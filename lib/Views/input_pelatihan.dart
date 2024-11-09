import 'dart:convert'; // For base64 encoding
// import 'dart:typed_data'; // For Uint8List
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Input Pelatihan',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0B2F9F)),
//         useMaterial3: true,
//       ),
//       home: const InputPelatihan(title: 'SERTIPEDIA'),
//     );
//   }
// }

class InputPelatihan extends StatefulWidget {
  const InputPelatihan({super.key, required this.title});
  final String title;

  @override
  State<InputPelatihan> createState() => _InputPelatihanState();
}

class _InputPelatihanState extends State<InputPelatihan> {
  DateTime? _selectedDate;
  final TextEditingController _namaPelatihanController =
      TextEditingController();

  // Dropdown options
  final List<String> _idMataKuliahOptions = ['MK001', 'MK002', 'MK003'];
  final List<String> _idBidangMinatOptions = ['BM001', 'BM002', 'BM003'];
  final List<String> _idPeriodeOptions = ['P2023', 'P2024', 'P2025'];
  final List<String> _jenisPelatihanOptions = ['DataScience', 'Jaringan'];
  final List<String> _idVendorOptions = ['V001', 'V002', 'V003'];
  final List<String> _levelPelatihanOptions = ['Nasional', 'Internal'];

  // Selected values for dropdowns
  String? _selectedIdMk;
  String? _selectedIdBidmin;
  String? _selectedIdPeriode;
  String? _selectedJenisPelatihan;
  String? _selectedVendor;
  String? _selectedLevelPelatihan;

  // Variable to store the base64-encoded image
  String? _base64Image;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2099),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
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

  void _saveData() {
    // Logic to save the data
    String savedData = '''
    Nama Pelatihan: ${_namaPelatihanController.text}
    Mata Kuliah: $_selectedIdMk
    Bidang Minat: $_selectedIdBidmin
    Periode: $_selectedIdPeriode
    Jenis Pelatihan: $_selectedJenisPelatihan
    Vendor: $_selectedVendor    
    Jenis Pelatihan: $_selectedLevelPelatihan
    Tanggal Pelaksanaan: $_selectedDate
    ''';
    print(savedData);
  }

  @override
  void dispose() {
    _namaPelatihanController.dispose();
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
      title: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Text(
            'SERTIPEDIA',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          const SizedBox(width: 20), // Optional padding for spacing
        ],
      ),
    ),
      body: SingleChildScrollView(
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
            const SizedBox(height: 16),
            TextField(
              controller: _namaPelatihanController,
              decoration: const InputDecoration(labelText: 'Nama Pelatihan'),
            ),
            DropdownButtonFormField<String>(
              value: _selectedIdMk,
              items: _idMataKuliahOptions.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedIdMk = newValue;
                });
              },
              decoration: const InputDecoration(labelText: 'ID Mata Kuliah'),
            ),
            DropdownButtonFormField<String>(
              value: _selectedIdBidmin,
              items: _idBidangMinatOptions.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedIdBidmin = newValue;
                });
              },
              decoration: const InputDecoration(labelText: 'ID Bidang Minat'),
            ),
            DropdownButtonFormField<String>(
              value: _selectedVendor,
              items: _idVendorOptions.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedVendor = newValue;
                });
              },
              decoration: const InputDecoration(labelText: 'ID Vendor'),
            ),
            DropdownButtonFormField<String>(
              value: _selectedIdPeriode,
              items: _idPeriodeOptions.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedIdPeriode = newValue;
                });
              },
              decoration: const InputDecoration(labelText: 'ID Periode'),
            ),
            DropdownButtonFormField<String>(
              value: _selectedJenisPelatihan,
              items: _jenisPelatihanOptions.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedJenisPelatihan = newValue;
                });
              },
              decoration: const InputDecoration(labelText: 'Jenis Pelatihan'),
            ),
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
              decoration: const InputDecoration(labelText: 'Kategori'),
            ),
            const SizedBox(height: 16),
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
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saveData,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0B2F9F), // Button color
                foregroundColor: Colors.white, // Text color
              ),
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}