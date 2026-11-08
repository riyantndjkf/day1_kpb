import 'dart:convert';

import 'package:day1_kpb/class/genre.dart';
import 'package:day1_kpb/class/popmovie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;


class EditPopMovie extends StatefulWidget {
  final int movieID;

  const EditPopMovie({super.key, required this.movieID});

  @override
  State<EditPopMovie> createState() => _EditPopMovieState();
}

class _EditPopMovieState extends State<EditPopMovie> {
  static const String _apiBase = 'https://ubaya.fun/flutter/160423125';

  final _formKey = GlobalKey<FormState>();
  final _titleCont = TextEditingController();
  final _homepageCont = TextEditingController();
  final _overviewCont = TextEditingController();
  final _releaseDateCont = TextEditingController();
  final _runtimeCont = TextEditingController();
  final _urlCont = TextEditingController();

  PopMovie? _pm;
  List<Genre> _availableGenres = [];
  bool _loading = true;
  bool _saving = false;
  bool _changingGenre = false;
  bool _checkingPoster = false;
  bool _posterPreviewOkay = false;
  String? _loadError;

  @override
  void initState() {
    super.initState();
    bacaData();
  }

  @override
  void dispose() {
    _titleCont.dispose();
    _homepageCont.dispose();
    _overviewCont.dispose();
    _releaseDateCont.dispose();
    _runtimeCont.dispose();
    _urlCont.dispose();
    super.dispose();
  }

