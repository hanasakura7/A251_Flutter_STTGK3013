<?php
    $servername = "localhost";
    $username = "root";
    $password = "";
    $dbname = "myfuwudb";
    // create connection
    $conn = new mysqli($servername, $username, $password, $dbname);
    // create connection
    if ($conn->connect_error) {
        die("Connection failed: " . $conn->connect_error);
    }
?>