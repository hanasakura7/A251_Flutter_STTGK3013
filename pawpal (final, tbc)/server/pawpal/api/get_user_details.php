<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json");

include 'dbconnect.php';

if (!isset($_GET['userid'])) {
    echo json_encode(['status' => false, 'message' => 'Missing user ID']);
    exit();
}

$userid = intval($_GET['userid']);

$sql = "SELECT user_id, email, name, phone, password, reg_date, profile_image
        FROM tbl_users WHERE user_id = '$userid' LIMIT 1";

$result = $conn->query($sql);

if ($result && $result->num_rows > 0) {
    $user = $result->fetch_assoc();
    echo json_encode([
        'status' => true,
        'message' => 'User found',
        'data' => [$user]
    ]);
} else {
    echo json_encode([
        'status' => false,
        'message' => 'User not found'
    ]);
}
?>
