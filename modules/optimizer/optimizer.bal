import backend.cart;
import backend.connection;
import backend.db;
import backend.distanceCalculation;
import backend.user_preference;

import ballerina/io;
import ballerina/persist;

public type ScoredItem record {|
    int consumerId?;
    int ItemId?;
    float score;
    int supermarketitemId?;
    int quantity?;
    int productId?;
    int SupermarketId?;
    db:SupermarketItem supermarketItem?;
|};

public function get_supermarket_items_by_product_id(int productId) returns db:SupermarketItemWithRelations[]|error {

    db:Client connection = connection:getConnection();

    stream<db:SupermarketItemWithRelations, persist:Error?> supermarketItemStream = connection->/supermarketitems();
    db:SupermarketItemWithRelations[] supermarketItems = check from db:SupermarketItemWithRelations supermarketitem in supermarketItemStream
        where supermarketitem.productId == productId
        order by supermarketitem.id
        select supermarketitem;

    return supermarketItems;
}

public function rateItems(db:SupermarketItemWithRelations[] items, string location, int? quantity, int userId) returns ScoredItem[]|error {
    float priceWeight = 0.4;
    float distanceWeight = 0.2;
    float userPreferenceWeight = 0.1;

    float maxPrice = 0;
    float maxDistance = 0;
    float maxUserPreference = 0;

    // float userPreference = 0;

    // Calculate maximum values for normalization
    foreach var item in items {

        float distance = check distanceCalculation:calculateShortestDistance(item.supermarketId ?: 0, location);
        float userPreference = check user_preference:getUserPreferencesByIdandProductId(userId, item.productId ?: 0);

        if (item.price > maxPrice) {
            maxPrice = <float>item.price;
        }

        if (distance > maxDistance) {
            maxDistance = distance;
        }
        if (userPreference > maxUserPreference) {
            maxUserPreference = userPreference;
        }
    }

    maxPrice = maxPrice == 0.0 ? 1.0 : maxPrice;
    maxDistance = maxDistance == 0.0 ? 1.0 : maxDistance;
    maxUserPreference = maxUserPreference == 0.0 ? 1.0 : maxUserPreference;

    ScoredItem[] scoredItems = [];

    foreach var item in items {
        float price = <float>item.price;
        io:println("Price: ", location);
        float distance = check distanceCalculation:calculateShortestDistance(item.supermarketId ?: 0, location);
        float userPreference = check user_preference:getUserPreferencesByIdandProductId(userId, item.productId ?: 0);
        float score = (priceWeight * (<float>1 - price / maxPrice) * <float>(quantity ?: 1)) +
                    (distanceWeight * (1 - distance / maxDistance)) +
                    (userPreferenceWeight * (1 - userPreference / maxUserPreference));

        scoredItems.push({
            ItemId: item.id,
            SupermarketId: item.supermarketId,
            score: score,
            supermarketitemId: item.supermarketId,
            quantity: quantity,
            productId: item.productId,
            supermarketItem: {
                id: item.id ?: 0,
                
                price: item.price ?: 0.0,
                discount: item.discount ?: 0.0,
                availableQuantity: item.availableQuantity ?: 0,
                productId: item.productId ?: 0,
                supermarketId: item.supermarketId ?: 0}
        });
    }

    return scoredItems;
}

public function OptimizeCart(int consumerId, string location) returns db:CartItemWithRelations[]|error {
    do {
        if (consumerId == 0) {
            return error("Consumer ID is not provided");
        }

        if (location == "") {
            return error("Location is not provided");
        }

        cart:CartItemResponse|error cartItemsResult = cart:getCartItems(consumerId);

        if cartItemsResult is error {
            return cartItemsResult;
        }

        db:CartItemWithRelations[] OptimizedCart = [];

        foreach db:CartItemWithRelations cartItem in cartItemsResult.results {
            db:SupermarketItemWithRelations[] similarSupermarketItems = check get_supermarket_items_by_product_id(cartItem.productId ?: 0);
            ScoredItem[]|error scoredItems = rateItems(similarSupermarketItems, location, cartItem.quantity, consumerId);

            // Sort the scored items in descending order
            ScoredItem[] sortedItems = from var e in check scoredItems
                order by e.score descending
                select e;

            ScoredItem bestItem;
            do {
                bestItem = sortedItems[0];
            } on fail {
                return error("Error in sorting the scored items");
            }

            OptimizedCart.push({
                    orderId: -1,
                    id: bestItem.ItemId ?: 0,
                    supermarketitemId: bestItem.SupermarketId ?: 0,
                    quantity: bestItem.quantity ?: 0,
                    productId: bestItem.productId ?: 0,
                    consumerId: consumerId,
                    supermarketItem: {
                        "id": bestItem.supermarketItem?.id ?: 0,
                        "price": bestItem.supermarketItem?.price ?: 0.0,
                        "discount": bestItem.supermarketItem?.discount ?: 0.0,
                        "availableQuantity": bestItem.supermarketItem?.availableQuantity ?: 0,
                        "productId": bestItem.supermarketItem?.productId ?: 0,
                        "supermarketId": bestItem.supermarketItem?.supermarketId ?: 0
                    }
                });
        }

        return OptimizedCart;
    }
    on fail {
        return error("Error in optimizing the cart");
    }
}