  void _notify(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  bool _validUrl(String? value) {
    final parsed = Uri.tryParse(value?.trim() ?? '');
    return parsed != null &&
        (parsed.scheme == 'https' || parsed.scheme == 'http') &&
        parsed.host.isNotEmpty;
  }

  Future<void> _previewPoster() async {
    final url = _urlCont.text.trim();
    if (!_validUrl(url)) {
      _notify('URL poster tidak valid');
      return;
    }
    setState(() => _checkingPoster = true);
    bool valid = false;
    try {
      final response = await http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 12));
      valid =
          response.statusCode == 200 &&
          (response.headers['content-type'] ?? '').toLowerCase().startsWith(
            'image/',
          );
    } catch (_) {
      valid = false;
    }
    if (!mounted) return;
    setState(() {
      _checkingPoster = false;
      _posterPreviewOkay = valid && _urlCont.text.trim() == url;
    });
    if (!_posterPreviewOkay) _notify('Gambar tidak dapat diverifikasi');
  }

  Future<Map<String, dynamic>> _post(
    String filename,
    Map<String, String> values,
  ) async {
    final response = await http
        .post(Uri.parse('$_apiBase/$filename'), body: values)
        .timeout(const Duration(seconds: 20));

    if (response.statusCode != 200) {
      throw Exception('HTTP ${response.statusCode} ($filename)');
    }
    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw Exception('Format JSON $filename tidak sesuai');
    }
    return decoded;
  }

  Future<void> bacaData() async {
    if (!mounted) return;
    setState(() {
      _loading = true;
      _loadError = null;
    });
    try {
      final movieJson = await _post('detailmovie.php', {
        'id': widget.movieID.toString(),
      });
      if (movieJson['result'] != 'success') {
        throw Exception(
          movieJson['message']?.toString() ?? 'Movie tidak ditemukan',
        );
      }
      final movie = PopMovie.fromJson(
        Map<String, dynamic>.from(movieJson['data'] as Map),
      );

      final genreJson = await _post('genrelist.php', {
        'movie_id': widget.movieID.toString(),
      });
      if (genreJson['result'] != 'success') {
        throw Exception(
          genreJson['message']?.toString() ?? 'Gagal membaca genre',
        );
      }
      final available = (genreJson['data'] as List<dynamic>? ?? [])
          .map((item) => Genre.fromJSON(Map<String, dynamic>.from(item as Map)))
          .where((item) => item.genreId > 0)
          .toList();

      if (!mounted) return;
      setState(() {
        _pm = movie;
        _availableGenres = available;
        _titleCont.text = movie.title;
        _homepageCont.text = movie.homepage;
        _overviewCont.text = movie.overview;
        _releaseDateCont.text = movie.releaseDate;
        _runtimeCont.text = movie.runtime;
        _urlCont.text = movie.urlPoster;
        _posterPreviewOkay = false;
        _loading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _loadError = error.toString();
        _loading = false;
      });
    }
  }

  Future<void> _chooseDate() async {
    final parts = _releaseDateCont.text.split('-');
    DateTime initialDate = DateTime.now();
    if (parts.length == 3) {
      final year = int.tryParse(parts[0]);
      final month = int.tryParse(parts[1]);
      final day = int.tryParse(parts[2]);
      if (year != null && month != null && day != null) {
        final parsed = DateTime(year, month, day);
        if (parsed.year == year && parsed.month == month && parsed.day == day) {
          initialDate = parsed;
        }
      }
    }
    if (initialDate.isBefore(DateTime(2000))) initialDate = DateTime(2000);
    if (initialDate.isAfter(DateTime(2200))) initialDate = DateTime(2200);

    final date = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2200),
    );
    if (!mounted || date == null) return;
    setState(() {
      _releaseDateCont.text =
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    });
  }

  Future<void> submit() async {
    if (_saving || _changingGenre) return;
    if (!(_formKey.currentState?.validate() ?? false)) {
      _notify('Harap isian diperbaiki');
      return;
    }
    setState(() => _saving = true);
    try {
      final json = await _post('updatemovie.php', {
        'title': _titleCont.text.trim(),
        'overview': _overviewCont.text.trim(),
        'runtime': _runtimeCont.text.trim(),
        'release_date': _releaseDateCont.text.trim(),
        'homepage': _homepageCont.text.trim(),
        'url': _urlCont.text.trim(),
        'movie_id': widget.movieID.toString(),
      });
      if (!mounted) return;
      if (json['result'] == 'success') {
        _notify('Sukses mengubah data film');
        await bacaData();
      } else {
        _notify(json['message']?.toString() ?? 'Gagal mengubah film');
      }
    } catch (error) {
      _notify('Gagal memperbarui film: $error');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> addGenre(int genreId) async {
    if (_changingGenre || _saving) return;
    setState(() => _changingGenre = true);
    try {
      final json = await _post('addmoviegenre.php', {
        'movie_id': widget.movieID.toString(),
        'genre_id': genreId.toString(),
      });
      if (!mounted) return;
      if (json['result'] == 'success') {
        _notify('Sukses menambah genre');
        await bacaData();
      } else {
        _notify(json['message']?.toString() ?? 'Gagal menambah genre');
      }
    } catch (error) {
      _notify('Gagal menambah genre: $error');
    } finally {
      if (mounted) setState(() => _changingGenre = false);
    }
  }

  Future<void> deleteGenre(int genreId) async {
    if (_changingGenre || _saving) return;
    setState(() => _changingGenre = true);
    try {
      final json = await _post('deletemoviegenre.php', {
        'movie_id': widget.movieID.toString(),
        'genre_id': genreId.toString(),
      });
      if (!mounted) return;
      if (json['result'] == 'success') {
        _notify('Sukses menghapus genre dari film');
        await bacaData();
      } else {
        _notify(json['message']?.toString() ?? 'Gagal menghapus genre');
      }
    } catch (error) {
      _notify('Gagal menghapus genre: $error');
    } finally {
      if (mounted) setState(() => _changingGenre = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Popular Movie')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _loadError != null
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'Error: $_loadError',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: bacaData,
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            )
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Text('Movie ID: ${widget.movieID}'),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _titleCont,
                    decoration: const InputDecoration(
                      labelText: 'Title',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => (value?.trim().isEmpty ?? true)
                        ? 'Judul harus diisi'
                        : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _homepageCont,
                    keyboardType: TextInputType.url,
                    decoration: const InputDecoration(
                      labelText: 'Website / Homepage',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        _validUrl(value) ? null : 'Alamat website tidak valid',
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _overviewCont,
                    keyboardType: TextInputType.multiline,
                    minLines: 3,
                    maxLines: 6,
                    decoration: const InputDecoration(
                      labelText: 'Overview',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => (value?.trim().length ?? 0) < 20
                        ? 'Overview minimal 20 karakter'
                        : null,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _releaseDateCont,
                          readOnly: true,
                          onTap: _chooseDate,
                          decoration: const InputDecoration(
                            labelText: 'Release Date',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) => (value?.isEmpty ?? true)
                              ? 'Tanggal harus dipilih'
                              : null,
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton.filled(
                        onPressed: _chooseDate,
                        icon: const Icon(Icons.calendar_today),
                        tooltip: 'Pilih tanggal',
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _runtimeCont,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(
                      labelText: 'Runtime (menit)',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => (int.tryParse(value ?? '') ?? 0) <= 0
                        ? 'Runtime harus lebih dari 0'
                        : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _urlCont,
                    keyboardType: TextInputType.url,
                    onChanged: (_) {
                      setState(() => _posterPreviewOkay = false);
                    },
                    decoration: const InputDecoration(
                      labelText: 'URL Poster',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => _validUrl(value)
                        ? null
                        : 'Alamat URL poster tidak valid',
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    onPressed: _checkingPoster ? null : _previewPoster,
                    icon: const Icon(Icons.image_search),
                    label: Text(
                      _checkingPoster ? 'Memeriksa...' : 'Cek Poster',
                    ),
                  ),
                  if (_validUrl(_urlCont.text))
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Image.network(
                        _urlCont.text.trim(),
                        width: 200,
                        height: 220,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) =>
                            const Text('Poster belum bisa ditampilkan'),
                      ),
                    ),
                  if (_posterPreviewOkay)
                    const Text('Poster sudah diverifikasi sebagai gambar'),
                  ElevatedButton(
                    onPressed: (_saving || _changingGenre) ? null : submit,
                    child: Text(
                      _saving ? 'Menyimpan...' : 'Submit Update Movie',
                    ),
                  ),
                  const Divider(height: 38),
                  const Text(
                    'Genre Film',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  if ((_pm?.genres ?? []).isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text('Belum ada genre untuk film ini'),
                    ),
                  for (final item in (_pm?.genres ?? []))
                    Builder(
                      builder: (context) {
                        final genre = Map<String, dynamic>.from(item as Map);
                        final genreId = int.tryParse(
                          genre['genre_id']?.toString() ?? '',
                        );
                        return Card(
                          child: ListTile(
                            title: Text(genre['genre_name']?.toString() ?? '-'),
                            trailing: IconButton(
                              tooltip: 'Hapus genre dari film',
                              icon: const Icon(Icons.close, color: Colors.red),
                              onPressed: (_changingGenre || genreId == null)
                                  ? null
                                  : () => deleteGenre(genreId),
                            ),
                          ),
                        );
                      },
                    ),
                  const SizedBox(height: 12),
                  const Text('Tambahkan genre:'),
                  if (_availableGenres.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text('Semua genre sudah dipakai oleh film ini.'),
                    )
                  else
                    DropdownButton<int>(
                      hint: const Text('Pilih genre'),
                      isExpanded: true,
                      value: null,
                      items: _availableGenres
                          .map(
                            (genre) => DropdownMenuItem<int>(
                              value: genre.genreId,
                              child: Text(genre.genreName),
                            ),
                          )
                          .toList(),
                      onChanged: (_saving || _changingGenre)
                          ? null
                          : (genreId) {
                              if (genreId != null) addGenre(genreId);
                            },
                    ),
                  if (_changingGenre)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: LinearProgressIndicator(),
                    ),
                  const SizedBox(height: 28),
                ],
              ),
            ),
    );
  }
}
