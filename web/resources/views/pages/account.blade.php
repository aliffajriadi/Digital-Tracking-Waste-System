@extends('layouts.app')

@section('title', 'Kelola Pengguna | WasteTracking')
@section('page-title', 'Kelola Pengguna')

@section('content')
<div x-data="{ openModal: false }">

    <div class="max-w-7xl mx-auto space-y-6">
        <!-- Header -->
        <div class="flex flex-col md:flex-row md:items-center md:justify-between gap-4">
            <div>
                <h1 class="text-2xl font-extrabold text-gray-800">Kelola Pengguna</h1>
                <p class="text-sm text-gray-500 mt-1">
                    Tambah dan kelola akun PIC Rumah Sampah.
                </p>
            </div>

            <button @click="openModal = true"
                class="inline-flex items-center justify-center gap-2 bg-[#3DBFA6] hover:bg-[#32aa94] text-white text-sm font-bold px-5 py-3 rounded-xl shadow-sm transition">
                <i data-lucide="plus" class="w-4 h-4"></i>
                Tambah PIC
            </button>
        </div>

        <!-- Tabel Data PIC -->
        <div class="bg-white border border-gray-200 rounded-2xl shadow-sm overflow-hidden">
            <div class="px-7 py-5 border-b border-gray-100 flex flex-col md:flex-row md:items-center md:justify-between gap-4">
                <div>
                    <h2 class="text-sm font-bold text-gray-800">Daftar Pengguna PIC</h2>
                    <p class="text-xs text-gray-400 mt-1">Data akun PIC yang sudah terdaftar.</p>
                </div>

                <div class="relative">
                    <i data-lucide="search" class="w-4 h-4 text-gray-400 absolute left-3 top-1/2 -translate-y-1/2"></i>
                    <input type="text" placeholder="Cari pengguna..."
                        class="w-full md:w-64 h-10 pl-10 pr-4 bg-gray-50 border border-gray-200 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-[#3DBFA6]/20 focus:border-[#3DBFA6]">
                </div>
            </div>

            <div class="overflow-x-auto">
                <table class="w-full text-sm">
                    <thead class="bg-gray-50 text-gray-400 text-[11px] uppercase tracking-wider">
                        <tr>
                            <th class="px-7 py-4 text-left">Pengguna</th>
                            <th class="px-7 py-4 text-left">NIK</th>
                            <th class="px-7 py-4 text-left">Nomor HP</th>
                            <th class="px-7 py-4 text-left">Status</th>
                            <th class="px-7 py-4 text-right">Aksi</th>
                        </tr>
                    </thead>

                    <tbody class="divide-y divide-gray-100">
                        <tr class="hover:bg-gray-50">
                            <td class="px-7 py-4">
                                <div class="flex items-center gap-3">
                                    <div class="w-10 h-10 rounded-xl bg-[#3DBFA6] text-white flex items-center justify-center font-bold">
                                        AF
                                    </div>
                                    <div>
                                        <p class="font-bold text-gray-800">Alif Fajriadi</p>
                                        <p class="text-xs text-gray-400">alif@email.com</p>
                                    </div>
                                </div>
                            </td>
                            <td class="px-7 py-4 text-gray-600">217102xxxx</td>
                            <td class="px-7 py-4 text-gray-600">0812-3456-7890</td>
                            <td class="px-7 py-4">
                                <span class="bg-green-50 text-green-600 text-[10px] font-bold px-3 py-1 rounded-full">
                                    Aktif
                                </span>
                            </td>
                            <td class="px-7 py-4">
                                <div class="flex justify-end gap-2">
                                    <button class="w-9 h-9 rounded-lg bg-blue-50 text-blue-500 hover:bg-blue-100 flex items-center justify-center">
                                        <i data-lucide="pencil" class="w-4 h-4"></i>
                                    </button>
                                    <button class="w-9 h-9 rounded-lg bg-red-50 text-red-500 hover:bg-red-100 flex items-center justify-center">
                                        <i data-lucide="trash-2" class="w-4 h-4"></i>
                                    </button>
                                </div>
                            </td>
                        </tr>

                        <tr class="hover:bg-gray-50">
                            <td class="px-7 py-4">
                                <div class="flex items-center gap-3">
                                    <div class="w-10 h-10 rounded-xl bg-gray-300 text-white flex items-center justify-center font-bold">
                                        NA
                                    </div>
                                    <div>
                                        <p class="font-bold text-gray-800">Nayla</p>
                                        <p class="text-xs text-gray-400">nayla@email.com</p>
                                    </div>
                                </div>
                            </td>
                            <td class="px-7 py-4 text-gray-600">217103xxxx</td>
                            <td class="px-7 py-4 text-gray-600">0821-7788-9900</td>
                            <td class="px-7 py-4">
                                <span class="bg-gray-100 text-gray-500 text-[10px] font-bold px-3 py-1 rounded-full">
                                    Nonaktif
                                </span>
                            </td>
                            <td class="px-7 py-4">
                                <div class="flex justify-end gap-2">
                                    <button class="w-9 h-9 rounded-lg bg-blue-50 text-blue-500 hover:bg-blue-100 flex items-center justify-center">
                                        <i data-lucide="pencil" class="w-4 h-4"></i>
                                    </button>
                                    <button class="w-9 h-9 rounded-lg bg-red-50 text-red-500 hover:bg-red-100 flex items-center justify-center">
                                        <i data-lucide="trash-2" class="w-4 h-4"></i>
                                    </button>
                                </div>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- Modal Tambah PIC -->
    <div x-show="openModal"
        x-cloak
        class="fixed inset-0 z-[9999] flex items-center justify-center bg-black/50 p-4">

        <div @click.outside="openModal = false"
            x-transition
            class="w-full max-w-2xl bg-white rounded-2xl shadow-xl border border-gray-100">

            <div class="px-7 py-5 border-b border-gray-100 flex items-center justify-between">
                <div>
                    <h2 class="text-base font-extrabold text-gray-800">Tambah Akun PIC</h2>
                    <p class="text-xs text-gray-400 mt-1">
                        Buat akun PIC untuk akses aplikasi mobile.
                    </p>
                </div>

                <button @click="openModal = false"
                    class="w-9 h-9 rounded-lg hover:bg-gray-100 flex items-center justify-center text-gray-400">
                    <i data-lucide="x" class="w-5 h-5"></i>
                </button>
            </div>

            <form class="p-7 grid grid-cols-1 md:grid-cols-2 gap-5">
                <div>
                    <label class="block text-[10px] font-bold text-gray-400 uppercase tracking-wider mb-2">
                        Nama Lengkap
                    </label>
                    <input type="text" placeholder="Contoh: Alif Fajriadi"
                        class="w-full h-11 px-4 bg-gray-50 border border-gray-200 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-[#3DBFA6]/20 focus:border-[#3DBFA6]">
                </div>

                <div>
                    <label class="block text-[10px] font-bold text-gray-400 uppercase tracking-wider mb-2">
                        NIK
                    </label>
                    <input type="text" placeholder="Masukkan NIK"
                        class="w-full h-11 px-4 bg-gray-50 border border-gray-200 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-[#3DBFA6]/20 focus:border-[#3DBFA6]">
                </div>

                <div>
                    <label class="block text-[10px] font-bold text-gray-400 uppercase tracking-wider mb-2">
                        Nomor HP / WhatsApp
                    </label>
                    <input type="text" placeholder="08xxxxxxxxxx"
                        class="w-full h-11 px-4 bg-gray-50 border border-gray-200 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-[#3DBFA6]/20 focus:border-[#3DBFA6]">
                </div>

                <div>
                    <label class="block text-[10px] font-bold text-gray-400 uppercase tracking-wider mb-2">
                        Email
                    </label>
                    <input type="email" placeholder="pic@email.com"
                        class="w-full h-11 px-4 bg-gray-50 border border-gray-200 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-[#3DBFA6]/20 focus:border-[#3DBFA6]">
                </div>

                <div class="md:col-span-2">
                    <label class="block text-[10px] font-bold text-gray-400 uppercase tracking-wider mb-2">
                        Password
                    </label>
                    <input type="password" placeholder="••••••••"
                        class="w-full h-11 px-4 bg-gray-50 border border-gray-200 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-[#3DBFA6]/20 focus:border-[#3DBFA6]">
                </div>

                <div class="md:col-span-2 flex justify-end gap-3 pt-3">
                    <button type="button" @click="openModal = false"
                        class="px-5 py-3 rounded-xl border border-gray-200 text-gray-500 text-sm font-bold hover:bg-gray-50">
                        Batal
                    </button>

                    <button type="submit"
                        class="px-5 py-3 rounded-xl bg-[#3DBFA6] text-white text-sm font-bold hover:bg-[#32aa94]">
                        Simpan Akun PIC
                    </button>
                </div>
            </form>
        </div>
    </div>

</div>
@endsection