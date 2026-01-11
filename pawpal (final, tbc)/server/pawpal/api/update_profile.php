<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json");

include 'dbconnect.php';

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    echo json_encode(['status' => false, 'message' => 'Method Not Allowed']);
    exit();
}

// Get POST data
$user_id = intval($_POST['user_id'] ?? 0);
$name = $conn->real_escape_string($_POST['user_name'] ?? '');
$phone = $conn->real_escape_string($_POST['user_phone'] ?? '');
$profileImage = $_POST['profile_image'] ?? null;

if (!$user_id || !$name || !$phone) {
    echo json_encode(['status' => false, 'message' => 'Missing required fields']);
    exit();
}

// Handle profile image
$imageName = null;
if (!empty($profileImage)) {
    $imageData = base64_decode($profileImage);
    if ($imageData === false) {
        echo json_encode(['status' => false, 'message' => 'Invalid image data']);
        exit();
    }

    $folder = __DIR__ . "/../assets/profiles/";
    if (!file_exists($folder)) {
        mkdir($folder, 0777, true);
    }

    $imageName = "profile_{$user_id}.jpg";
    $imagePath = $folder . $imageName;

    if (file_put_contents($imagePath, $imageData) === false) {
        echo json_encode(['status' => false, 'message' => 'Failed to save image']);
        exit();
    }
}

// Build SQL update
$updateFields = "user_name='$name', user_phone='$phone'";
if ($imageName) {
    $updateFields .= ", profile_image='$imageName'";
}

$sql = "UPDATE tbl_users SET $updateFields WHERE user_id='$user_id'";

if ($conn->query($sql)) {
    echo json_encode([
        'status' => true,
        'message' => 'Profile updated successfully',
        'profile_image' => $imageName ? "assets/profiles/$imageName" : null
    ]);
} else {
    echo json_encode([
        'status' => false,
        'message' => 'Database update failed'
    ]);
}
?>
