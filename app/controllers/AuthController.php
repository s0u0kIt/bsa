<?php

namespace Controllers;

use Classes\Hasher;
use Classes\Mail;
use Classes\Token;
use Framework\Config;
use Framework\Database;
use Framework\JWT;
use Framework\Request;
use Libs\Smarty\SmartyWrapper;

class AuthController
{
  /**
   * Display the sign-in form
   */
  public function getSigninForm(): void
  {
    $request = new Request();
    $wrongCredentials = is_string($request->get(['wrong_credentials:s']));

    $smarty = SmartyWrapper::getSmarty();
    if ($wrongCredentials) {
      $smarty->assign('message', 'Identifiants incorrects');
    }
    $smarty->display("signin.tpl");
  }

  /**
   * Display the forgot password form
   */
  public function getForgotPasswordForm(): void
  {
    $request = new Request();
    $emailSent = is_string($request->get(['email_sent:s']));

    $smarty = SmartyWrapper::getSmarty();
    if ($emailSent) {
      $smarty->assign('sent', true);
    }
    $smarty->display("forgot-password.tpl");
  }

  /**
   * Display the reset password form
   */
  public function getResetPasswordForm(): void
  {
    $request = new Request();
    $token = $request->get(['token:s']);
    $wrongCredentials = $request->get(['wrong_credentials:s']);
    $passwordReset = is_string($request->get(['password_reset:s']));

    $smarty = SmartyWrapper::getSmarty();
    if ($passwordReset) {
      $smarty->assign('reset', true);
    } else {
      $smarty->assign('token', $token ?? null);
    }

    if (is_string($wrongCredentials)) {
      $smarty->assign('message', 'Email incorrect, veuillez réessayer');
    }

    $smarty->display("reset-password.tpl");
  }

  /**
   * Send password reset with mail
   */
  public function sendResetPasswordEmail($email = null): void
  {
    $request = new Request();

    $email = $email ?? $request->post(['login:e']);

    // Redirect to homepage if no email is sent
    if (null === $email) {
      header('Location: /');
      exit;
    }

    // Check if email exists in database
    $agent = Database::getInstance()->prepare('SELECT * FROM Agent WHERE login = ? AND role != "Inactif"', [$email]);
    if (!is_array($agent)) {
      header('Location: /');
      exit;
    }

    // Generate token and put it in database
    $token = Token::getInstance()->generateToken(true, $agent[0]->idAgent);

    $url = Config::getInstance()->getConfig('app_url') . '/reinitialisation';
    $body = "Voici votre lien de réinitialisation de mot de passe: $url?token=$token";

    $mail = new Mail();
    $mail->sendEmail($email, 'BSA | Reinitialisation de mot de passe', $body);

    header('Location: /mot-de-passe-oublie?email_sent');
    exit;
  }

  /**
   * Reset password if email and token are valid
   */
  public function resetPassword()
  {
    $request = new Request();

    $inputs = $request->post(['login:e*', 'password:s*', 'token:s']);


    // Validate inputs
    if (empty($inputs->login) || empty($inputs->password) || empty($inputs->token)) {
      header('Location: /');
      exit;
    }

    // Check if email exists in database
    $agent = Database::getInstance()->prepare('SELECT idAgent FROM Agent WHERE login = ?', [$inputs->login]);
    if (!is_array($agent)) {
      header('Location: /reinitialisation?wrong_credentials&token=' . $inputs->token);
      exit;
    }

    // Check if token and email match in database
    $tokenValid = is_array(Database::getInstance()->prepare('SELECT token FROM Token WHERE token = ? AND idAgent = ? AND valid > NOW()', [$inputs->token, $agent[0]->idAgent]));
    if (!$tokenValid) {
      header('Location: /');
      exit;
    }

    $hasher = new Hasher();
    $hashedPassword = $hasher->hash($inputs->password);

    // Reset password in database
    Database::getInstance()->prepare('UPDATE Agent SET pwd = ? WHERE login = ?', [$hashedPassword, $inputs->login]);

    // Remove used tokens
    Database::getInstance()->prepare('DELETE FROM Token WHERE idAgent = ?', [$agent[0]->idAgent]);

    header('Location: /reinitialisation?password_reset');
  }

  /**
   * Verify user credentials from a POST request or JWT and handle redirection
   */
  public function verifyCredentials(): void
  {
    // Start session for redirect URL
    session_start();

    // Retrieve data from the POST request
    $request = new Request();
    $inputs = $request->post(['login:s*', 'password:s*', 'remember:b', 'g-recaptcha-response:s*']);

    // Validate inputs
    if (empty($inputs->login) || empty($inputs->password)) {
      header('Location: /connexion?wrong_credentials');
      exit;
    }

    if (!$this->validateReCaptcha()) {
      header('Location: /connexion?wrong_credentials');
      exit;
    }

    // Fetch agent from the database using provided credentials
    $result = Database::getInstance()->prepare('SELECT * FROM Agent WHERE login = ? AND role != "Inactif"', [$inputs->login]);

    // If a matching user is found
    if (is_array($result) && count($result) > 0) {
      $agent = $result[0];

      // Verify password hash
      $hasher = new Hasher();
      if (!$hasher->verify($inputs->password, $agent->pwd)) {
        header('Location: /connexion?wrong_credentials');
        exit;
      }

      // Set cookie expiration time based on "remember me" option
      $timeout = ($inputs->remember)
        ? time() + Config::getInstance()->getConfig('jwt_long_timeout')
        : time() + Config::getInstance()->getConfig('jwt_timeout');

      // Generate a JWT for the user
      $jwt = JWT::getInstance()->encode(
        ["idAgent" => $agent->idAgent, "login" => $agent->login, "lastname" => $agent->nom, "firstname" => $agent->prenom],
        null,
        $timeout
      );

      // Set the JWT as a cookie
      setcookie(Config::getInstance()->getConfig('jwt_cookie_name'), $jwt, $timeout, '/');
      header('Location: ' . $_SESSION['redirect_url']);
      return;
    }

    // Redirect to the login page if authentication fails
    header('Location: /connexion?wrong_credentials');
    exit;
  }

  private function validateReCaptcha()
  {
    // Get reCAPTCHA response from request
    $request = new Request();
    $recaptcha_response = $request->post(['g-recaptcha-response:s*']);

    // Get reCAPTCHA secret key from config
    $recaptcha_secret = Config::getInstance()->getConfig('recaptcha_secret_key');

    // Vérification avec Google
    $url = "https://www.google.com/recaptcha/api/siteverify";
    $data = [
      "secret" => $recaptcha_secret,
      "response" => $recaptcha_response
    ];

    $options = [
      "http" => [
        "header"  => "Content-type: application/x-www-form-urlencoded",
        "method"  => "POST",
        "content" => http_build_query($data)
      ]
    ];

    $context  = stream_context_create($options);
    $result = file_get_contents($url, false, $context);
    $response = json_decode($result);

    return $response->success;
  }


  /**
   * Log the user out by clearing the authentication cookie and redirecting to the home page
   */
  public function logout(): void
  {
    setcookie(Config::getInstance()->getConfig('jwt_cookie_name'), '', time() - 3600, '/');
    header('Location: /connexion');
    exit;
  }
}
