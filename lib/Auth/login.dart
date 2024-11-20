import 'dart:convert'; // Untuk jsonEncode dan jsonDecode
import 'package:http/http.dart' as http; // Untuk penggunaan http
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorMessage = '';

  Future<void> _login() async {
    final String username = _usernameController.text;
    final String password = _passwordController.text;

    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/api/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData['success'] == true) {
          // Simpan token dan navigasi
          String token = responseData['token'];
          Navigator.pushNamed(context, '/homepage');
        } else {
          setState(() {
            _errorMessage = responseData['message'] ?? 'Login failed.';
          });
        }
      } else {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        setState(() {
          _errorMessage = responseData['message'] ?? 'Login failed. Please try again.';
        });
      }
    } catch (e) {
      // Tangani kesalahan jaringan atau lainnya
      setState(() {
        _errorMessage = 'Terjadi kesalahan: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B2F9F),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset(
              'assets/backgroundtop.png',
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  const Text('Selamat Datang!', style: TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold)),
                  const Text('Sistem Informasi Sertifikasi dan Pelatihan Dosen JTI', style: TextStyle(fontSize: 15, color: Colors.white)),
                  const SizedBox(height: 10),
                  TextField(controller: _usernameController, decoration: InputDecoration(labelText: 'Username', labelStyle: TextStyle(color: Colors.white))),
                  const SizedBox(height: 20),
                  TextField(controller: _passwordController, obscureText: true, decoration: InputDecoration(labelText: 'Password', labelStyle: TextStyle(color: Colors.white))),
                  const SizedBox(height: 20),
                  if (_errorMessage.isNotEmpty) Text(_errorMessage, style: TextStyle(color: Colors.red)),
                  const SizedBox(height: 10),
                  ElevatedButton(onPressed: _login, child: Text('Log In')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
