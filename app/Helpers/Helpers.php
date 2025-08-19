<?php

if (! function_exists('redis_connection')) {
    function redis_connection()
    {
        return Redis::connection(env('REDIS_USE_CLUSTER', false) ? 'clusters.default' : 'default');
    }
}
