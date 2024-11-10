// AUTO-GENERATED FILE. DO NOT MODIFY.

// This file is an auto-generated file by Ballerina persistence layer for model.
// It should not be modified by hand.

import ballerina/time;

public enum NonVerifiedDriverStatus {
    OTPPending,
    OTPVerified,
    Accepted,
    Declined
}

public enum OrderStatus {
    ToPay,
    Placed,
    Prepared,
    Processing,
    Ready,
    Delivered,
    Cancelled
}

public type User record {|
    readonly int id;
    string name;
    string email;
    string password;
    string number;
    string profilePic;
    string role;
    string status;
    time:Civil? lastLogin;
    time:Civil createdAt;
    time:Civil updatedAt;
    time:Civil? deletedAt;

|};

public type UserOptionalized record {|
    int id?;
    string name?;
    string email?;
    string password?;
    string number?;
    string profilePic?;
    string role?;
    string status?;
    time:Civil? lastLogin?;
    time:Civil createdAt?;
    time:Civil updatedAt?;
    time:Civil? deletedAt?;
|};

public type UserWithRelations record {|
    *UserOptionalized;
    ConsumerOptionalized consumer?;
    SupermarketOptionalized supermarket?;
    DriverOptionalized driver?;
    ReviewOptionalized[] review?;
|};

public type UserTargetType typedesc<UserWithRelations>;

public type UserInsert record {|
    string name;
    string email;
    string password;
    string number;
    string profilePic;
    string role;
    string status;
    time:Civil? lastLogin;
    time:Civil createdAt;
    time:Civil updatedAt;
    time:Civil? deletedAt;
|};

public type UserUpdate record {|
    string name?;
    string email?;
    string password?;
    string number?;
    string profilePic?;
    string role?;
    string status?;
    time:Civil? lastLogin?;
    time:Civil createdAt?;
    time:Civil updatedAt?;
    time:Civil? deletedAt?;
|};

public type NonVerifyUser record {|
    readonly int id;
    string name;
    string email;
    string contactNo;
    string OTP;
    string password;
|};

public type NonVerifyUserOptionalized record {|
    int id?;
    string name?;
    string email?;
    string contactNo?;
    string OTP?;
    string password?;
|};

public type NonVerifyUserTargetType typedesc<NonVerifyUserOptionalized>;

public type NonVerifyUserInsert record {|
    string name;
    string email;
    string contactNo;
    string OTP;
    string password;
|};

public type NonVerifyUserUpdate record {|
    string name?;
    string email?;
    string contactNo?;
    string OTP?;
    string password?;
|};

public type NonVerifiedDriver record {|
    readonly int id;
    string name;
    string nic;
    string email;
    string contactNo;
    string OTP;
    string courierCompany;
    string vehicleType;
    string vehicleColor;
    string vehicleName;
    string vehicleNumber;
    string password;
    NonVerifiedDriverStatus status;
    time:Civil createdAt;
|};

public type NonVerifiedDriverOptionalized record {|
    int id?;
    string name?;
    string nic?;
    string email?;
    string contactNo?;
    string OTP?;
    string courierCompany?;
    string vehicleType?;
    string vehicleColor?;
    string vehicleName?;
    string vehicleNumber?;
    string password?;
    NonVerifiedDriverStatus status?;
    time:Civil createdAt?;
|};

public type NonVerifiedDriverTargetType typedesc<NonVerifiedDriverOptionalized>;

public type NonVerifiedDriverInsert record {|
    string name;
    string nic;
    string email;
    string contactNo;
    string OTP;
    string courierCompany;
    string vehicleType;
    string vehicleColor;
    string vehicleName;
    string vehicleNumber;
    string password;
    NonVerifiedDriverStatus status;
    time:Civil createdAt;
|};

public type NonVerifiedDriverUpdate record {|
    string name?;
    string nic?;
    string email?;
    string contactNo?;
    string OTP?;
    string courierCompany?;
    string vehicleType?;
    string vehicleColor?;
    string vehicleName?;
    string vehicleNumber?;
    string password?;
    NonVerifiedDriverStatus status?;
    time:Civil createdAt?;
|};

public type Address record {|
    readonly int id;
    string addressName;
    string address;
    string city;
    string location;
    boolean isDefault;
    int consumerId;
|};

public type AddressOptionalized record {|
    int id?;
    string addressName?;
    string address?;
    string city?;
    string location?;
    boolean isDefault?;
    int consumerId?;
|};

