<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Inertia\Inertia;
use Spatie\Permission\Models\Role;

class RoleController extends Controller
{
    //
    public function index(){
       return Inertia::render('Setting/Role/Index', [
        'filters' => Request::only('search'),
        'roles' => Role::all()
                ->orderBy('name')
                ->filter(Request::only('search'))
                ->paginate(10)
       ]);
    }

    public function create(){
        return Inertia::render('Setting/Role/Index');
    }
}
