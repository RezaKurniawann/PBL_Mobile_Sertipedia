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
//       title: 'Notifikasi',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0B2F9F)),
//         useMaterial3: true,
//       ),
//       home: const Statistik(title: 'SERTIPEDIA'),
//     );
//   }
// }

class Statistik extends StatefulWidget {
  const Statistik({super.key, required this.title});
  final String title;

  @override
  State<Statistik> createState() => _StatistikState();
}

class _StatistikState extends State<Statistik> {
  // bool _isVerifikasiExpanded = false; // Track the expanded state of the Verifikasi submenu

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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10), // Adjusting padding from top
            const Text(
              'SERTIFIKASI DAN PELATIHAN DOSEN JTI',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: Color(0xFF2F2175), // Customize the color accordingly
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 15), // Space between title and search bar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildInfoCard('PENGAJUAN', '15'),
                _buildInfoCard('DOSEN', '100'),
              ],
            ),
            const SizedBox(height: 20),
            _buildBarChartTitle('STATISTIK SERTIFIKASI TIAP PERIODE'),
            const SizedBox(height: 10),
            _buildBarChart(),
            const SizedBox(height: 20),
            _buildBarChartTitle('STATISTIK PELATIHAN TIAP PERIODE'),
            const SizedBox(height: 10),
            _buildBarChart(),
          ],
        ),
       ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String value) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.blue),
          ),
          const Icon(Icons.people, size: 32, color: Colors.blue),
        ],
      ),
    );
  }

  Widget _buildBarChartTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildBarChart() {
    return Container(
      height: 200,
      width: double.infinity,
      child: CustomPaint(
        painter: BarChartPainter(),
      ),
    );
  }
}

class BarChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2.0;

    // Draw x and y axis
    canvas.drawLine(Offset(0, size.height), Offset(size.width, size.height), paint);
    canvas.drawLine(Offset(0, 0), Offset(0, size.height), paint);

    // Draw bars
    final barPaint = Paint()..strokeWidth = 30.0;
    final barWidth = 30.0;
    final spaceBetweenBars = 30.0;
    final colors = [Colors.blue, Colors.yellow, Colors.green, Colors.red, Colors.orange];
    final barHeights = [60.0, 120.0, 90.0, 150.0, 110.0];

    for (int i = 0; i < colors.length; i++) {
      barPaint.color = colors[i];
      final x = (i * (barWidth + spaceBetweenBars)) + 40;
      final y = size.height - barHeights[i];
      canvas.drawRect(Rect.fromLTWH(x, y, barWidth, barHeights[i]), barPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
