import backend.connection;
import backend.db;
import backend.errors;

import ballerina/http;
import ballerina/io;
import ballerina/persist;
import ballerina/time;

// import ballerina/io;

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

public type AdvertisementUpdate record {|
    string image?;
    string status?;
    string startDate?;
    string endDate?;
    string priority?;
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

    stream<db:Advertisement, persist:Error?> advertisements = connection->/advertisements; //or .get()
    db:Advertisement[] advertisementList = check from db:Advertisement advertisement in advertisements
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

public function addAdvertisement(AdvertisementInsert advertisementN) returns db:Advertisement|error {
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

public function updateAdvertisement(int id,AdvertisementUpdate advertisement) returns db:Advertisement|AdvertisementNotFound|error? {
    db:Client connection=connection:getConnection();
    db:Advertisement|persist:Error? advertisementG = connection->/advertisements/[id](db:Advertisement);
    if advertisementG is persist:Error {
        return advertisementNotFound(id);
    }
    db:AdvertisementUpdate advertisementUpdate = {
        image: advertisement.image,
        status: advertisement.status,
        startDate: advertisement.startDate,
        endDate: advertisement.endDate,
        priority: advertisement.priority
    };

    db:Advertisement|persist:Error result = connection->/advertisements/[id].put(advertisementUpdate);
    if result is persist:Error {
        return error("Error while updating the advertisement");
    }

}

public function deactivateAdvertisement(int id) returns error? {
    db:Client connection = connection:getConnection();

    // Execute the SQL query
    _ = check connection->executeNativeSQL(`UPDATE "Advertisement" SET "status" = 'Inactive' WHERE "id" = ${id}`);

    io:println("Advertisement status updated successfully.");
}

