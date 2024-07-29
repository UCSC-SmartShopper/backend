import backend.connection;
import backend.db;
import backend.errors;

import ballerina/http;
import ballerina/persist;
import ballerina/time;
import backend.cart;

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

public function cartToOrder(int consumerID) returns db:OrderWithRelations|persist:Error|error {
    db:Client connection = connection:getConnection();
    stream< cart:CartItem, persist:Error?> cartItemsStream = connection->/cartitems(whereClause = `"CartItem"."cmonsumerId"=${consumerID}`);
    cart:CartItem[] cartItems = check from cart:CartItem cartItem in cartItemsStream
        select cartItem;

    db:OrderInsert orderInsert = {
        consumerId: consumerID,
        shippingAddress: "",
        shippingMethod: "Standard",
        status: "Pending"
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

    int[]|persist:Error orderItemResult = connection->/orderitems.post(orderItemInserts);

    if orderItemResult is persist:Error {
        return orderItemResult;
    }

    // Remove all the cart items for the consumer from the database
    _ = check connection->executeNativeSQL(`DELETE FROM "CartItem" WHERE "consumerId" = ${consumerID}`);

    return {id: orderId};
}
