<?php
namespace Controllers;

use Libs\Smarty\SmartyWrapper;

class AuthController {

  public function getSigninForm(): void {
    $smarty = SmartyWrapper::getSmarty();
    $smarty->display("signin.tpl");
  }

  public function getSignupForm(): void {
    $smarty = SmartyWrapper::getSmarty();
    $smarty->display("signup.tpl");
  }

  public function verifyCredentials(): void {
    echo 'logged in';
  }

  public function logout(): void {
    echo 'logged out';
  }
}