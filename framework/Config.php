<?php
namespace Framework;

use stdClass;
use Exception;

class Config
{
  // Singleton instance of Config
  private static ?Config $instance = null;

  // Stores the configuration data from the JSON file
  private ?stdClass $config = null;

  // Default configuration file name
  private static string $defaultFile = 'config.json';

  /**
   * Private constructor to prevent direct instantiation.
   * Loads and decodes the configuration file.
   * 
   * @param string $configFile The path to the configuration file.
   * @throws Exception If the configuration file cannot be read or if the JSON format is invalid.
   */
  private function __construct(string $configFile)
  {
    // Read the content of the config file
    $fileContent = file_get_contents($configFile);
    if ($fileContent === false) {
      throw new Exception('Unable to read the config file: ' . $configFile);
    }

    // Decode the JSON content into a stdClass object
    $decodedContent = json_decode($fileContent, false);
    if (json_last_error() !== JSON_ERROR_NONE) {
      throw new Exception('Invalid JSON format in the config file: ' . $configFile);
    }

    // Assign the decoded content to the config property
    $this->config = $decodedContent;
  }

  /**
   * Retrieves the singleton instance of the Config class.
   * If the instance doesn't exist, it will create it by loading the configuration file.
   * 
   * @param string|null $configFile The path to the configuration file. If null, the default file will be used.
   * @return Config The singleton instance of the Config class.
   */
  public static function getInstance(string $configFile = null): Config
  {
    // If the instance does not exist, create a new one
    if (is_null(self::$instance)) {
      self::$instance = new self($configFile ?? self::$defaultFile);
    }

    // Return the singleton instance
    return self::$instance;
  }

  /**
   * Gets the entire configuration object.
   * 
   * @return mixed Return the string that match the attribute. Return the config object itself if no attribute is specified
   */
  public function getConfig(string $attribute = null): mixed
  {
    return isset($attribute) ? (isset($this->config->{$attribute})) ? $this->config->{$attribute} : null : $this->config;
  }
}