import ballerina/http;
import ballerina/persist;
import ballerina/time;

type ProductResponse record {|
    int count;
    string next;
    Product[] results;
|};

@http:ServiceConfig {
    cors: {
        allowOrigins: ["http://localhost:5173", "http://localhost:5174"],
        allowCredentials: false,
        allowHeaders: ["CORELATION_ID"],
        exposeHeaders: ["X-CUSTOM-HEADER"],
        maxAge: 84900
    }
}
service / on new http:Listener(9090) {
    public final Client dbClient;

    function init() returns error? {
        self.dbClient = check new ();
    }

    resource function get users() returns User[]|error? {
        stream<User, persist:Error?> users = self.dbClient->/users.get();
        return from User user in users
            select user;
    }

    resource function get users/[int id]() returns User|DataNotFound|error? {
        User|persist:Error? user = self.dbClient->/users/[id](User);
        if user is () {
            DataNotFound notFound = {
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

    resource function post consumer(NewUser newUser) returns User|persist:Error|http:Conflict & readonly {
        UserInsert userInsert = {
            ...newUser,
            userRole: "consumer",
            status: "Active",
            createdAt: time:utcToCivil(time:utcNow()),
            updatedAt: time:utcToCivil(time:utcNow()),
            deletedAt: ()};

        int[]|persist:Error result = self.dbClient->/users.post([userInsert]);

        if result is persist:Error {
            if result is persist:AlreadyExistsError {
                return http:CONFLICT;
            }
            return result;
        }

        User user = {...userInsert, id: result[0]};

        return user;
    }

    resource function patch users/[int id](@http:Payload UserUpdate user) returns User|DataNotFound|error? {
        User|persist:Error result = self.dbClient->/users/[id].put(user);

        if result is persist:Error {
            if result is persist:NotFoundError {
                DataNotFound notFound = {
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

        User updatedUser = check self.dbClient->/users/[id](User);
        return updatedUser;
    }

    resource function get products() returns ProductResponse|persist:Error? {
        return getProducts();
    }

    resource function get products/[int id]() returns Product|DataNotFound|error? {
        return getProductsById(id);
    }
}
