<?php

namespace Framework;

use PDO;
use Exception;
use PDOException;
use Framework\Error;
use Framework\Config;

class Database
{

  // Singleton instance
  private static Database $instance;
  private PDO $pdo;

  /**
   * Constructor: Initialize the database connection.
   *
   * @param array $config Database configuration (host, dbname, user, password).
   */
  public function __construct()
  {
    $host = Config::getInstance()->getConfig('db_host');
    $name = Config::getInstance()->getConfig('db_name');
    $user = Config::getInstance()->getConfig('db_user');
    $password = Config::getInstance()->getConfig('db_password');
    // Generate the dsn based on host and database name
    $dsn = "mysql:host=$host;dbname=$name;charset=utf8mb4";

    // Attempt connection
    try {
      $this->pdo = new PDO($dsn, $user, $password);
    } catch (PDOException $e) {
      error_log($e);
      http_response_code(500);
      exit;
    }
  }

  /**
   *  Get this class's singleton instance
   * 
   * @return Database
   */
  public static function getInstance() {
    if (!isset(self::$instance)) {
      self::$instance = new Database();
    }
    return self::$instance;
  }

  /**
   * Insert an entity into the database
   *
   * @param object $entity The entity object to insert
   * @return int The ID of the inserted record
   */
  public function create(object $entity): int
  {
    // Get the table name from the entity class name
    $table = $this->getTableName($entity);

    // Get properties and values from the entity object
    $data = get_object_vars($entity);

    // Remove id from object
    unset($data['id']);
    // Create columns and values used
    $keys = implode(', ', array_keys($data));
    $values = implode(', ', array_fill(0, count($data), '?'));

    // Prepare the SQL query
    $sql = "INSERT INTO $table ($keys) VALUES ($values)";
    $stmt = $this->pdo->prepare($sql);

    // Execute the query
    $stmt->execute(array_values($data));

    // Return the ID of the inserted record
    return (int) $this->pdo->lastInsertId();
  }

  /**
   * Update an existing entity of the database
   *
   * @param object $entity The entity object to update
   * @return bool Returns True if the request was successful, returns False otherwise
   */
  public function update(object $entity): bool
  {
    // Get the table name from the entity class name
    $table = $this->getTableName($entity);

    // Get properties and values from the entity object
    $data = get_object_vars($entity);
    if (!isset($data['id'])) {
      throw new Exception("Missing id parameter for $table table update", 500);
    }

    // Store and unset id
    $id = $data['id'];
    unset($data['id']);

    // Generate SQL
    $sql = 'UPDATE ' . $table . ' SET ';
    $parts = [];
    foreach ($data as $key => $value) {
      $parts[] = "$key = '$value'";
    }
    $sql .= implode(', ', $parts) . ' WHERE id = ' . $id;

    // Execute the query
    $stmt = $this->pdo->prepare($sql);
    return $stmt->execute();
  }

  /**
   * Get the table name for an entity
   *
   * @param object $entity The entity object
   * @return string The table name
   */
  private function getTableName(object $entity): string
  {
    $className = (new \ReflectionClass($entity))->getShortName();
    return strtolower($className);
  }

  /**
   * Execute simple prepared query
   * 
   * @param string $sql SQL query string
   * @param array $params Params used to execute the prepared query
   * @return mixed Returns an array containing all the query's resultset, or false on failure
   */
  public function prepare(string $sql, array $params = null): mixed {
    $stmt = $this->pdo->prepare($sql);
    if (is_null($params)) {
      if($stmt->execute()) {
        if ($stmt->rowCount() > 0) {
          return $stmt->fetchAll(PDO::FETCH_OBJ);
        }
        return true;
      }
    } else {
      if ($stmt->execute($params)) {
        if ($stmt->rowCount() > 0) {
          return $stmt->fetchAll(PDO::FETCH_OBJ);
        }
        return true;
      }
    }
    return false;
  }
}