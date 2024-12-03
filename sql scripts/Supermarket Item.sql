INSERT INTO
    public."SupermarketItem" (
        id,
        price,
        discount,
        "availableQuantity",
        "productId",
        "supermarketId"
    )
VALUES
    -- Item 1 original price 118.00 
    (1, 100.00, 18, 100, 1, 1),
    (2, 105.00, 13, 200, 1, 2),
    (3, 110.00, 18, 150, 1, 3),
    -- Item 2 original price 755.00 
    (4, 700.00, 55, 50, 2, 1),
    (5, 750.00, 5, 400, 2, 2),
    (6, 745.00, 10, 500, 2, 3),
    -- Item 3 original price 755.00 
    (7, 720.00, 35, 300, 3, 1),
    (8, 750.00, 5, 400, 3, 2),
    (9, 745.00, 10, 500, 3, 3),
    -- Item 4 original price 180.00 
    (10, 150.00, 30, 100, 4, 1),
    (11, 160.00, 20, 200, 4, 2),
    (12, 170.00, 10, 300, 4, 3),
    -- Item 5 original price 400.00 
    (13, 350.00, 50, 100, 5, 1),
    (14, 380.00, 20, 200, 5, 2),
    (15, 390.00, 10, 300, 5, 3),
    -- Item 6 original price 506.00 
    (16, 450.00, 56, 100, 6, 1),
    (17, 500.00, 6, 200, 6, 2),
    (18, 490.00, 16, 300, 6, 3),
    -- Item 7 original price 540.00 
    (19, 500.00, 40, 100, 7, 1),
    (20, 520.00, 20, 200, 7, 2),
    (21, 530.00, 10, 300, 7, 3),
    -- Item 8 original price 350.00 
    (22, 300.00, 50, 100, 8, 1),
    (23, 320.00, 30, 200, 8, 2),
    (24, 330.00, 20, 300, 8, 3),
    -- Item 9 original price 252.00 
    (25, 200.00, 52, 100, 9, 1),
    (26, 220.00, 32, 200, 9, 2),
    (27, 230.00, 22, 300, 9, 3),
    -- Item 10 original price 180.00 
    (28, 150.00, 30, 100, 10, 1),
    (29, 160.00, 20, 200, 10, 2),
    (30, 170.00, 10, 300, 10, 3),
    -- Item 11 original price 180.00 
    (31, 150.00, 30, 100, 11, 1),
    (32, 160.00, 20, 200, 11, 2),
    (33, 170.00, 10, 300, 11, 3)
ON CONFLICT (id) DO
UPDATE
SET
    price = EXCLUDED.price,
    discount = EXCLUDED.discount,
    "availableQuantity" = EXCLUDED."availableQuantity",
    "productId" = EXCLUDED."productId",
    "supermarketId" = EXCLUDED."supermarketId";