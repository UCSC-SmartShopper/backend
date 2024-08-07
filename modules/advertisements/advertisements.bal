import backend.connection;
import backend.db;
import ballerina/persist;

import ballerina/http;
import backend.errors;
import ballerina/time;

public type AdvertisementNotFound record {|
    *http:NotFound;
    errors:ErrorDetails body;
|};

function advertisementNotFound(int id) returns AdvertisementNotFound {
    return {
        body: {
            message: "Advertisement not found",
            details: string `Advertisement not found for the given id: ${id}`,
            timestamp: time:utcNow()
        }
    };
}

public function getAdvertisements() returns db:Advertisement[]|error? {
    db:Client connection = connection:getConnection();

    stream<db:Advertisement, persist:Error?> advertisements = connection->/advertisements.get();
    db:Advertisement[] advertisementList= check from db:Advertisement advertisement in advertisements
        select advertisement;

        return advertisementList;
}

public function getAdvertisementsById(int id) returns db:Advertisement|AdvertisementNotFound|error? {
    db:Client connection = connection:getConnection();
    db:Advertisement|persist:Error? advertisement = connection->/advertisements/[id](db:Advertisement);
    if advertisement is persist:Error {
        return advertisementNotFound(id);
    }
    return advertisement;
}

