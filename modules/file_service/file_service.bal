import backend.cache_module;
import backend.connection;
import backend.db;

import ballerina/persist;
import ballerina/time;

// --------------------------- Image Files ---------------------------

public function saveFile(byte[] image, string fileType) returns string|error {

    string fileName = "/images/" + time:utcNow()[0].toBalString();

    match fileType {
        "image/jpeg" => {
            fileName = fileName + ".jpeg";
        }

        "image/png" => {
            fileName = fileName + ".png";
        }
        "image/jpg" => {
            fileName = fileName + ".jpg";
        }
    }
    db:Client connection = connection:getConnection();

    db:FilesInsert filesInsert = {
        name: fileName,
        data: image
    };

    int[]|persist:Error insertedFile = connection->/files.post([filesInsert]);
    if (insertedFile is persist:Error) {
        return insertedFile;
    }

    return fileName;
}

cache_module:FileCache fileCache = new ();

public function getImage(string fileName) returns byte[]|error {
    string filePath = "/images/" + fileName;

    byte[]|error file = check fileCache.get(filePath, fetchImage);

    return file;

}

public function fetchImage(string filePath) returns byte[]|error {
    db:Client connection = connection:getConnection();

    stream<db:Files, persist:Error?> streamResult = connection->/files.get(whereClause = ` "name" = ${filePath} `);
    db:Files[] files = check from db:Files file in streamResult
        select file;

    if (files.length() == 0) {
        return error("File not found");
    }

    return files[0].data;
}
