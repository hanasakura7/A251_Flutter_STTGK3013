//tengok balik this part
<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json");

include 'dbconnect.php';

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    echo json_encode([
        'status' => 'failed',
        'message' => 'Invalid request method'
    ]);
    exit();
}

/* =========================
   1. Get POST data
========================= */
$user_id     = $_POST['user_id'] ?? '';
$pet_name    = $_POST['pet_name'] ?? '';
$pet_type    = $_POST['pet_type'] ?? '';
$category    = $_POST['category'] ?? '';
$description = $_POST['description'] ?? '';
$lat         = $_POST['lat'] ?? '';
$lng         = $_POST['lng'] ?? '';
$imagesJson  = $_POST['images'] ?? '';

/* =========================
   2. Basic validation
========================= */
if (
    empty($user_id) ||
    empty($pet_name) ||
    empty($pet_type) ||
    empty($category) ||
    empty($description) ||
    empty($lat) ||
    empty($lng) ||
    empty($imagesJson)
) {
    echo json_encode([
        'status' => 'failed',
        'message' => 'Please fill in all required fields'
    ]);
    exit();
}

/* =========================
   3. Decode Base64 images
========================= */
$images = json_decode($imagesJson, true);
$imagePaths = [];

if (!is_array($images) || count($images) == 0) {
    echo json_encode([
        'status' => 'failed',
        'message' => 'Invalid image data'
    ]);
    exit();
}

foreach ($images as $index => $base64Image) {
    $decodedImage = base64_decode($base64Image);

    if ($decodedImage === false) {
        continue;
    }

    $filename = "pet_" . time() . "_$index.jpg";
    $path = "uploads/" . $filename;

    file_put_contents($path, $decodedImage);
    $imagePaths[] = $path;
}

/* =========================
   4. Insert into database
========================= */
$imagePathsDB = json_encode($imagePaths);

$sql = "INSERT INTO tbl_pets 
(user_id, pet_name, pet_type, category, description, lat, lng, image_paths, created_at)
VALUES
('$user_id', '$pet_name', '$pet_type', '$category', '$description', '$lat', '$lng', '$imagePathsDB', NOW())";

if ($conn->query($sql)) {
    echo json_encode([
        'status' => 'success',
        'message' => 'Pet submitted successfully'
    ]);
} else {
    echo json_encode([
        'status' => 'failed',
        'message' => 'Database error'
    ]);
}
?>
