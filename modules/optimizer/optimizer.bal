
import ballerina/io;
import backend.cart;
import backend.supermarket_items;
import backend.db;
import backend.connection;
import ballerina/persist;
// import ballerina/regex;


public type ScoredItem record {|
    int ItemId?;
    float score;
    int supermarketitemId?;
    int quantity?;
    int productId?;
    int SupermarketId?;
    db:SupermarketItem supermarketItem?;

|};

public function get_supermarket_items_by_product_id( int productId) returns supermarket_items:SupermarketItemResponse|error {

    db:Client connection = connection:getConnection();

    stream<db:SupermarketItemWithRelations, persist:Error?> supermarketitems = connection->/supermarketitems();
    db:SupermarketItemWithRelations[] supermarketItem = check from db:SupermarketItemWithRelations supermarketitem in supermarketitems
        where supermarketitem.productId == productId
        order by supermarketitem.id
        select supermarketitem;

    return {count: supermarketItem.length(), next: "null", results: supermarketItem};
}

public function rateItems(supermarket_items:SupermarketItemResponse items, string location, int? quantity) returns ScoredItem[] {
    float priceWeight = 0.4;
    float distanceWeight = 0.2;
    float userPreferenceWeight = 0.1;

    float maxPrice = 0;
    float maxDistance = 0;
    float maxUserPreference = 0;

    float distance = 5;
    float userPreference = 0;

    // Calculate maximum values for normalization
    foreach var item in items.results {

        io:println("similar item from other supermarkets Items : ", item);

        var supermarketLocation = item.productId;
        var locationSuperMarket = item.supermarket?.location;

        if (item.price > maxPrice) {
            maxPrice = <float>item.price;
        }
        
      
        if (distance > maxDistance) {
            maxDistance = distance;
        }
        if (userPreference> maxUserPreference){
            maxUserPreference = userPreference;
        }
    }

    maxPrice = maxPrice == 0.0 ? 1.0 : maxPrice;
    maxDistance = maxDistance == 0.0 ? 1.0 : maxDistance;
    maxUserPreference = maxUserPreference == 0.0 ? 1.0 : maxUserPreference;

    ScoredItem[] scoredItems = [];

    foreach var item in items.results {
        float price = <float>item.price;
        float score = (priceWeight * (1 - price / maxPrice) * <float>(quantity ?: 1)) +
                      (distanceWeight * (1 - distance / maxDistance)) +
                      (userPreferenceWeight * (1 - userPreference / maxUserPreference));

        io:println("Score for item ID ", item.id, ": ", score);

        scoredItems.push({
            ItemId: item.id,
            SupermarketId: item.supermarketId,
            score: score,
            supermarketitemId: item.supermarketId,
            quantity: quantity,
            productId: item.productId,
            supermarketItem : {
                id: item.id ?: 0,
                
                price: item.price ?: 0.0,
                discount: item.discount ?: 0.0,
                availableQuantity: item.availableQuantity ?: 0,
                productId: item.productId ?:0 ,
                supermarketId: item.supermarketId ?: 0}
        });
    }

    return scoredItems;
}

public function OptimizeCart(int userId, string location) returns json|error {
    var cartItemsResult = cart:getCartItems(userId);

    ScoredItem[] bestItems = [];
    
    if (cartItemsResult is cart:CartItemResponse) {
        io:println("Cart items retrieved successfully for user ID ", userId, ":");

        foreach var cartItem in cartItemsResult.results {
            io:println("Cart Item ID: ", cartItem.id); 
            int? quantity = cartItem.quantity;

            var similarItemsResult = check get_supermarket_items_by_product_id(cartItem.productId ?: 0);
            
            ScoredItem[] scoredItems = rateItems(similarItemsResult, location, quantity);
            ScoredItem[] sortedItems = from var e in scoredItems
                                       order by e.score descending
                                       select e;
            ScoredItem bestItem = sortedItems[0];
            bestItems.push(bestItem);
        }
        
        // Convert best items to JSON format
        json[] resultArray = [];
        foreach var bestItem in bestItems {
            resultArray.push({
                "ItemId": bestItem.ItemId,
                "score": bestItem.score,
                "SupermarketId": bestItem.SupermarketId,
                "supermarketitemId": bestItem.supermarketitemId,
                "quantity": bestItem.quantity,
                "productId": bestItem.productId,
                "supermarketItem": {
                    "id": bestItem.supermarketItem?.id ?: 0,
                    "price": bestItem.supermarketItem?.price ?: 0.0,
                    "discount": bestItem.supermarketItem?.discount ?: 0.0,
                    "availableQuantity": bestItem.supermarketItem?.availableQuantity ?: 0,
                    "productId": bestItem.supermarketItem?.productId ?: 0,
                    "supermarketId": bestItem.supermarketItem?.supermarketId ?: 0
                }
            });
        }
        json result = resultArray;
        return result; // Return the best items in JSON format
    } else if (cartItemsResult is error) {
        io:println("Error retrieving cart items for user ID ", userId, ": ", cartItemsResult.message());
        return cartItemsResult;
    }
}



