<?php
// Week 11 halaman 15: update data movie.
header('Access-Control-Allow-Origin: *');
header('Content-Type: application/json; charset=UTF-8');
mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT);

try {
    $conn = new mysqli('localhost', 'flutter_160423125', 'ubaya', 'flutter_160423125');
    $conn->set_charset('utf8mb4');

    $movie_id = filter_input(INPUT_POST, 'movie_id', FILTER_VALIDATE_INT);
    $title = trim($_POST['title'] ?? '');
    $overview = trim($_POST['overview'] ?? '');
    $runtime_raw = trim($_POST['runtime'] ?? '');
    $release_date = trim($_POST['release_date'] ?? '');
    $homepage = trim($_POST['homepage'] ?? '');
    $url = trim($_POST['url'] ?? '');

    $date = DateTimeImmutable::createFromFormat('!Y-m-d', $release_date);
    if (!$movie_id || $movie_id <= 0 || $title === '' || strlen($overview) < 20 ||
        !ctype_digit($runtime_raw) || (int)$runtime_raw <= 0 ||
        $date === false || $date->format('Y-m-d') !== $release_date ||
        !filter_var($homepage, FILTER_VALIDATE_URL) ||
        !in_array(strtolower(parse_url($homepage, PHP_URL_SCHEME) ?? ''), ['http', 'https'], true) ||
        !filter_var($url, FILTER_VALIDATE_URL) ||
        !in_array(strtolower(parse_url($url, PHP_URL_SCHEME) ?? ''), ['http', 'https'], true)) {
        echo json_encode(['result' => 'fail', 'message' => 'Data film tidak valid']);
        exit;
    }

    $runtime = (int)$runtime_raw;
    // Sama dengan slide 15. Parameter terakhir: ID movie.
    $sql = 'UPDATE movie SET title = ?, overview = ?, runtime = ?,
            release_date = ?, homepage = ?, url_poster = ? WHERE movie_id = ?';
    $stmt = $conn->prepare($sql);
    $stmt->bind_param('ssisssi', $title, $overview, $runtime,
        $release_date, $homepage, $url, $movie_id);
    $stmt->execute();

    if ($stmt->affected_rows > 0) {
        $arr = ['result' => 'success'];
    } else {
        // Jika tidak ada perubahan, cek bahwa filmnya masih ada.
        $check = $conn->prepare('SELECT movie_id FROM movie WHERE movie_id = ?');
        $check->bind_param('i', $movie_id);
        $check->execute();
        $exists = $check->get_result()->num_rows > 0;
        $arr = $exists
            ? ['result' => 'success', 'message' => 'Tidak ada data yang berubah']
            : ['result' => 'fail', 'message' => 'Movie ID tidak ditemukan'];
        $check->close();
    }
    echo json_encode($arr);
    $stmt->close();
    $conn->close();
} catch (Throwable $e) {
    echo json_encode(['result' => 'fail', 'message' => 'Gagal update. Periksa struktur tabel dan database']);
}
