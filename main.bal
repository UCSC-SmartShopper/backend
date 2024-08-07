import backend.auth;
import backend.cart;
import backend.connection;
import backend.db;
import backend.email_service;
import backend.opportunities;
import backend.orders;
import backend.products;
import backend.sms_service;
import backend.store_prices;
import backend.supermarkets;
import backend.user_registration;
import backend.advertisements;

import ballerina/http;
import ballerina/io;
import ballerina/persist;
import ballerina/time;

// import backend.user;

@http:ServiceConfig {
    cors: {
        allowOrigins: ["https://smart-shopper-frontend.vercel.app", "http://localhost:5173", "*"],
        allowCredentials: true,
        maxAge: 84900

    }
}
service / on new http:Listener(9090) {

    db:Client connection = connection:getConnection();

    resource function post login(@http:Payload auth:Credentials credentials) returns auth:UserwithToken|error {
        return auth:login(credentials);
    }

    resource function post generate_otp(@http:Payload user_registration:RegisterForm registerForm) returns string|error {
        return user_registration:otp_genaration(registerForm);
    }

    resource function post match_otp(@http:Payload user_registration:OtpMappingRequest otpMappingRequest) returns string|error|user_registration:NonVerifyUserNotFound {
        return user_registration:checkOtpMatching(otpMappingRequest);
    }

    // resource function post set_password(@http:Payload user_registration:SetPassword setPassword) returns string|error {
    //     user_registration:OtpMappingRequest otpMappingRequest = {
    //         contactNumber: setPassword.contactNumber,
    //         OTP: setPassword.OTP
    //     };

    //     string|user_registration:NonVerifyUserNotFound checkOtpMatching = check user_registration:checkOtpMatching(otpMappingRequest);

    //     if checkOtpMatching is string && checkOtpMatching == "OTP matched" {
    //         string result = check user_registration:setPassword(setPassword);
    //         return result;
    //     }

    //     return "OTP not matched";
    // }

    resource function get users() returns db:User[]|error? {
        stream<db:User, persist:Error?> users = self.connection->/users.get();
        return from db:User user in users
            order by user.id
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
            deletedAt: ()
        };

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
    resource function get carts(http:Request req) returns cart:CartItemResponse|error {
        auth:User user = check auth:getUser(req);
        io:println(user);
        return cart:getCartItems(user.consumerId ?: -1);
    }

    resource function post carts(http:Request req, cart:CartItemInsert cartItem) returns db:CartItem|int|error {
        auth:User user = check auth:getUser(req);
        io:println("addCartItem");
        return cart:addCartItem(user.consumerId ?: -1, cartItem);
    }

    resource function patch carts(http:Request req, cart:CartItem cartItem) returns db:CartItem|int|error {
        auth:User user = check auth:getUser(req);
        io:println("updateCartItem");
        return cart:updateCartItem(user.consumerId ?: -1, cartItem);
    }

    resource function delete carts(http:Request req, int id) returns db:CartItem|error {
        auth:User user = check auth:getUser(req);
        io:println("removeCartItem");
        return cart:removeCartItem(user.consumerId ?: -1, id);
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

    resource function post checkOtpMatching(@http:Payload user_registration:OtpMappingRequest otpMappingRequest) returns string|error|user_registration:NonVerifyUserNotFound {
        // io:println("OTP Matching");
        return user_registration:checkOtpMatching(otpMappingRequest);

    }

    // ---------------------------------------------- Opportunities Resource Functions ----------------------------------------------
    resource function get opportunities() returns opportunities:OpportunityResponse|error? {
        return opportunities:getOpportunities();
    }

    resource function get opportunities/[int id]() returns opportunities:OpportunityNotFound|db:OpportunityWithRelations {
        return opportunities:getOpportunitiesById(id);
    }

    resource function post accept_opportunity/[int id](http:Request req) returns db:Opportunity|error {
        auth:User user = check auth:getUser(req);
        return opportunities:accept_opportunity(user,id);
    }
    // ---------------------------------------------- Order Resource Functions ----------------------------------------------

    resource function get orders() returns db:OrderWithRelations[]|error {
        return orders:getOrders();
    }

    resource function get orders/[int id]() returns db:OrderWithRelations|orders:OrderNotFound|error? {
        return orders:getOrdersById(id);
    }

    resource function post cartToOrder(@http:Payload orders:CartToOrderRequest cartToOrderRequest) returns db:OrderWithRelations|persist:Error|error {
        return orders:cartToOrder(cartToOrderRequest);
    }

    // ---------------------------------------------- NonVerifyUser Resource Functions ----------------------------------------------

    // resource function get nonVerifyUser() returns  {
    //     return user:registerNonVerifyUser("contactNo" ,"username");
    // }

    //---------------------------------Advertisement Resource Functions----------------------------------------------

    resource function get advertisements() returns db:Advertisement[]|error?{
        return advertisements:getAdvertisements();
    }

    

}
