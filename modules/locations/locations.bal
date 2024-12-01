import backend.supermarkets;

import ballerina/io;
import ballerina/regex;

public type OptimizedRoute record {|
    int[] supermarketIds;
    float totalDistance;
    float deliveryCost;
|};

public function get_consumer_supermarket_distance(string location1, string location2) returns float|error {
    do {

        float[] homeCoordinates = check get_coordinates(location1);
        float[] supermarketCoordinates = check get_coordinates(location2);

        return calculateDistance(homeCoordinates, supermarketCoordinates);
    } on fail {
        return error("Error while calculating distance");
    }
}

public function get_coordinates(string address) returns float[]|error {
    string[] splitedAddress = regex:split(address, ",");

    if (splitedAddress.length() == 2) {
        float[] coordinates = [];

        foreach string part in splitedAddress {
            float result = check float:fromString(string:trim(part));
            coordinates.push(result);
        }
        return coordinates;
    }
    return error("Invalid address");
}

public function calculate_distance(float[] homeCoordinates, float[] supermarketCoordinates) returns float {
    float factor = 145;

    float x1 = homeCoordinates[0];
    float y1 = homeCoordinates[1];
    float x2 = supermarketCoordinates[0];
    float y2 = supermarketCoordinates[1];

    return (float:sqrt(float:pow(x2 - x1, 2) + float:pow(y2 - y1, 2)) * factor);
}

function calculateDistance(float[] homeCoordinates, float[] supermarketCoordinates) returns float {
    final float EARTH_RADIUS = 6371.0;

    float lat1 = homeCoordinates[0];
    float lon1 = homeCoordinates[1];
    float lat2 = supermarketCoordinates[0];
    float lon2 = supermarketCoordinates[1];

    float lat1Rad = lat1 * float:PI / 180;
    float lon1Rad = lon1 * float:PI / 180;
    float lat2Rad = lat2 * float:PI / 180;
    float lon2Rad = lon2 * float:PI / 180;

    // Calculate differences
    float dLat = lat2Rad - lat1Rad;
    float dLon = lon2Rad - lon1Rad;

    // Apply Haversine formula
    float a =
        float:pow(float:sin(dLat / 2), 2) +
        float:cos(lat1Rad) * float:cos(lat2Rad) * float:pow(float:sin(dLon / 2), 2);

    float c = 2 * float:atan2(float:sqrt(a), float:sqrt(1 - a));

    // Distance in kilometers
    return EARTH_RADIUS * c;
}

// ------------------------ Delivery Cost ------------------------
public function get_delivery_cost(string[] supermarketLocations, string deliveryLocation) returns float|error {
    float baseCost = 150;
    float costPerKm = 30;

    float totalDistance = 0;

    foreach string location in supermarketLocations {
        float distance = check get_consumer_supermarket_distance(deliveryLocation, location);
        totalDistance += distance;
    }

    return (totalDistance * costPerKm) + baseCost;
}

// ------------------------ getOptimizedRoute ------------------------
isolated map<float> distanceMap = {};

public function getOptimizedRoute(int[] supermarketIds, string homeLocation) returns OptimizedRoute|error {
    if supermarketIds.length() == 0 {
        return error("No supermarkets found");
    }
    if homeLocation == "" {
        return error("Invalid home location");
    }
    // supermarket id -> supermarket location
    map<string> locationMap = {};
    supermarkets:SupermarketResponse supermarketList = check supermarkets:get_supermarkets();

    // Get the coordinates of the all supermarkets
    foreach var supermarket in supermarketList.results {
        if (supermarketIds.indexOf(supermarket.id ?: -1) > -1) {
            string location = supermarket.location ?: "";
            if (location != "") {
                locationMap[supermarket.id.toString()] = location;
            }
        }
    }

    foreach int supermarketId in supermarketIds {
        float|error distance = get_consumer_supermarket_distance(homeLocation, locationMap[supermarketId.toString()] ?: "");
        if (distance is float) {
            lock {
                distanceMap[supermarketId.toString()] = distance;
            }
        }
    }

    // string[] sortedSupermarketIds = supermarketIds.sort(
    int[] sortedLocationIds = supermarketIds.sort("descending", isolated function(int i) returns float {
        lock {
            return distanceMap[i.toString()] ?: 0;
        }
    });

    // ---------------------- Calculate the delivery cost ----------------------
    float baseCost = 150;
    float costPerKm = 30;

    float totalDistance = 0;

    string[] waypoints = [];
    foreach int id in sortedLocationIds {
        waypoints.push(locationMap[id.toString()] ?: "");
    }
    waypoints.push(homeLocation);

    int i = 0;
    while i < waypoints.length() - 1 {
        float distance = check get_consumer_supermarket_distance(waypoints[i], waypoints[i + 1]);
        totalDistance += distance;
        i += 1;
    }

    float deliveryCost = (totalDistance * costPerKm) + baseCost;

    io:println("Total distance: " + totalDistance.toString());
    io:println("Delivery cost: " + deliveryCost.toString());

    return {supermarketIds: sortedLocationIds, totalDistance: totalDistance, deliveryCost: deliveryCost};
}



function getOrderedId(string id, float[] orderedIdList, map<int> indexMap) returns float {
    int index = indexMap[id] ?: 0;
    return orderedIdList[index];
}


