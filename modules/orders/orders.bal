import backend.auth;
import backend.cart;
import backend.connection;
import backend.db;
import backend.errors;
import backend.locations;
import backend.supermarkets;
import backend.utils;

import ballerina/http;
import ballerina/io;
import ballerina/persist;
import ballerina/time;

public type CartToOrderRequest record {
    int consumerId;
    string shippingLocation;
    string shippingAddress;
    string shippingMethod;
};

public type OrderReadyRequest record {
    int supermarketOrderId;
};

public type OrderResponse record {|
    int count;
    string next;
    db:OrderWithRelations[] results;
|};

public type OrderNotFound record {|
    *http:NotFound;
    errors:ErrorDetails body;
|};

function createOrderNotFound(int id) returns OrderNotFound {
    return {
        body: {
            message: "Order not found",
            details: string `Order not found for the given id: ${id}`,
            timestamp: time:utcNow()
        }
    };
}

public function getOrders(auth:User user, int supermarketId) returns OrderResponse|error {
    db:Client connection = connection:getConnection();
    db:OrderWithRelations[] orders = [];

    stream<db:OrderWithRelations, persist:Error?> orderStream = connection->/orders.get();
    db:OrderWithRelations[] orderList = check from db:OrderWithRelations _order in orderStream
        order by _order.id descending
        select _order;

    if (user.role == "Supermarket Manager") {
        db:OrderWithRelations[] filteredOrders = from db:OrderWithRelations _order in orderList
            let db:SupermarketOrderOptionalized[] supermarketOrders = _order.supermarketOrders ?: []
            where supermarketOrders.some((i) => i.supermarketId == user.supermarketId)
            select _order;

        orders = filteredOrders;

    } else if (user.role == "Consumer") {
        db:OrderWithRelations[] userOrders = from db:OrderWithRelations _order in orderList
            where _order.consumerId == user.consumerId
            order by _order.id descending
            select _order;

        orders = userOrders;

    } else if (user.role == "Admin") {
        orders = from db:OrderWithRelations _order in orderList
            let db:SupermarketOrderOptionalized[] supermarketOrders = _order.supermarketOrders ?: []
            where supermarketOrders.some((i) => i.supermarketId == supermarketId)
            select _order;
    }

    return {count: orders.length(), next: "null", results: orders};
}

public function getOrdersById(int id) returns db:OrderWithRelations|OrderNotFound|error? {
    db:Client connection = connection:getConnection();
    db:OrderWithRelations|persist:Error? order2 = connection->/orders/[id](db:OrderWithRelations);

    if order2 is persist:Error {
        return createOrderNotFound(id);
    }
    return order2;
}

public function cartToOrder(CartToOrderRequest cartToOrderRequest) returns int|persist:Error|error {

    int consumerId = cartToOrderRequest.consumerId;
    string shippingAddress = cartToOrderRequest.shippingAddress;
    string shippingLocation = cartToOrderRequest.shippingLocation;
    string shippingMethod = cartToOrderRequest.shippingMethod;

    db:Client connection = connection:getConnection();
    stream<cart:CartItem, persist:Error?> cartItemsStream = connection->/cartitems();
    cart:CartItem[] cartItems = check from cart:CartItem cartItem in cartItemsStream
        where cartItem.consumerId == consumerId
        select cartItem;

    // Calculate the total price of the order and get the supermarket ids
    float subTotal = 0.0;
    map<int> supermarketIdMap = {};
    foreach cart:CartItem item in cartItems {
        supermarketIdMap[item.supermarketItem.supermarketId.toBalString()] = item.supermarketItem.supermarketId;
        subTotal = subTotal + (item.supermarketItem.price * item.quantity);
    }

    // ------------------ Calculate the delivery fee ------------------
    float deliveryFee = 0.0;
    if (shippingMethod == "Home Delivery") {
        supermarkets:SupermarketResponse supermarketList = check supermarkets:get_supermarkets();

        string[] supermarketLocations = from var supermarket in supermarketList.results
            where supermarketIdMap.keys().indexOf(supermarket.id.toString()) > -1 && supermarket.location != ""
            select supermarket.location ?: "";

        deliveryFee = check locations:get_delivery_cost(supermarketLocations, shippingLocation);
    }

    // -------------------------- Create the Order --------------------------
    db:OrderInsert orderInsert = {
        consumerId: consumerId,
        status: "ToPay",
        shippingAddress: shippingAddress,
        shippingLocation: shippingLocation,
        shippingMethod: shippingMethod,

        subTotal: subTotal,
        deliveryFee: deliveryFee,
        totalCost: subTotal + deliveryFee,
        
        orderPlacedOn: utils:getCurrentTime()
    };
    int[]|persist:Error result = connection->/orders.post([orderInsert]);

    if result is persist:Error {
        return result;
    }

    int orderId = result[0];

    // Update all the cart items of the consumer from the database whre orderId = -1
    _ = check connection->executeNativeSQL(`UPDATE "CartItem" SET "orderId" = ${orderId} WHERE "consumerId" = ${consumerId} AND "orderId" = -1`);

    return orderId;
}

