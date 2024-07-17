import backend.db;

import ballerina/persist;
import ballerina/time;

public final db:Client dbClient = check new ();

function getProducts() returns ProductResponse|persist:Error? {
    stream<Product, persist:Error?> products = dbClient->/products.get();
    Product[] productList = check from Product product in products
        select product;

    return {count: productList.length(), next: "null", results: productList};
}

function getProductsById(int id) returns db:Product|DataNotFound|error? {
    db:Product|persist:Error? product = dbClient->/products/[id](db:Product);
    if product is () {
        DataNotFound notFound = {
            body: {
                message: "User not found",
                details: string `User not found for the given id: ${id} `,
                timestamp: time:utcNow()
            }
        };
        return notFound;
    }
    return product;
}