public type AddressWithRelations record {|
    *AddressOptionalized;
    ConsumerOptionalized consumer?;
|};

public type AddressTargetType typedesc<AddressWithRelations>;

public type AddressInsert record {|
    string addressName;
    string address;
    string city;
    string location;
    boolean isDefault;
    int consumerId;
|};

public type AddressUpdate record {|
    string addressName?;
    string address?;
    string city?;
    string location?;
    boolean isDefault?;
    int consumerId?;
|};

public type Supermarket record {|
    readonly int id;
    string name;
    string contactNo;
    string logo;
    string location;
    string city;
    string address;
    int supermarketmanagerId;

|};

public type SupermarketOptionalized record {|
    int id?;
    string name?;
    string contactNo?;
    string logo?;
    string location?;
    string city?;
    string address?;
    int supermarketmanagerId?;
|};

public type SupermarketWithRelations record {|
    *SupermarketOptionalized;
    UserOptionalized supermarketManager?;
    SupermarketItemOptionalized[] supermarketItems?;
    OpportunitySupermarketOptionalized[] opportunitysupermarket?;
    SupermarketOrderOptionalized[] supermarketOrder?;
|};

public type SupermarketTargetType typedesc<SupermarketWithRelations>;

public type SupermarketInsert record {|
    string name;
    string contactNo;
    string logo;
    string location;
    string city;
    string address;
    int supermarketmanagerId;
|};

public type SupermarketUpdate record {|
    string name?;
    string contactNo?;
    string logo?;
    string location?;
    string city?;
    string address?;
    int supermarketmanagerId?;
|};

public type Product record {|
    readonly int id;
    string name;
    string description;
    string category;
    float price;
    string imageUrl;

|};

public type ProductOptionalized record {|
    int id?;
    string name?;
    string description?;
    string category?;
    float price?;
    string imageUrl?;
|};

public type ProductWithRelations record {|
    *ProductOptionalized;
    SupermarketItemOptionalized[] supermarketItems?;
|};

public type ProductTargetType typedesc<ProductWithRelations>;

public type ProductInsert record {|
    string name;
    string description;
    string category;
    float price;
    string imageUrl;
|};

public type ProductUpdate record {|
    string name?;
    string description?;
    string category?;
    float price?;
    string imageUrl?;
|};

public type SupermarketItem record {|
    readonly int id;
    int productId;
    int supermarketId;
    float price;
    float discount;
    int availableQuantity;

|};

public type SupermarketItemOptionalized record {|
    int id?;
    int productId?;
    int supermarketId?;
    float price?;
    float discount?;
    int availableQuantity?;
|};

public type SupermarketItemWithRelations record {|
    *SupermarketItemOptionalized;
    ProductOptionalized product?;
    SupermarketOptionalized supermarket?;
    CartItemOptionalized[] cartItem?;
|};

public type SupermarketItemTargetType typedesc<SupermarketItemWithRelations>;

public type SupermarketItemInsert record {|
    int productId;
    int supermarketId;
    float price;
    float discount;
    int availableQuantity;
|};

public type SupermarketItemUpdate record {|
    int productId?;
    int supermarketId?;
    float price?;
    float discount?;
    int availableQuantity?;
|};

public type CartItem record {|
    readonly int id;
    int supermarketitemId;
    int quantity;
    int consumerId;
    int productId;
|};

public type CartItemOptionalized record {|
    int id?;
    int supermarketitemId?;
    int quantity?;
    int consumerId?;
    int productId?;
|};

public type CartItemWithRelations record {|
    *CartItemOptionalized;
    SupermarketItemOptionalized supermarketItem?;
|};

public type CartItemTargetType typedesc<CartItemWithRelations>;

public type CartItemInsert record {|
    int supermarketitemId;
    int quantity;
    int consumerId;
    int productId;
|};

public type CartItemUpdate record {|
    int supermarketitemId?;
    int quantity?;
    int consumerId?;
    int productId?;
|};

public type OrderItems record {|
    readonly int id;
    int supermarketId;
    int productId;
    int quantity;
    float price;
    int _orderId;
|};

public type OrderItemsOptionalized record {|
    int id?;
    int supermarketId?;
    int productId?;
    int quantity?;
    float price?;
    int _orderId?;
|};

public type OrderItemsWithRelations record {|
    *OrderItemsOptionalized;
    OrderOptionalized _order?;
|};

public type OrderItemsTargetType typedesc<OrderItemsWithRelations>;

