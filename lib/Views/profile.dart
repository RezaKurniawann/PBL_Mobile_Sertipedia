import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sertipedia/Template/drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  const Profile({super.key, required this.title});

  final String title;

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String name = '';
  String username = '';
  String nip = '';
  String imageUrl = '';  // Corrected to String
  bool isEditable = false; // Untuk mengatur apakah form editable
  List<dynamic> levels = [];

  final Dio _dio = Dio();
  static const String baseUrl = 'http://192.168.78.75:8000/api'; 
  final String urlUsers = '$baseUrl/users';
  final String urlLevels = '$baseUrl/levels';

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _nipController = TextEditingController();

  int userId = 0;
  String token = '';
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final int? id = prefs.getInt('id_user');
    final String? userToken = prefs.getString('token');

    if (id != null && userToken != null) {
      setState(() {
        userId = id;
        token = userToken;
      });
      await _getUserData();
      await _getLevels();
    } else {
      _showSnackBar('User not logged in.', backgroundColor: Colors.red);
    }
  }

  Future<void> _getUserData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await _dio.get(
        '$urlUsers/$userId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        final data = response.data['data'];

        if (data != null) {
          setState(() {
            name = data['name'] ?? '';
            username = data['username'] ?? '';
            nip = data['nip'] ?? '';
            imageUrl = data['image'] ?? '';
            _nameController.text = name;
            _usernameController.text = username;
            _nipController.text = nip;
          });
        } else {
          _showSnackBar('No user data found', backgroundColor: Colors.red);
        }
      } else {
        _showSnackBar('Failed to retrieve user data', backgroundColor: Colors.red);
      }
    } catch (e) {
      _showSnackBar('Error fetching user data: $e', backgroundColor: Colors.red);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _getLevels() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await _dio.get(
        urlLevels,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        final data = response.data['data'];

        // Debugging output to check the raw response
        print('Levels response: ${response.data}');  // Menampilkan seluruh response

        // Cek apakah data yang diterima benar-benar berupa list
        if (data != null && data is List) {
          setState(() {
            levels = List<dynamic>.from(data);
          });
        } else {
          _showSnackBar('Levels data is not a list or is empty', backgroundColor: Colors.red);
        }
      } else {
        _showSnackBar('Failed to retrieve levels data', backgroundColor: Colors.red);
      }
    } catch (e) {
      _showSnackBar('Error fetching levels data: $e', backgroundColor: Colors.red);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _updateUserData() async {
    if (!_validateInputs()) return;

    setState(() {
      isLoading = true;
    });

    try {
      final response = await _dio.put(
        '$urlUsers/$userId',
        data: {
          'name': _nameController.text,
          'username': _usernameController.text,
          'nip': _nipController.text,
        },
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        _showSnackBar('Data successfully updated!');
        _getUserData();
        setState(() {
          isEditable = false;  // Menyembunyikan tombol Save setelah update
        });
      } else {
        _showSnackBar('Failed to save data', backgroundColor: Colors.red);
      }
    } catch (e) {
      _showSnackBar('Error: $e', backgroundColor: Colors.red);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  bool _validateInputs() {
    if (_nameController.text.trim().isEmpty) {
      _showSnackBar('Name is required.', backgroundColor: Colors.red);
      return false;
    }
    if (_usernameController.text.trim().isEmpty) {
      _showSnackBar('Username is required.', backgroundColor: Colors.red);
      return false;
    }
    if (_nipController.text.trim().isEmpty) {
      _showSnackBar('NIP is required.', backgroundColor: Colors.red);
      return false;
    }
    return true;
  }

  void _showSnackBar(String message, {Color backgroundColor = Colors.green}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
      ),
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String label,
    bool enabled = true,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
      child: TextField(
        controller: controller,
        enabled: enabled,  // Menambahkan kontrol enable/disable
        decoration: InputDecoration(
          labelText: label,
          hintStyle: const TextStyle(color: Colors.grey),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B2F9F),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            color: Colors.white,
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        titleSpacing: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              widget.title,
              style: const TextStyle(fontWeight: FontWeight.w900, color: Colors.white),
            ),
            const Padding(padding: EdgeInsets.only(right: 17.5)),
          ],
        ),
      ),
      drawer: const DrawerLayout(),
      body: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Image.asset(
              'assets/backgroundbuttom.png',
              fit: BoxFit.cover,
              height: 110,
            ),
          ),
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            const SizedBox(height: 30),
                            const Text(
                              'PROFILE',
                              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20),
                            ),
                            imageUrl.isNotEmpty
                                ? CircleAvatar(
                                    radius: 75,
                                    backgroundImage: NetworkImage(imageUrl),
                                  )
                                : const CircleAvatar(
                                    radius: 75,
                                    child: Icon(Icons.person, size: 75),
                                  ),
                            buildTextField(
                              controller: _nameController,
                              label: 'Name',
                              enabled: isEditable,
                            ),
                            buildTextField(
                              controller: _usernameController,
                              label: 'Username',
                              enabled: isEditable,
                            ),
                            buildTextField(
                              controller: _nipController,
                              label: 'NIP',
                              enabled: isEditable,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                if (isEditable)
                                  ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        isEditable = false; // Menyembunyikan field edit
                                      });
                                    },
                                    child: const Text("Cancel"),
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(vertical: 15), backgroundColor: Colors.red, // Warna merah untuk cancel
                                    ),
                                  ),
                                ElevatedButton(
                                  onPressed: isEditable ? _updateUserData : () {
                                    setState(() {
                                      isEditable = true;  // Menyalakan mode edit
                                    });
                                  },
                                  child: Text(isEditable ? 'Save' : 'Edit'),
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(vertical: 15), backgroundColor: isEditable ? Colors.green : Color(0xFF0D6EFD), // Warna hijau untuk save, biru untuk edit
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}
