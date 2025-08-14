<?php

namespace App\Policies;

use App\Models\User;
use App\Models\SystemSetting;

class SystemSettingPolicy
{
    /**
     * Determine whether the user can create models.
     */
    public function create(User $user): bool
    {
        return $user->can('create system_setting');
    }
}
