<?php

namespace App\Console\Commands;

use App\Http\Controllers\Colis\CategorieColisController;
use App\Http\Controllers\Colis\ColisController;
use App\Http\Controllers\DashboardController;
use App\Http\Controllers\Gares\ArretController;
use App\Http\Controllers\Gares\GareController;
use App\Http\Controllers\Gares\LigneController;
use App\Http\Controllers\ParametreController;
use App\Http\Controllers\ProfileController;
use App\Http\Controllers\RoleController;
use App\Http\Controllers\SystemSettingController;
use App\Http\Controllers\Trains\TrainController;
use App\Http\Controllers\Trains\WagonController;
use App\Http\Controllers\UserController;
use App\Http\Controllers\Ventes\PointVenteController;
use App\Http\Controllers\Ventes\VenteController;
use App\Http\Controllers\Voyages\TarifController;
use App\Http\Controllers\Voyages\VoyageController;
use Spatie\Permission\Models\Permission;
use Illuminate\Console\Command;
use Illuminate\Support\Str;
use ReflectionClass;
use ReflectionMethod;

class GenerateResourcePermissions extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'permission:generate';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Generate permissions for all controllers';

    /**
     * Execute the console command.
     */
    public function handle()
    {
        //
        $controllers = [
            RoleController::class,
            VenteController::class,
            GareController::class,
            ArretController::class,
            TrainController::class,
            WagonController::class,
            ColisController::class,
            VoyageController::class,
            UserController::class,
            SystemSettingController::class,
            LigneController::class,
            CategorieColisController::class,
            PointVenteController::class,
            TarifController::class,
            DashboardController::class,
            ParametreController::class,
            ProfileController::class
        ];

        // Actions de base CRUD (peuvent être étendues)
        $crudActions = ['index', 'create', 'store', 'show', 'edit', 'update', 'destroy'];

        foreach ($controllers as $controller) {
            $reflection = new ReflectionClass($controller);
            $methods = $reflection->getMethods(ReflectionMethod::IS_PUBLIC);

            // Nom du modèle (ex: UserController -> user)
            $modelName = Str::snake(str_replace('Controller', '', class_basename($controller)));

            foreach ($methods as $method) {
                $methodName = $method->getName();

                // On ignore les méthodes spéciales et celles qui ne sont pas des actions CRUD
                if (
                    in_array($methodName, ['__construct']) ||
                    str_starts_with($methodName, '__')
                ) {
                    continue;
                }

                // Si c'est une méthode CRUD standard ou une méthode personnalisée
                if (in_array($methodName, $crudActions) || !in_array($methodName, get_class_methods(\App\Http\Controllers\Controller::class))) {
                    $permissionName = $this->mapActionToPermission($methodName, $modelName);

                    Permission::firstOrCreate([
                        'name' => $permissionName,
                        'guard_name' => 'web',
                    ]);

                    $this->info("Created permission: {$permissionName}");
                }
            }
        }

        $this->info('All controller-based permissions generated successfully!');
    }

    /**
     * Map controller action to permission name
     */
    protected function mapActionToPermission(string $action, string $modelName): string
    {
        $mapping = [
            'index' => 'viewAny',
            'show' => 'view',
            'create' => 'create',
            'store' => 'create',
            'edit' => 'update',
            'update' => 'update',
            'destroy' => 'delete',
        ];

        return ($mapping[$action] ?? $action) . ' ' . $modelName;
    }
}
