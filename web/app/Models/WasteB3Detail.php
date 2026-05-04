<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class WasteB3Detail extends Model
{
    protected $table = 'waste_b3_detail';

    protected $fillable = [
        'waste_code',
        'description',
        'retention_period_day',
        'danger_level',
    ];

    public function wasteSubCategories()
    {
        return $this->hasMany(WasteSubCategory::class, 'id_waste_b3_detail');
    }
}
