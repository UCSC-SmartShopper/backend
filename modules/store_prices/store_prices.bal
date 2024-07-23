// import backend.db;
// import backend.errors;

// import ballerina/http;
// import ballerina/persist;
// import ballerina/time;

// public type Supermarket record {|
//     readonly int id;
//     string name;
//     string contactNo;
//     string logo;
//     string location;
//     string address;
//     int supermarketmanagerId;

// |};

// // public type PriceList record {|
// //     readonly int id;
// //     products:Product product;
// //     Supermarket supermarket;
// //     int quantity;
// //     float price;
// //     float discountedTotal;
// // |};

// public type PriceListResponse record {|
//     int count;
//     string next;
//     db:StorePrice[] results;
// |};

// type PriceListNotFound record {|
//     *http:NotFound;
//     errors:ErrorDetails body;
// |};

// function createPriceListNotFound(int id) returns PriceListNotFound {
//     return {
//         body: {
//             message: "Price List not found",
//             details: string `Price List not found for the given id: ${id}`,
//             timestamp: time:utcNow()
//         }
//     };
// }

// // -------------------------------------------------- Resource Functions --------------------------------------------------

// public final db:Client dbClient = check new ();

// public function getPriceLists() returns PriceListResponse|persist:Error? {
//     stream<db:StorePrice, persist:Error?> prices = dbClient->/storeprices();

//     db:StorePrice[] priceList = check from db:StorePrice price in prices
//         select price;

//     return {count: priceList.length(), next: "null", results: priceList};
// }

// public function getPriceListsByProductId(int productId) returns PriceListResponse|persist:Error? {
//     stream<db:StorePrice, persist:Error?> prices = dbClient->/storeprices(whereClause = `"PriceList"."productId"=${productId}`);
//     db:StorePrice[] priceList = check from PriceList price in prices
//         select price;

//     return {count: priceList.length(), next: "null", results: priceList};
// }

