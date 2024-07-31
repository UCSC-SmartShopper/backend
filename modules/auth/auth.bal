import backend.connection;
import backend.db;

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

// jwt:IssuerConfig issuerConfig = {
//     issuer: "ballerina",
//     username: "ballerina",
//     audience: ["ballerina", "ballerina.org", "ballerina.io"],
//     customClaims: {"scp": "admin"},
//     expTime: 3600,
//     signatureConfig: {
//         config: {
//             keyFile: "rsa.key"
//         }
//     }
// };

db:Client connection = connection:getConnection();

public function getUser(http:Request req) returns User|error {
    http:Cookie[] cookies = req.getCookies();

    if (cookies.length() > 0) {
        string jwtToken = cookies.filter(cookie => cookie.name == "token")[0].value;

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
    if (userArray[0].password == credentials.password) {
        int consumerId = -1;

        if (userArray[0].role == "consumer") {
            stream<db:Consumer, persist:Error?> consumerStream = connection->/consumers();
            db:Consumer[] consumerArray = check from db:Consumer u in consumerStream
                where u.userId == userArray[0].id
                select u;


            if (consumerArray.length() > 0) {
                consumerId = consumerArray[0].id;
            }
        }

        User user = {id: userArray[0].id, name: userArray[0].name, email: userArray[0].email, number: userArray[0].number, profilePic: userArray[0].profilePic,
            role: userArray[0].role, consumerId: consumerId};

        // remove password from the user object
        string jwtToken = check jwt:issue(getConfig(user));
        return {user: user, jwtToken: jwtToken};
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
