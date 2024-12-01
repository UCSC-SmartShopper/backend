import backend.auth;
import backend.connection;
import backend.consumer;
import backend.db;

import ballerina/crypto;
import ballerina/http;
import ballerina/io;
import ballerina/persist;
import backend.orders;

configurable string merchant_id = ?;
configurable string merchantSecret = ?;

configurable string return_url = ?;
configurable string cancel_url = ?;
configurable string notify_url = ?;

public type payhereRequest record {|
    string merchant_id;

    string return_url;
    string cancel_url;
    string notify_url;

    int order_id;
    string first_name;
    string last_name;
    string email;
    string phone;
    string address;
    string city;
    string country;
    string items;
    string currency;
    decimal amount;
    string hash;
|};

public type payhereAuthorizationRequest record {|
    string merchant_id;
    string order_id;
    string payhere_amount;
    string payhere_currency;
    string status_code;
    string md5sig;
    string status_message;
    string authorization_token;
    string custom_1;
    string custom_2;
    string method;
    string card_holder_name;
    string card_no;
    string card_expiry;
    string payment_id;
    string recurring;
    string captured_amount;

|};

public function get_order_payment(auth:User authUser, int orderId) returns payhereRequest|http:Unauthorized|error {

    consumer:Consumer|http:Unauthorized|error consumer = consumer:get_consumer(authUser, authUser.consumerId ?: -1);
    if !(consumer is consumer:Consumer) {
        return consumer;
    }

    // Get Order details
    db:Client connection = connection:getConnection();
    db:OrderWithRelations|persist:Error _order = connection->/orders/[orderId]();

    if _order is persist:Error {
        return _order;
    }

    string amountStr = (_order.totalCost ?: 100.00).toFixedString(2);
    decimal amount = check decimal:fromString(amountStr);
    io:println(amount);
    string currency = "LKR";

    payhereRequest payload = {
        merchant_id: merchant_id,

        return_url: return_url,
        cancel_url: cancel_url,
        notify_url: notify_url,

        order_id: orderId,
        first_name: consumer.user.name,
        last_name: "Last Name",
        email: consumer.user.email,
        phone: consumer.user.number,
        address: _order.shippingAddress ?: "Address",
        city: _order.shippingAddress ?: "City",
        country: "Sri Lanka",
        items: orderId.toString(),
        currency: currency,
        amount: amount,

        hash: get_hash(merchant_id, orderId, amount, currency)
    
    };

    return payload;

}

public function get_hash(string merchantId, int orderId, decimal amount, string currency) returns string {

    string hashedSecret = getMd5Hash(merchantSecret).toUpperAscii();
    string allStrings = merchantId + orderId.toString() + amount.toString() + currency + hashedSecret;

    return getMd5Hash(allStrings).toUpperAscii();
};

public function verify_hash(string merchantId, string orderId, string amount, string statuscode, string currency) returns string {

    string hashedSecret = getMd5Hash(merchantSecret).toUpperAscii();
    string allStrings = merchantId + orderId.toString() + amount.toString() + currency + statuscode.toString() + hashedSecret;

    return getMd5Hash(allStrings).toUpperAscii();
};

public function getMd5Hash(string input) returns string {
    byte[] hash = crypto:hashMd5(input.toBytes());
    // io:println(hash.toBase16().toUpperAscii());
    return hash.toBase16();
}

public function payhere_verify(map<string> request) returns string|error {
    io:println(request);

    string merchant_id = request["merchant_id"] ?: "";
    string order_id = request["order_id"] ?: "";
    string payhere_amount = request["payhere_amount"] ?: "";
    string payhere_currency = request["payhere_currency"] ?: "";
    string status_code = request["status_code"] ?: "";
    string md5sig = request["md5sig"] ?: "";

    io:println("Merchant ID: " + merchant_id);
    io:println("Order ID: " + order_id);
    io:println("Amount: " + payhere_amount);
    io:println("Currency: " + payhere_currency);
    io:println("Status Code: " + status_code);
    io:println("MD5 Signature: " + md5sig);

    string local_hash = verify_hash(merchant_id, order_id, payhere_amount, status_code, payhere_currency);
    io:println("Local Hash: " + local_hash);

    if (local_hash != md5sig) {
        io:println("Hash mismatch");
        return error("Hash mismatch");
    }

    if (status_code != "2") {
        io:println("Payment not successful");
        return error("Payment not successful");
    }
    error? orderPayment = orders:order_payment(check int:fromString(order_id));
    if orderPayment is error {
        return orderPayment;
    }
    io:println("Payment successful");
    return "Payment successful";
}
