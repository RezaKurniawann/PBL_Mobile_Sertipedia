import 'package:flutter/material.dart';
import 'package:sertipedia/Template/drawer.dart';

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
    {
      'No': '1',
      'Nama': 'Pemrograman Web',
      'Prodi': 'D4 - Sistem Informasi Bisnis'
    },
    {
      'No': '2',
      'Nama': 'Pemrograman Mobile',
      'Prodi': 'D4 - Teknik Informatika'
    },
    {'No': '3', 'Nama': 'Jaringan Komputer', 'Prodi': 'D2 - Fast Track'},
  ];

  // Function to filter data based on search query
  List<Map<String, String>> _getFilteredData() {
    if (_searchQuery.isEmpty) {
      return _data;
    } else {
      return _data.where((row) {
        return row.values.any((value) =>
            value.toLowerCase().contains(_searchQuery.toLowerCase()));
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
      drawer: const DrawerLayout(),
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
                        _searchQuery = value.toLowerCase();
                      });
                    },
                  ),
                ),
                const SizedBox(
                    height: 10), // Space between search bar and table
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
