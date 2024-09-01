// import backend.connection;
// import backend.db;
// import backend.errors;

// import ballerina/http;
// import ballerina/persist;
// import ballerina/time;

public type monthlySale record {|
    string month;
    int sales;
|};

public type salesResponse record {|
    monthlySale[] results;
|};

// public function getSales() returns salesResponse|persist:Error? {
//     db:Client connection = connection:getConnection();
//     stream<monthlySale, persist:Error?> sales = connection->/sales.get();
//     monthlySale[] salesList = check from monthlySale sale in sales
//         select sale;

//     return {results: salesList};
// }
