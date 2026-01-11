<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json");

// 1. Database Connection
include 'dbconnect.php';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    // 2. Validate Input
    if (!isset($_POST['email']) || !isset($_POST['password'])) {
        echo json_encode(['status' => 'failed', 'message' => 'Missing email or password']);
        exit();
    }

    $email = trim($_POST['email']);
    $password = trim($_POST['password']);
    $hashedpassword = sha1($password);

    // 3. Attempt Login
    // Use TRIM() inside the SQL and 'LIKE' for a more flexible match
    $sqllogin = "SELECT * FROM `tbl_users` WHERE TRIM(`user_email`) LIKE '$email' AND `user_password` = '$hashedpassword'";
    $result = $conn->query($sqllogin);
    
    if ($result && $result->num_rows > 0) {
        $user = $result->fetch_assoc();
        // Remove password from response for security
        unset($user['user_password']); 
        
        echo json_encode([
            'status' => 'success', 
            'message' => 'Login successful', 
            'data' => $user
        ]);
    } else {
        // 4. If login fails, check why (The Debugger)
        $checkEmail = "SELECT * FROM `tbl_users` WHERE `user_email` LIKE '%$email%'";
        $emailResult = $conn->query($checkEmail);
        
        if ($emailResult && $emailResult->num_rows > 0) {
            $msg = "Password mismatch. Check if your registration used sha1.";
        } else {
            $msg = "Email not found: " . $email;
        }

        echo json_encode([
            'status' => 'failed', 
            'message' => $msg
        ]);
    }
} else {
    echo json_encode(['status' => 'failed', 'message' => 'Method Not Allowed']);
}
?>