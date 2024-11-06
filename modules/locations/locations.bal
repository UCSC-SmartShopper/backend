import backend.auth;
import backend.connection;
import backend.db;

import ballerina/regex;

public function get_consumer_supermarket_distance(auth:User user, string location) returns float|error {
    do {
        db:Client connection = connection:getConnection();
        int consumerId = user.consumerId ?: -1;

        db:ConsumerWithRelations consumer = check connection->/consumers/[consumerId](db:ConsumerWithRelations);

        db:AddressOptionalized[] addresses = consumer.addresses ?: [];

        float[] homeCoordinates = [];
        float[] supermarketCoordinates = check get_coordinates(location);

        foreach db:AddressOptionalized address in addresses {
            boolean isDefault = address.isDefault ?: false;
            string addressString = address.location ?: "";

            if (isDefault) {
                homeCoordinates = check get_coordinates(addressString);
                break;
            }
        }

        // homeCoordinates = [6.8555632, 79.9092448];
        // supermarketCoordinates = [6.8577889, 79.9059171];

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

