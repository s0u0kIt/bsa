<?php
namespace Framework;

use ErrorException;
use InvalidArgumentException;
use stdClass;

class Request
{
  private stdClass $get;
  private stdClass $post;
  private stdClass $server;
  private stdClass $cookie;
  private stdClass $files;
  private ?stdClass $json;

  /**
   * Constructor to initialize the request data
   */
  public function __construct(stdClass $get = null, stdClass $post = null, stdClass $server = null, stdClass $cookie = null, stdClass $files = null, stdClass $json = null)
  {
    $this->get = $get ?? (object) $_GET;
    $this->post = $post ?? (object) $_POST;
    $this->server = $server ?? (object) $_SERVER;
    $this->cookie = $cookie ?? (object) $_COOKIE;
    $this->files = $files ?? (object) $_FILES;

    // Initialize json object if content type is json and method is not GET
    $this->json = ($this->isContentJson() && !$this->isGet()) ? json_decode(file_get_contents('php://input')) : null;
  }

  /**
   * @param array $keys The key to find the value in the method cl  ass
   * @return mixed Returns the associated value for a given key, or null if it doesn't exist or is null. If no key is provided, returns the method class itself.
   */
  public function get(array $keys = null, bool $sanitize = true): mixed
  {
    return $this->getValues($keys, 'get', $sanitize);
  }

  /**
   * @param array $keys The key to find the value in the method class
   * @return mixed Returns the associated value for a given key, or null if it doesn't exist or is null. If no key is provided, returns the method class itself.
   */
  public function post(array $keys = null, bool $sanitize = true): mixed
  {
    return $this->getValues($keys, 'post', $sanitize);
  }

  /**
   * @param array $keys The key to find the value in the method class
   * @return mixed Returns the associated value for a given key, or null if it doesn't exist or is null. If no key is provided, returns the method class itself.
   */
  public function server(array $keys = null, bool $sanitize = true): mixed
  {
    return $this->getValues($keys, 'server', $sanitize);
  }

  /**
   * @param array $keys The key to find the value in the method class
   * @return mixed Returns the associated value for a given key, or null if it doesn't exist or is null. If no key is provided, returns the method class itself.
   */
  public function cookie(array $keys = null, bool $sanitize = true): mixed
  {
    return $this->getValues($keys, 'cookie', $sanitize);
  }

  /**
   * @param array $keys The key to find the value in the method class
   * @return mixed Returns the associated value for a given key, or null if it doesn't exist or is null. If no key is provided, returns the method class itself.
   */
  public function file(array $keys = null, bool $sanitize = true): mixed
  {
    return $this->getValues($keys, 'files', $sanitize);

  }

  /**
   * @param array $keys The key to find the value in the method class
   * @return mixed Returns the associated value for a given key, or null if it doesn't exist or is null. If no key is provided, returns the method class itself.
   */
  public function json(array $keys = null, bool $sanitize = true): mixed
  {
    return $this->getValues($keys, 'json', $sanitize);
  }

  /**
   * @param array $keys The key to find the value in the method class
   * @param string $method The method class
   * @param bool $sanitize Wether values should be sanitized before return
   * @return mixed Returns the associated value(s) for given key(s), or null if it doesn't exist or is null. If no key is provided, returns the method class itself.
   */
  public function getValues(array $keys = null, string $method, bool $sanitize = true): mixed
  {
    // Return the whole object if no keys are specified
    if ($keys === null) {
      return $this->$method;
    }

    // Handle a single key case
    if (count($keys) === 1) {
      $key = $sanitize ? $this->sanitize($this->match($keys[0]), $method) : ($this->$method->{$keys[0]} ?? null);
      return $key;
    }

    // Handle multiple keys
    $result = new stdClass();
    foreach ($keys as $key) {
      if ($sanitize) {
        $keyInfo = $this->match($key);
        $result->{$keyInfo->key} = $this->sanitize($keyInfo, $method);
      } else {
        $result->{$key} = ($this->$method->{$key} ?? null);
      }
    }

    return $result;
  }


