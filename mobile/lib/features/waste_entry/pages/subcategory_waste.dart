import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'form_waste_entry.dart';
import 'package:mobile/core/constants/api_constants.dart';

class SubCategoryPage extends StatefulWidget {
  final Map<String, dynamic> category; // Menerima data kategori dari halaman sebelumnya

  const SubCategoryPage({Key? key, required this.category}) : super(key: key);

  @override
  State<SubCategoryPage> createState() => _SubCategoryPageState();
}

class _SubCategoryPageState extends State<SubCategoryPage> {
  List<dynamic> _subCategories = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchSubCategories();
  }

  Future<void> _fetchSubCategories() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';
      
      // Ambil ID kategori induk
      final categoryId = widget.category['id'];

      // Panggil API Laravel berdasarkan ID Kategori
      final response = await http.get(
        Uri.parse('${ApiConstants.subCategories}/$categoryId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          setState(() {
            _subCategories = data['data'];
            _isLoading = false;
          });
        } else {
          setState(() {
            _errorMessage = 'Gagal memuat jenis sampah';
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
    const primaryColor = Color(0xFF14A38B);
    const bgLightColor = Color(0xFFF4F7F9);

    // Ambil data kosmetik banner dari halaman sebelumnya secara dinamis
    String categoryName = widget.category['name'] ?? 'Jenis Laporan';
    String categoryDesc = widget.category['description'] ?? '-';

    return Scaffold(
      backgroundColor: bgLightColor,
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Pilih Jenis Sampah',
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: primaryColor))
          : _errorMessage.isNotEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(_errorMessage, style: const TextStyle(color: Colors.red)),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: _fetchSubCategories,
                        child: const Text('Coba Lagi'),
                      )
                    ],
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // --- BANNER HEADER (Dinamis sesuai kategori yang diklik) ---
                      Container(
                        margin: const EdgeInsets.all(20),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: const LinearGradient(
                            colors: [Color(0xFF02AAB0), Color(0xFF00CDAC)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Row(
                            children: [
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(Icons.eco_rounded, color: Colors.white, size: 35),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      categoryName,
                                      style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      categoryDesc,
                                      style: const TextStyle(color: Colors.white, fontSize: 11, height: 1.3),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // --- JUDUL SEKSI ---
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 22),
                        child: Text(
                          'Lapor & catat total Sampah Sesuai Kategori',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF264653)),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // --- GRID VIEW DINAMIS (Mengikuti data MySQL `waste_sub_category`) ---
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _subCategories.length,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, // 2 Kotak menyamping
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            mainAxisExtent: 180, // Tinggi kotak
                          ),
                          itemBuilder: (context, index) {
                            final subCat = _subCategories[index];

                            return Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFB74D).withOpacity(0.9), // Warna orange estetik sesuai mockup-mu
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(16),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => InputSampahPage(selectedSubCategory: subCat),
                                      ),
                                    );
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // Logika Gambar / Icon jika Null
                                      subCat['photo_url'] != null && subCat['photo_url'].toString().isNotEmpty
                                          ? ClipRRect(
                                              borderRadius: BorderRadius.circular(12),
                                              child: Image.network(
                                                subCat['photo_url'],
                                                width: 70,
                                                height: 70,
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error, stackTrace) => 
                                                    _buildDefaultIcon(),
                                              ),
                                            )
                                          : _buildDefaultIcon(), // Jika Null di database, tampilkan icon default
                                      const SizedBox(height: 12),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                        child: Text(
                                          subCat['name'] ?? 'Tanpa Nama',
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF264653)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
    );
  }

  // Helper widget untuk menampilkan icon default jika foto sub-kategori kosong
  Widget _buildDefaultIcon() {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        color: const Color(0xFFE9F5F3),
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Center(
        child: Icon(Icons.restore_from_trash_rounded, color: Color(0xFF14A38B), size: 35),
      ),
    );
  }
}