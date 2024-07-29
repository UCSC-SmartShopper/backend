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
    Opportunity? opportunity;
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
    Opportunity opportunity;
|};

type SupermarketItem record {|
    @sql:Generated
    readonly int id;
    Product product;
    Supermarket supermarket;
    float price;
    float discount;
    int availableQuantity;
    CartItem[] cartitem;
|};

type CartItem record {|
    @sql:Generated
    readonly int id;
    SupermarketItem supermarketItem;
    int quantity;
    int consumerId;
|};

type Opportunity record {|
    @sql:Generated
    readonly int id;
    Supermarket[] supermarketList;
    float totalDistance;
    float tripCost;
    string orderPlacedOn;
    Consumer consumer;
    float deliveryCost;
    string startLocation;
    string deliveryLocation;
|};
// export interface Opportunity {
//   id: string;
//   supermarketList: string[];
//   totalDistance: number;
//   tripCost: number;

//   orderPlacedOn: string;
//   customer: string;
//   deliveryCost: number;
//   startLocation: string;
//   deliveryLocation: string;
// }
