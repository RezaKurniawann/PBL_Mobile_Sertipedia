

// URL dasar untuk API
String urlDomain = "http://192.168.30.165:8000/api/";

// URL-URL untuk endpoint API
String url_login = urlDomain + "login"; // Endpoint untuk login
String url_logout = urlDomain + "logout"; // Endpoint untuk logout

// Bidang Minat Routes
String url_bidangminats = urlDomain + "bidangminats"; // Mendapatkan daftar bidang minat
String url_bidangminat_show = urlDomain + "bidangminats/{bidangminat}"; // Menampilkan detail bidang minat
String url_bidangminat_create = urlDomain + "bidangminats/create"; // Menambahkan bidang minat
String url_bidangminat_update = urlDomain + "bidangminats/update/{bidangminat}"; // Memperbarui bidang minat
String url_bidangminat_delete = urlDomain + "bidangminats/delete/{bidangminat}"; // Menghapus bidang minat

// Kompetensi Routes
String url_kompetensis = urlDomain + "kompetensis"; // Mendapatkan daftar kompetensi
String url_kompetensi_show = urlDomain + "kompetensis/{kompetensi}"; // Menampilkan detail kompetensi

// Level Routes
String url_levels = urlDomain + "levels"; // Mendapatkan daftar level
String url_level_show = urlDomain + "levels/{level}"; // Menampilkan detail level

// Mata Kuliah Routes
String url_matakuliahs = urlDomain + "matakuliahs"; // Mendapatkan daftar mata kuliah
String url_matakuliah_show = urlDomain + "matakuliahs/{matakuliah}"; // Menampilkan detail mata kuliah

// Pelatihan Routes
String url_pelatihans = urlDomain + "pelatihans"; // Mendapatkan daftar pelatihan
String url_pelatihan_show = urlDomain + "pelatihans/{pelatihan}"; // Menampilkan detail pelatihan

// Prodi Routes
String url_prodis = urlDomain + "prodis"; // Mendapatkan daftar prodi
String url_prodi_show = urlDomain + "prodis/{prodi}"; // Menampilkan detail prodi

// Sertifikasi Routes
String url_sertifikasis = urlDomain + "sertifikasis"; // Mendapatkan daftar sertifikasi
String url_sertifikasi_show = urlDomain + "sertifikasis/{sertifikasi}"; // Menampilkan detail sertifikasi

// User Routes
String url_users = urlDomain + "users"; // Mendapatkan daftar pengguna
String url_user_show = urlDomain + "users/{user}"; // Menampilkan detail pengguna
String url_user_create = urlDomain + "users/create"; // Membuat pengguna baru
String url_user_update = urlDomain + "users/update/{user}"; // Memperbarui pengguna
String url_user_delete = urlDomain + "users/delete/{user}"; // Menghapus pengguna

// Vendor Routes
String url_vendors = urlDomain + "vendors"; // Mendapatkan daftar vendor
String url_vendor_show = urlDomain + "vendors/{vendor}"; // Menampilkan detail vendor

// Detail Pelatihan Routes
String url_d_pelatihans = urlDomain + "d_pelatihans"; // Mendapatkan daftar detail pelatihan
String url_d_pelatihan_show = urlDomain + "d_pelatihans/{d_pelatihan}"; // Menampilkan detail pelatihan

// Detail Sertifikasi Routes
String url_d_sertifikasis = urlDomain + "d_sertifikasis"; // Mendapatkan daftar detail sertifikasi
String url_d_sertifikasi_show = urlDomain + "d_sertifikasis/{d_sertifikasi}"; // Menampilkan detail sertifikasi

// Periode Routes
String url_periode = urlDomain + "periode"; // Mendapatkan daftar periode
String url_periode_show = urlDomain + "periode/{periode}"; // Menampilkan detail periode

