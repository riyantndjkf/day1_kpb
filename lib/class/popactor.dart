class PopActor {
  int id;
  String name;
  String urlPhoto;

  PopActor({required this.id, required this.name, required this.urlPhoto});

  factory PopActor.fromJson(Map<String, dynamic> json) {
    return PopActor(
      id: json['person_id'] as int,
      name: json['person_name']?.toString() ?? '',
      urlPhoto: json['url_photo']?.toString() ?? '',
    );
  }
}
