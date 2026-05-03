<nav class="fixed top-0 z-30 w-full h-20 bg-white border-b border-gray-200 lg:pl-72 flex items-center justify-between px-8">
    <div class="flex items-center gap-4">
        <button @click="sidebarOpen = !sidebarOpen" class="p-2 text-gray-500 lg:hidden">
            <i data-lucide="menu"></i>
        </button>

        <h1 class="text-xl font-bold text-gray-700 tracking-tight lg:ml-8">
            @yield('page-title', 'Dashboard')
        </h1>
    </div>

    <div class="flex items-center gap-6" x-data="{ profileOpen: false }">
        <div class="relative">
            <button @click="profileOpen = !profileOpen"
                    @click.outside="profileOpen = false"
                    class="flex items-center gap-3 group focus:outline-none">

                <div class="text-right hidden sm:block">
                    <p class="text-sm font-bold text-gray-800">Alif Fajriadi</p>
                    <p class="text-[10px] uppercase font-semibold text-gray-400 tracking-widest">
                        Administrator
                    </p>
                </div>

                <div class="w-10 h-10 rounded-full border-2 border-[#3DBFA6] p-0.5 transition-transform group-hover:scale-105">
                    <img src="https://ui-avatars.com/api/?name=Alif&background=3DBFA6&color=fff"
                         class="w-full h-full rounded-full"
                         alt="User profile">
                </div>

                <i data-lucide="chevron-down"
                   class="w-4 h-4 text-gray-400 transition-transform"
                   :class="{'rotate-180': profileOpen}"></i>
            </button>

            <div x-show="profileOpen"
                 x-transition
                 class="absolute right-0 mt-4 w-52 bg-white border border-gray-100 rounded-xl shadow-2xl shadow-gray-200/50 p-2 z-50"
                 x-cloak>

                <a href="{{ route('profile') }}" class="flex items-center gap-3 px-4 py-2.5 text-sm text-gray-600 hover:bg-gray-50 rounded-lg">
                    <i data-lucide="user" class="w-4 h-4"></i>
                    Ubah Profil
                </a>

                <div class="border-t border-gray-100 my-1"></div>

                <a href="#" class="flex items-center gap-3 px-4 py-2.5 text-sm text-red-600 font-bold hover:bg-red-50 rounded-lg">
                    <i data-lucide="log-out" class="w-4 h-4"></i>
                    Logout
                </a>
            </div>
        </div>
    </div>
</nav>