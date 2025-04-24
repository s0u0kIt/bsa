<?php

namespace Middlewares;

use Framework\Config;
use Framework\Database;
use Framework\JWT;
use Framework\Request;
use Libs\Smarty\SmartyWrapper;

class AuthMiddleware
{
  public function handle()
  {
    // Temporary store the requested URI
    session_start();
    $_SESSION['redirect_url'] = $_SERVER['REQUEST_URI'];

    $request = new Request();
    $cookie = $request->cookie([Config::getInstance()->getConfig('jwt_cookie_name') . ":s"]);
    $decodedJWT = JWT::getInstance()->decode($cookie);

    if (null === $decodedJWT) {
      header('Location: /connexion');
      exit;
    }

    // If JWT is valid, verify user credentials
    $this->verifyCredentials($decodedJWT);
    return;
  }

  /**
   * Verify user credentials from a POST request or JWT and handle redirection.
   */
  public function verifyCredentials($inputs = null): void
  {
    // Check if the request is for the admin panel or mobile site
    if ($this->isUrlAdmin()) {
      $this->verifyAppCredentials($inputs);
    } else {
      $this->verifyMobileCredentials($inputs);
    }
  }

  /**
   * Authenticate admin users.
   */
  public function verifyAppCredentials($inputs): void
  {
    // Validate inputs
    if (empty($inputs->login)) {
      header('Location: /connexion');
      exit;
    }

    // Fetch user by login
    $result = Database::getInstance()->prepare(
      'SELECT * FROM Agent WHERE login = ? AND role = "Admin" AND role != "Inactif"',
      [$inputs->login]
    );

    if (!is_array($result) || count($result) === 0) {
      header('Location: /connexion');
      exit;
    }

    $this->assignUserToSmarty($inputs->lastname, $inputs->firstname, $inputs->login);

    return;
  }

  /**
   * Assign user to smarty variables to access them in templates
   */
  private function assignUserToSmarty($lastname, $firstname, $login): void {
    $user = array('lastname' => $lastname, 'firstname' => $firstname, 'login' => $login);
    $smarty = SmartyWrapper::getSmarty();
    $smarty->assign('user', $user);
    return;
  }

  /**
   * Authenticate mobile users.
   */
  public function verifyMobileCredentials($inputs): void
  {
    // Validate inputs
    if (empty($inputs->login)) {
      header('Location: /connexion');
      exit;
    }

    // Fetch user by login
    $result = Database::getInstance()->prepare(
      'SELECT * FROM Agent WHERE login = ? AND role != "Inactif"',
      [$inputs->login]
    );

    if (!is_array($result) || count($result) === 0) {
      header('Location: /connexion');
      exit;
    }

    return;
  }

  /**
   * Check if the requested URL is for the admin panel.
   */
  private function isUrlAdmin(): bool
  {
    return isset($_SESSION['redirect_url']) && strpos($_SESSION['redirect_url'], '/app') === 0;
  }
}
