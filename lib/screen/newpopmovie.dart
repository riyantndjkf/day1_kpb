import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

class NewPopMovie extends StatefulWidget {
  const NewPopMovie({super.key});

  @override
  State<NewPopMovie> createState() => _NewPopMovieState();
}

class _NewPopMovieState extends State<NewPopMovie> {
  final _formKey = GlobalKey<FormState>();
  final _controllerDate = TextEditingController();
  final _controllerPoster = TextEditingController();

  String _title = '';
  String _overview = '';
  String _homepage = '';
  String _runtime = '';
  String _url = '';

  bool _checkingPoster = false;
  bool _posterValid = false;
  bool _submitting = false;

  static const _newMovieEndpoint =
      'https://ubaya.fun/flutter/160423125/newmovie.php';

  bool _isValidWebUrl(String? value) {
    final url = Uri.tryParse(value?.trim() ?? '');
    return url != null &&
        (url.scheme == 'http' || url.scheme == 'https') &&
        url.host.isNotEmpty;
  }

  Future<bool> validateImage(String imageUrl) async {
    if (!_isValidWebUrl(imageUrl)) return false;
    try {
      final response = await http
          .get(Uri.parse(imageUrl))
          .timeout(const Duration(seconds: 12));
      final contentType = response.headers['content-type']?.toLowerCase() ?? '';
      return response.statusCode == 200 && contentType.startsWith('image/');
    } catch (_) {
      return false;
    }
  }

  Future<void> _checkPoster() async {
    final checkedUrl = _controllerPoster.text.trim();
    if (!_isValidWebUrl(checkedUrl)) {
      setState(() => _posterValid = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('URL poster belum valid')));
      return;
    }

    setState(() => _checkingPoster = true);
    final valid = await validateImage(checkedUrl);
    if (!mounted) return;

    setState(() {
      _checkingPoster = false;
      _posterValid = checkedUrl == _controllerPoster.text.trim() && valid;
    });

    if (!_posterValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Poster bukan URL gambar yang bisa diakses'),
        ),
      );
    }
  }

  Future<void> _pickDate() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2200),
    );
    if (!mounted || selected == null) return;

    final month = selected.month.toString().padLeft(2, '0');
    final day = selected.day.toString().padLeft(2, '0');
    setState(() => _controllerDate.text = '${selected.year}-$month-$day');
  }

  Future<void> submit() async {
    if (_submitting) return;
    if (!(_formKey.currentState?.validate() ?? false)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Harap isian diperbaiki')));
      return;
    }

    setState(() => _submitting = true);
    try {
      final imageValid = await validateImage(_url);
      if (!mounted) return;
      setState(() => _posterValid = imageValid);
      if (!imageValid) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Poster tidak bisa diakses sebagai gambar'),
          ),
        );
        return;
      }

      final response = await http
          .post(
            Uri.parse(_newMovieEndpoint),
            body: {
              'title': _title.trim(),
              'overview': _overview.trim(),
              'homepage': _homepage.trim(),
              'release_date': _controllerDate.text,
              'runtime': _runtime,
              'url': _url.trim(),
            },
          )
          .timeout(const Duration(seconds: 20));

      if (response.statusCode != 200) {
        throw Exception('HTTP ${response.statusCode}');
      }
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      if (!mounted) return;

      if (json['result'] == 'success') {
        final newId = int.tryParse(json['id']?.toString() ?? '');
        if (newId != null && newId > 0) {
          await context.push('/editpopmovie/$newId');
          if (!mounted) return;
        }
        context.pop(true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(json['message']?.toString() ?? 'Gagal menambah film'),
          ),
        );
      }
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal mengirim data: $error')));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  void dispose() {
    _controllerDate.dispose();
    _controllerPoster.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Popular Movie')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => _title = value,
              validator: (value) =>
                  (value?.trim().isEmpty ?? true) ? 'Judul harus diisi' : null,
            ),
            const SizedBox(height: 14),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Overview',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.multiline,
              minLines: 3,
              maxLines: 6,
              onChanged: (value) => _overview = value,
              validator: (value) => (value?.trim().length ?? 0) < 20
                  ? 'Overview minimal 20 karakter'
                  : null,
            ),
            const SizedBox(height: 14),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Homepage (https://...)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.url,
              onChanged: (value) => _homepage = value,
              validator: (value) =>
                  _isValidWebUrl(value) ? null : 'Alamat homepage salah',
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _controllerDate,
                    readOnly: true,
                    onTap: _pickDate,
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
                  tooltip: 'Pilih tanggal',
                  onPressed: _pickDate,
                  icon: const Icon(Icons.calendar_today),
                ),
              ],
            ),
            const SizedBox(height: 14),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Runtime (menit)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: (value) => _runtime = value,
              validator: (value) {
                final runtime = int.tryParse(value ?? '');
                return runtime == null || runtime <= 0
                    ? 'Runtime harus angka lebih dari 0'
                    : null;
              },
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _controllerPoster,
              decoration: const InputDecoration(
                labelText: 'URL Poster (https://...)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.url,
              onChanged: (value) {
                _url = value.trim();
                setState(() => _posterValid = false);
              },
              onFieldSubmitted: (_) => _checkPoster(),
              validator: (value) =>
                  _isValidWebUrl(value) ? null : 'Alamat poster salah',
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: _checkingPoster ? null : _checkPoster,
              icon: _checkingPoster
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.image_search),
              label: const Text('Cek & Preview Poster'),
            ),
            if (_posterValid)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Image.network(
                  _controllerPoster.text.trim(),
                  height: 220,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) =>
                      const Text('Gagal menampilkan preview poster'),
                ),
              ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _submitting ? null : submit,
              icon: _submitting
                  ? const SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.send),
              label: Text(_submitting ? 'Mengirim...' : 'Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
