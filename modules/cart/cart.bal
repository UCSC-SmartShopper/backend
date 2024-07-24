import backend.db;

import ballerina/io;
import ballerina/persist;

public type CartItem record {|
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

public function getCartItems(CartItem[] localCartItems, int userId) returns db:CartItemWithRelations[]|error {

    db:CartItem[] toUpdate = [];
    db:CartItemInsert[] toInsert = [];

    // get price lists from the database
    stream<db:CartItem, persist:Error?> dbCartItemsSteam = dbClient->/cartitems(whereClause = ` "CartItem"."consumerId" = ${userId}`);
    map<db:CartItem> dbCartItemsMap = check map from db:CartItem dbCartItem in dbCartItemsSteam
        select [dbCartItem.supermarketitemId.toBalString(), dbCartItem];

    foreach CartItem i in localCartItems {
        string key = i.supermarketItem.id.toBalString();
        if (dbCartItemsMap[key] == null) {
            toInsert.push({supermarketitemId: i.supermarketItem.id, quantity: i.quantity, consumerId: userId});
        } else {
            toUpdate.push({id: i.supermarketItem.id, supermarketitemId: i.supermarketItem.id, quantity: i.quantity, consumerId: userId});
        }
    }

    // insert the new cart items to the database
    if (toInsert.length() > 0) {
        int[]|persist:Error result = dbClient->/cartitems.post(toInsert);
        if result is persist:Error {
            io:println(result);
        }
    }

    // update the existing cart items in the database
    if (toUpdate.length() > 0) {
        foreach db:CartItem item in toUpdate {
            db:CartItem|persist:Error result = dbClient->/cartitems/[item.id].put({});
            if result is persist:Error {
                io:println(result);
            }
        }
    }

    // get the final cart items from the database
    stream<CartItem, persist:Error?> finalDbCartItemsStream = dbClient->/cartitems(whereClause = `"CartItem"."consumerId"=${userId}`);
    CartItem[] finalDbCartItems = check from CartItem dbCartItem in finalDbCartItemsStream
        select dbCartItem;

    return finalDbCartItems;

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
