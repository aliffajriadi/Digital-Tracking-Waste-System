import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'report_detail.dart';
import '../../kendala/pages/detail_submiss.dart';

class RiwayatPage extends StatefulWidget {
  const RiwayatPage({super.key});

  @override
  State<RiwayatPage> createState() => _RiwayatPageState();
}

class _RiwayatPageState extends State<RiwayatPage> {
  Map<String, dynamic> _groupedRiwayat = {};
  List<dynamic> _categories = [];
  bool _isLoading = true;

  // State untuk Filter & Search
  String _searchQuery = "";
  int? _selectedCategoryId;
  String _selectedCategoryName = "Semua";

  @override
  void initState() {
    super.initState();
    _fetchRiwayat();
  }

  // Fungsi Fetch Data dari Laravel (Mendukung query parameter live search & filter)
  Future<void> _fetchRiwayat() async {
    setState(() => _isLoading = true);
    try {
      // Ubah parameter pemanggilan API agar sinkron dengan Controller
      String url = "http://192.168.1.9:8000/api/riwayat-laporan?search=$_searchQuery";
      
      if (_selectedCategoryId != null) {
        url += "&type=$_selectedCategoryId"; 
      }

      final response = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final resData = json.decode(response.body);
        if (mounted) {
          setState(() {
            _groupedRiwayat = resData['data'] ?? {};
            _categories = resData['categories'] ?? [];
            _isLoading = false;
          });
        }
      } else {
        if (mounted) setState(() => _isLoading = false);
      }
    } catch (e) {
      debugPrint("Error Riwayat: $e");
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // Bottom Sheet untuk memunculkan Filter Kategori Induk
  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Filter Berdasarkan Kategori",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF264653)),
              ),
              const SizedBox(height: 15),
              // Opsi Tampilkan Semua
              ListTile(
                title: const Text("Semua Kategori"),
                trailing: _selectedCategoryId == null ? const Icon(Icons.check, color: Color(0xFF14A38B)) : null,
                onTap: () {
                  setState(() {
                    _selectedCategoryId = null;
                    _selectedCategoryName = "Semua";
                  });
                  Navigator.pop(context);
                  _fetchRiwayat();
                },
              ),
              const Divider(),
              // Render list kategori dinamis dari DB Laravel
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    final cat = _categories[index];
                    return ListTile(
                      title: Text(cat['name']),
                      trailing: _selectedCategoryId == cat['id'] ? const Icon(Icons.check, color: Color(0xFF14A38B)) : null,
                      onTap: () {
                        setState(() {
                          _selectedCategoryId = cat['id'];
                          _selectedCategoryName = cat['name'];
                        });
                        Navigator.pop(context);
                        _fetchRiwayat(); // Reload data sesuai kategori terpilih
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF14A38B);
    const bgLightColor = Color(0xFFF4F7F9);
    const darkBlueColor = Color(0xFF264653);

    // Mengubah Map Keys menjadi List Tanggal untuk ListView.builder
    final tanggalList = _groupedRiwayat.keys.toList();

    return Scaffold(
      backgroundColor: bgLightColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Padding(
          padding: EdgeInsets.only(top: 15, left: 10),
          child: Row(
            children: [
              Icon(Icons.bar_chart_rounded, color: Colors.white, size: 28),
              SizedBox(width: 10),
              Text(
                'Riwayat Laporan',
                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          // --- KOTAK CARI & FILTER ---
          Container(
            color: primaryColor,
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
            child: Row(
              children: [
                // Kolom Cari (Live Search)
                Expanded(
                  child: Container(
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                        _fetchRiwayat(); // Otomatis tembak API tiap ketik huruf baru
                      },
                      decoration: const InputDecoration(
                        hintText: "Cari riwayat laporan...",
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                        prefixIcon: Icon(Icons.search, color: Colors.grey),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Tombol Filter Premium
                InkWell(
                  onTap: _showFilterBottomSheet,
                  child: Container(
                    height: 45,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: _selectedCategoryId != null ? Colors.orange : darkBlueColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.tune_rounded, color: Colors.white, size: 20),
                        const SizedBox(width: 6),
                        Text(
                          _selectedCategoryName,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // --- DATA RENDERING ---
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: primaryColor))
                : tanggalList.isEmpty
                    ? const Center(child: Text("Riwayat laporan tidak ditemukan"))
                    : ListView.builder(
                        padding: const EdgeInsets.all(20),
                        itemCount: tanggalList.length,
                        itemBuilder: (context, index) {
                          String tanggalSection = tanggalList[index];
                          List<dynamic> itemsDiTanggalIni = _groupedRiwayat[tanggalSection];

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildSectionTitle(tanggalSection),
                              const SizedBox(height: 10),
                              ...itemsDiTanggalIni.map((item) {
                                // Logika penentuan icon berdasarkan teks subkategori
                          

                                // ... di dalam ListView.builder RiwayatPage ...
                                String tipe = (item['type_log'] ?? '').toString(); // Aman dari null
                                IconData icon = Icons.assignment_rounded;
                                Color color = Colors.grey.shade700;
                                Color bg = Colors.grey.shade100;
                                String status = "Selesai";
                                Color statusColor = Colors.green;

                                if (tipe == 'input_masuk') {
                                  icon = Icons.login_rounded;
                                  color = Colors.blue.shade700;
                                  bg = const Color(0xFFE3F2FD);
                                } else if (tipe == 'input_keluar') {
                                  icon = Icons.logout_rounded;
                                  color = Colors.purple.shade700;
                                  bg = const Color(0xFFF3E5F5);
                                } else if (tipe == 'olahan') {
                                  icon = Icons.auto_awesome_rounded;
                                  color = const Color(0xFF14A38B);
                                  bg = const Color(0xFFE0F2F1);
                                } else if (tipe == 'kendala') {
                                  icon = Icons.warning_amber_rounded;
                                  color = Colors.orange.shade800;
                                  bg = const Color(0xFFFFF3E0);
                                  status = "Diproses";
                                  statusColor = Colors.orange;
                                }

                                return _buildRiwayatCard(
                                  context: context,
                                  idLaporan: item['id'] ?? 0, // Amankan ID jika null
                                  typeLog: tipe,
                                  title: (item['title'] ?? 'Tanpa Judul').toString(), // <--- AMAN DARI NULL
                                  time: (item['time'] ?? '-').toString(),             // <--- AMAN DARI NULL
                                  amount: (item['amount'] ?? '-').toString(),         // <--- AMAN DARI NULL
                                  categoryIcon: icon,
                                  iconBgColor: bg,
                                  iconColor: color,
                                  status: status,
                                  statusColor: statusColor,
                                );
                              }),
                              const SizedBox(height: 15),
                            ],
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF64748B)),
    );
  }

  Widget _buildRiwayatCard({
    required BuildContext context,
    required int idLaporan,
    required String typeLog, // <--- TAMBAHKAN DI SINI
    required String title,
    required String time,
    required String amount,
    required IconData categoryIcon,
    required Color iconBgColor,
    required Color iconColor,
    required String status,
    required Color statusColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 4)),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(color: iconBgColor, borderRadius: BorderRadius.circular(10)),
          child: Icon(categoryIcon, color: iconColor, size: 26),
        ),
        title: Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF264653)),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Row(
            children: [
              Text(time, style: const TextStyle(fontSize: 11, color: Colors.grey)),
              const SizedBox(width: 8),
              Container(
                width: 4,
                height: 4,
                decoration: const BoxDecoration(color: Colors.grey, shape: BoxShape.circle),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: statusColor.withOpacity(0.12), borderRadius: BorderRadius.circular(6)),
                child: Text(
                  status,
                  style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              amount,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF14A38B)),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.chevron_right, color: Colors.black26),
          ],
        ),
        onTap: () {
          // --- LOGIKA PERCABANGAN DI SINI ---
          if (typeLog == 'kendala') {
            // Jika type_log-nya kendala, arahkan ke halaman DetailKendalaPage
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailKendalaPage(reportId: idLaporan.toString()),
              ),
            );
          } else {
            // Jika type_log-nya yang lain (input_masuk, keluar, olahan), arahkan ke halaman sampah biasa
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailLaporanPage(idLaporan: idLaporan),
              ),
            );
          }
        },
      ),
    );
  }
}