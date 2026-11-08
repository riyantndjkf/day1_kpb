class Genre {
  final int genreId;
  final String genreName;

  Genre({required this.genreId, required this.genreName});

  factory Genre.fromJSON(Map<String, dynamic> json) {
    return Genre(
      genreId: int.tryParse(json['value']?.toString() ?? '') ?? 0,
      genreName: json['label']?.toString() ?? '',
    );
  }
}
