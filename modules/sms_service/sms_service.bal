// import ballerina/io;
// import ballerinax/twilio;

// configurable string accountSid = ?;
// configurable string authToken = ?;

// twilio:ConnectionConfig twilioConfig = {
//     auth: {
//         username: accountSid,
//         password: authToken
//     }
// };

// twilio:Client twilio = check new (twilioConfig);

// public function sendsms() returns error? {
//     twilio:CreateValidationRequest messageRequest = {
//         PhoneNumber: "+94712216841"
//     };

//      twilio:Validation_request validationRequest = check twilio->createValidationRequest(messageRequest);

//     // Print the status of the message from the response
//     io:println("Message Status: ", validationRequest);
// }
