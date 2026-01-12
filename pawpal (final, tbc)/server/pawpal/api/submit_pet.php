// tak complete
<?php
header("Access-Control-Allow-Origin: *"); // running as chrome app
include 'dbconnect.php';

if ($_SERVER['REQUEST_METHOD'] != 'POST') {
    http_response_code(405);
    echo json_encode(array('error' => 'Method not allowed'));
    exit();
}   

$user_id = $_POST['user_id'];
$pet_name = $_POST['pet_name'];
$pet_type = $_POST['pet_type'];
$category = $_POST['category'];
$description = addslashes($_POST['description']);
$lat = $_POST['lat'];
$lng = $_POST['lng'];
$imageArray  = json_decode($_POST['image_paths'] ?? "[]", true);

$imagePaths = []; // to store saved filenames

try {
    // Loop through each image and save
    foreach ($imageArray as $index => $encodedImage) {
        $decodedImage = base64_decode($encodedImage);
        // Generate unique filename using timestamp + index
        $filename = "pet_" . time() . "_$index.png";
        $filepath = __DIR__ . "/uploads/" . $filename;
        file_put_contents($filepath, $decodedImage);
        $imagePaths[] = $filename; // store filename for DB
    }

    // Convert image paths array to JSON for DB
    $imagesJson = json_encode($imagePaths);

    // Insert into database
    $sql = "INSERT INTO `tbl_pets`(`user_id`, `pet_name`, `pet_type`, `category`, `description`, `lat`, `lng`, `image_paths`) 
            VALUES('$user_id', '$pet_name', '$pet_type', '$category', '$description', '$lat', '$lng', '$imagesJson')";

    if ($conn->query($sql) === TRUE) {
        $response = array('status' => 'success', 'message' => 'Pet submitted successfully');
        sendJsonResponse($response);
    } else {
        $response = array('status' => 'failed', 'message' => 'Error submitting pet: ' . $conn->error);
        sendJsonResponse($response);
    }
} catch (Exception $e) {
    $response = array('status' => 'failed', 'message' => 'Exception: ' . $e->getMessage());
    sendJsonResponse($response);
}  

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>