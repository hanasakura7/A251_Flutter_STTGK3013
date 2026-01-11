<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'message' => 'No data received');
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

// 1. Map the POST data from Flutter to variables
$name = $_POST['name'];
$email = $_POST['email'];
$phone = $_POST['phone'];
$password = $_POST['password'];
$hashed_password = sha1($password); // Must match the hashing in login_user.php

// 2. Check if the user already exists
$sqlcheck = "SELECT * FROM `tbl_users` WHERE `user_email` = '$email'";
$resultcheck = $conn->query($sqlcheck);

if ($resultcheck->num_rows > 0) {
    $response = array('status' => 'failed', 'message' => 'Email already exists');
    sendJsonResponse($response);
} else {
    // 3. The INSERT query using the new column names (user_name, user_email, etc.)
    // We also set user_credit to 0 explicitly to prevent Flutter model crashes
    $sqlinsert = "INSERT INTO `tbl_users` (`user_name`, `user_email`, `user_password`, `user_phone`, `user_credit`) 
                  VALUES ('$name', '$email', '$hashed_password', '$phone', 0)";
    
    if ($conn->query($sqlinsert) === TRUE) {
        $response = array('status' => 'success', 'message' => 'Registration successful');
        sendJsonResponse($response);
    } else {
        $response = array('status' => 'failed', 'message' => 'Registration failed: ' . $conn->error);
        sendJsonResponse($response);
    }
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>