
import ballerina/io;

public type Item record {|
    int id;
    string name;
    float price;
    int rating;
    float distance;
    float score;
|};

public function rateItems(Item[] items) returns Item[] {

    float priceWeight = 0.4;
    float ratingWeight = 0.4;
    float distanceWeight = 0.2;

    float maxPrice = 0;
    int maxRating = 0;
    float maxDistance = 0;

    foreach var item in items {
        if (item.price > maxPrice) {
            maxPrice = item.price;
        }
        if (item.rating > maxRating) {
            maxRating = item.rating;
        }
        if (item.distance > maxDistance) {
            maxDistance = item.distance;
        }
    }
    foreach var item in items {
        item.score = (priceWeight * (1 - item.price / maxPrice)) +
                     (ratingWeight * item.rating / maxRating) +
                     (distanceWeight * (1 - item.distance / maxDistance));
    }

    Item[] sorted = from var e in items
                        order by e.score ascending
                        select e;

    

    io:println("Sorted items:");
    foreach var item in sorted {
        io:println(item.id);
    }  
    return sorted;
}

