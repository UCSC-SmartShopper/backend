// AUTO-GENERATED FILE. DO NOT MODIFY.

// This file is an auto-generated file by Ballerina persistence layer.
// It should not be modified by hand.

import ballerinax/postgresql;

configurable int port = ?;
configurable string host = ?;
configurable string user = ?;
configurable string database = ?;
configurable string password = ?;
configurable string mode = ?;
configurable postgresql:SSLMode SSLMode = ?;

configurable postgresql:Options & readonly connectionOptions = {
    ssl: {mode: SSLMode}
};

configurable float connectTimeout = ?;
configurable float socketTimeout = ?;
configurable float loginTimeout = ?;
configurable float cancelSignalTimeout = ?;

