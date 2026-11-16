<?php

// First boot on Railway: seed a fresh database and start the setup wizard at
// its domain step. Does nothing once a user exists.

require '/var/www/html/vendor/autoload.php';
$app = require '/var/www/html/bootstrap/app.php';
$kernel = $app->make(Illuminate\Contracts\Console\Kernel::class);
$kernel->bootstrap();

use App\Models\Setting;
use App\Models\User;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Str;

if (! Schema::hasTable('users')) {
    echo "**** Railway: running migrations ****\n";
    $kernel->call('migrate', ['--force' => true]);
}

if (User::query()->exists()) {
    echo "**** Railway: database already set up ****\n";
    exit(0);
}

echo "**** Railway: seeding a fresh database ****\n";
$kernel->call('db:seed', ['--force' => true]);

// The seeder creates admin@invoiceshelf.com with a public password. Replace it
// with a random one nobody knows; the wizard's account step sets the real
// email and password.
User::query()->update(['password' => Hash::make(Str::random(64))]);

// The wizard resumes after the last completed step. 3 = database done, so it
// opens at "Verify domain", then mail, account, company and preferences.
Setting::setSetting('profile_complete', 3);

echo "**** Railway: database ready, open the app to finish the setup wizard ****\n";
