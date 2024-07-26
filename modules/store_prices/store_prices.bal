import backend.connection;
import backend.db;
import backend.errors;

import ballerina/http;
import ballerina/io;
import ballerina/persist;

// public type Supermarket record {|
//     readonly int id;
//     string name;
//     string contactNo;
//     string logo;
//     string location;
//     string address;
//     int supermarketmanagerId;

// |};

public type SupermarketItemResponse record {|
    int count;
    string next;
    db:SupermarketItem[] results;
|};

public type SupermarketItemNotFound record {|
    *http:NotFound;
    errors:ErrorDetails body;
|};

function createSupermarketItemNotFound(int id) returns SupermarketItemNotFound {
    return {
        body: {
            message: "Price List not found",
            details: string `Price List not found for the given id: ${id}`
}
    };
}

// -------------------------------------------------- Resource Functions --------------------------------------------------

db:Client connection = connection:getConnection();

public function getSupermarketItemByProductId(int productId) returns SupermarketItemResponse|SupermarketItemNotFound|error {
    io:println("productId: ", productId);
    stream<db:SupermarketItem, persist:Error?> prices = connection->/supermarketitems(whereClause = `"SupermarketItem"."productId"= ${productId}`);
    db:SupermarketItem[] supermarketItem = check from db:SupermarketItem price in prices
        select price;

    io:println("supermarketItem: ", supermarketItem);

    return {count: supermarketItem.length(), next: "null", results: supermarketItem};
}

public function getSupermarketItemById(int id) returns db:SupermarketItem|SupermarketItemNotFound {
    db:SupermarketItem|persist:Error supermarketItem = connection->/supermarketitems/[id].get(db:SupermarketItem);

    if (supermarketItem is persist:Error) {
        return createSupermarketItemNotFound(id);
    }
    return supermarketItem;
}
