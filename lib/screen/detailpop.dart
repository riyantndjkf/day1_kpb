import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:day1_kpb/class/popmovie.dart'; 

class DetailPop extends StatefulWidget {
  final int movieID;

  const DetailPop({super.key, required this.movieID});

  @override
  State<DetailPop> createState() {
    return _DetailPopState();
  }
}

class _DetailPopState extends State<DetailPop> {
  PopMovie? _pm;
  String? _errorMessage;

  // Mengambil data film dari API
  Future<String> fetchData() async {
    final response = await http.post(
      Uri.parse('https://ubaya.cloud/flutter/160423125/detailmovie.php'),
      body: {'id': widget.movieID.toString()},
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to read API');
    }
  }

  // Mengubah JSON menjadi objek PopMovie
  void bacaData() async {
    try {
      String data = await fetchData();

      Map<String, dynamic> json = jsonDecode(data);

      if (json['result'] == 'success') {
        PopMovie movie = PopMovie.fromJson(json['data']);

        if (!mounted) return;

        setState(() {
          _pm = movie;
        });
      } else {
        if (!mounted) return;

        setState(() {
          _errorMessage = json['message']?.toString() ?? 'Film tidak ditemukan';
        });
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _errorMessage = e.toString();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    bacaData();
  }

  // Menampilkan informasi film
  Widget tampilData() {
    if (_errorMessage != null) {
      return Center(child: Text('Error: $_errorMessage'));
    }

    if (_pm == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final movie = _pm!;
    final genres = movie.genres ?? [];
    final casts = movie.casts ?? [];

    return Card(
      elevation: 10,
      margin: const EdgeInsets.all(10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          // JUDUL FILM
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              movie.title,
              style: const TextStyle(fontSize: 25),
              textAlign: TextAlign.center,
            ),
          ),

          // POSTER FILM
          Padding(
            padding: const EdgeInsets.all(10),
            child: Image.network(
              movie.urlPoster,
              width: 200,
              height: 300,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.movie, size: 100);
              },
            ),
          ),

          // DESKRIPSI FILM
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(movie.overview, style: const TextStyle(fontSize: 15)),
          ),

          // JUDUL GENRE
          const Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              'Genre:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),

          // DAFTAR GENRE
          Padding(
            padding: const EdgeInsets.all(10),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: genres.length,
              itemBuilder: (BuildContext context, int index) {
                return Text(genres[index]['genre_name'].toString());
              },
            ),
          ),

          const Divider(),

          // JUDUL CAST
          const Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              'Actor / Actress:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),

          // DAFTAR AKTOR DAN KARAKTER
          
          // DAFTAR AKTOR, KARAKTER, DAN GENDER
          Padding(
            padding: const EdgeInsets.all(10),
            child: casts.isEmpty
                ? const Text('Tidak ada data pemeran')
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: casts.length,
                    itemBuilder: (BuildContext context, int index) {
                      final cast = casts[index];

                      final String actorName =
                          cast['person_name']?.toString() ?? '-';

                      final String characterName =
                          cast['character_name']?.toString() ?? '-';

                      final String gender =
                          cast['gender']?.toString() ?? 'Unspecified';

                      final String photo = cast['url_photo']?.toString() ?? '';

                      return Card(
                        child: ListTile(
                          isThreeLine: true,

                          // Foto aktor
                          leading: SizedBox(
                            width: 55,
                            height: 70,
                            child: photo.isNotEmpty
                                ? Image.network(
                                    photo,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(Icons.person, size: 40);
                                    },
                                  )
                                : const Icon(Icons.person, size: 40),
                          ),

                          // Nama aktor
                          title: Text(
                            actorName,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),

                          // Karakter dan gender
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('As $characterName'),
                              Text('Gender: $gender'),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail of Popular Movie')),
      body: ListView(children: <Widget>[tampilData()]),
    );
  }
}
