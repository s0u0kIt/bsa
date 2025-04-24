<?php

namespace Framework;

use Libs\Smarty\SmartyWrapper;
use stdClass;
use RuntimeException;

/**
 * Class Router
 * Handles routing logic based on routes defined in a JSON file.
 */
class Router
{
	/**
	 * @var stdClass Stores the routes from the routes file.
	 */
	private static StdClass $routes;

	/**
	 * Constructor.
	 * Loads the routes from a JSON file.
	 * @param string $routesFile Path to the JSON file containing route definitions.
	 */
	public function __construct(string $routesFile)
	{
		// Loads the routes from the given JSON file and decodes it into an object.
		self::$routes = json_decode(file_get_contents($routesFile), false);
	}

	/**
	 * Dispatches the incoming request to the appropriate route, sends 404 error if no matching route is found.
	 * @param string $uri The URI requested by the client.
	 * @param string $method The HTTP method (e.g., GET, POST) used for the request.
	 * @return void
	 */
	public function dispatch(): void
	{
		// Create a new Request object to fetch request details.
		$request = new Request();

		// Loop through all routes and try to match the request URI and method with a route.
		foreach (self::$routes as $route) {
			$this->match($route, $request->getUri(), $request->getMethod());
		}

		// If no matching route is found, send a 404 error.-
		$smarty = SmartyWrapper::getSmarty();
		http_response_code(404);
		$smarty->display('404.tpl');
	}

	/**
	 * Matches the URI and method to a route definition.
	 * @param stdClass $route The current route being checked.
	 * @param string $uri The URI requested by the client.
	 * @param string $method The HTTP method used for the request.
	 * @return void
	 */
	private function match(stdClass $route, string $uri, string $method): void
	{
		// Normalisation de l'URI (suppression du '/' à la fin, sauf pour la racine)
		$uri = rtrim($uri, '/') ?: '/';
		$routeUri = rtrim($route->uri, '/') ?: '/';

		// Suppression des paramètres de requête
		$firstpart = explode('?', $uri)[0];

		// Si la méthode HTTP ne correspond pas, on ignore
		if ($route->method !== $method) {
			return;
		}

		// Gestion des paramètres dynamiques (par exemple: /users/{id})
		$pattern = preg_replace('/\{[^\/]+\}/', '([^\/]+)', $routeUri); // Remplace {param} par regex
		$pattern = '#^' . $pattern . '$#'; // Encadre pour correspondance complète

		if (preg_match($pattern, $firstpart, $matches)) {
			// Extraire les paramètres dynamiques
			array_shift($matches); // Supprime le premier élément (URI complète)
			$route->params = $matches; // Stocke les paramètres dynamiques dans l'objet route

			// Appelle la méthode handle pour cette route
			$this->handle($route);
		}
	}


	/**
	 * Handles the execution of the matched route.
	 * @param stdClass $route The route configuration matched to the request.
	 * @return void
	 */
	private function handle(stdClass $route): void
	{
		// Check if the route has a redirect URI and perform the redirection.
		$this->redirect($route);

		//Check if the route has middlewares and executes them one by one in the order of .json file.
		$this->middleware($route);

		// Check if the route specifies a controller and action, then execute it.
		if (isset($route->controller, $route->action)) {
			$class = Config::getInstance()->getConfig()->controllersNamespace . $route->controller;
			$method = $route->action;

			// If the controller class and method exist, instantiate the controller and call the method.
			if (class_exists($class, true) && method_exists($class, $method)) {
				$controller = new $class;
				$controller->$method();
				exit;
			} else {
				// If the class or method doesn't exist, output an error message.
				throw new RuntimeException('No action or class defined for ' . $route->uri . ' route', 500);
			}
		}

		// If no controller or method is found for the route, output an error message.
		throw new RuntimeException('No action or class defined for ' . $route->uri . ' route', 500);
	}

	/**
	 * Check if the route has a redirect URI and perform the redirection.
	 * 
	 * @param \stdClass $route
	 * @return void
	 */
	private function redirect(stdClass $route): void
	{
		if (isset($route->redirect_uri)) {
			header('Location: ' . $route->redirect_uri, true, 303);
			exit;
		}
	}

	/**
	 * Check if the route has middlewares and apply them.
	 * 
	 * @param \stdClass $route
	 * @return void
	 */
	private function middleware(stdClass $route): void
	{
		if (isset($route->middlewares)) {
			foreach ($route->middlewares as $middlewareName) {
				$class = Config::getInstance()->getConfig()->middlewaresNamespace . $middlewareName;
				// If the middleware class exists, instantiate and executes it.
				if (class_exists($class, true)) {
					$middleware = new $class;
					$middleware->handle();
				} else {
					// If the class or method doesn't exist, output an error message.
					throw new RuntimeException('Middleware ' . $middlewareName . ' does not exist for ' . $route->uri, 500);
				}
			}
		}
	}
}