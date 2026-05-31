<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class LaporanController extends Controller
{
    public function index(Request $request)
{
    try {
        $laporan = DB::table('waste_entry')
            ->leftJoin('waste_sub_category', 'waste_entry.id_waste_sub_category', '=', 'waste_sub_category.id')
            ->leftJoin('waste_category', 'waste_sub_category.id_waste_category', '=', 'waste_category.id')
            ->leftJoin('unit_measured', 'waste_sub_category.id_unit_measured', '=', 'unit_measured.id')
            ->select(
                'waste_entry.id', 
                'waste_entry.measured_qty',
                'waste_entry.created_at',
                'waste_sub_category.name as sub_name',
                'waste_category.name as cat_name',   
                'unit_measured.symbol as unit_symbol' 
            )
            ->orderBy('waste_entry.created_at', 'desc')
            ->limit(5)
            ->get();

        $data = $laporan->map(function ($item) {
            $catName = $item->cat_name ?? 'Umum';
            $subName = $item->sub_name ?? 'Sampah';
            $waktu = $item->created_at ? date('d M Y - H:i', strtotime($item->created_at)) . " WIB" : "-";
            $unit = $item->unit_symbol ?? 'Kg';

            return [
                "id" => $item->id, 
                "kategori" => $catName . ", " . $subName,
                "waktu" => $waktu,
                "jumlah" => $item->measured_qty . " " . $unit,
                "isBotol" => str_contains(strtolower($subName), 'botol'),
            ];
        });

        return response()->json([
            'success' => true,
            'data' => $data
        ]);

    } catch (\Exception $e) {
        return response()->json([
            'success' => false,
            'message' => $e->getMessage()
        ], 500);
    }
}

    public function show($id)
    {
        try {
            // Ambil data spesifik berdasarkan ID dengan left join ke semua tabel terkait
            $laporan = DB::table('waste_entry')
                ->leftJoin('waste_sub_category', 'waste_entry.id_waste_sub_category', '=', 'waste_sub_category.id')
                ->leftJoin('waste_category', 'waste_sub_category.id_waste_category', '=', 'waste_category.id')
                ->leftJoin('unit_measured', 'waste_sub_category.id_unit_measured', '=', 'unit_measured.id')
                ->leftJoin('source_location_waste', 'waste_entry.id_source_location_waste', '=', 'source_location_waste.id')
                ->leftJoin('attachment_waste_entry', 'waste_entry.id', '=', 'attachment_waste_entry.id_waste_entry')
                ->select(
                    'waste_entry.id',
                    'waste_entry.measured_qty',
                    'waste_entry.notes',
                    'waste_entry.created_at',
                    'waste_sub_category.name as sub_name',
                    'waste_category.name as cat_name',
                    'unit_measured.symbol as unit_symbol',
                    'source_location_waste.name as location_name',
                    'attachment_waste_entry.path as photo_path' // Alamat file foto lampiran
                )
                ->where('waste_entry.id', '=', $id)
                ->first();

            if (!$laporan) {
                return response()->json(['success' => false, 'message' => 'Data tidak ditemukan'], 404);
            }

            // Susun response data untuk Flutter
            $data = [
                "id" => $laporan->id,
                "sub_kategori" => $laporan->sub_name ?? 'Sampah',
                "kategori_gabung" => ($laporan->cat_name ?? 'Umum') . ", " . ($laporan->sub_name ?? 'Sampah'),
                "waktu_tanggal" => $laporan->created_at ? date('l, d M Y', strtotime($laporan->created_at)) : "-",
                "waktu_jam" => $laporan->created_at ? date('H:i', strtotime($laporan->created_at)) . " WIB" : "-",
                "jumlah" => $laporan->measured_qty ?? '0',
                "satuan" => $laporan->unit_symbol ?? 'Kg',
                "sumber" => $laporan->location_name ?? 'TIDAK DIKETAHUI',
                "catatan" => $laporan->notes ?? 'Tidak ada catatan dari PIC.',
                "foto" => $laporan->photo_path ? asset('storage/' . $laporan->photo_path) : null
            ];

            return response()->json(['success' => true, 'data' => $data]);

        } catch (\Exception $e) {
            return response()->json(['success' => false, 'message' => $e->getMessage()], 500);
        }
    }
}