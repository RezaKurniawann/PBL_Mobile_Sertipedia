import 'package:flutter/material.dart';

// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Dosen - Surat Tugas',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0B2F9F)),
//         useMaterial3: true,
//       ),
//     );
//   }
// }

class SuratTugasPage extends StatefulWidget {
  const SuratTugasPage({super.key, required this.title});
  final String title;

  @override
  State<SuratTugasPage> createState() => _SuratTugasPageState();
}

class _SuratTugasPageState extends State<SuratTugasPage> {
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
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Padding(padding: EdgeInsets.only(bottom: 30.0)),
                    const Text(
                      'PROFILE',
                      style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 40.0),
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          backgroundColor: const Color(0xFF0D6EFD),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () {
                          // Navigate to main page on button press

                        },
                        child: const Text(
                          "Download",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              child: Image.asset('assets/backgroundbuttom.png',fit: BoxFit.cover, width: double.infinity, height: 110),
            ),
          ],
        )
    );
  }
}
