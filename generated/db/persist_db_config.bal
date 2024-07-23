//  AUTO-GENERATED FILE. DO NOT MODIFY.

// This file is an auto-generated file by Ballerina persistence layer.
// It should not be modified by hand.

import ballerina/sql;
import ballerinax/postgresql;

configurable int port = ?;
configurable string host = ?;
configurable string user = ?;
configurable string database = ?;
configurable string password = ?;
configurable string mode = ?;
configurable sql:ConnectionPool connectionPool = {maxOpenConnections: 2};
configurable postgresql:SSLMode SSLMode = ?;

configurable decimal connectTimeout = ?;
configurable decimal socketTimeout = ?;
configurable decimal loginTimeout = ?;
configurable decimal cancelSignalTimeout = ?;

configurable postgresql:Options & readonly connectionOptions = {
    ssl: {mode: SSLMode},
    connectTimeout: connectTimeout,
    socketTimeout: socketTimeout,
    loginTimeout: loginTimeout

};

