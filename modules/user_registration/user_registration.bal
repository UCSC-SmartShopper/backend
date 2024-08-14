import backend.connection;
import backend.db;
import backend.errors;

// import ballerina/persist;
import ballerina/http;
import ballerina/io;
import ballerina/persist;
import ballerina/random;
import ballerina/time;
import ballerinax/twilio;

public type NonVerifyUser record {|
    readonly int id;
    string contactNo;
    string name;
    string OTP;
|};

public type OtpMappingRequest record {|
    string contactNumber;
    string OTP;
|};

public type SetPassword record {|
    string contactNumber;
    string OTP;
    string password;
|};

public type RegisterForm record {|
    string name;
    string email;
    string contactNumber;
    string password;
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

// public function createNonVerifyUser(string contactNo, string username, string otp) returns int[]|persist:Error {

//     db:NonVerifyUserInsert nonVerifyUser = {
//         contactNo: contactNo,
//         name: username,
//         OTP: otp
//     };
//     int[]|persist:Error result = connection->/nonverifyusers.post([nonVerifyUser]);
//     return result;
// }

public function generateOtp() returns int|error {
    int randomInteger = check random:createIntInRange(100000, 999999);
    io:println(randomInteger);
    return randomInteger;
}

twilio:Client twilioClient = check new (twilioConfig);

public function sendOtp(string otp, string phone, string name) returns error? {
    twilio:CreateMessageRequest messageRequest = {
        To: "+94"+phone.substring(1),
        From: "+16513173849",
        Body: "Hi " + name + ", Your OTP Code is : " + otp
    };

    twilio:Message response = check twilioClient->createMessage(messageRequest);

    io:println("Message Status: ", response.status);
}

// public function setPassword(SetPassword setPassword) returns string|error {
//     stream<NonVerifyUser, persist:Error?> nonVerifyUserStream = connection->/nonverifyusers();
//     NonVerifyUser[] nonVerifyUser = check from NonVerifyUser n in nonVerifyUserStream
//         where n.contactNo == setPassword.contactNumber
//         order by n.id descending
//         select n;

//     if (nonVerifyUser.length() == 0) {
//         return error("Non-Verify User not found");
//     }

//     NonVerifyUser user = nonVerifyUser[0];

//     db:UserInsert userInsert = {
//         email: "",
//         number: setPassword.contactNumber,
//         name: user.name,
//         password: setPassword.password,
//         role: "consumer",
//         status: "Active",
//         profilePic: "",
//         createdAt: time:utcToCivil(time:utcNow()),
//         updatedAt: time:utcToCivil(time:utcNow()),
//         deletedAt: ()
//     };

//     int[]|persist:Error result = connection->/users.post([userInsert]);
//     if (result is persist:Error) {
//         return error("Error while creating User");
//     }

    

//     return "Success";

// }

public function otp_genaration(RegisterForm registerForm) returns string|error {
    int|error otp = generateOtp();
    string otp_string = (check otp).toString();
    io:println("Generated OTP: " + otp_string);

    // send otp to users mobile
    check sendOtp(otp_string, registerForm.contactNumber, registerForm.name);

    // create non-verify user and insert into db
    db:NonVerifyUserInsert nonVerifyUser = {
        name: registerForm.name,
        email: registerForm.email,
        contactNo: registerForm.contactNumber,
        password: registerForm.password,
        OTP: otp_string
    };

    int[]|persist:Error result = connection->/nonverifyusers.post([nonVerifyUser]);

    if (result is persist:Error) {
        return error("Error while creating Non-Verify User");
    }

    return "Success";
}

public function getUserByNumber(string phone) returns NonVerifyUser|NonVerifyUserNotFound|error? {
    stream<NonVerifyUser, persist:Error?> nonVerifyUserStream = connection->/nonverifyusers();
    NonVerifyUser[] nonVerifyUser = check from NonVerifyUser n in nonVerifyUserStream
        where n.contactNo == phone
        select n;
    if (nonVerifyUser.length() == 0) {
        return createNonVerifyUserNotFound(phone);
    }
    return nonVerifyUser.pop();
}

public function checkOtpMatching(OtpMappingRequest otpMappingRequest) returns string|error|NonVerifyUserNotFound {
    string phone = otpMappingRequest.contactNumber;
    string otp = otpMappingRequest.OTP;

    stream<db:NonVerifyUser, persist:Error?> nonVerifyUserStream = connection->/nonverifyusers();
    db:NonVerifyUser[] nonVerifyUser = check from db:NonVerifyUser n in nonVerifyUserStream
        where n.contactNo == phone && n.OTP == otp
        order by n.id descending
        select n;

    io:println(nonVerifyUser);

    if (nonVerifyUser.length() == 0) {
        return error("Non-Verify User not found");
    }

    db:NonVerifyUser user = nonVerifyUser[0];

    // Save user to user table
    db:UserInsert userInsert = {
        email: user.email,
        number: user.contactNo,
        name: user.name,
        password: user.password,
        role: "Consumer",
        status: "Active",
        profilePic: "",
        createdAt: time:utcToCivil(time:utcNow()),
        updatedAt: time:utcToCivil(time:utcNow()),
        deletedAt: ()
    };

    int[]|persist:Error result = connection->/users.post([userInsert]);
    if (result is persist:Error) {
        return error("Error while creating User");
    }

    int userId = result[0];
    // inster user to consumer tabele
    db:ConsumerInsert consumerInsert = {
        userId: userId
    };

    int[]|persist:Error consumerResult = connection->/consumers.post([consumerInsert]);
    if (consumerResult is persist:Error) {
        return error("Error while creating Consumer");
    }

    return "Success";

}

