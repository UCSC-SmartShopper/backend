import backend.connection;
import backend.db;

import ballerina/io;
import ballerina/persist;
import ballerina/regex;

public function distanceCalculation(int[] id, string currentLocation) returns map<float>|error? {
    map<float> distanceMap = {};

    foreach int i in 0 ..< id.length() {
        distanceMap[id[i].toString()] = check calculateShortestDistance(i, currentLocation);
    }

    return distanceMap;
}

public function calculateShortestDistance(int id, string currentLocation) returns float|error {
    do {
        if (id == 0) {
            return error("Supermarket ID is not provided");
        }

        if (currentLocation == "") {
            return error("Current location is not provided");
        }

        io:println(id, currentLocation);

        db:Client connection = connection:getConnection();

        db:Supermarket|persist:Error? supermarket = connection->/supermarkets/[id](db:Supermarket);
        string location;
        if (supermarket is db:Supermarket) {
            location = supermarket.location;
        } else {
            return error("Supermarket not found");
        }

        string[] currentLocationArr = regex:split(currentLocation, ",");
        string[] supermarketLocationArr = regex:split(location, ",");

        float currentLat = check float:fromString(currentLocationArr[0]);
        float currentLon = check float:fromString(currentLocationArr[1]);
        float supermarketLat = check float:fromString(supermarketLocationArr[0]);
        float supermarketLon = check float:fromString(supermarketLocationArr[1]);
        float x = (currentLat - supermarketLat).pow(2) + (currentLon - supermarketLon).pow(2);

        return x.sqrt();
    } on fail {
        return error("Error in distance calculation");
    }
}
