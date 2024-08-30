import backend.auth;
import backend.connection;
import backend.db;

import ballerina/http;
import ballerina/persist;

public type DriverResponse record {|
    int count;
    string next;
    db:DriverWithRelations[] results;
|};

public function get_all_drivers() returns DriverResponse|http:Unauthorized|error {

    // string[] authorizedRoles = ["Admin", "SupermarketManager", "Driver"];

    // if !authorizedRoles.some((role) => role == user.role) {
    //     return http:UNAUTHORIZED;
    // }

    db:Client connection = connection:getConnection();
    stream<db:DriverWithRelations, persist:Error?> drivers = connection->/drivers.get();
    db:DriverWithRelations[] driverList = check from db:DriverWithRelations driver in drivers
        order by driver.id descending
        select driver;

    return {count: driverList.length(), next: "null", results: driverList};
}

public function get_driver(auth:User user, int id) returns db:DriverWithRelations|http:Unauthorized|error {
    db:Client connection = connection:getConnection();

    db:DriverWithRelations|persist:Error result = connection->/drivers/[id](db:DriverWithRelations);

    if result is persist:Error {
        return error("Driver not found");
    }

    return result;
}
