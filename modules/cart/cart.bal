import backend.connection;
import backend.db;

import ballerina/persist;

public type CartItem record {|
    int id;
    db:SupermarketItem supermarketItem;
    int quantity;
    int consumerId?;
|};

public type CartItemInsert record {|
    int supermarketitemId;
    int quantity;
|};

public type CartItemResponse record {|
    int count;
    string next;
    CartItem[] results;
|};

public function getCartItems(int consumerId) returns CartItemResponse|error {
    if (consumerId == -1) {
        return {count: 0, next: "null", results: []};
    }

    db:Client connection = connection:getConnection();
    stream<CartItem, persist:Error?> CartItemsStream = connection->/cartitems();
    CartItem[] CartItems = check from CartItem CartItem in CartItemsStream
        where CartItem.consumerId == consumerId
        order by CartItem.id descending
        select CartItem;

    return {count: CartItems.length(), next: "null", results: CartItems};
}

public function addCartItem(int consumerId, CartItemInsert cartItem) returns db:CartItem|int|error {
    if (consumerId == 0) {
        return error("Consumer not found");
    }

    db:Client connection = connection:getConnection();
    db:CartItemInsert cartItemInsert = {
        supermarketitemId: cartItem.supermarketitemId,
        quantity: cartItem.quantity,
        consumerId: consumerId
    };
    int[]|persist:Error result = connection->/cartitems.post([cartItemInsert]);

    if (result is persist:Error) {
        return error("Error while adding the cart item");
    }
    return result[0];
}

public function updateCartItem(int consumerId, CartItem cartItem) returns db:CartItem|int|error {
    if (consumerId == 0) {
        return error("Consumer not found");
    }

    db:CartItemUpdate cartItemUpdate = {
            supermarketitemId: cartItem.supermarketItem.id,
            quantity: cartItem.quantity,
            consumerId: consumerId
        };

    db:Client connection = connection:getConnection();
    db:CartItem|persist:Error result = connection->/cartitems/[cartItem.id].put(cartItemUpdate);
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
