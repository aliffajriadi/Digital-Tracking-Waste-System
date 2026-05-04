<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\WasteOutData;
use Illuminate\Http\Request;

class WasteOutController extends Controller
{
    public function index(Request $request)
    {
        $query = WasteOutData::with(['wasteOutMethod', 'wasteDestination'])->latest();

        if ($request->filled('date_from')) {
            $query->whereDate('created_at', '>=', $request->date_from);
        }
        if ($request->filled('date_to')) {
            $query->whereDate('created_at', '<=', $request->date_to);
        }

        $wasteOuts = $query->paginate(15)->withQueryString();
        return view('pages.waste-out.index', compact('wasteOuts'));
    }

    public function show(WasteOutData $wasteOut)
    {
        $wasteOut->load(['wasteOutMethod', 'wasteDestination']);
        return view('pages.waste-out.show', compact('wasteOut'));
    }
}
