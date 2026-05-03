@extends('layouts.app')

@section('title', 'Pengaturan Profil | WasteTracking')
@section('page-title', 'Pengaturan Profil')

@section('content')
<div class="max-w-6xl mx-auto space-y-7">

    <!-- Profile Header -->
    <div class="bg-white rounded-2xl border border-gray-200 shadow-sm overflow-hidden">
        <div class="h-28 bg-[#3DBFA6]"></div>
        <div class="px-8 pb-7">
            <div class="flex flex-col md:flex-row md:items-end gap-5 -mt-8">
                <!-- Avatar Upload -->
                <div class="relative w-24 h-24">
                    <label for="photoInput" class="cursor-pointer block">
                        <div class="w-24 h-24 rounded-2xl border-4 border-white bg-[#19BFA8] shadow-sm overflow-hidden flex items-center justify-center">
                            <img id="photoPreview"
                                 src=""
                                 alt=""
                                 class="hidden w-full h-full object-cover">
                            <span id="avatarText" class="text-white text-2xl font-bold">
                                AF
                            </span>
                        </div>
                        <div class="absolute -bottom-1 -right-1 w-8 h-8 bg-white border border-gray-200 rounded-full flex items-center justify-center shadow-sm">
                            <i data-lucide="camera" class="w-4 h-4 text-[#3DBFA6]"></i>
                        </div>
                    </label>
                    <input id="photoInput" type="file" accept="image/*" class="hidden">
                </div>

                <!-- User Info -->
                <div class="pt-4">
                    <h2 class="text-xl font-extrabold text-gray-800 tracking-wide">
                        ALIF FAJRIADI
                    </h2>
                    <div class="flex flex-wrap items-center gap-3 mt-2">
                        <span class="bg-[#DDF8F3] text-[#159D89] text-[10px] font-bold px-3 py-1 rounded-full uppercase tracking-wider">
                            Admin
                        </span>
                        <span class="flex items-center gap-1.5 text-xs text-gray-500">
                            <i data-lucide="map-pin" class="w-3.5 h-3.5 text-[#3DBFA6]"></i>
                            Polibatam, Batam
                        </span>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Forms -->
    <div class="grid grid-cols-1 lg:grid-cols-5 gap-7">
        <!-- Informasi Pribadi -->
        <div class="lg:col-span-3 bg-white rounded-2xl border border-gray-200 shadow-sm p-7">
            <div class="flex items-center gap-3 mb-7">
                <div class="w-10 h-10 rounded-xl bg-[#EAFBF7] flex items-center justify-center">
                    <i data-lucide="user-round" class="w-5 h-5 text-[#3DBFA6]"></i>
                </div>
                <div>
                    <h3 class="text-sm font-bold text-gray-800">Informasi Pribadi</h3>
                    <p class="text-xs text-gray-400 mt-0.5">Perbarui data diri Anda di sini.</p>
                </div>
            </div>
            <form class="space-y-5">
                <div class="grid grid-cols-1 md:grid-cols-2 gap-5">
                    <div>
                        <label class="block text-[10px] font-bold text-gray-400 uppercase tracking-wider mb-2">
                            Nama Lengkap
                        </label>
                        <input type="text"
                               class="w-full h-11 px-4 bg-gray-50 border border-gray-200 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-[#3DBFA6]/20 focus:border-[#3DBFA6]">
                    </div>
                    <div>
                        <label class="block text-[10px] font-bold text-gray-400 uppercase tracking-wider mb-2">
                            Nomor Telepon / WhatsApp
                        </label>
                        <input type="text"
                               class="w-full h-11 px-4 bg-gray-50 border border-gray-200 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-[#3DBFA6]/20 focus:border-[#3DBFA6]">
                    </div>
                </div>
                <div>
                    <label class="block text-[10px] font-bold text-gray-400 uppercase tracking-wider mb-2">
                        Email
                    </label>
                    <input type="email"
                           class="w-full h-11 px-4 bg-gray-50 border border-gray-200 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-[#3DBFA6]/20 focus:border-[#3DBFA6]">
                </div>
                <button type="button"
                        class="bg-[#3DBFA6] hover:bg-[#32aa94] text-white text-xs font-bold px-6 py-3 rounded-lg transition">
                    Simpan Perubahan
                </button>
            </form>
        </div>

        <!-- Keamanan -->
        <div class="lg:col-span-2 bg-white rounded-2xl border border-gray-200 shadow-sm p-7">
            <div class="flex items-center gap-3 mb-7">
                <div class="w-10 h-10 rounded-xl bg-red-50 flex items-center justify-center">
                    <i data-lucide="lock-keyhole" class="w-5 h-5 text-red-400"></i>
                </div>
                <div>
                    <h3 class="text-sm font-bold text-gray-800">Keamanan</h3>
                    <p class="text-xs text-gray-400 mt-0.5">Ganti kata sandi berkala.</p>
                </div>
            </div>
            <form class="space-y-5">
                <div>
                    <label class="block text-[10px] font-bold text-gray-400 uppercase tracking-wider mb-2">
                        Sandi Lama
                    </label>
                    <div class="relative">
                        <input id="oldPass" type="password"
                               class="w-full h-11 px-4 pr-11 bg-gray-50 border border-gray-200 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-[#3DBFA6]/20 focus:border-[#3DBFA6]">
                        <button type="button" onclick="togglePass('oldPass', this)"
                                class="absolute right-3 top-1/2 -translate-y-1/2 text-gray-400 hover:text-[#3DBFA6]">
                            <i data-lucide="eye" class="w-4 h-4"></i>
                        </button>
                    </div>
                </div>
                <div>
                    <label class="block text-[10px] font-bold text-gray-400 uppercase tracking-wider mb-2">
                        Sandi Baru
                    </label>
                    <div class="relative">
                        <input id="newPass" type="password"
                               class="w-full h-11 px-4 pr-11 bg-gray-50 border border-gray-200 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-[#3DBFA6]/20 focus:border-[#3DBFA6]">
                        <button type="button" onclick="togglePass('newPass', this)"
                                class="absolute right-3 top-1/2 -translate-y-1/2 text-gray-400 hover:text-[#3DBFA6]">
                            <i data-lucide="eye" class="w-4 h-4"></i>
                        </button>
                    </div>
                </div>
                <div>
                    <label class="block text-[10px] font-bold text-gray-400 uppercase tracking-wider mb-2">
                        Konfirmasi Sandi Baru
                    </label>
                    <input type="password"
                           class="w-full h-11 px-4 bg-gray-50 border border-gray-200 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-[#3DBFA6]/20 focus:border-[#3DBFA6]">
                </div>
                <button type="button"
                        class="w-full bg-red-100 hover:bg-red-200 text-red-500 text-xs font-bold px-6 py-3 rounded-lg transition">
                    Simpan Perubahan
                </button>
            </form>
        </div>
    </div>
</div>
@endsection

@push('scripts')
<script>
    const photoInput = document.getElementById('photoInput');
    const photoPreview = document.getElementById('photoPreview');
    const avatarText = document.getElementById('avatarText');

    photoInput?.addEventListener('change', function () {
        const file = this.files[0];

        if (file) {
            const reader = new FileReader();

            reader.onload = function (e) {
                photoPreview.src = e.target.result;
                photoPreview.classList.remove('hidden');
                avatarText.classList.add('hidden');
            };

            reader.readAsDataURL(file);
        }
    });

    function togglePass(id, button) {
        const input = document.getElementById(id);
        const icon = button.querySelector('i');

        input.type = input.type === 'password' ? 'text' : 'password';
        icon.setAttribute('data-lucide', input.type === 'password' ? 'eye' : 'eye-off');

        lucide.createIcons();
    }
</script>
@endpush