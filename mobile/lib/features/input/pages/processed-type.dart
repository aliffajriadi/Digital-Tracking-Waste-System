import 'package:flutter/material.dart';

class LaporanOlahanPage extends StatelessWidget {
  const LaporanOlahanPage({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF14A38B);
    const processedGradientStart = Color(0xFF3A9D8F); // Warna khas Olahan Sampah
    const processedGradientEnd = Color(0xFF2A7B6F);
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
          onPressed: () {
            Navigator.pop(context); // Balik ke Pilih Jenis Laporan
          },
        ),
        title: const Padding(
          padding: EdgeInsets.only(top: 15),
          child: Text(
            'Pilih Laporan',
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- BANNER HEADER (OLAHAN SAMPAH) ---
            Container(
              margin: const EdgeInsets.all(20),
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: const LinearGradient(
                  colors: [processedGradientStart, processedGradientEnd],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: processedGradientEnd.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    // Ikon Olahan
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.recycling_rounded,
                        color: Colors.white,
                        size: 45,
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Deskripsi
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Olahan Sampah',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Sampah yang di olah kembali dan bisa dimanfaatkan (kompos, kerajinan dll)',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // --- JUDUL SEKSI ---
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 22),
              child: Text(
                'Lapor & catat total Sampah Sesuai Kategori',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF264653),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // --- GRID SELECTION (Baru 1 Kategori: Kompos) ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  // 1. Kompos
                  Expanded(
                    child: _buildCategoryTile(
                      title: 'Kompos',
                      icon: Icons.takeout_dining_outlined, // Ikon mewakili wadah kompos
                      onTap: () {
                        // TODO: Masuk ke form detail input Kompos
                      },
                    ),
                  ),
                  // Spacer agar tile Kompos tidak memenuhi satu baris penuh sendirian (biar gak kaku)
                  const Expanded(child: SizedBox()), 
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // Widget Helper konsisten dengan halaman organik
  Widget _buildCategoryTile({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 14, 193, 187),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: const Color(0xFFE9F5F3),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Center(
                  child: Icon(
                    Icons.park_rounded, // Ikon pohon/taman cocok untuk kompos
                    color: Color(0xFF14A38B),
                    size: 40,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF264653),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}