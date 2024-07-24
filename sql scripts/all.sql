INSERT INTO
    "User" (
        "name",
        "email",
        "password",
        "number",
        "profilePic",
        "userRole",
        "status",
        "createdAt",
        "updatedAt",
        "deletedAt"
    )
VALUES (
        'kaveesha Hettige',
        'admin@gmail.com',
        '123456',
        '0713465836',
        'profile5.jpg',
        'admin',
        'active',
        '2024-01-01 10:00:00',
        '2024-01-01 10:00:00',
        NULL
    ),
    (
        'Bimsara Jayadewa',
        'consumer@gmail.com',
        '123456',
        '0717654321',
        'profile5.jpg',
        'consumer',
        'active',
        '2024-01-02 11:00:00',
        '2024-01-02 11:00:00',
        NULL
    ),
    (
        'Nethmi Athukorala',
        'driver@gmail.com',
        '123456',
        '0712334855',
        'profile5.jpg',
        'driver',
        'active',
        '2024-01-03 12:00:00',
        '2024-01-03 12:00:00',
        NULL
    ),
    (
        'Sarala Janson',
        'couriercompany@gmail.com',
        '123456',
        '0716778899',
        'profile5.jpg',
        'couriercompany',
        'active',
        '2024-01-04 13:00:00',
        '2024-01-04 13:00:00',
        NULL
    ),
    (
        'Milinda Shehan',
        'supermarket@gmail.com',
        '123456',
        '0717889900',
        'profile5.jpg',
        'supermarket',
        'active',
        '2024-01-05 14:00:00',
        '2024-01-05 14:00:00',
        NULL
    ),
    (
        'Milinda Shehan',
        'supermarket1@gmail.com',
        '123456',
        '0717345030',
        'profile5.jpg',
        'supermarket',
        'active',
        '2024-01-05 14:00:00',
        '2024-01-05 14:00:00',
        NULL
    ),
    (
        'Milinda Shehan',
        'supermarket2@gmail.com',
        '123456',
        '0717867400',
        'profile5.jpg',
        'supermarket',
        'active',
        '2024-01-05 14:00:00',
        '2024-01-05 14:00:00',
        NULL
    ),
    (
        'Milinda Shehan',
        'supermarket3@gmail.com',
        '123456',
        '0717824890',
        'profile5.jpg',
        'supermarket',
        'active',
        '2024-01-05 14:00:00',
        '2024-01-05 14:00:00',
        NULL
    ),
    (
        'Milinda Shehan',
        'supermarket4@gmail.com',
        '123456',
        '0717882340',
        'profile5.jpg',
        'supermarket',
        'active',
        '2024-01-05 14:00:00',
        '2024-01-05 14:00:00',
        NULL
    ),
    (
        'Milinda Shehan',
        'supermarket5@gmail.com',
        '123456',
        '0717878760',
        'profile5.jpg',
        'supermarket',
        'active',
        '2024-01-05 14:00:00',
        '2024-01-05 14:00:00',
        NULL
    ),
    (
        'Milinda Shehan',
        'supermarket6@gmail.com',
        '123456',
        '0717987300',
        'profile5.jpg',
        'supermarket',
        'active',
        '2024-01-05 14:00:00',
        '2024-01-05 14:00:00',
        NULL
    ),
    (
        'Milinda Shehan',
        'supermarket7@gmail.com',
        '123456',
        '0711206300',
        'profile5.jpg',
        'supermarket',
        'active',
        '2024-01-05 14:00:00',
        '2024-01-05 14:00:00',
        NULL
    ),
    (
        'Milinda Shehan',
        'supermarket8@gmail.com',
        '123456',
        '0714593200',
        'profile5.jpg',
        'supermarket',
        'active',
        '2024-01-05 14:00:00',
        '2024-01-05 14:00:00',
        NULL
    ),
    (
        'Milinda Shehan',
        'supermarket9@gmail.com',
        '123456',
        '0710347630',
        'profile5.jpg',
        'supermarket',
        'active',
        '2024-01-05 14:00:00',
        '2024-01-05 14:00:00',
        NULL
    ),
    (
        'Chathushka Ayash',
        'ayash@gmail.com',
        '123456',
        '0712216841',
        'profile5.jpg',
        'consumer',
        'active',
        '2024-01-05 14:00:00',
        '2024-01-05 14:00:00',
        NULL
    ),
    (
        'Ravindu Hansaka',
        'ravindu@gmail.com',
        '123456',
        '0715056775',
        'profile5.jpg',
        'consumer',
        'active',
        '2024-01-05 14:00:00',
        '2024-01-05 14:00:00',
        NULL
    ),
    (
        'Buddika Senanayake',
        'buddika@gmail.com',
        '123456',
        '0718926784',
        'profile5.jpg',
        'consumer',
        'active',
        '2024-01-05 14:00:00',
        '2024-01-05 14:00:00',
        NULL
    );

