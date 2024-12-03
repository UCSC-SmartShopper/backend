import backend.stats;
import backend.db;
import ballerina/persist;
import backend.connection;

public type supermarketEarningsDashboard record {
    float|error totEarnings;
    float totMonthEarnings;
    float totMonthEarningstoPay;
};






public function get_supermarket_earnings_by_month(int supermarketId, int month) returns json|error {
    float|error totEarnings = stats:get_supermarket_earnings(supermarketId);
    float totMonthEarnings = 0;
    float totMonthEarningstoPay = 0;

    do {
        db:Client connection = connection:getConnection();

        stream<db:OrderWithRelations, persist:Error?> orderStream = connection->/orders.get();
        db:OrderWithRelations[] orders = check from db:OrderWithRelations _order in orderStream
            order by _order.id descending
            select _order;

        foreach db:OrderWithRelations _order in orders {
            db:OrderItemsOptionalized[] _orderItems = _order.orderItems ?: [];
            
            if (_order.orderPlacedOn?.month == month && _order.status == "ToPay") {
                foreach db:OrderItemsOptionalized _orderItem in _orderItems {
                    if (_orderItem.supermarketId == supermarketId) {
                        float price = _orderItem.price ?: 0;
                        int quantity = _orderItem.quantity ?: 0;
                        totMonthEarningstoPay += price * quantity;
                    }
                }
            }
        }

        foreach db:OrderWithRelations _order in orders {
            db:OrderItemsOptionalized[] _orderItems = _order.orderItems ?: [];
            
            if (_order.orderPlacedOn?.month == month) {
                foreach db:OrderItemsOptionalized _orderItem in _orderItems {
                    if (_orderItem.supermarketId == supermarketId) {
                        float price = _orderItem.price ?: 0;
                        int quantity = _orderItem.quantity ?: 0;
                        totMonthEarnings += price * quantity;
                    }
                }
            }
        }

        // Create a JSON object from the record.
        json dashboard = {
            "totEarnings": totEarnings is float ? totEarnings : "Error retrieving total earnings",
            "totMonthEarnings": totMonthEarnings,
            "totMonthEarningstoPay": totMonthEarningstoPay
        };

        return dashboard;

    } on fail {
        return error("Failed to get earnings");
    }
}

public function get_supermarket_Order_stat(int supermarketId, int month) returns json|error {
    int Processing = 0;
    int Prepared = 0;
    int totOrdersPaid = 0;
    int totOrdersMonth = 0;
    int totOrders = 0;

    do {
        db:Client connection = connection:getConnection();

        stream<db:OrderWithRelations, persist:Error?> orderStream = connection->/orders.get();
        db:OrderWithRelations[] orders = check from db:OrderWithRelations _order in orderStream
            order by _order.id descending
            select _order;

        foreach db:OrderWithRelations _order in orders {
            db:OrderItemsOptionalized[] _orderItems = _order.orderItems ?: [];
            
            if (_order.orderPlacedOn?.month == month && _order.status == "Processing") {
                foreach db:OrderItemsOptionalized _orderItem in _orderItems {
                    if (_orderItem.supermarketId == supermarketId) {
                        Processing += 1;
                    }
                }
            }

            if (_order.orderPlacedOn?.month == month && _order.status == "Prepared") {
                foreach db:OrderItemsOptionalized _orderItem in _orderItems {
                    if (_orderItem.supermarketId == supermarketId) {
                        Prepared += 1;
                    }
                }
            }

            if (_order.orderPlacedOn?.month == month && _order.status == "ToPay") {
                foreach db:OrderItemsOptionalized _orderItem in _orderItems {
                    if (_orderItem.supermarketId == supermarketId) {
                        totOrdersPaid += 1;
                    }
                }
            }

            if (_order.orderPlacedOn?.month == month) {
                foreach db:OrderItemsOptionalized _orderItem in _orderItems {
                    if (_orderItem.supermarketId == supermarketId) {
                        totOrdersMonth += 1;
                    }
                }
            }

            foreach db:OrderItemsOptionalized _orderItem in _orderItems {
                if (_orderItem.supermarketId == supermarketId) {
                    totOrders += 1;
                }
            }



            
        }

        

        // Create a JSON object from the record.
        json dashboard = {
            "Processing": Processing,
            "Prepared": Prepared,
            "totOrdersPaid": totOrdersPaid,
            "totOrdersMonth": totOrdersMonth,
            "totOrders": totOrders
        };

        return dashboard;

    } on fail {
        return error("Failed to get earnings");
    }
}





public function supermarket_Earnings(int supermarketId) returns float|error {
    float|error earnings = stats:get_supermarket_earnings(supermarketId);

    if (earnings is error) {
        return error("Failed to get earnings");
    }



    return earnings;
}