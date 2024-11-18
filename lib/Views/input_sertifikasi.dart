import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'package:sertipedia/Template/drawer.dart';
import 'package:sertipedia/Api/api_services.dart';
import 'package:dio/dio.dart';
// import 'package:http/http.dart' as http;

class InputSertifikasi extends StatefulWidget {
  const InputSertifikasi({super.key, required this.title});
  final String title;

  @override
  State<InputSertifikasi> createState() => _InputSertifikasiState();
}

class _InputSertifikasiState extends State<InputSertifikasi> {
  List<dynamic> vendorSertifikasiList = [];
  List<dynamic> SertifikasiList = [];
  final List<String> _jenisSertifikasiOptions = ['Profesi', 'Keahlian'];

  String? _selectedVendorSertifikasi;
  String? _selectedSertifikasi;
  String? _selectedJenisSertifikasi;
  String? _base64Image;

  final TextEditingController _sertifikasiSearchController =
      TextEditingController();
  final TextEditingController _vendorSearchController = TextEditingController();
  final TextEditingController _periodeSertifikasiController =
      TextEditingController();
  final TextEditingController _noSertifikasiController =
      TextEditingController();
  
   // Ambil data Pelatihan
  Future<void> _fetchVendorSertifikasi() async {
    try {
      final response =
          await Dio().get(url_vendors); 
      if (response.statusCode == 200) {
        var vendors = response.data as List;
        var filteredVendors = vendors.where((vendor) {
          return vendor['kategori'] != null &&
              vendor['kategori'].contains('Sertifikasi');
        }).toList();

        setState(() {
          vendorSertifikasiList =
              filteredVendors;
        });
      } else {
        print("Gagal memuat data vendor sertifikasi");
      }
    } catch (e) {
      print("Error saat mengambil data vendor sertifikasi: $e");
    }
  }

  Future<void> _fetchSertifikasi() async {
    try {
      final response =
          await Dio().get(url_sertifikasis); 
      if (response.statusCode == 200) {
        setState(() {
          SertifikasiList = response.data as List; 
        });
      } else {
        print("Gagal memuat data sertifikasi");
      }
    } catch (e) {
      print("Error saat mengambil data sertifikasi: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchVendorSertifikasi(); 
    _fetchSertifikasi();
  }

  Future<void> _uploadPhoto() async {
    final ImagePicker picker = ImagePicker();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Upload Photo"),
          content: const Text("Choose your source"),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                final XFile? pickedFile =
                    await picker.pickImage(source: ImageSource.camera);
                if (pickedFile != null) {
                  final bytes = await pickedFile.readAsBytes();
                  setState(() {
                    _base64Image = base64Encode(bytes);
                  });
                }
                Navigator.of(context).pop();
              },
              child: const Text("Camera"),
            ),
            TextButton(
              onPressed: () async {
                final XFile? pickedFile =
                    await picker.pickImage(source: ImageSource.gallery);
                if (pickedFile != null) {
                  final bytes = await pickedFile.readAsBytes();
                  setState(() {
                    _base64Image = base64Encode(bytes);
                  });
                }
                Navigator.of(context).pop();
              },
              child: const Text("Gallery"),
            ),
          ],
        );
      },
    );
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi'),
          content: const Text('Apakah Anda yakin ingin menyimpan data?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Ya'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _sertifikasiSearchController.dispose();
    _vendorSearchController.dispose();
    _periodeSertifikasiController.dispose();
    _noSertifikasiController.dispose();
    super.dispose();
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
            Text(widget.title, // Gunakan title yang diteruskan dari route
                style: TextStyle(
                    fontWeight: FontWeight.w900, color: Colors.white)),
            Padding(padding: EdgeInsets.only(right: 17.5)),
          ],
        ),
      ),
      drawer: const DrawerLayout(),
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // Background image at the bottom of the screen
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Image.asset(
              'assets/backgroundbuttom.png', // Path to your footer image
              fit: BoxFit.cover,
              height: 110, // Adjust the height if necessary
            ),
          ),

          // Scrollable content with padding to avoid overlapping the background image
          Positioned.fill(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0).copyWith(
                  bottom:
                      130.0), // Extra bottom padding to avoid overlap with background
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Input Sertifikasi',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0B2F9F),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Autocomplete<String>(
                    optionsBuilder: (TextEditingValue textEditingValue) {
                      if (textEditingValue.text.isEmpty) {
                        return const Iterable<String>.empty();
                      }
                      return SertifikasiList.where((sertifikasi) =>
                              sertifikasi['nama']
                                  .toString()
                                  .toLowerCase()
                                  .contains(
                                      textEditingValue.text.toLowerCase()))
                          .map((sertifikasi) => sertifikasi['nama'].toString());
                    },
                    onSelected: (String selectedSertifikasi) {
                      setState(() {
                        _selectedSertifikasi = selectedSertifikasi;
                      });
                    },
                    fieldViewBuilder: (BuildContext context,
                        TextEditingController textEditingController,
                        FocusNode focusNode,
                        VoidCallback onFieldSubmitted) {
                      _sertifikasiSearchController.text =
                          _selectedSertifikasi ?? '';
                      return TextField(
                        controller: textEditingController,
                        focusNode: focusNode,
                        decoration: const InputDecoration(
                          labelText: 'Nama Pelatihan',
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  Autocomplete<String>(
                    optionsBuilder: (TextEditingValue textEditingValue) {
                      if (textEditingValue.text.isEmpty) {
                        return const Iterable<String>.empty();
                      }
                      return vendorSertifikasiList
                          .where((vendor) => vendor['nama']
                              .toString()
                              .toLowerCase()
                              .contains(textEditingValue.text.toLowerCase()))
                          .map((vendor) => vendor['nama'].toString());
                    },
                    onSelected: (String selectedVendor) {
                      setState(() {
                        _selectedVendorSertifikasi = selectedVendor;
                      });
                    },
                    fieldViewBuilder: (BuildContext context,
                        TextEditingController textEditingController,
                        FocusNode focusNode,
                        VoidCallback onFieldSubmitted) {
                      _vendorSearchController.text =
                          _selectedVendorSertifikasi ?? '';
                      return TextField(
                        controller: textEditingController,
                        focusNode: focusNode,
                        decoration: const InputDecoration(
                          labelText: 'Vendor',
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: _selectedJenisSertifikasi,
                    items: _jenisSertifikasiOptions.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedJenisSertifikasi = newValue;
                      });
                    },
                    decoration: const InputDecoration(labelText: 'Jenis'),
                  ),
                  TextField(
                    controller: _periodeSertifikasiController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(labelText: 'Periode / Tahun'),
                  ),
                  TextField(
                    controller: _noSertifikasiController,
                    decoration:
                        const InputDecoration(labelText: 'No. Sertifikasi'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _uploadPhoto,
                    icon: const Icon(Icons.upload),
                    label: const Text('Upload Sertifikasi'),
                  ),
                  if (_base64Image != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Image.memory(
                        base64Decode(_base64Image!),
                        width: 150,
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                    ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      _showConfirmationDialog(
                          context); // Show confirmation dialog
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0B2F9F), // Button color
                      foregroundColor: Colors.white, // Text color
                    ),
                    child: const Text('Simpan'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
