// AUTO-GENERATED FILE. DO NOT MODIFY.

// This file is an auto-generated file by Ballerina persistence layer for model.
// It should not be modified by hand.

import ballerina/jballerina.java;
import ballerina/persist;
import ballerina/sql;
import ballerinax/persist.sql as psql;
import ballerinax/postgresql;
import ballerinax/postgresql.driver as _;

const USER = "users";
const NON_VERIFY_USER = "nonverifyusers";
const NON_VERIFIED_DRIVER = "nonverifieddrivers";
const ADDRESS = "addresses";
const SUPERMARKET = "supermarkets";
const PRODUCT = "products";
const SUPERMARKET_ITEM = "supermarketitems";
const CART_ITEM = "cartitems";
const ORDER_ITEMS = "orderitems";
const ORDER = "orders";
const SUPERMARKET_ORDER = "supermarketorders";
const OPPORTUNITY_SUPERMARKET = "opportunitysupermarkets";
const OPPORTUNITY = "opportunities";
const CONSUMER = "consumers";
const ADVERTISEMENT = "advertisements";
const DRIVER = "drivers";
const REVIEW = "reviews";
const LIKED_PRODUCT = "likedproducts";
const ACTIVITY = "activities";
const FILES = "files";

public isolated client class Client {
    *persist:AbstractPersistClient;

    private final postgresql:Client dbClient;

    private final map<psql:SQLClient> persistClients;

    private final record {|psql:SQLMetadata...;|} & readonly metadata = {
        [USER]: {
            entityName: "User",
            tableName: "User",
            fieldMetadata: {
                id: {columnName: "id", dbGenerated: true},
                name: {columnName: "name"},
                email: {columnName: "email"},
                password: {columnName: "password"},
                number: {columnName: "number"},
                profilePic: {columnName: "profilePic"},
                role: {columnName: "role"},
                status: {columnName: "status"},
                lastLogin: {columnName: "lastLogin"},
                createdAt: {columnName: "createdAt"},
                updatedAt: {columnName: "updatedAt"},
                deletedAt: {columnName: "deletedAt"},
                "consumer.id": {relation: {entityName: "consumer", refField: "id"}},
                "consumer.userId": {relation: {entityName: "consumer", refField: "userId"}},
                "supermarket.id": {relation: {entityName: "supermarket", refField: "id"}},
                "supermarket.name": {relation: {entityName: "supermarket", refField: "name"}},
                "supermarket.contactNo": {relation: {entityName: "supermarket", refField: "contactNo"}},
                "supermarket.logo": {relation: {entityName: "supermarket", refField: "logo"}},
                "supermarket.location": {relation: {entityName: "supermarket", refField: "location"}},
                "supermarket.city": {relation: {entityName: "supermarket", refField: "city"}},
                "supermarket.address": {relation: {entityName: "supermarket", refField: "address"}},
                "supermarket.supermarketmanagerId": {relation: {entityName: "supermarket", refField: "supermarketmanagerId"}},
                "driver.id": {relation: {entityName: "driver", refField: "id"}},
                "driver.userId": {relation: {entityName: "driver", refField: "userId"}},
                "driver.nic": {relation: {entityName: "driver", refField: "nic"}},
                "driver.courierCompany": {relation: {entityName: "driver", refField: "courierCompany"}},
                "driver.vehicleType": {relation: {entityName: "driver", refField: "vehicleType"}},
                "driver.vehicleColor": {relation: {entityName: "driver", refField: "vehicleColor"}},
                "driver.vehicleName": {relation: {entityName: "driver", refField: "vehicleName"}},
                "driver.vehicleNumber": {relation: {entityName: "driver", refField: "vehicleNumber"}},
                "review[].id": {relation: {entityName: "review", refField: "id"}},
                "review[].reviewType": {relation: {entityName: "review", refField: "reviewType"}},
                "review[].userId": {relation: {entityName: "review", refField: "userId"}},
                "review[].targetId": {relation: {entityName: "review", refField: "targetId"}},
                "review[].title": {relation: {entityName: "review", refField: "title"}},
                "review[].content": {relation: {entityName: "review", refField: "content"}},
                "review[].rating": {relation: {entityName: "review", refField: "rating"}},
                "review[].createdAt": {relation: {entityName: "review", refField: "createdAt"}}
            },
            keyFields: ["id"],
            joinMetadata: {
                consumer: {entity: Consumer, fieldName: "consumer", refTable: "Consumer", refColumns: ["userId"], joinColumns: ["id"], 'type: psql:ONE_TO_ONE},
                supermarket: {entity: Supermarket, fieldName: "supermarket", refTable: "Supermarket", refColumns: ["supermarketmanagerId"], joinColumns: ["id"], 'type: psql:ONE_TO_ONE},
                driver: {entity: Driver, fieldName: "driver", refTable: "Driver", refColumns: ["userId"], joinColumns: ["id"], 'type: psql:ONE_TO_ONE},
                review: {entity: Review, fieldName: "review", refTable: "Review", refColumns: ["userId"], joinColumns: ["id"], 'type: psql:MANY_TO_ONE}
            }
        },
        [NON_VERIFY_USER]: {
            entityName: "NonVerifyUser",
            tableName: "NonVerifyUser",
            fieldMetadata: {
                id: {columnName: "id", dbGenerated: true},
                name: {columnName: "name"},
                email: {columnName: "email"},
                contactNo: {columnName: "contactNo"},
                OTP: {columnName: "OTP"},
                password: {columnName: "password"}
            },
            keyFields: ["id"]
        },
        [NON_VERIFIED_DRIVER]: {
            entityName: "NonVerifiedDriver",
            tableName: "NonVerifiedDriver",
            fieldMetadata: {
                id: {columnName: "id", dbGenerated: true},
                name: {columnName: "name"},
                nic: {columnName: "nic"},
                email: {columnName: "email"},
                contactNo: {columnName: "contactNo"},
                OTP: {columnName: "OTP"},
                courierCompany: {columnName: "courierCompany"},
                vehicleType: {columnName: "vehicleType"},
                vehicleColor: {columnName: "vehicleColor"},
                vehicleName: {columnName: "vehicleName"},
                vehicleNumber: {columnName: "vehicleNumber"},
                password: {columnName: "password"},
                status: {columnName: "status"},
                createdAt: {columnName: "createdAt"}
            },
            keyFields: ["id"]
        },
        [ADDRESS]: {
            entityName: "Address",
            tableName: "Address",
            fieldMetadata: {
                id: {columnName: "id", dbGenerated: true},
                addressName: {columnName: "addressName"},
                address: {columnName: "address"},
                city: {columnName: "city"},
                location: {columnName: "location"},
                isDefault: {columnName: "isDefault"},
                consumerId: {columnName: "consumerId"},
                "consumer.id": {relation: {entityName: "consumer", refField: "id"}},
                "consumer.userId": {relation: {entityName: "consumer", refField: "userId"}}
            },
            keyFields: ["id"],
            joinMetadata: {consumer: {entity: Consumer, fieldName: "consumer", refTable: "Consumer", refColumns: ["id"], joinColumns: ["consumerId"], 'type: psql:ONE_TO_MANY}}
        },
        [SUPERMARKET]: {
            entityName: "Supermarket",
            tableName: "Supermarket",
            fieldMetadata: {
                id: {columnName: "id", dbGenerated: true},
                name: {columnName: "name"},
                contactNo: {columnName: "contactNo"},
                logo: {columnName: "logo"},
                location: {columnName: "location"},
                city: {columnName: "city"},
                address: {columnName: "address"},
                supermarketmanagerId: {columnName: "supermarketmanagerId"},
                "supermarketManager.id": {relation: {entityName: "supermarketManager", refField: "id"}},
                "supermarketManager.name": {relation: {entityName: "supermarketManager", refField: "name"}},
                "supermarketManager.email": {relation: {entityName: "supermarketManager", refField: "email"}},
                "supermarketManager.password": {relation: {entityName: "supermarketManager", refField: "password"}},
                "supermarketManager.number": {relation: {entityName: "supermarketManager", refField: "number"}},
                "supermarketManager.profilePic": {relation: {entityName: "supermarketManager", refField: "profilePic"}},
                "supermarketManager.role": {relation: {entityName: "supermarketManager", refField: "role"}},
                "supermarketManager.status": {relation: {entityName: "supermarketManager", refField: "status"}},
                "supermarketManager.lastLogin": {relation: {entityName: "supermarketManager", refField: "lastLogin"}},
                "supermarketManager.createdAt": {relation: {entityName: "supermarketManager", refField: "createdAt"}},
                "supermarketManager.updatedAt": {relation: {entityName: "supermarketManager", refField: "updatedAt"}},
                "supermarketManager.deletedAt": {relation: {entityName: "supermarketManager", refField: "deletedAt"}},
                "supermarketItems[].id": {relation: {entityName: "supermarketItems", refField: "id"}},
                "supermarketItems[].productId": {relation: {entityName: "supermarketItems", refField: "productId"}},
                "supermarketItems[].supermarketId": {relation: {entityName: "supermarketItems", refField: "supermarketId"}},
                "supermarketItems[].price": {relation: {entityName: "supermarketItems", refField: "price"}},
                "supermarketItems[].discount": {relation: {entityName: "supermarketItems", refField: "discount"}},
                "supermarketItems[].availableQuantity": {relation: {entityName: "supermarketItems", refField: "availableQuantity"}},
                "opportunitysupermarket[].id": {relation: {entityName: "opportunitysupermarket", refField: "id"}},
                "opportunitysupermarket[].supermarketId": {relation: {entityName: "opportunitysupermarket", refField: "supermarketId"}},
                "opportunitysupermarket[].opportunityId": {relation: {entityName: "opportunitysupermarket", refField: "opportunityId"}},
                "supermarketOrder[].id": {relation: {entityName: "supermarketOrder", refField: "id"}},
                "supermarketOrder[].status": {relation: {entityName: "supermarketOrder", refField: "status"}},
                "supermarketOrder[].qrCode": {relation: {entityName: "supermarketOrder", refField: "qrCode"}},
                "supermarketOrder[]._orderId": {relation: {entityName: "supermarketOrder", refField: "_orderId"}},
                "supermarketOrder[].supermarketId": {relation: {entityName: "supermarketOrder", refField: "supermarketId"}}
            },
            keyFields: ["id"],
            joinMetadata: {
                supermarketManager: {entity: User, fieldName: "supermarketManager", refTable: "User", refColumns: ["id"], joinColumns: ["supermarketmanagerId"], 'type: psql:ONE_TO_ONE},
                supermarketItems: {entity: SupermarketItem, fieldName: "supermarketItems", refTable: "SupermarketItem", refColumns: ["supermarketId"], joinColumns: ["id"], 'type: psql:MANY_TO_ONE},
                opportunitysupermarket: {entity: OpportunitySupermarket, fieldName: "opportunitysupermarket", refTable: "OpportunitySupermarket", refColumns: ["supermarketId"], joinColumns: ["id"], 'type: psql:MANY_TO_ONE},
                supermarketOrder: {entity: SupermarketOrder, fieldName: "supermarketOrder", refTable: "SupermarketOrder", refColumns: ["supermarketId"], joinColumns: ["id"], 'type: psql:MANY_TO_ONE}
            }
        },
        [PRODUCT]: {
            entityName: "Product",
            tableName: "Product",
            fieldMetadata: {
                id: {columnName: "id", dbGenerated: true},
                name: {columnName: "name"},
                description: {columnName: "description"},
                category: {columnName: "category"},
                price: {columnName: "price"},
                imageUrl: {columnName: "imageUrl"},
                "supermarketItems[].id": {relation: {entityName: "supermarketItems", refField: "id"}},
                "supermarketItems[].productId": {relation: {entityName: "supermarketItems", refField: "productId"}},
                "supermarketItems[].supermarketId": {relation: {entityName: "supermarketItems", refField: "supermarketId"}},
                "supermarketItems[].price": {relation: {entityName: "supermarketItems", refField: "price"}},
                "supermarketItems[].discount": {relation: {entityName: "supermarketItems", refField: "discount"}},
                "supermarketItems[].availableQuantity": {relation: {entityName: "supermarketItems", refField: "availableQuantity"}}
            },
            keyFields: ["id"],
            joinMetadata: {supermarketItems: {entity: SupermarketItem, fieldName: "supermarketItems", refTable: "SupermarketItem", refColumns: ["productId"], joinColumns: ["id"], 'type: psql:MANY_TO_ONE}}
        },
        [SUPERMARKET_ITEM]: {
            entityName: "SupermarketItem",
            tableName: "SupermarketItem",
            fieldMetadata: {
                id: {columnName: "id", dbGenerated: true},
                productId: {columnName: "productId"},
                supermarketId: {columnName: "supermarketId"},
                price: {columnName: "price"},
                discount: {columnName: "discount"},
                availableQuantity: {columnName: "availableQuantity"},
                "product.id": {relation: {entityName: "product", refField: "id"}},
                "product.name": {relation: {entityName: "product", refField: "name"}},
                "product.description": {relation: {entityName: "product", refField: "description"}},
                "product.category": {relation: {entityName: "product", refField: "category"}},
                "product.price": {relation: {entityName: "product", refField: "price"}},
                "product.imageUrl": {relation: {entityName: "product", refField: "imageUrl"}},
                "supermarket.id": {relation: {entityName: "supermarket", refField: "id"}},
                "supermarket.name": {relation: {entityName: "supermarket", refField: "name"}},
                "supermarket.contactNo": {relation: {entityName: "supermarket", refField: "contactNo"}},
                "supermarket.logo": {relation: {entityName: "supermarket", refField: "logo"}},
                "supermarket.location": {relation: {entityName: "supermarket", refField: "location"}},
                "supermarket.city": {relation: {entityName: "supermarket", refField: "city"}},
                "supermarket.address": {relation: {entityName: "supermarket", refField: "address"}},
                "supermarket.supermarketmanagerId": {relation: {entityName: "supermarket", refField: "supermarketmanagerId"}},
                "cartItem[].id": {relation: {entityName: "cartItem", refField: "id"}},
                "cartItem[].supermarketitemId": {relation: {entityName: "cartItem", refField: "supermarketitemId"}},
                "cartItem[].quantity": {relation: {entityName: "cartItem", refField: "quantity"}},
                "cartItem[].consumerId": {relation: {entityName: "cartItem", refField: "consumerId"}},
                "cartItem[].productId": {relation: {entityName: "cartItem", refField: "productId"}}
            },
            keyFields: ["id"],
            joinMetadata: {
                product: {entity: Product, fieldName: "product", refTable: "Product", refColumns: ["id"], joinColumns: ["productId"], 'type: psql:ONE_TO_MANY},
                supermarket: {entity: Supermarket, fieldName: "supermarket", refTable: "Supermarket", refColumns: ["id"], joinColumns: ["supermarketId"], 'type: psql:ONE_TO_MANY},
                cartItem: {entity: CartItem, fieldName: "cartItem", refTable: "CartItem", refColumns: ["supermarketitemId"], joinColumns: ["id"], 'type: psql:MANY_TO_ONE}
            }
        },
        [CART_ITEM]: {
            entityName: "CartItem",
            tableName: "CartItem",
            fieldMetadata: {
                id: {columnName: "id", dbGenerated: true},
                supermarketitemId: {columnName: "supermarketitemId"},
                quantity: {columnName: "quantity"},
                consumerId: {columnName: "consumerId"},
                productId: {columnName: "productId"},
                "supermarketItem.id": {relation: {entityName: "supermarketItem", refField: "id"}},
                "supermarketItem.productId": {relation: {entityName: "supermarketItem", refField: "productId"}},
                "supermarketItem.supermarketId": {relation: {entityName: "supermarketItem", refField: "supermarketId"}},
                "supermarketItem.price": {relation: {entityName: "supermarketItem", refField: "price"}},
                "supermarketItem.discount": {relation: {entityName: "supermarketItem", refField: "discount"}},
                "supermarketItem.availableQuantity": {relation: {entityName: "supermarketItem", refField: "availableQuantity"}}
            },
            keyFields: ["id"],
            joinMetadata: {supermarketItem: {entity: SupermarketItem, fieldName: "supermarketItem", refTable: "SupermarketItem", refColumns: ["id"], joinColumns: ["supermarketitemId"], 'type: psql:ONE_TO_MANY}}
        },
        [ORDER_ITEMS]: {
            entityName: "OrderItems",
            tableName: "OrderItems",
            fieldMetadata: {
                id: {columnName: "id", dbGenerated: true},
                supermarketId: {columnName: "supermarketId"},
                productId: {columnName: "productId"},
                quantity: {columnName: "quantity"},
                price: {columnName: "price"},
                _orderId: {columnName: "_orderId"},
                "_order.id": {relation: {entityName: "_order", refField: "id"}},
                "_order.consumerId": {relation: {entityName: "_order", refField: "consumerId"}},
                "_order.status": {relation: {entityName: "_order", refField: "status"}},
                "_order.shippingAddress": {relation: {entityName: "_order", refField: "shippingAddress"}},
                "_order.shippingMethod": {relation: {entityName: "_order", refField: "shippingMethod"}},
                "_order.location": {relation: {entityName: "_order", refField: "location"}},
                "_order.deliveryFee": {relation: {entityName: "_order", refField: "deliveryFee"}},
                "_order.orderPlacedOn": {relation: {entityName: "_order", refField: "orderPlacedOn"}}
            },
            keyFields: ["id"],
            joinMetadata: {_order: {entity: Order, fieldName: "_order", refTable: "Order", refColumns: ["id"], joinColumns: ["_orderId"], 'type: psql:ONE_TO_MANY}}
        },
        [ORDER]: {
            entityName: "Order",
            tableName: "Order",
            fieldMetadata: {
                id: {columnName: "id", dbGenerated: true},
                consumerId: {columnName: "consumerId"},
                status: {columnName: "status"},
                shippingAddress: {columnName: "shippingAddress"},
                shippingMethod: {columnName: "shippingMethod"},
                location: {columnName: "location"},
                deliveryFee: {columnName: "deliveryFee"},
                orderPlacedOn: {columnName: "orderPlacedOn"},
                "orderItems[].id": {relation: {entityName: "orderItems", refField: "id"}},
                "orderItems[].supermarketId": {relation: {entityName: "orderItems", refField: "supermarketId"}},
                "orderItems[].productId": {relation: {entityName: "orderItems", refField: "productId"}},
                "orderItems[].quantity": {relation: {entityName: "orderItems", refField: "quantity"}},
                "orderItems[].price": {relation: {entityName: "orderItems", refField: "price"}},
                "orderItems[]._orderId": {relation: {entityName: "orderItems", refField: "_orderId"}},
                "supermarketOrders[].id": {relation: {entityName: "supermarketOrders", refField: "id"}},
                "supermarketOrders[].status": {relation: {entityName: "supermarketOrders", refField: "status"}},
                "supermarketOrders[].qrCode": {relation: {entityName: "supermarketOrders", refField: "qrCode"}},
                "supermarketOrders[]._orderId": {relation: {entityName: "supermarketOrders", refField: "_orderId"}},
                "supermarketOrders[].supermarketId": {relation: {entityName: "supermarketOrders", refField: "supermarketId"}},
                "opportunity[].id": {relation: {entityName: "opportunity", refField: "id"}},
                "opportunity[].totalDistance": {relation: {entityName: "opportunity", refField: "totalDistance"}},
                "opportunity[].tripCost": {relation: {entityName: "opportunity", refField: "tripCost"}},
                "opportunity[].consumerId": {relation: {entityName: "opportunity", refField: "consumerId"}},
                "opportunity[].deliveryCost": {relation: {entityName: "opportunity", refField: "deliveryCost"}},
                "opportunity[].startLocation": {relation: {entityName: "opportunity", refField: "startLocation"}},
                "opportunity[].deliveryLocation": {relation: {entityName: "opportunity", refField: "deliveryLocation"}},
                "opportunity[].status": {relation: {entityName: "opportunity", refField: "status"}},
                "opportunity[]._orderId": {relation: {entityName: "opportunity", refField: "_orderId"}},
                "opportunity[].driverId": {relation: {entityName: "opportunity", refField: "driverId"}},
                "opportunity[].orderPlacedOn": {relation: {entityName: "opportunity", refField: "orderPlacedOn"}}
            },
            keyFields: ["id"],
            joinMetadata: {
                orderItems: {entity: OrderItems, fieldName: "orderItems", refTable: "OrderItems", refColumns: ["_orderId"], joinColumns: ["id"], 'type: psql:MANY_TO_ONE},
                supermarketOrders: {entity: SupermarketOrder, fieldName: "supermarketOrders", refTable: "SupermarketOrder", refColumns: ["_orderId"], joinColumns: ["id"], 'type: psql:MANY_TO_ONE},
                opportunity: {entity: Opportunity, fieldName: "opportunity", refTable: "Opportunity", refColumns: ["_orderId"], joinColumns: ["id"], 'type: psql:MANY_TO_ONE}
            }
        },
        [SUPERMARKET_ORDER]: {
            entityName: "SupermarketOrder",
            tableName: "SupermarketOrder",
            fieldMetadata: {
                id: {columnName: "id", dbGenerated: true},
                status: {columnName: "status"},
                qrCode: {columnName: "qrCode"},
                _orderId: {columnName: "_orderId"},
                supermarketId: {columnName: "supermarketId"},
                "_order.id": {relation: {entityName: "_order", refField: "id"}},
                "_order.consumerId": {relation: {entityName: "_order", refField: "consumerId"}},
                "_order.status": {relation: {entityName: "_order", refField: "status"}},
                "_order.shippingAddress": {relation: {entityName: "_order", refField: "shippingAddress"}},
                "_order.shippingMethod": {relation: {entityName: "_order", refField: "shippingMethod"}},
                "_order.location": {relation: {entityName: "_order", refField: "location"}},
                "_order.deliveryFee": {relation: {entityName: "_order", refField: "deliveryFee"}},
                "_order.orderPlacedOn": {relation: {entityName: "_order", refField: "orderPlacedOn"}},
                "supermarket.id": {relation: {entityName: "supermarket", refField: "id"}},
                "supermarket.name": {relation: {entityName: "supermarket", refField: "name"}},
                "supermarket.contactNo": {relation: {entityName: "supermarket", refField: "contactNo"}},
                "supermarket.logo": {relation: {entityName: "supermarket", refField: "logo"}},
                "supermarket.location": {relation: {entityName: "supermarket", refField: "location"}},
                "supermarket.city": {relation: {entityName: "supermarket", refField: "city"}},
                "supermarket.address": {relation: {entityName: "supermarket", refField: "address"}},
                "supermarket.supermarketmanagerId": {relation: {entityName: "supermarket", refField: "supermarketmanagerId"}}
            },
            keyFields: ["id"],
            joinMetadata: {
                _order: {entity: Order, fieldName: "_order", refTable: "Order", refColumns: ["id"], joinColumns: ["_orderId"], 'type: psql:ONE_TO_MANY},
                supermarket: {entity: Supermarket, fieldName: "supermarket", refTable: "Supermarket", refColumns: ["id"], joinColumns: ["supermarketId"], 'type: psql:ONE_TO_MANY}
            }
        },
        [OPPORTUNITY_SUPERMARKET]: {
            entityName: "OpportunitySupermarket",
            tableName: "OpportunitySupermarket",
            fieldMetadata: {
                id: {columnName: "id", dbGenerated: true},
                supermarketId: {columnName: "supermarketId"},
                opportunityId: {columnName: "opportunityId"},
                "supermarket.id": {relation: {entityName: "supermarket", refField: "id"}},
                "supermarket.name": {relation: {entityName: "supermarket", refField: "name"}},
                "supermarket.contactNo": {relation: {entityName: "supermarket", refField: "contactNo"}},
                "supermarket.logo": {relation: {entityName: "supermarket", refField: "logo"}},
                "supermarket.location": {relation: {entityName: "supermarket", refField: "location"}},
                "supermarket.city": {relation: {entityName: "supermarket", refField: "city"}},
                "supermarket.address": {relation: {entityName: "supermarket", refField: "address"}},
                "supermarket.supermarketmanagerId": {relation: {entityName: "supermarket", refField: "supermarketmanagerId"}},
                "opportunity.id": {relation: {entityName: "opportunity", refField: "id"}},
                "opportunity.totalDistance": {relation: {entityName: "opportunity", refField: "totalDistance"}},
                "opportunity.tripCost": {relation: {entityName: "opportunity", refField: "tripCost"}},
                "opportunity.consumerId": {relation: {entityName: "opportunity", refField: "consumerId"}},
                "opportunity.deliveryCost": {relation: {entityName: "opportunity", refField: "deliveryCost"}},
                "opportunity.startLocation": {relation: {entityName: "opportunity", refField: "startLocation"}},
                "opportunity.deliveryLocation": {relation: {entityName: "opportunity", refField: "deliveryLocation"}},
                "opportunity.status": {relation: {entityName: "opportunity", refField: "status"}},
                "opportunity._orderId": {relation: {entityName: "opportunity", refField: "_orderId"}},
                "opportunity.driverId": {relation: {entityName: "opportunity", refField: "driverId"}},
                "opportunity.orderPlacedOn": {relation: {entityName: "opportunity", refField: "orderPlacedOn"}}
            },
            keyFields: ["id"],
            joinMetadata: {
                supermarket: {entity: Supermarket, fieldName: "supermarket", refTable: "Supermarket", refColumns: ["id"], joinColumns: ["supermarketId"], 'type: psql:ONE_TO_MANY},
                opportunity: {entity: Opportunity, fieldName: "opportunity", refTable: "Opportunity", refColumns: ["id"], joinColumns: ["opportunityId"], 'type: psql:ONE_TO_MANY}
            }
        },
        [OPPORTUNITY]: {
            entityName: "Opportunity",
            tableName: "Opportunity",
            fieldMetadata: {
                id: {columnName: "id", dbGenerated: true},
                totalDistance: {columnName: "totalDistance"},
                tripCost: {columnName: "tripCost"},
                consumerId: {columnName: "consumerId"},
                deliveryCost: {columnName: "deliveryCost"},
                startLocation: {columnName: "startLocation"},
                deliveryLocation: {columnName: "deliveryLocation"},
                status: {columnName: "status"},
                _orderId: {columnName: "_orderId"},
                driverId: {columnName: "driverId"},
                orderPlacedOn: {columnName: "orderPlacedOn"},
                "consumer.id": {relation: {entityName: "consumer", refField: "id"}},
                "consumer.userId": {relation: {entityName: "consumer", refField: "userId"}},
                "opportunitysupermarket[].id": {relation: {entityName: "opportunitysupermarket", refField: "id"}},
                "opportunitysupermarket[].supermarketId": {relation: {entityName: "opportunitysupermarket", refField: "supermarketId"}},
                "opportunitysupermarket[].opportunityId": {relation: {entityName: "opportunitysupermarket", refField: "opportunityId"}},
                "_order.id": {relation: {entityName: "_order", refField: "id"}},
                "_order.consumerId": {relation: {entityName: "_order", refField: "consumerId"}},
                "_order.status": {relation: {entityName: "_order", refField: "status"}},
                "_order.shippingAddress": {relation: {entityName: "_order", refField: "shippingAddress"}},
                "_order.shippingMethod": {relation: {entityName: "_order", refField: "shippingMethod"}},
                "_order.location": {relation: {entityName: "_order", refField: "location"}},
                "_order.deliveryFee": {relation: {entityName: "_order", refField: "deliveryFee"}},
                "_order.orderPlacedOn": {relation: {entityName: "_order", refField: "orderPlacedOn"}}
            },
            keyFields: ["id"],
            joinMetadata: {
                consumer: {entity: Consumer, fieldName: "consumer", refTable: "Consumer", refColumns: ["id"], joinColumns: ["consumerId"], 'type: psql:ONE_TO_MANY},
                opportunitysupermarket: {entity: OpportunitySupermarket, fieldName: "opportunitysupermarket", refTable: "OpportunitySupermarket", refColumns: ["opportunityId"], joinColumns: ["id"], 'type: psql:MANY_TO_ONE},
                _order: {entity: Order, fieldName: "_order", refTable: "Order", refColumns: ["id"], joinColumns: ["_orderId"], 'type: psql:ONE_TO_MANY}
            }
        },
        [CONSUMER]: {
            entityName: "Consumer",
            tableName: "Consumer",
            fieldMetadata: {
                id: {columnName: "id", dbGenerated: true},
                userId: {columnName: "userId"},
                "user.id": {relation: {entityName: "user", refField: "id"}},
                "user.name": {relation: {entityName: "user", refField: "name"}},
                "user.email": {relation: {entityName: "user", refField: "email"}},
                "user.password": {relation: {entityName: "user", refField: "password"}},
                "user.number": {relation: {entityName: "user", refField: "number"}},
                "user.profilePic": {relation: {entityName: "user", refField: "profilePic"}},
                "user.role": {relation: {entityName: "user", refField: "role"}},
                "user.status": {relation: {entityName: "user", refField: "status"}},
                "user.lastLogin": {relation: {entityName: "user", refField: "lastLogin"}},
                "user.createdAt": {relation: {entityName: "user", refField: "createdAt"}},
                "user.updatedAt": {relation: {entityName: "user", refField: "updatedAt"}},
                "user.deletedAt": {relation: {entityName: "user", refField: "deletedAt"}},
                "addresses[].id": {relation: {entityName: "addresses", refField: "id"}},
                "addresses[].addressName": {relation: {entityName: "addresses", refField: "addressName"}},
                "addresses[].address": {relation: {entityName: "addresses", refField: "address"}},
                "addresses[].city": {relation: {entityName: "addresses", refField: "city"}},
                "addresses[].location": {relation: {entityName: "addresses", refField: "location"}},
                "addresses[].isDefault": {relation: {entityName: "addresses", refField: "isDefault"}},
                "addresses[].consumerId": {relation: {entityName: "addresses", refField: "consumerId"}},
                "opportunity[].id": {relation: {entityName: "opportunity", refField: "id"}},
                "opportunity[].totalDistance": {relation: {entityName: "opportunity", refField: "totalDistance"}},
                "opportunity[].tripCost": {relation: {entityName: "opportunity", refField: "tripCost"}},
                "opportunity[].consumerId": {relation: {entityName: "opportunity", refField: "consumerId"}},
                "opportunity[].deliveryCost": {relation: {entityName: "opportunity", refField: "deliveryCost"}},
                "opportunity[].startLocation": {relation: {entityName: "opportunity", refField: "startLocation"}},
                "opportunity[].deliveryLocation": {relation: {entityName: "opportunity", refField: "deliveryLocation"}},
                "opportunity[].status": {relation: {entityName: "opportunity", refField: "status"}},
                "opportunity[]._orderId": {relation: {entityName: "opportunity", refField: "_orderId"}},
                "opportunity[].driverId": {relation: {entityName: "opportunity", refField: "driverId"}},
                "opportunity[].orderPlacedOn": {relation: {entityName: "opportunity", refField: "orderPlacedOn"}}
            },
            keyFields: ["id"],
            joinMetadata: {
                user: {entity: User, fieldName: "user", refTable: "User", refColumns: ["id"], joinColumns: ["userId"], 'type: psql:ONE_TO_ONE},
                addresses: {entity: Address, fieldName: "addresses", refTable: "Address", refColumns: ["consumerId"], joinColumns: ["id"], 'type: psql:MANY_TO_ONE},
                opportunity: {entity: Opportunity, fieldName: "opportunity", refTable: "Opportunity", refColumns: ["consumerId"], joinColumns: ["id"], 'type: psql:MANY_TO_ONE}
            }
        },
        [ADVERTISEMENT]: {
            entityName: "Advertisement",
            tableName: "Advertisement",
            fieldMetadata: {
                id: {columnName: "id", dbGenerated: true},
                image: {columnName: "image"},
                status: {columnName: "status"},
                startDate: {columnName: "startDate"},
                endDate: {columnName: "endDate"},
                priority: {columnName: "priority"}
            },
            keyFields: ["id"]
        },
        [DRIVER]: {
            entityName: "Driver",
            tableName: "Driver",
            fieldMetadata: {
                id: {columnName: "id", dbGenerated: true},
                userId: {columnName: "userId"},
                nic: {columnName: "nic"},
                courierCompany: {columnName: "courierCompany"},
                vehicleType: {columnName: "vehicleType"},
                vehicleColor: {columnName: "vehicleColor"},
                vehicleName: {columnName: "vehicleName"},
                vehicleNumber: {columnName: "vehicleNumber"},
                "user.id": {relation: {entityName: "user", refField: "id"}},
                "user.name": {relation: {entityName: "user", refField: "name"}},
                "user.email": {relation: {entityName: "user", refField: "email"}},
                "user.password": {relation: {entityName: "user", refField: "password"}},
                "user.number": {relation: {entityName: "user", refField: "number"}},
                "user.profilePic": {relation: {entityName: "user", refField: "profilePic"}},
                "user.role": {relation: {entityName: "user", refField: "role"}},
                "user.status": {relation: {entityName: "user", refField: "status"}},
                "user.lastLogin": {relation: {entityName: "user", refField: "lastLogin"}},
                "user.createdAt": {relation: {entityName: "user", refField: "createdAt"}},
                "user.updatedAt": {relation: {entityName: "user", refField: "updatedAt"}},
                "user.deletedAt": {relation: {entityName: "user", refField: "deletedAt"}}
            },
            keyFields: ["id"],
            joinMetadata: {user: {entity: User, fieldName: "user", refTable: "User", refColumns: ["id"], joinColumns: ["userId"], 'type: psql:ONE_TO_ONE}}
        },
        [REVIEW]: {
            entityName: "Review",
            tableName: "Review",
            fieldMetadata: {
                id: {columnName: "id", dbGenerated: true},
                reviewType: {columnName: "reviewType"},
                userId: {columnName: "userId"},
                targetId: {columnName: "targetId"},
                title: {columnName: "title"},
                content: {columnName: "content"},
                rating: {columnName: "rating"},
                createdAt: {columnName: "createdAt"},
                "user.id": {relation: {entityName: "user", refField: "id"}},
                "user.name": {relation: {entityName: "user", refField: "name"}},
                "user.email": {relation: {entityName: "user", refField: "email"}},
                "user.password": {relation: {entityName: "user", refField: "password"}},
                "user.number": {relation: {entityName: "user", refField: "number"}},
                "user.profilePic": {relation: {entityName: "user", refField: "profilePic"}},
                "user.role": {relation: {entityName: "user", refField: "role"}},
                "user.status": {relation: {entityName: "user", refField: "status"}},
                "user.lastLogin": {relation: {entityName: "user", refField: "lastLogin"}},
                "user.createdAt": {relation: {entityName: "user", refField: "createdAt"}},
                "user.updatedAt": {relation: {entityName: "user", refField: "updatedAt"}},
                "user.deletedAt": {relation: {entityName: "user", refField: "deletedAt"}}
            },
            keyFields: ["id"],
            joinMetadata: {user: {entity: User, fieldName: "user", refTable: "User", refColumns: ["id"], joinColumns: ["userId"], 'type: psql:ONE_TO_MANY}}
        },
        [LIKED_PRODUCT]: {
            entityName: "LikedProduct",
            tableName: "LikedProduct",
            fieldMetadata: {
                id: {columnName: "id", dbGenerated: true},
                userId: {columnName: "userId"},
                productId: {columnName: "productId"}
            },
            keyFields: ["id"]
        },
        [ACTIVITY]: {
            entityName: "Activity",
            tableName: "Activity",
            fieldMetadata: {
                id: {columnName: "id", dbGenerated: true},
                userId: {columnName: "userId"},
                description: {columnName: "description"},
                dateTime: {columnName: "dateTime"}
            },
            keyFields: ["id"]
        },
        [FILES]: {
            entityName: "Files",
            tableName: "Files",
            fieldMetadata: {
                id: {columnName: "id", dbGenerated: true},
                name: {columnName: "name"},
                data: {columnName: "data"}
            },
            keyFields: ["id"]
        }
    };

    public isolated function init() returns persist:Error? {
        postgresql:Client|error dbClient = new (host = host, username = user, password = password, database = database, port = port, options = connectionOptions);
        if dbClient is error {
            return <persist:Error>error(dbClient.message());
        }
        self.dbClient = dbClient;
        self.persistClients = {
            [USER]: check new (dbClient, self.metadata.get(USER), psql:POSTGRESQL_SPECIFICS),
            [NON_VERIFY_USER]: check new (dbClient, self.metadata.get(NON_VERIFY_USER), psql:POSTGRESQL_SPECIFICS),
            [NON_VERIFIED_DRIVER]: check new (dbClient, self.metadata.get(NON_VERIFIED_DRIVER), psql:POSTGRESQL_SPECIFICS),
            [ADDRESS]: check new (dbClient, self.metadata.get(ADDRESS), psql:POSTGRESQL_SPECIFICS),
            [SUPERMARKET]: check new (dbClient, self.metadata.get(SUPERMARKET), psql:POSTGRESQL_SPECIFICS),
            [PRODUCT]: check new (dbClient, self.metadata.get(PRODUCT), psql:POSTGRESQL_SPECIFICS),
            [SUPERMARKET_ITEM]: check new (dbClient, self.metadata.get(SUPERMARKET_ITEM), psql:POSTGRESQL_SPECIFICS),
            [CART_ITEM]: check new (dbClient, self.metadata.get(CART_ITEM), psql:POSTGRESQL_SPECIFICS),
            [ORDER_ITEMS]: check new (dbClient, self.metadata.get(ORDER_ITEMS), psql:POSTGRESQL_SPECIFICS),
            [ORDER]: check new (dbClient, self.metadata.get(ORDER), psql:POSTGRESQL_SPECIFICS),
            [SUPERMARKET_ORDER]: check new (dbClient, self.metadata.get(SUPERMARKET_ORDER), psql:POSTGRESQL_SPECIFICS),
            [OPPORTUNITY_SUPERMARKET]: check new (dbClient, self.metadata.get(OPPORTUNITY_SUPERMARKET), psql:POSTGRESQL_SPECIFICS),
            [OPPORTUNITY]: check new (dbClient, self.metadata.get(OPPORTUNITY), psql:POSTGRESQL_SPECIFICS),
            [CONSUMER]: check new (dbClient, self.metadata.get(CONSUMER), psql:POSTGRESQL_SPECIFICS),
            [ADVERTISEMENT]: check new (dbClient, self.metadata.get(ADVERTISEMENT), psql:POSTGRESQL_SPECIFICS),
            [DRIVER]: check new (dbClient, self.metadata.get(DRIVER), psql:POSTGRESQL_SPECIFICS),
            [REVIEW]: check new (dbClient, self.metadata.get(REVIEW), psql:POSTGRESQL_SPECIFICS),
            [LIKED_PRODUCT]: check new (dbClient, self.metadata.get(LIKED_PRODUCT), psql:POSTGRESQL_SPECIFICS),
            [ACTIVITY]: check new (dbClient, self.metadata.get(ACTIVITY), psql:POSTGRESQL_SPECIFICS),
            [FILES]: check new (dbClient, self.metadata.get(FILES), psql:POSTGRESQL_SPECIFICS)
        };
    }

    isolated resource function get users(UserTargetType targetType = <>, sql:ParameterizedQuery whereClause = ``, sql:ParameterizedQuery orderByClause = ``, sql:ParameterizedQuery limitClause = ``, sql:ParameterizedQuery groupByClause = ``) returns stream<targetType, persist:Error?> = @java:Method {
        'class: "io.ballerina.stdlib.persist.sql.datastore.PostgreSQLProcessor",
        name: "query"
    } external;

    isolated resource function get users/[int id](UserTargetType targetType = <>) returns targetType|persist:Error = @java:Method {
        'class: "io.ballerina.stdlib.persist.sql.datastore.PostgreSQLProcessor",
        name: "queryOne"
    } external;

    isolated resource function post users(UserInsert[] data) returns int[]|persist:Error {
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(USER);
        }
        sql:ExecutionResult[] result = check sqlClient.runBatchInsertQuery(data);
        return from sql:ExecutionResult inserted in result
            where inserted.lastInsertId != ()
            select <int>inserted.lastInsertId;
    }

    isolated resource function put users/[int id](UserUpdate value) returns User|persist:Error {
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(USER);
        }
        _ = check sqlClient.runUpdateQuery(id, value);
        return self->/users/[id].get();
    }

    isolated resource function delete users/[int id]() returns User|persist:Error {
        User result = check self->/users/[id].get();
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(USER);
        }
        _ = check sqlClient.runDeleteQuery(id);
        return result;
    }

    isolated resource function get nonverifyusers(NonVerifyUserTargetType targetType = <>, sql:ParameterizedQuery whereClause = ``, sql:ParameterizedQuery orderByClause = ``, sql:ParameterizedQuery limitClause = ``, sql:ParameterizedQuery groupByClause = ``) returns stream<targetType, persist:Error?> = @java:Method {
        'class: "io.ballerina.stdlib.persist.sql.datastore.PostgreSQLProcessor",
        name: "query"
    } external;

    isolated resource function get nonverifyusers/[int id](NonVerifyUserTargetType targetType = <>) returns targetType|persist:Error = @java:Method {
        'class: "io.ballerina.stdlib.persist.sql.datastore.PostgreSQLProcessor",
        name: "queryOne"
    } external;

    isolated resource function post nonverifyusers(NonVerifyUserInsert[] data) returns int[]|persist:Error {
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(NON_VERIFY_USER);
        }
        sql:ExecutionResult[] result = check sqlClient.runBatchInsertQuery(data);
        return from sql:ExecutionResult inserted in result
            where inserted.lastInsertId != ()
            select <int>inserted.lastInsertId;
    }

    isolated resource function put nonverifyusers/[int id](NonVerifyUserUpdate value) returns NonVerifyUser|persist:Error {
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(NON_VERIFY_USER);
        }
        _ = check sqlClient.runUpdateQuery(id, value);
        return self->/nonverifyusers/[id].get();
    }

    isolated resource function delete nonverifyusers/[int id]() returns NonVerifyUser|persist:Error {
        NonVerifyUser result = check self->/nonverifyusers/[id].get();
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(NON_VERIFY_USER);
        }
        _ = check sqlClient.runDeleteQuery(id);
        return result;
    }

    isolated resource function get nonverifieddrivers(NonVerifiedDriverTargetType targetType = <>, sql:ParameterizedQuery whereClause = ``, sql:ParameterizedQuery orderByClause = ``, sql:ParameterizedQuery limitClause = ``, sql:ParameterizedQuery groupByClause = ``) returns stream<targetType, persist:Error?> = @java:Method {
        'class: "io.ballerina.stdlib.persist.sql.datastore.PostgreSQLProcessor",
        name: "query"
    } external;

    isolated resource function get nonverifieddrivers/[int id](NonVerifiedDriverTargetType targetType = <>) returns targetType|persist:Error = @java:Method {
        'class: "io.ballerina.stdlib.persist.sql.datastore.PostgreSQLProcessor",
        name: "queryOne"
    } external;

    isolated resource function post nonverifieddrivers(NonVerifiedDriverInsert[] data) returns int[]|persist:Error {
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(NON_VERIFIED_DRIVER);
        }
        sql:ExecutionResult[] result = check sqlClient.runBatchInsertQuery(data);
        return from sql:ExecutionResult inserted in result
            where inserted.lastInsertId != ()
            select <int>inserted.lastInsertId;
    }

    isolated resource function put nonverifieddrivers/[int id](NonVerifiedDriverUpdate value) returns NonVerifiedDriver|persist:Error {
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(NON_VERIFIED_DRIVER);
        }
        _ = check sqlClient.runUpdateQuery(id, value);
        return self->/nonverifieddrivers/[id].get();
    }

    isolated resource function delete nonverifieddrivers/[int id]() returns NonVerifiedDriver|persist:Error {
        NonVerifiedDriver result = check self->/nonverifieddrivers/[id].get();
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(NON_VERIFIED_DRIVER);
        }
        _ = check sqlClient.runDeleteQuery(id);
        return result;
    }

    isolated resource function get addresses(AddressTargetType targetType = <>, sql:ParameterizedQuery whereClause = ``, sql:ParameterizedQuery orderByClause = ``, sql:ParameterizedQuery limitClause = ``, sql:ParameterizedQuery groupByClause = ``) returns stream<targetType, persist:Error?> = @java:Method {
        'class: "io.ballerina.stdlib.persist.sql.datastore.PostgreSQLProcessor",
        name: "query"
    } external;

    isolated resource function get addresses/[int id](AddressTargetType targetType = <>) returns targetType|persist:Error = @java:Method {
        'class: "io.ballerina.stdlib.persist.sql.datastore.PostgreSQLProcessor",
        name: "queryOne"
    } external;

    isolated resource function post addresses(AddressInsert[] data) returns int[]|persist:Error {
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(ADDRESS);
        }
        sql:ExecutionResult[] result = check sqlClient.runBatchInsertQuery(data);
        return from sql:ExecutionResult inserted in result
            where inserted.lastInsertId != ()
            select <int>inserted.lastInsertId;
    }

    isolated resource function put addresses/[int id](AddressUpdate value) returns Address|persist:Error {
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(ADDRESS);
        }
        _ = check sqlClient.runUpdateQuery(id, value);
        return self->/addresses/[id].get();
    }

    isolated resource function delete addresses/[int id]() returns Address|persist:Error {
        Address result = check self->/addresses/[id].get();
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(ADDRESS);
        }
        _ = check sqlClient.runDeleteQuery(id);
        return result;
    }

    isolated resource function get supermarkets(SupermarketTargetType targetType = <>, sql:ParameterizedQuery whereClause = ``, sql:ParameterizedQuery orderByClause = ``, sql:ParameterizedQuery limitClause = ``, sql:ParameterizedQuery groupByClause = ``) returns stream<targetType, persist:Error?> = @java:Method {
        'class: "io.ballerina.stdlib.persist.sql.datastore.PostgreSQLProcessor",
        name: "query"
    } external;

    isolated resource function get supermarkets/[int id](SupermarketTargetType targetType = <>) returns targetType|persist:Error = @java:Method {
        'class: "io.ballerina.stdlib.persist.sql.datastore.PostgreSQLProcessor",
        name: "queryOne"
    } external;

    isolated resource function post supermarkets(SupermarketInsert[] data) returns int[]|persist:Error {
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(SUPERMARKET);
        }
        sql:ExecutionResult[] result = check sqlClient.runBatchInsertQuery(data);
        return from sql:ExecutionResult inserted in result
            where inserted.lastInsertId != ()
            select <int>inserted.lastInsertId;
    }

    isolated resource function put supermarkets/[int id](SupermarketUpdate value) returns Supermarket|persist:Error {
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(SUPERMARKET);
        }
        _ = check sqlClient.runUpdateQuery(id, value);
        return self->/supermarkets/[id].get();
    }

    isolated resource function delete supermarkets/[int id]() returns Supermarket|persist:Error {
        Supermarket result = check self->/supermarkets/[id].get();
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(SUPERMARKET);
        }
        _ = check sqlClient.runDeleteQuery(id);
        return result;
    }

    isolated resource function get products(ProductTargetType targetType = <>, sql:ParameterizedQuery whereClause = ``, sql:ParameterizedQuery orderByClause = ``, sql:ParameterizedQuery limitClause = ``, sql:ParameterizedQuery groupByClause = ``) returns stream<targetType, persist:Error?> = @java:Method {
        'class: "io.ballerina.stdlib.persist.sql.datastore.PostgreSQLProcessor",
        name: "query"
    } external;

    isolated resource function get products/[int id](ProductTargetType targetType = <>) returns targetType|persist:Error = @java:Method {
        'class: "io.ballerina.stdlib.persist.sql.datastore.PostgreSQLProcessor",
        name: "queryOne"
    } external;

    isolated resource function post products(ProductInsert[] data) returns int[]|persist:Error {
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(PRODUCT);
        }
        sql:ExecutionResult[] result = check sqlClient.runBatchInsertQuery(data);
        return from sql:ExecutionResult inserted in result
            where inserted.lastInsertId != ()
            select <int>inserted.lastInsertId;
    }

    isolated resource function put products/[int id](ProductUpdate value) returns Product|persist:Error {
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(PRODUCT);
        }
        _ = check sqlClient.runUpdateQuery(id, value);
        return self->/products/[id].get();
    }

    isolated resource function delete products/[int id]() returns Product|persist:Error {
        Product result = check self->/products/[id].get();
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(PRODUCT);
        }
        _ = check sqlClient.runDeleteQuery(id);
        return result;
    }

    isolated resource function get supermarketitems(SupermarketItemTargetType targetType = <>, sql:ParameterizedQuery whereClause = ``, sql:ParameterizedQuery orderByClause = ``, sql:ParameterizedQuery limitClause = ``, sql:ParameterizedQuery groupByClause = ``) returns stream<targetType, persist:Error?> = @java:Method {
        'class: "io.ballerina.stdlib.persist.sql.datastore.PostgreSQLProcessor",
        name: "query"
    } external;

    isolated resource function get supermarketitems/[int id](SupermarketItemTargetType targetType = <>) returns targetType|persist:Error = @java:Method {
        'class: "io.ballerina.stdlib.persist.sql.datastore.PostgreSQLProcessor",
        name: "queryOne"
    } external;

    isolated resource function post supermarketitems(SupermarketItemInsert[] data) returns int[]|persist:Error {
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(SUPERMARKET_ITEM);
        }
        sql:ExecutionResult[] result = check sqlClient.runBatchInsertQuery(data);
        return from sql:ExecutionResult inserted in result
            where inserted.lastInsertId != ()
            select <int>inserted.lastInsertId;
    }

    isolated resource function put supermarketitems/[int id](SupermarketItemUpdate value) returns SupermarketItem|persist:Error {
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(SUPERMARKET_ITEM);
        }
        _ = check sqlClient.runUpdateQuery(id, value);
        return self->/supermarketitems/[id].get();
    }

    isolated resource function delete supermarketitems/[int id]() returns SupermarketItem|persist:Error {
        SupermarketItem result = check self->/supermarketitems/[id].get();
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(SUPERMARKET_ITEM);
        }
        _ = check sqlClient.runDeleteQuery(id);
        return result;
    }

    isolated resource function get cartitems(CartItemTargetType targetType = <>, sql:ParameterizedQuery whereClause = ``, sql:ParameterizedQuery orderByClause = ``, sql:ParameterizedQuery limitClause = ``, sql:ParameterizedQuery groupByClause = ``) returns stream<targetType, persist:Error?> = @java:Method {
        'class: "io.ballerina.stdlib.persist.sql.datastore.PostgreSQLProcessor",
        name: "query"
    } external;

    isolated resource function get cartitems/[int id](CartItemTargetType targetType = <>) returns targetType|persist:Error = @java:Method {
        'class: "io.ballerina.stdlib.persist.sql.datastore.PostgreSQLProcessor",
        name: "queryOne"
    } external;

    isolated resource function post cartitems(CartItemInsert[] data) returns int[]|persist:Error {
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(CART_ITEM);
        }
        sql:ExecutionResult[] result = check sqlClient.runBatchInsertQuery(data);
        return from sql:ExecutionResult inserted in result
            where inserted.lastInsertId != ()
            select <int>inserted.lastInsertId;
    }

    isolated resource function put cartitems/[int id](CartItemUpdate value) returns CartItem|persist:Error {
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(CART_ITEM);
        }
        _ = check sqlClient.runUpdateQuery(id, value);
        return self->/cartitems/[id].get();
    }

    isolated resource function delete cartitems/[int id]() returns CartItem|persist:Error {
        CartItem result = check self->/cartitems/[id].get();
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(CART_ITEM);
        }
        _ = check sqlClient.runDeleteQuery(id);
        return result;
    }

    isolated resource function get orderitems(OrderItemsTargetType targetType = <>, sql:ParameterizedQuery whereClause = ``, sql:ParameterizedQuery orderByClause = ``, sql:ParameterizedQuery limitClause = ``, sql:ParameterizedQuery groupByClause = ``) returns stream<targetType, persist:Error?> = @java:Method {
        'class: "io.ballerina.stdlib.persist.sql.datastore.PostgreSQLProcessor",
        name: "query"
    } external;

    isolated resource function get orderitems/[int id](OrderItemsTargetType targetType = <>) returns targetType|persist:Error = @java:Method {
        'class: "io.ballerina.stdlib.persist.sql.datastore.PostgreSQLProcessor",
        name: "queryOne"
    } external;

    isolated resource function post orderitems(OrderItemsInsert[] data) returns int[]|persist:Error {
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(ORDER_ITEMS);
        }
        sql:ExecutionResult[] result = check sqlClient.runBatchInsertQuery(data);
        return from sql:ExecutionResult inserted in result
            where inserted.lastInsertId != ()
            select <int>inserted.lastInsertId;
    }

    isolated resource function put orderitems/[int id](OrderItemsUpdate value) returns OrderItems|persist:Error {
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(ORDER_ITEMS);
        }
        _ = check sqlClient.runUpdateQuery(id, value);
        return self->/orderitems/[id].get();
    }

    isolated resource function delete orderitems/[int id]() returns OrderItems|persist:Error {
        OrderItems result = check self->/orderitems/[id].get();
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(ORDER_ITEMS);
        }
        _ = check sqlClient.runDeleteQuery(id);
        return result;
    }

    isolated resource function get orders(OrderTargetType targetType = <>, sql:ParameterizedQuery whereClause = ``, sql:ParameterizedQuery orderByClause = ``, sql:ParameterizedQuery limitClause = ``, sql:ParameterizedQuery groupByClause = ``) returns stream<targetType, persist:Error?> = @java:Method {
        'class: "io.ballerina.stdlib.persist.sql.datastore.PostgreSQLProcessor",
        name: "query"
    } external;

    isolated resource function get orders/[int id](OrderTargetType targetType = <>) returns targetType|persist:Error = @java:Method {
        'class: "io.ballerina.stdlib.persist.sql.datastore.PostgreSQLProcessor",
        name: "queryOne"
    } external;

    isolated resource function post orders(OrderInsert[] data) returns int[]|persist:Error {
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(ORDER);
        }
        sql:ExecutionResult[] result = check sqlClient.runBatchInsertQuery(data);
        return from sql:ExecutionResult inserted in result
            where inserted.lastInsertId != ()
            select <int>inserted.lastInsertId;
    }

    isolated resource function put orders/[int id](OrderUpdate value) returns Order|persist:Error {
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(ORDER);
        }
        _ = check sqlClient.runUpdateQuery(id, value);
        return self->/orders/[id].get();
    }

    isolated resource function delete orders/[int id]() returns Order|persist:Error {
        Order result = check self->/orders/[id].get();
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(ORDER);
        }
        _ = check sqlClient.runDeleteQuery(id);
        return result;
    }

    isolated resource function get supermarketorders(SupermarketOrderTargetType targetType = <>, sql:ParameterizedQuery whereClause = ``, sql:ParameterizedQuery orderByClause = ``, sql:ParameterizedQuery limitClause = ``, sql:ParameterizedQuery groupByClause = ``) returns stream<targetType, persist:Error?> = @java:Method {
        'class: "io.ballerina.stdlib.persist.sql.datastore.PostgreSQLProcessor",
        name: "query"
    } external;

    isolated resource function get supermarketorders/[int id](SupermarketOrderTargetType targetType = <>) returns targetType|persist:Error = @java:Method {
        'class: "io.ballerina.stdlib.persist.sql.datastore.PostgreSQLProcessor",
        name: "queryOne"
    } external;

    isolated resource function post supermarketorders(SupermarketOrderInsert[] data) returns int[]|persist:Error {
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(SUPERMARKET_ORDER);
        }
        sql:ExecutionResult[] result = check sqlClient.runBatchInsertQuery(data);
        return from sql:ExecutionResult inserted in result
            where inserted.lastInsertId != ()
            select <int>inserted.lastInsertId;
    }

    isolated resource function put supermarketorders/[int id](SupermarketOrderUpdate value) returns SupermarketOrder|persist:Error {
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(SUPERMARKET_ORDER);
        }
        _ = check sqlClient.runUpdateQuery(id, value);
        return self->/supermarketorders/[id].get();
    }

    isolated resource function delete supermarketorders/[int id]() returns SupermarketOrder|persist:Error {
        SupermarketOrder result = check self->/supermarketorders/[id].get();
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(SUPERMARKET_ORDER);
        }
        _ = check sqlClient.runDeleteQuery(id);
        return result;
    }

    isolated resource function get opportunitysupermarkets(OpportunitySupermarketTargetType targetType = <>, sql:ParameterizedQuery whereClause = ``, sql:ParameterizedQuery orderByClause = ``, sql:ParameterizedQuery limitClause = ``, sql:ParameterizedQuery groupByClause = ``) returns stream<targetType, persist:Error?> = @java:Method {
        'class: "io.ballerina.stdlib.persist.sql.datastore.PostgreSQLProcessor",
        name: "query"
    } external;

    isolated resource function get opportunitysupermarkets/[int id](OpportunitySupermarketTargetType targetType = <>) returns targetType|persist:Error = @java:Method {
        'class: "io.ballerina.stdlib.persist.sql.datastore.PostgreSQLProcessor",
        name: "queryOne"
    } external;

    isolated resource function post opportunitysupermarkets(OpportunitySupermarketInsert[] data) returns int[]|persist:Error {
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(OPPORTUNITY_SUPERMARKET);
        }
        sql:ExecutionResult[] result = check sqlClient.runBatchInsertQuery(data);
        return from sql:ExecutionResult inserted in result
            where inserted.lastInsertId != ()
            select <int>inserted.lastInsertId;
    }

    isolated resource function put opportunitysupermarkets/[int id](OpportunitySupermarketUpdate value) returns OpportunitySupermarket|persist:Error {
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(OPPORTUNITY_SUPERMARKET);
        }
        _ = check sqlClient.runUpdateQuery(id, value);
        return self->/opportunitysupermarkets/[id].get();
    }

    isolated resource function delete opportunitysupermarkets/[int id]() returns OpportunitySupermarket|persist:Error {
        OpportunitySupermarket result = check self->/opportunitysupermarkets/[id].get();
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(OPPORTUNITY_SUPERMARKET);
        }
        _ = check sqlClient.runDeleteQuery(id);
        return result;
    }

    isolated resource function get opportunities(OpportunityTargetType targetType = <>, sql:ParameterizedQuery whereClause = ``, sql:ParameterizedQuery orderByClause = ``, sql:ParameterizedQuery limitClause = ``, sql:ParameterizedQuery groupByClause = ``) returns stream<targetType, persist:Error?> = @java:Method {
        'class: "io.ballerina.stdlib.persist.sql.datastore.PostgreSQLProcessor",
        name: "query"
    } external;

    isolated resource function get opportunities/[int id](OpportunityTargetType targetType = <>) returns targetType|persist:Error = @java:Method {
        'class: "io.ballerina.stdlib.persist.sql.datastore.PostgreSQLProcessor",
        name: "queryOne"
    } external;

    isolated resource function post opportunities(OpportunityInsert[] data) returns int[]|persist:Error {
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(OPPORTUNITY);
        }
        sql:ExecutionResult[] result = check sqlClient.runBatchInsertQuery(data);
        return from sql:ExecutionResult inserted in result
            where inserted.lastInsertId != ()
            select <int>inserted.lastInsertId;
    }

    isolated resource function put opportunities/[int id](OpportunityUpdate value) returns Opportunity|persist:Error {
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(OPPORTUNITY);
        }
        _ = check sqlClient.runUpdateQuery(id, value);
        return self->/opportunities/[id].get();
    }

    isolated resource function delete opportunities/[int id]() returns Opportunity|persist:Error {
        Opportunity result = check self->/opportunities/[id].get();
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(OPPORTUNITY);
        }
        _ = check sqlClient.runDeleteQuery(id);
        return result;
    }

    isolated resource function get consumers(ConsumerTargetType targetType = <>, sql:ParameterizedQuery whereClause = ``, sql:ParameterizedQuery orderByClause = ``, sql:ParameterizedQuery limitClause = ``, sql:ParameterizedQuery groupByClause = ``) returns stream<targetType, persist:Error?> = @java:Method {
        'class: "io.ballerina.stdlib.persist.sql.datastore.PostgreSQLProcessor",
        name: "query"
    } external;

    isolated resource function get consumers/[int id](ConsumerTargetType targetType = <>) returns targetType|persist:Error = @java:Method {
        'class: "io.ballerina.stdlib.persist.sql.datastore.PostgreSQLProcessor",
        name: "queryOne"
    } external;

    isolated resource function post consumers(ConsumerInsert[] data) returns int[]|persist:Error {
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(CONSUMER);
        }
        sql:ExecutionResult[] result = check sqlClient.runBatchInsertQuery(data);
        return from sql:ExecutionResult inserted in result
            where inserted.lastInsertId != ()
            select <int>inserted.lastInsertId;
    }

    isolated resource function put consumers/[int id](ConsumerUpdate value) returns Consumer|persist:Error {
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(CONSUMER);
        }
        _ = check sqlClient.runUpdateQuery(id, value);
        return self->/consumers/[id].get();
    }

    isolated resource function delete consumers/[int id]() returns Consumer|persist:Error {
        Consumer result = check self->/consumers/[id].get();
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(CONSUMER);
        }
        _ = check sqlClient.runDeleteQuery(id);
        return result;
    }

    isolated resource function get advertisements(AdvertisementTargetType targetType = <>, sql:ParameterizedQuery whereClause = ``, sql:ParameterizedQuery orderByClause = ``, sql:ParameterizedQuery limitClause = ``, sql:ParameterizedQuery groupByClause = ``) returns stream<targetType, persist:Error?> = @java:Method {
        'class: "io.ballerina.stdlib.persist.sql.datastore.PostgreSQLProcessor",
        name: "query"
    } external;

    isolated resource function get advertisements/[int id](AdvertisementTargetType targetType = <>) returns targetType|persist:Error = @java:Method {
        'class: "io.ballerina.stdlib.persist.sql.datastore.PostgreSQLProcessor",
        name: "queryOne"
    } external;

    isolated resource function post advertisements(AdvertisementInsert[] data) returns int[]|persist:Error {
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(ADVERTISEMENT);
        }
        sql:ExecutionResult[] result = check sqlClient.runBatchInsertQuery(data);
        return from sql:ExecutionResult inserted in result
            where inserted.lastInsertId != ()
            select <int>inserted.lastInsertId;
    }

    isolated resource function put advertisements/[int id](AdvertisementUpdate value) returns Advertisement|persist:Error {
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(ADVERTISEMENT);
        }
        _ = check sqlClient.runUpdateQuery(id, value);
        return self->/advertisements/[id].get();
    }

    isolated resource function delete advertisements/[int id]() returns Advertisement|persist:Error {
        Advertisement result = check self->/advertisements/[id].get();
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(ADVERTISEMENT);
        }
        _ = check sqlClient.runDeleteQuery(id);
        return result;
    }

    isolated resource function get drivers(DriverTargetType targetType = <>, sql:ParameterizedQuery whereClause = ``, sql:ParameterizedQuery orderByClause = ``, sql:ParameterizedQuery limitClause = ``, sql:ParameterizedQuery groupByClause = ``) returns stream<targetType, persist:Error?> = @java:Method {
        'class: "io.ballerina.stdlib.persist.sql.datastore.PostgreSQLProcessor",
        name: "query"
    } external;

    isolated resource function get drivers/[int id](DriverTargetType targetType = <>) returns targetType|persist:Error = @java:Method {
        'class: "io.ballerina.stdlib.persist.sql.datastore.PostgreSQLProcessor",
        name: "queryOne"
    } external;

    isolated resource function post drivers(DriverInsert[] data) returns int[]|persist:Error {
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(DRIVER);
        }
        sql:ExecutionResult[] result = check sqlClient.runBatchInsertQuery(data);
        return from sql:ExecutionResult inserted in result
            where inserted.lastInsertId != ()
            select <int>inserted.lastInsertId;
    }

    isolated resource function put drivers/[int id](DriverUpdate value) returns Driver|persist:Error {
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(DRIVER);
        }
        _ = check sqlClient.runUpdateQuery(id, value);
        return self->/drivers/[id].get();
    }

    isolated resource function delete drivers/[int id]() returns Driver|persist:Error {
        Driver result = check self->/drivers/[id].get();
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(DRIVER);
        }
        _ = check sqlClient.runDeleteQuery(id);
        return result;
    }

    isolated resource function get reviews(ReviewTargetType targetType = <>, sql:ParameterizedQuery whereClause = ``, sql:ParameterizedQuery orderByClause = ``, sql:ParameterizedQuery limitClause = ``, sql:ParameterizedQuery groupByClause = ``) returns stream<targetType, persist:Error?> = @java:Method {
        'class: "io.ballerina.stdlib.persist.sql.datastore.PostgreSQLProcessor",
        name: "query"
    } external;

    isolated resource function get reviews/[int id](ReviewTargetType targetType = <>) returns targetType|persist:Error = @java:Method {
        'class: "io.ballerina.stdlib.persist.sql.datastore.PostgreSQLProcessor",
        name: "queryOne"
    } external;

    isolated resource function post reviews(ReviewInsert[] data) returns int[]|persist:Error {
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(REVIEW);
        }
        sql:ExecutionResult[] result = check sqlClient.runBatchInsertQuery(data);
        return from sql:ExecutionResult inserted in result
            where inserted.lastInsertId != ()
            select <int>inserted.lastInsertId;
    }

    isolated resource function put reviews/[int id](ReviewUpdate value) returns Review|persist:Error {
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(REVIEW);
        }
        _ = check sqlClient.runUpdateQuery(id, value);
        return self->/reviews/[id].get();
    }

    isolated resource function delete reviews/[int id]() returns Review|persist:Error {
        Review result = check self->/reviews/[id].get();
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(REVIEW);
        }
        _ = check sqlClient.runDeleteQuery(id);
        return result;
    }

    isolated resource function get likedproducts(LikedProductTargetType targetType = <>, sql:ParameterizedQuery whereClause = ``, sql:ParameterizedQuery orderByClause = ``, sql:ParameterizedQuery limitClause = ``, sql:ParameterizedQuery groupByClause = ``) returns stream<targetType, persist:Error?> = @java:Method {
        'class: "io.ballerina.stdlib.persist.sql.datastore.PostgreSQLProcessor",
        name: "query"
    } external;

    isolated resource function get likedproducts/[int id](LikedProductTargetType targetType = <>) returns targetType|persist:Error = @java:Method {
        'class: "io.ballerina.stdlib.persist.sql.datastore.PostgreSQLProcessor",
        name: "queryOne"
    } external;

    isolated resource function post likedproducts(LikedProductInsert[] data) returns int[]|persist:Error {
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(LIKED_PRODUCT);
        }
        sql:ExecutionResult[] result = check sqlClient.runBatchInsertQuery(data);
        return from sql:ExecutionResult inserted in result
            where inserted.lastInsertId != ()
            select <int>inserted.lastInsertId;
    }

    isolated resource function put likedproducts/[int id](LikedProductUpdate value) returns LikedProduct|persist:Error {
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(LIKED_PRODUCT);
        }
        _ = check sqlClient.runUpdateQuery(id, value);
        return self->/likedproducts/[id].get();
    }

    isolated resource function delete likedproducts/[int id]() returns LikedProduct|persist:Error {
        LikedProduct result = check self->/likedproducts/[id].get();
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(LIKED_PRODUCT);
        }
        _ = check sqlClient.runDeleteQuery(id);
        return result;
    }

    isolated resource function get activities(ActivityTargetType targetType = <>, sql:ParameterizedQuery whereClause = ``, sql:ParameterizedQuery orderByClause = ``, sql:ParameterizedQuery limitClause = ``, sql:ParameterizedQuery groupByClause = ``) returns stream<targetType, persist:Error?> = @java:Method {
        'class: "io.ballerina.stdlib.persist.sql.datastore.PostgreSQLProcessor",
        name: "query"
    } external;

    isolated resource function get activities/[int id](ActivityTargetType targetType = <>) returns targetType|persist:Error = @java:Method {
        'class: "io.ballerina.stdlib.persist.sql.datastore.PostgreSQLProcessor",
        name: "queryOne"
    } external;

    isolated resource function post activities(ActivityInsert[] data) returns int[]|persist:Error {
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(ACTIVITY);
        }
        sql:ExecutionResult[] result = check sqlClient.runBatchInsertQuery(data);
        return from sql:ExecutionResult inserted in result
            where inserted.lastInsertId != ()
            select <int>inserted.lastInsertId;
    }

    isolated resource function put activities/[int id](ActivityUpdate value) returns Activity|persist:Error {
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(ACTIVITY);
        }
        _ = check sqlClient.runUpdateQuery(id, value);
        return self->/activities/[id].get();
    }

    isolated resource function delete activities/[int id]() returns Activity|persist:Error {
        Activity result = check self->/activities/[id].get();
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(ACTIVITY);
        }
        _ = check sqlClient.runDeleteQuery(id);
        return result;
    }

    isolated resource function get files(FilesTargetType targetType = <>, sql:ParameterizedQuery whereClause = ``, sql:ParameterizedQuery orderByClause = ``, sql:ParameterizedQuery limitClause = ``, sql:ParameterizedQuery groupByClause = ``) returns stream<targetType, persist:Error?> = @java:Method {
        'class: "io.ballerina.stdlib.persist.sql.datastore.PostgreSQLProcessor",
        name: "query"
    } external;

    isolated resource function get files/[int id](FilesTargetType targetType = <>) returns targetType|persist:Error = @java:Method {
        'class: "io.ballerina.stdlib.persist.sql.datastore.PostgreSQLProcessor",
        name: "queryOne"
    } external;

    isolated resource function post files(FilesInsert[] data) returns int[]|persist:Error {
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(FILES);
        }
        sql:ExecutionResult[] result = check sqlClient.runBatchInsertQuery(data);
        return from sql:ExecutionResult inserted in result
            where inserted.lastInsertId != ()
            select <int>inserted.lastInsertId;
    }

    isolated resource function put files/[int id](FilesUpdate value) returns Files|persist:Error {
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(FILES);
        }
        _ = check sqlClient.runUpdateQuery(id, value);
        return self->/files/[id].get();
    }

    isolated resource function delete files/[int id]() returns Files|persist:Error {
        Files result = check self->/files/[id].get();
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(FILES);
        }
        _ = check sqlClient.runDeleteQuery(id);
        return result;
    }

    remote isolated function queryNativeSQL(sql:ParameterizedQuery sqlQuery, typedesc<record {}> rowType = <>) returns stream<rowType, persist:Error?> = @java:Method {
        'class: "io.ballerina.stdlib.persist.sql.datastore.PostgreSQLProcessor"
    } external;

    remote isolated function executeNativeSQL(sql:ParameterizedQuery sqlQuery) returns psql:ExecutionResult|persist:Error = @java:Method {
        'class: "io.ballerina.stdlib.persist.sql.datastore.PostgreSQLProcessor"
    } external;

    public isolated function close() returns persist:Error? {
        error? result = self.dbClient.close();
        if result is error {
            return <persist:Error>error(result.message());
        }
        return result;
    }
}

