<?php

namespace Database\Seeders;

use App\Models\Role;
use App\Models\User;
use App\Models\AdminDetail;
use App\Models\WasteCategory;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    use WithoutModelEvents;

    /**
     * Seed the application's database.
     */
    public function run(): void
    {
        // User::factory(10)->create();

        // User::factory()->create([
        //     'name' => 'Test User',
        //     'email' => 'test@example.com',
        // ]);
        Role::create([
            'name' => 'admin'
        ]);
        User::create([
            'email' => 'admin@gmail.com',
            'password' => bcrypt('admin'),
            'is_active' => true,
            'role_id' => 1,
        ]);
        AdminDetail::create([
            'id_user' => 1,
            'full_name' => 'admin',
        ]);

        $categories = [
            ['name' => 'organik', 'description' => 'Limbah organik'],
            ['name' => 'anorganik', 'description' => 'Limbah anorganik'],
            ['name' => 'b3', 'description' => 'Limbah b3'],
        ];
        foreach ($categories as $category) {
            WasteCategory::create($category);
        }
    }
}
