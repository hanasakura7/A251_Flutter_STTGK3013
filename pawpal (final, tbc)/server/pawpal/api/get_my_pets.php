<?php
header("Access-Control-Allow-Origin: *"); // running as chrome app

if ($_SERVER['REQUEST_METHOD'] == 'GET') {
	
	if (!isset($_GET['user_id'])) {
		$response = array('status' => 'failed', 'message' => 'Bad Request');
		sendJsonResponse($response);
		exit();
	}
	$userid = $_GET['user_id'];

	include 'dbconnect.php';
	
	$sqlgetpets = "SELECT * FROM `tbl_pets` WHERE `user_id` = '$userid'";
	$result = $conn->query($sqlgetpets);
	
	if ($result->num_rows > 0) {
		$petsdata = array();
		while ($row = $result->fetch_assoc()) {
			
			$images = json_decode($row['images'], true);
			$row['images'] = $images[0] ?? null;

			$petsdata[] = $row;
		}

		$response = array('status' => 'success', 'message' => 'Pets found!', 'data' => $petsdata);
		sendJsonResponse($response);
	} else {
		$response = array('status' => 'failed', 'message' => 'No pets found','data'=> null);
		sendJsonResponse($response);
	}
} else {
	$response = array('status' => 'failed', 'message' => 'Method Not Allowed');
	sendJsonResponse($response);
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>