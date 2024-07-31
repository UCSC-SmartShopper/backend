// import backend.db;
// import backend.errors;

// import ballerina/http;
// import ballerina/persist;
// import ballerina/time;

// public type Consumer record {|
//     readonly int id;
//     string name;
//     string description;
//     float price;
//     string imageUrl;
// |};

// public type ProductResponse record {|
//     int count;
//     string next;
//     Product[] results;
// |};

// type ProductNotFound record {|
//     *http:NotFound;
//     errors:ErrorDetails body;
// |};

// function createProductNotFound(int id) returns ProductNotFound {
//     return {
//         body: {
//             message: "Product not found",
//             details: string `Product not found for the given id: ${id}`,
//             timestamp: time:utcNow()
//         }
//     };
// }

// public final db:Client dbClient = check new ();

// public function getProducts() returns ProductResponse|persist:Error? {
//     stream<Consumer, persist:Error?> products = dbClient->/products.get();
//     Consumer[] productList = check from Product product in products
//         select product;

//     return {count: productList.length(), next: "null", results: productList};
// }

// public function getConsumerById(int id) returns ProductNotFound|typedesc<Consumer> {
//     Consumer|persist:Error? product = dbClient->/users/[id](Consumer);
//     if Consumer is persist:Error {
//         return createProductNotFound(id);
//     }
//     return Consumer;
// }

