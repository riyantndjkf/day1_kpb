
<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

$arr = null;

// Koneksi database
$conn = new mysqli(
    "localhost",
    "flutter_160423125",
    "ubaya",
    "flutter_160423125"
);

// Periksa koneksi
if ($conn->connect_error) {
    echo json_encode([
        "result" => "error",
        "message" => "unable to connect"
    ]);
    exit;
}

// Mengambil parameter dari Flutter / Postman
$user_id = $_POST['user_id'] ?? '';
$user_password = $_POST['user_password'] ?? '';

// Query untuk memeriksa login
$sql = "SELECT * FROM master_user
        WHERE user_id = ? AND user_password = ?";

$stmt = $conn->prepare($sql);

$stmt->bind_param("ss", $user_id, $user_password);

$stmt->execute();

$result = $stmt->get_result();

if ($result->num_rows > 0) {
    $r = mysqli_fetch_assoc($result);

    $arr = [
        "result" => "success",
        "user_name" => $r['user_name']
    ];
} else {
    $arr = [
        "result" => "error",
        "message" => "Incorrect user or password"
    ];
}

echo json_encode($arr);

$stmt->close();
$conn->close();
?>
