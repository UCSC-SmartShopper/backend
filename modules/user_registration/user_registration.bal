import ballerina/io;
import ballerinax/twilio;
import ballerina/random;
// import ballerina/persist;
// import ballerina/http;

import backend.connection;
import backend.db;
// import ballerina/time;
// import backend.errors;




configurable string accountSid = ?;
configurable string authToken = ?;

twilio:ConnectionConfig twilioConfig = {
    auth: {
        username: accountSid,
        password: authToken
    }
};



type User record {|
    string name;
    string password;
    string number;
    string otp;
    string userRole;
    string status;
|};


db:Client connection = connection:getConnection();



public function generateOtp() returns int|error {
    int randomInteger = check random:createIntInRange(1000, 9999);
    io:println(randomInteger);   
    return randomInteger;
}

twilio:Client twilioClient = check new (twilioConfig);

public function sendOtp(string otp) returns error? {
    io:println(otp);
    twilio:CreateMessageRequest messageRequest = {
        To: "+94714879783",
        From: "+16513173849",
        Body: "Your Otp Code is " + otp
    };

    twilio:Message response = check twilioClient->createMessage(messageRequest);

    io:println("Message Status: ", response.status);
}

public function otpgenaration() returns error? {
    int|error otp = generateOtp();
    io:println(otp);
    string otptoString = (check otp).toString();
    io:println(otptoString);
   check sendOtp(otptoString);

}
