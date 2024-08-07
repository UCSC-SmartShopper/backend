-- CREATE TABLE "OpportunitySupermarket" (
-- 	"id"  SERIAL,
-- 	"supermarketId" INT NOT NULL,
-- 	FOREIGN KEY("supermarketId") REFERENCES "Supermarket"("id"),
-- 	"opportunityId" INT NOT NULL,
-- 	FOREIGN KEY("opportunityId") REFERENCES "Opportunity"("id"),
-- 	PRIMARY KEY("id")
-- );

-- CREATE TABLE "Opportunity" (
-- 	"id"  SERIAL,
-- 	"totalDistance" FLOAT NOT NULL,
-- 	"tripCost" FLOAT NOT NULL,
-- 	"orderPlacedOn" VARCHAR(191) NOT NULL,
-- 	"deliveryCost" FLOAT NOT NULL,
-- 	"startLocation" VARCHAR(191) NOT NULL,
-- 	"deliveryLocation" VARCHAR(191) NOT NULL,
-- 	"consumerId" INT UNIQUE NOT NULL,
-- 	FOREIGN KEY("consumerId") REFERENCES "Consumer"("id"),
-- 	PRIMARY KEY("id")
-- );

INSERT INTO
    "Opportunity" (
        "totalDistance",
        "tripCost",
        "orderPlacedOn",
        "consumerId",
        "deliveryCost",
        "startLocation",
        "deliveryLocation",
        "status" ,"orderId" ,"driverId"
    )
VALUES (
        12.3,
        180.0,
        '2024-07-28',
        2,
        45.0,
        'Origin A',
        'Destination A',
        'Pending',
        2,
        2
    ),
    (
        8.5,
        120.0,
        '2024-07-29',
        1,
        25.0,
        'Origin B',
        'Destination B',
        'Cancelled',
        1,
        1
    ),
    (
        15.0,
        210.0,
        '2024-07-30',
        3,
        55.0,
        'Origin C',
        'Destination C',
        'Delivered',
        3,
        3
    ),
    (
        10.2,
        130.0,
        '2024-07-31',
        2,
        35.0,
        'Origin D',
        'Destination D',
        'Pending',
        4,
        2
    ),
    (
        22.7,
        270.0,
        '2024-08-01',
        1,
        60.0,
        'Origin E',
        'Destination E',
        'Delivered',
        2,
        4
    );

INSERT INTO
    "OpportunitySupermarket" (
        "supermarketId",
        "opportunityId"
    )
VALUES (1, 1),
    (2, 1),
    (1, 2),
    (3, 2),
    (2, 3),
    (3, 3),
    (1, 4),
    (2, 4),
    (3, 5),
    (1, 5);