import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sertipedia/Template/drawer.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sertipedia',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(title: 'Dosen Jurusan Teknologi Informasi'),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

//ingga

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> lecturers = [];
  List<Map<String, dynamic>> prodis = [];
  List<Map<String, dynamic>> bidangMinats = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      await Future.wait([fetchProdis(), fetchBidangMinats()]);
      await fetchLecturers();
    } catch (e) {
      setState(() {
        errorMessage = 'Terjadi kesalahan: $e';
        isLoading = false;
      });
    }
  }

  Future<void> fetchProdis() async {
    const String apiUrl = "http://192.168.30.165:8000/api/prodis";
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        setState(() {
          prodis = data.map((item) {
            return {'id': item['id'], 'name': item['nama']};
          }).toList();
        });
      } else {
        throw 'Gagal memuat data Prodi: ${response.statusCode}';
      }
    } catch (e) {
      throw 'Gagal memuat data Prodi: $e';
    }
  }

  Future<void> fetchBidangMinats() async {
    const String apiUrl = "http://192.168.30.165:8000/api/bidangminats";
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        setState(() {
          bidangMinats = data.map((item) {
            return {'id': item['id'], 'name': item['nama']};
          }).toList();
        });
      } else {
        throw 'Gagal memuat data Bidang Minat: ${response.statusCode}';
      }
    } catch (e) {
      throw 'Gagal memuat data Bidang Minat: $e';
    }
  }

  Future<void> fetchLecturers() async {
    const String apiUrl = "http://192.168.30.165:8000/api/users";
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        setState(() {
          lecturers = data.map((user) {
            final bidangMinat = bidangMinats.firstWhere(
              (bm) => bm['id'] == user['id_bidangminat'],
              orElse: () => {'name': 'Tidak diketahui'},
            );
            final prodi = prodis.firstWhere(
              (pr) => pr['id_prodi'] == user['id_prodi'],
              orElse: () => {'name': 'Tidak diketahui'},
            );
            return {
              'id': user['id'],
              'name': user['nama'],
              'prodi': prodi['nama'],
              'bidangMinat': bidangMinat['nama'],
              'matakuliahs': user['mata_kuliahs']?.join(', ') ?? '',
              'image': user['image'] ?? '',  // Ensure image URL is safely handled
              'sertifikasis': user['sertifikasis']?.length ?? 0,
              'pelatihans': user['pelatihans']?.length ?? 0,
            };
          }).toList();
          isLoading = false;
        });
      } else {
        throw 'Gagal memuat data Dosen: ${response.statusCode}';
      }
    } catch (e) {
      throw 'Gagal memuat data Dosen: $e';
    }
  }

  void showLecturerDetail(BuildContext context, Map<String, dynamic> lecturer) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: lecturer['image'] != null && lecturer['image'] != ''
                      ? Image.network(
                          lecturer['image'],
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        )
                      : const Icon(Icons.person, size: 100),
                ),
                const SizedBox(height: 10),
                Text(
                  lecturer['name'] ?? 'Nama tidak tersedia',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const SizedBox(height: 10),
                Text('Prodi: ${lecturer['prodi']}'),
                Text('Bidang Minat: ${lecturer['bidangMinat']}'),
                Text('Matakuliah: ${lecturer['matakuliahs']}'),
                Text('Jumlah Sertifikasi: ${lecturer['sertifikasis']}'),
                Text('Jumlah Pelatihan: ${lecturer['pelatihans']}'),
              ],
            ),
          ),
        );
      },
    );
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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : buildLecturersList(),
    );
  }

  Widget buildLecturersList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: lecturers.length,
      itemBuilder: (context, index) {
        final lecturer = lecturers[index];
        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: lecturer['image'] != ''
                  ? NetworkImage(lecturer['image'])
                  : const AssetImage('assets/default_image.png')
                      as ImageProvider,
              radius: 30,
            ),
            title: Text(
              lecturer['name'],
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Prodi: ${lecturer['prodi']}'),
                Text('Bidang Minat: ${lecturer['bidangMinat']}'),
              ],
            ),
            trailing: ElevatedButton(
              onPressed: () => showLecturerDetail(context, lecturer),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0B2F9F),
                foregroundColor: Colors.white,
              ),
              child: const Text('Detail'),
            ),
          ),
        );
      },
    );
  }
}
