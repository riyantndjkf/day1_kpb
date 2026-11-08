// Model Week 9–11. Field baru Week 11: homepage, releaseDate, runtime.
// Nama JSON tetap mengikuti kolom MySQL: release_date dan url_poster.
class PopMovie {
  int id;
  String title;
  String overview;
  String voteAverage;
  String urlPoster;
  String homepage;
  String releaseDate;
  String runtime;

  // Relasi dari detailmovie.php (genre dan pemeran).
  List<dynamic>? genres;
  List<dynamic>? casts;

  PopMovie({
    required this.id,
    required this.title,
    required this.overview,
    required this.voteAverage,
    required this.urlPoster,
    this.homepage = '',
    this.releaseDate = '',
    this.runtime = '',
    this.genres,
    this.casts,
  });

  factory PopMovie.fromJson(Map<String, dynamic> json) {
    return PopMovie(
      id: int.tryParse(json['movie_id']?.toString() ?? '') ?? 0,
      title: json['title']?.toString() ?? '',
      overview: json['overview']?.toString() ?? '',
      voteAverage:
          (json['vote_average'] ?? json['voteAverage'])?.toString() ?? '0.0',
      urlPoster: (json['url_poster'] ?? json['url'])?.toString() ?? '',
      homepage: json['homepage']?.toString() ?? '',
      releaseDate: json['release_date']?.toString() ?? '',
      runtime: json['runtime']?.toString() ?? '',
      genres: json['genres'] as List<dynamic>?,
      casts: json['casts'] as List<dynamic>?,
    );
  }
}
