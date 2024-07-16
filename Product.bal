import ballerina/http;

type Product record {|
    readonly string itemID;
    string name;
    string description;
    float price;
    string imageUrl;
|};

type ProductNotFound record {|
    *http:NotFound;
    ErrorDetails body;
|};
