<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class SourceLocationWaste extends Model
{
    protected $table = 'source_location_waste';

    protected $fillable = [
        'name',
        'photo',
    ];

    public function wasteEntries()
    {
        return $this->hasMany(WasteEntry::class, 'id_source_location_waste');
    }
}
