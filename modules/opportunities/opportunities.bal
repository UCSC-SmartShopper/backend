import backend.auth;
import backend.connection;
import backend.db;
import backend.errors;

import ballerina/http;
import ballerina/persist;

public type OpportunityNotFound record {|
    *http:NotFound;
    errors:ErrorDetails body;
|};

public type OpportunityResponse record {|
    int count;
    string next;
    db:OpportunityWithRelations[] results;
|};

public type AcceptOpportunityRequest record {|
    int opportunityId;
|};

function createOpportunityNotFound(int id) returns OpportunityNotFound {
    return {
        body: {
            message: "Opportunity not found",
            details: string `Opportunity not found for the given id: ${id}`
        }
    };
}

public function getOpportunities(auth:User user, string status,int _limit) returns OpportunityResponse|http:Unauthorized|error {

    string[] authorizedRoles = ["Driver", "Courier Company Manager"];

    if (!authorizedRoles.some((role) => role == user.role)) {
        return http:UNAUTHORIZED;
    }

    db:Client connection = connection:getConnection();

    stream<db:OpportunityWithRelations, persist:Error?> opportunityStream = connection->/opportunities.get();

    // Filter opportunities based on params
    db:OpportunityWithRelations[] opportunities = check from db:OpportunityWithRelations opportunity in opportunityStream
        where
            (opportunity.status == status || status == "")

        order by opportunity.id descending
        select opportunity;

    // Filter opportunities based on user role
    match user.role {
        "Driver" => {
            // Show all opportunities belonging to the driver
            // Show all pending opportunities
            opportunities = opportunities.filter(
                (opportunity) => opportunity.driverId == user.driverId || status == "Pending"
                );
        }

        // Show all opportunities that belong to the courier company
        // "Courier Company Manager" => {
        //     opportunities = opportunities.filter((opportunity) => status == "Pending");
        // }
    }

    // Limit the number of opportunities to be returned
    opportunities = opportunities.length() > _limit ? opportunities.slice(0, _limit) : opportunities;

    return {count: opportunities.length(), next: "", results: opportunities};
}

public function getOpportunitiesById(int id) returns OpportunityNotFound|db:OpportunityWithRelations {
    db:Client connection = connection:getConnection();

    db:OpportunityWithRelations|persist:Error opportunity = connection->/opportunities/[id](db:OpportunityWithRelations);
    if (opportunity is persist:Error) {
        return createOpportunityNotFound(id);
    }
    return opportunity;
}

public function accept_opportunity(auth:User user, int id) returns db:Opportunity|error {
    db:Client connection = connection:getConnection();

    db:OpportunityUpdate opportunityUpdate = {status: "Accepted", driverId: user.id};

    db:Opportunity|persist:Error updatedOpportunity = connection->/opportunities/[id].put(opportunityUpdate);
    if updatedOpportunity is persist:Error {
        return error("Accepting opportunity failed");
    }
    return updatedOpportunity;
}

public function complete_delivery(auth:User user, int id) returns db:Opportunity|error {
    db:Client connection = connection:getConnection();

    db:OpportunityUpdate opportunityUpdate = {status: "Delivered"};

    db:Opportunity|persist:Error updatedOpportunity = connection->/opportunities/[id].put(opportunityUpdate);
    if updatedOpportunity is persist:Error {
        return error("Completing delivery failed");
    }
    return updatedOpportunity;
}

