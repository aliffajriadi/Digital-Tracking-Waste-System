import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'select_input.dart';
import '../../history/pages/detail_waste_page.dart';
import 'package:mobile/core/constants/api_constants.dart'; 

class LaporanDataHarianPage extends StatefulWidget {
  const LaporanDataHarianPage({super.key});

  @override
  State<LaporanDataHarianPage> createState() => _LaporanDataHarianPageState();
}

class _LaporanDataHarianPageState extends State<LaporanDataHarianPage> {
  final _searchController = TextEditingController();
  List<dynamic> _laporanList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchLaporan();
  }

  Future<void> _fetchLaporan() async {
  try {
    final response = await http.get(Uri.parse(ApiConstants.laporanHarian))
        .timeout(const Duration(seconds: 5));
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      
      // Cek apakah widget masih terpasang di layar
      if (mounted) {
        setState(() {
          _laporanList = data['data'] ?? [];
          _isLoading = false;
        });
      }
    } else {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  } catch (e) {
    debugPrint("Error: $e");
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }
}

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF14A38B);
    const darkTealColor = Color(0xFF264653);
    const bgLightColor = Color(0xFFF4F7F9);

    return Scaffold(
      backgroundColor: bgLightColor,
      body: Column(
        children: [
          // HEADER
          Container(
            padding: const EdgeInsets.fromLTRB(20, 60, 20, 24),
            decoration: const BoxDecoration(color: primaryColor),
            child: Column(
              children: [
                Row(
                  children: [
                    const Icon(Icons.add_box_outlined, color: Colors.white, size: 28),
                    const SizedBox(width: 12),
                    const Text('Laporan Data Harian', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 42,
                        decoration: BoxDecoration(color: const Color(0xFFEAEFF2), borderRadius: BorderRadius.circular(10)),
                        child: TextField(
                          controller: _searchController,
                          decoration: const InputDecoration(hintText: 'Cari Laporan...', prefixIcon: Icon(Icons.search_rounded, size: 20), border: InputBorder.none),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // LIST DATA
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: primaryColor))
                : _laporanList.isEmpty
                    ? const Center(child: Text("Belum ada data laporan"))
                    : ListView.builder(
                        padding: const EdgeInsets.all(20),
                        itemCount: _laporanList.length,
                        itemBuilder: (context, index) {
                          final item = _laporanList[index];
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context, 
                                MaterialPageRoute(
                                  builder: (context) => DetailLaporanPage(idLaporan: item['id'] ?? 0), // Jika null, ganti jadi 0
                                ),
                              );
                            },
                            child: _buildLaporanCard(item, primaryColor),
                          );
                        },
                      ),
          ),

          // TOMBOL TAMBAH BAWAH
          Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PilihJenisLaporanPage())),
                style: ElevatedButton.styleFrom(backgroundColor: darkTealColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text('Tambah', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLaporanCard(Map<String, dynamic> item, Color arrowColor) {
    bool isBotol = item['isBotol'] == true || item['isBotol'] == 1;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          Container(
            width: 55, height: 55,
            decoration: const BoxDecoration(color: Color(0xFFE5E9EC), shape: BoxShape.circle),
            child: Center(
              child: isBotol
                  ? const Icon(Icons.opacity_rounded, color: Colors.blueGrey, size: 28)
                  : const Icon(Icons.oil_barrel_rounded, color: Colors.amber, size: 28),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item['kategori'] ?? 'N/A', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF264653))),
                Text(item['waktu'] ?? '-', style: const TextStyle(fontSize: 11, color: Color(0xFF8A99A8))),
                const SizedBox(height: 4),
                Text(item['jumlah'] ?? '0', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF264653))),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_ios_rounded, color: arrowColor, size: 18),
        ],
      ),
    );
  }
}