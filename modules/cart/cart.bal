import backend.connection;
import backend.db;

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

public function getCartItems(int userId) returns CartItemResponse|error {
    db:Client connection = connection:getConnection();

    stream<CartItem, persist:Error?> CartItemsStream = connection->/cartitems(whereClause = `"CartItem"."consumerId"=${userId}`);
    CartItem[] CartItems = check from CartItem CartItem in CartItemsStream
        select CartItem;

    return {count: CartItems.length(), next: "null", results: CartItems};
}

public function saveCartItems(CartItem[] cartItems) returns CartItem[]|persist:Error {
    db:Client connection = connection:getConnection();
    int id = 6;

    // remove all the cart items from the database
    _ = check connection->executeNativeSQL(`DELETE FROM "CartItem" WHERE "consumerId" = ${id} `);

    // then add the new cart items to the database
    db:CartItemInsert[] cartItemInserts = from CartItem cartItem in cartItems
        select {
            supermarketitemId: cartItem.supermarketItem.id,
            quantity: cartItem.quantity,
            consumerId: id
        };

    int[]|persist:Error result = connection->/cartitems.post(cartItemInserts);

    if result is persist:Error {
        return result;
    }

    // get all the cart items from the database
    stream<CartItem, persist:Error?> insertedCartItemSteam = connection->/cartitems(whereClause = `"CartItem"."consumerId"=${id}`);
    CartItem[] insertedCartItems = check from CartItem CartItem in insertedCartItemSteam
        select CartItem;

    return insertedCartItems;

}
