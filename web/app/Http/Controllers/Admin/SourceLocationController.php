<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\SourceLocationWaste;
use Illuminate\Http\Request;

class SourceLocationController extends Controller
{
    public function index(Request $request)
    {
        $query = SourceLocationWaste::withCount('wasteEntries');
        if ($request->filled('search')) {
            $query->where('name', 'like', "%{$request->search}%");
        }
        $locations = $query->paginate(10)->withQueryString();
        return view('pages.source-location.index', compact('locations'));
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'name'    => ['required', 'string', 'max:100'],
            'address' => ['nullable', 'string'],
        ]);
        SourceLocationWaste::create($validated);
        return back()->with('success', 'Sumber lokasi berhasil ditambahkan.');
    }

    public function update(Request $request, SourceLocationWaste $sourceLocation)
    {
        $validated = $request->validate([
            'name'    => ['required', 'string', 'max:100'],
            'address' => ['nullable', 'string'],
        ]);
        $sourceLocation->update($validated);
        return back()->with('success', 'Sumber lokasi berhasil diperbarui.');
    }

    public function destroy(SourceLocationWaste $sourceLocation)
    {
        $sourceLocation->delete();
        return back()->with('success', 'Sumber lokasi berhasil dihapus.');
    }
}
