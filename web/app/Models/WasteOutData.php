<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class WasteOutData extends Model
{
    protected $table = 'waste_out_data';

    public $timestamps = false;

    protected $fillable = [
        'id_waste_out_method',
        'id_waste_destination',
        'notes',
        'created_at',
    ];

    public function method()
    {
        return $this->belongsTo(WasteOutMethod::class, 'id_waste_out_method');
    }

    public function destination()
    {
        return $this->belongsTo(WasteDestinations::class, 'id_waste_destination');
    }
}
