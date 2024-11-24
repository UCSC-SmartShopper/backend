import ballerina/io;
import backend.db;
import backend.connection;
import ballerina/time;
import ballerina/persist;

public type UserPreference record {| 
    int userId; 
    string preferenceType; 
    int referenceId; 
|};

map<int> preferenceWeights = {
    "Clicks": 1,
    "Purchases": 5,
    "Favorites": 4,
    "Search history": 2,
    "Time spent on items": 3,
    "Ratings or Reviews": 5
};


record {| int userId; int referenceId; int points; |}[] userInteractions = [
    {userId: 1, referenceId: 101, points: 10},
    {userId: 1, referenceId: 104,  points: 2},
    {userId: 1, referenceId: 102, points: 1},
    {userId: 3, referenceId: 103, points: 5},
    {userId: 2, referenceId: 107, points: 20},
    {userId: 1, referenceId: 109, points: 1}
];


function calculateRank(UserPreference userPreference) returns int? {

    foreach var interaction in userInteractions {
        if (interaction.userId == userPreference.userId && 
            interaction.referenceId == userPreference.referenceId ) {


            int weight = preferenceWeights[userPreference.preferenceType] ?: 0;
            interaction.points = interaction.points + weight;
            return interaction.points;
        }
    }
    

    return null;
}

public function addUserPreference(UserPreference userPreference) returns db:UserPreference|string|error {


    int? updatedPoints = calculateRank(userPreference);

    if (updatedPoints != null) {
        io:println("User preference updated successfully");
        io:println("User ID: ", userPreference.userId, 
                   ", Preference Type: ", userPreference.preferenceType, 
                   ", Reference ID: ", userPreference.referenceId, 
                   ", Updated Points: ", updatedPoints);
    } else {
        io:println("No existing preference found to update");
    }
    
    db:Client connection = connection:getConnection();

    db:UserPreferenceInsert userPreferenceInsert = {
        userId: userPreference.userId,
        referenceId: userPreference.referenceId,
        points: <int>updatedPoints,
        createdAt: time:utcToCivil(time:utcNow())
        };

    int[]|persist:Error result = connection->/userpreferences.post([userPreferenceInsert]);

    if result is persist:Error {
        return error("Error while adding the user preference");
    }

    db:UserPreference userPreferenceN = {...userPreferenceInsert, id:result[0]};


    

    return userPreferenceN;
}
