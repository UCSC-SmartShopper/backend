import backend.db;

import ballerina/http;
import ballerina/persist;
import ballerina/time;

table<User> key(id) users = table [
    {id: 1, name: "John Doe", email: "johndoe@gmail.com"},
    {id: 2, name: "Jane Doe", email: "janedoe@gmail.com"}
];

service / on new http:Listener(9090) {
    private final db:Client dbClient;

    function init() returns error? {
        self.dbClient = check new ();
    }

    resource function get users() returns User[]|UserNotFound|error? {
        return users.toArray();
    }

    resource function get users/[int id]() returns User|UserNotFound|error? {

        User|error? user = users[id];
        if user is () {
            UserNotFound notFound = {
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

    resource function post users(db:UserInsert newUser) returns http:Created & readonly|persist:Error|http:Conflict & readonly {
        int[]|persist:Error result = self.dbClient->/users.post([newUser]);

        if result is persist:Error {
            if result is persist:AlreadyExistsError {
                return http:CONFLICT;
            }
            return result;
        }
        return http:CREATED;
    }
}
