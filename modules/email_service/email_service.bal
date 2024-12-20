import ballerina/email;

public function sendmail() returns error? {
    // Creates an SMTP client with the connection parameters, host, username, and password. 
    // The default port number `465` is used over SSL with these configurations. `SmtpConfig` can 
    // be configured and passed to this client if the port or security is to be customized.
    email:SmtpClient smtpClient = check new ("smtp.sendgrid.net", "apikey" , "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");

    // Defines the email that is required to be sent.
    email:Message email = {
        // "TO", "CC", and "BCC" addresses can be added as follows.
        // Only the "TO" address is mandatory out of these three.
        to: "milinda.msd@gmail.com",
        // Subject of the email is added as follows. This field is mandatory.
        subject: "Sample Email",
        // Body content (text) of the email is added as follows. This field is optional.
        body: "This is a sample email from ballerina."
    };

    // Sends the email message with the client. The `send` method can be used instead if the 
    // email is required to be sent with mandatory and optional parameters instead of 
    // configuring an `email:Message` record.
    check smtpClient->sendMessage(email);
}
