<?php
error_reporting(0);
//include_once("dbconnect.php");
$petid = $_GET['pet_id'];
$email = $_GET['user_email']; //email
$phone = $_GET['user_phone']; 
$name = $_GET['user_name']; 
$credit = $_GET['user_credits']; 
$userid = $_GET['user_id'];

$api_key = '7fbeae84-ade9-4ed6-8f8d-86b201503a1e';
$collection_id = '1r1jbqs4';
$host = 'https://www.billplz-sandbox.com/api/v3/bills';


$data = array(
          'collection_id' => $collection_id,
          'email' => $email,
          'mobile' => $phone,
          'name' => $name,
          'amount' => $credit * 10, 
		  'description' => 'Payment for '.$userid,
          'callback_url' => "http://socstudentmusicforlife.com/pawpal/api/return_url",
          'redirect_url' => "http://socstudentmusicforlife.com/pawpal/api/payment_update.php?userid=$userid&email=$email&name=$name&phone=$phone&credit=$credit&userid=$userid" 
);


$process = curl_init($host );
curl_setopt($process, CURLOPT_HEADER, 0);
curl_setopt($process, CURLOPT_USERPWD, $api_key . ":");
curl_setopt($process, CURLOPT_TIMEOUT, 30);
curl_setopt($process, CURLOPT_RETURNTRANSFER, 1);
curl_setopt($process, CURLOPT_SSL_VERIFYHOST, 0);
curl_setopt($process, CURLOPT_SSL_VERIFYPEER, 0);
curl_setopt($process, CURLOPT_POSTFIELDS, http_build_query($data) ); 

$return = curl_exec($process);
curl_close($process);

$bill = json_decode($return, true);

echo "<pre>".print_r($bill, true)."</pre>";
header("Location: {$bill['url']}");
?>