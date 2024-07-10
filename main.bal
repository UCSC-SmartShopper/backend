import ballerina/http;
import ballerina/time;

table<User> key(id) users = table [
    {id: 1, name: "John Doe", email: "johndoe@gmail.com"},
    {id: 2, name: "Jane Doe", email: "janedoe@gmail.com"}
];

service / on new http:Listener(9090) {
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

    resource function post users(NewUser newUser) returns User|error? {
        User user = {id: users.length() + 1, ...newUser};
        users.add(user);
        return users[user.id];
    }
}
