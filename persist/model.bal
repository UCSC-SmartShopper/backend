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
    string userRole;
    string status;

    time:Civil createdAt;
    time:Civil updatedAt;
    time:Civil? deletedAt;
    Consumer? consumer;
	Supermarket? supermarket;
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
	PriceList[] pricelist;
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
	PriceList[] pricelist;
|};

type PriceList record {|
    @sql:Generated
    readonly int id;
    Product product;
    Supermarket supermarket;
    float price;
    int quantity;
    float discountedTotal;
	CartItem? cartitem;
|};

type CartItem record {|
    @sql:Generated
    readonly int id;
    PriceList priceList;
    int quantity;
    int consumerId;
|};

