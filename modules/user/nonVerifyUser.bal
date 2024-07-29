// import backend.connection;
// import backend.db;
// import backend.errors;

// import ballerina/http;
// import ballerina/persist;
// import ballerina/random;
// import ballerina/time;

// public type NonVerifyUser record {|
//     readonly int id;
//     string contactNo;
//     string name;
//     string OTP;
// |};

// public type NonVerifyUserNotFound record {|
//     *http:NotFound;
//     errors:ErrorDetails body;
// |};

// function createNonVerifyUserNotFound(string otp) returns NonVerifyUserNotFound {
//     return {
//         body: {
//             message: "Non-Verify User not found",
//             details: string `Non-Verify User not found for the given OTP: ${otp}`,
//             timestamp: time:utcNow()
//         }
//     };
// }

// public function generateOTP() returns string|error {
//     string otp = "";
//     int randomInteger = check random:createIntInRange(100000, 999999);
//     otp = randomInteger.toString();
//     return otp;
// }

// public function registerNonVerifyUser(string contactNo, string username) returns (NonVerifyUser|NonVerifyUserNotFound|error) {
//     db:Client connection = connection:getConnection();
//     string|error otp = generateOTP();
//     db:NonVerifyUserInsert nonVerifyUser = {
//         contactNo: "0719944045",
//         name: "Bimsara",
//         OTP: check otp
//     };
//     NonVerifyUser|NonVerifyUserNotFound|error result = connection->/nonverifyusers.post([nonVerifyUser]);
//     return result;
// }

