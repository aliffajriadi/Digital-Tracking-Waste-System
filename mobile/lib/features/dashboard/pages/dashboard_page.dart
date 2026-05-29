import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mobile/features/input/pages/select_input.dart';
import 'package:mobile/features/settings/widgets/notification/notification_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String _namaPetugas = "Memuat...";
  String? _fotoProfil; // Menyimpan URL/path foto profil dari database user
  List<dynamic> _kategoriSampah = []; 
  List<dynamic> _riwayatHariIni = []; // Menyimpan data riwayat dari tabel waste_entry
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchDashboardData();
  }

  Future<void> _fetchDashboardData() async {
    try {
      setState(() => _isLoading = true);
      
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var userNikRaw = prefs.get('user_nik') ?? prefs.get('nik') ?? '';
      String nik = userNikRaw.toString();

      // Pastikan backend mengembalikan data 'user_photo' dan 'recent_entries' hari ini
      String url = "http://192.168.1.9:8000/api/dashboard-data?nik=$nik"; 

      final response = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 4)); 
      
      if (!mounted) return;

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        if (data['success'] == true) {
          setState(() {
            _namaPetugas = data['full_name'].toString();
            // Ambil path foto profil user (misal: "profiles/avatar1.png")
            _fotoProfil = data['user_photo']; 
            _kategoriSampah = data['categories'] ?? []; 
            // Ambil array data inputan dari tabel waste_entry hari ini
            _riwayatHariIni = data['recent_entries'] ?? []; 
            _isLoading = false;
          });
        } else {
          setState(() {
            _namaPetugas = data['message'] ?? "Nama Tidak Ditemukan";
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _namaPetugas = "Server Error (${response.statusCode})";
          _isLoading = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _namaPetugas = "Gagal Terhubung"; 
      });
    }
  }

  Map<String, dynamic> _getStyleKategori(String name) {
    if (name.toLowerCase().contains('organik') && !name.toLowerCase().contains('anorganik')) {
      return {'color': const Color(0xFF14A38B), 'icon': Icons.grass_rounded};
    } else if (name.toLowerCase().contains('anorganik') || name.toLowerCase().contains('non organik')) {
      return {'color': const Color(0xFFF2994A), 'icon': Icons.layers_outlined};
    } else if (name.toLowerCase().contains('b3')) {
      return {'color': const Color(0xFFEB5757), 'icon': Icons.gpp_maybe_outlined};
    }
    return {'color': Colors.blueGrey, 'icon': Icons.delete_outline_rounded};
  }

  void _navigasiKePilihLaporan(String jenisSampah) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PilihJenisLaporanPage(jenisSampah: jenisSampah),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF14A38B);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FA),
      body: RefreshIndicator(
        onRefresh: _fetchDashboardData,
        color: primaryColor,
        child: Stack(
          children: [
            Container(width: double.infinity, height: 200, color: primaryColor),
            SafeArea(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // HEADER (FOTO USER DB + IKON NOTIFIKASI)
                    Padding(
                      padding: const EdgeInsets.all(30),
                      child: Row(
                        children: [
                          // Foto Profil Dinamis dari Database User
                          Container(
                            width: 52, height: 52,
                            decoration: const BoxDecoration(color: Color(0xFFFFB057), shape: BoxShape.circle),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(26),
                              child: _fotoProfil != null && _fotoProfil!.isNotEmpty
                                  ? Image.network(
                                      "http://192.168.1.9:8000/storage/$_fotoProfil",
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) => 
                                          const Icon(Icons.person_rounded, color: Colors.white, size: 32),
                                    )
                                  : const Icon(Icons.person_rounded, color: Colors.white, size: 32),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Hallo, $_namaPetugas',
                                  style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 2),
                                const Text('Petugas Rumah Sampah', style: TextStyle(color: Colors.white70, fontSize: 12)),
                              ],
                            ),
                          ),
                          // Ikon Notifikasi
                          IconButton(
                            icon: const Icon(Icons.notifications_none_rounded, color: Colors.white, size: 28),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const NotifikasiPage(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),

                    // KARTU RINGKASAN (Statis - Sesuai Request Dibiarkan Dulu)
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 16, offset: const Offset(0, 8))],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Ringkasan Hari Ini', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(color: primaryColor.withOpacity(0.08), borderRadius: BorderRadius.circular(12)),
                                  child: const Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Total Masuk', style: TextStyle(fontSize: 11, color: Colors.grey)),
                                      SizedBox(height: 6),
                                      Text('0.0 Kg', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryColor)),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(color: Colors.blue.withOpacity(0.08), borderRadius: BorderRadius.circular(12)),
                                  child: const Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Sudah Diolah', style: TextStyle(fontSize: 11, color: Colors.grey)),
                                      SizedBox(height: 6),
                                      Text('0.0 Kg', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue)),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),

                    // MENU INPUT KATEGORI
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Lapor Sampah Harian Sekarang', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                          const SizedBox(height: 16),
                          
                          _isLoading
                              ? const Center(child: Padding(padding: EdgeInsets.all(20.0), child: CircularProgressIndicator(color: primaryColor)))
                              : _kategoriSampah.isEmpty
                                  ? const Text("Kategori tidak tersedia.", style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey))
                                  : Column(
                                      children: _kategoriSampah.map((item) {
                                        String name = item['name'] ?? 'Kategori';
                                        String desc = item['description'] ?? '';
                                        var style = _getStyleKategori(name);

                                        return _buildMenuSampah(
                                          title: name,
                                          desc: desc,
                                          color: style['color'],
                                          icon: style['icon'],
                                          onTap: () => _navigasiKePilihLaporan(name),
                                        );
                                      }).toList(),
                                    ),
                          
                          const SizedBox(height: 24),

                          // === 📜 SEKSI RIWAYAT BARU SAJA (DINAMIS DARI DATABASE) ===
                          const Text('Riwayat Baru Saja', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                          const SizedBox(height: 12),

                          _isLoading
                              ? const Center(child: Padding(padding: EdgeInsets.all(16.0), child: CircularProgressIndicator(color: primaryColor)))
                              : _riwayatHariIni.isEmpty
                                  ? Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(color: Colors.black12),
                                      ),
                                      child: const Center(
                                        child: Text(
                                          "Belum ada data yang diinput hari ini",
                                          style: TextStyle(fontStyle: FontStyle.italic, color: Colors.black45, fontSize: 13),
                                        ),
                                      ),
                                    )
                                  : ListView.builder(
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemCount: _riwayatHariIni.length,
                                      itemBuilder: (context, index) {
                                        final entry = _riwayatHariIni[index];
                                        
                                        // Format nama sub_category & lokasi dari JSON response Eager Loading Laravel
                                        String namaSub = entry['sub_category']?['name'] ?? 'Sampah';
                                        String namaLokasi = entry['source_location']?['name'] ?? 'Lokasi';
                                        String qty = entry['measured_qty']?.toString() ?? '0';
                                        
                                        // Opsional parsing symbol satuan
                                        String unit = entry['sub_category']?['unit_measured']?['symbol'] ?? 'Kg';

                                        return Container(
                                          margin: const EdgeInsets.only(bottom: 10),
                                          padding: const EdgeInsets.all(14),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(12),
                                            border: Border.all(color: const Color(0xFFE2E8F0)),
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(namaSub, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1E293B))),
                                                  const SizedBox(height: 4),
                                                  Row(
                                                    children: [
                                                      const Icon(Icons.location_on_outlined, size: 14, color: Colors.grey),
                                                      const SizedBox(width: 4),
                                                      Text(namaLokasi, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              Text(
                                                "$qty $unit",
                                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: primaryColor),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuSampah({required String title, required String desc, required Color color, required IconData icon, required VoidCallback onTap}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(14)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(icon, size: 36, color: Colors.white70),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(desc, style: const TextStyle(color: Colors.white70, fontSize: 11)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}

// Halaman Notifikasi sederhana
class NotifikasiPage extends StatelessWidget {
  const NotifikasiPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Notifikasi")),
      body: const Center(child: Text("Belum ada notifikasi baru")),
    );
  }
}