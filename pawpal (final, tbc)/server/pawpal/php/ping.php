<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json");

// This simple response tells Flutter the server is alive
echo json_encode([
    "status" => "success",
    "message" => "Server is reachable!",
    "timestamp" => date("Y-m-d H:i:s")
]);
?>