import backend.auth;
import backend.connection;
import backend.db;

import ballerina/persist;
import backend.utils;
public type ActivityResponse record {|
    int count;
    boolean next;
    db:Activity[] results;
|};

public function getActivities(auth:User user) returns ActivityResponse|persist:Error? {
    db:Client connection = connection:getConnection();
    stream<db:Activity, persist:Error?> activityStream = connection->/activities();
    db:Activity[] activities = check from db:Activity activity in activityStream
        where activity.userId == user.consumerId
        select activity;
    return {count: activities.length(), next: false, results: activities};
}

public function createActivity(int userId, string description) returns error|int {
    db:Client connection = connection:getConnection();

    db:ActivityInsert activityInsert = {userId: userId, description: description, dateTime: utils:getCurrentTime()};
    int[]|persist:Error result = connection->/activities.post([activityInsert]);
    if result is persist:Error || result.length() == 0 {
        return error("Error while adding the activity");
    }
    return result[0];
}