  /**
   * Matches and parses the key to extract its metadata.
   *
   * This method takes a key in the format of "key:type" and optionally a "*" to indicate that the key is required.
   * It parses the key to extract the actual key, its expected type, and whether it's required.
   *
   * @param string $key The key to match, in the format "key:type" and optionally "*" for required.
   *
   * @return object An object containing the parsed key metadata:
   * - 'key': The actual key
   * - 'type': The expected type (defaults to 's' for string)
   * - 'required': A boolean indicating if the key is mandatory
   * @throws InvalidArgumentException If the key format is invalid or the key is not a string.
   */
  private function match(string $key): object
  {
    // Match the key format "key:type*"
    if (!preg_match('/([a-zA-Z0-9_-]*):([a-z]*)(\*)?/', $key, $matches)) {
      throw new InvalidArgumentException("Invalid key format '{$key}'.", 500);
    }

    // Assign parsed values to the class object
    return (object) [
      'key' => $matches[1],
      'type' => (!empty($matches[2]) ? $matches[2] : 's'), // Default type to 's' (string)
      'required' => isset($matches[3]) // '*' indicates required
    ];
  }


  /**
   * Sanitizes and validates the request value based on its type.
   *
   * This method checks if the value matches the specified type (integer, string, float, boolean, or array) and returns
   * the sanitized value. If the value is required and missing, or if the type is unsupported, an error is thrown.
   *
   * @param object $keyInfo Contains metadata for the key, type, and required flag.
   * @param string $method The request method (get, post, etc.) from which to retrieve the value.
   *
   * @return mixed The sanitized value or null if invalid.
   * @throws ErrorException If the value is required but missing, or if the type is unsupported.
   */
  private function sanitize(object $keyInfo, string $method): mixed
  {
    $key = $keyInfo->key;
    $type = $keyInfo->type;
    $required = $keyInfo->required;

    // Retrieve the raw value based on the method
    $value = $this->$method->$key ?? null;

    // Check if the value is required and missing
    if ($required && $value === null) {
      throw new ErrorException("Required key '{$key}' is missing.");
    }

    // Sanitize based on type
    switch ($type) {
      case 'i': // Integer
        return filter_var($value, FILTER_VALIDATE_INT, FILTER_NULL_ON_FAILURE);
      case 's': // String
        return is_string($value) ? trim($value) : null;
      case 'f': // Float
        return filter_var($value, FILTER_VALIDATE_FLOAT, FILTER_NULL_ON_FAILURE);
      case 'b': // Boolean
        return filter_var($value, FILTER_VALIDATE_BOOLEAN, FILTER_NULL_ON_FAILURE);
      case 'a': // Array
        return is_array($value) ? $value : null;
      case 'e':
        return filter_var($value, FILTER_VALIDATE_EMAIL, FILTER_NULL_ON_FAILURE);
      case 'ip':
        return filter_var($value, FILTER_VALIDATE_URL, FILTER_NULL_ON_FAILURE);
      default:
        throw new ErrorException("Unsupported type '{$type}' for key '{$key}'.");
    }
  }


  /**
   * @return bool Returns True if current request's method is GET, False otherwise
   */
  public function isGet(): bool
  {
    return $this->server(['REQUEST_METHOD'], false) === 'GET';
  }

  /**
   * @return bool Returns True if current request's method is POST, False otherwise
   */
  public function isPost(): bool
  {
    return $this->server(['REQUEST_METHOD'], false) === 'POST';
  }

  /**
   * @return mixed Returns the method of the current request or null if empty
   */
  public function getMethod(): mixed
  {
    return $this->server(['REQUEST_METHOD'], false);
  }

  /**
   * @return mixed Returns the uri of the current request or null if empty
   */
  public function getUri(): mixed
  {
    return $this->server(['REQUEST_URI'], false);
  }
  
  /**
   * @return mixed Returns the content type of the current request or null if empty
   */
  public function getContentType(): mixed
  {
    return $this->server(['CONTENT_TYPE'], false);
  }

    /**
   * @return bool Returns True if current request's method is POST, False otherwise
   */
  public function isContentJson(): bool
  {
    return $this->getContentType() === 'application/json';
  }
}