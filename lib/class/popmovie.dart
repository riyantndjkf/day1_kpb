class PopMovie {
  int id;
  String title;
  String overview;
  String voteAverage;
  String urlPoster;

  // nested list genres dan cast
  List<dynamic>? genres;
  List<dynamic>? casts;

  PopMovie({
    required this.id,
    required this.title,
    required this.overview,
    required this.voteAverage,
    required this.urlPoster,
    this.genres,
    this.casts,
  });

  factory PopMovie.fromJson(Map<String, dynamic> json) {
    return PopMovie(
      id: json['movie_id'] as int,
      title: json['title']?.toString() ?? '',
      overview: json['overview']?.toString() ?? '',
      voteAverage: json['vote_average']?.toString() ?? '0.0',
      urlPoster: json['url_poster']?.toString() ?? '',
      genres: json['genres'] as List<dynamic>?,
      casts: json['casts'] as List<dynamic>?,
    );
  }
}
