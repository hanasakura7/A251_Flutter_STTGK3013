<?php
    header('Access-Control-Allow-Origin: *');
    include 'dbconnect.php';

    if ($_SERVER['REQUEST_METHOD'] != 'POST') {
        http_response_code(405);
        echo json_encode(array('error' => 'Method Not Allowed'));
        exit();
    }

    if (!isset($_POST['name']) || !isset($_POST['email']) || !isset($_POST['password']) || !isset($_POST['phone'])) {
        http_response_code(400);
        echo json_encode(array('error' => 'Bad Request'));
        exit();
    }

    $name = $_POST['name'];
    $email = $_POST['email'];   
    $password = $_POST['password'];
    $phone = $_POST['phone'];

    $hashed_password = sha1($password);

    //checkk for email already exists (blocking mechanism)
    $sqlcheckemail = "SELECT * FROM `tbl_users` WHERE `email` = '$email'";
    $result = $conn->query($sqlcheckemail);

    if ($result->num_rows > 0) { 
        $response = array(
            'status' => 'failed',
            'message' => 'Email already exists'
        );
        sendJsonResponse($response);
        exit();
    }

    $sql_register = "INSERT INTO `tbl_users`(`name`, `email`, `password`, `phone`) VALUES ('$name','$email','$hashed_password','$phone')";


    try {
        if ($conn->query($sql_register) === TRUE) {
            $response = array(
                'status' => 'success',
                'message' => 'User registered successfully'
            );
            sendJsonResponse($response);
        } else {
            $response = array(
                'status' => 'failed',
                'message' => 'Registration failed: '
            );
            sendJsonResponse($response);
        }
    } catch (Exception $e) {
        $response = array(
            'status' => 'error',
            'message' => 'Error'
        );
        sendJsonResponse($response);
    }

    //function to send json response
    function sendJsonResponse($sentArray) {
        header('Content-Type: application/json');
        echo json_encode($sentArray);
    }

    $conn->close();
?>    