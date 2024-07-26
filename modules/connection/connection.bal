import backend.db;

import ballerina/io;

final db:Client dbClient;

function init() returns error? {
    io:println("Connecting to the database...");
    dbClient = check new ();
    io:println("Connected to the database");
}

public isolated function getConnection() returns db:Client {
    return dbClient;
}
