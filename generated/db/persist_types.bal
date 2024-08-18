// AUTO-GENERATED FILE. DO NOT MODIFY.

// This file is an auto-generated file by Ballerina persistence layer for model.
// It should not be modified by hand.

import ballerina/time;

public type User record {|
    readonly int id;
    string name;
    string email;
    string password;
    string number;
    string profilePic;
    string role;
    string status;
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
    time:Civil createdAt?;
    time:Civil updatedAt?;
    time:Civil? deletedAt?;
|};

public type UserWithRelations record {|
    *UserOptionalized;
    ConsumerOptionalized consumer?;
    SupermarketOptionalized supermarket?;
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
    string otpStatus;
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
    string otpStatus?;
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
    string otpStatus;
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
    string otpStatus?;
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
    string address;
    int supermarketmanagerId;

|};

public type SupermarketOptionalized record {|
    int id?;
    string name?;
    string contactNo?;
    string logo?;
    string location?;
    string address?;
    int supermarketmanagerId?;
|};

public type SupermarketWithRelations record {|
    *SupermarketOptionalized;
    UserOptionalized supermarketManager?;
    SupermarketItemOptionalized[] storeprice?;
    OpportunitySupermarketOptionalized[] opportunitysupermarket?;
    SupermarketOrderOptionalized[] supermarketorder?;
|};

public type SupermarketTargetType typedesc<SupermarketWithRelations>;

public type SupermarketInsert record {|
    string name;
    string contactNo;
    string logo;
    string location;
    string address;
    int supermarketmanagerId;
|};

public type SupermarketUpdate record {|
    string name?;
    string contactNo?;
    string logo?;
    string location?;
    string address?;
    int supermarketmanagerId?;
|};

public type Product record {|
    readonly int id;
    string name;
    string description;
    float price;
    string imageUrl;

|};

public type ProductOptionalized record {|
    int id?;
    string name?;
    string description?;
    float price?;
    string imageUrl?;
|};

public type ProductWithRelations record {|
    *ProductOptionalized;
    SupermarketItemOptionalized[] storeprice?;
|};

public type ProductTargetType typedesc<ProductWithRelations>;

public type ProductInsert record {|
    string name;
    string description;
    float price;
    string imageUrl;
|};

public type ProductUpdate record {|
    string name?;
    string description?;
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
|};

public type CartItemOptionalized record {|
    int id?;
    int supermarketitemId?;
    int quantity?;
    int consumerId?;
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
|};

public type CartItemUpdate record {|
    int supermarketitemId?;
    int quantity?;
    int consumerId?;
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
    string status;
    string shippingAddress;
    string shippingMethod;
    string location;

    time:Civil orderPlacedOn;

|};

public type OrderOptionalized record {|
    int id?;
    int consumerId?;
    string status?;
    string shippingAddress?;
    string shippingMethod?;
    string location?;
    time:Civil orderPlacedOn?;
|};

public type OrderWithRelations record {|
    *OrderOptionalized;
    OrderItemsOptionalized[] orderItems?;
    SupermarketOrderOptionalized[] supermarketOrders?;
|};

public type OrderTargetType typedesc<OrderWithRelations>;

public type OrderInsert record {|
    int consumerId;
    string status;
    string shippingAddress;
    string shippingMethod;
    string location;
    time:Civil orderPlacedOn;
|};

public type OrderUpdate record {|
    int consumerId?;
    string status?;
    string shippingAddress?;
    string shippingMethod?;
    string location?;
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
    string orderPlacedOn;
    int consumerId;
    float deliveryCost;
    string startLocation;
    string deliveryLocation;

    string status;
    int orderId;
    int driverId;
|};

public type OpportunityOptionalized record {|
    int id?;
    float totalDistance?;
    float tripCost?;
    string orderPlacedOn?;
    int consumerId?;
    float deliveryCost?;
    string startLocation?;
    string deliveryLocation?;
    string status?;
    int orderId?;
    int driverId?;
|};

public type OpportunityWithRelations record {|
    *OpportunityOptionalized;
    ConsumerOptionalized consumer?;
    OpportunitySupermarketOptionalized[] opportunitysupermarket?;
|};

public type OpportunityTargetType typedesc<OpportunityWithRelations>;

public type OpportunityInsert record {|
    float totalDistance;
    float tripCost;
    string orderPlacedOn;
    int consumerId;
    float deliveryCost;
    string startLocation;
    string deliveryLocation;
    string status;
    int orderId;
    int driverId;
|};

public type OpportunityUpdate record {|
    float totalDistance?;
    float tripCost?;
    string orderPlacedOn?;
    int consumerId?;
    float deliveryCost?;
    string startLocation?;
    string deliveryLocation?;
    string status?;
    int orderId?;
    int driverId?;
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

