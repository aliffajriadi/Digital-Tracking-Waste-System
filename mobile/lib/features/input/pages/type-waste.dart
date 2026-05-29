import 'package:flutter/material.dart';
import 'waste-in-input.dart';

class LaporanOrganikPage extends StatelessWidget {
  const LaporanOrganikPage({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF14A38B); // Teal tema utama
    const organicGradientStart = Color(0xFF02AAB0); // Hijau organik start
    const organicGradientEnd = Color(0xFF00CDAC);   // Hijau organik end
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
            Navigator.pop(context); // Kembali ke Pilih Jenis Laporan
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
            // --- BANNER HEADER ---
            Container(
              margin: const EdgeInsets.all(20),
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: const LinearGradient(
                  colors: [organicGradientStart, organicGradientEnd],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: organicGradientEnd.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Dekorasi daun di background (opsional jika ada aset)
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: [
                        // Ikon Besar
                        Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.eco_rounded,
                            color: Colors.white,
                            size: 45,
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Teks Deskripsi
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Sampah Organik',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Sampah alami seperti sisa makanan, daun, dan buah yang mudah terurai.',
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
                ],
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

            // --- GRID SELECTION (Hanya 2 Sesuai Permintaan) ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  // 1. Sampah Daun
                  Expanded(
                    child: _buildCategoryTile(
                      title: 'Sampah\nDaun',
                      icon: Icons.energy_savings_leaf_rounded,
                      iconColor: Colors.green.shade700,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => InputSampahPage(
                              selectedSubCategory: WasteSubCategory(
                                id: 1,
                                name: "Daun Kering",
                                categoryName: "Organik",
                                photo: "https://via.placeholder.com/150",
                                unitMeasured: UnitMeasured(id: 1, name: "Kilogram", symbol: "Kg"),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  // 2. Sampah Sisa Makanan
                  Expanded(
                    child: _buildCategoryTile(
                      title: 'Sampah Sisa\nMakanan',
                      icon: Icons.restaurant_rounded,
                      iconColor: Colors.orange.shade800,
                      onTap: () {
                        // TODO: Masuk ke form detail input Sisa Makanan
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // Widget Helper untuk Kotak Pilihan (Tile) agar rapi dan seragam
  Widget _buildCategoryTile({
    required String title,
    required IconData icon,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return Container(
      height: 180, // Ukuran kotak yang pas agar tidak kaku
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
              // Lingkaran Ikon
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: const Color(0xFFE9F5F3),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Icon(
                    icon,
                    color: const Color(0xFF14A38B),
                    size: 40,
                  ),
                ),
                // TIPS: Jika nanti mau pakai gambar ilustrasi seperti di screenshot, ganti Icon di atas menjadi Image.asset
              ),
              const SizedBox(height: 16),
              // Judul Kategori
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