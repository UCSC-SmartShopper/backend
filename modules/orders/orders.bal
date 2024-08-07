import backend.auth;
import backend.cart;
import backend.connection;
import backend.db;
import backend.errors;

import ballerina/http;
import ballerina/io;
import ballerina/persist;
import ballerina/time;

public type CartToOrderRequest record {
    int consumerId;
    string shippingAddress;
    string shippingMethod;
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

public function getOrders(auth:User user) returns OrderResponse|error {
    db:Client connection = connection:getConnection();
    db:OrderWithRelations[] orders = [];

    stream<db:OrderWithRelations, persist:Error?> orderStream = connection->/orders.get();
    db:OrderWithRelations[] orderList = check from db:OrderWithRelations _order in orderStream
        order by _order.id descending
        select _order;

    if (user.role == "supermarket") {
        db:OrderWithRelations[] filteredOrders = from db:OrderWithRelations _order in orderList
            let db:SupermarketOrderOptionalized[] supermarketOrders = _order.supermarketorder ?: []
            where supermarketOrders.some((i) => i.supermarketId == user.supermarketId)
            select _order;

        orders = filteredOrders;

    } else if (user.role == "consumer") {
        db:OrderWithRelations[] userOrders = from db:OrderWithRelations _order in orderList
            where _order.consumerId == user.id
            select _order;

        orders = userOrders;
    }

    return {count: orders.length(), next: "null", results: orders};
}

public function getOrdersById(int id) returns db:OrderWithRelations|OrderNotFound|error? {
    db:Client connection = connection:getConnection();
    db:OrderWithRelations|persist:Error? order2 = connection->/orders/[id](db:OrderWithRelations);
    io:println(order2);
    if order2 is persist:Error {
        return createOrderNotFound(id);
    }
    return order2;
}

public function cartToOrder(CartToOrderRequest cartToOrderRequest) returns db:OrderWithRelations|persist:Error|error {
    int consumerId = cartToOrderRequest.consumerId;
    string shippingAddress = cartToOrderRequest.shippingAddress;
    string shippingMethod = cartToOrderRequest.shippingMethod;

    db:Client connection = connection:getConnection();
    stream<cart:CartItem, persist:Error?> cartItemsStream = connection->/cartitems();
    cart:CartItem[] cartItems = check from cart:CartItem cartItem in cartItemsStream
        where cartItem.consumerId == consumerId
        select cartItem;

    map<int> supermarketIdMap = {};
    foreach cart:CartItem item in cartItems {
        supermarketIdMap[item.supermarketItem.supermarketId.toBalString()] = item.supermarketItem.supermarketId;
    }
    int[] supermarketIdList = supermarketIdMap.toArray();

    // -------------------------- Create the Order --------------------------
    db:OrderInsert orderInsert = {
        consumerId: consumerId,
        status: "ToPay",
        shippingAddress: shippingAddress,
        shippingMethod: shippingMethod,
        location: "6.8657635,79.8571086",
        orderPlacedOn: time:utcToCivil(time:utcNow())
    };
    int[]|persist:Error result = connection->/orders.post([orderInsert]);

    if result is persist:Error {
        return result;
    }

    int orderId = result[0];

    // -------------------------- Create Supermarker Orders --------------------------
    db:SupermarketOrderInsert[] supermarketOrderInsert = from int supermarketId in supermarketIdList
        select {
            status: "Processing",
            qrCode: "",
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
                supermarketItemId: cartItem.supermarketItem.id,
                productId: cartItem.supermarketItem.productId,
                quantity: cartItem.quantity,
                price: cartItem.supermarketItem.price,
                _orderId: orderId
            };

    int[]|persist:Error orderItemResult = connection->/orderitems.post(orderItemInserts);

    io:println(orderItemInserts);
    if orderItemResult is persist:Error {
        return orderItemResult;
    }

    // Remove all the cart items of the consumer from the database
    _ = check connection->executeNativeSQL(`DELETE FROM "CartItem" WHERE "consumerId" = ${consumerId}`);

    return {id: orderId};
}
