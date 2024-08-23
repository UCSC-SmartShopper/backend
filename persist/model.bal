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

    time:Civil createdAt;
    time:Civil updatedAt;
    time:Civil? deletedAt;
    Consumer? consumer;
    Supermarket? supermarket;
    Driver? driver;
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

type NonVerifiedDriver record {|
    @sql:Generated
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
    string status;
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
    string address;
    User supermarketManager;
    SupermarketItem[] storeprice;
    OpportunitySupermarket[] opportunitysupermarket;
    SupermarketOrder[] supermarketorder;
|};

type Product record {|
    @sql:Generated
    readonly int id;
    string name;
    string description;
    float price;
    string imageUrl;
    SupermarketItem[] storeprice;
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
    int consumerId;
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

type Order record {|
    @sql:Generated
    readonly int id;
    int consumerId;
    string status;
    string shippingAddress;
    string shippingMethod;
    string location;
    OrderItems[] orderItems;

    time:Civil orderPlacedOn;

    SupermarketOrder[] supermarketOrders;
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

    int orderId;
    int driverId;
    
    string orderPlacedOn;
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
