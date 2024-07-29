// import ballerina/http;
// import ballerina/io;

// service /upload on new http:Listener(8080) {

    
// }


    // resource function post file(http:Caller caller, http:Request req) returns error {
    //     string content;
    //     string fileName;

    //     mime:Entity[] bodyParts = check req.getBodyParts();

    //     foreach mime:Entity part in bodyParts {
    //         mime:ContentDisposition contentDisposition = part.getContentDisposition();
    //         if (contentDisposition.name == "file") {
    //             string filePath = "/" + fileName;
    //             io:file fileHandler = check new io:file(filePath);
    //             content = handleContent(part);
    //             fileName = contentDisposition.fileName;
    //         }
    //         else {
    //             submission[contentDisposition.name] = check part.getBodyAsString();
    //         }
    //     }

    // }