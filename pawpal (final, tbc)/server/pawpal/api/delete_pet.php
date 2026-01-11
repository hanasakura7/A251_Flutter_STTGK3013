<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

$petid = $_POST['petid'];

// 1. First, get the image names or ID to delete files from the 'uploads' folder
// Assuming your naming convention is pet_ID_index.png
$files = glob("../uploads/pet_" . $petid . "_*"); // Find all images related to this pet
foreach($files as $file){
    if(is_file($file)) {
        unlink($file); // Delete the file from the folder
    }
}

// 2. Delete the record from the database
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