INSERT INTO "Consumer" ("userId") VALUES (2), (15), (16);

INSERT INTO
    "Address" (
        "addressName",
        "address",
        "city",
        "location",
        "isDefault",
        "consumerId"
    )
VALUES (
        'Bodima',
        '123 Temple Road, Wijerama',
        'Wijerama',
        '6.857740, 79.908682',
        TRUE,
        1
    ),
    (
        'Home',
        '144 High Level Rd, Maharagama',
        'Maharagama',
        '6.841174, 79.965387',
        TRUE,
        2
    ),
    (
        'Home',
        '292 High Level Rd, Nugegoda',
        'Nugegoda',
        '6.865683, 79.894157',
        TRUE,
        3
    );

INSERT INTO
    "Product" (
        "name",
        "description",
        "price",
        "imageUrl"
    )
VALUES (
        'Keells Marshmallow Assorted 70g',
        'KEELLS MARSHMALLOW ASSORTED 70G',
        118,
        'https://essstr.blob.core.windows.net/essimg/350x/Small/Pic119557.jpg'
    ),
    (
        'Keells A/Fresh Spray E/Rose 475ml',
        'KEELLS A/FRESH SPRAY E/ROSE 475ML',
        755,
        'https://essstr.blob.core.windows.net/essimg/350x/Small/Pic101593.jpg'
    ),
    (
        'Keells A/Fresh Spray Lavend. 475ml',
        'KEELLS A/FRESH SPRAY LAVEND. 475ML',
        755,
        'https://essstr.blob.core.windows.net/essimg/350x/Small/Pic101594.jpg'
    ),
    (
        'Keells Ambulthiyal Paste 50g',
        'KEELLS AMBULTHIYAL PASTE 50G',
        180,
        'https://essstr.blob.core.windows.net/essimg/350x/Small/Pic119998.jpg'
    ),
    (
        'Keells Anti-Bac Dish Wash Liq 500ml',
        'KEELLS ANTI-BAC DISH WASH LIQ 500ML',
        400,
        'https://essstr.blob.core.windows.net/essimg/350x/Small/Pic115419.jpg'
    ),
    (
        'Keells Arabic Bread 500G 5S',
        'KEELLS ARABIC BREAD 500G 5S',
        506,
        'https://essstr.blob.core.windows.net/essimg/350x/Small/Pic119753.jpg'
    ),
    (
        'Keells Ash Guord Cherry 200g',
        'KEELLS ASH GUORD CHERRY 200G',
        540,
        'https://essstr.blob.core.windows.net/essimg/350x/Small/Pic118651.jpg'
    ),
    (
        'Keells Atta Flour 1kg',
        'KEELLS ATTA FLOUR 1KG',
        350,
        'https://essstr.blob.core.windows.net/essimg/350x/Small/Pic118033.jpg'
    ),
    (
        'Keells Baking Powder 100g',
        'KEELLS BAKING POWDER 100G',
        252,
        'https://essstr.blob.core.windows.net/essimg/350x/Small/Pic121183.jpg'
    ),
    (
        'Keells Balloons "Happy Bday" 9In 8S',
        'KEELLS BALLOONS "HAPPY BDAY" 9IN 8S',
        179,
        'https://essstr.blob.core.windows.net/essimg/350x/Small/Pic108344.jpg'
    ),
    (
        'Keells Balloons Assorted 9 Inch 20S',
        'KEELLS BALLOONS ASSORTED 9 INCH 20S',
        223,
        'https://essstr.blob.core.windows.net/essimg/350x/Small/Pic108343.jpg'
    ),
    (
        'Keells Balloons Red 9 Inch 20S',
        'KEELLS BALLOONS RED 9 INCH 20S',
        232,
        'https://essstr.blob.core.windows.net/essimg/350x/Small/Pic108342.jpg'
    ),
    (
        'Keells Bar Soap 650g',
        'KEELLS BAR SOAP 650G',
        445,
        'https://essstr.blob.core.windows.net/essimg/350x/Small/Pic118281.jpg'
    ),
    (
        'Keells Barley 250g',
        'KEELLS BARLEY 250G',
        465,
        'https://essstr.blob.core.windows.net/essimg/350x/Small/Pic117941.jpg'
    ),
    (
        'Keells Bbq Chicken Tikka Mix 50g',
        'KEELLS BBQ CHICKEN TIKKA MIX 50G',
        280,
        'https://essstr.blob.core.windows.net/essimg/350x/Small/Pic119999.jpg'
    ),
    (
        'Keells Biriyani Masala Mix 50g',
        'KEELLS BIRIYANI MASALA MIX 50G',
        225,
        'https://essstr.blob.core.windows.net/essimg/350x/Small/Pic120297.jpg'
    ),
    (
        'Keells Black Currants 100g',
        'KEELLS BLACK CURRANTS 100G',
        968,
        'https://essstr.blob.core.windows.net/essimg/350x/Small/Pic118650.jpg'
    ),
    (
        'Keells Bopf Tea Bag 25S 50g',
        'KEELLS BOPF TEA BAG 25S 50G',
        268,
        'https://essstr.blob.core.windows.net/essimg/350x/Small/Pic114976.jpg'
    ),
    (
        'Keells Bopf Tea Bag 50S 100g',
        'KEELLS BOPF TEA BAG 50S 100G',
        514,
        'https://essstr.blob.core.windows.net/essimg/350x/Small/Pic114977.jpg'
    ),
    (
        'Keells Bopf Tea Leaves 100g',
        'KEELLS BOPF TEA LEAVES 100G',
        260,
        'https://essstr.blob.core.windows.net/essimg/350x/Small/Pic114973.jpg'
    ),
    (
        'Keells Bopf Tea Leaves 200g',
        'KEELLS BOPF TEA LEAVES 200G',
        500,
        'https://essstr.blob.core.windows.net/essimg/350x/Small/Pic114974.jpg'
    ),
    (
        'Keells Bopf Tea Leaves 400g',
        'KEELLS BOPF TEA LEAVES 400G',
        925,
        'https://essstr.blob.core.windows.net/essimg/350x/Small/Pic114975.jpg'
    ),
    (
        'Keells Bot/Dri Water 1.5L',
        'KEELLS BOT/DRI WATER 1.5L',
        142,
        'https://essstr.blob.core.windows.net/essimg/350x/Small/Pic110860.jpg'
    ),
    (
        'Keells Bot/Dri Water 500ml',
        'KEELLS BOT/DRI WATER 500ML',
        72,
        'https://essstr.blob.core.windows.net/essimg/350x/Small/Pic110859.jpg'
    ),
    (
        'Keells Brown Sugar Sachet 25S 150g',
        'KEELLS BROWN SUGAR SACHET 25S 150G',
        460,
        'https://essstr.blob.core.windows.net/essimg/350x/Small/Pic115559.jpg'
    ),
    (
        'Keells Cake Flour 1kg',
        'KEELLS CAKE FLOUR 1KG',
        410,
        'https://essstr.blob.core.windows.net/essimg/350x/Small/Pic118034.jpg'
    ),
    (
        'Keells Car Air Freshener 5g',
        'KEELLS CAR AIR FRESHENER 5G',
        600,
        'https://essstr.blob.core.windows.net/essimg/350x/Small/Pic118234.jpg'
    ),
    (
        'Keells Car Interior Liquid Spray 300ml',
        'KEELLS CAR INTERIOR LIQUID SPRAY 300ML',
        304,
        'https://essstr.blob.core.windows.net/essimg/350x/Small/Pic119652.jpg'
    ),
    (
        'Keells Car Wash 500ml',
        'KEELLS CAR WASH 500ML',
        410,
        'https://essstr.blob.core.windows.net/essimg/350x/Small/Pic105771.jpg'
    ),
    (
        'Keells Chapathi 10 Pcs 350g',
        'KEELLS CHAPATHI 10 PCS 350G',
        485,
        'https://essstr.blob.core.windows.net/essimg/350x/Small/Pic119666.jpg'
    ),
    (
        'Keells Cheese Snacks 50g',
        'KEELLS CHEESE SNACKS 50G',
        179,
        'https://essstr.blob.core.windows.net/essimg/350x/Small/Pic118832.jpg'
    ),
    (
        'Keells Chicken Curry Mix 50g',
        'KEELLS CHICKEN CURRY MIX 50G',
        234,
        'https://essstr.blob.core.windows.net/essimg/350x/Small/Pic120296.jpg'
    ),
    (
        'Keells Chicken Flv Soup 60g',
        'KEELLS CHICKEN FLV SOUP 60G',
        226,
        'https://essstr.blob.core.windows.net/essimg/350x/Small/Pic120056.jpg'
    );

