<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json");
include 'dbconnect.php';

if (isset($_GET['userid'])) {
    $userid = $_GET['userid'];

    // Select donation details + the pet name from tbl_pets
    $sql = "SELECT tbl_donations.*, tbl_pets.pet_name 
            FROM `tbl_donations` 
            INNER JOIN `tbl_pets` ON tbl_donations.pet_id = tbl_pets.pet_id 
            WHERE tbl_donations.user_id = '$userid' 
            ORDER BY tbl_donations.donation_at DESC";

    $result = $conn->query($sql);

    if ($result) {
        if ($result->num_rows > 0) {
            $donations = array();
            while ($row = $result->fetch_assoc()) {
                $donations[] = $row;
            }
            sendJsonResponse(['status' => 'success', 'data' => $donations]);
        } else {
            sendJsonResponse(['status' => 'failed', 'message' => 'No history found']);
        }
    } else {
        // This helps identify if your table names or columns are spelled wrong
        sendJsonResponse(['status' => 'failed', 'message' => 'SQL Error: ' . $conn->error]);
    }
} else {
    sendJsonResponse(['status' => 'failed', 'message' => 'Unauthorized Access']);
}

function sendJsonResponse($sentArray) {
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>