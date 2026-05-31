import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile/features/navigation/pages/main_navigation.dart';
import 'package:mobile/core/constants/api_constants.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _nikController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;
  bool _isLoading = false; 

  // FUNGSI UTAMA KONEKSI KE LARAVEL
  void _prosesLogin() async {
    String nikInput = _nikController.text.trim();
    String passwordInput = _passwordController.text;

    if (nikInput.isEmpty || passwordInput.isEmpty) {
      _showSnackBar('NIK dan Kata Sandi wajib diisi!', Colors.redAccent);
      return;
    }

    setState(() {
      _isLoading = true; 
    });

    try {
      String url = ApiConstants.login;

      final response = await http.post(
        Uri.parse(url),
        headers: {'Accept': 'application/json'},
        body: {
          'nik': nikInput,
          'password': passwordInput,
        },
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', data['token']);
        await prefs.setString('user_name', data['user']['full_name']);
        await prefs.setString('user_nik', data['user']['nik']);
        await prefs.setString('user_email', data['user']['email'] ?? '');

        _showSnackBar('Login Berhasil! Selamat Datang ${data['user']['full_name']}', Colors.green);

        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MainNavigation()),
          );
        }
      } else {
        _showSnackBar(data['message'] ?? 'Login Gagal', Colors.redAccent);
      }
    } catch (e) {
      _showSnackBar('Gagal terhubung ke server. Pastikan server Laravel menyala.', Colors.redAccent);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false; 
        });
      }
    }
  }

  void _showSnackBar(String pesan, Color warna) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(pesan), backgroundColor: warna),
    );
  }

  @override
  void dispose() {
    _nikController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(15),
          decoration: const BoxDecoration(
            color: Color(0xFF16B3AC),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.home_work_outlined,
            size: 50,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        
        const Text(
          'WasteTrack',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF5A5A5A),
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 35),

        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Nomor Induk Karyawan",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF7A7A7A),
            ),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _nikController,
          keyboardType: TextInputType.number, 
          style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2C3E50)),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFE5EBF2),
            hintText: 'Masukkan NIK Anda',
            hintStyle: const TextStyle(color: Color(0xFF7A8B9B), fontWeight: FontWeight.normal),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 20),

        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Kata Sandi",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF7A7A7A),
            ),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _passwordController,
          obscureText: _obscureText,
          style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2C3E50)),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFE5EBF2),
            hintText: '••••••••',
            hintStyle: const TextStyle(color: Color(0xFF7A8B9B)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            suffixIcon: Padding(
              padding: const EdgeInsets.only(right: 10),
              child: IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined, 
                  color: const Color(0xFF2C3E50)
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 35),

        Container(
          width: double.infinity,
          height: 52,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            gradient: const LinearGradient(
              colors: [Color(0xFF0F9B96), Color(0xFF19D2C9)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            ),
            onPressed: _isLoading ? null : _prosesLogin, 
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                  )
                : const Text(
                    'LOGIN',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1.0),
                  ),
          ),
        ),
      ],
    );
  }
}