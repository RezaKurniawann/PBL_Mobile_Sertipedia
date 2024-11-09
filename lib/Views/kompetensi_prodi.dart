import 'package:flutter/material.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Halaman KompetensiProdi',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0B2F9F)),
//         useMaterial3: true,
//       ),
//       home: const KompetensiProdi(title: 'SERTIPEDIA'),
//       routes: {
//         '/login': (context) => LoginPage(),
//         '/verifikasi_pelatihan': (context) => const VerifikasiPublikasi(title: 'SERTIPEDIA'),
//         '/verifikasi_sertifikasi': (context) => const VerifikasiSertifikasi(title: 'SERTIPEDIA'),
//         '/KompetensiProdi': (context) => const KompetensiProdi(title: 'SERTIPEDIA'),
//         '/homepage': (context) => const MyHomePage(title: 'SERTIPEDIA'),
//         '/download_surat': (context) => const SuratTugasPage(title: 'SERTIPEDIA'),
//         '/profile' : (context) => const ProfilePage(),
//         '/input_pelatihan' : (context) => const DaftarPelatihanPage(title: 'SERTIPEDIA'),
//         '/input_sertifikasi' : (context) => const DaftarSertifikasiPage(title: 'SERTIPEDIA'),
//       },
//     );
//   }
// }

class KompetensiProdi extends StatefulWidget {
  const KompetensiProdi({super.key, required this.title});
  final String title;

  @override
  State<KompetensiProdi> createState() => _KompetensiProdiState();
}

class _KompetensiProdiState extends State<KompetensiProdi> {
  String _searchQuery = ""; // Variable to hold search query

  // Updated data for the DataTable
  List<Map<String, String>> _data = [
    {'No': '1', 'Nama': 'Pemrograman Web', 'Prodi': 'D4 - Sistem Informasi Bisnis'},
    {'No': '2', 'Nama': 'Pemrograman Mobile', 'Prodi': 'D4 - Teknik Informatika'},
    {'No': '3', 'Nama': 'Jaringan Komputer', 'Prodi': 'D2 - Fast Track'},
  ];

  // Function to filter data based on search query
  List<Map<String, String>> _getFilteredData() {
    if (_searchQuery.isEmpty) {
      return _data;
    } else {
      return _data.where((row) {
        return row.values.any((value) => value.toLowerCase().contains(_searchQuery.toLowerCase()));
      }).toList();
    }
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
            Text(widget.title,
                style: const TextStyle(
                    fontWeight: FontWeight.w900, color: Colors.white)),
            const Padding(padding: EdgeInsets.only(right: 17.5)),
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
                title: const Text('Home', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/homepage');
                },
              ),
              ListTile(
                leading: const Icon(Icons.person, color: Colors.white),
                title: const Text('Profile', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/profile');
                },
              ),
              ListTile(
                leading: const Icon(Icons.bar_chart, color: Colors.white),
                title: const Text('Statistik', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/statistik');
                },
              ),
              ExpansionTile(
                leading: const Icon(Icons.check_circle, color: Colors.white),
                title: const Text('Verifikasi', style: TextStyle(color: Colors.white)),
                children: [
                  ListTile(
                    title: const Text('Sertifikasi', style: TextStyle(color: Colors.white)),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/verifikasi_sertifikasi');
                    },
                  ),
                  ListTile(
                    title: const Text('Pelatihan', style: TextStyle(color: Colors.white)),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/verifikasi_pelatihan');
                    },
                  ),
                ],
              ),
              ListTile(
                leading: const Icon(Icons.school, color: Colors.white),
                title: const Text('Kompetensi Prodi', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/kompetensi_prodi');
                },
              ),
              ExpansionTile(
                leading: const Icon(Icons.workspace_premium, color: Colors.white),
                title: const Text('Input Data', style: TextStyle(color: Colors.white)),
                children: [
                  ListTile(
                    title: const Text('Sertifikasi', style: TextStyle(color: Colors.white)),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/input_sertifikasi');
                    },
                  ),
                  ListTile(
                    title: const Text('Pelatihan', style: TextStyle(color: Colors.white)),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/input_pelatihan');
                    },
                  ),
                ],
              ),
              ListTile(
                leading: const Icon(Icons.notifications_active, color: Colors.white),
                title: const Text('Notifikasi', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/notifikasi');
                },
              ),
              ListTile(
                leading: const Icon(Icons.file_download, color: Colors.white), // Icon for Download Surat
                title: const Text('Download Surat', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/surat_tugas'); // Navigate to Login on logout
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.white),
                title: const Text('Logout', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/login'); // Navigate to Login on logout
                },
              ),
            ],
          ),
        ),
      ),
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
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
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'Kompetensi Prodi',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0B2F9F),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value; // Update the search query
                      });
                    },
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      hintText: 'Search',
                      filled: true,
                      fillColor: Colors.grey[300],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10), // Space between search bar and table
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('No')),
                        DataColumn(label: Text('Nama')),
                        DataColumn(label: Text('Prodi')),
                      ],
                      rows: _getFilteredData().map((row) {
                        return DataRow(cells: [
                          DataCell(Text(row['No']!)),
                          DataCell(Text(row['Nama']!)),
                          DataCell(Text(row['Prodi']!)),
                        ]);
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
