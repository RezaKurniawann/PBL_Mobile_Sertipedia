import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'package:sertipedia/Template/drawer.dart';
import 'package:sertipedia/Api/api_services.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InputSertifikasi extends StatefulWidget {
  const InputSertifikasi({super.key, required this.title});
  final String title;

  @override
  State<InputSertifikasi> createState() => _InputSertifikasiState();
}

class _InputSertifikasiState extends State<InputSertifikasi> {
  int _idUser = 0;

  List<dynamic> vendorSertifikasiList = [];
  List<dynamic> sertifikasiList = [];
  List<dynamic> detailSertifikasiList = [];
  List<dynamic> periodeList = [];

  final List<String> _jenisSertifikasiOptions = ['Profesi', 'Keahlian'];

  String? _selectedVendorSertifikasi;
  String? _selectedSertifikasi;
  String? _selectedDetailSertifikasi;
  String? _selectedPeriodeSertifikasi;
  String? _selectedJenisSertifikasi;
  String? _base64Image;

  final TextEditingController _sertifikasiSearchController =
      TextEditingController();
  final TextEditingController _vendorSearchController = TextEditingController();
  final TextEditingController _noSertifikasiController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchVendorSertifikasi();
    _fetchSertifikasi();
    _fetchDetailSertifikasi();
    _fetchPeriodeList();
    _loadIdUser();
  }

  Future<void> _loadIdUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _idUser = prefs.getInt('id_user') ?? 0;
    });
  }

  // Ambil data Pelatihan
  Future<void> _fetchVendorSertifikasi() async {
    try {
      final response = await Dio().get(url_vendors);
      if (response.statusCode == 200) {
        var vendors = response.data as List;
        var filteredVendors = vendors.where((vendor) {
          return vendor['kategori'] != null &&
              vendor['kategori'].contains('Sertifikasi');
        }).toList();

        setState(() {
          vendorSertifikasiList = filteredVendors;
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
      final response = await Dio().get(url_sertifikasis);
      if (response.statusCode == 200) {
        setState(() {
          sertifikasiList = response.data as List;
        });
      } else {
        print("Gagal memuat data sertifikasi");
      }
    } catch (e) {
      print("Error saat mengambil data sertifikasi: $e");
    }
  }

  Future<void> _fetchDetailSertifikasi() async {
    try {
      final response = await Dio().get(url_d_sertifikasis);
      if (response.statusCode == 200) {
        setState(() {
          detailSertifikasiList = response.data as List;
        });
      } else {
        print("Gagal memuat data Sertiifkasi");
      }
    } catch (e) {
      print("Error saat mengambil data Sertifikasi: $e");
    }
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

  Future<void> _updateDatatoServer() async {
    if (_base64Image != null && _selectedDetailSertifikasi != null) {
      try {
        final url =
            url_d_sertifikasi_update + _selectedDetailSertifikasi.toString();
        final response = await Dio().put(
          url,
          data: {
            'no_sertifikasi': _noSertifikasiController.text,
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
        const SnackBar(content: Text('Belum memasukkan gambar!')),
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
                Navigator.of(context).pop();
              },
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _updateDatatoServer();
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
      final vendor = vendorSertifikasiList.firstWhere(
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

  Future<int?> _getIdSertifikasi(
      int idVendor, int idPeriode, String namaSertifikasi, String level) async {
    try {
      final sertifikasi = sertifikasiList.firstWhere(
        (p) =>
            p['id_vendor'] == idVendor &&
            p['id_periode'] == idPeriode &&
            p['nama'].toString().toLowerCase() ==
                namaSertifikasi.toLowerCase() &&
            p['jenis_sertifikasi'].toString().toLowerCase() ==
                level.toLowerCase(),
        orElse: () => null,
      );
      return sertifikasi != null ? sertifikasi['id_sertifikasi'] : null;
    } catch (e) {
      print("Error saat mencari id_sertifikasi: $e");
      return null;
    }
  }

  Future<int?> _getIdDetailSertifikasi(int idUser, int idSertifikasi) async {
    try {
      final detailSertifikasi = detailSertifikasiList.firstWhere(
        (p) => p['id_user'] == idUser && p['id_sertifikasi'] == idSertifikasi,
        orElse: () => null,
      );
      return detailSertifikasi != null
          ? detailSertifikasi['id_detail_sertifikasi']
          : null;
    } catch (e) {
      print("Error saat mencari id_detail_sertifikasi: $e");
      _showAlertDialog(context, "Error saat mencari id_detail_sertifikasi");
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
    _sertifikasiSearchController.dispose();
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
              padding: const EdgeInsets.all(16.0),
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
                      return sertifikasiList
                          .where((sertifikasi) => sertifikasi['nama']
                              .toString()
                              .toLowerCase()
                              .contains(textEditingValue.text.toLowerCase()))
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
                          labelText: 'Nama Sertifikasi',
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _noSertifikasiController,
                    decoration: const InputDecoration(
                      labelText: 'No Sertifikasi',
                    ),
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
                    decoration: const InputDecoration(labelText: 'Level'),
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: _selectedPeriodeSertifikasi,
                    items: periodeList.map((periode) {
                      return DropdownMenuItem<String>(
                        value: periode['tahun'],
                        child: Text(periode['tahun']),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedPeriodeSertifikasi = newValue;
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
                      int? idVendor =
                          await _getIdVendor(_selectedVendorSertifikasi ?? '');
                     
                      if (_noSertifikasiController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('No Sertifikasi belum diisi!'),
                          ),
                        );
                        return;
                      }

                      if (idVendor == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Vendor tidak ditemukan!')),
                        );
                        return;
                      }

                      int? idPeriode = await _getIdPeriode(
                          _selectedPeriodeSertifikasi ?? '');
                      print('id periode : $idPeriode');
                      if (idPeriode == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Periode tidak ditemukan!')),
                        );
                        return;
                      }

                      int? idSertifikasi = await _getIdSertifikasi(
                          idVendor,
                          idPeriode,
                          _selectedSertifikasi ?? '',
                          _selectedJenisSertifikasi ?? '');
                      print("id sertifiki : $idSertifikasi");

                      if (idSertifikasi == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content:
                                  Text('Nama sertifikasi tidak ditemukan!')),
                        );
                        return;
                      }

                      int? idDetailSertifikasi =
                          await _getIdDetailSertifikasi(_idUser, idSertifikasi);
                      print('id detail sertifikasi : $idDetailSertifikasi');
                      if (idDetailSertifikasi == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content:
                                  Text('Detail Sertifikasi tidak ditemukan!')),
                        );
                        return;
                      }

                      setState(() {
                        _selectedDetailSertifikasi =
                            idDetailSertifikasi.toString();
                      });

                      print("image: $_base64Image");
                      print(
                          "ID Detail Sertifikasi: $_selectedDetailSertifikasi");

                      _showConfirmationDialog(context);
                    },
                    child: const Text('Simpan Sertifikasi'),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