// When the consumer pays for the order
// Payment Resource will call this function
// This function will create supermarket orders for each supermarket
// This function will create supermarket orders for each supermarket
// and update the order status to Processing
public function order_payment(int orderId) returns error? {

    // Cart Items for this order
    db:Client connection = connection:getConnection();
    stream<cart:CartItem, persist:Error?> cartItemsStream = connection->/cartitems();
    cart:CartItem[] cartItems = check from cart:CartItem cartItem in cartItemsStream
        where cartItem.orderId == orderId
        select cartItem;

    // Get the supermarket ids belongs to the cart items
    map<int> supermarketIdMap = {};
    foreach cart:CartItem item in cartItems {
        supermarketIdMap[item.supermarketItem.supermarketId.toBalString()] = item.supermarketItem.supermarketId;
    }
    int[] supermarketIdList = supermarketIdMap.toArray();

    // -------------------------- Create Supermarker Orders --------------------------
    db:SupermarketOrderInsert[] supermarketOrderInsert = from int supermarketId in supermarketIdList
        select {
            status: "Processing",
            qrCode: "https://support.thinkific.com/hc/article_attachments/360042081334/5d37325ea1ff6.png",
            _orderId: orderId,
            supermarketId: supermarketId
        };

    int[]|persist:Error supermarketOrderResult = connection->/supermarketorders.post(supermarketOrderInsert);
    if supermarketOrderResult is persist:Error {
        return supermarketOrderResult;
    }

    // -------------------------- Create the Order Items --------------------------
    db:OrderItemsInsert[] orderItemInserts = from cart:CartItem cartItem in cartItems
        select {
            supermarketId: cartItem.supermarketItem.supermarketId,
            productId: cartItem.supermarketItem.productId,
            quantity: cartItem.quantity,
            price: cartItem.supermarketItem.price,
            _orderId: orderId
        };

    int[]|persist:Error orderItemResult = connection->/orderitems.post(orderItemInserts);

    if orderItemResult is persist:Error {
        return orderItemResult;
    }

    // Update the order status to Processing
    db:OrderUpdate orderUpdate = {
        status: "Processing"
    };
    _ = check connection->/orders/[orderId].put(orderUpdate);
}

public function supermarket_order_ready(auth:User user, OrderReadyRequest orderReadyRequest) returns db:SupermarketOrderWithRelations|OrderNotFound|http:Unauthorized|error {
    int supermarketId = user.supermarketId ?: -1;
    int supermarketOrderId = orderReadyRequest.supermarketOrderId;

    db:Client connection = connection:getConnection();
    db:SupermarketOrderWithRelations|persist:Error supermarketOrder = connection->/supermarketorders/[supermarketOrderId](db:SupermarketOrderWithRelations);

    if supermarketOrder is persist:Error {
        return createOrderNotFound(supermarketOrderId);
    }

    if (supermarketOrder.supermarketId != supermarketId) {
        return http:UNAUTHORIZED;
    }

    db:SupermarketOrderUpdate supermarketOrderUpdate = {
        status: "Ready"
    };

    db:SupermarketOrderWithRelations|persist:Error updatedSupermarketOrder = connection->/supermarketorders/[supermarketOrderId].put(supermarketOrderUpdate);

    if updatedSupermarketOrder is persist:Error {
        return error("Error updating the supermarket order");
    }

    // This function will update the order status to Prepared if all the supermarket orders are ready
    _ = start update_order_status_to_prepared(updatedSupermarketOrder._orderId ?: -1);

    return updatedSupermarketOrder;
}

// This function will update the order status to Prepared if all the supermarket orders are ready
function update_order_status_to_prepared(int orderId) returns error? {
    do {
        if (orderId != -1) {

            db:Client connection = connection:getConnection();
            db:OrderWithRelations _order = check connection->/orders/[orderId]();

            db:SupermarketOrderOptionalized[] superMarketOrders = _order.supermarketOrders ?: [];

            if superMarketOrders.every((i) => i.status == "Ready") && _order.status == "Processing" {
                db:OrderUpdate orderUpdate = {
                    status: "Prepared"
                };

                // Update the order status to Prepared
                _ = check connection->/orders/[orderId].put(orderUpdate);

                // Get Supermarket Ids
                int[] supermarketIds = from db:SupermarketOrderOptionalized supermarketOrder in superMarketOrders
                    select supermarketOrder.supermarketId ?: -1;

                locations:OptimizedRoute optimizedRoute = check locations:getOptimizedRoute(supermarketIds, _order.shippingLocation ?: "");

                // Create an opportunity
                db:OpportunityInsert opportunityInsert = {
                    totalDistance: optimizedRoute.totalDistance,
                    tripCost: optimizedRoute.deliveryCost - 100,
                    consumerId: _order.consumerId ?: -1,
                    deliveryCost: optimizedRoute.deliveryCost,

                    startLocation: _order.shippingLocation ?: "",
                    deliveryLocation: _order.shippingAddress ?: "",
                    
                    status: "Pending",
                    _orderId: orderId,
                    orderPlacedOn: _order.orderPlacedOn ?: utils:getCurrentTime(),
                    driverId: -1
                };

                _ = check connection->/opportunities.post([opportunityInsert]);
            }
        }
    } on fail var e {
        io:println(e);
    }
}
