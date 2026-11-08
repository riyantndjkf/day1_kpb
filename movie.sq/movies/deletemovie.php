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

    // Nama parameter 'id' sama dengan detailmovie.php
    $id = filter_input(INPUT_POST, 'id', FILTER_VALIDATE_INT);
    if ($id === null || $id === false || $id <= 0) {
        echo json_encode(["result" => "fail", "message" => "Movie ID tidak valid"]);
        exit;
    }

    // PPT halaman 24 menulis 'movies', tetapi tabel asli kamu 'movie'
    $sql = "DELETE FROM movie WHERE movie_id = ?";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("i", $id);
    $stmt->execute();

    if ($stmt->affected_rows > 0) {
        $arr = ["result" => "success"];
    } else {
        $arr = ["result" => "fail", "message" => "Movie tidak ditemukan"];
    }
    echo json_encode($arr);

    $stmt->close();
    $conn->close();
} catch (mysqli_sql_exception $e) {
    // Film lama biasanya mempunyai relasi dalam movie_genres / movie_cast
    echo json_encode([
        "result" => "fail",
        "message" => "Film gagal dihapus. Bisa jadi masih memiliki data genre/cast terkait."
    ]);
} catch (Throwable $e) {
    echo json_encode(["result" => "fail", "message" => "Gagal memproses permintaan"]);
}
