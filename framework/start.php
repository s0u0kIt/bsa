<?php
use Framework\Autoloader;
use Framework\Config;
use Framework\Router;
use Framework\Database;

require_once 'Autoloader.php';


// Initialize the autoloader and register it
$autoloader = new Autoloader('namespaces.json');
$autoloader->register();


// Initialize the config
Config::getInstance('config.json');

// Initialize the router and run it
$router = new Router('routes.json');

$router->dispatch();