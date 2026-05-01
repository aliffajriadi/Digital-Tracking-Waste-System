<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class WasteSellingData extends Model
{
    protected $table = 'waste_selling_data';

    public $timestamps = false;

    protected $fillable = [
        'id_waste_out_data',
        'total_revenue',
        'id_buyer',
        'created_at',
    ];

    public function wasteOutData()
    {
        return $this->belongsTo(WasteOutData::class, 'id_waste_out_data');
    }

    public function buyer()
    {
        return $this->belongsTo(DataCollectorBuyer::class, 'id_buyer');
    }
}
