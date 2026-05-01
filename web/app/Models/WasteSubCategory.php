<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class WasteSubCategory extends Model
{
    protected $table = 'waste_sub_category';

    public $timestamps = false;

    protected $fillable = [
        'id_waste_category',
        'name',
        'description',
        'id_waste_b3_detail',
        'photo',
        'is_active',
        'created_at',
        'id_unit_measured',
        'default_measured_qty',
    ];

    public function category()
    {
        return $this->belongsTo(WasteCategory::class, 'id_waste_category');
    }

    public function wasteEntries()
    {
        return $this->hasMany(WasteEntry::class, 'id_waste_sub_category');
    }
}
