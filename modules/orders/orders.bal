import backend.db;
import backend.errors;

import ballerina/http;
// import ballerina/persist;
import ballerina/time;

public type Order record {|
    readonly int id;
|};

public type OrderResponse record {|
    int count;
    string next;
    Order[] results;
|};

type OrderNotFound record {|
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

public final db:Client dbClient = check new ();

// public function getOrders() returns OrderResponse|persist:Error? {
//     stream<Order, persist:Error?> Orders = dbClient->/orders.get();
//     Order[] OrderList = check from Order Order in Orders
//         select Order;

//     return {count: OrderList.length(), next: "null", results: OrderList};
// }

// public function getOrdersById(int id) returns Order|OrderNotFound|error? {
//     Order|persist:Error? Order = dbClient->/orders/[id](Order);
//     if Order is persist:Error {
//         return createOrderNotFound(id);
//     }
//     return Order;
// }

