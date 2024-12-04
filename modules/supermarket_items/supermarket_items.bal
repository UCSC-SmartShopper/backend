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

public function get_supermarket_items_by_product_id(auth:User user, int productId) returns SupermarketItemResponse|error {

    db:Client connection = connection:getConnection();

    stream<db:SupermarketItemWithRelations, persist:Error?> supermarketitems = connection->/supermarketitems();
    db:SupermarketItemWithRelations[] supermarketItem = check from db:SupermarketItemWithRelations supermarketitem in supermarketitems
        where supermarketitem.productId == productId
        order by supermarketitem.id
        select supermarketitem;

    return {count: supermarketItem.length(), next: "null", results: supermarketItem};
}

public function get_all_supermarket_items(auth:User user) returns SupermarketItemResponse|error {

    if (user.role != "Supermarket Manager") {
        return error("Unauthorized");
    }

    db:Client connection = connection:getConnection();

    stream<db:SupermarketItemWithRelations, persist:Error?> supermarketitems = connection->/supermarketitems();
    db:SupermarketItemWithRelations[] supermarketItem = check from db:SupermarketItemWithRelations supermarketitem in supermarketitems
        where supermarketitem.supermarketId == user.supermarketId
        order by supermarketitem.id
        select supermarketitem;

    return {count: supermarketItem.length(), next: "null", results: supermarketItem};
}

public isolated function get_supermarket_item_by_id(int id) returns db:SupermarketItemWithRelations|error {
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
