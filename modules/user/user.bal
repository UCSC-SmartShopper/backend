import backend.auth;
import backend.connection;
import backend.db;
import backend.errors;
import backend.file_service;
import backend.utils;

import ballerina/http;
import ballerina/persist;
import ballerina/time;

public type UserNotFound record {|
    *http:NotFound;
    errors:ErrorDetails body;
|};

public type UpdatePassword record {|
    string oldPassword;
    string newPassword;
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

public function get_all_user(auth:User authUser) returns UserResponse|http:Unauthorized|error {

    string[] authorizedRoles = ["Admin", "SupermarketManager", "Driver"];

    if !authorizedRoles.some((role) => role == authUser.role) {
        return http:UNAUTHORIZED;
    }

    db:Client connection = connection:getConnection();
    stream<db:User, persist:Error?> users = connection->/users.get();
    db:User[] userList = check from db:User user in users
        order by user.id descending
        select user;

    return {count: userList.length(), next: "null", results: userList};
}

public function get_user(auth:User user, int id) returns db:User|http:Unauthorized|error {
    db:Client connection = connection:getConnection();

    string[] authorizedRoles = ["Admin", "SupermarketManager", "Driver"];

    if !authorizedRoles.some((role) => role == user.role) && user.id != id {
        return http:UNAUTHORIZED;
    }

    db:User|persist:Error result = connection->/users/[id]();

    if result is persist:Error {
        return error("User not found");
    }

    db:User sanitizedUser = {
        id: result.id,
        name: result.name,
        email: result.email,
        number: result.number,
        profilePic: result.profilePic,
        role: result.role,
        status: result.status,
        password: "",
        lastLogin: result.lastLogin,
        createdAt: result.createdAt,
        updatedAt: result.updatedAt,
        deletedAt: result.deletedAt
    };

    return sanitizedUser;
}

public function get_user_with_relations(int id) returns db:UserWithRelations|error {
    db:Client connection = connection:getConnection();

    db:UserWithRelations|persist:Error result = connection->/users/[id]();

    if result is persist:Error {
        return error("User not found");
    }

    return result;
}

public function update_user(auth:User user, db:UserUpdate userUpdate) returns db:User|error {
    db:Client connection = connection:getConnection();

    // Validataion
    if userUpdate.name == "" {
        return error("Name cannot be empty");
    }
    if userUpdate.email == "" {
        return error("Email cannot be empty");
    }
    if userUpdate.number == "" {
        return error("Number cannot be empty");
    }

    db:UserUpdate sanitizedUserUpdate = {
        name: userUpdate.name,
        email: userUpdate.email,
        number: userUpdate.number
    };

    db:User|persist:Error updatedUser = connection->/users/[user.id].put(sanitizedUserUpdate);

    if updatedUser is persist:Error {
        return error("Failed to update the user");
    }

    return updatedUser;
}

public function update_password(auth:User user, int id, UpdatePassword updatePassword) returns db:User|error {
    db:Client connection = connection:getConnection();

    db:User|persist:Error dbUser = connection->/users/[id](db:User);

    if dbUser is persist:Error {
        return error("User not found");
    }

    if updatePassword.oldPassword != dbUser.password {
        return error("Invalid password");
    }

    db:UserUpdate userUpdate = {password: updatePassword.newPassword};
    db:User|persist:Error updatedUser = connection->/users/[id].put(userUpdate);

    if updatedUser is persist:Error {
        return error("Failed to update the password");
    }

    return updatedUser;
}

public function update_profile_picture(auth:User user, http:Request req, int id) returns string|error {

    // Admin can update any user's profile picture
    // Other users can only update their own profile picture
    int userId = user.role == "Admin" ? id : user.id;
    string imagePath = "";

    utils:FormData[] formData = check utils:decodedFormData(req);
    foreach utils:FormData data in formData {
        if (data.name == "profilePicture") {

            // used to save the file with a unique name
            string file_code = "profile_pic_" + userId.toBalString();
            imagePath = check file_service:saveFile(<byte[]>data.value, data.contentType, file_code);
        }

    }

    db:Client connection = connection:getConnection();
    db:User|persist:Error dbUser = connection->/users/[userId].put({profilePic: imagePath});
    if dbUser is persist:Error {
        return error("Failed to update the profile picture");
    }

    return "Profile picture updated successfully";
}
