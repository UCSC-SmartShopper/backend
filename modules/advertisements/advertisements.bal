import backend.connection;
import backend.db;
import ballerina/persist;

import ballerina/http;
import backend.errors;

public type AdvertisementNotFound record {|
    *http:NotFound;
    errors:ErrorDetails body;
|};

public function getAdvertisements() returns db:Advertisement[]|error? {
    db:Client connection = connection:getConnection();

    stream<db:Advertisement, persist:Error?> advertisements = connection->/advertisements.get();
    db:Advertisement[] advertisementList= check from db:Advertisement advertisement in advertisements
        select advertisement;

        return advertisementList;
}