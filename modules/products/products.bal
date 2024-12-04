import backend.cache_module;
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
    string price;
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

cache_module:ProductCache productCache = new ();

public function getProducts(
        string category,
        string price,
        string sortOrder,
        string searchText,
        int page,
        int _limit)
    returns ProductResponse|error {

    db:ProductWithRelations[] products = check productCache.get("products", getAllProducts);
    // db:ProductWithRelations[] products;

    // if (cachedProducts is error) {
    //     products = check getAllProducts();

    // } else {
    //     products = cachedProducts;

    //     if (!cacheManager.isValid("productCache")) {
    //         _ = start getAllProducts();
    //     }

    // }

    // stream<db:ProductWithRelations, persist:Error?> products = connection->/products.get();
    db:ProductWithRelations[] productList = from db:ProductWithRelations product in products
        let string name = product.name ?: ""

        where
            (category == "" || category == "All Categories" || product.category == category) &&  // Filter by category
            (searchText == "" || name.toLowerAscii().includes(searchText.toLowerAscii())) // Filter by search text
        select product;

    // Filter by price range
    map<float[]> priceRanges = {
        "Lower than Rs 250": [0.00, 250.00],
        "Rs 250 - Rs 500": [250.00, 500.00],
        "Rs 500 - Rs 1000": [500.00, 1000.00],
        "Rs 1000 - Rs 2000": [1000.00, 2000.00],
        "Rs 2000 - Rs 5000": [2000.00, 5000.00],
        "More than Rs 5000": [5000.00, 100000.00]
    };

    if (priceRanges.hasKey(price)) {
        float[] range = priceRanges[price] ?: [0.00, 100000.00];
        productList = from db:ProductWithRelations p in productList

            let float originalPrice = p.price ?: 99999.00
            let db:SupermarketItemOptionalized[] items = p.supermarketItems ?: []
            let float[] prices = items.map((item) => item.price ?: 99999.00)
            let float minVal = float:min(float:min(...prices), originalPrice)

            where minVal >= range[0] && minVal <= range[1]
            select p;
    }

    // Sort the product list based on the sort order
    match sortOrder {
        "Oldest" => {
            productList = from db:ProductWithRelations p in productList
                order by p.id ascending
                select p;
        }
        "Price: Low to High" => {
            productList = from db:ProductWithRelations p in productList

                let float originalPrice = p.price ?: 99999.00
                let db:SupermarketItemOptionalized[] items = p.supermarketItems ?: []
                let float[] prices = items.map((item) => item.price ?: 99999.00)
                let float minVal = float:min(float:min(...prices), originalPrice)

                order by minVal ascending
                select p;
        }
        "Price: High to Low" => {
            productList = from db:ProductWithRelations p in productList

                let float originalPrice = p.price ?: 99999.00
                let db:SupermarketItemOptionalized[] items = p.supermarketItems ?: []
                let float[] prices = items.map((item) => item.price ?: 99999.00)
                let float minVal = float:min(float:min(...prices), originalPrice)

                order by minVal descending
                select p;
        }
        _ => {
            productList = from db:ProductWithRelations p in productList
                // FIXME: Default sort order
                order by p.id ascending
                select p;
        }
    }

    // Pagination
    // boolean hasNext = productList.length() > _limit * page;
    // anydata[] paginateArray = utils:paginateArray(productList, page, _limit);
    // productList = paginateArray.length() == 0 ? [] : <db:ProductWithRelations[]>paginateArray; // Type casting

    utils:Pagination paginationResult = utils:paginate(productList, page, _limit);

    boolean hasNext = paginationResult.next;
    int count = paginationResult.count;
    productList = paginationResult.results.length() == 0 ? [] : <db:ProductWithRelations[]>paginationResult.results; // Type casting

    return {count: count, next: hasNext, results: productList};
}

public isolated  function getProductsById(int id) returns db:ProductWithRelations|error? {
    db:Client connection = connection:getConnection();

    db:ProductWithRelations|persist:Error? product = connection->/products/[id](db:ProductWithRelations);
    if product is persist:Error {
        return error("Product not found for id: " + id.toBalString());
    }
    return product;
}

public function getAllProducts() returns db:ProductWithRelations[]|error {
    db:Client connection = connection:getConnection();

    stream<db:ProductWithRelations, persist:Error?> productStream = connection->/products.get();
    db:ProductWithRelations[] products = check from db:ProductWithRelations product in productStream
        select product;

    productCache.put("products", products);

    return products;
}
