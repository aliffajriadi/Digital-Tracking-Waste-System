import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/core/constants/api_constants.dart';

class PengaturanPasswordPage extends StatefulWidget {
  const PengaturanPasswordPage({super.key});

  @override
  State<PengaturanPasswordPage> createState() => _PengaturanPasswordPageState();
}

class _PengaturanPasswordPageState extends State<PengaturanPasswordPage> {
  // Controller dikosongkan agar siap menerima ketikan user
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscureOld = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Menambahkan listener agar UI warna background textfield berubah secara LIVE saat diketik
    _oldPasswordController.addListener(() => setState(() {}));
    _newPasswordController.addListener(() => setState(() {}));
    _confirmPasswordController.addListener(() => setState(() {}));
  }

  // Fungsi Kirim Data Ganti Password ke API Laravel
  void _changePassword() async {
    String oldPassword = _oldPasswordController.text.trim();
    String newPassword = _newPasswordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();

    // 1. Validasi Input di Sisi Flutter
    if (oldPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      _showSnackBar('Semua kolom wajib diisi!', Colors.redAccent);
      return;
    }

    if (newPassword.length < 6) {
      _showSnackBar('Kata sandi baru minimal harus 6 karakter!', Colors.redAccent);
      return;
    }

    if (newPassword != confirmPassword) {
      _showSnackBar('Konfirmasi sandi baru tidak cocok!', Colors.redAccent);
      return;
    }

    setState(() => _isLoading = true);

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String nik = prefs.getString('user_nik') ?? '';

      String url = ApiConstants.changePassword;

      final response = await http.post(
        Uri.parse(url),
        body: {
          'nik': nik,
          'old_password': oldPassword,
          'new_password': newPassword,
        },
      ).timeout(const Duration(seconds: 10));

      var responseData = jsonDecode(response.body);

      setState(() => _isLoading = false);

      if (response.statusCode == 200 && responseData['success'] == true) {
        _showSnackBar('Kata sandi berhasil diubah!', const Color(0xFF14A38B));
        
        // Bersihkan form setelah sukses
        _oldPasswordController.clear();
        _newPasswordController.clear();
        _confirmPasswordController.clear();
        
        if (mounted) Navigator.pop(context);
      } else {
        // Menampilkan pesan eror dari Laravel (misal: "Kata sandi lama salah")
        _showSnackBar(responseData['message'] ?? 'Gagal mengubah kata sandi', Colors.redAccent);
      }
    } catch (e) {
      setState(() => _isLoading = false);
      _showSnackBar('Terjadi kesalahan koneksi: $e', Colors.redAccent);
    }
  }

  void _showSnackBar(String message, Color color) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: color),
      );
    }
  }

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF14A38B);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FA),
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Pengaturan Password',
          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(height: 10, width: double.infinity, color: primaryColor),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 15,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFD1F2EC),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.lock_open_rounded, color: primaryColor, size: 24),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Ganti Kata Sandi',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // KATA SANDI LAMA
                    _buildInputField(
                      label: 'KATA SANDI LAMA',
                      controller: _oldPasswordController,
                      obscureText: _obscureOld,
                      hasValue: _oldPasswordController.text.isNotEmpty, // Otomatis True jika ada teks
                      onToggleVisibility: () => setState(() => _obscureOld = !_obscureOld),
                    ),
                    const SizedBox(height: 20),

                    // KATA SANDI BARU
                    _buildInputField(
                      label: 'KATA SANDI BARU',
                      controller: _newPasswordController,
                      obscureText: _obscureNew,
                      hasValue: _newPasswordController.text.isNotEmpty, // Otomatis True jika ada teks
                      onToggleVisibility: () => setState(() => _obscureNew = !_obscureNew),
                    ),
                    const SizedBox(height: 20),

                    // KONFIRMASI SANDI BARU
                    _buildInputField(
                      label: 'KONFIRMASI SANDI BARU',
                      controller: _confirmPasswordController,
                      obscureText: _obscureConfirm,
                      hasValue: _confirmPasswordController.text.isNotEmpty, // Otomatis True jika ada teks
                      onToggleVisibility: () => setState(() => _obscureConfirm = !_obscureConfirm),
                    ),
                    const SizedBox(height: 24),

                    // Tombol Simpan
                    Align(
                      alignment: Alignment.centerRight,
                      child: SizedBox(
                        width: 120,
                        height: 38,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _changePassword, // Disabled saat loading
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                )
                              : const Text(
                                  'Simpan',
                                  style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required bool obscureText,
    required bool hasValue,
    required VoidCallback onToggleVisibility,
  }) {
    const primaryColor = Color(0xFF14A38B);
    const filledGrey = Color(0xFFE9ECF0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF8A99A8), letterSpacing: 0.5),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: hasValue ? primaryColor : filledGrey,
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            cursorColor: hasValue ? Colors.white : Colors.black87,
            style: TextStyle(
              color: hasValue ? Colors.white : Colors.black87,
              fontSize: 14,
              letterSpacing: obscureText ? 3.0 : 1.0,
            ),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: InputBorder.none,
              suffixIcon: IconButton(
                icon: Icon(
                  obscureText ? Icons.visibility_off_rounded : Icons.remove_red_eye_rounded,
                  color: hasValue ? Colors.white.withOpacity(0.9) : primaryColor,
                  size: 20,
                ),
                onPressed: onToggleVisibility,
              ),
            ),
          ),
        ),
      ],
    );
  }
}