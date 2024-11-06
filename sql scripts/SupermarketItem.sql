DROP TABLE IF EXISTS "SupermarketItem";

INSERT INTO
    "SupermarketItem" (
        "productId",
        "price",
        "availableQuantity",
        "discount",
        "supermarketId"
    )
VALUES (1, 120, 100, 3.00, 1),
    (1, 110, 200, 1.00, 4),
    (1, 130, 150, 6.00, 3),
    (2, 730, 300, 2.00, 3),
    (2, 755, 80, 5.00, 4),
    (2, 740, 89, 2.00, 5),
    (3, 800, 87, 4.00, 10),
    (3, 720, 90, 8.00, 11),
    (3, 750, 102, 6.00, 12),
    (4, 200, 88, 5.00, 6),
    (4, 180, 132, 5.00, 7),
    (5, 400, 98, 5.00, 7),
    (5, 450, 90, 5.00, 8),
    (5, 500, 95, 5.00, 11),
    (6, 600, 59, 5.00, 2),
    (6, 506, 93, 5.00, 3),
    (7, 500, 150, 5.00, 1),
    (7, 700, 180, 5.00, 4),
    (7, 540, 192, 5.00, 3),
    (8, 350, 98, 5.00, 1),
    (8, 400, 107, 5.00, 2),
    (9, 252, 97, 5.00, 1),
    (9, 250, 120, 5.00, 2),
    (9, 200, 110, 5.00, 3),
    (10, 179, 200, 5.00, 11),
    (10, 200, 188, 5.00, 12),
    (11, 280, 157, 5.00, 1),
    (11, 300, 176, 5.00, 7),
    (11, 390, 180, 5.00, 11),
    (12, 280, 100, 5.00, 3),
    (12, 232, 120, 5.00, 7),
    (12, 250, 118, 5.00, 10);