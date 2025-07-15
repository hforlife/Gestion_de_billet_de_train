<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

class FeedController extends Controller
{
    //
    public function index()
    {
        // Logic to retrieve and display the feed
        return view('feed.index');
    }
}
