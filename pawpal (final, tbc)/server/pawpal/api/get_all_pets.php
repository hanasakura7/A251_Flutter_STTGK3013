<?php
header("Access-Control-Allow-Origin: *"); 
header("Content-Type: application/json");

// REMOVED 'isset($_GET['userid'])' to allow public access
if ($_SERVER['REQUEST_METHOD'] == 'GET') {
    include 'dbconnect.php';
    
    // Check if userid exists, otherwise set to null
    $userid = isset($_GET['userid']) ? $_GET['userid'] : null;
    $search = isset($_GET['search']) ? $conn->real_escape_string(trim($_GET['search'])) : '';
    $type = isset($_GET['type']) ? $conn->real_escape_string(trim($_GET['type'])) : 'All';

    $query = "SELECT 
            p.pet_id,
            p.user_id,
            p.pet_name,
            p.pet_type,
            p.category,
            p.description,
            p.image_paths,
            p.age,
            p.gender,
            u.name as user_name 
        FROM tbl_pets p
        JOIN tbl_users u ON p.user_id = u.user_id";

    $conditions = [];
    if (!empty($search)) {
        $conditions[] = "p.pet_name LIKE '%$search%'";
    }
    if ($type !== 'All') {
        $conditions[] = "p.pet_type = '$type'";
    }

    if (count($conditions) > 0) {
        $query .= " WHERE " . implode(' AND ', $conditions);
    }

    $query .= " ORDER BY p.pet_id DESC"; // Changed from created_at if that column doesn't exist

    $result = $conn->query($query);

    if ($result && $result->num_rows > 0) {
        $petsdata = array();
        while ($row = $result->fetch_assoc()) {
            $images = json_decode($row['image_paths'], true);
            $row['image_paths'] = is_array($images) ? $images : [];
            $petsdata[] = $row;
        }
        $response = array('status' => 'success', 'data' => $petsdata);
        sendJsonResponse($response);
    } else {
        $response = array('status' => 'failed', 'message' => 'No pets found', 'data' => null);
        sendJsonResponse($response);
    }
} else {
    $response = array('status' => 'failed', 'message' => 'Invalid Request');
    sendJsonResponse($response);
}

function sendJsonResponse($sentArray) {
    echo json_encode($sentArray);
}
?>