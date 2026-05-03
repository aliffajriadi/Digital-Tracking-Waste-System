<?php

use Illuminate\Support\Facades\Route;

Route::get('/', function () {
    return view('welcome');
});

Route::get('/login', function () {
    return view('auth.login');
});

Route::view('/dashboard', 'pages.dashboard');
Route::view('/profile', 'pages.profile')->name('profile');
Route::view('/account', 'pages.account')->name('account');