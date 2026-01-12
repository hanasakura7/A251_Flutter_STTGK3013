<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json");

include 'dbconnect.php';

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    echo json_encode(['status' => 'failed', 'message' => 'Invalid request method']);
    exit();
}

// 1. Get POST data
$user_id     = $_POST['user_id'] ?? '';
$pet_name    = $_POST['pet_name'] ?? '';
$pet_type    = $_POST['pet_type'] ?? '';
$category    = $_POST['category'] ?? '';
$description = $_POST['description'] ?? '';
$lat         = $_POST['lat'] ?? '';
$lng         = $_POST['lng'] ?? '';
$age         = $_POST['age'] ?? '';
$gender      = $_POST['gender'] ?? '';
$health      = $_POST['health'] ?? '';

// 2. Validation (Check text fields and ensure files were uploaded)
if (empty($user_id) || empty($pet_name) || !isset($_FILES['images'])) {
    echo json_encode(['status' => 'failed', 'message' => 'Required data missing']);
    exit();
}

$imagePaths = [];
$uploadDir = "uploads/pets/"; 

if (!is_dir($uploadDir)) {
    mkdir($uploadDir, 0777, true);
}

// 3. Handle Binary File Uploads (Multipart)
foreach ($_FILES['images']['tmp_name'] as $index => $tmpName) {
    if (!empty($tmpName)) {
        $filename = "pet_" . time() . "_$index.jpg";
        $targetPath = $uploadDir . $filename;
        
        if (move_uploaded_file($tmpName, $targetPath)) {
            $imagePaths[] = $targetPath;
        }
    }
}

if (count($imagePaths) == 0) {
    echo json_encode(['status' => 'failed', 'message' => 'No images uploaded']);
    exit();
}

// 4. Insert into database
$imagePathsDB = json_encode($imagePaths);

$sql = "INSERT INTO tbl_pets 
(user_id, pet_name, pet_type, category, description, lat, lng, image_paths, age, gender, health)
VALUES
('$user_id', '$pet_name', '$pet_type', '$category', '$description', '$lat', '$lng', '$imagePathsDB', '$age', '$gender', '$health')";

if ($conn->query($sql)) {
    echo json_encode(['status' => 'success', 'message' => 'Pet submitted successfully']);
} else {
    echo json_encode(['status' => 'failed', 'message' => 'Database error: ' . $conn->error]);
}
?>