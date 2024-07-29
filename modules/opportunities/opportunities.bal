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

function createOpportunityNotFound(int id) returns OpportunityNotFound {
    return {
        body: {
            message: "Opportunity not found",
            details: string `Opportunity not found for the given id: ${id}`
        }
    };
}

public function getOpportunities() returns OpportunityResponse|error? {
    db:Client connection = connection:getConnection();

    stream<db:OpportunityWithRelations, persist:Error?> opportunityStream = connection->/opportunities.get();
    db:OpportunityWithRelations[] opportunities = check from db:OpportunityWithRelations opportunity in opportunityStream
        select opportunity;

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
