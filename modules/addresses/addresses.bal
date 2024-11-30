import backend.auth;
import backend.connection;
import backend.db;

import ballerina/persist;
import ballerina/time;

public type AddressesResponse record {|
    int count;
    boolean next;
    db:Address[] results;
|};

// get all addresses belongs to a consumer
public function get_all_addresses(auth:User user) returns AddressesResponse|error {

    db:Client connection = connection:getConnection();
    stream<db:Address, persist:Error?> addresses = connection->/addresses();
    db:Address[] addressList = check from db:Address address in addresses
        where address.consumerId == user.consumerId
        order by address.id descending
        select address;

    return {count: addressList.length(), next: false, results: addressList};
}

public function create_consumer_address(auth:User user, db:AddressInsert address) returns string|error {

    int consumerId = user.consumerId ?: -1;
    if consumerId == -1 {
        return error("Consumer id not found");
    }

    // Validate the address
    if address.addressName == "" {
        return error("Address name is required");
    }

    if address.address == "" {
        return error("Address is required");
    }

    if address.city == "" {
        return error("City is required");
    }

    if address.location == "" {
        return error("Location is required");
    }

    db:AddressInsert addressInsert = {
        addressName: address.addressName,
        address: address.address,
        city: address.city,
        location: address.location,
        priority: time:utcNow()[0],
        consumerId: consumerId
    };

    db:Client connection = connection:getConnection();
    int[]|persist:Error result = connection->/addresses.post([addressInsert]);

    if result is persist:Error {
        return result;
    }

    return "Address created successfully";
}

public function update_consumer_default_address(auth:User user, int id) returns string|error {

    db:Client connection = connection:getConnection();
    db:Address address = check connection->/addresses/[id]();

    // Authorization
    if address.consumerId != user.consumerId {
        return error("Unauthorized access");
    }

    db:AddressUpdate AddressUpdate = {
        priority: time:utcNow()[0]
    };

    db:Address|persist:Error result = connection->/addresses/[id].put(AddressUpdate);

    if result is persist:Error {
        return result;
    }

    return "Default address updated successfully";
}
