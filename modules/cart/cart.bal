
import ballerina/persist;
import ballerina/io;

public type CartItem record {|
    int productId;
    int supermarketId;
    int quantity;
    // Product product;
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

public function getCartItems(CartItem[] cartItems) returns CartItemResponse|persist:Error? {

    // stream<db:PriceListWithRelations, persist:Error?> prices = dbClient->/pricelists();
    // db:PriceListWithRelations[] priceList = check from db:PriceListWithRelations price in prices
    //     select price;
    io:println(cartItems);

    return {count: 1, next: "null", results: [{productId: 1, supermarketId: 1, quantity: 1}]};
}

public function test() returns CartItem[]|persist:Error? {
    // stream<db:PriceListWithRelations, persist:Error?> prices = dbClient->/pricelists();
    // db:PriceListWithRelations[] priceList = check from db:PriceListWithRelations price in prices
    //     select price;
    // io:println(cartItems);

    return [{productId: 1, supermarketId: 1, quantity: 1},
            {productId: 2, supermarketId: 1, quantity: 1}];
}
