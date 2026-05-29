<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\CategoryReport;
use App\Models\Report;
use Illuminate\Support\Facades\DB;

class ReportSubmissionController extends Controller
{
    // Fungsi untuk mengambil daftar kategori (Untuk Dropdown Flutter)
    public function getCategories()
    {
        try {
            $categories = CategoryReport::all();
            
            return response()->json([
                'success' => true,
                'data' => $categories
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal mengambil kategori: ' . $e->getMessage()
            ], 500);
        }
    }

    // Fungsi untuk menyimpan input data kendala dari Flutter
    public function storeKendala(Request $request)
    {
        $request->validate([
            'id_user' => 'required',
            'id_category_report' => 'required',
            'title' => 'required|string|max:255',
            'content' => 'required|string',
            'attachment' => 'nullable|file|mimes:png,jpg,jpeg,pdf,doc,docx|max:5120',
        ]);

        try {
            DB::beginTransaction();

            // 1. Simpan ke tabel report
            $report = Report::create([
                'id_user' => $request->id_user,
                'id_category_report' => $request->id_category_report,
                'title' => $request->title,
                'content' => $request->content,
            ]);

            // 2. Simpan file lampiran jika ada
            if ($request->hasFile('attachment')) {
                $file = $request->file('attachment');
                $path = $file->store('attachments/reports', 'public');

                DB::table('attachment_report')->insert([
                    'id_report' => $report->id,
                    'path' => $path,
                ]);
            }

            DB::commit();

            return response()->json([
                'success' => true,
                'message' => 'Laporan kendala berhasil disimpan!',
                'data' => $report
            ], 201);

        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json([
                'success' => false,
                'message' => 'Gagal menyimpan laporan: ' . $e->getMessage()
            ], 500);
        }
    }

    // Fungsi untuk mengambil detail satu laporan kendala berdasarkan ID
    public function showKendala($id)
    {
        try {
            // 1. Ambil data report mentah
            $report = Report::find($id);

            if (!$report) {
                return response()->json([
                    'success' => false,
                    'message' => 'Laporan kendala tidak ditemukan.'
                ], 404);
            }

            // 2. Ambil nama kategori langsung dari tabel induknya
            $category = DB::table('category_report')
                ->where('id', $report->id_category_report)
                ->first();

            // 3. Ambil data lampiran foto
            $attachment = DB::table('attachment_report')
                ->where('id_report', $id)
                ->first();

            // 4. Susun respond JSON yang super aman dari data null
            $responseData = [
                'id' => $report->id,
                'id_user' => $report->id_user,
                'category_name' => $category ? $category->name : 'Kategori Umum',
                'title' => $report->title,
                'content' => $report->content,
                'attachment_path' => $attachment ? asset('storage/' . $attachment->path) : null,
            ];

            return response()->json([
                'success' => true,
                'data' => $responseData
            ], 200);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal mengambil detail laporan: ' . $e->getMessage()
            ], 500);
        }
    }
}