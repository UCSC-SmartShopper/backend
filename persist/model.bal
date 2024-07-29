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
|};

type NonVerifyUser record {|
    @sql:Generated
    readonly int id;
    string contactNo;
    string name;
    string OTP;
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

type Consumer record {|
    @sql:Generated
    readonly int id;
    User user;
    Address[] addresses;
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
    int supermarketItemId;
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
|};

