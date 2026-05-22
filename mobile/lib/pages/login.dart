import 'package:flutter/material.dart';
import 'package:mobile/components/main_navigation.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FA),
      body: Stack(
        children: [
          Positioned(
            top: -screenHeight * 0.35,
            left: -200,
            right: -200,
            child: Container(
              height: screenHeight * 0.85,
              decoration: const BoxDecoration(
                color: Color(0xFF16B3AC),
                shape: BoxShape.circle,
              ),
            ),
          ),

          // Konten Utama
          Center(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 25),
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 35),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    )
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // LOGO BULAT HIJAU
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
                    
                    // TEKS WASTETRACK
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

                    // INPUT NOMOR INDUK KARYAWAN
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
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2C3E50)),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFFE5EBF2),
                        hintText: '7493074917',
                        hintStyle: const TextStyle(color: Color(0xFF7A8B9B)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // INPUT KATA SANDI
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
                      obscureText: true,
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2C3E50)),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFFE5EBF2),
                        hintText: '••••••••',
                        hintStyle: const TextStyle(color: Color(0xFF7A8B9B)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        suffixIcon: const Padding(
                          padding: EdgeInsets.only(right: 10),
                          child: Icon(Icons.visibility_off_outlined, color: Color(0xFF2C3E50)),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 35),

                    // TOMBOL LOGIN DENGAN GRADASI WARNA
                    Container(
                      width: double.infinity,
                      height: 52,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF0F9B96),
                            Color(0xFF19D2C9),
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF16B3AC).withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          )
                        ],
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        onPressed: () {
                          // Menggunakan push biasa (tidak menghancurkan halaman login)
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const MainNavigation()),
                          );
                        },
                        child: const Text(
                          'LOGIN',
                          style: TextStyle(
                            fontSize: 16, 
                            fontWeight: FontWeight.bold, 
                            color: Colors.white,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}