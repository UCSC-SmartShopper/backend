import ballerina/io;
import backend.db;
import backend.connection;
import ballerina/persist;
import backend.utils;

public type UserPreference record {|
    int userid;
    string preferenceType;
    int referenceid;

|};

map<int> preferenceWeights = {
    "Cart": 3,
    "Purchases": 5,
    // "Favorites": 4,
    // "Search history": 2,
    // "Time spent on items": 3,
    "Ratings": 4
};

public function getUserPreferencesByIdandProductId(int userId, int productId) returns error|float {
    db:Client connection = connection:getConnection();

    stream<db:UserPreference, persist:Error?> userPreferenceStream = connection->/userpreferences;
    db:UserPreference[] userPreferenceList = check from db:UserPreference userPreference in userPreferenceStream
        where userPreference.userid == userId && userPreference.referenceid == productId
        select userPreference;
    check userPreferenceStream.close();

    if userPreferenceList.length() == 0 {
        return 0.0;
    }

    float scoreTop = <float> userPreferenceList[0].points;
    
    return scoreTop;
}


public function getUserPreferences() returns db:UserPreference[]|error {
    db:Client connection = connection:getConnection();

    stream<db:UserPreference, persist:Error?> userPreferenceStream = connection->/userpreferences;
    db:UserPreference[] userPreferenceList = check from db:UserPreference userPreference in userPreferenceStream
        select userPreference;
    check userPreferenceStream.close();
    
    return userPreferenceList;
}

function calculateWeight(UserPreference userPreference) returns int {
    int weight = preferenceWeights[userPreference.preferenceType] ?: 0;
    return weight;
}


public function updatepoints(int id, int point) returns string|error {
    db:Client connection = connection:getConnection();
    db:UserPreferenceOptionalized|persist:Error preference = connection->/userpreferences/[id]();

    if preference is persist:Error {
        return error("Preference not found");
    }

    db:UserPreferenceUpdate userPreferenceUpdate = {
        points: point
    };

    db:UserPreference |persist:Error result = connection->/userpreferences/[id].put(userPreferenceUpdate);
    if result is persist:Error {
        return error("Error while updating the user preference");
    }

    return "User preference updated successfully";
}

public function createUserPreference(UserPreference userPreference, int updatedPoints) returns db:UserPreference|error {
    db:Client connection = connection:getConnection();
    
    io:println("Database connection established.");

    db:UserPreferenceInsert userPreferenceInsert = {
        userid: userPreference.userid,
        referenceid: userPreference.referenceid, 
        points: updatedPoints,
        createdAt: utils:getCurrentTime()
    };
    io:println("Insert Record: ", userPreferenceInsert);

    int[]|persist:Error result = connection->/userpreferences.post([userPreferenceInsert]);
    if result is persist:Error {
        return error("Error while adding the user preference", result);
    }

    db:UserPreference userPreferenceN = {...userPreferenceInsert, id: result[0]};
    return userPreferenceN;
}

public function calculatePoints(UserPreference userPreference) returns db:UserPreference|error|string|error|error {
    db:UserPreference[]|error userPreferencesResult = getUserPreferences();

    if userPreferencesResult is error {
        io:println("Error fetching user preferences: ", userPreferencesResult.message());
        return error("Error fetching user preferences");
    }

    foreach var existingPreference in userPreferencesResult {
        if existingPreference.userid == userPreference.userid && existingPreference.referenceid == userPreference.referenceid {

            int existingPoints = existingPreference.points;
            io:println("existingPoints = ", existingPoints);
            int additionalPoints = calculateWeight(userPreference);

            io:println("additionalPoints = ", additionalPoints);
            int updatedPoints = existingPoints + additionalPoints;
            io:println("updatedPoints = ", updatedPoints);

            io:println("Existing Preference Found. User ID: ", existingPreference.userid, 
                       ", Reference ID: ", existingPreference.referenceid, 
                       ", Updated Points: ", updatedPoints);

            return updatepoints(existingPreference.id, updatedPoints);
        }
    }

    io:println("No matching preference found for User ID: ", userPreference.userid, 
               ", Reference ID: ", userPreference.referenceid);

    int pointWeight = calculateWeight(userPreference);
    return createUserPreference(userPreference, pointWeight);
}

