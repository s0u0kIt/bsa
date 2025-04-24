<?php

namespace teachframe;

/**
 * Class Router
 *
 * Cette classe gère les routes de l'application et  dispatche les requêtes
 * vers les contrôleurs appropriés en fonction de la méthode HTTP et de l'URL.
 * Les routes peuvent être chargées à partir d'un fichier YAML, ou ajoutées dans le code.
 */
class Router {
  private array $routes;
  
  public function __construct() {
    $this->routes = [];
  }
  
  /**
   * Ajoute une nouvelle route.
   *
   * @param $route tableau associatif ayant les clés 'method' et 'path'
   * ainsi que la clé 'redirect' ou les clés 'controller', et 'action'.
   */
  public function addRoute (array $route) {
    $this->routes[] = $route;
  }
  
  /**
   * Charge les routes à partir d'un fichier YAML.
   *
   * @param $yamlFile chemin vers le fichier YAML contenant les routes.
   * @throws \Exception si le fichier YAML ne peut pas être analysé.
   *
   * Le fichier de routes doit être au format YAML doit respecter la structure suivante :
   * routes:
   *   <route_name>:
   *     path: <route_path>
   *     method: <http_method>
   *     controller: <controller_class>
   *     action: <controller_method>
   */
  public function loadRoutes (string $yamlFile) {
    $this->routes = yaml_parse_file($yamlFile)['routes'];
  }

  /**
   * Dispatche une requête en fonction de la méthode HTTP et de l'URL.
   *
   * @param $requestMethod méthode HTTP (GET, POST, ...).
   * @param $requestUri URL de la requête.
   */
  public function dispatch (string $requestMethod, string $requestUri) {
    $uriParts = explode('/', trim($requestUri, '/'));
    
    $found = false;
    foreach ($this->routes as $key => $route) {
    
      if (!isset($route['method'])) {
        http_response_code(500);
        die('error: route \'' . $key . '\' is missing \'method\'');
      }
      
      if ($route['method'] == $requestMethod) {
        $routeParts = explode('/', trim($route['path'], '/'));
        
        if (count($uriParts) == count($routeParts)) {
          $params = [];
          $match = true;
          
          foreach ($routeParts as $index => $part) { //vérification de chaque partie du chemin
            if (strpos($part, '{') == 0 && strpos($part, '}') == strlen($part) - 1) {
              $params[] = $uriParts[$index];
            } elseif ($part != $uriParts[$index]) {
              $match = false; break;
            }
          }
          
          if ($match) {
            if (isset($route['redirect'])) {
              header('Location: ' . $route['redirect']);
            } else if (isset($route['controller']) && isset($route['action'])) {
              $controller = new $route['controller']();
              $method = $route['action'];
              $controller->$method(...$params);
            } else {
              http_response_code(500);
              die('error: route \'' . $key . '\' is missing \'redirect\' or \'controleur\' + \'action\'');
            }
            $found = true; break;
          }
          
        }
      }
    }
    if (!$found) { 
      http_response_code(404);
    }
  }
  
  /**
   * Renvoie la documentation utilisateur des routes (pour API).
   *
   * @return tableau des routes.
   */
  public function getRoutes(): array {
    $routes = [];
    foreach ($this->routes as $route) {
      $fields = [];
      foreach ($route as $key => $value) {
        if ($key != 'controller' && $key != 'action' && $key != 'redirect') {
          $fields[$key] = $value;
        }
      }
      $routes[] = $fields; 
    }
    return $routes;
  }
}