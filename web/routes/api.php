<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\AuthApiController;
use App\Http\Controllers\Api\DashboardApiController;
use App\Http\Controllers\Api\LaporanController;
use App\Http\Controllers\Api\ReportLogController;
use App\Http\Controllers\Api\ReportSubmissionController;

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
Route::get('/laporan-kendala/{id}', [ReportSubmissionController::class, 'showKendala']); // Route untuk mengambil detail kendala spesifik