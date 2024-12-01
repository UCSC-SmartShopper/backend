import backend.connection;
import backend.db;

// import backend.user;

import ballerina/http;
import ballerina/io;
import ballerina/jwt;
import ballerina/persist;
import backend.utils;

public type Credentials record {|
    string email_or_number;
    string password?;
|};

public type User record {|
    int id;
    string name;
    string email;
    string password?;
    string number;
    string profilePic;
    string role;

    int consumerId?;
    int supermarketId?;
    int driverId?;

|};

public type UserwithToken record {|
    User user;
    string jwtToken;
|};

public function getUser(http:Request req) returns User|error {
    // get barrier token from the request
    string|error authHeader = req.getHeader("jwt-key");
    if (authHeader is error) {
        return error("Authorization header not found");
    }

    if (authHeader.length() > 7 && authHeader.substring(0, 7) == "Bearer ") {
        string jwtToken = authHeader.substring(7);
        jwt:Payload jwtPayload = check jwt:validate(jwtToken, validatorConfig);
        json userJson = <json>jwtPayload["user"];
        User user = check userJson.cloneWithType(User);
        return user;
    } else {
        return error("Token not found");
    }

}

public function login(Credentials credentials) returns UserwithToken|error {

    db:Client connection = connection:getConnection();
    stream<db:User, persist:Error?> userStream = connection->/users();
    db:User[] userArray = check from db:User u in userStream
        where u.email == credentials.email_or_number || u.number == credentials.email_or_number
        order by u.id descending
        select u;

    if (userArray.length() == 0) {
        return error("User not found");
    }

    db:User user = userArray[0];
    if (user.password == credentials.password) {

        User jwtUser = {id: user.id, name: user.name, email: user.email, number: user.number, profilePic: user.profilePic, role: user.role};

        // attach consumerId, supermarketId or driverId based on the role
        match user.role {
            "Consumer" => {
                int consumerId = getConsumerId(user.id);
                jwtUser.consumerId = consumerId;
            }
            // supermarket manager id is the user id of the supermarket
            "Supermarket Manager" => {
                int supermarketId = getSupermarketId(user.id);
                jwtUser.supermarketId = supermarketId;
            }
            "Driver" => {
                int driverId = getDriverId(user.id);
                jwtUser.driverId = driverId;
            }
        }

        // update last login
        _ = start updateUserLastLogin(user.id);

        string jwtToken = check jwt:issue(getConfig(jwtUser));
        return {user: jwtUser, jwtToken: jwtToken};
    }
    return error("Invalid credentials");

}

function getConfig(User user) returns jwt:IssuerConfig {
    return {
        issuer: "ballerina",
        username: "ballerina",
        audience: ["ballerina", "ballerina.org", "ballerina.io"],
        customClaims: {user: user},
        expTime: 360000,
        signatureConfig: {
            config: {
                keyFile: "rsa.key"
            }
        }
    };
};

jwt:ValidatorConfig validatorConfig = {
    issuer: "ballerina",
    username: "ballerina",
    audience: ["ballerina", "ballerina.org", "ballerina.io"],
    signatureConfig: {
        certFile: "rsa.pub"
    }
};

function getConsumerId(int userId) returns int {
    int consumerId = -1;
    do {
        db:Client connection = connection:getConnection();
        stream<db:Consumer, persist:Error?> consumerStream = connection->/consumers();
        db:Consumer[] consumerArray = check from db:Consumer u in consumerStream
            where u.userId == userId
            order by u.id descending
            select u;
        if (consumerArray.length() > 0) {
            consumerId = consumerArray[0].id;
        }
    } on fail {
        consumerId = -1;
    }
    return consumerId;
}

function getSupermarketId(int userId) returns int {
    int supermarketId = -1;
    do {
        db:Client connection = connection:getConnection();
        stream<db:Supermarket, persist:Error?> supermarketStream = connection->/supermarkets();
        db:Supermarket[] supermarketArray = check from db:Supermarket s in supermarketStream
            // supermarket manager id is the user id of the supermarket
            where s.supermarketmanagerId == userId
            order by s.id descending
            select s;
        if (supermarketArray.length() > 0) {
            supermarketId = supermarketArray[0].id;
        }
    } on fail {
        supermarketId = -1;
    }
    return supermarketId;
}

function getDriverId(int userId) returns int {
    int driverId = -1;
    do {
        db:Client connection = connection:getConnection();
        stream<db:Driver, persist:Error?> driverStream = connection->/drivers();
        db:Driver[] driverArray = check from db:Driver u in driverStream
            where u.userId == userId
            order by u.id descending
            select u;
        if (driverArray.length() > 0) {
            driverId = driverArray[0].id;
        }
    } on fail {
        driverId = -1;
    }
    return driverId;
}

isolated function updateUserLastLogin(int userId) {
    do {
        db:Client connection = connection:getConnection();
        _ = check connection->/users/[userId].put({lastLogin: utils:getCurrentTime()});
    } on fail {
        io:println("Error updating last login");

    }
}
