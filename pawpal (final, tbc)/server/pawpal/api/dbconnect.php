<?php
    $servername = "localhost";
    // Ensure there are no extra spaces inside the quotes
    $username = "musicbvk_hana";
    $password = "Hana07**"; 
    $dbname = "musicbvk_pawpal_db_hana";

    $conn = new mysqli($servername, $username, $password, $dbname);
    
    if ($conn->connect_error) {
        // This follows your assignment requirement for JSON responses [cite: 29]
        header('Content-Type: application/json');
        echo json_encode(array('status' => 'failed', 'message' => 'Connection failed'));
        exit();
    }
?>