<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="WasteTracking - Sistem Digital Monitoring Rumah Sampah Polibatam">
    <title>@yield('title', 'WasteTracking Admin')</title>

    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://unpkg.com/lucide@latest"></script>
    <script defer src="https://unpkg.com/alpinejs@3.x.x/dist/cdn.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <style>
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap');
        body { font-family: 'Inter', sans-serif; }
        [x-cloak] { display: none !important; }

        /* Custom scrollbar */
        ::-webkit-scrollbar { width: 5px; height: 5px; }
        ::-webkit-scrollbar-track { background: transparent; }
        ::-webkit-scrollbar-thumb { background: #CBD5E1; border-radius: 4px; }
        ::-webkit-scrollbar-thumb:hover { background: #94A3B8; }

        /* Sidebar active link */
        .sidebar-link-active {
            background: rgba(255,255,255,0.2);
            color: white !important;
        }

        /* Smooth transition for sidebar */
        aside { transition: transform 0.3s cubic-bezier(0.4,0,0.2,1); }

        /* Toast animation */
        @keyframes slideInRight {
            from { transform: translateX(100%); opacity: 0; }
            to   { transform: translateX(0); opacity: 1; }
        }
        .toast-enter { animation: slideInRight 0.3s ease; }

        /* Stat card shimmer */
        .stat-card { transition: transform 0.2s, box-shadow 0.2s; }
        .stat-card:hover { transform: translateY(-2px); box-shadow: 0 10px 30px rgba(0,0,0,0.08); }
    </style>
</head>
<body class="bg-slate-50 antialiased m-0" x-data="{ sidebarOpen: window.innerWidth >= 1024 }">

    <!-- Overlay for mobile -->
    <div x-show="sidebarOpen && window.innerWidth < 1024"
         @click="sidebarOpen = false"
         class="fixed inset-0 bg-black/40 z-30 lg:hidden"
         x-cloak></div>

    <!-- ===== SIDEBAR ===== -->
    <aside
        class="fixed top-0 left-0 z-40 w-72 h-screen bg-gradient-to-b from-[#1fa88c] to-[#158f77] text-white border-r border-teal-400/20 shadow-2xl"
        :class="sidebarOpen ? 'translate-x-0' : '-translate-x-full'">

        <!-- Logo -->
        <div class="h-20 flex items-center px-5 border-b border-white/15">
            <div class="flex items-center gap-3">
                <div class="w-10 h-10 bg-white rounded-xl flex items-center justify-center shadow-sm flex-shrink-0">
                    <img src="{{ asset('images/Politeknik_Negeri_Batam.png') }}"
                         alt="Logo Polibatam"
                         class="h-8 w-8 object-contain">
                </div>
                <div>
                    <h2 class="text-sm font-bold tracking-wide leading-tight">WasteTracking</h2>
                    <p class="text-[10px] font-medium text-white/70 leading-tight uppercase tracking-widest">Admin Panel</p>
                </div>
            </div>
        </div>

        <!-- Navigation -->
        <div class="h-[calc(100%-80px)] px-3 py-5 overflow-y-auto">
            <ul class="space-y-0.5">

                <!-- Dashboard -->
                <li>
                    <a href="{{ route('admin.dashboard') }}"
                       class="flex items-center gap-3.5 px-4 py-3 rounded-xl text-white/80 hover:bg-white/15 hover:text-white transition-all text-sm font-medium {{ request()->routeIs('admin.dashboard') ? 'sidebar-link-active' : '' }}">
                        <i data-lucide="layout-dashboard" class="w-4.5 h-4.5 flex-shrink-0"></i>
                        <span>Dashboard</span>
                    </a>
                </li>

                <!-- Separator -->
                <li class="pt-3 pb-1">
                    <p class="px-4 text-[9px] font-bold text-white/40 uppercase tracking-[0.15em]">Data Master</p>
                </li>

                <!-- Jenis Sampah -->
                <li>
                    <a href="{{ route('admin.waste-category.index') }}"
                       class="flex items-center gap-3.5 px-4 py-3 rounded-xl text-white/80 hover:bg-white/15 hover:text-white transition-all text-sm font-medium {{ request()->routeIs('admin.waste-category.*') ? 'sidebar-link-active' : '' }}">
                        <i data-lucide="layers" class="w-4 h-4 flex-shrink-0"></i>
                        <span>Kategori Sampah</span>
                    </a>
                </li>

                <li>
                    <a href="{{ route('admin.waste-subcategory.index') }}"
                       class="flex items-center gap-3.5 px-4 py-3 rounded-xl text-white/80 hover:bg-white/15 hover:text-white transition-all text-sm font-medium {{ request()->routeIs('admin.waste-subcategory.*') ? 'sidebar-link-active' : '' }}">
                        <i data-lucide="tag" class="w-4 h-4 flex-shrink-0"></i>
                        <span>Sub-Kategori Sampah</span>
                    </a>
                </li>

                <li>
                    <a href="{{ route('admin.waste-b3.index') }}"
                       class="flex items-center gap-3.5 px-4 py-3 rounded-xl text-white/80 hover:bg-white/15 hover:text-white transition-all text-sm font-medium {{ request()->routeIs('admin.waste-b3.*') ? 'sidebar-link-active' : '' }}">
                        <i data-lucide="flask-conical" class="w-4 h-4 flex-shrink-0"></i>
                        <span>Limbah B3</span>
                    </a>
                </li>

                <li>
                    <a href="{{ route('admin.processed-waste.index') }}"
                       class="flex items-center gap-3.5 px-4 py-3 rounded-xl text-white/80 hover:bg-white/15 hover:text-white transition-all text-sm font-medium {{ request()->routeIs('admin.processed-waste.*') ? 'sidebar-link-active' : '' }}">
                        <i data-lucide="recycle" class="w-4 h-4 flex-shrink-0"></i>
                        <span>Jenis Olahan</span>
                    </a>
                </li>

                <li>
                    <a href="{{ route('admin.unit-measured.index') }}"
                       class="flex items-center gap-3.5 px-4 py-3 rounded-xl text-white/80 hover:bg-white/15 hover:text-white transition-all text-sm font-medium {{ request()->routeIs('admin.unit-measured.*') ? 'sidebar-link-active' : '' }}">
                        <i data-lucide="ruler" class="w-4 h-4 flex-shrink-0"></i>
                        <span>Satuan Ukur</span>
                    </a>
                </li>

                <li>
                    <a href="{{ route('admin.source-location.index') }}"
                       class="flex items-center gap-3.5 px-4 py-3 rounded-xl text-white/80 hover:bg-white/15 hover:text-white transition-all text-sm font-medium {{ request()->routeIs('admin.source-location.*') ? 'sidebar-link-active' : '' }}">
                        <i data-lucide="map-pin" class="w-4 h-4 flex-shrink-0"></i>
                        <span>Sumber Sampah</span>
                    </a>
                </li>

                <li>
                    <a href="{{ route('admin.collector-buyer.index') }}"
                       class="flex items-center gap-3.5 px-4 py-3 rounded-xl text-white/80 hover:bg-white/15 hover:text-white transition-all text-sm font-medium {{ request()->routeIs('admin.collector-buyer.*') ? 'sidebar-link-active' : '' }}">
                        <i data-lucide="building-2" class="w-4 h-4 flex-shrink-0"></i>
                        <span>Pengepul / Pembeli</span>
                    </a>
                </li>

                <!-- Separator -->
                <li class="pt-3 pb-1">
                    <p class="px-4 text-[9px] font-bold text-white/40 uppercase tracking-[0.15em]">Monitoring</p>
                </li>

                <li>
                    <a href="{{ route('admin.waste-entry.index') }}"
                       class="flex items-center gap-3.5 px-4 py-3 rounded-xl text-white/80 hover:bg-white/15 hover:text-white transition-all text-sm font-medium {{ request()->routeIs('admin.waste-entry.*') ? 'sidebar-link-active' : '' }}">
                        <i data-lucide="inbox" class="w-4 h-4 flex-shrink-0"></i>
                        <span>Sampah Masuk</span>
                    </a>
                </li>

                <li>
                    <a href="{{ route('admin.waste-out.index') }}"
                       class="flex items-center gap-3.5 px-4 py-3 rounded-xl text-white/80 hover:bg-white/15 hover:text-white transition-all text-sm font-medium {{ request()->routeIs('admin.waste-out.*') ? 'sidebar-link-active' : '' }}">
                        <i data-lucide="send" class="w-4 h-4 flex-shrink-0"></i>
                        <span>Sampah Keluar</span>
                    </a>
                </li>

                <li>
                    <a href="{{ route('admin.processed-waste-data.index') }}"
                       class="flex items-center gap-3.5 px-4 py-3 rounded-xl text-white/80 hover:bg-white/15 hover:text-white transition-all text-sm font-medium {{ request()->routeIs('admin.processed-waste-data.*') ? 'sidebar-link-active' : '' }}">
                        <i data-lucide="cpu" class="w-4 h-4 flex-shrink-0"></i>
                        <span>Pengolahan</span>
                    </a>
                </li>

                <li>
                    <a href="{{ route('admin.report.index') }}"
                       class="flex items-center gap-3.5 px-4 py-3 rounded-xl text-white/80 hover:bg-white/15 hover:text-white transition-all text-sm font-medium {{ request()->routeIs('admin.report.*') ? 'sidebar-link-active' : '' }}">
                        <i data-lucide="file-text" class="w-4 h-4 flex-shrink-0"></i>
                        <span>Laporan</span>
                    </a>
                </li>

                <!-- Separator -->
                <li class="pt-3 pb-1">
                    <p class="px-4 text-[9px] font-bold text-white/40 uppercase tracking-[0.15em]">Akun</p>
                </li>

                <li>
                    <a href="{{ route('admin.users.index') }}"
                       class="flex items-center gap-3.5 px-4 py-3 rounded-xl text-white/80 hover:bg-white/15 hover:text-white transition-all text-sm font-medium {{ request()->routeIs('admin.users.*') ? 'sidebar-link-active' : '' }}">
                        <i data-lucide="users" class="w-4 h-4 flex-shrink-0"></i>
                        <span>Kelola Pengguna</span>
                    </a>
                </li>

                <li>
                    <a href="{{ route('admin.profile') }}"
                       class="flex items-center gap-3.5 px-4 py-3 rounded-xl text-white/80 hover:bg-white/15 hover:text-white transition-all text-sm font-medium {{ request()->routeIs('admin.profile') ? 'sidebar-link-active' : '' }}">
                        <i data-lucide="user-round" class="w-4 h-4 flex-shrink-0"></i>
                        <span>Profil Saya</span>
                    </a>
                </li>

            </ul>

            <!-- Logout -->
            <div class="mt-6 px-1">
                <form method="POST" action="{{ route('logout') }}">
                    @csrf
                    <button type="submit"
                        class="w-full flex items-center gap-3.5 px-4 py-3 rounded-xl text-white/70 hover:bg-red-500/20 hover:text-red-200 transition-all text-sm font-medium">
                        <i data-lucide="log-out" class="w-4 h-4 flex-shrink-0"></i>
                        <span>Logout</span>
                    </button>
                </form>
            </div>
        </div>
    </aside>

    <!-- ===== NAVBAR ===== -->
    <nav class="fixed top-0 z-30 w-full h-16 bg-white/90 backdrop-blur-sm border-b border-gray-200/80 flex items-center justify-between px-5 shadow-sm transition-all duration-300"
         :class="sidebarOpen ? 'lg:pl-[304px]' : 'lg:pl-5'">

        <!-- Left: Hamburger + Page Title -->
        <div class="flex items-center gap-3">
            <button @click="sidebarOpen = !sidebarOpen"
                class="w-9 h-9 flex items-center justify-center rounded-xl text-gray-500 hover:bg-gray-100 transition-colors">
                <i data-lucide="menu" class="w-5 h-5"></i>
            </button>

            <div class="hidden sm:block">
                <p class="text-[10px] font-semibold text-gray-400 uppercase tracking-widest leading-none">Admin Panel</p>
                <h1 class="text-base font-bold text-gray-800 leading-tight">
                    @yield('page-title', 'Dashboard')
                </h1>
            </div>
        </div>

        <!-- Right: Notifications + Profile -->
        <div class="flex items-center gap-2" x-data="{ profileOpen: false }">

            <!-- Notification Bell -->
            <button class="relative w-9 h-9 flex items-center justify-center rounded-xl text-gray-500 hover:bg-gray-100 transition-colors">
                <i data-lucide="bell" class="w-5 h-5"></i>
                <span class="absolute top-1.5 right-1.5 w-2 h-2 bg-red-500 rounded-full"></span>
            </button>

            <!-- Profile Dropdown -->
            <div class="relative" @click.outside="profileOpen = false">
                <button @click="profileOpen = !profileOpen"
                        class="flex items-center gap-2.5 pl-2 pr-3 py-1.5 rounded-xl hover:bg-gray-100 transition-colors group">

                    <div class="w-8 h-8 rounded-lg border-2 border-[#3DBFA6]/30 overflow-hidden">
                        <img src="https://ui-avatars.com/api/?name={{ auth()->check() ? urlencode(auth()->user()->adminDetail->full_name ?? 'Admin') : 'Admin' }}&background=3DBFA6&color=fff&bold=true"
                             class="w-full h-full object-cover"
                             alt="Avatar">
                    </div>

                    <div class="hidden md:block text-left">
                        <p class="text-xs font-bold text-gray-800 leading-tight">
                            {{ auth()->check() ? (auth()->user()->adminDetail->full_name ?? 'Administrator') : 'Administrator' }}
                        </p>
                        <p class="text-[10px] text-gray-400 leading-tight">Admin</p>
                    </div>

                    <span class="transition-transform duration-200" :class="{'rotate-180': profileOpen}">
                        <i data-lucide="chevron-down" class="w-3.5 h-3.5 text-gray-400"></i>
                    </span>
                </button>

                <div x-show="profileOpen"
                     x-transition:enter="transition ease-out duration-200"
                     x-transition:enter-start="opacity-0 translate-y-1"
                     x-transition:enter-end="opacity-100 translate-y-0"
                     x-transition:leave="transition ease-in duration-150"
                     x-transition:leave-start="opacity-100 translate-y-0"
                     x-transition:leave-end="opacity-0 translate-y-1"
                     class="absolute right-0 mt-2 w-52 bg-white border border-gray-100 rounded-xl shadow-xl shadow-gray-200/50 p-1.5 z-50"
                     x-cloak>

                    <a href="{{ route('admin.profile') }}"
                       class="flex items-center gap-3 px-3 py-2.5 text-sm text-gray-600 hover:bg-gray-50 rounded-lg transition-colors">
                        <i data-lucide="user-round" class="w-4 h-4 text-gray-400"></i>
                        Profil Saya
                    </a>

                    <div class="border-t border-gray-100 my-1"></div>

                    <form method="POST" action="{{ route('logout') }}">
                        @csrf
                        <button type="submit"
                            class="w-full flex items-center gap-3 px-3 py-2.5 text-sm text-red-600 font-semibold hover:bg-red-50 rounded-lg transition-colors">
                            <i data-lucide="log-out" class="w-4 h-4"></i>
                            Logout
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </nav>

    <!-- ===== MAIN CONTENT ===== -->
    <main class="pt-16 min-h-screen transition-all duration-300"
          :class="sidebarOpen ? 'lg:ml-72' : 'lg:ml-0'">
        <div class="px-5 md:px-8 py-7">
            @yield('content')
        </div>
    </main>

    <!-- ===== TOAST NOTIFICATIONS ===== -->
    @if(session('success'))
    <div id="toast-success"
         class="fixed bottom-6 right-6 z-[9999] flex items-center gap-3 bg-white border border-green-100 rounded-xl px-5 py-4 shadow-xl shadow-gray-200/50 toast-enter">
        <div class="w-8 h-8 rounded-lg bg-green-50 flex items-center justify-center flex-shrink-0">
            <i data-lucide="check-circle-2" class="w-4 h-4 text-green-500"></i>
        </div>
        <div>
            <p class="text-sm font-semibold text-gray-800">Berhasil!</p>
            <p class="text-xs text-gray-500">{{ session('success') }}</p>
        </div>
        <button onclick="document.getElementById('toast-success').remove()" class="ml-2 text-gray-300 hover:text-gray-500">
            <i data-lucide="x" class="w-4 h-4"></i>
        </button>
    </div>
    @endif

    @if(session('error'))
    <div id="toast-error"
         class="fixed bottom-6 right-6 z-[9999] flex items-center gap-3 bg-white border border-red-100 rounded-xl px-5 py-4 shadow-xl shadow-gray-200/50 toast-enter">
        <div class="w-8 h-8 rounded-lg bg-red-50 flex items-center justify-center flex-shrink-0">
            <i data-lucide="alert-circle" class="w-4 h-4 text-red-500"></i>
        </div>
        <div>
            <p class="text-sm font-semibold text-gray-800">Gagal!</p>
            <p class="text-xs text-gray-500">{{ session('error') }}</p>
        </div>
        <button onclick="document.getElementById('toast-error').remove()" class="ml-2 text-gray-300 hover:text-gray-500">
            <i data-lucide="x" class="w-4 h-4"></i>
        </button>
    </div>
    @endif

    <script>
        lucide.createIcons();

        // Auto-hide toasts
        setTimeout(() => {
            const toasts = document.querySelectorAll('[id^="toast-"]');
            toasts.forEach(t => t.remove());
        }, 5000);
    </script>

    @stack('scripts')
</body>
</html>