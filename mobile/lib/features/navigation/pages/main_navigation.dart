import 'package:flutter/material.dart';
import '../../dashboard/pages/dashboard_page.dart';
import '../../settings/pages/setting_page.dart';
import '../../input/pages/waste_data.dart';
import '../../input/pages/history_page.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const DashboardPage(),
    const LaporanDataHarianPage(),
    const RiwayatPage(),
    const PengaturanPage(),
  ];

  @override
  Widget build(BuildContext context) {
    // Disamakan menjadi warna hijau pekat andalan kita
    const primaryColor = Color(0xFF14A38B); 

    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: primaryColor, // Diubah ke hijau pekat biar serasi
        unselectedItemColor: const Color(0xFF94A3B8),
        currentIndex: _currentIndex,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        unselectedLabelStyle: const TextStyle(fontSize: 12),
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
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