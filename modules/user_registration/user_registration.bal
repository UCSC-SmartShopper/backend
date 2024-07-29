import ballerina/io;
import ballerinax/twilio;
import ballerina/random;
// import ballerina/persist;
import ballerina/http;

import backend.connection;
import backend.db;
import ballerina/time;
import ballerina/persist;
import backend.errors;


public type NonVerifyUser record {|
    readonly int id;
    string contactNo;
    string name;
    string OTP;
|};

public type NonVerifyUserNotFound record {|
    *http:NotFound;
    errors:ErrorDetails body;
|};

function createNonVerifyUserNotFound(string otp) returns NonVerifyUserNotFound {
    return {
        body: {
            message: "Non-Verify User not found",
            details: string `Non-Verify User not found for the given OTP: ${otp}`,
            timestamp: time:utcNow()
        }
    };
}




configurable string accountSid = ?;
configurable string authToken = ?;

twilio:ConnectionConfig twilioConfig = {
    auth: {
        username: accountSid,
        password: authToken
    }
};





db:Client connection = connection:getConnection();

public function createNonVerifyUser(string contactNo, string username , string otp) returns int[]|persist:Error {

    db:NonVerifyUserInsert nonVerifyUser = {
        contactNo: contactNo,
        name: username,
        OTP: otp
    };
    int[]|persist:Error result = connection->/nonverifyusers.post([nonVerifyUser]);
    return result;
}



public function generateOtp() returns int|error {
    int randomInteger = check random:createIntInRange(100000, 999999);
    io:println(randomInteger);   
    return randomInteger;
}

twilio:Client twilioClient = check new (twilioConfig);

public function sendOtp(string otp, string phone, string name) returns error? {
    io:println(otp);
    twilio:CreateMessageRequest messageRequest = {
        To: phone,
        From: "+16513173849",
        Body: "Hi "+ name +", Your OTP Code is : " + otp
    };

    twilio:Message response = check twilioClient->createMessage(messageRequest);

    io:println("Message Status: ", response.status);
}

public function otpgenaration(string phone , string name) returns error? {
    int|error otp = generateOtp();
    io:println(otp);
    string otptoString = (check otp).toString();
    io:println(otptoString);
   check sendOtp(otptoString , phone , name);
   int[]|persist:Error nonVerifyUser = check createNonVerifyUser(phone,name,otptoString);

}

// public function verifyOtp(string otp , string phone) returns NonVerifyUser|NonVerifyUserNotFound|error? {
//     stream<NonVerifyUser, persist:Error?> nonVerifyUserStream = connection->/nonverifyusers(whereClause = `"NonVerifyUser"."contactNo"='${phone}' AND "NonVerifyUser"."OTP"='${otp}'`);
//     NonVerifyUser[] nonVerifyUser = check from NonVerifyUser n in nonVerifyUserStream
//         select n;
//     if (nonVerifyUser.length() == 0) {
//         return createNonVerifyUserNotFound(otp);
//     }
//     return nonVerifyUser[0];
// }
