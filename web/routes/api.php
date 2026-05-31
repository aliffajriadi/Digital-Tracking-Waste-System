<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\AuthApiController;
use App\Http\Controllers\Api\DashboardApiController;
use App\Http\Controllers\Api\LaporanController;
use App\Http\Controllers\Api\ReportLogController;
use App\Http\Controllers\Api\ReportSubmissionController;
use App\Http\Controllers\Api\CategoryController;
use App\Http\Controllers\Api\SubCategoryController;
use App\Http\Controllers\Api\SourceLocationController;
use App\Http\Controllers\Api\WasteEntryController;
use App\Http\Controllers\Api\ProcessedWasteController;
use App\Http\Controllers\Api\WasteOutController;
use App\Http\Controllers\Api\NotificationController;

Route::get('/user', function (Request $request) {
    return $request->user();
})->middleware('auth:sanctum');

// Jalur API Login untuk Flutter
Route::post('/login', [AuthApiController::class, 'login']);
Route::post('/update-profile', [AuthApiController::class, 'updateProfile']);
Route::post('/change-password', [AuthApiController::class, 'changePassword']); 

// Route untuk dashboard data
Route::get('/dashboard-data', [DashboardApiController::class, 'getDashboardData']);
// Route untuk laporan data
Route::get('/laporan-harian', [LaporanController::class, 'index']);
Route::get('/laporan-harian/{id}', [LaporanController::class, 'show']);

// Route untuk riwayat laporan
Route::get('/riwayat-laporan', [ReportLogController::class, 'history']);

// Route untuk submit laporan kendala
Route::get('/kategori-kendala', [ReportSubmissionController::class, 'getCategories']);
Route::post('/laporan-kendala', [ReportSubmissionController::class, 'storeKendala']);
Route::get('/laporan-kendala/{id}', [ReportSubmissionController::class, 'showKendala']); 

// Route untuk kategori
Route::get('/categories', [CategoryController::class, 'index']);

// Route untuk sub-kategori berdasarkan kategori
Route::get('/sub-categories/{category_id}', [SubCategoryController::class, 'getByCategoryId']);

// Route untuk lokasi sumber sampah
Route::get('/source-locations', [SourceLocationController::class, 'index']);

Route::middleware('auth:sanctum')->group(function () {
    Route::post('/waste-entry', [WasteEntryController::class, 'store']);
});

// Route untuk sampah yang sudah diproses
Route::get('/processed-waste', [ProcessedWasteController::class, 'index']);
Route::middleware('auth:sanctum')->group(function () { 
    Route::post('/processed-waste-data', [ProcessedWasteController::class, 'store']);
});

// Route untuk metode pengeluaran sampah
Route::get('/waste-out-methods', [WasteOutController::class, 'index']);
Route::get('/waste-subcategories', [WasteOutController::class, 'getSubcategories']);
Route::middleware('auth:sanctum')->group(function () {
    Route::post('/waste-out', [WasteOutController::class, 'store']);
});


Route::get(
    '/waste-b3-notifications',
    [NotificationController::class, 'getWarnings']
);
