@extends('layouts.app')

@section('title', 'Dashboard | WasteTracking')
@section('page-title', 'Dashboard')

@section('content')
<div class="max-w-7xl mx-auto">

    <div class="bg-white border border-gray-200 rounded-2xl shadow-sm overflow-hidden mb-8">
        <div class="bg-[#3DBFA6]/10 border-b border-gray-100 px-8 py-4">
            <span class="bg-[#3DBFA6] text-white text-[10px] font-bold px-2 py-1 rounded uppercase tracking-wider">
                Info
            </span>
        </div>

        <div class="p-8">
            <h2 class="text-2xl font-bold text-gray-800 mb-2 leading-tight">
                Selamat Datang di Sistem Monitoring Rumah Sampah
            </h2>
            <p class="text-gray-500 text-sm">
                Kelola data operasional harian secara efisien dan terintegrasi.
            </p>
        </div>
    </div>

    <div class="border-4 border-dashed border-gray-200 rounded-3xl h-[400px] flex items-center justify-center bg-white">
        <p class="text-gray-300 font-black text-4xl tracking-widest uppercase">
            Hello World
        </p>
    </div>

</div>
@endsection