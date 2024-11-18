import ballerina/io;


public type UserPreference record {|
    int preferenceId;
    int userId;
    string preferenceType;
    int referenceId;
    int rank;
|};


map<int> preferenceWeights = {
    "Clicks": 1,
    "Purchases": 5,
    "Favorites": 4,
    "Search history": 2,
    "Time spent on items": 3,
    "Ratings or Reviews": 5
};

// temp 
record {| int userId; int referenceId; string preferenceType; int interactionCount; |}[] userInteractions = [
    {userId: 1, referenceId: 101, preferenceType: "Clicks", interactionCount: 10},
    {userId: 1, referenceId: 101, preferenceType: "Purchases", interactionCount: 2},
    {userId: 1, referenceId: 102, preferenceType: "Favorites", interactionCount: 1},
    {userId: 1, referenceId: 103, preferenceType: "Search history", interactionCount: 5},
    {userId: 1, referenceId: 101, preferenceType: "Time spent on items", interactionCount: 20},
    {userId: 1, referenceId: 101, preferenceType: "Ratings or Reviews", interactionCount: 1}
];


function calculateRank(UserPreference userPreference) returns int? {

    int? weight = preferenceWeights[userPreference.preferenceType];

    int interactionCount = 0;
    foreach var interaction in userInteractions {
        if interaction.userId == userPreference.userId && interaction.referenceId == userPreference.referenceId && 
           interaction.preferenceType == userPreference.preferenceType {
            interactionCount = interaction.interactionCount;
            break;
        }
    }

    return interactionCount * weight;
}

public function addUserPreference(UserPreference userPreference) returns string {

    int? rank = calculateRank(userPreference);



    io:println("User preference added successfully");
    io:println("User ID: ", userPreference.userId , ", Preference Type: ", userPreference.preferenceType, ", Reference ID: ", userPreference.referenceId, ", Rank: ", rank);

    return "User preference added successfully";
}
