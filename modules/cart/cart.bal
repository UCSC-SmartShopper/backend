import backend.connection;
import backend.db;

import ballerina/persist;
import ballerina/io;

public type CartItem record {|
    int id?;
    db:SupermarketItem supermarketItem;
    int quantity;
    int consumerId?;
|};

public type CartItemResponse record {|
    int count;
    string next;
    CartItem[] results;
|};

// This function is used to get all the carts from local storage
// Then it synced with the database
// It attach the Product to the CartItem

public function getCartItems(int consumerId) returns CartItemResponse|error {
    if (consumerId == -1) {
        return {count: 0, next: "null", results: []};
    }

    db:Client connection = connection:getConnection();

    stream<CartItem, persist:Error?> CartItemsStream = connection->/cartitems(whereClause = `"CartItem"."consumerId"=${consumerId}`);
    CartItem[] CartItems = check from CartItem CartItem in CartItemsStream
        order by CartItem.id descending
        select CartItem;

    return {count: CartItems.length(), next: "null", results: CartItems};
}

public function addCartItem(int consumerId, CartItem cartItem) returns db:CartItem|int|error {
    io:println(cartItem);
    if (consumerId == 0) {
        return error("Consumer not found");
    }

    db:Client connection = connection:getConnection();
    int cartItemId = cartItem.id ?: -1;

    // Create a new cart item if the cart item is not in the database
    if (cartItemId == -1) {
        db:CartItemInsert cartItemInsert = {
            supermarketitemId: cartItem.supermarketItem.id,
            quantity: cartItem.quantity,
            consumerId: consumerId
        };
        int[]|persist:Error result = connection->/cartitems.post([cartItemInsert]);

        if (result is persist:Error) {
            return error("Error while adding the cart item");
        }
        return result[0];
    }

    // Update the cart item if the cart item is already in the database
    db:CartItemUpdate cartItemUpdate = {
            supermarketitemId: cartItem.supermarketItem.id,
            quantity: cartItem.quantity,
            consumerId: consumerId
        };
    db:CartItem|persist:Error result = connection->/cartitems/[cartItemId].put(cartItemUpdate);
    if result is persist:Error {
        return error("Error while updating the cart item");
    }
    return result;
}

public function removeCartItem(int consumerId, int id) returns db:CartItem|error {
    if (consumerId == 0) {
        return error("Consumer not found");
    }

    db:Client connection = connection:getConnection();
    db:CartItem|persist:Error result = connection->/cartitems/[id].delete;
    if result is persist:Error {
        return error("Error while deleting the cart item");
    }
    return result;

}
