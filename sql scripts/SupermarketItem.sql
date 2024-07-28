DROP TABLE IF EXISTS "SupermarketItem";
INSERT INTO
    "SupermarketItem" (
        "productId",
        "price",
        "availableQuantity",
        "discount",
        "supermarketId"
    )
VALUES 
(1, 10.99, 100, 3.99, 1),
    (1, 5.49, 200, 1.00, 2),
    (1, 15.25, 150, 6.50, 3),
    (2, 7.99, 300, 2.30, 1),
    (2, 12.75, 80, 5.00, 2);    
