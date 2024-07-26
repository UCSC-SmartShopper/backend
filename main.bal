import backend.auth;
import backend.cart;
import backend.connection;
import backend.db;
import backend.products;
import backend.store_prices;
import backend.supermarkets;

import ballerina/http;
import ballerina/io;
import ballerina/persist;
import ballerina/time;

@http:ServiceConfig {
    cors: {
        allowOrigins: ["*"],
        allowCredentials: true,
        maxAge: 84900
    }
}
service / on new http:Listener(9090) {

    db:Client connection = connection:getConnection();

    resource function post login(@http:Payload auth:Credentials credentials) returns auth:UserwithToken|error {
        return auth:login(credentials);
    }

    resource function get users() returns db:User[]|error? {
        stream<db:User, persist:Error?> users = self.connection->/users.get();
        return from db:User user in users
            select user;
    }

    resource function get users/[int id]() returns db:UserWithRelations|DataNotFound|error? {
        db:UserWithRelations|persist:Error? user = self.connection->/users/[id](db:UserWithRelations);
        if user is () {
            DataNotFound notFound = {
                body: {
                    message: "User not found",
                    details: string `User not found for the given id: ${id}`,
                    timestamp: time:utcNow()
                }
            };
            return notFound;
        }
        return user;
    }

    resource function post consumer(NewUser newUser) returns db:User|persist:Error|http:Conflict & readonly {
        db:UserInsert userInsert = {
            ...newUser,
            userRole: "consumer",
            status: "Active",
            createdAt: time:utcToCivil(time:utcNow()),
            updatedAt: time:utcToCivil(time:utcNow()),
            deletedAt: ()};

        int[]|persist:Error result = self.connection->/users.post([userInsert]);

        if result is persist:Error {
            if result is persist:AlreadyExistsError {
                return http:CONFLICT;
            }
            return result;
        }

        db:User user = {...userInsert, id: result[0]};

        return user;
    }

    resource function patch users/[int id](@http:Payload db:UserUpdate user) returns db:User|DataNotFound|error? {
        db:User|persist:Error result = self.connection->/users/[id].put(user);

        if result is persist:Error {
            if result is persist:NotFoundError {
                DataNotFound notFound = {
                    body: {
                        message: "User not found",
                        details: string `User not found for the given id: ${id}`,
                        timestamp: time:utcNow()
                    }
                };
                return notFound;
            }
            return result;
        }

        db:User updatedUser = check self.connection->/users/[id](db:User);
        return updatedUser;
    }

    resource function get products(http:Request req) returns products:ProductResponse|persist:Error? {
        io:println(auth:getUser(req));
        return products:getProducts();
    }

    resource function get products/[int id]() returns products:Product|DataNotFound|error? {
        return products:getProductsById(id);
    }

    // ---------------------------------------------- Store Price Resource Functions ----------------------------------------------
    resource function get storeprices(@http:Query int productId) returns store_prices:SupermarketItemResponse|store_prices:SupermarketItemNotFound|error {
        return store_prices:getSupermarketItemByProductId(productId);
    }

    resource function get pricelists/[int id]() returns db:SupermarketItem|store_prices:SupermarketItemNotFound {
        return store_prices:getSupermarketItemById(id);
    }

    // ---------------------------------------------- Cart Resource Functions ----------------------------------------------
    resource function get carts(int userId) returns cart:CartItemResponse|error {
        return cart:getCartItems(userId);
    }

    // resource function get carts() returns cart:CartItem[]|error? {
    //     return cart:test();
    // }

    // ---------------------------------------------- Supermarket Resource Functions ----------------------------------------------
    resource function get supermarkets() returns db:Supermarket[]|error? {
        return supermarkets:getSupermarkets();
    }

    resource function get supermarkets/[int id]() returns db:Supermarket|supermarkets:SuperMarketNotFound|error? {
        return supermarkets:getSupermarketById(id);
    }

}
