<?php
/**
 * 
 * ! CONTROLLERS MUST HAVE THEIR OWN NAMESPACE MAPPED DIRECTLY TO THE CONTROLLERS FOLDER !
 * The mapping must be specified in the "namespaces.json" file
 * The namespace must also be spcified in the "config.json" file
 * 
 */

namespace Framework;

use Exception;
use stdClass;

class Autoloader
{
    private stdClass $namespaces;

    /**
     * Constructor for the Autoloader class.
     * Loads and decodes the PSR-4 namespace mappings from a JSON file.
     * 
     * @param string $namespaces The path to the JSON file containing the PSR-4 mappings.
     * @throws Exception If the file cannot be read or the JSON is invalid.
     */
    public function __construct(string $namespaces)
    {
        $fileContent = file_get_contents($namespaces);
        if ($fileContent === false) {
            throw new Exception("Unable to read the PSR-4 file: $namespaces");
        }

        $decodedContent = json_decode($fileContent, false);
        if (json_last_error() !== JSON_ERROR_NONE) {
            throw new Exception("Invalid JSON format in PSR-4 file: $namespaces");
        }

        $this->namespaces = $decodedContent->psr4;
    }

    /**
     * Registers the autoload function with SPL autoload stack.
     * This method makes the `autoload` function active for loading classes dynamically.
     * 
     * @return void
     */
    public function register(): void
    {
        spl_autoload_register([$this, 'autoload']);
    }

    /**
     * Autoloads a class based on its namespace and class name.
     * Resolves the file path for the class using PSR-4 mappings and includes the file if it exists.
     * 
     * @param string $className The fully qualified name of the class to be autoloaded.
     * @return void
     * @throws Exception If the file for the class cannot be found.
     */
    public function autoload(string $className): void
    {
        // Check if the class contains a namespace
        if (!str_contains($className, '\\')) {
            return;
        }

        // Explode the classname to extract namespace
        $namespaceParts = explode("\\", $className);
        $namespace = array_shift($namespaceParts) . '\\'; // The first part

        // Check if the namespace is mapped in the PSR-4 configuration
        if (!isset($this->namespaces->$namespace)) {
            throw new Exception("Namespace '$namespace' not mapped in PSR-4 configuration.");
        }

        // Build the file path based on the namespace and class name
        $className = array_pop($namespaceParts); // The last part
        $subPath = empty($namespaceParts) ? null : strtolower(implode('/', $namespaceParts)) . '/';
        $path = $subPath . $className . '.php';
        $includePath = dirname(__DIR__) . '/' . $this->namespaces->$namespace . $path;
        $normalizedPath = str_replace('\\', '/', $includePath);

        //Include the file or throw an exception if it doesn't exist
        if (file_exists($normalizedPath)) {
            require $normalizedPath;
        } else {
            throw new Exception("Unable to load class: $className. File not found at: $normalizedPath");
        }
    }
}
