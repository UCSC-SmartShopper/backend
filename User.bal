import ballerina/http;
import ballerina/time;

type NewUser record {|
    string name;
    string email;
    string password;
    string number;
    string profilePic;
|};

// type User record {|
//     *NewUser;
//     readonly int id;
// |};

type ErrorDetails record {
    string message;
    string details;
    time:Utc timestamp;

};

type DataNotFound record {|
    *http:NotFound;
    ErrorDetails body;
|};