public type OrderItemsInsert record {|
    int supermarketId;
    int productId;
    int quantity;
    float price;
    int _orderId;
|};

public type OrderItemsUpdate record {|
    int supermarketId?;
    int productId?;
    int quantity?;
    float price?;
    int _orderId?;
|};

public type Order record {|
    readonly int id;
    int consumerId;
    OrderStatus status;
    string shippingAddress;
    string shippingMethod;
    string location;

    float deliveryFee;
    time:Civil orderPlacedOn;

|};

public type OrderOptionalized record {|
    int id?;
    int consumerId?;
    OrderStatus status?;
    string shippingAddress?;
    string shippingMethod?;
    string location?;
    float deliveryFee?;
    time:Civil orderPlacedOn?;
|};

public type OrderWithRelations record {|
    *OrderOptionalized;
    OrderItemsOptionalized[] orderItems?;
    SupermarketOrderOptionalized[] supermarketOrders?;
    OpportunityOptionalized[] opportunity?;
|};

public type OrderTargetType typedesc<OrderWithRelations>;

public type OrderInsert record {|
    int consumerId;
    OrderStatus status;
    string shippingAddress;
    string shippingMethod;
    string location;
    float deliveryFee;
    time:Civil orderPlacedOn;
|};

public type OrderUpdate record {|
    int consumerId?;
    OrderStatus status?;
    string shippingAddress?;
    string shippingMethod?;
    string location?;
    float deliveryFee?;
    time:Civil orderPlacedOn?;
|};

public type SupermarketOrder record {|
    readonly int id;
    string status;
    string qrCode;
    int _orderId;
    int supermarketId;
|};

public type SupermarketOrderOptionalized record {|
    int id?;
    string status?;
    string qrCode?;
    int _orderId?;
    int supermarketId?;
|};

public type SupermarketOrderWithRelations record {|
    *SupermarketOrderOptionalized;
    OrderOptionalized _order?;
    SupermarketOptionalized supermarket?;
|};

public type SupermarketOrderTargetType typedesc<SupermarketOrderWithRelations>;

public type SupermarketOrderInsert record {|
    string status;
    string qrCode;
    int _orderId;
    int supermarketId;
|};

public type SupermarketOrderUpdate record {|
    string status?;
    string qrCode?;
    int _orderId?;
    int supermarketId?;
|};

public type OpportunitySupermarket record {|
    readonly int id;
    int supermarketId;
    int opportunityId;
|};

public type OpportunitySupermarketOptionalized record {|
    int id?;
    int supermarketId?;
    int opportunityId?;
|};

public type OpportunitySupermarketWithRelations record {|
    *OpportunitySupermarketOptionalized;
    SupermarketOptionalized supermarket?;
    OpportunityOptionalized opportunity?;
|};

public type OpportunitySupermarketTargetType typedesc<OpportunitySupermarketWithRelations>;

public type OpportunitySupermarketInsert record {|
    int supermarketId;
    int opportunityId;
|};

public type OpportunitySupermarketUpdate record {|
    int supermarketId?;
    int opportunityId?;
|};

public type Opportunity record {|
    readonly int id;
    float totalDistance;
    float tripCost;
    int consumerId;
    float deliveryCost;
    string startLocation;
    string deliveryLocation;

    string status;
    int _orderId;
    int driverId;
    time:Civil orderPlacedOn;
|};

public type OpportunityOptionalized record {|
    int id?;
    float totalDistance?;
    float tripCost?;
    int consumerId?;
    float deliveryCost?;
    string startLocation?;
    string deliveryLocation?;
    string status?;
    int _orderId?;
    int driverId?;
    time:Civil orderPlacedOn?;
|};

public type OpportunityWithRelations record {|
    *OpportunityOptionalized;
    ConsumerOptionalized consumer?;
    OpportunitySupermarketOptionalized[] opportunitysupermarket?;
    OrderOptionalized _order?;
|};

public type OpportunityTargetType typedesc<OpportunityWithRelations>;

public type OpportunityInsert record {|
    float totalDistance;
    float tripCost;
    int consumerId;
    float deliveryCost;
    string startLocation;
    string deliveryLocation;
    string status;
    int _orderId;
    int driverId;
    time:Civil orderPlacedOn;
|};

public type OpportunityUpdate record {|
    float totalDistance?;
    float tripCost?;
    int consumerId?;
    float deliveryCost?;
    string startLocation?;
    string deliveryLocation?;
    string status?;
    int _orderId?;
    int driverId?;
    time:Civil orderPlacedOn?;
|};

