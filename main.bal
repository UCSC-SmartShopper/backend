import backend.auth;
import backend.cart;
import backend.connection;
import backend.db;
import backend.opportunities;
import backend.orders;
import backend.products;
import backend.store_prices;
import backend.supermarkets;
import backend.sms_service;
import backend.email_service;

import ballerina/http;
import ballerina/persist;
import ballerina/time;
import backend.user_registration;
import ballerina/io;


// import backend.user;

@http:ServiceConfig {
    cors: {
        allowOrigins: ["*"],
        allowCredentials: true,
        maxAge: 84900
    }
}
service / on new http:Listener(9090) {

    db:Client connection = connection:getConnection();

    resource function post login(@http:Payload auth:Credentials credentials) returns auth:UserwithToken|error {
        return auth:login(credentials);
    }

    resource function get users() returns db:User[]|error? {
        stream<db:User, persist:Error?> users = self.connection->/users.get();
        return from db:User user in users
            select user;
    }

    resource function get users/[int id]() returns db:UserWithRelations|DataNotFound|error? {
        db:UserWithRelations|persist:Error? user = self.connection->/users/[id](db:UserWithRelations);
        if user is () {
            DataNotFound notFound = {
                body: {
                    message: "User not found",
                    details: string `User not found for the given id: ${id}`,
                    timestamp: time:utcNow()
                }
            };
            return notFound;
        }
        return user;
    }

    resource function post consumer(NewUser newUser) returns db:User|persist:Error|http:Conflict & readonly {
        db:UserInsert userInsert = {
            ...newUser,
            role: "consumer",
            status: "Active",
            createdAt: time:utcToCivil(time:utcNow()),
            updatedAt: time:utcToCivil(time:utcNow()),
            deletedAt: ()};

        int[]|persist:Error result = self.connection->/users.post([userInsert]);

        if result is persist:Error {
            if result is persist:AlreadyExistsError {
                return http:CONFLICT;
            }
            return result;
        }

        db:User user = {...userInsert, id: result[0]};

        return user;
    }

    resource function patch users/[int id](@http:Payload db:UserUpdate user) returns db:User|DataNotFound|error? {
        db:User|persist:Error result = self.connection->/users/[id].put(user);

        if result is persist:Error {
            if result is persist:NotFoundError {
                DataNotFound notFound = {
                    body: {
                        message: "User not found",
                        details: string `User not found for the given id: ${id}`,
                        timestamp: time:utcNow()
                    }
                };
                return notFound;
            }
            return result;
        }

        db:User updatedUser = check self.connection->/users/[id](db:User);
        return updatedUser;
    }

    resource function get products(http:Request req) returns products:ProductResponse|persist:Error? {
        // io:println(auth:getUser(req));
        return products:getProducts();
    }

    resource function get products/[int id]() returns products:Product|DataNotFound|error? {
        return products:getProductsById(id);
    }

    // ---------------------------------------------- Store Price Resource Functions ----------------------------------------------
    resource function get storeprices(@http:Query int productId) returns store_prices:SupermarketItemResponse|store_prices:SupermarketItemNotFound|error {
        return store_prices:getSupermarketItemByProductId(productId);
    }

    resource function get pricelists/[int id]() returns db:SupermarketItem|store_prices:SupermarketItemNotFound {
        return store_prices:getSupermarketItemById(id);
    }

    // ---------------------------------------------- Cart Resource Functions ----------------------------------------------
    resource function get carts(int userId) returns cart:CartItemResponse|error {
        return cart:getCartItems(userId);
    }

    resource function post carts(http:Request req, cart:CartItem[] cartItems) returns cart:CartItem[]|error? {
        auth:User user = check auth:getUser(req);
        return cart:saveCartItems(user.consumerId ?: 0, cartItems);
    }

    // ---------------------------------------------- Supermarket Resource Functions ----------------------------------------------
    resource function get supermarkets() returns db:Supermarket[]|error? {
        return supermarkets:getSupermarkets();
    }

    resource function get supermarkets/[int id]() returns db:Supermarket|supermarkets:SuperMarketNotFound|error? {
        return supermarkets:getSupermarketById(id);
    }

    resource function get sendsms() returns error? {
        io:println("Sending sms");
        error? sendmail = sms_service:sendsms();
        return sendmail;
    }

    resource function get sendmail() returns error? {
        io:println("Sending email");
        error? sendmail = email_service:sendmail();
        return sendmail;
    }

    resource function get otpgenaration() returns error? {
        io:println("OTP Generation");
        error? otpgenaration = user_registration:otpgenaration("+94714879783" ,"milinda");
        
        return otpgenaration;   
    }

    // resource function get verifyOtp() returns user_registration:NonVerifyUser|user_registration:NonVerifyUserNotFound|error? {
    //     io:println("OTP Verification");
    //     user_registration:NonVerifyUser|user_registration:NonVerifyUserNotFound|error? verifyOtp = user_registration:verifyOtp("6205" , "+94714879783");
    //     return verifyOtp;
        
    // }




    // ---------------------------------------------- Opportunities Resource Functions ----------------------------------------------
    resource function get opportunities() returns opportunities:OpportunityResponse|error? {
        return opportunities:getOpportunities();
    }

    resource function get opportunities/[int id]() returns opportunities:OpportunityNotFound|db:OpportunityWithRelations {
        return opportunities:getOpportunitiesById(id);
    }

    // ---------------------------------------------- Order Resource Functions ----------------------------------------------

    resource function get orders() returns db:OrderWithRelations[]|error {
        return orders:getOrders();
    }

    resource function get orders/[int id]() returns db:OrderWithRelations|orders:OrderNotFound|error? {
        return orders:getOrdersById(id);
    }

    resource function post cartToOrder(@http:Payload orders:CartToOrder cartToOrder) returns db:OrderWithRelations|persist:Error|error {
        return orders:cartToOrder(cartToOrder);
    }

    // ---------------------------------------------- NonVerifyUser Resource Functions ----------------------------------------------

    // resource function get nonVerifyUser() returns  {
    //     return user:registerNonVerifyUser("contactNo" ,"username");
    // }

}
