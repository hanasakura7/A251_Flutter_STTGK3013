<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json");

include 'dbconnect.php';

$userid = $_GET['user_id'] ?? '';
$sql = "SELECT a.motivation, a.status as adoption_status, a.created_at, 
               p.pet_name, p.image_paths, p.pet_type
        FROM tbl_adoptions a
        JOIN tbl_pets p ON a.pet_id = p.pet_id
        WHERE a.user_id = '$userid'
        ORDER BY a.created_at DESC";

$result = $conn->query($sql);

if ($result && $result->num_rows > 0) {
    $data = [];
    while ($row = $result->fetch_assoc()) {
        // Decode image paths so Flutter gets a list
        $row['image_paths'] = json_decode($row['image_paths'], true);
        $data[] = $row;
    }
    echo json_encode(['status' => 'success', 'data' => $data]);
} else {
    echo json_encode(['status' => 'failed', 'message' => 'No adoption history found']);
}
?>