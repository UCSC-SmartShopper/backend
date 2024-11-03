-- AUTO-GENERATED FILE.

-- This file is an auto-generated file by Ballerina persistence layer for model.
-- Please verify the generated scripts and execute them against the target DB server.

DROP TABLE IF EXISTS "OrderItems";
DROP TABLE IF EXISTS "Address";
DROP TABLE IF EXISTS "OpportunitySupermarket";
DROP TABLE IF EXISTS "Opportunity";
DROP TABLE IF EXISTS "Consumer";
DROP TABLE IF EXISTS "SupermarketItem";
DROP TABLE IF EXISTS "SupermarketOrder";
DROP TABLE IF EXISTS "Supermarket";
DROP TABLE IF EXISTS "Driver";
DROP TABLE IF EXISTS "CartItem";
DROP TABLE IF EXISTS "Review";
DROP TABLE IF EXISTS "Order";
DROP TABLE IF EXISTS "User";
DROP TABLE IF EXISTS "NonVerifyUser";
DROP TABLE IF EXISTS "Product";
DROP TABLE IF EXISTS "Advertisement";
DROP TABLE IF EXISTS "LikedProduct";
DROP TABLE IF EXISTS "NonVerifiedDriver";

CREATE TABLE "NonVerifiedDriver" (
	"id"  SERIAL,
	"name" VARCHAR(191) NOT NULL,
	"nic" VARCHAR(191) NOT NULL,
	"email" VARCHAR(191) NOT NULL,
	"contactNo" VARCHAR(191) NOT NULL,
	"OTP" VARCHAR(191) NOT NULL,
	"courierCompany" VARCHAR(191) NOT NULL,
	"vehicleType" VARCHAR(191) NOT NULL,
	"vehicleColor" VARCHAR(191) NOT NULL,
	"vehicleName" VARCHAR(191) NOT NULL,
	"vehicleNumber" VARCHAR(191) NOT NULL,
	"password" VARCHAR(191) NOT NULL,
	"status" VARCHAR(191) NOT NULL,
	PRIMARY KEY("id")
);

CREATE TABLE "LikedProduct" (
	"id"  SERIAL,
	"userId" INT NOT NULL,
	"productId" INT NOT NULL,
	PRIMARY KEY("id")
);

CREATE TABLE "Advertisement" (
	"id"  SERIAL,
	"image" VARCHAR(191) NOT NULL,
	"status" VARCHAR(191) NOT NULL,
	"startDate" VARCHAR(191) NOT NULL,
	"endDate" VARCHAR(191) NOT NULL,
	"priority" VARCHAR(191) NOT NULL,
	PRIMARY KEY("id")
);

CREATE TABLE "Product" (
	"id"  SERIAL,
	"name" VARCHAR(191) NOT NULL,
	"description" VARCHAR(191) NOT NULL,
	"category" VARCHAR(191) NOT NULL,
	"price" FLOAT NOT NULL,
	"imageUrl" VARCHAR(191) NOT NULL,
	PRIMARY KEY("id")
);

CREATE TABLE "NonVerifyUser" (
	"id"  SERIAL,
	"name" VARCHAR(191) NOT NULL,
	"email" VARCHAR(191) NOT NULL,
	"contactNo" VARCHAR(191) NOT NULL,
	"OTP" VARCHAR(191) NOT NULL,
	"password" VARCHAR(191) NOT NULL,
	PRIMARY KEY("id")
);

CREATE TABLE "User" (
	"id"  SERIAL,
	"name" VARCHAR(191) NOT NULL,
	"email" VARCHAR(191) NOT NULL,
	"password" VARCHAR(191) NOT NULL,
	"number" VARCHAR(191) NOT NULL,
	"profilePic" VARCHAR(191) NOT NULL,
	"role" VARCHAR(191) NOT NULL,
	"status" VARCHAR(191) NOT NULL,
	"lastLogin" TIMESTAMP,
	"createdAt" TIMESTAMP NOT NULL,
	"updatedAt" TIMESTAMP NOT NULL,
	"deletedAt" TIMESTAMP,
	PRIMARY KEY("id")
);

CREATE TABLE "Order" (
	"id"  SERIAL,
	"consumerId" INT NOT NULL,
	"status" VARCHAR(10) CHECK ("status" IN ('ToPay', 'Placed', 'Prepared', 'Processing', 'Ready', 'Delivered', 'Cancelled')) NOT NULL,
	"shippingAddress" VARCHAR(191) NOT NULL,
	"shippingMethod" VARCHAR(191) NOT NULL,
	"location" VARCHAR(191) NOT NULL,
	"deliveryFee" FLOAT NOT NULL,
	"orderPlacedOn" TIMESTAMP NOT NULL,
	PRIMARY KEY("id")
);

CREATE TABLE "Review" (
	"id"  SERIAL,
	"reviewType" VARCHAR(191) NOT NULL,
	"targetId" INT NOT NULL,
	"title" VARCHAR(191) NOT NULL,
	"content" VARCHAR(191) NOT NULL,
	"rating" FLOAT NOT NULL,
	"createdAt" TIMESTAMP NOT NULL,
	"userId" INT NOT NULL,
	FOREIGN KEY("userId") REFERENCES "User"("id"),
	PRIMARY KEY("id")
);

