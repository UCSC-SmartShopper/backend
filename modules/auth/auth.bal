import backend.connection;
import backend.db;
// import backend.user;

import ballerina/http;
import ballerina/jwt;
import ballerina/persist;

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
|};

public type UserwithToken record {|
    User user;
    string jwtToken;
|};

db:Client connection = connection:getConnection();

public function getUser(http:Request req) returns User|error {
    // get barrier token from the request
    string|error authHeader = req.getHeader("Authorization");
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

        match user.role {
            "consumer" => {
                int consumerId = getConsumerId(user.id);
                jwtUser.consumerId = consumerId;
            }
            // "driver" => {
            //     int driverId = getDriverId(user.id);
            //     jwtUser.driverId = driverId;
            // }
        }

        string jwtToken = check jwt:issue(getConfig(jwtUser));
        return {user: jwtUser, jwtToken: jwtToken};
    }
    return error("Password incorrect");

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

// function getDriverId(int userId) returns int {
//     int driverId = -1;
//     do {
//         stream<db:Consumer, persist:Error?> driverStream = connection->/drivers();
//         db:Consumer[] driverArray = check from db:Consumer u in driverStream
//             where u.userId == userId
//             order by u.id descending
//             select u;
//         if (driverArray.length() > 0) {
//             driverId = driverArray[0].id;
//         }
//     } on fail {
//         driverId = -1;
//     }
//     return driverId;
// }
