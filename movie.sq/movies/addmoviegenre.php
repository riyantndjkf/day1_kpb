<?php
header('Access-Control-Allow-Origin: *');
header('Content-Type: application/json; charset=UTF-8');
mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT);

try {
    $conn = new mysqli('localhost', 'flutter_160423125', 'ubaya', 'flutter_160423125');
    $conn->set_charset('utf8mb4');

    $movie_id = filter_input(INPUT_POST, 'movie_id', FILTER_VALIDATE_INT);
    $genre_id = filter_input(INPUT_POST, 'genre_id', FILTER_VALIDATE_INT);
    if (!$movie_id || $movie_id <= 0 || !$genre_id || $genre_id <= 0) {
        echo json_encode(['result' => 'fail', 'message' => 'movie_id/genre_id tidak valid']);
        exit;
    }

    // Prepared statement, kedua field ID bertipe integer (ii, bukan dd).
    $sql = 'INSERT INTO movie_genres (movie_id, genre_id) VALUES (?, ?)';
    $stmt = $conn->prepare($sql);
    $stmt->bind_param('ii', $movie_id, $genre_id);
    $stmt->execute();

    $arr = $stmt->affected_rows > 0
        ? ['result' => 'success', 'id' => $conn->insert_id]
        : ['result' => 'fail', 'message' => 'Genre tidak berhasil ditambahkan'];
    echo json_encode($arr);
    $stmt->close();
    $conn->close();
} catch (Throwable $e) {
    echo json_encode(['result' => 'fail', 'message' => 'Gagal tambah genre. Cek relasi atau duplikasi']);
}
