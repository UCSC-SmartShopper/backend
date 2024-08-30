import backend.auth;
import backend.connection;
import backend.db;
import backend.errors;

import ballerina/http;
import ballerina/persist;
import ballerina/time;

public type UserNotFound record {|
    *http:NotFound;
    errors:ErrorDetails body;
|};

// without password
public type User record {|
    readonly int id;
    string name;
    string email;
    string number;
    string profilePic;
    string role;
    string status;

    time:Civil? lastLogin;
    time:Civil createdAt;
    time:Civil updatedAt;
    time:Civil? deletedAt;
|};

public type UserResponse record {|
    int count;
    string next;
    db:User[] results;
|};

function createUserNotFound(int id) returns UserNotFound {
    return {
        body: {
            message: "User not found",
            details: string `User not found for the given id: ${id}`,
            timestamp: time:utcNow()
        }
    };
}

public function get_all_user() returns UserResponse|http:Unauthorized|error {

    // string[] authorizedRoles = ["Admin", "SupermarketManager", "Driver"];

    // if !authorizedRoles.some((role) => role == user.role) {
    //     return http:UNAUTHORIZED;
    // }

    db:Client connection = connection:getConnection();
    stream<db:User, persist:Error?> users = connection->/users.get();
    db:User[] userList = check from db:User user in users
        order by user.id descending
        select user;

    return {count: userList.length(), next: "null", results: userList};
}

public function get_user(auth:User user, int id) returns db:UserWithRelations|http:Unauthorized|UserNotFound {
    db:Client connection = connection:getConnection();

    string[] authorizedRoles = ["Admin", "SupermarketManager", "Driver"];

    if !authorizedRoles.some((role) => role == user.role) && user.id != id {
        return http:UNAUTHORIZED;
    }

    db:UserWithRelations|persist:Error result = connection->/users/[id](db:UserWithRelations);

    if result is persist:Error {
        return createUserNotFound(id);
    }

    return result;
}

public function update_user(auth:User user, db:UserUpdate userUpdate) returns db:User|UserNotFound {
    db:Client connection = connection:getConnection();

    db:User|persist:Error updatedUser = connection->/users/[user.id].put(userUpdate);

    if updatedUser is persist:Error {
        return createUserNotFound(user.id);
    }

    return updatedUser;
}
