
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

// Mengambil ID film
$id = filter_input(INPUT_POST, 'id', FILTER_VALIDATE_INT);

if ($id === null || $id === false || $id <= 0) {
    echo json_encode([
        "result" => "error",
        "message" => "Invalid movie ID"
    ]);
    $conn->close();
    exit;
}

// Mengambil satu film
$sql = "SELECT * FROM movie WHERE movie_id = ?";
$stmt = $conn->prepare($sql);
$stmt->bind_param("i", $id);
$stmt->execute();

$result = $stmt->get_result();

if ($result->num_rows > 0) {
    $r = mysqli_fetch_assoc($result);

    // Mengambil genre film
    $sql2 = "SELECT genre_name
             FROM genre
             INNER JOIN movie_genres
             ON genre.genre_id = movie_genres.genre_id
             WHERE movie_genres.movie_id = ?";

    $stmt2 = $conn->prepare($sql2);
    $stmt2->bind_param("i", $id);
    $stmt2->execute();

    $result2 = $stmt2->get_result();
    $genres = [];

    if ($result2->num_rows > 0) {
        while ($r2 = mysqli_fetch_assoc($result2)) {
            array_push($genres, $r2);
        }
    }

    // Memasukkan genre ke objek film
    $r["genres"] = $genres;

    $stmt2->close();

    
    
    // data aktor, karakter, dan gender
    $sql3 = "SELECT
                p.person_id,
                p.person_name,
                p.url_photo,
                mc.character_name,
                mc.cast_order,
                COALESCE(g.gender, 'Unspecified') AS gender
            FROM movie_cast mc
            INNER JOIN person p
                ON mc.person_id = p.person_id
            LEFT JOIN gender g
                ON mc.gender_id = g.gender_id
            WHERE mc.movie_id = ?
            ORDER BY mc.cast_order ASC, p.person_name ASC";

    $stmt3 = $conn->prepare($sql3);
    $stmt3->bind_param("i", $id);
    $stmt3->execute();

    $result3 = $stmt3->get_result();

    $casts = [];

    if ($result3->num_rows > 0) {
        while ($r3 = mysqli_fetch_assoc($result3)) {
            array_push($casts, $r3);
        }
    }

    // Memasukkan pemeran ke JSON film
    $r["casts"] = $casts;

    $stmt3->close();



    $arr = [
        "result" => "success",
        "data" => $r
    ];
} else {
    $arr = [
        "result" => "error",
        "message" => "Movie not found"
    ];
}

echo json_encode($arr);

$stmt->close();
$conn->close();
?>
