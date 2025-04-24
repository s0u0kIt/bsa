<?php

namespace Controllers;

use Framework\Config;
use Libs\Smarty\SmartyWrapper;
use Framework\Database;
use Framework\JWT;
use Framework\Request;

class MobileController
{
  /**
   * Handle the main home page
   * @return void
   */
  public function app(): void
  {
    $smarty = SmartyWrapper::getSmarty();
    $smarty->display('mobile-app.tpl');
  }

  /**
   * Display all cases
   * @return void
   */
  public function displayAllCases(bool $api = false): mixed
  {
    // Fetch data
    $data = Database::getInstance()->prepare('SELECT * FROM Personne;');

    // Convert objects to arrays
    if (is_array($data)) {
      $arrayData = array_map(function ($obj) {
        return (array)$obj;
      }, $data);
    } else {
      $arrayData = null;
    }

    // Return the raw array if controller has been called by api
    if ($api) {
      return $arrayData;
    }

    $smarty = SmartyWrapper::getSmarty();
    $smarty->assign('cases', $arrayData);
    $smarty->display('mobile-case.tpl');
    return true;
  }

  /**
   * Display all cases
   * @return void
   */
  public function displayOneCase(bool $api = false): mixed
  {
    $request = new Request();
    $id = $request->get(['id:i*']);

    // Fetch data
    $data = Database::getInstance()->prepare('SELECT * FROM Personne WHERE idPersonne = ?;', [$id]);

    // Convert objects to arrays
    if (is_array($data)) {
      $arrayData = array_map(function ($obj) {
        return (array)$obj;
      }, $data);
    } else {
      $arrayData = null;
    }

    // Return the raw array if controller has been called by api
    if ($api) {
      return $arrayData;
    }

    $smarty = SmartyWrapper::getSmarty();
    if (isset($arrayData[0])) {
      $smarty->assign('case', $arrayData[0]);
    }

    $smarty->display('mobile-case-one.tpl');
    return true;
  }

  /**
   * Display case form
   * @return void
   */
  public function getCaseForm(): void
  {
    $archipelagos = Database::getInstance()->prepare('SELECT * FROM Zone WHERE type = "archipel" ORDER BY lib ASC;');
    $isles = Database::getInstance()->prepare('SELECT * FROM Zone WHERE type = "ile" ORDER BY lib ASC;');
    $tutors = Database::getInstance()->prepare('SELECT * FROM Tuteur ORDER BY nom ASC;');

    // Convert objects to arrays
    if (is_array($archipelagos)) {
      $arrayArchipelagos = array_map(function ($obj) {
        return (array)$obj;
      }, $archipelagos);
    } else {
      $arrayArchipelagos = null;
    }
    
    // Convert objects to arrays
    if (is_array($isles)) {
      $arrayIsles = array_map(function ($obj) {
        return (array)$obj;
      }, $isles);
    } else {
      $arrayIsles = null;
    }

    // Convert objects to arrays
    if (is_array($tutors)) {
      $arrayTutors = array_map(function ($obj) {
        return (array)$obj;
      }, $tutors);
    } else {
      $arrayTutors = null;
    }

    $smarty = SmartyWrapper::getSmarty();
    $smarty->assign('isles', $arrayIsles);
    $smarty->assign('archipelagos', $arrayArchipelagos);
    $smarty->assign('tutors', $arrayTutors);
    $smarty->display('mobile-case-add.tpl');
  }

  /**
   * Display counting zone
   * @return void
   */
  public function getCountForm(): void
  {

    $zones = Database::getInstance()->prepare('SELECT * FROM Zone WHERE active = 1 ORDER BY lib ASC;');

    // Convert objects to arrays
    if (is_array($zones)) {
      $arrayIsles = array_map(function ($obj) {
        return (array)$obj;
      }, $zones);
    } else {
      $arrayIsles = null;
    }

    $smarty = SmartyWrapper::getSmarty();
    $smarty->assign('zones', $arrayIsles);
    $smarty->display('mobile-count-form.tpl');
  }

  public function displayAllReports(bool $api = false): mixed
  {
    // Get idAgent from cookie
    $request = new Request();
    $cookie = $request->cookie([Config::getInstance()->getConfig('jwt_cookie_name') . ':s*']);
    $decodedCookie = JWT::getInstance()->decode($cookie);
    $idAgent = $decodedCookie->idAgent;

    // Get date
    $date = date('Y-m-d');

    // Fetch data
    $reports = Database::getInstance()->prepare('SELECT idPersonne, commentaire, DATE(date) AS date FROM Releve WHERE idAgent = ? AND DATE(date) = DATE(?) ORDER BY date DESC;', [$idAgent, $date]);

    // Convert objects to arrays
    if (is_array($reports)) {
      $arrayReports = array_map(function ($obj) {

        $case = Database::getInstance()->prepare('SELECT nom, prenom FROM Personne WHERE idPersonne = ?;', [$obj->idPersonne]);
        $obj->personne = $case[0]->nom . ' ' . $case[0]->prenom;
        return (array)$obj;
      }, $reports);
    } else {
      $arrayReports = null;
    }

    // Return the raw array if controller has been called by api
    if ($api) {
      return $arrayReports;
    }

    $smarty = SmartyWrapper::getSmarty();
    $smarty->assign('reports', $arrayReports);
    $smarty->display('mobile-report.tpl');
    return true;
  }
}
