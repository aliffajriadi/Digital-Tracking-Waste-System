@extends('layouts.app')

@section('title', 'Sampah Keluar | WasteTracking')
@section('page-title', 'Monitoring Sampah Keluar')

@section('content')
    <div class="max-w-7xl mx-auto space-y-5">

        <div>
            <h2 class="text-lg font-extrabold text-gray-800">Data Sampah Keluar</h2>
            <p class="text-xs text-gray-400 mt-0.5">Data sampah yang telah dikeluarkan dari rumah sampah.</p>
        </div>

        <!-- Filter -->
        <form method="GET"
            class="bg-white rounded-2xl border border-gray-100 shadow-sm p-4 flex flex-wrap items-center gap-3">
            <div class="flex items-center gap-2">
                <label class="text-xs text-gray-500 font-semibold">Dari:</label>
                <input type="date" name="date_from" value="{{ request('date_from') }}"
                    class="h-9 px-3 bg-gray-50 border border-gray-200 rounded-xl text-xs text-gray-600 focus:outline-none focus:ring-2 focus:ring-[#3DBFA6]/20 focus:border-[#3DBFA6]">
                <label class="text-xs text-gray-500 font-semibold">s/d:</label>
                <input type="date" name="date_to" value="{{ request('date_to') }}"
                    class="h-9 px-3 bg-gray-50 border border-gray-200 rounded-xl text-xs text-gray-600 focus:outline-none focus:ring-2 focus:ring-[#3DBFA6]/20 focus:border-[#3DBFA6]">
            </div>
            <button type="submit"
                class="h-9 px-4 bg-gray-800 text-white text-xs font-bold rounded-xl hover:bg-gray-700">Filter</button>
            @if (request()->anyFilled(['date_from', 'date_to']))
                <a href="{{ route('admin.waste-out.index') }}"
                    class="h-9 px-4 border border-gray-200 text-gray-500 text-xs font-bold rounded-xl hover:bg-gray-50 flex items-center">Reset</a>
            @endif
        </form>

        <div class="bg-white rounded-2xl border border-gray-100 shadow-sm overflow-hidden">
            <div class="px-6 py-4 border-b border-gray-50">
                <span class="text-xs font-bold text-gray-600">{{ $wasteOuts->total() }} data</span>
            </div>

            <table class="w-full text-sm">
                <thead class="bg-gray-50/80">
                    <tr>
                        <th class="px-6 py-3.5 text-left text-[10px] font-bold text-gray-400 uppercase tracking-wider">#
                        </th>
                        <th class="px-6 py-3.5 text-left text-[10px] font-bold text-gray-400 uppercase tracking-wider">
                            Metode Keluar</th>
                        <th class="px-6 py-3.5 text-left text-[10px] font-bold text-gray-400 uppercase tracking-wider">
                            Tujuan</th>
                        <th class="px-6 py-3.5 text-left text-[10px] font-bold text-gray-400 uppercase tracking-wider">
                            Catatan</th>
                        <th class="px-6 py-3.5 text-left text-[10px] font-bold text-gray-400 uppercase tracking-wider">Waktu
                        </th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-gray-50">
                    @forelse($wasteOuts as $i => $item)
                        <tr class="hover:bg-gray-50/60 transition-colors">
                            <td class="px-6 py-4 text-xs text-gray-400">{{ $wasteOuts->firstItem() + $i }}</td>
                            <td class="px-6 py-4">
                                <span class="text-xs font-semibold px-2.5 py-1 rounded-full bg-orange-50 text-orange-600">
                                    {{ $item->method?->name ?? ($item->wasteOutMethod?->name ?? '-') }}
                                </span>
                            </td>
                            <td class="px-6 py-4 text-xs text-gray-600">
                                {{ $item->destination?->name ?? ($item->wasteDestination?->name ?? '-') }}</td>
                            <td class="px-6 py-4 text-xs text-gray-500 max-w-xs truncate">{{ $item->notes ?? '-' }}</td>
                            <td class="px-6 py-4 text-[11px] text-gray-400">{{ $item->created_at?->format('d/m/Y H:i') }}
                            </td>
                        </tr>
                    @empty
                        <tr>
                            <td colspan="5" class="px-6 py-14 text-center">
                                <i data-lucide="send" class="w-10 h-10 text-gray-200 mx-auto mb-3"></i>
                                <p class="text-sm text-gray-400">Tidak ada data sampah keluar</p>
                            </td>
                        </tr>
                    @endforelse
                </tbody>
            </table>

            @if ($wasteOuts->hasPages())
                <div class="px-6 py-4 border-t border-gray-50">{{ $wasteOuts->links() }}</div>
            @endif
        </div>

    </div>
@endsection
