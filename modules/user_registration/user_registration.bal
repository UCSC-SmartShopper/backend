import backend.auth;
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

public type NonVerifiedDriver record {|
    readonly int id;
    string name;
    string nic;
    string email;
    string contactNo;
    string courierCompany;
    string vehicleType;
    string vehicleColor;
    string vehicleName;
    string vehicleNumber;
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

public type DriverOtp record {|
    string OTP;
    int id;
|};

public type RegisterForm record {|
    string name;
    string email;
    string contactNumber;
    string password;
|};

public type DriverPersonalDetails record {|
    string name;
    string nic;
    string email;
    string contactNo;
|};

public type NonVerifyUserNotFound record {|
    *http:NotFound;
    errors:ErrorDetails body;
|};

public type DriverRequestsResponse record {|
    int count;
    string next;
    NonVerifiedDriver[] results;
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

public function generateOtp() returns int|error {
    int randomInteger = check random:createIntInRange(100000, 999999);
    io:println(randomInteger);
    return randomInteger;
}

twilio:Client twilioClient = check new (twilioConfig);

public function sendOtp(string otp, string phone, string name) returns error? {
    twilio:CreateMessageRequest messageRequest = {
        To: "+94" + phone.substring(1),
        From: "+16513173849",
        Body: "Hi " + name + ", Your OTP Code is : " + otp
    };

    twilio:Message response = check twilioClient->createMessage(messageRequest);

    io:println("Message Status: ", response.status);
}

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

    db:Client connection = connection:getConnection();
    int[]|persist:Error result = connection->/nonverifyusers.post([nonVerifyUser]);

    if (result is persist:Error) {
        return error("Error while creating Non-Verify User");
    }

    return "Success";
}

public function getUserByNumber(string phone) returns NonVerifyUser|NonVerifyUserNotFound|error? {
    db:Client connection = connection:getConnection();
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

    db:Client connection = connection:getConnection();
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

public function driver_otp_genaration(DriverPersonalDetails driverPersonalDetails) returns error|int {
    int|error otp = generateOtp();
    string otp_string = (check otp).toString();
    io:println("Generated OTP: " + otp_string);

    // send otp to  non-verify driver's mobile
    check sendOtp(otp_string, driverPersonalDetails.contactNo, driverPersonalDetails.name);

    // create non-verify driver and insert into db
    db:NonVerifiedDriverInsert nonVerifyDriver = {
        name: driverPersonalDetails.name,
        nic: driverPersonalDetails.nic,
        email: driverPersonalDetails.email,
        contactNo: driverPersonalDetails.contactNo,
        OTP: otp_string,

        courierCompany: "",
        vehicleType: "",
        vehicleColor: "",
        vehicleName: "",
        vehicleNumber: "",
        password: "",
        otpStatus: ""
    };

    db:Client connection = connection:getConnection();
    int[]|persist:Error result = connection->/nonverifieddrivers.post([nonVerifyDriver]);

    if (result is persist:Error || result.length() == 0) {
        return error("Error while creating Non-Verify Driver");
    }

    return result[0];
}

public function match_driver_otp(DriverOtp driverOtp) returns db:NonVerifiedDriver|error {
    db:Client connection = connection:getConnection();

    db:NonVerifiedDriver|persist:Error result = connection->/nonverifieddrivers/[driverOtp.id](db:NonVerifiedDriver);

    if result is persist:Error {
        return error("Driver not found.");
    }

    if (driverOtp.OTP != result.OTP) {
        return error("Otp does not matched.");
    }
    db:NonVerifiedDriverUpdate nonVerifiedDriverUpdate = {otpStatus: "Verified"};

    db:NonVerifiedDriver|persist:Error updatedDriver = connection->/nonverifieddrivers/[driverOtp.id].put(nonVerifiedDriverUpdate);
    return updatedDriver;
}

public function update_driver_signup(db:NonVerifiedDriverOptionalized driverUpdate, int id) returns db:NonVerifiedDriver|error {

    db:Client connection = connection:getConnection();

    db:NonVerifiedDriver|persist:Error result = connection->/nonverifieddrivers/[id](db:NonVerifiedDriver);

    if result is persist:Error {
        return error("Driver not found.");
    }

    if (driverUpdate.OTP != result.OTP) {
        return error("Otp does not matched.");
    }

    db:NonVerifiedDriverUpdate nonVerifiedDriverUpdate = {
        courierCompany: driverUpdate.courierCompany,
        vehicleType: driverUpdate.vehicleType,
        vehicleColor: driverUpdate.vehicleColor,
        vehicleName: driverUpdate.vehicleName,
        vehicleNumber: driverUpdate.vehicleNumber,
        password: driverUpdate.password
    };

    db:NonVerifiedDriver|persist:Error updatedDriver = connection->/nonverifieddrivers/[id].put(nonVerifiedDriverUpdate);
    return updatedDriver;
}

public function accept_driver_request(auth:User user, int driverRequestId) returns http:Unauthorized & readonly|error|int {

    if user.role != "Courier Company Manager" {
        return http:UNAUTHORIZED;
    }

    db:Client connection = connection:getConnection();
    db:NonVerifiedDriver|persist:Error result = connection->/nonverifieddrivers/[driverRequestId](db:NonVerifiedDriver);

    if result is persist:Error {
        return error("Driver not found.");
    }

    // db:NonVerifiedDriverUpdate nonVerifiedDriverUpdate = {
    //     courierCompany: driverUpdate.courierCompany,
    //     vehicleType: driverUpdate.vehicleType,
    //     vehicleColor: driverUpdate.vehicleColor,
    //     vehicleName: driverUpdate.vehicleName,
    //     vehicleNumber: driverUpdate.vehicleNumber,
    //     password: driverUpdate.password
    // };

    // db:NonVerifiedDriver|persist:Error updatedDriver = connection->/nonverifieddrivers/[id].put(nonVerifiedDriverUpdate);
    return driverRequestId;
}

public function get_all_driver_requests(auth:User user) returns DriverRequestsResponse|http:Unauthorized|persist:Error? {
    if user.role != "Courier Company Manager" {
        return http:UNAUTHORIZED;
    }

    db:Client connection = connection:getConnection();
    stream<db:NonVerifiedDriver, persist:Error?> driverRequests = connection->/nonverifieddrivers();
    NonVerifiedDriver[] driverRequestList = check from db:NonVerifiedDriver driverRequest in driverRequests
        where driverRequest.otpStatus == "Verified"
        order by driverRequest.id descending
        select {
            id: driverRequest.id,
            name: driverRequest.name,
            nic: driverRequest.nic,
            email: driverRequest.email,
            contactNo: driverRequest.contactNo,
            courierCompany: driverRequest.courierCompany,
            vehicleType: driverRequest.vehicleType,
            vehicleColor: driverRequest.vehicleColor,
            vehicleName: driverRequest.vehicleName,
            vehicleNumber: driverRequest.vehicleNumber
        };

    return {count: driverRequestList.length(), next: "null", results: driverRequestList};
}
