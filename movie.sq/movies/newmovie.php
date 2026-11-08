<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

// Pakai koneksi yang sama dengan movielist.php
mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT);

try {
    $conn = new mysqli(
    "localhost",
    "flutter_160423125",
    "ubaya",
    "flutter_160423125"
);
    $conn->set_charset("utf8mb4");

    // Parameter dari Flutter Week 10 (halaman 21)
    $title = trim($_POST['title'] ?? '');
    $overview = trim($_POST['overview'] ?? '');
    $runtimeInput = trim($_POST['runtime'] ?? '');
    $release_date = trim($_POST['release_date'] ?? '');
    $homepage = trim($_POST['homepage'] ?? '');
    $url = trim($_POST['url'] ?? '');

    // Validasi tambahan supaya input tidak hanya dicek dari Flutter
    if ($title === '') {
        echo json_encode(['result' => 'fail', 'message' => 'Judul harus diisi']);
        exit;
    }
    if (strlen($overview) < 20) {
        echo json_encode(['result' => 'fail', 'message' => 'Overview minimal 20 karakter']);
        exit;
    }
    if (!ctype_digit($runtimeInput) || (int)$runtimeInput <= 0) {
        echo json_encode(['result' => 'fail', 'message' => 'Runtime harus angka positif']);
        exit;
    }
    $tanggal = DateTimeImmutable::createFromFormat('!Y-m-d', $release_date);
    if ($tanggal === false || $tanggal->format('Y-m-d') !== $release_date) {
        echo json_encode(['result' => 'fail', 'message' => 'Release Date harus YYYY-MM-DD']);
        exit;
    }
    if (!filter_var($homepage, FILTER_VALIDATE_URL) ||
        !in_array(strtolower(parse_url($homepage, PHP_URL_SCHEME) ?? ''), ['http', 'https'], true)) {
        echo json_encode(['result' => 'fail', 'message' => 'Homepage tidak valid']);
        exit;
    }
    if (!filter_var($url, FILTER_VALIDATE_URL) ||
        !in_array(strtolower(parse_url($url, PHP_URL_SCHEME) ?? ''), ['http', 'https'], true)) {
        echo json_encode(['result' => 'fail', 'message' => 'URL poster tidak valid']);
        exit;
    }

    $runtime = (int)$runtimeInput;

    // Query INSERT sesuai PPT Week 10 halaman 10
    $sql = "INSERT INTO movie
            (title, overview, runtime, release_date, homepage, url_poster)
            VALUES (?, ?, ?, ?, ?, ?)";

    $stmt = $conn->prepare($sql);
    $stmt->bind_param("ssisss", $title, $overview, $runtime, $release_date, $homepage, $url);
    $stmt->execute();

    if ($stmt->affected_rows > 0) {
        $arr = ["result" => "success", "id" => $conn->insert_id];
    } else {
        $arr = ["result" => "fail", "message" => "Gagal menambah film"];
    }
    echo json_encode($arr);

    $stmt->close();
    $conn->close();
} catch (Throwable $e) {
    // Jangan tampilkan detail koneksi/database kepada pengakses API
    echo json_encode(["result" => "fail", "message" => "Kesalahan database atau struktur tabel"]);
}
