import 'dart:convert'; // For base64 encoding
// import 'dart:typed_data'; // For Uint8List
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';


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
  final TextEditingController _waktuPelatihanController =
  TextEditingController();

  // Dropdown options
  final List<String> _levelPelatihanOptions = ['Nasional', 'Internasional'];
  final List<String> _VendorOptions = ['Vendor A', 'Vendor B', 'Vendor C'];

  // Selected values for dropdowns
  String? _selectedLevelPelatihan;
  String? _selectedVendor;

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
                _saveData(); // Call the save function
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Ya'),
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
    Waktu: ${_waktuPelatihanController.text}
    Level Pelatihan: $_selectedLevelPelatihan
    Vendor: $_selectedVendor
    Tanggal Pelaksanaan: $_selectedDate
    ''';
    print(savedData);
  }

  @override
  void dispose() {
    _namaPelatihanController.dispose();
    _waktuPelatihanController.dispose();
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
          children: const [
            Text('SERTIPEDIA',
                style: TextStyle(
                    fontWeight: FontWeight.w900, color: Colors.white)),
            Padding(padding: EdgeInsets.only(right: 17.5)),
          ],
        ),
      ),
      drawer: Drawer(
        child: Container(
          color: const Color(0xFF0B2F9F),
          child: ListView(
            padding: const EdgeInsets.only(top: 0),
            children: <Widget>[
              SizedBox(
                height: 89,
                child: DrawerHeader(
                  decoration: const BoxDecoration(
                    color: Color(0xFF0B2F9F),
                  ),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 0),
                      child: IconButton(
                        icon: const Icon(Icons.menu, color: Colors.white),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.home, color: Colors.white),
                title:
                const Text('Home', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/homepage');
                },
              ),
              ListTile(
                leading: const Icon(Icons.person, color: Colors.white),
                title: const Text('Profile',
                    style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/profile');
                },
              ),
              ListTile(
                leading: const Icon(Icons.bar_chart, color: Colors.white),
                title: const Text('Statistik',
                    style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/statistik');
                },
              ),
              ExpansionTile(
                leading: const Icon(Icons.check_circle, color: Colors.white),
                title: const Text('Verifikasi',
                    style: TextStyle(color: Colors.white)),
                children: [
                  ListTile(
                    title: const Text('Sertifikasi',
                        style: TextStyle(color: Colors.white)),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/verifikasi_sertifikasi');
                    },
                  ),
                  ListTile(
                    title: const Text('Pelatihan',
                        style: TextStyle(color: Colors.white)),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/verifikasi_pelatihan');
                    },
                  ),
                ],
              ),
              ListTile(
                leading: const Icon(Icons.school, color: Colors.white),
                title: const Text('Kompetensi Prodi',
                    style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/kompetensi_prodi');
                },
              ),
              ExpansionTile(
                leading:
                const Icon(Icons.workspace_premium, color: Colors.white),
                title: const Text('Input Data',
                    style: TextStyle(color: Colors.white)),
                children: [
                  ListTile(
                    title: const Text('Sertifikasi',
                        style: TextStyle(color: Colors.white)),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/input_sertifikasi');
                    },
                  ),
                  ListTile(
                    title: const Text('Pelatihan',
                        style: TextStyle(color: Colors.white)),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/input_pelatihan');
                    },
                  ),
                ],
              ),
              ListTile(
                leading:
                const Icon(Icons.notifications_active, color: Colors.white),
                title: const Text('Notifikasi',
                    style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/notifikasi');
                },
              ),
              ListTile(
                leading: const Icon(Icons.file_download,
                    color: Colors.white), // Icon for Download Surat
                title: const Text('Download Surat',
                    style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(
                      context, '/surat_tugas'); // Navigate to Login on logout
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.white),
                title:
                const Text('Logout', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(
                      context, '/login'); // Navigate to Login on logout
                },
              ),
            ],
          ),
        ),
      ),
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
                const SizedBox(height: 16),
                TextField(
                  controller: _namaPelatihanController,
                  decoration: const InputDecoration(labelText: 'Nama Pelatihan'),
                ),
                TextField(
                  controller: _waktuPelatihanController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(labelText: 'Waktu Pelatihan'),
                ),
                DropdownButtonFormField<String>(
                  value: _selectedVendor,
                  items: _VendorOptions.map((String value) {
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
                  decoration: const InputDecoration(labelText: 'Vendor Pelatihan'),
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
                  decoration: const InputDecoration(labelText: 'Level Pelatihan'),
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
                  onPressed: () {
                    _showConfirmationDialog(context); // Show confirmation dialog
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