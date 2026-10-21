import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() {
    return _LoginState();
  }
}

class _LoginState extends State<Login> {
  String _userId = '';
  String _password = '';
  String _errorLogin = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _errorLogin = '';
  }

  Future<void> doLogin() async {
    if (_isLoading) return;

    if (_userId.trim().isEmpty || _password.isEmpty) {
      setState(() {
        _errorLogin = 'User ID dan password harus diisi';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorLogin = '';
    });

    try {
      final response = await http.post(
        Uri.parse('https://ubaya.cloud/flutter/160423125/login.php'),
        body: {'user_id': _userId.trim(), 'user_password': _password},
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> json = jsonDecode(response.body);

        if (json['result'] == 'success') {
          final prefs = await SharedPreferences.getInstance();

          await prefs.setString('user_id', _userId.trim());
          await prefs.setString('user_name', json['user_name'].toString());

          if (!mounted) return;

          active_user = _userId.trim();
          isLoggedIn.value = true;
        } else {
          if (!mounted) return;

          setState(() {
            _errorLogin = 'Incorrect user or password';
          });
        }
      } else {
        throw Exception('Failed to read API');
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _errorLogin = 'Gagal menghubungi server. Periksa koneksi API.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(width: 1),
            color: Colors.white,
            boxShadow: const [BoxShadow(blurRadius: 5)],
          ),
          child: Column(
            children: [
              // User ID
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  onChanged: (value) {
                    _userId = value;
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'User ID',
                    hintText: 'Enter your User ID',
                  ),
                ),
              ),

              // Password
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  obscureText: true,
                  onChanged: (value) {
                    _password = value;
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    hintText: 'Enter your password',
                  ),
                ),
              ),

              // Pesan error login
              Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  _errorLogin,
                  style: const TextStyle(color: Colors.red),
                ),
              ),

              // Tombol Login
              Padding(
                padding: const EdgeInsets.all(10),
                child: SizedBox(
                  height: 50,
                  width: 300,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : doLogin,
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : const Text('Login', style: TextStyle(fontSize: 25)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