INSERT INTO
    "Supermarket" (
        "name",
        "contactNo",
        "logo",
        "address",
        "location",
        "supermarketmanagerId"
    )
VALUES (
        'Keels Super',
        '+94 11 2303500',
        'https://d36b0zw3cawrft.cloudfront.net/9lokzbu1a2tdd8zb1jx41mexxk70',
        '226 High Level Rd, Maharagama 10280',
        '6.8657635,79.8571086',
        5
    ),
    (
        'Glow Mark',
        '555-555-5555',
        'https://glomark.lk/build/images/logo.9155b058.png',
        '789 Oak St, Midtown',
        'Maharagama',
        6
    ),
    (
        'Arpico Super',
        '987-654-3210',
        'https://upload.wikimedia.org/wikipedia/en/0/03/Arpico_Supercenter_logo.png',
        '456 Elm St, Uptown',
        'Nugegoda',
        7
    ),
    (
        'Keels Super',
        '987-654-3210',
        'https://d36b0zw3cawrft.cloudfront.net/9lokzbu1a2tdd8zb1jx41mexxk70',
        'VV8W+834, Colombo - Batticaloa Hwy, Nugegoda',
        '6.8657635,79.8571086',
        8
    ),
    (
        'Arpico Super',
        '987-654-3210',
        'https://upload.wikimedia.org/wikipedia/en/0/03/Arpico_Supercenter_logo.png',
        '456 Elm St, Uptown',
        'Nugegoda',
        9
    ),
    (
        'Arpico Super',
        '987-654-3210',
        'https://upload.wikimedia.org/wikipedia/en/0/03/Arpico_Supercenter_logo.png',
        '456 Elm St, Uptown',
        'Nugegoda',
        10
    ),
    (
        'Arpico Super',
        '987-654-3210',
        'https://upload.wikimedia.org/wikipedia/en/0/03/Arpico_Supercenter_logo.png',
        '456 Elm St, Uptown',
        'Nugegoda',
        11
    ),
    (
        'Arpico Super',
        '987-654-3210',
        'https://upload.wikimedia.org/wikipedia/en/0/03/Arpico_Supercenter_logo.png',
        '456 Elm St, Uptown',
        'Nugegoda',
        12
    ),
    (
        'Arpico Super',
        '987-654-3210',
        'https://upload.wikimedia.org/wikipedia/en/0/03/Arpico_Supercenter_logo.png',
        '456 Elm St, Uptown',
        'Nugegoda',
        13
    ),
    (
        'GloMark',
        '555-555-5555',
        'https://glomark.lk/build/images/logo.9155b058.png',
        '789 Oak St, Midtown',
        'Maharagama',
        14
    );

INSERT INTO
    "SupermarketItem" (
        "productId",
        "price",
        "availableQuantity",
        "discount",
        "supermarketId"
    )
VALUES (1, 10.99, 100, 999.00, 1),
    (1, 5.49, 200, 1098.00, 2),
    (1, 15.25, 150, 2287.50, 3),
    (2, 7.99, 300, 2397.00, 1),
    (2, 12.75, 80, 1020.00, 2);