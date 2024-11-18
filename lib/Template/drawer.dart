import 'package:flutter/material.dart';

class DrawerLayout extends StatelessWidget {
  const DrawerLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
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
              title:
                  const Text('Profile', style: TextStyle(color: Colors.white)),
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
              leading: const Icon(Icons.workspace_premium, color: Colors.white),
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
    );
  }
}
