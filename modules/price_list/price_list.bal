import backend.db;
import backend.errors;

import ballerina/http;
import ballerina/persist;
import ballerina/time;

public type PriceList record {|
    readonly int id;
    int productId;
    int supermarketId;
    float price;
    int quantity;
    float discountedTotal;
|};

public type PriceListResponse record {|
    int count;
    string next;
    db:PriceListWithRelations[] results;
|};

type PriceListNotFound record {|
    *http:NotFound;
    errors:ErrorDetails body;
|};

function createPriceListNotFound(int id) returns PriceListNotFound {
    return {
        body: {
            message: "Price List not found",
            details: string `Price List not found for the given id: ${id}`,
            timestamp: time:utcNow()
        }
    };
}

// -------------------------------------------------- Resource Functions --------------------------------------------------

public final db:Client dbClient = check new ();

public function getPriceLists() returns PriceListResponse|persist:Error? {
    stream<db:PriceListWithRelations, persist:Error?> prices = dbClient->/pricelists();
    db:PriceListWithRelations[] priceList = check from db:PriceListWithRelations price in prices
        select price;

    return {count: priceList.length(), next: "null", results: priceList};
}

public function getPriceListsByProductId(int productId) returns PriceListResponse|persist:Error? {
    stream<db:PriceListWithRelations, persist:Error?> prices = dbClient->/pricelists(whereClause = `"PriceList"."productId"=${productId}`);
    db:PriceListWithRelations[] priceList = check from db:PriceListWithRelations price in prices
        select price;

    return {count: priceList.length(), next: "null", results: priceList};
}

