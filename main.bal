import backend.activity;
import backend.addresses;
import backend.advertisements;
import backend.auth;
import backend.cart;
import backend.consumer;
import backend.db;
import backend.distanceCalculation;
import backend.driver;
import backend.file_service;
import backend.liked_products;
import backend.locations;
import backend.opportunities;
import backend.optimizer;
import backend.orders;
import backend.payments;
import backend.products;
import backend.reviews;
import backend.stats;
import backend.supermarket_items;
import backend.supermarkets;
import backend.user;
import backend.user_preference;
import backend.user_registration;
import backend.utils;

import ballerina/http;
import ballerina/io;
import ballerina/persist;

type productQuery record {|
    int category;
    float price;
    string sortOrder;
    string searchText;
    int page;
    int _limit;
|};

@http:ServiceConfig {
    cors: {
        allowOrigins: ["*"],
        allowCredentials: true,
        maxAge: 84900
    }
}
service / on new http:Listener(9090) {

    function init() returns error? {
        io:println("Service started on port 9090");
        _ = start utils:sendHeartbeat();
    }

    // ------------------------------------------- User Login and Signup Resource Functions ---------------------------------------
    resource function post login(@http:Payload auth:Credentials credentials) returns auth:UserwithToken|error {
        return auth:login(credentials);
    }

    resource function post generate_otp(@http:Payload user_registration:RegisterForm registerForm) returns string|error {
        return user_registration:otp_genaration(registerForm);
    }

    resource function post match_otp(@http:Payload user_registration:OtpMappingRequest otpMappingRequest) returns string|error|user_registration:NonVerifyUserNotFound {
        return user_registration:checkOtpMatching(otpMappingRequest);
    }

    // ---------------------------------------------- Driver Signup Resource Functions --------------------------------------------

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
    resource function post update_driver_vehicle_details/[int id](@http:Payload db:NonVerifiedDriverOptionalized driverUpdate) returns db:NonVerifiedDriver|error {
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

    // ---------------------------------------------- User Resource Functions ------------------------------------------------
    resource function get users(http:Request req) returns user:UserResponse|http:Unauthorized|error {
        auth:User user = check auth:getUser(req);
        return user:get_all_user(user);
    }

    resource function get users/[int id](http:Request req) returns db:UserWithRelations|http:Unauthorized|error {
        auth:User user = check auth:getUser(req);
        return user:get_user(user, id);
    }

    resource function patch users/[int id](http:Request req, @http:Payload db:UserUpdate userUpdate) returns db:User|error {
        auth:User user = check auth:getUser(req);
        return user:update_user(user, userUpdate);
    }

    resource function patch change_password/[int id](http:Request req, @http:Payload user:UpdatePassword updatePassword) returns db:User|error {
        auth:User user = check auth:getUser(req);
        return user:update_password(user, id, updatePassword);
    }

    resource function patch update_profile_picture/[int id](http:Request req) returns string|error {
        auth:User user = check auth:getUser(req);
        return user:update_profile_picture(user, req, id);
    }

    // ---------------------------------------------- Driver Resource Functions ----------------------------------------------
    resource function get drivers() returns driver:DriverResponse|http:Unauthorized|error {
        return driver:get_all_drivers();
    }

    resource function get drivers/[int id](http:Request req) returns db:DriverWithRelations|http:Unauthorized|error {
        auth:User user = check auth:getUser(req);
        return driver:get_driver(user, id);
    }

    resource function patch update_driver_profile_picture/[int id](http:Request req) returns string|error {
        return user_registration:update_driver_profile_picture(req, id);
    }

    // ---------------------------------------------- Consumer Resource Functions -----------------------------------------------
    resource function get consumers(@http:Query string searchText, int month, int page, int _limit) returns consumer:ConsumerResponse|http:Unauthorized|error {
        return consumer:get_all_consumers(searchText, month, page, _limit);
    }

    resource function get consumers/[int id](http:Request req) returns consumer:Consumer|http:Unauthorized|error {
        auth:User user = check auth:getUser(req);
        return consumer:get_consumer(user, id);
    }

    // ---------------------------------------------- Consumer Address Resource Functions ---------------------------------------
    resource function get addresses(http:Request req) returns addresses:AddressesResponse|error {
        auth:User user = check auth:getUser(req);
        return addresses:get_all_addresses(user);
    }

    resource function post addresses(http:Request req, @http:Payload db:AddressInsert consumerAddress) returns string|error {
        auth:User user = check auth:getUser(req);
        return addresses:create_consumer_address(user, consumerAddress);
    }

    resource function patch addresses/default/[int id](http:Request req) returns string|error {
        auth:User user = check auth:getUser(req);
        return addresses:update_consumer_default_address(user, id);
    }

    // ---------------------------------------------- Consumer Activity Resource Functions --------------------------------------- 
    resource function get activities(http:Request req) returns activity:ActivityResponse|error? {
        do {
            auth:User user = check auth:getUser(req);
            return activity:getActivities(user);
        } on fail {
            return {count: 0, next: false, activities: []};
        }
    }

    resource function post activities(http:Request req, @http:Payload record {string description;} payload) returns int|error {
        auth:User user = check auth:getUser(req);
        return activity:createActivity(user, payload.description);
    }

    // ---------------------------------------------- Products Resource Functions -----------------------------------------------
    resource function get products(
            string category,
            string price,
            string ordering,
            string searchText,
            int page,
            int _limit
            ) returns products:ProductResponse|error {
        return products:getProducts(category, price, ordering, searchText, page, _limit);
    }

    resource function get products/[int id]() returns db:ProductWithRelations|error? {
        return products:getProductsById(id);
    }

    // ---------------------------------------------- Liked Products Resource Functions ------------------------------------------
    resource function get liked_products(http:Request req) returns liked_products:LikedProductResponse|error? {
        do {
            auth:User user = check auth:getUser(req);
            return liked_products:get_liked_products(user);
        } on fail {
            return {count: 0, next: false, results: []};
        }
    }

    resource function post liked_products(http:Request req, @http:Payload record {int productId;} payload) returns int|error {
        auth:User user = check auth:getUser(req);
        return liked_products:create_liked_product(user, payload.productId);
    }

    resource function delete liked_products/[int id](http:Request req) returns string|error {
        auth:User user = check auth:getUser(req);
        return liked_products:delete_liked_product(user, id);
    }

    // ---------------------------------------------- Supermarket Resource Functions ---------------------------------------------
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

    // ---------------------------------------------- Supermarket Items Resource Functions --------------------------------------
    // return all supermarket items for that product id
    resource function get supermarket_items(http:Request req, @http:Query int productId) returns supermarket_items:SupermarketItemResponse|error {
        auth:User user = check auth:getUser(req);
        return supermarket_items:get_supermarket_items_by_product_id(user, productId);
    }

    //  return all supermarket items belongs to the supermarket to the supermarket manager
    resource function get supermarket_items_all(http:Request req) returns supermarket_items:SupermarketItemResponse|error {
        auth:User user = check auth:getUser(req);
        return supermarket_items:get_all_supermarket_items(user);
    }

    resource function get supermarket_items/[int id]() returns db:SupermarketItemWithRelations|error {
        return supermarket_items:get_supermarket_item_by_id(id);
    }

    resource function patch supermarket_items/[int id](http:Request req, @http:Payload db:SupermarketItemUpdate supermarketItem) returns db:SupermarketItem|error {
        auth:User user = check auth:getUser(req);
        return supermarket_items:editSupermarketItem(user, id, supermarketItem);
    }

    // ---------------------------------------------- Cart Items Resource Functions ---------------------------------------------------
    resource function get cart_items(http:Request req) returns cart:CartItemResponse|error {
        do {
            auth:User user = check auth:getUser(req);
            return cart:getCartItems(user.consumerId ?: -1);
        } on fail {
            return {count: 0, next: "null", results: []};
        }
    }

    resource function post cart_items(http:Request req, db:CartItemInsert cartItem) returns db:CartItem|int|error {
        auth:User user = check auth:getUser(req);
        return cart:addCartItem(user.consumerId ?: -1, cartItem);
    }

    resource function patch cart_items/[int id](http:Request req, db:CartItem cartItem) returns db:CartItem|int|error {
        auth:User user = check auth:getUser(req);
        return cart:updateCartItem(user.consumerId ?: -1, cartItem);
    }

    resource function delete cart_items/[int id](http:Request req) returns db:CartItem|error {
        auth:User user = check auth:getUser(req);
        return cart:removeCartItem(user.consumerId ?: -1, id);
    }

    // ---------------------------------------------- Opportunities Resource Functions -------------------------------------------
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

    // ---------------------------------------------- Order Resource Functions ------------------------------------------------

    resource function get orders(http:Request req, int supermarketId) returns orders:OrderResponse|error {
        auth:User user = check auth:getUser(req);
        return orders:getOrders(user, supermarketId);
    }

    resource function get orders/[int id]() returns db:OrderWithRelations|orders:OrderNotFound|error? {
        return orders:getOrdersById(id);
    }

    resource function post cart_to_order(@http:Payload orders:CartToOrderRequest cartToOrderRequest) returns int|persist:Error|error {
        return orders:cartToOrder(cartToOrderRequest);
    }

    resource function post supermarket_order_ready(http:Request req, orders:OrderReadyRequest orderReadyRequest) returns db:SupermarketOrderWithRelations|orders:OrderNotFound|http:Unauthorized|error {
        auth:User user = check auth:getUser(req);
        return orders:supermarket_order_ready(user, orderReadyRequest);
    }

    resource function get allOrders(http:Request req) returns orders:OrderResponse|error {
        return orders:getAllOrders();
    }

    //---------------------------------Advertisement Resource Functions---------------------------------------------------------

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

    //------------------------------------------ Stats Resource Functions ------------------------------------------------------
    resource function get stats/supermarket_earnings() returns stats:EarningResponse|error {
        return stats:get_all_supermarket_earnings();
    }

    resource function get stats/supermarket_earnings/[int supermarketId]() returns float|error {
        return stats:get_supermarket_earnings(supermarketId);
    }

    resource function get stats/feedbacks_by_supermarket_id(int supermarketId) returns reviews:ReviewResponse|error {
        return stats:get_feedbacks_by_supermarket_id(supermarketId);
    }

    resource function get stats/drivers_earnings/[int driverId]() returns float|error {
        return stats:get_driver_earnings(driverId);

    }

    resource function get stats/supermarket_sales() returns stats:SalesResponse|error {
        return stats:get_all_supermarket_sales();
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

    //-------------------------------------------- Payment Resource Functions----------------------------------------------------
    resource function get payments/orders/[int orderId](http:Request req) returns payments:payhereRequest|http:Unauthorized|error {
        auth:User user = check auth:getUser(req);
        return payments:get_order_payment(user, orderId);
    }

    resource function post payhere_verify(http:Request req) returns string|error {
        return payments:payhere_verify(check req.getFormParams());
    }

    //-------------------------------------------- Location Resource Functions----------------------------------------------------
    resource function post locations/consumer_supermarket_distance(@http:Payload record {string location1; string location2;} payload) returns float|error {
        return locations:get_consumer_supermarket_distance(payload.location1, payload.location2);
    }

    resource function post locations/delivery_cost(@http:Payload record {string[] supermarketLocations; string deliveryLocation;} payload) returns float|error {
        return locations:get_delivery_cost(payload.supermarketLocations, payload.deliveryLocation);
    }

    resource function post locations/optimize_route(@http:Payload record {int[] supermarketIds; string homeLocation;} payload) returns locations:OptimizedRoute|error {
        return locations:getOptimizedRoute(payload.supermarketIds, payload.homeLocation);
    }

    //-------------------------------------------- Heartbeat Resource Functions----------------------------------------------------

    resource function get heartbeat() returns string {
        return "Heartbeat successful";
    }

    // ---------------------------------------------- Serve Files  -----------------------------------------------------------
    resource function get images/[string path]() returns byte[]|error {
        return file_service:getImage(path);
    };

    // ---------------------------------------------- Optimizing Algorithm  -----------------------------------------------------------
    //     resource function get optimizer() returns optimizer:Item[] {
    //     // Hardcoded list of items
    //     io:println("Optimizer service called");
    //     optimizer:Item[] items = [
    //         {id: 1, name: "item1", price: 100.0, rating: 4, distance: 10.0, score: 0.0 , userPreference: 0.0},
    //         {id: 2, name: "item2", price: 150.0, rating: 5, distance: 15.0, score: 0.0, userPreference: 0.0},
    //         {id: 3, name: "item3", price: 120.0, rating: 3, distance: 12.0, score: 0.0, userPreference: 0.0},
    //         {id: 4, name: "item4", price: 200.0, rating: 4, distance: 8.0, score: 0.0, userPreference: 0.0}
    //     ];

    //     return optimizer:rateItems(items);
    // }

    resource function get optimizer(@http:Query int userId, @http:Query string location) returns json|error|optimizer:ScoredItem[] {
        return optimizer:OptimizeCart(userId, location);
    }

    resource function post userpreference/add(@http:Payload user_preference:UserPreference userPreference) returns db:UserPreference|string|error {
        return user_preference:calculatePoints(userPreference);
    }

    // ---------------------------------------------- distance cal Files  -----------------------------------------------------------
    resource function get distanceCalculation(int[] id, string currentLocation) returns map<float>|error? {
        return distanceCalculation:distanceCalculation(id, currentLocation);
    };

}
