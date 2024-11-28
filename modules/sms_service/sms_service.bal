import ballerina/io;
import ballerinax/twilio;

configurable string accountSid = ?;
configurable string authToken = ?;

twilio:ConnectionConfig twilioConfig = {
    auth: {
        authToken: authToken,
        accountSid: accountSid
    }
};

twilio:Client twilio = check new (twilioConfig);

public function sendsms() returns error? {
    twilio:CreateMessageRequest messageRequest = {
        To: "+94714879783",
        From: "+16513173849",
        Body: "visit milindashehan.me"
    };

    twilio:Message response = check twilio->createMessage(messageRequest);

    // Print the status of the message from the response
    io:println("Message Status: ", response);
}
