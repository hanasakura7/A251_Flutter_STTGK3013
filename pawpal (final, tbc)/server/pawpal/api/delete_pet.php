<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

$petid = $_POST['petid'];

// 1. Get the image paths from the database first
$sqlgetimages = "SELECT `image_paths` FROM `tbl_pets` WHERE `pet_id` = '$petid'";
$result = $conn->query($sqlgetimages);

if ($result->num_rows > 0) {
    $row = $result->fetch_assoc();
    // Decode the JSON array of images
    $images = json_decode($row['image_paths'], true);
    
    if (is_array($images)) {
        foreach ($images as $imagePath) {
            $fullPath = "../" . $imagePath; 
            if (file_exists($fullPath)) {
                unlink($fullPath); // Delete the actual file
            }
        }
    }
}

$sqldelete = "DELETE FROM `tbl_pets` WHERE `pet_id` = '$petid'";

if ($conn->query($sqldelete) === TRUE) {
    $response = array('status' => 'success', 'data' => null);
    sendJsonResponse($response);
} else {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
}

function sendJsonResponse($sentArray) {
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>