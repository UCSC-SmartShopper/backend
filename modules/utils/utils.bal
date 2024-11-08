import ballerina/http;
import ballerina/io;
import ballerina/lang.runtime;

public function pagination_values(int count, int page, int _limit) returns int[] {
    if (count == 0) {
        return [0, 0];
    }

    if (page < 1) {
        return [0, 0];
    }

    if (_limit < 1) {
        return [0, 0];
    }

    int _start = (page - 1) * _limit;

    if (_start >= count) {
        return [0, 0];
    }

    int _end = _start + _limit;

    if (_end > count) {
        _end = count;
    }

    return [_start, _end];
}

public function paginateArray(anydata[] array, int page, int _limit) returns anydata[] {
    int offset = (page - 1) * _limit;

    if (_limit <= 0 || offset < 0) {
        return [];
    }

    int totalLength = array.length();

    // If offset is out of bounds, return an empty array
    if (offset >= totalLength) {
        return [];
    }

    // Calculate the end index for slicing
    int endIndex = offset + _limit;
    if (endIndex > totalLength) {
        endIndex = totalLength;
    }

    // Return the sliced portion of the array
    return array.slice(offset, endIndex);
}

public type Pagination record {|
    int count;
    boolean next;
    anydata[] results;
|};

public isolated function paginate(anydata[] array, int page, int _limit) returns Pagination {
    int count = array.length();
    boolean hasNext = count > _limit * page;

    // Paginate the array
    int offset = (page - 1) * _limit;

    if (_limit <= 0 || offset < 0) {
        return {count: 0, next: false, results: []};
    }

    int totalLength = array.length();

    // If offset is out of bounds, return an empty array
    if (offset >= totalLength) {
        return {count: 0, next: false, results: []};
    }

    // Calculate the end index for slicing
    int endIndex = offset + _limit;
    if (endIndex > totalLength) {
        endIndex = totalLength;
    }

    // Return the sliced portion of the array
    return {count: count, next: hasNext, results: array.slice(offset, endIndex)};
}

configurable string HEART_BEAT_URL = ?;

public isolated function sendHeartbeat() {
    while true {
        runtime:sleep(5);
        do {
            http:Client clientEndpoint = check new (HEART_BEAT_URL);
            http:Response _ = check clientEndpoint->get("/heartbeat");
        } on fail {
            io:println("Failed to send heartbeat");
        }
        runtime:sleep(30);
    }
}
