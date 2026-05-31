import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile/features/auth/pages/login_page.dart'; 
import 'change_password_page.dart';
import 'change_profil_page.dart';
import '../widgets/settings/menu_item_model.dart'; 
import '../widgets/notification/notification_page.dart';
import 'help_center_page.dart';

class PengaturanPage extends StatefulWidget {
  const PengaturanPage({super.key});

  @override
  State<PengaturanPage> createState() => _PengaturanPageState();
}

class _PengaturanPageState extends State<PengaturanPage> {
  String _userName = 'Memuat...';
  String _userNik = '...';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Fungsi untuk mengambil data login user secara dinamis
  void _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('user_name') ?? 'Nama Karyawan';
      _userNik = prefs.getString('user_nik') ?? '-';
    });
  }

  @override
  Widget build(BuildContext context) {
    const Color toscaWasteTrack = Color(0xFF14A38B); 

    return Stack(
      children: [
        // 1. BACKGROUND HEADER TOSCA
        Container(
          width: double.infinity,
          height: 115,
          decoration: const BoxDecoration(
            color: toscaWasteTrack,
          ),
        ),

        // 2. KONTEN UTAMA (Scrollable)
        SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Custom Header Title (Pengaturan + Icon Gear)
                Padding(
                  padding: const EdgeInsets.only(top: 25, left: 24, right: 24, bottom: 20),
                  child: Row(
                    children: const [
                      Icon(Icons.settings, color: Colors.white, size: 28),
                      SizedBox(width: 12),
                      Text(
                        'Pengaturan',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // AREA KONTEN PUTIH DI BAWAH HEADER
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      // Profile Section (Foto, Nama, NIK dari database)
                      _buildProfileSection(toscaWasteTrack),

                      const SizedBox(height: 30),

                      // Group Menu 1 (Profile, Password, Notif, IoT)
                      _buildMenuGroup(
                        toscaWasteTrack: toscaWasteTrack,
                        items: [
                          MenuItemModel(
                            icon: Icons.person_outline,
                            label: 'Pengaturan Profile',
                            onTap: () async {
                              // Menunggu hasil (refresh data) ketika user kembali dari halaman UbahProfilPage
                              final shouldRefresh = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const UbahProfilPage(),
                                ),
                              );

                              // Jika bernilai true, panggil kembali data user yang baru dari SharedPreferences
                              if (shouldRefresh == true) {
                                _loadUserData(); 
                              }
                            },
                          ),
                          MenuItemModel(
                            icon: Icons.key_outlined,
                            label: 'Ganti Password',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const PengaturanPasswordPage(),
                                ),
                              );
                            },
                          ),
                          MenuItemModel(
                            icon: Icons.notifications_none_outlined,
                            label: 'Notifikasi',
                            badge: true,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const NotifikasiPage(),
                                ),
                              );
                            },
                          ),
                          MenuItemModel(
                            icon: Icons.router_outlined,
                            label: 'Integrasi IoT',
                            onTap: () {},
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Group Menu 2 (Bantuan)
                      _buildMenuGroup(
                        toscaWasteTrack: toscaWasteTrack,
                        items: [
                          MenuItemModel(
                            icon: Icons.help_outline,
                            label: 'Bantuan',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const HelpCenterPage(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 25),

                      // Tombol Keluar Akun
                      _buildKeluarButton(context),

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

  Widget _buildProfileSection(Color toscaWasteTrack) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: toscaWasteTrack,
              width: 2.5,
            ),
          ),
          child: const CircleAvatar(
            radius: 50,
            backgroundColor: Color(0xFFE2E8F0),
            child: Icon(Icons.person, size: 55, color: Colors.grey),
          ),
        ),
        const SizedBox(height: 14),
        Text(
          _userName, // OTOMATIS AMBIL NAMA USER YANG LOGIN
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'NIK: $_userNik', // OTOMATIS AMBIL NIK USER YANG LOGIN
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF64748B),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuGroup({required Color toscaWasteTrack, required List<MenuItemModel> items}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final isLast = index == items.length - 1;

          return Column(
            children: [
              _buildMenuItem(item, toscaWasteTrack),
              if (!isLast)
                const Divider(
                  height: 1,
                  thickness: 1,
                  indent: 68,
                  endIndent: 20,
                  color: Color(0xFFF1F5F9),
                ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMenuItem(MenuItemModel item, Color toscaWasteTrack) {
    return InkWell(
      onTap: item.onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: toscaWasteTrack,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(item.icon, color: Colors.white, size: 22),
                  if (item.badge)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                item.label,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF334155),
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: toscaWasteTrack,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKeluarButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          showDialog(
            context: context,
            builder: (BuildContext dialogContext) {
              return AlertDialog(
                title: const Text('Keluar Akun'),
                content: const Text('Apakah Anda yakin ingin keluar dari aplikasi?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(dialogContext),
                    child: const Text('Batal', style: TextStyle(color: Colors.grey)),
                  ),
                  TextButton(
                    onPressed: () async {
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      await prefs.clear();

                      if (dialogContext.mounted) {
                        Navigator.pop(dialogContext);
                      }

                      if (context.mounted) {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginPage()),
                          (route) => false,
                        );
                      }
                    },
                    child: const Text('Keluar', style: TextStyle(color: Color(0xFFE26B50))),
                  ),
                ],
              );
            },
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFE26B50), 
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: const [
                Icon(Icons.logout, color: Colors.white, size: 22),
                SizedBox(width: 12),
                Text(
                  'Keluar Akun',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Icon(Icons.chevron_right, color: Colors.white, size: 22),
          ],
        ),
      ),
    );
  }
}