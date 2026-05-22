import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    // KUNCINYA DI SINI: Kita langsung return Stack tanpa Scaffold bawaan
    return Stack(
      children: [
        // =========================================================
        // 1. BACKGROUND HIJAU TOSCA (Mandiri, Petak Mentok)
        // =========================================================
        Container(
          width: double.infinity,
          height: 180, 
          color: const Color(0xFF16B3AC), // Warna Tosca WasteTrack
        ),

        // =========================================================
        // 2. KONTEN UTAMA (Melayang di atas Background Hijau)
        // =========================================================
        SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // HEADER (Nama, Profil, Lonceng)
                Padding(
                  padding: const EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 20),
                  child: Row(
                    children: [
                      // Foto Profil Bulat
                      Container(
                        width: 55,
                        height: 55,
                        decoration: const BoxDecoration(
                          color: Color(0xFFFFB057),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.person, color: Colors.white, size: 35),
                      ),
                      const SizedBox(width: 15),
                      // Teks Nama PIC
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hallo, Naylah Amirah',
                              style: TextStyle(
                                color: Colors.white, 
                                fontSize: 18, 
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.3,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Petugas Rumah Sampah',
                              style: TextStyle(color: Colors.white70, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                      // Lonceng Notifikasi
                      Stack(
                        children: [
                          const Icon(Icons.notifications_none_outlined, color: Colors.white, size: 32),
                          Positioned(
                            right: 2,
                            top: 2,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                              child: const Text(
                                '2', 
                                style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // KARTU RINGKASAN HARI INI (Pas Memotong di Tengah Garis Hijau)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04), 
                        blurRadius: 15, 
                        offset: const Offset(0, 8),
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Ringkasan Hari Ini', 
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                            decoration: BoxDecoration(
                              color: const Color(0xFF16B3AC), 
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Column(
                              children: [
                                  Text('3', style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
                                  Text('Laporan', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w500)),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Container(
                              height: 70,
                              decoration: BoxDecoration(
                                color: const Color(0xFF16B3AC), 
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                // MENU LAPOR SAMPAH SEKARANG
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Lapor Sampah Harian Sekarang', 
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                      ),
                      const SizedBox(height: 15),

                      _buildMenuSampah(
                        title: 'Sampah Organik',
                        desc: 'Sampah alami seperti sisa makanan, daun, dan buah yang mudah terurai.',
                        color: const Color(0xFF16B3AC),
                        icon: Icons.grass_rounded,
                      ),
                      
                      _buildMenuSampah(
                        title: 'Sampah Non Organik',
                        desc: 'Sampah tidak mudah terurai (contoh: plastik, kaca, logam).',
                        color: const Color(0xFFF2994A),
                        icon: Icons.layers_outlined, 
                      ),

                      _buildMenuSampah(
                        title: 'Sampah B3',
                        desc: 'Sampah yang berbahaya bagi kesehatan/lingkungan (baterai, obat, dll).',
                        color: const Color(0xFFEB5757),
                        icon: Icons.gpp_maybe_outlined,
                      ),

                      const SizedBox(height: 15),
                      const Text(
                        'Riwayat Input Terakhir', 
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                      ),
                      const SizedBox(height: 15),

                      // Item Riwayat
                      Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.white, 
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          children: [
                            const CircleAvatar(
                              radius: 25,
                              backgroundColor: Color(0xFFE5EBF2),
                              child: Icon(Icons.local_drink_outlined, color: Color(0xFF16B3AC), size: 28),
                            ),
                            const SizedBox(width: 15),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Non Organik, Botol', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1E293B))),
                                  Text('Hari ini - 10.36 WIB', style: TextStyle(color: Colors.grey, fontSize: 11)),
                                  SizedBox(height: 5),
                                  Text('9 Kg', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF1E293B))),
                                ],
                              ),
                            ),
                          ],
                        ),
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
    );
  }

  Widget _buildMenuSampah({required String title, required String desc, required Color color, required IconData icon}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(15)),
      child: Row(
        children: [
          Icon(icon, size: 40, color: Colors.white.withOpacity(0.6)),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(desc, style: const TextStyle(color: Colors.white70, fontSize: 11, height: 1.3)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.white),
        ],
      ),
    );
  }
}