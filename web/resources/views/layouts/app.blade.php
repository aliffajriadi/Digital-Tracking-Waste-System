<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>@yield('title', 'WasteTracking')</title>

    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://unpkg.com/lucide@latest"></script>
    <script defer src="https://unpkg.com/alpinejs@3.x.x/dist/cdn.min.js"></script>

    <style>
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap');
        body { font-family: 'Inter', sans-serif; }
        [x-cloak] { display: none !important; }
    </style>
</head>

<body class="bg-slate-50 antialiased m-0" x-data="{ sidebarOpen: true }">

    @include('components.sidebar')
    @include('components.navbar')

    <main class="lg:ml-72 pt-28 px-8 pb-12">
        @yield('content')
    </main>

    <script>
        lucide.createIcons();
    </script>

    @stack('scripts')
</body>
</html>