import backend.db;
import backend.price_list;

import ballerina/io;
import ballerina/persist;

public type CartItem record {|
    int id?;
    int quantity;
    price_list:PriceList priceList;
    int consumerId?;
|};

public type CartItemRequest record {|
    CartItem[] cartItems;
|};

public type CartItemResponse record {|
    int count;
    string next;
    db:CartItemWithRelations[] results;
|};

// This function is used to get all the carts from local storage
// Then it synced with the database
// It attach the Product to the CartItem

public final db:Client dbClient = check new ();

public function getCartItems(CartItem[] localCartItems, int userId) returns db:CartItemWithRelations[]|error {

    map<db:CartItemWithRelations> finalCartItems = {};

    // get price lists from the database
    stream<db:CartItemWithRelations, persist:Error?> dbCartItemsSteam = dbClient->/cartitems(whereClause = ` "CartItem"."consumerId" = ${userId}`);
    db:CartItemWithRelations[] dbCartItems = check from db:CartItemWithRelations dbCartItem in dbCartItemsSteam
        select dbCartItem;

    io:println("dbCartItems 1");
    io:println(dbCartItems);

    // add the price lists to the final cart items
    foreach db:CartItemWithRelations dbCartItem in dbCartItems {
        finalCartItems[dbCartItem.id.toBalString()] = {quantity: dbCartItem.quantity, priceList: dbCartItem.priceList};
    }

    io:println("finalCartItems 2");
    io:println(finalCartItems);

    // get the cart items that are not in the database
    CartItem[] newCartItems = from CartItem cartItem in localCartItems
        where (finalCartItems[cartItem.id.toBalString()] == null)
        select cartItem;

    io:println("newCartItems 3");
    io:println(newCartItems);

    // save the new cart items to the database
    if (newCartItems.length() > 0) {
        db:CartItemInsert[] newDbCartItems = from CartItem cartItem in newCartItems
            select {pricelistId: cartItem.priceList.id, quantity: cartItem.quantity, consumerId: userId};

        int[]|persist:Error result = dbClient->/cartitems.post(newDbCartItems);
        if result is persist:Error {
            io:println(result);
        }
        io:println("newDbCartItems 4");
        io:println(newDbCartItems);
    }

    // get the final cart items from the database
    stream<db:CartItemWithRelations, persist:Error?> finalDbCartItemsStream = dbClient->/cartitems(whereClause = `"CartItem"."consumerId"=${userId}`);
    db:CartItemWithRelations[] finalDbCartItems = check from db:CartItemWithRelations dbCartItem in finalDbCartItemsStream
        select dbCartItem;

    io:println("finalDbCartItems 5");
    io:println(finalDbCartItems);

    return finalDbCartItems;

}

public function test() returns CartItem[]|persist:Error? {
    // stream<db:PriceListWithRelations, persist:Error?> prices = dbClient->/pricelists();
    // db:PriceListWithRelations[] priceList = check from db:PriceListWithRelations price in prices
    //     select price;
    io:println("hi");
    return [
        {
            "priceList": {
                "product": {
                    "id": 1,
                    "name": "Keells Marshmallow Assorted 70g",
                    "description": "KEELLS MARSHMALLOW ASSORTED 70G",
                    "price": 118,
                    "imageUrl": "https://essstr.blob.core.windows.net/essimg/350x/Small/Pic119557.jpg"
                },
                "supermarket": {
                    "id": 3,
                    "name": "Glow Mark",
                    "contactNo": "555-555-5555",
                    "logo": "https://glomark.lk/build/images/logo.9155b058.png",
                    "location": "Maharagama",
                    "address": "789 Oak St, Midtown",
                    "supermarketmanagerId": 5
                },
                "id": 3,
                "price": 15.25,
                "quantity": 150,
                "discountedTotal": 2287.5
            },
            "quantity": 1
        }
];

}
