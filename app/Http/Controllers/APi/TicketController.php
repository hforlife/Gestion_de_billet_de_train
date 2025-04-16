<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Tickets;
use Illuminate\Http\Request;
use Inertia\Inertia;

class TicketController extends Controller
{
    //
    public function index(){
        $ticket = Tickets::all();
        return Inertia::render('vente', [
            'tickets' => $ticket,
        ]);
    }
}
