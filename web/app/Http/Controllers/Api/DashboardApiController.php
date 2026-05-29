<?php
namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use App\Models\WasteEntry; // 1. Wajib import Model WasteEntry

class DashboardApiController extends Controller
{
    public function getDashboardData(Request $request)
{
    try {
        $nik = $request->query('nik');

        // 1. Ambil data PIC
        $picDetail = DB::table('pic_detail')->where('nik', $nik)->first();

        if (!$picDetail) {
            return response()->json(['success' => false, 'message' => 'NIK tidak terdaftar.'], 200);
        }

        // 2. Ambil Kategori
        $categories = DB::table('waste_category')->get();

        // 3. Ambil Riwayat (Dibuat lebih toleran)
        // Jika model WasteEntry ada masalah, ini akan menangkap error di log Laravel
        $recentEntries = WasteEntry::with(['subCategory.unitMeasured', 'sourceLocation'])
            ->orderBy('created_at', 'desc')
            ->limit(5)
            ->get();

        // 4. Cek apakah kolom photo ada di tabel pic_detail
        // Menggunakan property_exists agar tidak error jika kolomnya tidak ada
        $photo = property_exists($picDetail, 'photo') ? $picDetail->photo : null;

        return response()->json([
            'success' => true,
            'full_name' => $picDetail->full_name ?? 'User',
            'user_photo' => $photo, 
            'categories' => $categories,
            'recent_entries' => $recentEntries,
        ], 200);

    } catch (\Exception $e) {
        return response()->json([
            'success' => false,
            'message' => 'Error Laravel: ' . $e->getMessage()
        ], 200);
    }
}
}