<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json");

include 'dbconnect.php';

if ($_SERVER['REQUEST_METHOD'] != 'POST') {
    sendJsonResponse([
        'status' => 'failed',
        'message' => 'Method Not Allowed'
    ]);
    exit();
}

$petid = $_POST['petid'] ?? null;
$userid = $_POST['userid'] ?? null;
$motivation = $conn->real_escape_string($_POST['motivation'] ?? '');

if (empty($petid) || empty($userid)) {
    sendJsonResponse([
        'status' => 'failed',
        'message' => 'Missing required fields'
    ]);
    exit();
}

$sql = "INSERT INTO tbl_adoptions (pet_id, user_id, motivation)
        VALUES ('$petid', '$userid', '$motivation')";

if ($conn->query($sql) === TRUE) {
    sendJsonResponse([
        'status' => 'success',
        'message' => 'Adoption request sent'
    ]);
} else {
    sendJsonResponse([
        'status' => 'failed',
        'message' => 'Failed to submit request'
    ]);
}

function sendJsonResponse($sentArray)
{
    echo json_encode($sentArray);
}
?>
