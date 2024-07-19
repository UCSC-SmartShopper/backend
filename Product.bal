import ballerina/http;


type ProductNotFound record {|
    *http:NotFound;
    ErrorDetails body;
|};
