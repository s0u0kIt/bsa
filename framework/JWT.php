<?php

namespace Framework;

use RuntimeException;

/**
 * JSON Web Token (JWT) Minimalist Library
 * Provides functionality to encode and decode JWTs for secure information exchange.
 */
class JWT
{
  // Singleton instance of the JWT class
  private static JWT $instance;

  // Secret key for signing the JWT
  private string $key;

  // Token expiration timeout in seconds
  private int $timeout;

  // Hashing algorithm used for signing
  private string $algorithm;

  /**
   * Constructor for the JWT class.
   * Private to enforce singleton pattern.
   *
   * @param string $key The secret key for signing the JWT.
   * @param int $timeout Token expiration timeout.
   * @param string $algorithm Hashing algorithm (e.g., 'sha256').
   */
  private function __construct(string $key, int $timeout, string $algorithm)
  {
    $this->key = $key;
    $this->timeout = $timeout;
    $this->algorithm = $algorithm;
  }

  /**
   * Returns the singleton instance of the JWT class.
   * Ensures the class is configured properly via a configuration file.
   *
   * @return JWT The singleton instance.
   * @throws RuntimeException If any required configuration parameter is missing.
   */
  public static function getInstance(): JWT
  {
    if (!isset(JWT::$instance)) {
      $config = Config::getInstance()->getConfig();

      if (!isset($config->jwt_key)) {
        throw new RuntimeException("Missing 'jwt_key' in configuration file.");
      }

      if (!isset($config->jwt_timeout)) {
        throw new RuntimeException("Missing 'jwt_timeout' in configuration file.");
      }

      if (!isset($config->jwt_algorithm)) {
        throw new RuntimeException("Missing 'jwt_algorithm' in configuration file.");
      }

      JWT::$instance = new JWT($config->jwt_key, $config->jwt_timeout, $config->jwt_algorithm);
    }

    return JWT::$instance;
  }

  /**
   * Encodes data in a URL-safe Base64 format.
   *
   * @param string $data Data to encode.
   * @return string URL-safe Base64 encoded string.
   */
  private function base64UrlEncode(string $data): string
  {
    return rtrim(strtr(base64_encode($data), '+/', '-_'), '=');
  }

  /**
   * Decodes a URL-safe Base64 encoded string.
   *
   * @param string $data URL-safe Base64 encoded string.
   * @return string Decoded data.
   */
  private function base64UrlDecode(string $data): string
  {
    return base64_decode(strtr($data, '-_', '+/'));
  }

  /**
   * Encodes an array of fields into a JWT.
   *
   * @param array $fields Payload fields to include in the token.
   * @param string|null $issuer The issuer of the token (default: server name).
   * @return string The generated JWT.
   */
  public function encode(array $fields, string $issuer = null, int $timeout = null): string
  {
    if (!isset($issuer)) {
      $issuer = $_SERVER['SERVER_NAME'];
    }

    // Create the header and payload
    $header = $this->base64UrlEncode(json_encode(["alg" => $this->algorithm, "typ" => "JWT"]));
    $values = array_merge(["iss" => $issuer, "exp" => time() + ($timeout ?? $this->timeout)], $fields);
    $payload = $this->base64UrlEncode(json_encode($values));

    // Generate the signature
    $signature = hash_hmac($this->algorithm, "$header.$payload", $this->key, true);
    $encodedSignature = $this->base64UrlEncode($signature);

    // Return the complete JWT
    return "$header.$payload.$encodedSignature";
  }

  /**
   * Decodes and verifies a JWT.
   *
   * @param string $jwt The JSON Web Token to decode.
   * @return object|null Decoded payload object, or null if the JWT is invalid or expired.
   */
  public function decode(string $jwt = null): ?object
  {
    if ($jwt === null) {
      return null;
    }
    
    // Split the JWT into its components
    $parts = explode('.', $jwt, 3);

    if (count($parts) !== 3) {
      return null;
    }

    [$header, $payload, $signature] = $parts;

    // Recompute the signature and compare
    $computedSignature = $this->base64UrlEncode(hash_hmac($this->algorithm, "$header.$payload", $this->key, true));
    if (!hash_equals($computedSignature, $signature)) {
      return null;
    }

    // Decode the payload
    $decodedPayload = json_decode($this->base64UrlDecode($payload));

    // Verify expiration time
    if (!$decodedPayload || !isset($decodedPayload->exp) || time() > $decodedPayload->exp) {
      return null;
    }

    // Return the decoded payload
    return $decodedPayload;
  }

  /**
   * Verifies if a JWT is correctly encoded with the defined key and algorithm.
   *
   * @param string $jwt The JSON Web Token to verify.
   * @return bool True if the JWT is valid, False otherwise.
   */
  public function isValid(string $jwt): bool
  {
    // Split the JWT into its components
    $parts = explode('.', $jwt, 3);

    // A valid JWT must have exactly three parts: header, payload, and signature
    if (count($parts) !== 3) {
      return false;
    }

    [$header, $payload, $signature] = $parts;

    // Recalculate the signature using the provided key and algorithm
    $computedSignature = $this->base64UrlEncode(hash_hmac($this->algorithm, "$header.$payload", $this->key, true));

    // Verify that the computed signature matches the signature in the token
    if (!hash_equals($computedSignature, $signature)) {
      return false;
    }

    // Decode the payload to verify its content
    $decodedPayload = json_decode($this->base64UrlDecode($payload));

    // Verify the payload is valid and the token has not expired
    if (!$decodedPayload || !isset($decodedPayload->exp) || time() > $decodedPayload->exp) {
      return false;
    }

    // If all checks pass, the JWT is valid
    return true;
  }
}