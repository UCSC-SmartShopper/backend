INSERT INTO
    "User" (
        "name",
        "email",
        "password",
        "number",
        "profilePic",
        "role",
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
        'Admin',
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
        'Consumer',
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
        'Driver',
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
        'Courier Company Manager',
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
        'Supermarket Manager',
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
        'Supermarket Manager',
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
        'Supermarket Manager',
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
        'Supermarket Manager',
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
        'Supermarket Manager',
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
        'Supermarket Manager',
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
        'Supermarket Manager',
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
        'Supermarket Manager',
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
        'Supermarket Manager',
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
        'Supermarket Manager',
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
        'Consumer',
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
        'Consumer',
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
        'Consumer',
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
    "NonVerifyUser" (
        "contactNo",
        "name",
        "OTP"
    )
VALUES (
        '1234567890',
        'user1',
        '123456'
    ),
    (
        '0987654321',
        'user2',
        '654321'
    ),
    (
        '1122334455',
        'user3',
        '112233'
    ),
    (
        '2233445566',
        'user4',
        '334455'
    ),
    (
        '3344556677',
        'user5',
        '556677'
    ),
    (
        '4455667788',
        'user6',
        '778899'
    );