import backend.auth;
import backend.connection;
import backend.db;
import backend.errors;

import ballerina/http;
import ballerina/persist;
import backend.utils;

public type SuperMarketNotFound record {|
    *http:NotFound;
    errors:ErrorDetails body;
|};

public type SupermarketResponse record {|
    int count;
    string next;
    db:SupermarketWithRelations[] results;
|};

public type NewSupermarket record {|
    string name;
    string contactNo;
    string logo;
    string location;
    string address;
    string city;
    string email;
    string password;
    string role;
    string status;
    string supermarketManagerId;
    string supermarketManagerName;
|};

function createSuperMarketNotFound(int id) returns SuperMarketNotFound {
    return {
        body: {
            message: "SuperMarket not found",
            details: string `SuperMarket not found for the given id: ${id}`
        }
    };
}

public function get_supermarkets() returns SupermarketResponse|error {
    db:Client connection = connection:getConnection();
    stream<db:SupermarketWithRelations, persist:Error?> supermarketStream = connection->/supermarkets.get();
    db:SupermarketWithRelations[] supermarkets = check from db:SupermarketWithRelations supermarket in supermarketStream
        select supermarket;

    return {count: supermarkets.length(), next: "", results: supermarkets};
}

public function get_supermarket_by_id(int id) returns db:Supermarket|SuperMarketNotFound|error? {
    db:Client connection = connection:getConnection();
    db:Supermarket|persist:Error? supermarket = connection->/supermarkets/[id](db:Supermarket);
    if (supermarket is ()) {
        return createSuperMarketNotFound(id);
    }
    return supermarket;
}

// create supermarket

public function register_supermarket(auth:User user, NewSupermarket supermarket) returns db:Supermarket|http:Unauthorized|persist:Error|error? {

    if user.role != "Admin" {
        return http:UNAUTHORIZED;
    }

    // Insert user information
    db:UserInsert userInsert = {
        name: supermarket.supermarketManagerName,
        email: supermarket.email,
        password: supermarket.password,
        number: supermarket.contactNo,
        profilePic: supermarket.logo,
        role: "Supermarket Manager",
        status: "Active",
        
        lastLogin: utils:getCurrentTime(),
        createdAt: utils:getCurrentTime(),
        updatedAt: utils:getCurrentTime(),
        deletedAt: ()
    };
    db:Client connection = connection:getConnection();
    int[]|persist:Error userResult = connection->/users.post([userInsert]);

    if userResult is persist:Error {
        if userResult is persist:AlreadyExistsError {
            return error("User already exists");
        }
        return userResult;
    }

    // Insert supermarket information
    db:SupermarketInsert supermarketInsert = {
        name: supermarket.name,
        contactNo: supermarket.contactNo,
        logo: supermarket.logo,
        location: supermarket.location,
        address: supermarket.address,
        city: supermarket.city,
        supermarketmanagerId: userResult[0]
    };

    int[]|persist:Error supermarketResult = connection->/supermarkets.post([supermarketInsert]);

    if supermarketResult is persist:Error {
        if supermarketResult is persist:AlreadyExistsError {
            return error("User already exists");
        }
        return supermarketResult;
    }

    // Return the created user
    return {
        ...supermarketInsert,
        id: supermarketResult[0]
    };
}
