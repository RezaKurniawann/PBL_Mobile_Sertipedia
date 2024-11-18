import 'package:flutter/material.dart';
import 'package:sertipedia/Template/drawer.dart';

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
      drawer: const DrawerLayout(),
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
            style: const TextStyle(
                fontSize: 32, fontWeight: FontWeight.bold, color: Colors.blue),
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
    canvas.drawLine(
        Offset(0, size.height), Offset(size.width, size.height), paint);
    canvas.drawLine(Offset(0, 0), Offset(0, size.height), paint);

    // Draw bars
    final barPaint = Paint()..strokeWidth = 30.0;
    final barWidth = 30.0;
    final spaceBetweenBars = 30.0;
    final colors = [
      Colors.blue,
      Colors.yellow,
      Colors.green,
      Colors.red,
      Colors.orange
    ];
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
