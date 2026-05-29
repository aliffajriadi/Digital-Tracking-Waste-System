import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';

// Import model di atas jika dipisah filenya
// import 'package:your_app/models/waste_models.dart';

class InputSampahPage extends StatefulWidget {
  // Sekarang menerima objek utuh Sub Kategori hasil pilihan dari halaman sebelumnya
  final WasteSubCategory selectedSubCategory;

  const InputSampahPage({super.key, required this.selectedSubCategory});

  @override
  State<InputSampahPage> createState() => _InputSampahPageState();
}

class _InputSampahPageState extends State<InputSampahPage> {
  final _kuantitasController = TextEditingController();
  final _catatanController = TextEditingController();

  SourceLocationWaste? _selectedSumberLocation;
  DateTime _waktuTerpilih = DateTime.now();
  File? _buktiFoto;
  final ImagePicker _picker = ImagePicker();

  // Data Dummy Sumber Lokasi berfoto (Nanti di-fetch dari API source_location_waste)
  final List<SourceLocationWaste> _sumberLokasiList = [
    SourceLocationWaste(id: 1, name: "WORKSHOP", photo: "https://via.placeholder.com/150"),
    SourceLocationWaste(id: 2, name: "GEDUNG TECHNOPRENOUR", photo: "https://via.placeholder.com/150"),
    SourceLocationWaste(id: 3, name: "GEDUNG UTAMA", photo: "https://via.placeholder.com/150"),
    SourceLocationWaste(id: 4, name: "KANTIN", photo: "https://via.placeholder.com/150"),
  ];

  @override
  void dispose() {
    _kuantitasController.dispose();
    _catatanController.dispose();
    super.dispose();
  }

