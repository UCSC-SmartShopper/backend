import backend.db;

import ballerina/io;
import ballerina/persist;

public type CartItem record {|
    int id?;
    db:SupermarketItem supermarketItem;
    int quantity;
|};

public type CartItemResponse record {|
    int count;
    string next;
    CartItem[] results;
|};

// This function is used to get all the carts from local storage
// Then it synced with the database
// It attach the Product to the CartItem

public final db:Client dbClient = check new ();

public function getCartItems(int userId) returns CartItemResponse|error {
    stream<CartItem, persist:Error?> CartItemsStream = dbClient->/cartitems(whereClause = `"CartItem"."consumerId"=${userId}`);
    CartItem[] CartItems = check from CartItem CartItem in CartItemsStream
        select CartItem;

    return {count: CartItems.length(), next: "null", results: CartItems};
}

public function test() returns CartItem[]|persist:Error? {
    io:println("hi");
    return [
        {
            "supermarketItem": {
                "id": 2,
                "productId": 1,
                "supermarketId": 2,
                "price": 5.49,
                "discount": 1098,
                "availableQuantity": 200
            },
            "quantity": 1
        }
];

}
