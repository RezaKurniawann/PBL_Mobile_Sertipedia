import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:sertipedia/Template/drawer.dart';

class KompetensiProdi extends StatefulWidget {
  const KompetensiProdi({super.key, required this.title});
  final String title;

  @override
  State<KompetensiProdi> createState() => _KompetensiProdiState();
}

class _KompetensiProdiState extends State<KompetensiProdi> {
  String _searchQuery = ""; // Variable to hold search query
  List<Map<String, String>> _data = []; // Data fetched from API
  Map<String, String> _prodiMap = {}; // Map to store prodi data with id_prodi as key
  bool _isLoading = true; // Loading state
  bool _hasError = false; // Error state

  // Fetch data from API
  Future<void> _fetchData() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.0.238:8000/api/kompetensis'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body) as List<dynamic>;
        setState(() {
          _data = jsonData.map((item) {
            return {
              'No': item['id_kompetensi'].toString(),
              'Nama': item['nama'].toString(),
              'Prodi': item['id_prodi'].toString(),
            };
          }).toList();
          _isLoading = false;
        });
        print("Data fetched successfully: $_data");
      } else {
        setState(() {
          _hasError = true;
          _isLoading = false;
        });
        print("Error: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
      print("Exception: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchData(); // Fetch data when the widget is initialized
  }

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
              'assets/backgroundbuttom.png',
              fit: BoxFit.cover,
              height: 110,
            ),
          ),
          Center(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Kompetensi Prodi',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0B2F9F),
                    ),
                    textAlign: TextAlign.center,
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
                const SizedBox(height: 10),
                _isLoading
                    ? const CircularProgressIndicator()
                    : _hasError
                        ? const Text(
                            'Error fetching data',
                            style: TextStyle(color: Colors.red),
                          )
                        : Expanded(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: DataTable(
                                  headingRowColor: MaterialStateColor.resolveWith(
                                    (states) => const Color(0xFF0B2F9F),
                                  ),
                                  headingTextStyle: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
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
                          ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
