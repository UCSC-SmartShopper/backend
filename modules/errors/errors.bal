import ballerina/time;

public type ErrorDetails record {
    string message;
    string details;
    time:Utc timestamp = time:utcNow();
};

