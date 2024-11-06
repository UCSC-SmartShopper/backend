DROP TABLE IF EXISTS "SupermarketItem";


INSERT INTO public."SupermarketItem" (id, price, discount, "availableQuantity", "productId", "supermarketId") VALUES
(1, 100.99, 999, 100, 1, 1),
(2, 5.49, 1098, 200, 1, 2),
(3, 15.25, 2287.5, 150, 1, 3),
(4, 7.99, 2397, 300, 2, 1),
(5, 12.75, 1020, 80, 2, 2)
ON CONFLICT (id) 
DO UPDATE SET 
    price = EXCLUDED.price,
    discount = EXCLUDED.discount,
    "availableQuantity" = EXCLUDED."availableQuantity",
    "productId" = EXCLUDED."productId",
    "supermarketId" = EXCLUDED."supermarketId";


