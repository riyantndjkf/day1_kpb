
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

if ($conn->connect_error) {
    echo json_encode([
        "result" => "error",
        "message" => "unable to connect"
    ]);
    exit;
}

// Mengambil parameter pencarian
$cari = "%" . ($_POST['cari'] ?? '') . "%";

// Query berdasarkan judul film
$sql = "SELECT * FROM movie WHERE title LIKE ?";

$stmt = $conn->prepare($sql);
$stmt->bind_param("s", $cari);
$stmt->execute();

$result = $stmt->get_result();
$data = [];

if ($result->num_rows > 0) {
    while ($r = mysqli_fetch_assoc($result)) {
        array_push($data, $r);
    }

    $arr = [
        "result" => "success",
        "data" => $data
    ];
} else {
    $arr = [
        "result" => "error",
        "message" => "tidak ada data"
    ];
}

echo json_encode($arr);

$stmt->close();
$conn->close();
?>
