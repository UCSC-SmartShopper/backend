import ballerina/io;

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

// Temp hardcoded user interactions
record {| int userId; int referenceId; int points; |}[] userInteractions = [
    {userId: 1, referenceId: 101, points: 10},
    {userId: 1, referenceId: 104,  points: 2},
    {userId: 1, referenceId: 102, points: 1},
    {userId: 3, referenceId: 103, points: 5},
    {userId: 2, referenceId: 107, points: 20},
    {userId: 1, referenceId: 109, points: 1}
];

// Function to calculate rank and update points
function calculateRank(UserPreference userPreference) returns int? {
    // Check if the userInteraction exists
    foreach var interaction in userInteractions {
        if (interaction.userId == userPreference.userId && 
            interaction.referenceId == userPreference.referenceId ) {

            // Update points based on preferenceType
            int weight = preferenceWeights[userPreference.preferenceType] ?: 0;
            interaction.points = interaction.points + weight;
            return interaction.points;
        }
    }
    
    // If no matching entry is found, return null
    return null;
}

public function addUserPreference(UserPreference userPreference) returns string {
    int? updatedPoints = calculateRank(userPreference);

    // Check if the points were updated
    if (updatedPoints != null) {
        io:println("User preference updated successfully");
        io:println("User ID: ", userPreference.userId, 
                   ", Preference Type: ", userPreference.preferenceType, 
                   ", Reference ID: ", userPreference.referenceId, 
                   ", Updated Points: ", updatedPoints);
    } else {
        io:println("No existing preference found to update");
    }

    return "User preference processed successfully";
}
