<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\WasteEntry;
use App\Models\WasteOutData;
use App\Models\ProcessedWasteData;
use App\Models\Report;

class ReportLogController extends Controller
{
    public function history(Request $request)
    {
        try {
            $search = $request->query('search');
            $type = $request->query('type'); // Filter menu: 1=Masuk, 2=Keluar, 3=Olahan, 4=Kendala

            $allLogs = collect();

            // 1. AMBIL DATA MASUK (waste_entry)
            if (empty($type) || $type == 1) {
                $queryMasuk = WasteEntry::with(['subCategory']);
                
                if (!empty($search)) {
                    $queryMasuk->whereHas('subCategory', function($q) use ($search) {
                        $q->where('name', 'LIKE', "%{$search}%");
                    });
                }

                $masuk = $queryMasuk->orderBy('id', 'desc')->get()->map(function ($item) {
                    return [
                        'id' => $item->id,
                        'type_log' => 'input_masuk',
                        'title' => 'Input Masuk: ' . ($item->subCategory->name ?? 'Sampah'),
                        'time_display' => $item->created_at ? $item->created_at->format('H:i') . ' WIB' : '-',
                        'amount' => number_format($item->measured_qty, 0, ',', '.') . ' Kg',
                        'timestamp' => $item->created_at ? $item->created_at->timestamp : 0,
                        'date_group' => $item->created_at ? $item->created_at->translatedFormat('l, d M Y') : 'Tanpa Tanggal'
                    ];
                });
                $allLogs = $allLogs->merge($masuk);
            }

            // 2. AMBIL DATA KELUAR (waste_out_data)
            if (empty($type) || $type == 2) {
                $queryKeluar = WasteOutData::with(['dataWasteOut.wasteSubCategory', 'dataWasteOut.processedWaste']);
                
                if (!empty($search)) {
                    $queryKeluar->whereHas('dataWasteOut.wasteSubCategory', function($q) use ($search) {
                        $q->where('name', 'LIKE', "%{$search}%");
                    })->orWhereHas('dataWasteOut.processedWaste', function($q) use ($search) {
                        $q->where('name', 'LIKE', "%{$search}%");
                    });
                }

                $keluar = $queryKeluar->orderBy('id', 'desc')->get()->flatMap(function ($item) {
                    // Karena satu transaksi keluar bisa berisi banyak item sampah, kita pecah per detail item sampah
                    return $item->dataWasteOut->map(function ($detail) use ($item) {
                        $namaSampah = $detail->is_processed_waste == 1 
                            ? ($detail->processedWaste->name ?? 'Produk Olahan')
                            : ($detail->wasteSubCategory->name ?? 'Sampah Mentah');

                        return [
                            'id' => $item->id, // Kirim ID utama untuk detail halaman
                            'type_log' => 'input_keluar',
                            'title' => 'Input Keluar: ' . $namaSampah,
                            'time_display' => $item->created_at ? $item->created_at->format('H:i') . ' WIB' : '-',
                            'amount' => number_format($detail->measured_qty, 0, ',', '.') . ' Kg',
                            'timestamp' => $item->created_at ? $item->created_at->timestamp : 0,
                            'date_group' => $item->created_at ? $item->created_at->translatedFormat('l, d M Y') : 'Tanpa Tanggal'
                        ];
                    });
                });
                $allLogs = $allLogs->merge($keluar);
            }

            // 3. AMBIL DATA HASIL OLAHAN (processed_waste_data)
            if (empty($type) || $type == 3) {
                $queryOlahan = ProcessedWasteData::with(['processedWaste']);

                if (!empty($search)) {
                    $queryOlahan->whereHas('processedWaste', function($q) use ($search) {
                        $q->where('name', 'LIKE', "%{$search}%");
                    });
                }

                $olahan = $queryOlahan->orderBy('id', 'desc')->get()->map(function ($item) {
                    return [
                        'id' => $item->id,
                        'type_log' => 'olahan',
                        'title' => 'Olahan: ' . ($item->processedWaste->name ?? 'Produk Jadi'),
                        'time_display' => $item->created_at ? $item->created_at->format('H:i') . ' WIB' : '-',
                        'amount' => number_format($item->measured_qty, 0, ',', '.') . ' Kg',
                        'timestamp' => $item->created_at ? $item->created_at->timestamp : 0,
                        'date_group' => $item->created_at ? $item->created_at->translatedFormat('l, d M Y') : 'Tanpa Tanggal'
                    ];
                });
                $allLogs = $allLogs->merge($olahan);
            }

            // 4. AMBIL DATA KENDALA (report)
            if (empty($type) || $type == 4) {
                $queryKendala = Report::query();

                if (!empty($search)) {
                    $queryKendala->where('title', 'LIKE', "%{$search}%")
                                 ->orWhere('content', 'LIKE', "%{$search}%");
                }

                $kendala = $queryKendala->orderBy('id', 'desc')->get()->map(function ($item) {
                    return [
                        'id' => $item->id,
                        'type_log' => 'kendala',
                        'title' => 'Kendala: ' . ($item->title ?? 'Tidak Ada Judul'),
                        'time_display' => 'Catatan', // Sesuai kesepakatan, karena tidak ada created_at
                        'amount' => '1 Berkas',
                        'timestamp' => $item->id, // Akali urutan berdasarkan besaran ID karena tidak ada waktu
                        'date_group' => 'Laporan Kendala Lapangan' // Kita kelompokkan ke section tersendiri
                    ];
                });
                $allLogs = $allLogs->merge($kendala);
            }

            // --- PROSES INTERPOLASI DAN PENGURUTAN GABUNGAN ---
            // Pisahkan kendala dan data bertanggal agar pengurutan waktu tidak berantakan
            $dataBerwaktu = $allLogs->where('type_log', '!=', 'kendala')->sortByDesc('timestamp');
            $dataKendala = $allLogs->where('type_log', '==', 'kendala')->sortByDesc('id');

            // Gabungkan kembali (Data berwaktu di atas, Kendala di bagian kelompoknya)
            $sortedLogs = $dataBerwaktu->merge($dataKendala);

            // Kelompokkan hasil akhir berdasarkan key 'date_group'
            $groupedData = $sortedLogs->groupBy('date_group');

            // Buat menu opsi filter untuk diserahkan ke Flutter
            $categories = [
                ['id' => 1, 'name' => 'Input Masuk'],
                ['id' => 2, 'name' => 'Input Keluar'],
                ['id' => 3, 'name' => 'Hasil Olahan'],
                ['id' => 4, 'name' => 'Laporan Kendala'],
            ];

            return response()->json([
                'success' => true,
                'categories' => $categories,
                'data' => $groupedData
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => $e->getMessage()
            ], 500);
        }
    }
}