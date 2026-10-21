import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:day1_kpb/class/popmovie.dart';
import 'package:go_router/go_router.dart';

class PopularMovie extends StatefulWidget {
  const PopularMovie({super.key});

  @override
  State<PopularMovie> createState() => _PopularMovieState();
}

class _PopularMovieState extends State<PopularMovie> {
  List<PopMovie> PMs = [];

  bool _isLoading = true;
  String? _errorMessage;
  String _txtCari = '';
  // Mengambil data JSON dari API
  Future<String> fetchData() async {
    final response = await http.post(
      Uri.parse('https://ubaya.cloud/flutter/160423125/movielist.php'),
      body: {'cari': _txtCari},
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to read API');
    }
  }

  // Mengubah JSON menjadi List<PopMovie>

  void bacaData() async {
    try {
      String data = await fetchData();

      Map<String, dynamic> json = jsonDecode(data);

      List<PopMovie> temp = [];

      if (json['result'] == 'success') {
        for (var mov in json['data']) {
          PopMovie pm = PopMovie.fromJson(mov);
          temp.add(pm);
        }
      }

      if (!mounted) return;

      setState(() {
        PMs = temp;
        _isLoading = false;
        _errorMessage = null;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  // Menampilkan daftar film
  Widget DaftarPopMovie(List<PopMovie> popMovs) {
    return ListView.builder(
      itemCount: popMovs.length,
      itemBuilder: (BuildContext context, int index) {
        PopMovie movie = popMovs[index];

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: ListTile(
            isThreeLine: true,
            leading: SizedBox(
              width: 55,
              height: 80,
              child: Image.network(
                movie.urlPoster,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.movie, size: 40);
                },
              ),
            ),
            title: GestureDetector(
              child: Text(movie.title),
              onTap: () {
                context.push('/detailpop/${movie.id}');
              },
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movie.overview,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Text('Rating: ${movie.voteAverage}'),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    bacaData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Popular Movie')),
      body: Column(
        children: [
          // Textbox pencarian
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextFormField(
              decoration: const InputDecoration(
                icon: Icon(Icons.search),
                labelText: 'Judul mengandung kata:',
              ),
              textInputAction: TextInputAction.search,
              onFieldSubmitted: (value) {
                setState(() {
                  _txtCari = value;
                  PMs.clear();
                  _isLoading = true;
                  _errorMessage = null;
                });

                bacaData();
              },
            ),
          ),

          // Daftar film
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _errorMessage != null
                ? Center(child: Text('Error: $_errorMessage'))
                : PMs.isNotEmpty
                ? DaftarPopMovie(PMs)
                : const Center(child: Text('Tidak ada data')),
          ),
        ],
      ),
    );
  }
}
