import backend.connection;
import backend.db;
import backend.utils;

import ballerina/persist;

public type Product record {|
    readonly int id;
    string name;
    string description;
    float price;
    string imageUrl;
|};

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
    Product[] results;
|};

public function getProducts(
        string category,
        float price,
        string sortOrder,
        string searchText,
        int page,
        int _limit) returns ProductResponse|persist:Error? {

    db:Client connection = connection:getConnection();
    stream<Product, persist:Error?> products = connection->/products.get();
    Product[] productList = check from Product product in products
        where
            (price == 0.0 || product.price == price) &&
            searchText == "" || product.name.toLowerAscii().includes(searchText.toLowerAscii())
        order by product.id ascending
        select product;

    // Sort the product list based on the sort order
    match sortOrder {
        "price_asc" => {
            productList = from Product p in productList
                order by p.price ascending
                select p;
        }
        "price_desc" => {
            productList = from Product p in productList
                order by p.price descending
                select p;
        }
    }

    // Pagination
    boolean hasNext = productList.length() > _limit * page;
    anydata[] paginateArray = utils:paginateArray(productList, page, _limit);
    productList = paginateArray.length() == 0 ? [] : <Product[]>paginateArray; // Type casting

    return {count: productList.length(), next: hasNext, results: productList};
}

public function getProductsById(int id) returns Product|error? {
    db:Client connection = connection:getConnection();

    Product|persist:Error? product = connection->/products/[id](Product);
    if product is persist:Error {
        return error("Product not found for id: " + id.toBalString());
    }
    return product;
}

