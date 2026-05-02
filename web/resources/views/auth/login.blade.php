@extends('layouts.auth')

@section('title', 'Login Admin')

@section('content')
<div class="w-full max-w-[400px]">

    <!-- Card Login -->
    <div class="bg-white rounded-3xl border border-gray-200 shadow-sm p-8 md:p-10">

        <!-- Logo -->
        <div class="flex justify-center mb-4">
            <img src="{{ asset('images/Politeknik_Negeri_Batam.png') }}" 
                alt="Logo Polibatam"
                class="h-14 w-auto object-contain">
        </div>

        <div class="text-center mb-8">
            <h2 class="text-xl font-bold text-gray-800">Login Admin</h2>
            <p class="text-gray-400 text-xs mt-2 uppercase tracking-widest font-semibold">
                Digital Waste Tracking
            </p>
        </div>

        <form class="space-y-6">

            <!-- Email -->
            <div class="space-y-2">
                <label class="text-[11px] font-bold text-gray-400 uppercase tracking-wider ml-1">
                    Alamat Email
                </label>

                <input type="email"
                    class="w-full px-5 py-4 bg-gray-50 border border-gray-200 rounded-2xl text-sm focus:outline-none focus:ring-2 focus:ring-[#34a88e]/20 focus:border-[#34a88e]"
                    placeholder="Masukkan email..." required>
            </div>

            <!-- Password + Icon -->
            <div class="space-y-2">
                <label class="text-[11px] font-bold text-gray-400 uppercase tracking-wider ml-1">
                    Kata Sandi
                </label>

                <div class="relative">
                    <input id="password"
                        type="password"
                        class="w-full px-5 py-4 pr-12 bg-gray-50 border border-gray-200 rounded-2xl text-sm focus:outline-none focus:ring-2 focus:ring-[#34a88e]/20 focus:border-[#34a88e]"
                        placeholder="••••••••" required>

                    <button type="button"
                        onclick="togglePassword()"
                        class="absolute right-4 top-1/2 -translate-y-1/2 text-gray-500 hover:text-gray-700">
                        <i id="eyeIcon" data-lucide="eye"></i>
                    </button>
                </div>
            </div>

            <!-- Button -->
            <button type="submit"
                class="w-full bg-[#34a88e] hover:bg-[#2d917a] text-white font-bold py-4 rounded-2xl shadow-lg transition-all">
                Masuk
            </button>

        </form>
    </div>

    <!-- Footer -->
    <p class="text-center text-gray-100 text-[10px] mt-8 uppercase tracking-[0.2em] font-medium">
        &copy; 2026 Teknik Informatika - Polibatam
    </p>
</div>
@endsection

@push('scripts')
<script>
function togglePassword() {
    const input = document.getElementById('password');
    const icon = document.getElementById('eyeIcon');

    if (input.type === 'password') {
        input.type = 'text';
        icon.setAttribute('data-lucide', 'eye-off');
    } else {
        input.type = 'password';
        icon.setAttribute('data-lucide', 'eye');
    }

    lucide.createIcons();
}
</script>
@endpush