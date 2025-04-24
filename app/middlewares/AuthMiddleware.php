<?php
namespace Middlewares;

use Framework\Database;

class AuthMiddleware {
  public function handle() {
    /**
     * IMPLEMENT AUTHENTICATION LOGIC HERE
     * CERTAINLY USING HASHED COOKIE TOKEN FROM $request->cookie
     */

     header('Location: /signin');
     exit;
  }
}