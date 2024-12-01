import backend.connection;
import backend.db;

import ballerina/persist;
import backend.activity;

// Non optimized version of the cart item
public type CartItem record {|
    *db:CartItem;
    db:SupermarketItem supermarketItem;
|};

// public type CartItemInsert record {|
//     int supermarketitemId;
//     int quantity;
// |};

public type CartItemResponse record {|
    int count;
    string next;
    db:CartItemWithRelations[] results;
|};

public function getCartItems(int consumerId) returns CartItemResponse|error {
    if (consumerId == -1) {
        return {count: 0, next: "null", results: []};
    }

    db:Client connection = connection:getConnection();
    stream<db:CartItemWithRelations, persist:Error?> CartItemsStream = connection->/cartitems();
    db:CartItemWithRelations[] CartItems = check from db:CartItemWithRelations CartItem in CartItemsStream
        where CartItem.consumerId == consumerId && CartItem.orderId == -1
        order by CartItem.id descending
        select CartItem;

    return {count: CartItems.length(), next: "null", results: CartItems};
}

public function addCartItem(int consumerId, db:CartItemInsert cartItem) returns db:CartItem|int|error {
    if (consumerId == 0) {
        return error("Consumer not found");
    }

    db:Client connection = connection:getConnection();
    db:CartItemInsert cartItemInsert = {
        supermarketitemId: cartItem.supermarketitemId,
        quantity: cartItem.quantity,
        consumerId: consumerId,
        productId: cartItem.productId,
        orderId: -1
    };
    int[]|persist:Error result = connection->/cartitems.post([cartItemInsert]);

    if (result is persist:Error) {
        return result;
    }
    //create activity
    _  = start activity:createActivity(consumerId, "Added item to cart.");
    return result[0];
}

public function updateCartItem(int consumerId, db:CartItem cartItem) returns db:CartItem|int|error {
    if (consumerId == 0) {
        return error("Consumer not found");
    }

    db:CartItemUpdate cartItemUpdate = {
        supermarketitemId: cartItem.supermarketitemId,
        quantity: cartItem.quantity
    };

    db:Client connection = connection:getConnection();
    db:CartItem|persist:Error result = connection->/cartitems/[cartItem.id].put(cartItemUpdate);
    if result is persist:Error {
        return error("Error while updating the cart item");
    }
    //create activity
    _  = start activity:createActivity(consumerId, "Updated cart item.");
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
    //create activity
    _  = start activity:createActivity(consumerId, "Deleted cart item.");
    return result;

}
