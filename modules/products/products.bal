import backend.db;
import backend.errors;

import ballerina/http;
import ballerina/persist;
import ballerina/time;
import backend.connection;

public type Product record {|
    readonly int id;
    string name;
    string description;
    float price;
    string imageUrl;
|};

public type ProductResponse record {|
    int count;
    string next;
    Product[] results;
|};

type ProductNotFound record {|
    *http:NotFound;
    errors:ErrorDetails body;
|};

function createProductNotFound(int id) returns ProductNotFound {
    return {
        body: {
            message: "Product not found",
            details: string `Product not found for the given id: ${id}`,
            timestamp: time:utcNow()
        }
    };
}


public function getProducts() returns ProductResponse|persist:Error? {
    db:Client connection = connection:getConnection();
    stream<Product, persist:Error?> products = connection->/products.get();
    Product[] productList = check from Product product in products
        select product;

    return {count: productList.length(), next: "null", results: productList};
}

public function getProductsById(int id) returns Product|ProductNotFound|error? {
    db:Client connection = connection:getConnection();

    Product|persist:Error? product = connection->/products/[id](Product);
    if product is persist:Error {
        return createProductNotFound(id);
    }
    return product;
}


