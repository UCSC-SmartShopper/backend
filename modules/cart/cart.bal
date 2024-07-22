import backend.db;
import backend.price_list;

import ballerina/persist;
import ballerina/io;

public type CartItem record {|
    int quantity;
    price_list:PriceList priceList;
|};

public type CartItemRequest record {|
    CartItem[] cartItems;
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

public function getCartItems(CartItem[] cartItems) returns CartItemResponse|persist:Error? {
    // int userId = 6;

    // get price lists from the database
    // stream<price_list:PriceList, persist:Error?> databasePriceList = dbClient->/pricelists();

    // price_list:PriceList[] priceListsToAdd = check from price_list:PriceList priceList in databasePriceList
    //     // where (priceList in cartItems)
    //     select priceList;

    // stream<db:PriceListWithRelations, persist:Error?> prices = dbClient->/pricelists();
    // db:PriceListWithRelations[] priceList = check from db:PriceListWithRelations price in prices
    //     select price;

    return {count: 1, next: "null", results: []};
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
