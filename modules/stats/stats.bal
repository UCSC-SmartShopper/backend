import backend.connection;
import backend.db;

import ballerina/persist;

type SupermarketsGroupedByName record {|
    string name;
    int[] ids;
|};

public type Earning record {|
    string name;
    float earnings;
|};

public function get_all_supermarket_earnings() returns Earning[]|error {

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

        return earnings;

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
