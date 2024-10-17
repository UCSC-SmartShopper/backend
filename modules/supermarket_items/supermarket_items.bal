import backend.auth;
import backend.connection;
import backend.db;
import ballerina/persist;

public type SupermarketItemResponse record {|
    int count;
    string next;
    db:SupermarketItemWithRelations[] results;
|};


// -------------------------------------------------- Resource Functions --------------------------------------------------

public function get_supermarket_items(auth:User user, int productId) returns SupermarketItemResponse|error {

    // if user is supermarket manager then return all items belongs to the supermarket
    // if user is consumer then return supermarket item for the given product id
    db:Client connection = connection:getConnection();

    stream<db:SupermarketItemWithRelations, persist:Error?> prices = connection->/supermarketitems();
    db:SupermarketItemWithRelations[] supermarketItem = check from db:SupermarketItemWithRelations price in prices
        where (user.role == "Consumer" && price.productId == productId) || (user.role == "Supermarket Manager" && price.supermarketId == user.supermarketId)
        order by price.id
        select price;

    return {count: supermarketItem.length(), next: "null", results: supermarketItem};
}

public function get_supermarket_item_by_id(int id) returns db:SupermarketItemWithRelations|error {
    db:Client connection = connection:getConnection();

    db:SupermarketItemWithRelations|persist:Error supermarketItem = connection->/supermarketitems/[id].get();

    if (supermarketItem is persist:Error) {
        return error("Supermarket Item not found");
    }
    return supermarketItem;
}

public function editSupermarketItem(auth:User user, int id, db:SupermarketItemUpdate supermarketItemUpdate) returns db:SupermarketItem|error {

    db:Client connection = connection:getConnection();

    db:SupermarketItem|persist:Error UpdatedSupermarketItem = connection->/supermarketitems/[id].put(supermarketItemUpdate);

    if (UpdatedSupermarketItem is persist:Error) {
        return error("Supermarket Item not found");
    }
    return UpdatedSupermarketItem;
}

