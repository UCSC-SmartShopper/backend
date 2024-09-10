import backend.advertisements;
import backend.auth;
import backend.cart;
import backend.consumer;
import backend.db;
import backend.driver;
import backend.opportunities;
import backend.orders;
import backend.products;
import backend.reviews;
import backend.stats;
import backend.supermarket_items;
import backend.supermarkets;
import backend.user;
import backend.user_registration;

//import backend.adminOverview;

import ballerina/http;
import ballerina/persist;

@http:ServiceConfig {
    cors: {
        allowOrigins: ["*"],
        allowCredentials: true,
        maxAge: 84900

    }
}
service / on new http:Listener(9090) {

    // ---------------------------------------------- User Login and Signup Resource Functions ----------------------------------------------
    resource function post login(@http:Payload auth:Credentials credentials) returns auth:UserwithToken|error {
        return auth:login(credentials);
    }

    resource function post generate_otp(@http:Payload user_registration:RegisterForm registerForm) returns string|error {
        return user_registration:otp_genaration(registerForm);
    }

    resource function post match_otp(@http:Payload user_registration:OtpMappingRequest otpMappingRequest) returns string|error|user_registration:NonVerifyUserNotFound {
        return user_registration:checkOtpMatching(otpMappingRequest);
    }

    // ---------------------------------------------- Driver Signup Resource Functions ----------------------------------------------

    // get the otp 
    resource function post driver_otp(@http:Payload user_registration:DriverPersonalDetails driverPersonalDetails) returns error|int {
        return user_registration:driver_otp_genaration(driverPersonalDetails);
    }

    resource function post driver_otp_resend(@http:Payload record {|int id;|} payload) returns http:Created|error {
        return user_registration:driver_otp_resend(payload.id);
    }

    // match the otp and create a driver request
    resource function post match_driver_otp(@http:Payload user_registration:DriverOtp driverOtp) returns db:NonVerifiedDriver|error {
        return user_registration:match_driver_otp(driverOtp);
    }

    // finalizing the driver signup
    resource function post update_driver_signup/[int id](@http:Payload db:NonVerifiedDriverOptionalized driverUpdate) returns db:NonVerifiedDriver|error {
        return user_registration:update_driver_signup(driverUpdate, id);
    }

    // Accept driver request by courier company manager
    resource function post accept_driver_request(http:Request req, @http:Payload record {int id;} payload) returns db:Driver|http:Unauthorized|error|int {
        auth:User user = check auth:getUser(req);
        return user_registration:accept_driver_request(user, payload.id);
    }

    resource function get driver_requests(http:Request req) returns user_registration:DriverRequestsResponse|http:Unauthorized|persist:Error?|error {
        auth:User user = check auth:getUser(req);
        return user_registration:get_all_driver_requests(user);
    }

    // ---------------------------------------------- User Resource Functions ----------------------------------------------
    resource function get users() returns user:UserResponse|http:Unauthorized|error {
        return user:get_all_user();
    }

    resource function get users/[int id](http:Request req) returns db:UserWithRelations|http:Unauthorized|user:UserNotFound|error {
        auth:User user = check auth:getUser(req);
        return user:get_user(user, id);
    }

    resource function patch users/[int id](http:Request req, @http:Payload db:UserUpdate userUpdate) returns db:User|DataNotFound|error {
        auth:User user = check auth:getUser(req);
        return user:update_user(user, userUpdate);
    }

    resource function patch change_password/[int id](http:Request req, @http:Payload user:UpdatePassword updatePassword) returns db:User|DataNotFound|error {
        auth:User user = check auth:getUser(req);
        return user:update_password(user, id, updatePassword);
    }

    // ---------------------------------------------- Driver Resource Functions ----------------------------------------------
    resource function get drivers() returns driver:DriverResponse|http:Unauthorized|error {
        return driver:get_all_drivers();
    }

    resource function get drivers/[int id](http:Request req) returns db:DriverWithRelations|http:Unauthorized|error {
        auth:User user = check auth:getUser(req);
        return driver:get_driver(user, id);
    }

    // ---------------------------------------------- Consumer Resource Functions ----------------------------------------------
    resource function get consumers(@http:Query string searchText, int month, int page, int _limit) returns consumer:ConsumerResponse|http:Unauthorized|error {
        return consumer:get_all_consumers(searchText, month, page, _limit);
    }

    resource function get consumers/[int id](http:Request req) returns consumer:Consumer|http:Unauthorized|error {
        auth:User user = check auth:getUser(req);
        return consumer:get_consumer(user, id);
    }

    resource function get activity/[int id]() returns activity:Activity|http:Unauthorized|error {
        return check activity:get_activities(id);
    }

    // ---------------------------------------------- Products Resource Functions ----------------------------------------------
    resource function get products(http:Request req) returns products:ProductResponse|persist:Error? {
        return products:getProducts();
    }

    resource function get products/[int id]() returns products:Product|DataNotFound|error? {
        return products:getProductsById(id);
    }

    // ---------------------------------------------- Supermarket Resource Functions ----------------------------------------------
    resource function get supermarkets() returns supermarkets:SupermarketResponse|error? {
        return supermarkets:get_supermarkets();
    }

    resource function get supermarkets/[int id]() returns db:Supermarket|supermarkets:SuperMarketNotFound|error? {
        return supermarkets:get_supermarket_by_id(id);
    }

    resource function post supermarket(http:Request req, @http:Payload supermarkets:NewSupermarket supermartInsert) returns db:Supermarket|http:Unauthorized|persist:Error|error? {
        auth:User user = check auth:getUser(req);
        return check supermarkets:register_supermarket(user, supermartInsert);
    }

    // ---------------------------------------------- Supermarket Items Resource Functions ----------------------------------------------
    resource function get supermarketitems(http:Request req, @http:Query int productId) returns supermarket_items:SupermarketItemResponse|error {
        auth:User user = check auth:getUser(req);
        // if user is supermarket manager then return all items belongs to the supermarket
        return supermarket_items:get_supermarket_items(user, productId);
    }

    resource function get supermarketitems/[int id]() returns db:SupermarketItemWithRelations|error {
        return supermarket_items:get_supermarket_item_by_id(id);
    }

    resource function patch supermarketitems/[int id](http:Request req, @http:Payload db:SupermarketItemUpdate supermarketItem) returns db:SupermarketItem|error {
        auth:User user = check auth:getUser(req);
        return supermarket_items:editSupermarketItem(user, id, supermarketItem);
    }

    // ---------------------------------------------- Cart Resource Functions ----------------------------------------------
    resource function get carts(http:Request req) returns cart:CartItemResponse|error {
        auth:User user = check auth:getUser(req);
        return cart:getCartItems(user.consumerId ?: -1);
    }

    resource function post carts(http:Request req, cart:CartItemInsert cartItem) returns db:CartItem|int|error {
        auth:User user = check auth:getUser(req);
        return cart:addCartItem(user.consumerId ?: -1, cartItem);
    }

    resource function patch carts/[int id](http:Request req, cart:CartItem cartItem) returns db:CartItem|int|error {
        auth:User user = check auth:getUser(req);
        return cart:updateCartItem(user.consumerId ?: -1, cartItem);
    }

    resource function delete carts(http:Request req, int id) returns db:CartItem|error {
        auth:User user = check auth:getUser(req);
        return cart:removeCartItem(user.consumerId ?: -1, id);
    }

    // ---------------------------------------------- Opportunities Resource Functions ----------------------------------------------
    resource function get opportunities(http:Request req, @http:Query string status, @http:Query int _limit) returns opportunities:OpportunityResponse|http:Unauthorized|error {
        auth:User user = check auth:getUser(req);
        return opportunities:getOpportunities(user, status, _limit);
    }

    resource function get opportunities/[int id]() returns opportunities:OpportunityNotFound|db:OpportunityWithRelations {
        return opportunities:getOpportunitiesById(id);
    }

    resource function post accept_opportunity/[int id](http:Request req) returns db:Opportunity|error {
        auth:User user = check auth:getUser(req);
        return opportunities:accept_opportunity(user, id);
    }

    resource function post complete_delivery/[int id](http:Request req) returns db:Opportunity|error {
        auth:User user = check auth:getUser(req);
        return opportunities:complete_delivery(user, id);
    }

    // ---------------------------------------------- Order Resource Functions ----------------------------------------------

    resource function get orders(http:Request req, int supermarketId) returns orders:OrderResponse|error {
        auth:User user = check auth:getUser(req);
        return orders:getOrders(user, supermarketId);
    }

    resource function get orders/[int id]() returns db:OrderWithRelations|orders:OrderNotFound|error? {
        return orders:getOrdersById(id);
    }

    resource function post cartToOrder(@http:Payload orders:CartToOrderRequest cartToOrderRequest) returns db:OrderWithRelations|persist:Error|error {
        return orders:cartToOrder(cartToOrderRequest);
    }

    resource function post supermarket_order_ready(http:Request req, orders:OrderReadyRequest orderReadyRequest) returns db:SupermarketOrderWithRelations|orders:OrderNotFound|http:Unauthorized|error {
        auth:User user = check auth:getUser(req);
        return orders:supermarket_order_ready(user, orderReadyRequest);
    }

    //---------------------------------Advertisement Resource Functions----------------------------------------------

    resource function get advertisements() returns db:Advertisement[]|error? {
        return advertisements:getAdvertisements();
    }

    resource function get advertisements/[int id]() returns db:Advertisement|advertisements:AdvertisementNotFound|error? {
        return advertisements:getAdvertisementsById(id);
    }

    resource function post advertisements(http:Request req, @http:Payload db:AdvertisementInsert advertisement) returns db:Advertisement|error {
        return advertisements:addAdvertisement(advertisement);
    }

    resource function patch advertisements/[int id](http:Request req, @http:Payload db:AdvertisementUpdate advertisement) returns db:Advertisement|advertisements:AdvertisementNotFound|error? {
        return advertisements:updateAdvertisement(id, advertisement);
    }

    resource function patch deactivate_advertisements/[int id]() returns error? {
        return advertisements:deactivateAdvertisement(id);
    }

    //--------------------------------- Stats Resource Functions----------------------------------------------
    resource function get stats/supermarket_earnings() returns stats:EarningResponse|error {
        return stats:get_all_supermarket_earnings();
    }

    resource function get stats/supermarket_earnings/[int supermarketId]() returns float|error {
        return stats:get_supermarket_earnings(supermarketId);
    }

    resource function get stats/feedbacks_by_supermarket_id(int supermarketId) returns reviews:ReviewResponse|error {
        return stats:get_feedbacks_by_supermarket_id(supermarketId);
    }

    //--------------------------------- Review Resource Functions----------------------------------------------
    resource function get reviews(string reviewType, int targetId) returns reviews:ReviewResponse|error? {
        return reviews:get_reviews(reviewType, targetId);
    }

    resource function get reviews/[int id]() returns db:Review|error? {
        return reviews:get_review_by_id(id);
    }

    resource function post reviews(http:Request req, @http:Payload reviews:ReviewInsert review) returns int|error? {
        auth:User user = check auth:getUser(req);
        return reviews:create_review(user, review);
    }

}
