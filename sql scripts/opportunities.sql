INSERT INTO "Opportunity" (
    "supermarketList",
    "totalDistance",
    "tripCost",
    "orderPlacedOn",
    "consumer",
    "deliveryCost",
    "startLocation",
    "deliveryLocation"
    "status"
) VALUES 
    (
        ARRAY[1, 2], -- IDs of supermarkets
        12.3,        -- Total distance in kilometers
        180.0,       -- Trip cost
        '2024-07-28',-- Order placed date
        2,           -- Consumer ID
        45.0,        -- Delivery cost
        'Origin A',  -- Start location
        'Destination A', -- Delivery location
        'Pending'    -- Status
    ), 
    (
        ARRAY[3, 4],
        8.5,
        120.0,
        '2024-07-29',
        15,
        25.0,
        'Origin B',
        'Destination B',
        'Cancelled'
    ),
    (
        ARRAY[5, 6],
        15.0,
        210.0,
        '2024-07-30',
        16,
        55.0,
        'Origin C',
        'Destination C',
        'Delivered'
    ), 
    (
        ARRAY[7, 8],
        10.2,
        130.0,
        '2024-07-31',
        2,
        35.0,
        'Origin D',
        'Destination D',
        'Pending'
    ), 
    (
        ARRAY[9, 10],
        22.7,
        270.0,
        '2024-08-01',
        15,
        60.0,
        'Origin E',
        'Destination E',
        'Delivered'
    );