import 'dart:convert'; // For base64 encoding
// import 'dart:typed_data'; // For Uint8List
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

final TextEditingController _namaSertifikasiController = TextEditingController();
final TextEditingController _noSertifikasiController = TextEditingController();

final List<String> _jenisSertifikasiOptions = ['Profesi', 'Keahlian'];
final List<String> _VendorOptions = ['Vendor A', 'Vendor B', 'Vendor C'];

String? _selectedJenisSertifikasi;
String? _selectedVendor;
String? _base64Image;

// URL dasar untuk API
String url_domain = "http://api:8000/";
String url_all_data = url_domain + "api/all_data";
String url_create_data = url_domain + "api/create_data";
String url_show_data = url_domain + "api/show_data";

class InputSertifikasi extends StatefulWidget {
  const InputSertifikasi({super.key, required this.title});
  final String title;

  @override
  State<InputSertifikasi> createState() => _InputSertifikasiState();
}

class _InputSertifikasiState extends State<InputSertifikasi> {
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
    Nama Sertifikasi: ${_namaSertifikasiController.text}
    No Sertifikasi: ${_noSertifikasiController.text}
    Jenis Sertifikasi: $_selectedJenisSertifikasi
    Vendor: $_selectedVendor
    ''';
    print(savedData);
  }

  @override
  void dispose() {
    _namaSertifikasiController.dispose();
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
              padding: const EdgeInsets.all(16.0).copyWith(bottom: 130.0), // Extra bottom padding to avoid overlap with background
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
                  const SizedBox(height: 16),
                  TextField(
                    controller: _namaSertifikasiController,
                    decoration: const InputDecoration(labelText: 'Nama Sertifikasi'),
                  ),
                  TextField(
                    controller: _noSertifikasiController,
                    decoration: const InputDecoration(labelText: 'No. Sertifikasi'),
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
                    decoration: const InputDecoration(labelText: 'Vendor'),
                  ),
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
                    decoration: const InputDecoration(labelText: 'Jenis Sertifikasi'),
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
          ),
        ],
      ),
    );
  }
}