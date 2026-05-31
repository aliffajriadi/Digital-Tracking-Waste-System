import 'package:flutter/material.dart';
import '../../waste_entry/pages/form_waste_entry.dart';       
import '../../waste_processed/pages/processed_method.dart';  
import '../../report/pages/report_submiss.dart'; 
import '../../waste_entry/pages/category_waste.dart';    
import '../../waste_out/pages/method_out.dart';

class PilihJenisLaporanPage extends StatelessWidget {
  final String? jenisSampah;

  const PilihJenisLaporanPage({super.key, this.jenisSampah});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF14A38B);
    const bgLightColor = Color(0xFFF4F7F9);

    return Scaffold(
      backgroundColor: bgLightColor,
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: primaryColor,
        elevation: 0,
        leading: IconButton(
          padding: const EdgeInsets.only(top: 15),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Padding(
          padding: EdgeInsets.only(top: 15),
          child: Text(
            'Pilih Aktivitas Laporan',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        centerTitle: false,
        titleSpacing: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Silakan pilih jenis pencatatan sampah yang ingin dilaporkan:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF264653),
              ),
            ),
            const SizedBox(height: 20),

            // 1. INPUT SAMPAH MASUK
            _buildMenuCard(
              title: 'Sampah Masuk',
              description: 'Catat berat timbangan sampah harian yang baru tiba di rumah sampah.',
              startColor: const Color(0xFF02AAB0),
              endColor: const Color(0xFF00CDAC),
              iconAssetOrPlaceholder: Icons.login_rounded, 
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PilihKategoriPage()),
                );
              },
            ),

            // 2. OLAHAN SAMPAH
            _buildMenuCard(
              title: 'Olahan Sampah',
              description: 'Catat hasil sampah yang berhasil diolah kembali (kompos, pupuk cair, kerajinan).',
              startColor: const Color(0xFF3A9D8F),
              endColor: const Color(0xFF2A7B6F),
              iconAssetOrPlaceholder: Icons.recycling_rounded,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LaporanOlahanPage()),
                );
              },
            ),

            // 3. SAMPAH KELUAR
            _buildMenuCard(
              title: 'Sampah Keluar / Residu',
              description: 'Catat total sampah sisa (residu) yang tidak bisa diolah dan dibawa ke TPA.',
              startColor: const Color(0xFF8A5A16),
              endColor: const Color(0xFF70450D),
              iconAssetOrPlaceholder: Icons.logout_rounded,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PilihMetodeKeluarPage()),
                );
              },
            ),

            // 4. LAINNYA / KENDALA
            _buildMenuCard(
              title: 'Lainnya / Kendala',
              description: 'Laporkan masalah operasional di lapangan (mesin rusak, area penuh, cuaca ekstrem).',
              startColor: const Color(0xFFE07A5F),
              endColor: const Color(0xFFD95D39),
              iconAssetOrPlaceholder: Icons.report_problem_rounded,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LaporanKendalaPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _jalankanNavigasi(BuildContext context, String jenisLaporan) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Membuka halaman formulir: $jenisLaporan'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  Widget _buildMenuCard({
    required String title,
    required String description,
    required Color startColor,
    required Color endColor,
    required IconData iconAssetOrPlaceholder,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: LinearGradient(
          colors: [startColor, endColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: endColor.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          splashColor: Colors.white24,
          highlightColor: Colors.white10,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      iconAssetOrPlaceholder,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 11,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.white,
                  size: 14,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}