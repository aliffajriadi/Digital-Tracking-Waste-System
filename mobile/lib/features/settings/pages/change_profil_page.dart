import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile/core/constants/api_constants.dart';

class UbahProfilPage extends StatefulWidget {
  const UbahProfilPage({super.key});

  @override
  State<UbahProfilPage> createState() => _UbahProfilPageState();
}

class _UbahProfilPageState extends State<UbahProfilPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  
  String _userNik = '...'; 
  String? _profileImageUrl; // Menyimpan URL foto profil (Simulasi)
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  void _loadProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _nameController.text = prefs.getString('user_name') ?? '';
      
      // PERBAIKAN EMAIL: Mencoba mengambil dari 'user_email', jika null coba ambil dari 'email'
      _emailController.text = prefs.getString('user_email') ?? prefs.getString('email') ?? '';
      
      // NOMOR HP: Jika di database kosong, set default text agar tidak kosongan banget
      String savedPhone = prefs.getString('user_phone') ?? '';
      _phoneController.text = savedPhone.isEmpty ? '-' : savedPhone;
      
      _userNik = prefs.getString('user_nik') ?? '-';
      
      // Mengambil simulasi foto profil jika pernah disimpan sebelumnya
      _profileImageUrl = prefs.getString('user_profile_text');
      
      _isLoading = false;
    });
  }

  // Fungsi untuk menyimpan perubahan ke API Laravel dan SharedPreferences
  void _saveProfileData() async {
    if (_nameController.text.isEmpty || _emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nama dan Email tidak boleh kosong!'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    // Tampilkan loading dialog supaya user tahu data sedang dikirim
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: Color(0xFF14A38B)),
      ),
    );

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      // 1. Alamat API Laravel kamu (Sesuaikan IP/Domain & Port-nya seperti pas login)
      String url = ApiConstants.updateProfile;

      // 2. Kirim data via HTTP POST
      final response = await http.post(
        Uri.parse(url),
        body: {
          'nik': _userNik, // Pastikan NIK dikirim supaya backend tahu data siapa yang diupdate
          'name': _nameController.text,
          'email': _emailController.text,
          'phone': _phoneController.text,
          // Jika API mendukung upload foto, bisa tambahkan field untuk itu di sini
        },
      ).timeout(const Duration(seconds: 10));

      // Tutup loading dialog
      if (mounted) {
        Navigator.pop(context);
      }

      var responseData = json.decode(response.body);

      if (response.statusCode == 200 && responseData['success'] == true) {
        // Jika update berhasil di backend, simpan juga di SharedPreferences hp
        await prefs.setString('user_name', _nameController.text);
    
      // Simpan email sesuai key yang aktif di aplikasi 
      if (prefs.containsKey('user_email')) {
        await prefs.setString('user_email', _emailController.text);
      } else {
        await prefs.setString('email', _emailController.text);
      }
      await prefs.setString('user_phone', _phoneController.text);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profil berhasil diperbarui!'),
            backgroundColor: Color(0xFF14A38B),
          ),
        );
        Navigator.pop(context); // Kembali ke halaman pengaturan
      }
    } else {
      // jika gagal dari sisi laravel (misal email duplikat)
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(responseData['message'] ?? 'Gagal memperbarui profil'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
    } catch (e) {
      // Jika gagal koneksi atau error lain
       if (mounted) {
          Navigator.pop(context); // Tutup loading dialog jika masih terbuka
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
            content: Text('Terjadi kesalahan koneksi: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  // Fungsi Simulasi Ganti Foto Profil untuk demo PBL
  void _simulateChangePhoto() {
    setState(() {
      // Menggunakan gambar avatar acak dari internet untuk simulasi ganti foto
      _profileImageUrl = "https://avatar.iran.liara.run/public/30"; 
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Simulasi: Foto profil berhasil diperbarui!'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF14A38B);
    const bgLightColor = Color(0xFFF4F7F9);

    return Scaffold(
      backgroundColor: bgLightColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Profil Saya',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: primaryColor))
          : SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: 40,
                    width: double.infinity,
                    decoration: const BoxDecoration(color: primaryColor),
                  ),

                  // Bagian Foto Profil & Nama
                  Transform.translate(
                    offset: const Offset(0, -30),
                    child: Column(
                      children: [
                        // Avatar dengan Tombol Ubah
                        GestureDetector(
                          onTap: _simulateChangePhoto, // Klik avatar bisa ganti foto
                          child: Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 4),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 10,
                                    )
                                  ],
                                ),
                                child: CircleAvatar(
                                  radius: 55,
                                  backgroundColor: const Color(0xFFE2E8F0),
                                  backgroundImage: _profileImageUrl != null 
                                      ? NetworkImage(_profileImageUrl!) 
                                      : null,
                                  child: _profileImageUrl == null
                                      ? const Icon(Icons.person, size: 60, color: Colors.grey)
                                      : null,
                                ),
                              ),
                              // Tombol Pensil
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: const BoxDecoration(
                                  color: primaryColor,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.edit_square,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        
                        // Nama Live Update
                        ValueListenableBuilder<TextEditingValue>(
                          valueListenable: _nameController,
                          builder: (context, value, child) {
                            return Text(
                              value.text.isEmpty ? 'Nama Karyawan' : value.text,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2D3142),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 4),
                        
                        // Badge NIK
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFD1F2EC),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'NIK : $_userNik',
                            style: const TextStyle(
                              color: primaryColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Form Input Data
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Column(
                      children: [
                        _buildProfileInput(
                          label: "NAMA LENGKAP",
                          controller: _nameController,
                          icon: Icons.person_outline_rounded,
                        ),
                        const SizedBox(height: 20),
                        _buildProfileInput(
                          label: "EMAIL",
                          controller: _emailController,
                          icon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 20),
                        _buildProfileInput(
                          label: "NOMOR HP",
                          controller: _phoneController,
                          icon: Icons.phone_android_outlined,
                          keyboardType: TextInputType.phone,
                        ),
                        const SizedBox(height: 40),

                        // Tombol Simpan
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _saveProfileData,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 2,
                            ),
                            child: const Text(
                              'Simpan Perubahan',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildProfileInput({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    const primaryColor = Color(0xFF14A38B);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFFD1F2EC),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: primaryColor, size: 24),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF8A99A8),
                  letterSpacing: 0.5,
                ),
              ),
              TextField(
                controller: controller,
                keyboardType: keyboardType,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
                decoration: const InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 6),
                  border: InputBorder.none,
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFE0E0E0), width: 1),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: primaryColor, width: 1.5),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}