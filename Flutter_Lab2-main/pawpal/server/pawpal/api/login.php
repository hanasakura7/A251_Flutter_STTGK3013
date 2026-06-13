<?php
    header('Access-Control-Allow-Origin: *');
    include 'dbconnect.php';

    if ($_SERVER['REQUEST_METHOD'] == 'POST') {
        if (!isset($_POST['email']) || !isset($_POST['password'])) {
            $response = array('status' => 'failed', 'message' => 'Bad Request');
            sendJsonResponse($response);
            exit();
        }

    $email = $_POST['email'];   
    $password = $_POST['password'];
    $hashed_password = sha1($password);
    $sql_login = "SELECT * FROM `tbl_users` WHERE `email` = '$email' AND `password` = '$hashed_password'";
    $result = $conn->query($sql_login);

    if ($result->num_rows > 0) {
        $row = $result->fetch_assoc();
        $response = array(
            'status' => 'success',
            'message' => 'Login successful',
            'data' => $row
        );
        sendJsonResponse($response);
    } else {
        $response = array(
            'status' => 'failed',
            'message' => 'Invalid email or password',
            'data' => null
        );
        sendJsonResponse($response);
    }
}
    function sendJsonResponse($response) {
        header('Content-Type: application/json');
        echo json_encode($response);
    }
?>