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

function calculatePoints(UserPreference userPreference) returns ()|db:UserPreference|error|int {

    db:UserPreference[]|error userPreferencesResult = getUserPreferences();


    if userPreferencesResult is error {
        io:println("Error fetching user preferences: ", userPreferencesResult.message());
        return null;
    }

    foreach var existingPreference in userPreferencesResult {
        if existingPreference.userid == userPreference.userid && 
           existingPreference.referenceid == userPreference.referenceid {

            int existingPoints = existingPreference.points;
            int additionalPoints = calculateWeight(userPreference);
            int updatedPoints = existingPoints + additionalPoints;

            io:println("Existing Preference Found. User ID: ", existingPreference.userid, 
                       ", Reference ID: ", existingPreference.referenceid, 
                       ", Updated Points: ", updatedPoints);
            return updatedPoints;
        }
    }

    io:println("No matching preference found for User ID: ", userPreference.userid, 
               ", Reference ID: ", userPreference.referenceid);

    int pointWeight = calculateWeight(userPreference);
    return createUserPreference(userPreference,pointWeight );
};


public function createUserPreference(UserPreference userPreference,int updatedPoints ) returns db:UserPreference|error {
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
};




public function addUserPreference(UserPreference userPreference) returns string|error {
    // Calculate rank and validate
    ()|db:UserPreference|error|int updatedPoints = calculatePoints(userPreference);
    if updatedPoints is null {
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

