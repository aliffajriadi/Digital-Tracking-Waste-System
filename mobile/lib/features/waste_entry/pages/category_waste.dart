import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'subcategory_waste.dart';
import 'package:mobile/core/constants/api_constants.dart';

class PilihKategoriPage extends StatefulWidget {
  const PilihKategoriPage({Key? key}) : super(key: key);

  @override
  State<PilihKategoriPage> createState() => _PilihKategoriPageState();
}

class _PilihKategoriPageState extends State<PilihKategoriPage> {
  List<dynamic> _categories = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      final response = await http.get(
        Uri.parse(ApiConstants.categories),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          setState(() {
            _categories = data['data'];
            _isLoading = false;
          });
        } else {
          setState(() {
            _errorMessage = 'Gagal memuat kategori';
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _errorMessage = 'Error server: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Koneksi gagal. Pastikan backend menyala.';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pilih Kategori Sampah',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF14A38B), // Warna hijau tosca sesuai desain
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF14A38B)))
          : _errorMessage.isNotEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(_errorMessage, style: const TextStyle(color: Colors.red)),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: _fetchCategories,
                        child: const Text('Coba Lagi'),
                      )
                    ],
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Pilih kategori sampah yang sesuai',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: ListView.builder(
                          itemCount: _categories.length,
                          itemBuilder: (context, index) {
                            final category = _categories[index];
                            
                            // Menentukan warna background kartu berdasarkan index secara dinamis/manual
                            List<Color> cardColors = [
                              const Color(0xFF00BFA6), // Teal/Hijau
                              const Color(0xFFFFB74D), // Orange
                              const Color(0xFFE57373), // Merah/B3
                            ];
                            Color bgColor = cardColors[index % cardColors.length];

                            return Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                color: bgColor,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(12),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SubCategoryPage(category: category),
                                    ),
                                  );
                                  print('Kategori dipilih: ${category['name']} (ID: ${category['id']})');
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Row(
                                    children: [
                                      // Bagian Gambar dengan pengecekan kondisi Null / Kosong yang sudah diperbaiki
                                      category['photo_url'] != null && category['photo_url'].toString().isNotEmpty
                                          ? ClipRRect(
                                              borderRadius: BorderRadius.circular(8),
                                              child: Image.network(
                                                category['photo_url'],
                                                width: 60,
                                                height: 60,
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error, stackTrace) {
                                                  // Jika URL ada tapi gambar rusak saat di-load (error 404)
                                                  return Container(
                                                    width: 60,
                                                    height: 60,
                                                    color: Colors.white24,
                                                    child: const Icon(Icons.image_not_supported, color: Colors.white, size: 30),
                                                  );
                                                },
                                              ),
                                            )
                                          : Container(
                                              width: 60,
                                              height: 60,
                                              decoration: BoxDecoration(
                                                color: Colors.white.withOpacity(0.2),
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: const Icon(
                                                Icons.delete_outline, 
                                                color: Colors.white, 
                                                size: 32
                                              ),
                                            ),
                                      const SizedBox(width: 16),
                                      // Bagian Teks Nama & Deskripsi Kategori
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              category['name'] ?? 'Tanpa Nama',
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              category['description'] ?? 'Tidak ada deskripsi',
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.white70,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Icon(
                                        Icons.chevron_right,
                                        color: Colors.white,
                                        size: 30,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}