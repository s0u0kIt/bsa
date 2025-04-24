<?php

spl_autoload_register(function ($className) {
    $className = str_replace('\\', '/', $className);
    $path = 'lib/' . $className . '.php';
    if (! file_exists($path)) {
        $path = $className . '.php';
    }
    require $path;
});

