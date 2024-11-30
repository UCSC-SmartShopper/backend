import backend.auth;
import backend.consumer;

import ballerina/crypto;
import ballerina/http;
import ballerina/io;

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

public function get_order_payment(auth:User authUser, int orderId) returns payhereRequest|error {

    consumer:Consumer|http:Unauthorized|error consumer = consumer:get_consumer(authUser, authUser.id);

    if !(consumer is consumer:Consumer) {
        return error("User not found");
    }

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
        address: "Address",
        city: "Colombo",
        country: "Sri Lanka",
        items: orderId.toString(),
        currency: "LKR",
        amount: 1000.00,

        hash: get_hash(merchant_id, orderId, 1000.00, "LKR")
    
    };

    return payload;

}

public function get_hash(string merchantId, int orderId, decimal amount, string currency) returns string {

    string hashedSecret = getMd5Hash(merchantSecret).toUpperAscii();
    string allStrings = merchantId + orderId.toString() + amount.toString() + currency + hashedSecret;

    io:println(allStrings);

    return getMd5Hash(allStrings).toUpperAscii();
};

public function getMd5Hash(string input) returns string {
    byte[] hash = crypto:hashMd5(input.toBytes());
    io:println(hash.toBase16().toUpperAscii());
    return hash.toBase16();
}