  // --- AMBIL FOTO BUKTI ---
  Future<void> _ambilFotoBukti() async {
  try {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 70,
    );

    if (image != null) {
      setState(() {
        _buktiFoto = File(image.path);
      });
    }
  } catch (e) {
    // Menampilkan pesan error di log konsol jika kamera gagal terbuka
    debugPrint("Gagal mengambil foto: $e");
    
    // Opsional: tampilin snackbar biar PIC tahu kalau kameranya bermasalah
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Gagal membuka kamera: Silakan cek izin aplikasi.")),
    );
  }
}

  // --- PICKER TANGGAL & WAKTU ---
  Future<void> _pilihWaktu(BuildContext context) async {
    final DateTime? tanggalPicked = await showDatePicker(
      context: context,
      initialDate: _waktuTerpilih,
      firstDate: DateTime(2025),
      lastDate: DateTime(2030),
    );

    if (tanggalPicked != null) {
      final TimeOfDay? waktuPicked = await showTimePicker(
        // ignore: use_build_context_synchronously
        context: context,
        initialTime: TimeOfDay.fromDateTime(_waktuTerpilih),
      );

      if (waktuPicked != null) {
        setState(() {
          _waktuTerpilih = DateTime(
            tanggalPicked.year,
            tanggalPicked.month,
            tanggalPicked.day,
            waktuPicked.hour,
            waktuPicked.minute,
          );
        });
      }
    }
  }

  // --- BOTTOM SHEET SUMBER LOKASI BERFOTO ---
  void _showSumberLokasiBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          height: MediaQuery.of(context).size.height * 0.6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Sumber Sampah",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF264653)),
              ),
              const Divider(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: _sumberLokasiList.length,
                  itemBuilder: (context, index) {
                    final lokasi = _sumberLokasiList[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.black12),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(8),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: lokasi.photo != null
                              ? Image.network(lokasi.photo!, width: 60, height: 60, fit: BoxFit.cover)
                              : Container(color: Colors.grey, width: 60, height: 60),
                        ),
                        title: Text(
                          lokasi.name,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          setState(() {
                            _selectedSumberLocation = lokasi;
                          });
                          Navigator.pop(context);
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF14A38B);
    const darkBlueColor = Color(0xFF264653);
    const bgLightColor = Color(0xFFF4F7F9);

    String waktuStringFormatted = "${DateFormat('dd MMM yyyy, HH:mm').format(_waktuTerpilih)} WIB";
    var subKat = widget.selectedSubCategory;

    return Scaffold(
      backgroundColor: bgLightColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Input Sampah Masuk',
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. INFO JENIS SAMPAH TERPILIH (DARI HALAMAN SEBELUMNYA)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.black12),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: subKat.photo != null
                        ? Image.network(subKat.photo!, width: 65, height: 65, fit: BoxFit.cover)
                        : Container(color: const Color(0xFFD1F2EC), width: 65, height: 65, child: const Icon(Icons.delete, color: primaryColor)),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          subKat.categoryName ?? "Kategori",
                          style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          subKat.name,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: darkBlueColor),
                        ),
                        // Kondisional Jika Limbah Tergolong B3 (Menampilkan Kode Sampah B3)
                        if (subKat.b3Detail != null)
                          Container(
                            margin: const EdgeInsets.only(top: 4),
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(color: Colors.red.shade100, borderRadius: BorderRadius.circular(4)),
                            child: Text(
                              "B3: ${subKat.b3Detail!.wasteCode}",
                              style: TextStyle(color: Colors.red.shade800, fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                          )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 2. WAKTU TRANSAKSI
            _buildLabel("Waktu Pengisian / Transaksi"),
            InkWell(
              onTap: () => _pilihWaktu(context),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.black12)),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_month_rounded, color: primaryColor, size: 20),
                    const SizedBox(width: 12),
                    Expanded(child: Text(waktuStringFormatted, style: const TextStyle(fontWeight: FontWeight.w600, color: darkBlueColor))),
                    const Icon(Icons.edit_calendar_rounded, color: Colors.grey, size: 18),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 3. SELEKSI SUMBER LOKASI (BOTTOM SHEET BERFOTO)
            _buildLabel("Sumber Lokasi"),
            InkWell(
              onTap: _showSumberLokasiBottomSheet,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.black12)),
                child: Row(
                  children: [
                    const Icon(Icons.location_on_rounded, color: primaryColor, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _selectedSumberLocation == null
                          ? const Text("Pilih lokasi sumber sampah...", style: TextStyle(color: Colors.grey))
                          : Text(_selectedSumberLocation!.name, style: const TextStyle(fontWeight: FontWeight.w600, color: darkBlueColor)),
                    ),
                    const Icon(Icons.arrow_drop_down_circle_rounded, color: Colors.grey, size: 20),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 4. KUANTITAS BERDASARKAN SATUAN UKUR MASTER DATA
            _buildLabel("Kuantitas Data"),
            Container(
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.black12)),
              child: TextField(
                controller: _kuantitasController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  hintText: "0.00",
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(16),
                  // Mengambil Simbol Satuan Ukuran secara dinamis dari database (Misal: Kg / L)
                  suffixText: subKat.unitMeasured.symbol,
                  suffixStyle: const TextStyle(fontWeight: FontWeight.bold, color: darkBlueColor, fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 5. UPLOAD BUKTI FOTO
            _buildLabel("Upload Bukti Foto"),
            InkWell(
              onTap: _ambilFotoBukti,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: double.infinity,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.black12),
                ),
                child: _buktiFoto != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(_buktiFoto!, fit: BoxFit.cover, width: double.infinity),
                      )
                    : const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.camera_alt_rounded, size: 40, color: Colors.grey),
                          SizedBox(height: 8),
                          Text("Ambil Foto Lewat Kamera", style: TextStyle(color: Colors.grey, fontSize: 12)),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 16),

            // 6. CATATAN PIC
            _buildLabel("Catatan Dari PIC"),
            Container(
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.black12)),
              child: TextField(
                controller: _catatanController,
                maxLines: 3,
                decoration: const InputDecoration(hintText: "Tulis catatan tambahan di sini...", border: InputBorder.none, contentPadding: EdgeInsets.all(16)),
              ),
            ),
            const SizedBox(height: 32),

            // ACTION BUTTON
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: const BorderSide(color: Colors.grey),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text("Batal", style: TextStyle(color: Colors.black87)),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Di sini kirim data ke API simpan:
                      // - widget.selectedSubCategory.id
                      // - _waktuTerpilih (Format ke string ISO/Y-m-d H:i:s sebelum kirim)
                      // - _selectedSumberLocation?.id
                      // - _kuantitasController.text
                      // - _buktiFoto (Multi-part file upload)
                      // - _catatanController.text
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text("Simpan Data", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(text, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black54)),
    );
  }
}

class UnitMeasured {
  final int id;
  final String name;
  final String symbol;

  UnitMeasured({required this.id, required this.name, required this.symbol});
}

class WasteB3Detail {
  final String wasteCode;
  final String dangerLevel;

  WasteB3Detail({required this.wasteCode, required this.dangerLevel});
}

class WasteSubCategory {
  final int id;
  final String name;
  final String? categoryName;
  final String? photo;
  final UnitMeasured unitMeasured;
  final WasteB3Detail? b3Detail;

  WasteSubCategory({
    required this.id,
    required this.name,
    this.categoryName,
    this.photo,
    required this.unitMeasured,
    this.b3Detail,
  });
}

class SourceLocationWaste {
  final int id;
  final String name;
  final String? photo;

  SourceLocationWaste({required this.id, required this.name, this.photo});
}