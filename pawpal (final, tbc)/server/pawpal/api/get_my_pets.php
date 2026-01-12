
<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json");
error_reporting(0);

include 'dbconnect.php';

if ($_SERVER['REQUEST_METHOD'] !== 'GET') {
    echo json_encode(['status' => 'failed', 'message' => 'Method Not Allowed']);
    exit();
}

$userid = $_GET['user_id'] ?? '';

$sql = "SELECT * FROM `tbl_pets` WHERE `user_id` = '$userid' ORDER BY `created_at` DESC";
$result = $conn->query($sql);

$petsdata = [];

if ($result && $result->num_rows > 0) {
    while ($row = $result->fetch_assoc()) {
        $images = json_decode($row['image_paths'], true);
        if (!is_array($images)) $images = []; // ensure array
        $row['image_paths'] = $images; // return full array, Flutter can pick [0] if needed
        $petsdata[] = $row;
    }
    echo json_encode(['status' => 'success', 'message' => 'Pets found!', 'data' => $petsdata]);
} else {
    echo json_encode(['status' => 'failed', 'message' => 'No pets found', 'data' => []]);
}
?>
