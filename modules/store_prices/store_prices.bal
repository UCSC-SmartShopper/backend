import backend.connection;
import backend.db;
import backend.errors;
// import backend.products;

import ballerina/http;
import ballerina/persist;
import ballerina/io;



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
    stream<db:SupermarketItem, persist:Error?> prices = connection->/supermarketitems(whereClause = `"SupermarketItem"."productId"= ${productId}`);
    db:SupermarketItem[] supermarketItem = check from db:SupermarketItem price in prices
        order by price.price
        select price;


    return {count: supermarketItem.length(), next: "null", results: supermarketItem};
}

public function getSupermarketItemById(int id) returns db:SupermarketItem|SupermarketItemNotFound {
    db:SupermarketItem|persist:Error supermarketItem = connection->/supermarketitems/[id].get(db:SupermarketItem);

    if (supermarketItem is persist:Error) {
        return createSupermarketItemNotFound(id);
    }
    return supermarketItem;
}


public function getSupermarketItemsBySupermarketId(int SupermarketId) returns SupermarketItemResponse|SupermarketItemNotFound|error {
    io:println("SupermarketId: ", SupermarketId);

    stream<db:SupermarketItem, persist:Error?> supermarketItemStream = connection->/supermarketitems(whereClause = `"SupermarketItem"."supermarketId"= ${SupermarketId}`);
    db:SupermarketItem[] supermarketitems = check from db:SupermarketItem item in supermarketItemStream
        select item;
    io:println("SupermarketItems: ", supermarketitems);

    return {
        count: supermarketitems.length(),
        next: "null",
        results: supermarketitems
    };
}



