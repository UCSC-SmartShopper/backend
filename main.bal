import backend.db;
import backend.price_list;
import backend.products;

import ballerina/http;
import ballerina/persist;
import ballerina/time;

@http:ServiceConfig {
    cors: {
        allowOrigins: ["http://localhost:5173", "http://localhost:5174", "*"],
        allowCredentials: false,
        allowHeaders: ["CORELATION_ID"],
        exposeHeaders: ["X-CUSTOM-HEADER"],
        maxAge: 84900
    }
}
service / on new http:Listener(9090) {
    public final db:Client dbClient;

    function init() returns error? {
        self.dbClient = check new ();
    }

    resource function get users() returns db:User[]|error? {
        stream<db:User, persist:Error?> users = self.dbClient->/users.get();
        return from db:User user in users
            select user;
    }

    resource function get users/[int id]() returns db:UserWithRelations|DataNotFound|error? {
        db:UserWithRelations|persist:Error? user = self.dbClient->/users/[id](db:UserWithRelations);
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

        int[]|persist:Error result = self.dbClient->/users.post([userInsert]);

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
        db:User|persist:Error result = self.dbClient->/users/[id].put(user);

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

        db:User updatedUser = check self.dbClient->/users/[id](db:User);
        return updatedUser;
    }

    resource function get products() returns products:ProductResponse|persist:Error? {
        return products:getProducts();
    }

    resource function get products/[int id]() returns products:Product|DataNotFound|error? {
        return products:getProductsById(id);
    }

    // ---------------------------------------------- Price List Resource Functions ----------------------------------------------
    resource function get pricelists() returns price_list:PriceListResponse|error? {
        return price_list:getPriceLists();
    }

    resource function get pricelists/[int productId]() returns price_list:PriceListResponse|error? {
        return price_list:getPriceListsByProductId(productId);
    }
}
