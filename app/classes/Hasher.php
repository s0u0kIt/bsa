<?php

namespace Classes;

use Framework\Config;

class Hasher
{
  /**
   * Hashes a given data (e.g., password) using the algorithm defined in the configuration.
   *
   * @param string $data The data to hash.
   * @return string The securely hashed data.
   */
  public static function hash(string $data): string
  {
    // Retrieve the algorithm from the configuration
    $algorithm = Config::getInstance()->getConfig('hash_algorithm');

    // Define hashing options based on the chosen algorithm
    switch ($algorithm) {
      case 'bcrypt':
        $options = ['cost' => 12]; // Adjustable cost factor
        $algo = PASSWORD_BCRYPT;
        break;

      case 'argon2i':
        $options = [
          'memory_cost' => 1 << 16, // 64MB memory usage
          'time_cost'   => 3,       // Number of iterations
          'threads'     => 2        // Parallelism factor
        ];
        $algo = PASSWORD_ARGON2I;
        break;

      case 'argon2id': // Recommended option
      default:
        $options = [
          'memory_cost' => 1 << 17, // 128MB memory usage
          'time_cost'   => 4,       // Number of iterations
          'threads'     => 2        // Parallelism factor
        ];
        $algo = PASSWORD_ARGON2ID;
        break;
    }

    return password_hash($data, $algo, $options);
  }

  /**
   * Verifies if a given data matches a stored hash.
   *
   * @param string $data The plain text data.
   * @param string $hash The stored hash.
   * @return bool True if the data matches the hash, False otherwise.
   */
  public static function verify(string $data, string $hash): bool
  {
    return password_verify($data, $hash);
  }

  /**
   * Checks if a hash needs to be updated based on current hashing parameters.
   *
   * @param string $hash The hash to check.
   * @return bool True if the hash needs to be updated, False otherwise.
   */
  public static function needsRehash(string $hash): bool
  {
    $algorithm = Config::getInstance()->getConfig('hash_algorithm');

    switch ($algorithm) {
      case 'bcrypt':
        $options = ['cost' => 12];
        $algo = PASSWORD_BCRYPT;
        break;

      case 'argon2i':
        $options = [
          'memory_cost' => 1 << 16,
          'time_cost'   => 3,
          'threads'     => 2
        ];
        $algo = PASSWORD_ARGON2I;
        break;

      case 'argon2id':
      default:
        $options = [
          'memory_cost' => 1 << 17,
          'time_cost'   => 4,
          'threads'     => 2
        ];
        $algo = PASSWORD_ARGON2ID;
        break;
    }

    return password_needs_rehash($hash, $algo, $options);
  }
}