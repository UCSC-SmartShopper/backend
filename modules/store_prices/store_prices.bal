import backend.auth;
import backend.connection;
import backend.db;
import backend.errors;

import ballerina/http;
import ballerina/persist;

// public type Supermarket record {|
//     readonly int id;
//     string name;
//     string contactNo;
//     string logo;
//     string location;
//     string address;
//     int supermarketmanagerId;

// |};

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

db:Client connection = connection:getConnection();

public function getSupermarketItemByProductId(auth:User user, int productId) returns SupermarketItemResponse|SupermarketItemNotFound|error {

    // if user is supermarket manager then return all items belongs to the supermarket
    // if user is consumer then return supermarket item for the given product id

    stream<db:SupermarketItem, persist:Error?> prices = connection->/supermarketitems();
    db:SupermarketItem[] supermarketItem = check from db:SupermarketItem price in prices
        where (user.role == "consumer" && price.productId == productId) || (user.role == "supermarket" && price.supermarketId == user.supermarketId)
        order by price.id
        select price;

    return {count: supermarketItem.length(), next: "null", results: supermarketItem};
}

public function getSupermarketItemById(int id) returns db:SupermarketItem|SupermarketItemNotFound {
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

    db:SupermarketItem|persist:Error UpdatedSupermarketItem = connection->/supermarketitems/[supermarketItemId].put(supermarketItemUpdate);

    if (UpdatedSupermarketItem is persist:Error) {
        return createSupermarketItemNotFound(supermarketItemId);
    }
    return UpdatedSupermarketItem;
}
