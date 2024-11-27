import ballerina/persist as _;
import ballerina/time;
import ballerinax/persist.sql;

type User record {|
    @sql:Generated
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

    Consumer? consumer;
    Supermarket? supermarket;
    Driver? driver;
    Review[] review;
|};

type NonVerifyUser record {|
    @sql:Generated
    readonly int id;
    string name;
    string email;
    string contactNo;
    string OTP;
    string password;
|};

enum NonVerifiedDriverStatus {
    OTPPending,
    OTPVerified,
    Accepted,
    Declined
};

type NonVerifiedDriver record {|
    @sql:Generated
    readonly int id;
    string name;
    string nic;
    string email;
    string contactNo;
    string profilePic;

    // Vehicle details
    string courierCompany;
    string vehicleType;
    string vehicleColor;
    string vehicleName;
    string vehicleNumber;

    // Credentials
    string OTP;
    string password;
    NonVerifiedDriverStatus? status;

    time:Civil createdAt;
|};

type Address record {|
    @sql:Generated
    readonly int id;
    string addressName;
    string address;
    string city;
    string location;
    boolean isDefault;
    Consumer consumer;
|};

type Supermarket record {|
    @sql:Generated
    readonly int id;
    string name;
    string contactNo;
    string logo;
    string location;
    string city;
    string address;
    User supermarketManager;
    SupermarketItem[] supermarketItems;
    OpportunitySupermarket[] opportunitysupermarket;
    SupermarketOrder[] supermarketOrder;
|};

type Product record {|
    @sql:Generated
    readonly int id;
    string name;
    string description;
    string category;
    float price;
    string imageUrl;
    SupermarketItem[] supermarketItems;
|};

type SupermarketItem record {|
    @sql:Generated
    readonly int id;
    Product product;
    Supermarket supermarket;
    float price;
    float discount;
    int availableQuantity;
    CartItem[] cartItem;
|};

type CartItem record {|
    @sql:Generated
    readonly int id;
    SupermarketItem supermarketItem;
    int quantity;

    @sql:UniqueIndex {name: "cart_item_unique_index"}
    int consumerId;
    @sql:UniqueIndex {name: "cart_item_unique_index"}
    int productId;
|};

type OrderItems record {|
    @sql:Generated
    readonly int id;
    int supermarketId;
    int productId;
    int quantity;
    float price;
    Order _order;
|};

enum OrderStatus {
    ToPay,
    Processing,
    Prepared,
    Completed,
    Cancelled
};

type Order record {|
    @sql:Generated
    readonly int id;
    int consumerId;

    string shippingMethod;
    string shippingAddress;
    string shippingLocation;
    
    OrderItems[] orderItems;

    float subTotal;
    float deliveryFee;
    float totalCost;

    time:Civil orderPlacedOn;

    SupermarketOrder[] supermarketOrders;
    Opportunity[] opportunity;

    OrderStatus status;
|};

type SupermarketOrder record {|
    @sql:Generated
    readonly int id;
    string status;
    string qrCode;

    Order _order;
    Supermarket supermarket;
|};

// keep track of the supermarket ids in a perticular opportunity
type OpportunitySupermarket record {|
    @sql:Generated
    readonly int id;

    Supermarket supermarket;
    Opportunity opportunity;
|};

type Opportunity record {|
    @sql:Generated
    readonly int id;

    float totalDistance;
    float tripCost;
    Consumer consumer;
    float deliveryCost;
    string startLocation;
    string deliveryLocation;
    OpportunitySupermarket[] opportunitysupermarket;
    string status;

    byte[] waypoints; // strore the supermarket ids and locations

    Order _order;
    int driverId;

    time:Civil orderPlacedOn;
|};

type Consumer record {|
    @sql:Generated
    readonly int id;
    User user;
    Address[] addresses;
    Opportunity[] opportunity;
|};

type Advertisement record {|
    @sql:Generated
    readonly int id;
    string image;
    string status;
    string startDate;
    string endDate;
    string priority;
|};

type Driver record {|
    @sql:Generated
    readonly int id;
    User user;
    string nic;
    string courierCompany;
    string vehicleType;
    string vehicleColor;
    string vehicleName;
    string vehicleNumber;
|};

type Review record {|
    @sql:Generated
    readonly int id;
    string reviewType;
    User user;
    int targetId;
    string title;
    string content;
    float rating;
    time:Civil createdAt;
|};

type LikedProduct record {|
    @sql:Generated
    readonly int id;

    @sql:UniqueIndex {name: "liked_product_unique_index"}
    int userId;
    @sql:UniqueIndex {name: "liked_product_unique_index"}
    int productId;
|};

type Activity record {|
    @sql:Generated
    readonly int id;
    int userId;
    string description;
    time:Civil dateTime;
|};

type Files record {|
    @sql:Generated
    readonly int id;

    string name;
    byte[] data;

    // User can't have multiple files for same purpose
    // Ex: profile pic, NIC, etc
    @sql:UniqueIndex {name: "file_unique_index"}
    string file_code;
|};

type UserPreference record {|
    @sql:Generated
    readonly int id;
    int userid;
    int points;
    int referenceid;
    time:Civil createdAt;

|};
