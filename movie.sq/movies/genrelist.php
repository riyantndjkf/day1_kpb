<?php
// Week 11 halaman 20: list genre yang BELUM dimiliki movie.
header('Access-Control-Allow-Origin: *');
header('Content-Type: application/json; charset=UTF-8');
mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT);

try {
    $conn = new mysqli('localhost', 'flutter_160423125', 'ubaya', 'flutter_160423125');
    $conn->set_charset('utf8mb4');
    $movie_id = filter_input(INPUT_POST, 'movie_id', FILTER_VALIDATE_INT);
    if (!$movie_id || $movie_id <= 0) {
        echo json_encode(['result' => 'fail', 'message' => 'movie_id tidak valid']);
        exit;
    }
    $sql = 'SELECT genre_id, genre_name, genre_name AS label, genre_id AS value
            FROM genre
            WHERE genre_id NOT IN (
                SELECT genre_id FROM movie_genres WHERE movie_id = ?
            )
            ORDER BY genre_name';
    $stmt = $conn->prepare($sql);
    $stmt->bind_param('i', $movie_id);
    $stmt->execute();
    $result = $stmt->get_result();
    $data = [];
    while ($row = $result->fetch_assoc()) {
        $data[] = $row;
    }
    echo json_encode(['result' => 'success', 'data' => $data]);
    $stmt->close();
    $conn->close();
} catch (Throwable $e) {
    echo json_encode(['result' => 'fail', 'message' => 'Gagal memuat daftar genre']);
}
