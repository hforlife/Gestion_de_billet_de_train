<?php

namespace Database\Factories;

use App\Models\Trains;
use App\Models\Gares;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\Voyages>
 */
class VoyageFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        return [
            //
        'train_id' => Trains::all()->random()->id,
        'gare_depart' => Gares::all()->random()->nom,
        'gare_arrivee' => Gares::all()->random()->nom,
        'date_depart' => fake()->dateTime(),
        'date_arrivee' => fake()->dateTime(),
        'status' => fake()->randomElement,
        ];
    }
}
