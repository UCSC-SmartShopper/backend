INSERT INTO 
    "Order" (
        "consumerId",
        "status",
        "shippingAddress",
        "shippingMethod",
        "location",
        "supermarketIdList"
    ) 
VALUES 
    (1, 'ToPay', '73/c Koskanda, Halthota', 'delivery', '6.8657635,79.8571086', '1,2,3,4'),
    (2, 'ToPay', '45/B Green Street, Hillview', 'delivery', '6.8657635,79.8571086', '2,3,4'),
    (3, 'Shipped', '12/A Beach Road, Seaview', 'pickup', '6.8657635,79.8571086', '1,2,3'),
    (1, 'Delivered', '89/D Maple Lane, Forestville', 'delivery', '6.8657635,79.8571086', '1,3,4'),
    (2, 'Cancelled', '22/F Pine Avenue, Rivertown', 'delivery', '6.8657635,79.8571086', '1,2'),
    (3, 'Processing', '33/C Oak Street, Woodland', 'pickup', '6.8657635,79.8571086', '3');


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