import 'package:flutter/material.dart';
import 'package:sertipedia/Routes/routes_general.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Halaman Login',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0B2F9F)),
        useMaterial3: true,
      ),
      home: const LoginPage(),
      routes: {
        '/login': (context) => const LoginPage(),
        '/verifikasi_pelatihan': (context) => const VerifikasiPelatihan(title: 'SERTIPEDIA'),
        '/verifikasi_sertifikasi': (context) => const VerifikasiSertifikasi(title: 'SERTIPEDIA'),
        '/notifikasi': (context) => const Notifikasi (title: 'SERTIPEDIA'),
        '/homepage': (context) => const HomePage (title: 'SERTIPEDIA'),
        '/profile': (context) => const Profile (title: 'SERTIPEDIA'),
        '/statistik': (context) => const Statistik (title: 'SERTIPEDIA'),
        '/kompetensi_prodi': (context) => const KompetensiProdi (title: 'SERTIPEDIA'),
        '/surat_tugas': (context) => const SuratTugasPage (title: 'SERTIPEDIA'),
        '/input_pelatihan': (context) => const InputPelatihan (title: 'SERTIPEDIA'),
        '/input_sertifikasi': (context) => const InputSertifikasi (title: 'SERTIPEDIA'),
      },
    );
  }
}