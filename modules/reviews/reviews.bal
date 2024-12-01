import backend.auth;
import backend.connection;
import backend.db;

import ballerina/persist;
import backend.utils;
import backend.activity;

public type ReviewInsert record {|
    string reviewType;
    int targetId;
    string title;
    string content;
    float rating;
|};

public type ReviewResponse record {|
    int count;
    string next;
    db:ReviewWithRelations[] results;
|};

public function get_reviews(string reviewType, int targetId) returns ReviewResponse|error? {
    db:Client connection = connection:getConnection();
    stream<db:ReviewWithRelations, persist:Error?> reviewStream = connection->/reviews.get();
    db:ReviewWithRelations[] reviews = check from db:ReviewWithRelations review in reviewStream
        where
            (reviewType == "" || review.reviewType == reviewType) &&
            (targetId == 0 || review.targetId == targetId)
        order by review.id descending
        select filterUserDetails(review);

    return {count: reviews.length(), next: "", results: reviews};
}

public function get_review_by_id(int id) returns db:Review|error? {
    db:Client connection = connection:getConnection();
    db:Review|persist:Error? review = connection->/reviews/[id](db:Review);
    if (review is persist:Error) {
        return error("Error occurred while retrieving the review");
    }
    return review;
}

public function create_review(auth:User user, ReviewInsert review) returns int|error? {

    db:ReviewInsert ReviewInsert = {
        userId: user.id,
        reviewType: review.reviewType,
        targetId: review.targetId,
        title: review.title,
        content: review.content,
        rating: review.rating,
        createdAt: utils:getCurrentTime()
    };

    db:Client connection = connection:getConnection();
    int[]|persist:Error result = connection->/reviews.post([ReviewInsert]);
    if (result is persist:Error) {
        return error("Error occurred while creating the review");
    }
    if (result.length() > 0) {
        return result[0];
    }
    //create activity
    int consumerId = user.consumerId ?: -1;
    _  = start activity:createActivity(consumerId, "Added review to " + review.reviewType + "with" + review.rating.toString() + "rating");
    return -1;
}

function filterUserDetails(db:ReviewWithRelations review) returns db:ReviewWithRelations {
    db:UserOptionalized user = review.user ?: {};
    return {
        id: review.id,
        reviewType: review.reviewType,
        user: {
            id: user.id,
            name: user.name,
            profilePic: user.profilePic
        },
        targetId: review.targetId,
        title: review.title,
        content: review.content,
        rating: review.rating,
        createdAt: review.createdAt
    };
}