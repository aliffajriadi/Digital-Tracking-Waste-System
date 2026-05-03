<aside
    class="fixed top-0 left-0 z-40 w-72 h-screen transition-transform bg-[#3DBFA6] text-white lg:translate-x-0 border-r border-teal-300/40 shadow-xl"
    :class="{'translate-x-0': sidebarOpen, '-translate-x-full': !sidebarOpen}">

    <div class="h-20 flex items-center px-6 border-b border-white/20">
        <div class="flex items-center gap-3">
            <img src="{{ asset('images/Politeknik_Negeri_Batam.png') }}"
                 alt="Logo Polibatam"
                 class="h-10 w-10 object-contain bg-white rounded-xl p-1">
            <div>
                <h2 class="text-sm font-bold tracking-wide leading-tight">WasteTracking</h2>
                <p class="text-[11px] font-medium text-white/75 leading-tight">Admin Panel</p>
            </div>
        </div>
    </div>

    <div class="h-[calc(100%-80px)] px-3 py-6 overflow-y-auto">
        <ul class="space-y-1 font-medium">

            <li>
                <a href="/dashboard"
                   class="flex items-center gap-4 px-4 py-3.5 rounded-xl bg-white/20 text-white transition-all">
                    <i data-lucide="layout-grid" class="w-5 h-5"></i>
                    <span class="text-sm tracking-wide">Dashboard</span>
                </a>
            </li>

            <li x-data="{ open: false }">
                <button @click="open = !open"
                    class="flex items-center w-full gap-4 px-4 py-3.5 text-white/85 hover:bg-white/15 hover:text-white rounded-xl transition-all">
                    <i data-lucide="database" class="w-5 h-5"></i>
                    <span class="flex-1 text-left text-sm tracking-wide">Data Master</span>
                    <i data-lucide="chevron-down" class="w-4 h-4 transition-transform duration-200" :class="{'rotate-180': open}"></i>
                </button>

                <div x-show="open" x-transition class="overflow-hidden bg-white/10 rounded-xl mt-1 mx-2" x-cloak>
                    <div class="py-2 space-y-1">
                        <a href="#" class="block px-10 py-2 text-xs text-white/80 hover:text-white hover:bg-white/10">Jenis Sampah</a>
                        <a href="#" class="block px-10 py-2 text-xs text-white/80 hover:text-white hover:bg-white/10">Limbah B3</a>
                        <a href="#" class="block px-10 py-2 text-xs text-white/80 hover:text-white hover:bg-white/10">Jenis Olahan</a>
                        <a href="#" class="block px-10 py-2 text-xs text-white/80 hover:text-white hover:bg-white/10">Satuan & Konversi</a>
                        <a href="#" class="block px-10 py-2 text-xs text-white/80 hover:text-white hover:bg-white/10">Sumber Sampah</a>
                        <a href="#" class="block px-10 py-2 text-xs text-white/80 hover:text-white hover:bg-white/10">Pihak Ketiga</a>
                    </div>
                </div>
            </li>

            <li>
                <a href="{{ route('account') }}"
                   class="flex items-center gap-4 px-4 py-3.5 text-white/85 hover:bg-white/15 hover:text-white rounded-xl transition-all">
                    <i data-lucide="users" class="w-5 h-5"></i>
                    <span class="text-sm tracking-wide">Kelola Pengguna</span>
                </a>
            </li>

            <li x-data="{ open: false }">
                <button @click="open = !open"
                    class="flex items-center w-full gap-4 px-4 py-3.5 text-white/85 hover:bg-white/15 hover:text-white rounded-xl transition-all">
                    <i data-lucide="bar-chart-3" class="w-5 h-5"></i>
                    <span class="flex-1 text-left text-sm tracking-wide">Laporan & Monitoring</span>
                    <i data-lucide="chevron-down" class="w-4 h-4 transition-transform duration-200" :class="{'rotate-180': open}"></i>
                </button>

                <div x-show="open" x-transition class="overflow-hidden bg-white/10 rounded-xl mt-1 mx-2" x-cloak>
                    <div class="py-2 space-y-1">
                        <a href="#" class="block px-10 py-2 text-xs text-white/80 hover:text-white hover:bg-white/10">Sampah Masuk</a>
                        <a href="#" class="block px-10 py-2 text-xs text-white/80 hover:text-white hover:bg-white/10">Pengolahan</a>
                        <a href="#" class="block px-10 py-2 text-xs text-white/80 hover:text-white hover:bg-white/10">Sampah Keluar</a>
                        <a href="#" class="block px-10 py-2 text-xs text-white/80 hover:text-white hover:bg-white/10">Limbah B3</a>
                        <a href="#" class="block px-10 py-2 text-xs text-white/80 hover:text-white hover:bg-white/10">Catatan & Kendala</a>
                        <a href="#" class="block px-10 py-2 text-xs text-white/80 hover:text-white hover:bg-white/10">Rekap Bulanan</a>
                    </div>
                </div>
            </li>

        </ul>
    </div>
</aside>