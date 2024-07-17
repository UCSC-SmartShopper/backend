import ballerina/persist as _;

type User record {|
    readonly int id;
    string name;
    string email;
    string number;
|};

type Product record {|
    readonly int itemID;
    string name;
    string description;
    float price;
    string imageUrl;
|};

