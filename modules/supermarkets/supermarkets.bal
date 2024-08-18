import backend.connection;
import backend.db;
import backend.errors;

import ballerina/http;
import ballerina/persist;

public type SuperMarketNotFound record {|
    *http:NotFound;
    errors:ErrorDetails body;
|};

function createSuperMarketNotFound(int id) returns SuperMarketNotFound {
    return {
        body: {
            message: "SuperMarket not found",
            details: string `SuperMarket not found for the given id: ${id}`
        }
    };
}




public function getSupermarkets() returns db:Supermarket[]|error? {
    db:Client connection = connection:getConnection();
    stream<db:Supermarket, persist:Error?> supermarketStream = connection->/supermarkets.get();
    db:Supermarket[] supermarkets = check from db:Supermarket supermarket in supermarketStream
        select supermarket;

    return supermarkets;
}

public function getSupermarketById(int id) returns db:Supermarket|SuperMarketNotFound|error? {
    db:Client connection = connection:getConnection();
    db:Supermarket|persist:Error? supermarket = connection->/supermarkets/[id](db:Supermarket);
    if (supermarket is ()) {
        return createSuperMarketNotFound(id);
    }
    return supermarket;
}
