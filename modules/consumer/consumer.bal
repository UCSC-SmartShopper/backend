import backend.auth;
import backend.connection;
import backend.db;
import backend.user;
import backend.utils;

import ballerina/http;
import ballerina/persist;

public type ConsumerResponse record {|
    int count;
    string next;
    Consumer[] results;
|};

public type Consumer record {|
    *db:ConsumerOptionalized;
    user:User user;
    db:AddressOptionalized[] addresses?;
    db:OpportunityOptionalized[] opportunity?;
|};

public function get_all_consumers(string searchText, int month, int page, int _limit) returns ConsumerResponse|http:Unauthorized|error {

    // string[] authorizedRoles = ["Admin", "SupermarketManager", "Consumer"];

    // if !authorizedRoles.some((role) => role == user.role) {
    //     return http:UNAUTHORIZED;
    // }

    db:Client connection = connection:getConnection();
    stream<Consumer, persist:Error?> consumers = connection->/consumers.get();
    Consumer[] consumerList = check from Consumer consumer in consumers
        where
            (searchText == "" || consumer.user.name.toLowerAscii().includes(searchText.toLowerAscii())) &&
            (month == 0 || consumer.user.createdAt.month == month)
        order by consumer.id descending
        select consumer;

    // pagination
    do {
        int[] pagination_values = utils:pagination_values(consumerList.length(), page, _limit);
        consumerList = consumerList.slice(pagination_values[0], pagination_values[1]);
    } on fail {
        return error("Pagination failed");
    }

    return {count: consumerList.length(), next: "null", results: consumerList};
}

public function get_consumer(auth:User user, int id) returns Consumer|error {
    db:Client connection = connection:getConnection();

    Consumer|persist:Error result = connection->/consumers/[id](Consumer);

    return result;
}
