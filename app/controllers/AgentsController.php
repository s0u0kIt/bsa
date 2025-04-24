<?php

namespace Controllers;

use Classes\Hasher;
use Classes\Mail;
use Exception;
use Framework\Config;
use Libs\Smarty\SmartyWrapper;
use Framework\Database;
use Framework\JWT;
use Framework\Request;
use stdClass;

class AgentsController
{

  /**
   * 
   * GETTERS AND SETTERS
   * 
   */


  /**
   * List all agents
   * @return mixed
   */
  public function getOne(int $id, bool $api = false, string $login = null): bool|stdClass|array
  {
    if (!$this->isUserSuperAdmin()) {
      return false;
    }
    
    if ($id === 0 && isset($login)) {
      // Fetch data via login
      $data = Database::getInstance()->prepare('SELECT * FROM Agent WHERE login = ?;', [$login]);
    } else {
      // Fetch data via id
      $data = Database::getInstance()->prepare('SELECT * FROM Agent WHERE idAgent = ?;', [$id]);
    }

    // Convert objects to arrays because Database return OBJECTS array.
    if (is_array($data)) {
      $arrayData = $data[0];
    } else {
      $arrayData = [];
    }

    // Return the raw array if controller has been called by api
    if ($api) {
      return $arrayData;
    }

    $smarty = SmartyWrapper::getSmarty();
    $smarty->assign('agents', $arrayData);
    $smarty->display('agents.tpl');
    return true;
  }

  public function getAll(bool $api = false): array|bool
  {
    // Fetch data
    $data = Database::getInstance()->prepare('SELECT * FROM Agent WHERE login != "admin";');

    // Convert objects to arrays because Database return OBJECTS array.
    if (is_array($data)) {
      $arrayData = array_map(function ($obj) {
        if (isset($obj->pwd)) {
          unset($obj->pwd);
        }
        return (array)$obj;
      }, $data);
    } else {
      $arrayData = [];
    }

    // Return the raw array if controller has been called by api
    if ($api) {
      if ($this->isUserSuperAdmin()) {
        return $arrayData;
      } else {
        return false;
      }
    }

    if (!$this->isUserSuperAdmin()) {
      header('Location: /app');
    }

    $smarty = SmartyWrapper::getSmarty();
    $smarty->assign('agents', $arrayData);
    $smarty->display('agents.tpl');
    return true;
  }

  /**
   * Add one agent
   * @return void
   */
  public function addOne($inputs): bool
  {
    if (!$this->isUserSuperAdmin()) {
      return false;
    }

    $hasher = new Hasher();
    $randomPassword = $this->generatePassword(12);
    $passwordHash = $hasher->hash($randomPassword);

    // Insert new agents
    $result = Database::getInstance()->prepare('INSERT INTO Agent (nom, prenom, tel, login, pwd, role) VALUES (?, ?, ?, ?, ?, ?)', [$inputs->nom, $inputs->prenom, $inputs->tel, $inputs->login, $passwordHash, $inputs->role]);

    if (is_array($result)) {

      try {
        $mailer = new Mail();

        $mailer->sendEmail(
          $inputs->login, // Destinataire
          'Inscription au BSA', // Sujet
          "Votre mot de passe BSA : $randomPassword", // Corps du mail
          true, // Format HTML
        );
      } catch (Exception $e) {
        echo "Erreur: " . $e->getMessage();
      }

      return true;
    }

    return false;
  }

  /**
   * Update one agent
   * @return void
   */
  public function updateOne($inputs): bool
  {
    if (!$this->isUserSuperAdmin()) {
      return false;
    }

    // Update agent
    $result = Database::getInstance()->prepare('UPDATE Agent SET nom = ?, prenom = ?, tel = ?, login = ?, role = ? WHERE idAgent = ?', [$inputs->nom, $inputs->prenom, $inputs->tel, $inputs->login, $inputs->role, $inputs->idAgent]);

    if (is_array($result)) {
      return true;
    }

    return false;
  }

  /**
   * Delete one agent
   * @return void
   */
  public function deleteOne($input): bool
  {
    if (!$this->isUserSuperAdmin()) {
      return false;
    }

    // Delete agent
    $result = Database::getInstance()->prepare('DELETE FROM Agent WHERE idAgent = ?', [$input]);

    if (is_array($result)) {
      return true;
    }

    return false;
  }

  /**
   * 
   *  UTILITY METHODS
   * 
   */

  /**
   * Generate random password of chosen length
   * @return string
   */
  function generatePassword($length = 12): string
  {
    // Définir les caractères possibles pour le mot de passe
    $characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*()-_=+';

    // Mélanger les caractères et choisir une longueur spécifique
    $password = '';
    for ($i = 0; $i < $length; $i++) {
      $password .= $characters[rand(0, strlen($characters) - 1)];
    }

    return $password;
  }

  /**
   * 
   */
  function isUserSuperAdmin(): bool
  {
    $request = new Request();

    $jwt = $request->cookie(['bsa_cookie:s*']);

    $decodedJwt = JWT::getInstance()->decode($jwt);

    $superadmin = Config::getInstance()->getConfig('superadmin_login');

    return ($decodedJwt->login === $superadmin);
  }
}
