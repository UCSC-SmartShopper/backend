import backend.connection;
import backend.db;
import backend.utils;

import ballerina/persist;

// public type Product record {|
//     readonly int id;
//     string name;
//     string description;
//     float price;
//     string imageUrl;
// |};

type productQuery record {|
    int category;
    float price;
    string sortOrder;
    string searchText;
    int page;
    int _limit;
|};

public type ProductResponse record {|
    int count;
    boolean next;
    db:ProductWithRelations[] results;
|};

public function getProducts(
        string category,
        float price,
        string sortOrder,
        string searchText,
        int page,
        int _limit) 
    returns ProductResponse|persist:Error? {

    db:Client connection = connection:getConnection();
    stream<db:ProductWithRelations, persist:Error?> products = connection->/products.get();
    db:ProductWithRelations[] productList = check from db:ProductWithRelations product in products
        let string name = product.name ?: ""

        where
            (price == 0.0 || product.price == price) &&
            searchText == "" || name.toLowerAscii().includes(searchText.toLowerAscii())
        order by product.id ascending
        select product;

    // Sort the product list based on the sort order
    match sortOrder {
        "price_asc" => {
            productList = from db:ProductWithRelations p in productList
                order by p.price ascending
                select p;
        }
        "price_desc" => {
            productList = from db:ProductWithRelations p in productList
                order by p.price descending
                select p;
        }
    }

    // Pagination
    boolean hasNext = productList.length() > _limit * page;
    anydata[] paginateArray = utils:paginateArray(productList, page, _limit);
    productList = paginateArray.length() == 0 ? [] : <db:ProductWithRelations[]>paginateArray; // Type casting

    return {count: productList.length(), next: hasNext, results: productList};
}

public function getProductsById(int id) returns db:ProductWithRelations|error? {
    db:Client connection = connection:getConnection();

    db:ProductWithRelations|persist:Error? product = connection->/products/[id](db:ProductWithRelations);
    if product is persist:Error {
        return error("Product not found for id: " + id.toBalString());
    }
    return product;
}

