<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\ProcessedWaste;
use App\Models\UnitMeasured;
use Illuminate\Http\Request;

class ProcessedWasteController extends Controller
{
    public function index(Request $request)
    {
        $query = ProcessedWaste::with('unitMeasured');
        if ($request->filled('search')) {
            $query->where('name', 'like', "%{$request->search}%");
        }
        $processedWastes = $query->paginate(10)->withQueryString();
        $units = UnitMeasured::orderBy('name')->get();
        return view('pages.processed-waste.index', compact('processedWastes', 'units'));
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'name'                => ['required', 'string', 'max:100'],
            'description'         => ['nullable', 'string'],
            'id_unit_measured'    => ['required', 'exists:unit_measured,id'],
            'default_measured_qty'=> ['required', 'numeric', 'min:0'],
        ]);
        ProcessedWaste::create($validated);
        return back()->with('success', 'Jenis olahan berhasil ditambahkan.');
    }

    public function update(Request $request, ProcessedWaste $processedWaste)
    {
        $validated = $request->validate([
            'name'                => ['required', 'string', 'max:100'],
            'description'         => ['nullable', 'string'],
            'id_unit_measured'    => ['required', 'exists:unit_measured,id'],
            'default_measured_qty'=> ['required', 'numeric', 'min:0'],
        ]);
        $processedWaste->update($validated);
        return back()->with('success', 'Jenis olahan berhasil diperbarui.');
    }

    public function destroy(ProcessedWaste $processedWaste)
    {
        $processedWaste->delete();
        return back()->with('success', 'Jenis olahan berhasil dihapus.');
    }
}
