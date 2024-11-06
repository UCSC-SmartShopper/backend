import backend.auth;
import backend.connection;
import backend.db;

import ballerina/persist;

public type LikedProductResponse record {|
    int count;
    boolean next;
    db:LikedProduct[] results;
|};

public function get_liked_products(auth:User user) returns LikedProductResponse|persist:Error? {

    db:Client connection = connection:getConnection();
    stream<db:LikedProduct, persist:Error?> likedProductStream = connection->/likedproducts();
    db:LikedProduct[] likedProducts = check from db:LikedProduct likedProduct in likedProductStream
        where likedProduct.userId == user.id
        select likedProduct;

    return {count: likedProducts.length(), next: false, results: likedProducts};
}

public function create_liked_product(auth:User user, int productId) returns error|int {
    db:Client connection = connection:getConnection();

    db:LikedProductInsert likedProductInsert = {userId: user.id, productId: productId};
    int[]|persist:Error result = connection->/likedproducts.post([likedProductInsert]);

    if result is persist:Error || result.length() == 0 {
        return error("Error while adding the liked product");
    }
    return result[0];
}

public function delete_liked_product(auth:User user, int id) returns string|error {
    db:Client connection = connection:getConnection();

    db:LikedProduct likedProduct = check connection->/likedproducts/[id].get();

    if likedProduct.userId != user.id {
        return error("User is not authorized to delete this liked product");
    }

    db:LikedProduct|persist:Error result = connection->/likedproducts/[id].delete();

    if result is persist:Error {
        return error("Error while deleting the liked product");
    }
    return "Liked product deleted successfully";
}

