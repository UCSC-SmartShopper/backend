import backend.db;

import ballerina/http;
import ballerina/persist;
import ballerina/time;

table<User> key(id) users = table [
    {id: 1, name: "John Doe", email: "johndoe@gmail.com"},
    {id: 2, name: "Jane Doe", email: "janedoe@gmail.com"}
];

service / on new http:Listener(9090) {
    public final db:Client dbClient;
    function init() returns error? {
        self.dbClient = check new ();
    }

    resource function get users() returns User[]|UserNotFound|error? {
        stream<User, persist:Error?> users = self.dbClient->/users.get();
        return from User user in users
            select user;
    }

    resource function get users/[int id]() returns db:User|UserNotFound|error? {
        db:User|persist:Error? user = self.dbClient->/users/[id](db:User);
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

    resource function post users(db:UserInsert newUser) returns db:UserInsert|persist:Error|http:Conflict & readonly {
        int[]|persist:Error result = self.dbClient->/users.post([newUser]);

        if result is persist:Error {
            if result is persist:AlreadyExistsError {
                return http:CONFLICT;
            }
            return result;
        }

        db:User insertedUser = check self.dbClient->/users/[newUser.id](db:User);
        return insertedUser;
    }

    resource function patch users/[int id](@http:Payload db:UserUpdate user) returns db:User|UserNotFound|error? {
        db:User|persist:Error result = self.dbClient->/users/[id].put(user);

        if result is persist:Error {
            if result is persist:NotFoundError {
                UserNotFound notFound = {
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
}