public type Consumer record {|
    readonly int id;
    int userId;

|};

public type ConsumerOptionalized record {|
    int id?;
    int userId?;
|};

public type ConsumerWithRelations record {|
    *ConsumerOptionalized;
    UserOptionalized user?;
    AddressOptionalized[] addresses?;
    OpportunityOptionalized[] opportunity?;
|};

public type ConsumerTargetType typedesc<ConsumerWithRelations>;

public type ConsumerInsert record {|
    int userId;
|};

public type ConsumerUpdate record {|
    int userId?;
|};

public type Advertisement record {|
    readonly int id;
    string image;
    string status;
    string startDate;
    string endDate;
    string priority;
|};

public type AdvertisementOptionalized record {|
    int id?;
    string image?;
    string status?;
    string startDate?;
    string endDate?;
    string priority?;
|};

public type AdvertisementTargetType typedesc<AdvertisementOptionalized>;

public type AdvertisementInsert record {|
    string image;
    string status;
    string startDate;
    string endDate;
    string priority;
|};

public type AdvertisementUpdate record {|
    string image?;
    string status?;
    string startDate?;
    string endDate?;
    string priority?;
|};

public type Driver record {|
    readonly int id;
    int userId;
    string nic;
    string courierCompany;
    string vehicleType;
    string vehicleColor;
    string vehicleName;
    string vehicleNumber;
|};

public type DriverOptionalized record {|
    int id?;
    int userId?;
    string nic?;
    string courierCompany?;
    string vehicleType?;
    string vehicleColor?;
    string vehicleName?;
    string vehicleNumber?;
|};

public type DriverWithRelations record {|
    *DriverOptionalized;
    UserOptionalized user?;
|};

public type DriverTargetType typedesc<DriverWithRelations>;

public type DriverInsert record {|
    int userId;
    string nic;
    string courierCompany;
    string vehicleType;
    string vehicleColor;
    string vehicleName;
    string vehicleNumber;
|};

public type DriverUpdate record {|
    int userId?;
    string nic?;
    string courierCompany?;
    string vehicleType?;
    string vehicleColor?;
    string vehicleName?;
    string vehicleNumber?;
|};

public type Review record {|
    readonly int id;
    string reviewType;
    int userId;
    int targetId;
    string title;
    string content;
    float rating;
    time:Civil createdAt;
|};

public type ReviewOptionalized record {|
    int id?;
    string reviewType?;
    int userId?;
    int targetId?;
    string title?;
    string content?;
    float rating?;
    time:Civil createdAt?;
|};

public type ReviewWithRelations record {|
    *ReviewOptionalized;
    UserOptionalized user?;
|};

public type ReviewTargetType typedesc<ReviewWithRelations>;

public type ReviewInsert record {|
    string reviewType;
    int userId;
    int targetId;
    string title;
    string content;
    float rating;
    time:Civil createdAt;
|};

public type ReviewUpdate record {|
    string reviewType?;
    int userId?;
    int targetId?;
    string title?;
    string content?;
    float rating?;
    time:Civil createdAt?;
|};

public type LikedProduct record {|
    readonly int id;
    int userId;
    int productId;
|};

public type LikedProductOptionalized record {|
    int id?;
    int userId?;
    int productId?;
|};

public type LikedProductTargetType typedesc<LikedProductOptionalized>;

public type LikedProductInsert record {|
    int userId;
    int productId;
|};

public type LikedProductUpdate record {|
    int userId?;
    int productId?;
|};

public type Files record {|
    readonly int id;
    string name;
    byte[] data;
|};

public type FilesOptionalized record {|
    int id?;
    string name?;
    byte[] data?;
|};

public type FilesTargetType typedesc<FilesOptionalized>;

public type FilesInsert record {|
    string name;
    byte[] data;
|};

public type FilesUpdate record {|
    string name?;
    byte[] data?;
|};

public type Activity record {|
    readonly int id;
    int userId;
    string description;
    time:Civil dateTime;
|};

public type ActivityOptionalized record {|
    int id?;
    int userId?;
    string description?;
    time:Civil dateTime?;
|};

public type ActivityTargetType typedesc<ActivityOptionalized>;

public type ActivityInsert record {|
    int userId;
    string description;
    time:Civil dateTime;
|};

public type ActivityUpdate record {|
    int userId?;
    string description?;
    time:Civil dateTime?;
|};

