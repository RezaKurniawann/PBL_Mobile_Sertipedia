import 'dart:convert';
// import 'dart:typed_data'; // For Uint8List
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'package:sertipedia/Template/drawer.dart';
import 'package:sertipedia/Api/api_services.dart';
import 'package:dio/dio.dart';

class InputPelatihan extends StatefulWidget {
  const InputPelatihan({super.key, required this.title});
  final String title;

  @override
  State<InputPelatihan> createState() => _InputPelatihanState();
}

class _InputPelatihanState extends State<InputPelatihan> {
  List<dynamic> vendorPelatihanList = [];
  List<dynamic> PelatihanList = [];
  final List<String> _levelPelatihanOptions = ['Nasional', 'Internasional'];

  String? _selectedVendorPelatihan;
  String? _selectedPelatihan;
  String? _selectedLevelPelatihan;
  String? _base64Image;


  final TextEditingController _periodePelatihanController =
      TextEditingController();
  final TextEditingController _pelatihanSearchController = TextEditingController();
  final TextEditingController _vendorSearchController = TextEditingController();

  // Ambil data Pelatihan
  Future<void> _fetchVendorPelatihan() async {
    try {
      final response =
          await Dio().get(url_vendors); // Menggunakan Dio untuk request GET
      if (response.statusCode == 200) {
        // Menyaring vendor yang memiliki kategori pelatihan
        var vendors = response.data as List;
        var filteredVendors = vendors.where((vendor) {
          return vendor['kategori'] != null &&
              vendor['kategori'].contains('Pelatihan');
        }).toList();

        setState(() {
          vendorPelatihanList =
              filteredVendors; // Menyimpan data yang telah difilter
        });
      } else {
        print("Gagal memuat data Pelatihan");
      }
    } catch (e) {
      print("Error saat mengambil data Pelatihan: $e");
    }
  }

  Future<void> _fetchNamaPelatihan() async {
    try {
      final response =
          await Dio().get(url_pelatihans); // URL API untuk pelatihan
      if (response.statusCode == 200) {
        setState(() {
          PelatihanList = response.data as List; // Simpan semua field
        });
      } else {
        print("Gagal memuat data Pelatihan");
      }
    } catch (e) {
      print("Error saat mengambil data Pelatihan: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchVendorPelatihan(); // Mengambil data Pelatihan saat widget diinisialisasi
    _fetchNamaPelatihan();
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
                Navigator.of(context).pop(); // Close the dialog
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
    _pelatihanSearchController.dispose();
    _vendorSearchController.dispose();
    _periodePelatihanController.dispose();
  
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
                style: const TextStyle(
                    fontWeight: FontWeight.w900, color: Colors.white)),
            const Padding(padding: EdgeInsets.only(right: 17.5)),
          ],
        ),
      ),
      drawer: const DrawerLayout(),
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 110, // Adjust as necessary for your image height
              width: double.infinity,
              child: Image.asset(
                'assets/backgroundbuttom.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Input Pelatihan',
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
                    return PelatihanList
                        .where((pelatihan) => pelatihan['nama']
                            .toString()
                            .toLowerCase()
                            .contains(textEditingValue.text.toLowerCase()))
                        .map((pelatihan) => pelatihan['nama'].toString());
                  },
                  onSelected: (String selectedPelatihan) {
                    setState(() {
                      _selectedPelatihan = selectedPelatihan;
                    });
                  },
                  fieldViewBuilder: (BuildContext context,
                      TextEditingController textEditingController,
                      FocusNode focusNode,
                      VoidCallback onFieldSubmitted) {
                    _pelatihanSearchController.text = _selectedPelatihan ?? '';
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
                    return vendorPelatihanList
                        .where((vendor) => vendor['nama']
                            .toString()
                            .toLowerCase()
                            .contains(textEditingValue.text.toLowerCase()))
                        .map((vendor) => vendor['nama'].toString());
                  },
                  onSelected: (String selectedVendor) {
                    setState(() {
                      _selectedVendorPelatihan = selectedVendor;
                    });
                  },
                  fieldViewBuilder: (BuildContext context,
                      TextEditingController textEditingController,
                      FocusNode focusNode,
                      VoidCallback onFieldSubmitted) {
                    _vendorSearchController.text =
                        _selectedVendorPelatihan ?? '';
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
                  value: _selectedLevelPelatihan,
                  items: _levelPelatihanOptions.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedLevelPelatihan = newValue;
                    });
                  },
                  decoration: const InputDecoration(labelText: 'Level'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _periodePelatihanController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration:
                      const InputDecoration(labelText: 'Periode / Tahun'),
                ),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: _uploadPhoto,
                  icon: const Icon(Icons.upload),
                  label: const Text('Upload Pelatihan'),
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
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    _showConfirmationDialog(context);
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
        ],
      ),
    );
  }
}
