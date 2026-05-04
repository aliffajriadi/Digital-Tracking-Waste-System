<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class WasteCategory extends Model
{
    protected $table = 'waste_category';


    protected $fillable = [
        'name',
        'description',
        'photo',
        'created_at',
    ];

    public function subCategories()
    {
        return $this->hasMany(WasteSubCategory::class, 'id_waste_category');
    }
}
