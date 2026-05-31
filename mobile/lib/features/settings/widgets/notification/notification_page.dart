import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:mobile/core/constants/api_constants.dart';

class NotifikasiPage extends StatefulWidget {
  const NotifikasiPage({super.key});

  @override
  State<NotifikasiPage> createState() => _NotifikasiPageState();
}

class _NotifikasiPageState extends State<NotifikasiPage> {
  List<dynamic> _notificationList = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchNotifikasiB3();
  }

  // --- AMBIL DATA DARI API LARAVEL ---
  Future<void> _fetchNotifikasiB3() async {
    try {
      // FIX: Sekarang kita panggil langsung konstanta yang baru dibuat tadi
      final response = await http.get(Uri.parse(ApiConstants.wasteB3Notifications));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _notificationList = data['data'] ?? [];
          _errorMessage = null;
          _isLoading = false;
        });
      } else {
        final errorData = json.decode(response.body);
        setState(() {
          _errorMessage = errorData['message'] ?? 'Gagal memuat data (Status: ${response.statusCode})';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Terjadi kesalahan koneksi: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF14A38B);

    return Scaffold(
      backgroundColor: const Color(0xFFF1F2F6),
      body: Column(
        children: [
          // HEADER CUSTOM
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 60, left: 20, right: 20, bottom: 25),
            decoration: const BoxDecoration(
              color: primaryColor,
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 8),
                const Text(
                  "Peringatan Masa Simpan B3",
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          const SizedBox(height: 15),

          // AREA KONTEN NOTIFIKASI
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: primaryColor))
                : _errorMessage != null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 24),
                              child: Text(_errorMessage!, style: const TextStyle(color: Colors.red), textAlign: TextAlign.center),
                            ),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: _fetchNotifikasiB3,
                              style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
                              child: const Text('Coba Lagi', style: TextStyle(color: Colors.white)),
                            )
                          ],
                        ),
                      )
                    : _notificationList.isEmpty
                        ? const Center(
                            child: Padding(
                              padding: EdgeInsets.all(24.0),
                              child: Text(
                                'Aman! Tidak ada limbah B3 yang mendekati batas waktu penyimpanan.',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.grey, fontSize: 14),
                              ),
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: _fetchNotifikasiB3,
                            color: primaryColor,
                            child: ListView.builder(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              itemCount: _notificationList.length,
                              itemBuilder: (context, index) {
                                return NotificationCard(data: _notificationList[index]);
                              },
                            ),
                          ),
          ),
        ],
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final Map<String, dynamic> data;

  const NotificationCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    String itemTitle = data['waste_name'] ?? '-';
    String wasteCode = data['waste_code'] ?? '-';
    int sisaHari = data['sisa_hari'] ?? 0;
    
    DateTime tglMasuk = DateTime.tryParse(data['created_at'] ?? '') ?? DateTime.now();
    String formattedDate = DateFormat('dd MMM yyyy').format(tglMasuk);

    Color statusColor;
    String statusLabel;
    IconData statusIcon;

    // Logika visual: Karena data sudah pasti <= 10 hari, saring menjadi 2 kondisi kritis
    if (sisaHari <= 0) {
      statusColor = Colors.red;
      statusLabel = "Masa Simpan Habis (${sisaHari.abs()} hari yang lalu)";
      statusIcon = Icons.dangerous_rounded;
    } else {
      statusColor = Colors.orange;
      statusLabel = "Peringatan: Sisa $sisaHari Hari Lagi!";
      statusIcon = Icons.warning_amber_rounded;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 6,
            offset: const Offset(0, 3),
          )
        ],
        border: Border(left: BorderSide(color: statusColor, width: 5)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: statusColor.withOpacity(0.1),
            child: Icon(statusIcon, color: statusColor, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        wasteCode,
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.blueGrey),
                      ),
                    ),
                    Text(
                      "Masuk: $formattedDate",
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  itemTitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF264653)),
                ),
                const SizedBox(height: 6),
                Text(
                  statusLabel,
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: statusColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}