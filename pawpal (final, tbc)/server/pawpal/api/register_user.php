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
$sqlcheck = "SELECT * FROM `tbl_users` WHERE `email` = '$email'";
$resultcheck = $conn->query($sqlcheck);

if ($resultcheck->num_rows > 0) {
    $response = array('status' => 'failed', 'message' => 'Email already exists');
    sendJsonResponse($response);
} else {
    // 3. Register the user
    $sqlinsert = "INSERT INTO `tbl_users` (`name`, `email`, `password`, `phone`) 
                  VALUES ('$name', '$email', '$hashed_password', '$phone')";
    
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