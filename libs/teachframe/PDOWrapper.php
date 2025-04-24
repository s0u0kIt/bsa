<?php

namespace teachframe;
use \PDO;

class PDOWrapper extends PDO {
  static private ?array $config = null;
  static private ?PDOWrapper $instance = null;
  
  private function __construct (string $dsn, string $usr, string $pwd) {
    try {
      parent::__construct($dsn, $usr, $pwd);
    } catch(PDOException $e) {
      http_response_code(500);
      die($e->getmessage());
    }
  }
  
  public static function getInstance(): PDOWrapper {
    if (null == PDOWrapper::$instance) {
        if (null != PDOWrapper::$config) {
          PDOWrapper::$instance = new PDOWrapper(PDOWrapper::$config['dsn'],
                                                 PDOWrapper::$config['usr'],
                                                 PDOWrapper::$config['pwd']);
        }
    }
    return PDOWrapper::$instance;
  }
  
  public static function setConfig (string $configFile) {
    PDOWrapper::$config = yaml_parse_file($configFile)['db'];
  }
}