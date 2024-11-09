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
//       title: 'Halaman Verifikasi Pelatihan',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0B2F9F)),
//         useMaterial3: true,
//       ),
//       home: const VerifikasiPelatihan(title: 'SERTIPEDIA'),
//       routes: {
//         '/login': (context) => LoginPage(),
//         '/verifikasi_pelatihan': (context) => const VerifikasiPelatihan(title: 'SERTIPEDIA'),
//         '/verifikasi_sertifikasi': (context) => const VerifikasiSertifikasi(title: 'SERTIPEDIA'),
//         '/history': (context) => const History(title: 'SERTIPEDIA'),
//         '/homepage': (context) => const MyHomePage(title: 'SERTIPEDIA'),
//         '/download_surat': (context) => const SuratTugasPage(title: 'SERTIPEDIA'),
//         '/profile' : (context) => const ProfilePage(),
//         '/input_pelatihan' : (context) => const DaftarPelatihanPage(title: 'SERTIPEDIA'),
//         '/input_sertifikasi' : (context) => const DaftarSertifikasiPage(title: 'SERTIPEDIA'),
//       },
//     );
//   }
// }


// class NewPage extends StatelessWidget {
//   const NewPage({super.key, required this.title});
//   final String title;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(title),
//       ),
//       body: Center(
//         child: Text('Ini adalah halaman baru!'),
//       ),
//     );
//   }
// }

class VerifikasiPelatihan extends StatefulWidget {
  const VerifikasiPelatihan({super.key, required this.title});
  final String title;

  @override
  State<VerifikasiPelatihan> createState() => _VerifikasiPelatihanState();
}

class _VerifikasiPelatihanState extends State<VerifikasiPelatihan> {
  List<Map<String, String>> items = [
    {'no': '1', 'nama': 'Nama Dosen S.T, M.T', 'bidang': 'Data Science', 'penyelenggara': 'Gobelins Paris', 'durasi': '12'},
    {'no': '2', 'nama': 'Nama Dosen S.T, M.T', 'bidang': 'Web Development', 'penyelenggara': 'Harvard University', 'durasi': '8'},
    {'no': '3', 'nama': 'Nama Dosen S.T, M.T', 'bidang': 'Mobile Development', 'penyelenggara': 'Stanford University', 'durasi': '10'},
  ];

  String searchQuery = '';

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
              style: const TextStyle(
                  fontWeight: FontWeight.w900, color: Colors.white),
            ),
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
                        'Verifikasi Pengajuan',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0B2F9F),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        'Pelatihan',
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
                // Search bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'search...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      fillColor: Colors.grey[300],
                      filled: true,
                    ),
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value.toLowerCase();
                      });
                    },
                  ),
                ),
                // Adding the table below the title
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('No')),
                        DataColumn(label: Text('Nama Dosen')),
                        DataColumn(label: Text('Bidang')),
                        DataColumn(label: Text('Penyelenggara')),
                        DataColumn(label: Text('Durasi Pelaksanaan')),
                        DataColumn(label: Text('Detail')),
                      ],
                      rows: items
                          .where((item) =>
                      item['bidang']!.toLowerCase().contains(searchQuery) ||
                          item['penyelenggara']!.toLowerCase().contains(searchQuery))
                          .map((item) {
                        return DataRow(cells: [
                          DataCell(Text(item['no']!)),
                          DataCell(Text(item['nama']!)),
                          DataCell(Text(item['bidang']!)),
                          DataCell(Text(item['penyelenggara']!)),
                          DataCell(Text(item['durasi']!)),
                          DataCell(
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF0d6efd),
                                      Color(0xFF4576fd),
                                      Color(0xFF607ffc),
                                      Color(0xFF74888fc),
                                      Color(0xFF8691fc),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: TextButton(
                                  onPressed: () {
                                    // Add your detail page navigation logic here
                                  },
                                  child: const Text(
                                    'Detail',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
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
