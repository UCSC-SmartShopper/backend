import backend.auth;
import backend.connection;
import backend.db;
import backend.user;
import backend.utils;

import ballerina/http;
import ballerina/persist;
import ballerina/time;
import ballerina/sql;
import ballerina/log;

public type ConsumerResponse record {|
    int count;
    string next;
    Consumer[] results;
|};

public type Activity record {|
    string description;
    time:Civil dateTime;
|};

// created a new type Consumer to remove the password field from the User type
public type Consumer record {|
    *db:ConsumerOptionalized;
    user:User user;
    db:AddressOptionalized[] addresses?;
    db:OpportunityOptionalized[] opportunity?;
|};

public function get_all_consumers(string searchText, int month, int page, int _limit) returns ConsumerResponse|http:Unauthorized|error {

    // string[] authorizedRoles = ["Admin", "SupermarketManager", "Consumer"];

    // if !authorizedRoles.some((role) => role == user.role) {
    //     return http:UNAUTHORIZED;
    // }

    sql:Client connection = connection:getConnection();
    stream<Consumer, persist:Error?> consumers = connection->/consumers.get();
    Consumer[] consumerList = check from Consumer consumer in consumers
        where
            (searchText == "" || consumer.user.name.toLowerAscii().includes(searchText.toLowerAscii())) &&
            (month == 0 || consumer.user.createdAt.month == month)
        order by consumer.id descending
        select consumer;

    // pagination
    do {
        int[] pagination_values = utils:pagination_values(consumerList.length(), page, _limit);
        consumerList = consumerList.slice(pagination_values[0], pagination_values[1]);
    } on fail {
        return error("Pagination failed");
    }

    return {count: consumerList.length(), next: "null", results: consumerList};
}

public function get_consumer(auth:User user, int id) returns Consumer|http:Unauthorized|error {
    db:Client connection = connection:getConnection();

    Consumer|persist:Error result = connection->/consumers/[id](Consumer);

    if result is persist:Error {
        return error("Consumer not found");
    }

    return result;
}

// public function get_activities(int userId) returns Activity[]|error {
//     db:Client connection = connection:getConnection();
//     // Query activities by userId
//     Activity|persist:Error activityStream = connection->/activities/[userId](Activity);
//     // Collect the activities
//     Activity[] activities = from Activity activity in check activityStream
//         select activity;

//     return activities;
// }


public function get_activities(int userId) returns Activity[]|error {
    // Get a database connection
    db:Client connection = connection:getConnection();

    // Write an SQL query to select activities based on userId
    sql:ParameterizedQuery query = `SELECT * FROM activities WHERE userId = ${userId}`;

    // Execute the query and collect the activities
    stream<Activity, error> activityStream = connection->query(query, Activity);

    // Collect the activities from the stream
    Activity[] activities = check from Activity activity in activityStream
        select activity;

    return activities;
}

public function add_activity(Activity activity) returns error? {
    // Get a database connection
    db:Client connection = connection:getConnection();

    // SQL query to insert a new activity
    string query = "INSERT INTO activities (userId, actionType, description, timestamp) VALUES (?, ?, ?, ?)";

    // Execute the SQL query with the activity details
    sql:ExecutionResult result = check connection->execute(query, activity.userId, activity.actionType, 
                                                           activity.description, activity.timestamp);

    // Check if the query was successful
    if (result.affectedRowCount > 0) {
        log:printInfo("Activity added successfully");
    } else {
        log:printError("Failed to add activity");
    }

    return;
}