CREATE TABLE "CartItem" (
	"id"  SERIAL,
	"quantity" INT NOT NULL,
	"consumerId" INT NOT NULL,
	"productId" INT NOT NULL,
	"supermarketitemId" INT NOT NULL,
	FOREIGN KEY("supermarketitemId") REFERENCES "SupermarketItem"("id"),
	PRIMARY KEY("id")
);

CREATE TABLE "Driver" (
	"id"  SERIAL,
	"nic" VARCHAR(191) NOT NULL,
	"courierCompany" VARCHAR(191) NOT NULL,
	"vehicleType" VARCHAR(191) NOT NULL,
	"vehicleColor" VARCHAR(191) NOT NULL,
	"vehicleName" VARCHAR(191) NOT NULL,
	"vehicleNumber" VARCHAR(191) NOT NULL,
	"userId" INT UNIQUE NOT NULL,
	FOREIGN KEY("userId") REFERENCES "User"("id"),
	PRIMARY KEY("id")
);

CREATE TABLE "Supermarket" (
	"id"  SERIAL,
	"name" VARCHAR(191) NOT NULL,
	"contactNo" VARCHAR(191) NOT NULL,
	"logo" VARCHAR(191) NOT NULL,
	"location" VARCHAR(191) NOT NULL,
	"city" VARCHAR(191) NOT NULL,
	"address" VARCHAR(191) NOT NULL,
	"supermarketmanagerId" INT UNIQUE NOT NULL,
	FOREIGN KEY("supermarketmanagerId") REFERENCES "User"("id"),
	PRIMARY KEY("id")
);

CREATE TABLE "SupermarketOrder" (
	"id"  SERIAL,
	"status" VARCHAR(191) NOT NULL,
	"qrCode" VARCHAR(191) NOT NULL,
	"_orderId" INT NOT NULL,
	FOREIGN KEY("_orderId") REFERENCES "Order"("id"),
	"supermarketId" INT NOT NULL,
	FOREIGN KEY("supermarketId") REFERENCES "Supermarket"("id"),
	PRIMARY KEY("id")
);

CREATE TABLE "SupermarketItem" (
	"id"  SERIAL,
	"price" FLOAT NOT NULL,
	"discount" FLOAT NOT NULL,
	"availableQuantity" INT NOT NULL,
	"productId" INT NOT NULL,
	FOREIGN KEY("productId") REFERENCES "Product"("id"),
	"supermarketId" INT NOT NULL,
	FOREIGN KEY("supermarketId") REFERENCES "Supermarket"("id"),
	PRIMARY KEY("id")
);

CREATE TABLE "Consumer" (
	"id"  SERIAL,
	"userId" INT UNIQUE NOT NULL,
	FOREIGN KEY("userId") REFERENCES "User"("id"),
	PRIMARY KEY("id")
);

CREATE TABLE "Opportunity" (
	"id"  SERIAL,
	"totalDistance" FLOAT NOT NULL,
	"tripCost" FLOAT NOT NULL,
	"deliveryCost" FLOAT NOT NULL,
	"startLocation" VARCHAR(191) NOT NULL,
	"deliveryLocation" VARCHAR(191) NOT NULL,
	"status" VARCHAR(191) NOT NULL,
	"driverId" INT NOT NULL,
	"orderPlacedOn" TIMESTAMP NOT NULL,
	"consumerId" INT NOT NULL,
	FOREIGN KEY("consumerId") REFERENCES "Consumer"("id"),
	"_orderId" INT NOT NULL,
	FOREIGN KEY("_orderId") REFERENCES "Order"("id"),
	PRIMARY KEY("id")
);

CREATE TABLE "OpportunitySupermarket" (
	"id"  SERIAL,
	"supermarketId" INT NOT NULL,
	FOREIGN KEY("supermarketId") REFERENCES "Supermarket"("id"),
	"opportunityId" INT NOT NULL,
	FOREIGN KEY("opportunityId") REFERENCES "Opportunity"("id"),
	PRIMARY KEY("id")
);

CREATE TABLE "Address" (
	"id"  SERIAL,
	"addressName" VARCHAR(191) NOT NULL,
	"address" VARCHAR(191) NOT NULL,
	"city" VARCHAR(191) NOT NULL,
	"location" VARCHAR(191) NOT NULL,
	"isDefault" BOOLEAN NOT NULL,
	"consumerId" INT NOT NULL,
	FOREIGN KEY("consumerId") REFERENCES "Consumer"("id"),
	PRIMARY KEY("id")
);

CREATE TABLE "OrderItems" (
	"id"  SERIAL,
	"supermarketId" INT NOT NULL,
	"productId" INT NOT NULL,
	"quantity" INT NOT NULL,
	"price" FLOAT NOT NULL,
	"_orderId" INT NOT NULL,
	FOREIGN KEY("_orderId") REFERENCES "Order"("id"),
	PRIMARY KEY("id")
);


CREATE UNIQUE INDEX "cart_item_unique_index" ON "CartItem" ("consumerId", "productId");
CREATE UNIQUE INDEX "liked_product_unique_index" ON "LikedProduct" ("userId", "productId");
