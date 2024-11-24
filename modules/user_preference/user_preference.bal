import ballerina/io;
import backend.db;
import backend.connection;
import ballerina/time;
import ballerina/persist;

public type UserPreference record {|
    int userid;
    string preferenceType;
    int referenceid;

|};

map<int> preferenceWeights = {
    "Clicks": 1,
    "Purchases": 5,
    "Favorites": 4,
    "Search history": 2,
    "Time spent on items": 3,
    "Ratings or Reviews": 5
};

// Fetch all user preferences from the database
public function getUserPreferences() returns db:UserPreference[]|error {
    db:Client connection = connection:getConnection();

    stream<db:UserPreference, persist:Error?> userPreferenceStream = connection->/userpreferences;
    db:UserPreference[] userPreferenceList = check from db:UserPreference userPreference in userPreferenceStream
        select userPreference;
    check userPreferenceStream.close();
    
    return userPreferenceList;
}

// Calculate the weight based on preference type
function calculateWeight(UserPreference userPreference) returns int {
    int weight = preferenceWeights[userPreference.preferenceType] ?: 0;
    return weight;
}

// Calculate points based on existing user preferences or create a new one
function calculatePoints(UserPreference userPreference) returns db:UserPreference|error|string|error|error {
    db:UserPreference[]|error userPreferencesResult = getUserPreferences();

    if userPreferencesResult is error {
        io:println("Error fetching user preferences: ", userPreferencesResult.message());
        return error("Error fetching user preferences");
    }

    // Check if the preference exists in the database
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

            // Update the points for the existing preference
            return updatepoints(existingPreference.id, updatedPoints);
        }
    }

    io:println("No matching preference found for User ID: ", userPreference.userid, 
               ", Reference ID: ", userPreference.referenceid);

    // If no match is found, create a new user preference
    int pointWeight = calculateWeight(userPreference);
    return createUserPreference(userPreference, pointWeight);
}

// Update the points for an existing user preference
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

// Create a new user preference with calculated points
public function createUserPreference(UserPreference userPreference, int updatedPoints) returns db:UserPreference|error {
    db:Client connection = connection:getConnection();
    
    io:println("Database connection established.");

    db:UserPreferenceInsert userPreferenceInsert = {
        userid: userPreference.userid,
        referenceid: userPreference.referenceid, 
        points: updatedPoints,
        createdAt: time:utcToCivil(time:utcNow())
    };
    io:println("Insert Record: ", userPreferenceInsert);

    int[]|persist:Error result = connection->/userpreferences.post([userPreferenceInsert]);
    if result is persist:Error {
        return error("Error while adding the user preference", result);
    }

    db:UserPreference userPreferenceN = {...userPreferenceInsert, id: result[0]};
    return userPreferenceN;
}

// Add or update a user preference based on existing preferences
public function addUserPreference(UserPreference userPreference) returns string|error {
    // Calculate rank and validate
    db:UserPreference|error|string updatedPoints = calculatePoints(userPreference);
    if updatedPoints is error {
        return error("Points calculation failed; cannot insert.");
    }

    // Log the updated details
    io:println("User preference updated successfully");
    io:println("User ID: ", userPreference.userid, 
               ", Preference Type: ", userPreference.preferenceType, 
               ", Reference ID: ", userPreference.referenceid, 
               ", Updated Points: ", updatedPoints);

    return "done";
}
