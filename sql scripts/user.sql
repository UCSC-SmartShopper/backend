-- Active: 1720773754283@@pg-157cd029-luravel-b97c.i.aivencloud.com@11213@defaultdb
INSERT INTO "User" (
    "name",
    "email",
    "password",
    "number",
    "profilePic",
    "userRole",
    "status",
    "creaedAt",
    "updatedAt",
    "deletedAt"
) VALUES
    ('John Doe', 'john.doe@example.com', 'password123', '1234567890', 'profile1.jpg', 'admin', 'active', '2024-01-01 10:00:00', '2024-01-01 10:00:00', NULL),
    ('Jane Smith', 'jane.smith@example.com', 'password456', '0987654321', 'profile2.jpg', 'user', 'active', '2024-01-02 11:00:00', '2024-01-02 11:00:00', NULL),
    ('Alice Johnson', 'alice.johnson@example.com', 'password789', '1122334455', 'profile3.jpg', 'user', 'inactive', '2024-01-03 12:00:00', '2024-01-03 12:00:00', NULL),
    ('Bob Brown', 'bob.brown@example.com', 'password321', '5566778899', 'profile4.jpg', 'moderator', 'active', '2024-01-04 13:00:00', '2024-01-04 13:00:00', NULL),
    ('Carol White', 'carol.white@example.com', 'password654', '6677889900', 'profile5.jpg', 'user', 'inactive', '2024-01-05 14:00:00', '2024-01-05 14:00:00', NULL);
