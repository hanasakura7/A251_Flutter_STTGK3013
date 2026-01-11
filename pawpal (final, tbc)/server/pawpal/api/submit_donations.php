<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json");
include 'dbconnect.php';

$userid = $_POST['userid'];
$petid = $_POST['petid'];
$type = $_POST['type'];
$amount = $_POST['amount'];
$description = $conn->real_escape_string($_POST['description']);

// SQL matches requirements: Insert donation record into tbl_donations
$sql = "INSERT INTO tbl_donations (user_id, pet_id, donation_type, amount, description) 
        VALUES ('$userid', '$petid', '$type', '$amount', '$description')";

if ($conn->query($sql) === TRUE) {
    echo json_encode(['status' => 'success']);
} else {
    echo json_encode(['status' => 'failed']);
}
?>