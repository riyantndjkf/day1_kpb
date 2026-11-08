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

    $sql = 'DELETE FROM movie_genres WHERE movie_id = ? AND genre_id = ?';
    $stmt = $conn->prepare($sql);
    $stmt->bind_param('ii', $movie_id, $genre_id);
    $stmt->execute();

    $arr = $stmt->affected_rows > 0
        ? ['result' => 'success']
        : ['result' => 'fail', 'message' => 'Genre tersebut tidak ditemukan pada film'];
    echo json_encode($arr);
    $stmt->close();
    $conn->close();
} catch (Throwable $e) {
    echo json_encode(['result' => 'fail', 'message' => 'Gagal menghapus genre dari film']);
}
