import 'dart:convert';
// import 'dart:typed_data'; // For Uint8List
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'package:sertipedia/Template/drawer.dart';
import 'package:sertipedia/Api/api_services.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InputPelatihan extends StatefulWidget {
  const InputPelatihan({super.key, required this.title});
  final String title;

  @override
  State<InputPelatihan> createState() => _InputPelatihanState();
}

class _InputPelatihanState extends State<InputPelatihan> {
  int _idUser = 0;

  List<dynamic> vendorPelatihanList = [];
  List<dynamic> pelatihanList = [];
  List<dynamic> detailPelatihanList = [];
  List<dynamic> periodeList = [];

  final List<String> _levelPelatihanOptions = ['Nasional', 'Internasional'];

  String? _selectedVendorPelatihan;
  String? _selectedPelatihan;
  String? _selectedDetailPelatihan;
  String? _selectedPeriodePelatihan;
  String? _selectedLevelPelatihan;
  String? _base64Image;

  final TextEditingController _pelatihanSearchController =
      TextEditingController();
  final TextEditingController _vendorSearchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchVendorPelatihan();
    _fetchPelatihan();
    _fetchDetailPelatihan();
    _fetchPeriodeList();
    _loadIdUser();
  }

  Future<void> _loadIdUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _idUser = prefs.getInt('id_user') ?? 0;
    });
  }

  Future<void> _fetchPeriodeList() async {
    try {
      final response = await Dio().get(url_periode); // Make the API call
      if (response.statusCode == 200) {
        setState(() {
          periodeList =
              response.data as List; // Store the periods in periodeList
        });
      } else {
        print("Gagal memuat data Periode");
      }
    } catch (e) {
      print("Error saat mengambil data Periode: $e");
    }
  }

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

  Future<void> _fetchPelatihan() async {
    try {
      final response =
          await Dio().get(url_pelatihans); // URL API untuk pelatihan
      if (response.statusCode == 200) {
        setState(() {
          pelatihanList = response.data as List; // Simpan semua field
        });
      } else {
        print("Gagal memuat data Pelatihan");
      }
    } catch (e) {
      print("Error saat mengambil data Pelatihan: $e");
    }
  }

  Future<void> _fetchDetailPelatihan() async {
    try {
      final response = await Dio().get(url_d_pelatihans);
      if (response.statusCode == 200) {
        setState(() {
          detailPelatihanList = response.data as List;
        });
      } else {
        print("Gagal memuat data Pelatihan");
      }
    } catch (e) {
      print("Error saat mengambil data Pelatihan: $e");
    }
  }

  Future<void> _updateImageToServer() async {
    if (_base64Image != null && _selectedDetailPelatihan != null) {
      try {
        final url =
            url_d_pelatihan_update + _selectedDetailPelatihan.toString();
        final response = await Dio().put(
          url,
          data: {
            'image': _base64Image,
          },
        );
        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Data berhasil diupload!')),
          );

        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Data gagal diupload!')),
          );
        }
      } catch (e) {
        print('Error: $e');
        // Display an error message if an exception occurs
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('Belum memasukkan gambar!')),
      );
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
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog
                // Call the function to update the image
                await _updateImageToServer();
                // Optionally, show a success message to the user
                // ScaffoldMessenger.of(context).showSnackBar(
                //   const SnackBar(content: Text('Image updated successfully!')),
                // );
              },
              child: const Text('Ya'),
            ),
          ],
        );
      },
    );
  }

  Future<int?> _getIdVendor(String namaVendor) async {
    try {
      final vendor = vendorPelatihanList.firstWhere(
        (v) => v['nama'].toString().toLowerCase() == namaVendor.toLowerCase(),
        orElse: () => null,
      );
      return vendor != null ? vendor['id_vendor'] : null;
    } catch (e) {
      print("Error saat mencari id_vendor: $e");
      return null;
    }
  }

  Future<int?> _getIdPeriode(String tahun) async {
    try {
      final periode = periodeList.firstWhere(
        (p) => p['tahun'].toString().toLowerCase() == tahun.toLowerCase(),
        orElse: () => null,
      );
      return periode != null ? periode['id_periode'] : null;
    } catch (e) {
      print("Error saat mencari id_periode: $e");
      return null;
    }
  }

  Future<int?> _getIdPelatihan(
      int idVendor, int idPeriode, String namaPelatihan, String level) async {
    try {
      final pelatihan = pelatihanList.firstWhere(
        (p) =>
            p['id_vendor'] == idVendor &&
            p['id_periode'] == idPeriode &&
            p['nama'].toString().toLowerCase() == namaPelatihan.toLowerCase() &&
            p['level_pelatihan'].toString().toLowerCase() ==
                level.toLowerCase(),
        orElse: () => null,
      );
      return pelatihan != null ? pelatihan['id_pelatihan'] : null;
    } catch (e) {
      print("Error saat mencari id_pelatihan: $e");
      return null;
    }
  }

  Future<int?> _getIdDetailPelatihan(int idUser, int idPelatihan) async {
    try {
      final detailPelatihan = detailPelatihanList.firstWhere(
        (p) => p['id_user'] == idUser && p['id_pelatihan'] == idPelatihan,
        orElse: () => null,
      );
      return detailPelatihan != null
          ? detailPelatihan['id_detail_pelatihan']
          : null;
    } catch (e) {
      print("Error saat mencari id_detail_pelatihan: $e");
      _showAlertDialog(context, "Error saat mencari id_detail_pelatihan");
      return null;
    }
  }

  void _showAlertDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Peringatan"),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
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
                    return pelatihanList
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
                DropdownButtonFormField<String>(
                  value: _selectedPeriodePelatihan,
                  items: periodeList.map((periode) {
                    return DropdownMenuItem<String>(
                      value: periode['tahun'],
                      child: Text(periode['tahun']),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedPeriodePelatihan = newValue;
                    });
                  },
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
                  onPressed: () async {
                    int? idVendor = await _getIdVendor(_selectedVendorPelatihan ?? '');

                    if (idVendor == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content:
                            Text('Vendor tidak ditemukan!')),
                      );
                      return;
                    }

                    int? idPeriode = await _getIdPeriode(_selectedPeriodePelatihan ?? '');
                    if (idPeriode == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content:
                            Text('Periode tidak ditemukan!')),
                      );
                      return;
                    }

                    int? idPelatihan = await _getIdPelatihan(
                        idVendor,
                        idPeriode,
                        _selectedPelatihan ?? '',
                        _selectedLevelPelatihan ?? '');
                    if (idPelatihan == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content:
                            Text('Nama pelatihan tidak ditemukan!')),
                      );
                      return;
                    }

                    int? idDetailPelatihan = await _getIdDetailPelatihan(_idUser, idPelatihan);
                    if (idDetailPelatihan == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content:
                            Text('Pelatihan tidak ditemukan!')),
                      );
                      return;
                    }

                    setState(() {
                      _selectedDetailPelatihan = idDetailPelatihan.toString();
                    });

                    print("image: $_base64Image");
                    print("ID Detail Pelatihan: $_selectedDetailPelatihan");

                    _showConfirmationDialog(context);
                  },
                  child: const Text('Simpan Pelatihan'),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
