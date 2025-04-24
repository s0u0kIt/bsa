<?php

namespace Classes;

use Framework\Config;
use Framework\Database;

class Token
{

  // Singleton instance
  private static Token $instance;
  private int $tokenLength;
  private int $tokenTimeOut;

  /**
   * Constructor: Initialize the database connection.
   *
   * @param array $config Database configuration (host, dbname, user, password).
   */
  public function __construct()
  {
    $this->tokenLength = Config::getInstance()->getConfig('token_length');
    $this->tokenTimeOut = Config::getInstance()->getConfig('token_timeout');
  }

  /**
   *  Get this class's singleton instance
   * 
   * @return Token
   */
  public static function getInstance()
  {
    if (!isset(self::$instance)) {
      self::$instance = new Token();
    }
    return self::$instance;
  }

  public function generateToken($saveInDatabase = false, $idAgent = false): string
  {
    $chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    $token = '';
    $maxIndex = strlen($chars) - 1;

    for ($i = 0; $i < $this->tokenLength; $i++) {
      $token .= $chars[random_int(0, $maxIndex)];
    }

    if ($saveInDatabase) {
      $this->saveToken($token, $idAgent);
    }
    
    return $token;
  }

  public function saveToken($token, $idAgent)
  {
    /**
     * IMPLEMENT HASHING LATER !!!!
     */
    // $hasher = new Hasher();
    // $hashedToken = $hasher->hash($token);
    
    Database::getInstance()->prepare('INSERT INTO Token (token, valid, idAgent) VALUES (?, ?, ?);', [$token, $this->getFutureDate($this->tokenTimeOut), $idAgent]);
  }

  public function getFutureDate($seconds): string
  {
    $date = new \DateTime();
    $date->modify("+{$seconds} seconds");
    return $date->format('Y-m-d H:i:s');
  }
}
