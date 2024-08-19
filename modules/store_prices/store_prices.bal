import backend.auth;
import backend.connection;
import backend.db;
import backend.errors;
// import backend.products;

import ballerina/http;
import ballerina/persist;



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

public function get_supermarket_items(auth:User user, int productId) returns SupermarketItemResponse|SupermarketItemNotFound|error {

    // if user is supermarket manager then return all items belongs to the supermarket
    // if user is consumer then return supermarket item for the given product id
    db:Client connection = connection:getConnection();

    stream<db:SupermarketItem, persist:Error?> prices = connection->/supermarketitems();
    db:SupermarketItem[] supermarketItem = check from db:SupermarketItem price in prices
        where (user.role == "Consumer" && price.productId == productId) || (user.role == "Supermarket Manager" && price.supermarketId == user.supermarketId)
        order by price.id
        select price;

    return {count: supermarketItem.length(), next: "null", results: supermarketItem};
}

public function get_supermarket_item_by_id(int id) returns db:SupermarketItem|SupermarketItemNotFound {
    db:Client connection = connection:getConnection();

    db:SupermarketItem|persist:Error supermarketItem = connection->/supermarketitems/[id].get(db:SupermarketItem);

    if (supermarketItem is persist:Error) {
        return createSupermarketItemNotFound(id);
    }
    return supermarketItem;
}

public function editSupermarketItem(auth:User user, db:SupermarketItem supermarketItem) returns db:SupermarketItem|SupermarketItemNotFound {

    int supermarketItemId = supermarketItem.id;

    db:SupermarketItemUpdate supermarketItemUpdate = {
        price: supermarketItem.price,
        productId: supermarketItem.productId,
        supermarketId: supermarketItem.supermarketId,
        discount: supermarketItem.discount,
        availableQuantity: supermarketItem.availableQuantity
    };
    db:Client connection = connection:getConnection();

    db:SupermarketItem|persist:Error UpdatedSupermarketItem = connection->/supermarketitems/[supermarketItemId].put(supermarketItemUpdate);

    if (UpdatedSupermarketItem is persist:Error) {
        return createSupermarketItemNotFound(supermarketItemId);
    }
    return UpdatedSupermarketItem;
}




