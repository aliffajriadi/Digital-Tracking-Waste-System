import 'package:flutter/material.dart';
import '../pages/dashboard.dart';
import '../pages/setting.dart';
//import '../pages/data_sampah_page.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  // Mengingat posisi index menu yang aktif saat ini
  int _currentIndex = 0;

  // Daftar halaman yang akan ditampilkan sesuai menu yang diklik
  final List<Widget> _pages = [
    const DashboardPage(),
    const Scaffold(body: Center(child: Text('Halaman data sampah'))),
    const Scaffold(body: Center(child: Text('Halaman Riwayat'))),
    const PengaturanPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Tubuh aplikasi otomatis berganti sesuai index menu aktif
      body: _pages[_currentIndex],
      
      // KOMPONEN NAVBAR TUNGGAL YANG BISA DIAKSES SEMUA HALAMAN
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF16B3AC), // Warna hijau tosca aktif
        unselectedItemColor: const Color(0xFF94A3B8),
        currentIndex: _currentIndex,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        unselectedLabelStyle: const TextStyle(fontSize: 12),
        onTap: (int index) {
          setState(() {
            _currentIndex = index; // Mengubah halaman secara reaktif saat ikon diklik
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.delete_outline), label: 'Data Sampah'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart_outlined), label: 'Riwayat'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Pengaturan'),
        ],
      ),
    );
  }
}