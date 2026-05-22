import 'package:flutter/material.dart';

class PengaturanPage extends StatelessWidget {
  const PengaturanPage({super.key});

  @override
  Widget build(BuildContext context) {
    const Color toscaWasteTrack = Color(0xFF16B3AC); 

    return Stack(
      children: [
        // 1. BACKGROUND HEADER TOSCA
        Container(
          width: double.infinity,
          height: 80,
          decoration: const BoxDecoration(
            color: toscaWasteTrack,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(0),
              bottomRight: Radius.circular(0), //sementara 
            ),
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
                      // Profile Section (Foto, Nama, Email)
                      _buildProfileSection(toscaWasteTrack),

                      const SizedBox(height: 30),

                      // Group Menu 1 (Profile, Password, Notif, IoT)
                      _buildMenuGroup(
                        toscaWasteTrack: toscaWasteTrack,
                        items: [
                          _MenuItem(
                            icon: Icons.person_outline,
                            label: 'Pengaturan Profile',
                            onTap: () {},
                          ),
                          _MenuItem(
                            icon: Icons.key_outlined,
                            label: 'Ganti Password',
                            onTap: () {},
                          ),
                          _MenuItem(
                            icon: Icons.notifications_none_outlined,
                            label: 'Notifikasi',
                            badge: true,
                            onTap: () {},
                          ),
                          _MenuItem(
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
                          _MenuItem(
                            icon: Icons.help_outline,
                            label: 'Bantuan',
                            onTap: () {},
                          ),
                        ],
                      ),

                      const SizedBox(height: 25),

                      // Tombol Keluar Akun 
                      _buildKeluarButton(),

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
        // Avatar dengan garis tepi lingkaran tipis Tosca
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
            // Catatan: Jika mau pakai foto, buka komentar baris di bawah ini:
            // backgroundImage: AssetImage('assets/avatar.png'),
            child: Icon(Icons.person, size: 55, color: Colors.grey),
          ),
        ),
        const SizedBox(height: 14),
        const Text(
          'Naylah Amirah',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'naylaamirah@pbl.com',
          style: TextStyle(
            fontSize: 13,
            color: Color(0xFF64748B),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuGroup({required Color toscaWasteTrack, required List<_MenuItem> items}) {
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

  Widget _buildMenuItem(_MenuItem item, Color toscaWasteTrack) {
    return InkWell(
      onTap: item.onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            // Kotak Icon Rounded Tosca
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
            // Teks Label Menu
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
            // Arrow Chevron Kanan Tosca
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

  Widget _buildKeluarButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {},
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
          children: const [
            Row(
              children: [
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
            Icon(Icons.chevron_right, color: Colors.white, size: 22),
          ],
        ),
      ),
    );
  }
}

// Data Model Menu Item
class _MenuItem {
  final IconData icon;
  final String label;
  final bool badge;
  final VoidCallback onTap;

  _MenuItem({
    required this.icon,
    required this.label,
    this.badge = false,
    required this.onTap,
  });
}