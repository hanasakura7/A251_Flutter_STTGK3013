<?php
	header("Access-Control-Allow-Origin: *");
	include 'dbconnect.php';

	if ($_SERVER['REQUEST_METHOD'] != 'POST') {
		http_response_code(405);
		echo json_encode(array('error' => 'Method not allowed'));
		exit();
	}

	if (!isset($_POST['email']) || !isset($_POST['password']) || !isset($_POST['name']) || !isset($_POST['phone'])) {
		http_response_code(400);
		echo json_encode(array('error' => 'Bad Request'));
		exit();
	}

    $name = $_POST['name'];
    $phone = $_POST['phone'];
	$email = $_POST['email'];
	$password = $_POST['password'];
	$hashedpassword = sha1($password);

    //check kalau email dah wujud
	$sqlcheckmail = "SELECT * FROM `tbl_users` WHERE `email` = '$email'";
	$result = $conn->query($sqlcheckmail);
	if ($result -> num_rows > 0) {
		$response = array('status' => 'failed', 'message' => 'Email already registered');
		sendJsonResponse($response);
		exit();
	}
	
    //insert new user into database
	$sqlregister = "INSERT INTO `tbl_users`(`name`, `email`, `password`, `phone`) VALUES ('$name','$email','$hashedpassword','$phone')";
	try {
		if ($conn->query($sqlregister) === TRUE) {
			$response = array('status' => 'success', 'message' => 'User Registered successfully!');
			sendJsonResponse($response);
		} else {
			$response = array('status' => 'failed', 'message' => 'User Registration failed');
			sendJsonResponse($response);
		}
	} catch (Exception $e) {
		$response = array('status' => 'failed', 'message' => 'Error occured: ' . $e->getMessage());
		sendJsonResponse($response);
	}

function sendJsonResponse($sentArray) {
	header('Content-Type: application/json');
	echo json_encode($sentArray);
}

?>