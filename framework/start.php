<?php
use Framework\Autoloader;
use Framework\Config;
use Framework\Router;

require_once 'Autoloader.php';


// Initialize the autoloader and register it
$autoloader = new Autoloader($_SERVER['DOCUMENT_ROOT'].'/namespaces.json');
$autoloader->register();


// Initialize the config
Config::getInstance($_SERVER['DOCUMENT_ROOT'].'/config.json');

// Initialize the router and run it
$router = new Router($_SERVER['DOCUMENT_ROOT'].'/routes.json');

$router->dispatch();