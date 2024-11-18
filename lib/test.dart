// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:flutter/services.dart';

// import 'package:dio/dio.dart';

// class InputPelatihan extends StatefulWidget {
//   const InputPelatihan({super.key, required this.title});
//   final String title;

//   @override
//   State<InputPelatihan> createState() => _InputPelatihanState();
// }

// class _InputPelatihanState extends State<InputPelatihan> {
//   String url_vendors = "http://192.168.1.14:8000/api/vendors";

//   // Variabel untuk menyimpan data Pelatihan
//   List<dynamic> vendorPelatihanList = [];
//   String? _selectedVendorPelatihan;

//   // Ambil data Pelatihan
//   Future<void> _fetchVendorPelatihan() async {
//     try {
//       final response = await Dio().get(url_vendors); // Menggunakan Dio untuk request GET
//       if (response.statusCode == 200) {
//         // Menyaring vendor yang memiliki kategori pelatihan
//         var vendors = response.data as List;
//         var filteredVendors = vendors.where((vendor) {
//           return vendor['kategori'] != null && vendor['kategori'].contains('Pelatihan');
//         }).toList();

//         setState(() {
//           vendorPelatihanList = filteredVendors; // Menyimpan data yang telah difilter
//         });
//       } else {
//         print("Gagal memuat data Pelatihan");
//       }
//     } catch (e) {
//       print("Error saat mengambil data Pelatihan: $e");
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     _fetchVendorPelatihan(); // Mengambil data Pelatihan saat widget diinisialisasi
//   }

//   final TextEditingController _namaPelatihanController = TextEditingController();
//   final TextEditingController _periodePelatihanController = TextEditingController();

//   final List<String> _levelPelatihanOptions = ['Nasional', 'Internasional'];
//   String? _selectedLevelPelatihan;

//   String? _base64Image;

//   Future<void> _uploadPhoto() async {
//     final ImagePicker picker = ImagePicker();
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text("Upload Photo"),
//           content: const Text("Choose your source"),
//           actions: <Widget>[
//             TextButton(
//               onPressed: () async {
//                 final XFile? pickedFile = await picker.pickImage(source: ImageSource.camera);
//                 if (pickedFile != null) {
//                   final bytes = await pickedFile.readAsBytes();
//                   setState(() {
//                     _base64Image = base64Encode(bytes);
//                   });
//                 }
//                 Navigator.of(context).pop();
//               },
//               child: const Text("Camera"),
//             ),
//             TextButton(
//               onPressed: () async {
//                 final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
//                 if (pickedFile != null) {
//                   final bytes = await pickedFile.readAsBytes();
//                   setState(() {
//                     _base64Image = base64Encode(bytes);
//                   });
//                 }
//                 Navigator.of(context).pop();
//               },
//               child: const Text("Gallery"),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _showConfirmationDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Konfirmasi'),
//           content: const Text('Apakah Anda yakin ingin menyimpan data?'),
//           actions: <Widget>[
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(); // Close the dialog
//               },
//               child: const Text('Batal'),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: const Text('Ya'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   void dispose() {
//     _namaPelatihanController.dispose();
//     _periodePelatihanController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF0B2F9F),
//         leading: Builder(
//           builder: (context) => IconButton(
//             icon: const Icon(Icons.menu),
//             color: Colors.white,
//             onPressed: () => Scaffold.of(context).openDrawer(),
//           ),
//         ),
//         titleSpacing: 0,
//         title: Row(
//           mainAxisAlignment: MainAxisAlignment.end,
//           children: [
//             Text(widget.title, // Gunakan title yang diteruskan dari route
//                 style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white)),
//             Padding(padding: EdgeInsets.only(right: 17.5)),
//           ],
//         ),
//       ),
//       drawer: const DrawerLayout(),
//       resizeToAvoidBottomInset: false,
//       body: Stack(
//         children: [
//           Align(
//             alignment: Alignment.bottomCenter,
//             child: Container(
//               height: 110, // Adjust as necessary for your image height
//               width: double.infinity,
//               child: Image.asset(
//                 'assets/backgroundbuttom.png',
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//           SingleChildScrollView(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 const Text(
//                   'Input Pelatihan',
//                   style: TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                     color: Color(0xFF0B2F9F),
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//                 const SizedBox(height: 16),
//                 TextField(
//                   controller: _namaPelatihanController,
//                   decoration: const InputDecoration(labelText: 'Nama Pelatihan'),
//                 ),
//                 // Use FutureBuilder to handle async data fetching
//                 FutureBuilder<void>(
//                   future: _fetchVendorPelatihan(),
//                   builder: (context, snapshot) {
//                     if (snapshot.connectionState == ConnectionState.waiting) {
//                       return const Center(child: CircularProgressIndicator()); // Loading indicator
//                     } else if (snapshot.hasError) {
//                       return Center(child: Text('Error: ${snapshot.error}'));
//                     } else {
//                       return DropdownButtonFormField<String>(
//                         value: _selectedVendorPelatihan,
//                         items: vendorPelatihanList.isNotEmpty
//                             ? vendorPelatihanList.map((vendor) {
//                                 return DropdownMenuItem<String>(
//                                   value: vendor['id_vendor'].toString(), // Convert to string here
//                                   child: Text(vendor['nama']),
//                                 );
//                               }).toList()
//                             : [DropdownMenuItem(child: Text('No vendors available'))],
//                         onChanged: (newValue) {
//                           setState(() {
//                             _selectedVendorPelatihan = newValue;
//                           });
//                         },
//                         decoration: const InputDecoration(labelText: 'Vendor Pelatihan'),
//                       );
//                     }
//                   },
//                 ),
//                 DropdownButtonFormField<String>(
//                   value: _selectedLevelPelatihan,
//                   items: _levelPelatihanOptions.map((String value) {
//                     return DropdownMenuItem<String>(
//                       value: value,
//                       child: Text(value),
//                     );
//                   }).toList(),
//                   onChanged: (newValue) {
//                     setState(() {
//                       _selectedLevelPelatihan = newValue;
//                     });
//                   },
//                   decoration: const InputDecoration(labelText: 'Level'),
//                 ),
//                 TextField(
//                   controller: _periodePelatihanController,
//                   keyboardType: TextInputType.number,
//                   inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//                   decoration: const InputDecoration(labelText: 'Periode'),
//                 ),
//                 const SizedBox(height: 16),
//                 ElevatedButton.icon(
//                   onPressed: _uploadPhoto,
//                   icon: const Icon(Icons.upload),
//                   label: const Text('Upload Pelatihan'),
//                 ),
//                 if (_base64Image != null)
//                   Padding(
//                     padding: const EdgeInsets.only(top: 16),
//                     child: Image.memory(
//                       base64Decode(_base64Image!),
//                       width: 150,
//                       height: 150,
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                 const SizedBox(height: 16),
//                 ElevatedButton(
//                   onPressed: () {
//                     _showConfirmationDialog(context); // Show confirmation dialog
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFF0B2F9F), // Button color
//                     foregroundColor: Colors.white, // Text color
//                   ),
//                   child: const Text('Simpan Pelatihan'),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }