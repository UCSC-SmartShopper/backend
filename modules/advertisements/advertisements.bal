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

public type AdvertisementInsert record {|
    string image;
    string status;
    string startDate;
    string endDate;
    string priority;
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

public function addAdvertisement(AdvertisementInsert advertisementN) returns db:Advertisement|error{
    db:Client connection = connection:getConnection();
    db:AdvertisementInsert advertisementInsert = {
        image: advertisementN.image,
        status: advertisementN.status,
        startDate: advertisementN.startDate,
        endDate: advertisementN.endDate,
        priority: advertisementN.priority
    };
    int[]|persist:Error result = connection->/advertisements.post([advertisementInsert]);

    if result is persist:Error {
        return error("Error while adding the advertisement");
    }
    db:Advertisement advertisement = {...advertisementInsert, id: result[0]};
    return advertisement;


}

