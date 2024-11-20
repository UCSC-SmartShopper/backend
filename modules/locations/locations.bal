import backend.supermarkets;
import backend.utils;

import ballerina/regex;

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

// function optimizeCart(int[] productIds, int[] homeCoordinates) {
// productIds -> supermarket_items okkoma kadawal

// goal -> minimize the cost of the cart + (total travel distance )* cost_per_km

// return [supermarket_items]

// }

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
public function getOptimizedRoute(int[] supermarketIds, string homeLocation) returns string[]|error {

    // supermarket id -> supermarket location
    map<string> locationMap = {};
    locationMap["0"] = homeLocation;

    // supermarket id -> index of coordinates in allCoordinates
    map<int> indexMap = {};
    indexMap["0"] = 0;

    // All coordinates list including the home location
    float[][] allCoordinates = [check get_coordinates(homeLocation)];

    supermarkets:SupermarketResponse supermarketList = check supermarkets:get_supermarkets();

    // Get the coordinates of the all supermarkets
    foreach var supermarket in supermarketList.results {
        if (supermarketIds.indexOf(supermarket.id ?: -1) > -1) {
            string location = supermarket.location ?: "";
            if (location != "") {
                locationMap[supermarket.id.toString()] = location;
                allCoordinates.push(check get_coordinates(location));
                indexMap[supermarket.id.toBalString()] = allCoordinates.length() - 1;
            }
        }
    }

    float[] orderedIdList = utils:dijkstra(allCoordinates, calculate_distance);

    // Sort the supermarkets based on the distance from the home location
    // string[] sortedSupermarketIds = locationMap.keys().sort("descending",  function(string[] i) returns float[] {
    //     return i.map(id =>  orderedIdList[(indexMap[id]) ?: 0]);
    // });

    float[] & readonly orderedIdListReadonly = orderedIdList.cloneReadOnly();

    // string[] sortedSupermarketIds = locationMap.keys().sort("descending", x => getOrderedId(x, orderedIdListReadonly, indexMap));

    return ["1", "2", "3"];
}

public function dikstra(float[][] allCoordinates) returns int[] {
    int[] orderedIdList = [];

    // Implement the dikstra algorithm here

    return orderedIdList;
}

// function sortSupermarketsBasedOnDistance(string[] supermarketIds, string homeLocation) returns string[] {

function getOrderedId(string id, float[] orderedIdList, map<int> indexMap) returns float {
    int index = indexMap[id] ?: 0;
    return orderedIdList[index];
}

