INSERT INTO "Order" ("consumerId") VALUES (1), (2), (3);

INSERT INTO
    "OrderItems" (
        "supermarketItemId",
        "productId",
        "quantity",
        "price",
        "_orderId"
    )
VALUES (1, 1, 2, 10.99, 1),
    (2, 1, 1, 5.49, 1),
    (3, 1, 1, 15.25, 2),
    (4, 2, 3, 7.99, 2),
    (5, 2, 2, 12.75, 3);