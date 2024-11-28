
import ballerina/io;
import backend.cart;
import backend.supermarket_items;
import backend.db;
import backend.connection;
import ballerina/persist;
// import ballerina/regex;


public type Item record {|
    cart:CartItemResponse itemResponse;
    float score;

|};



// public function rateItems(supermarket_items:SupermarketItemResponse items , string location) returns Item[] {

//     float priceWeight = 0.4;
//     float ratingWeight = 0.4;
//     float distanceWeight = 0.2;
//     float userPreferenceWeight = 0.1;

//     float maxPrice = 0;
//     int maxRating = 0;
//     float maxDistance = 0;
//     float maxUserPreference = 0;


//     string[] locations = regex:split(location, ",");
//     float distance = 5;
//         float userPreference = 0;

//     foreach var item in items.results {

//         if (item.price > maxPrice) {
//             maxPrice = <float>item.price;
//         }
        

//         var locationSuperMarket = item.supermarket?.location;
      

//         if (distance > maxDistance) {
//             maxDistance = distance;
//         }


//         if (userPreference> maxUserPreference){
//             maxUserPreference = userPreference;
//         }
//     }
//     foreach var item in items.results {
//         float price = <float>item.price;
//         float score = (priceWeight * (1 - price / maxPrice)) +
//                     // (ratingWeight * item.rating / maxRating) +
//                     (distanceWeight * (1 - distance / maxDistance)) +
//                     (userPreferenceWeight * (1 - userPreference / maxUserPreference));

//         // cart:CartItem itemResponse = {
//         //     id: item.id,
//         //     supermarketItem: item,
//         //     quantity: 1
//         // };

//         // Item itemRecord = {
//         //     itemResponse: item,
//         //     score: score
//         // };

        

//     }

//     // Item[] sorted = from var e in items
//     //                     order by e.score ascending
//     //                     select e;

    

//     io:println("Sorted items:");
//     foreach var item in sorted {
//         io:println(item.id);
//     }  
//     return sorted;
// }

public function get_supermarket_items_by_product_id( int productId) returns supermarket_items:SupermarketItemResponse|error {

    db:Client connection = connection:getConnection();

    stream<db:SupermarketItemWithRelations, persist:Error?> supermarketitems = connection->/supermarketitems();
    db:SupermarketItemWithRelations[] supermarketItem = check from db:SupermarketItemWithRelations supermarketitem in supermarketitems
        where supermarketitem.productId == productId
        order by supermarketitem.id
        select supermarketitem;

    return {count: supermarketItem.length(), next: "null", results: supermarketItem};
}

public function OptimizeCart(int userId, string location) returns error? {
    // Retrieve cart items for the given user ID
    var cartItemsResult = cart:getCartItems(userId);
    if (cartItemsResult is cart:CartItemResponse) {
        io:println("Cart items retrieved successfully for user ID ", userId, ":");

        foreach var cartItem in cartItemsResult.results {
            io:println("id: ", cartItem.id); 
            var similarItemsResult = check get_supermarket_items_by_product_id(cartItem.productId ?: 0);
            foreach var item in similarItemsResult.results {
                io:println("Item id: ", item);
                io:println("....... ");
            }
            

        }
    } else if (cartItemsResult is error) {
        io:println("Error retrieving cart items for user ID ", userId, ": ", cartItemsResult.message());
        return cartItemsResult;
    }

    
}


