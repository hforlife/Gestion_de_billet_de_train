<?php

namespace Database\Factories;

use Illuminate\Database\Eloquent\Factories\Factory;
use Illuminate\Support\Number;
/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\Trains>
 */
class TrainsFactory extends Factory
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
            'nom' => fake()->name(),
            'etat' => fake()->randomElement,
        ];
    }
}
