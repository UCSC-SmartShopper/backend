import backend.cart;
import backend.connection;
import backend.db;
import backend.errors;

import ballerina/http;
import ballerina/io;
import ballerina/persist;
import ballerina/time;

public type CartToOrder record {
    int consumerId;
    string shippingAddress;
    string shippingMethod;
};

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

public function getOrders() returns db:OrderWithRelations[]|error {
    db:Client connection = connection:getConnection();

    stream<db:OrderWithRelations, persist:Error?> orders = connection->/orders.get();
    db:OrderWithRelations[] orderList = check from db:OrderWithRelations order1 in orders
        select order1;

    return orderList;
}

public function getOrdersById(int id) returns db:OrderWithRelations|OrderNotFound|error? {
    db:Client connection = connection:getConnection();
    db:OrderWithRelations|persist:Error? order2 = connection->/orders/[id](db:OrderWithRelations);
    if order2 is persist:Error {
        return createOrderNotFound(id);
    }
    return order2;
}

public function cartToOrder(CartToOrder cartToOrder) returns db:OrderWithRelations|persist:Error|error {
    int consumerId = cartToOrder.consumerId;
    string shippingAddress = cartToOrder.shippingAddress;
    string shippingMethod = cartToOrder.shippingMethod;
    time:Utc utc = time:utcNow();

    db:Client connection = connection:getConnection();
    stream<cart:CartItem, persist:Error?> cartItemsStream = connection->/cartitems();
    cart:CartItem[] cartItems = check from cart:CartItem cartItem in cartItemsStream
        where cartItem.consumerId == consumerId
        select cartItem;
    
    string supermarketIdList = "";
    foreach cart:CartItem cartItem in cartItems {
        if supermarketIdList != "" {
            supermarketIdList += ",";
        }
        supermarketIdList += cartItem.supermarketItem.id.toString();
    }

    db:OrderInsert orderInsert = {
        consumerId: consumerId,
        status: "ToPay",
        shippingAddress: shippingAddress,
        shippingMethod: shippingMethod,
        location: "6.8657635,79.8571086",
        supermarketIdList: supermarketIdList,
        startDate: utc
    };
    int[]|persist:Error result = connection->/orders.post([orderInsert]);

    if result is persist:Error {
        return result;
    }

    int orderId = result[0];

    db:OrderItemsInsert[] orderItemInserts = from cart:CartItem cartItem in cartItems
        select {
            supermarketItemId: cartItem.supermarketItem.id,
            productId: cartItem.supermarketItem.productId,
            quantity: cartItem.quantity,
            price: cartItem.supermarketItem.price,
            _orderId: orderId
        };

    io:println(1);
    int[]|persist:Error orderItemResult = connection->/orderitems.post(orderItemInserts);

    io:println(orderItemInserts);
    if orderItemResult is persist:Error {
        return orderItemResult;
    }
    io:println(2);

    // Remove all the cart items for the consumer from the database
    _ = check connection->executeNativeSQL(`DELETE FROM "CartItem" WHERE "consumerId" = ${consumerId}`);
    io:println(3);

    return {id: orderId};
}
