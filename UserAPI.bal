// import ballerina/persist;

// function getusers() returns User[]|UserNotFound|error? {
//     // Initialize dbClient as a client object
//     persist:Client dbClient = check new("http://localhost:8080");
    
//     stream<User, persist:Error?> users = dbClient->/users.get();
//     return from User user in users
//         select user;
// }
