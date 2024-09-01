import backend.connection;
import backend.db;
import backend.reviews;

import ballerina/persist;
import ballerina/io;

type SupermarketsGroupedByName record {|
    string name;
    int[] ids;
|};

public type Earning record {|
    string name;
    float earnings;
|};

public type EarningResponse record {|
    int count;
    string next;
    Earning[] results;
|};

public function get_all_supermarket_earnings() returns EarningResponse|error {

    do {
        db:Client connection = connection:getConnection();

        stream<db:OrderWithRelations, persist:Error?> orderStream = connection->/orders.get();
        db:OrderWithRelations[] orders = check from db:OrderWithRelations _order in orderStream
            // where _order.status == "COMPLETED"
            order by _order.id descending
            select _order;

        stream<db:Supermarket, persist:Error?> supermarketStream = connection->/supermarkets.get();
        SupermarketsGroupedByName[] supermarkets = check from var {id, name} in supermarketStream
            group by name
            select {name, ids: [id]};

        map<float> supermarketsMap = {};

        foreach db:OrderWithRelations _order in orders {
            db:OrderItemsOptionalized[] _orderItems = _order.orderItems ?: [];

            foreach db:OrderItemsOptionalized _orderItem in _orderItems {
                int supermarketId = _orderItem.supermarketId ?: 0;
                float price = _orderItem.price ?: 0;
                int quantity = _orderItem.quantity ?: 0;
                float total = price * quantity;

                supermarketsMap[supermarketId.toBalString()] = (supermarketsMap[supermarketId.toBalString()] ?: 0.0) + total;
            }
        }

        Earning[] earnings = [];
        foreach SupermarketsGroupedByName supermarket in supermarkets {
            float supermarketEarnings = 0;
            foreach int id in supermarket.ids {
                supermarketEarnings += supermarketsMap[id.toBalString()] ?: 0.0;
            }
            earnings.push({name: supermarket.name, earnings: supermarketEarnings});
        }

        return {count: earnings.length(), next: "", results: earnings};

    } on fail {
        return error("Failed to get earnings");
    }
}

public function get_supermarket_earnings(int supermarketId) returns float|error {

    do {
        db:Client connection = connection:getConnection();

        stream<db:OrderWithRelations, persist:Error?> orderStream = connection->/orders.get();
        db:OrderWithRelations[] orders = check from db:OrderWithRelations _order in orderStream
            // where _order.status == "COMPLETED"
            order by _order.id descending
            select _order;

        float supermarketEarnings = 0;
        foreach db:OrderWithRelations _order in orders {
            db:OrderItemsOptionalized[] _orderItems = _order.orderItems ?: [];

            foreach db:OrderItemsOptionalized _orderItem in _orderItems {
                if (_orderItem.supermarketId == supermarketId) {
                    float price = _orderItem.price ?: 0;
                    int quantity = _orderItem.quantity ?: 0;
                    supermarketEarnings += price * quantity;
                }
            }
        }

        return supermarketEarnings;

    } on fail {
        return error("Failed to get earnings");
    }
}

public function get_feedbacks_by_supermarket_id(int supermarketId) returns reviews:ReviewResponse|error {

    db:Client connection = connection:getConnection();

    stream<db:SupermarketItemWithRelations, persist:Error?> supermarketItemStream = connection->/supermarketitems();
    int[] supermarketItemIdList = check from db:SupermarketItemWithRelations supermarketItem in supermarketItemStream
        where supermarketItem.supermarketId == supermarketId
        select supermarketItem.id ?: 0;

    stream<db:Review, persist:Error?> reviewStream = connection->/reviews.get();
    db:Review[] reviews = check from db:Review review in reviewStream
        where review.reviewType == "supermarketItem"
        select review;

    db:ReviewWithRelations[] reviewsWithRelations = [];
    foreach db:Review review in reviews {
        if (supermarketItemIdList.some((i) => i == review.targetId)) {
            reviewsWithRelations.push(review);
        }
    }

    return {count: reviewsWithRelations.length(), next: "", results: reviewsWithRelations};

}

//get_driver_earnings
public function get_driver_earnings(int driverId) returns float|error {
    do {
        db:Client connection = connection:getConnection();

        stream<db:OpportunityWithRelations, persist:Error?> opportunityStream = connection->/opportunities.get();
        db:OpportunityWithRelations[] opportunities = check from db:OpportunityWithRelations accept_opportunity in opportunityStream
             where accept_opportunity.status == "Delivered" && accept_opportunity.driverId == driverId
            select accept_opportunity;

        float driverEarnings = 0.0;

        foreach db:OpportunityWithRelations accept_opportunity in opportunities {
                driverEarnings += accept_opportunity.deliveryCost ?: 0.0;

        }

        return driverEarnings;

    } on fail {
        return error("Failed to get earnings");
    }
}

