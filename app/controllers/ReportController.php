<?php

namespace Controllers;

use Libs\Smarty\SmartyWrapper;
use Framework\Database;
use stdClass;

class ReportController
{
  /**
   * 
   * GETTERS AND SETTERS
   * 
   */


  /**
   * List all reports
   * @return void
   */

  public function getOne(int $id, bool $api = false, string $mail = null): bool|stdClass|array
  {
    if ($id === 0 && isset($mail)) {
      // Fetch data via mail
      $data = Database::getInstance()->prepare('SELECT * FROM Releve WHERE email = ?;', [$mail]);
    } else {
      // Fetch data via id
      $data = Database::getInstance()->prepare('SELECT * FROM Releve WHERE idReleve = ?;', [$id]);
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
    $smarty->assign('report', $arrayData);
    $smarty->display('report.tpl');
    return true;
  }

  public function getAll(bool $api = false, int $idPersonne = null): mixed
  {
    // Fetch data

    if (null != $idPersonne) {
      $data = Database::getInstance()->prepare('SELECT * FROM Releve WHERE idPersonne = ? ORDER BY date DESC;', [$idPersonne]);
    } else {
      $data = Database::getInstance()->prepare('SELECT * FROM Releve ORDER BY idReleve DESC;');
    }

    $agents = Database::getInstance()->prepare('SELECT * FROM Agent;');

    // Convert objects to arrays
    if (is_array($data)) {
      $arrayData = array_map(function ($obj) use ($agents) {
        $agent = $this->findAgentById($agents, $obj->idAgent);
        $obj->agentLastName = $agent->nom;
        $obj->agentFirstName = $agent->prenom;
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
    $smarty->assign('reports', $arrayData);
    $smarty->display('report.tpl');
    return true;
  }

  /**
   * Add one report
   * @return void
   */
  public function addOne($inputs): bool
  {
    $date = date('Y-m-d H:i:s');
    // Insert new report
    $result = Database::getInstance()->prepare('INSERT INTO Releve (commentaire, date, idAgent, idPersonne) VALUES (?, ?, ?, ?)', [$inputs->dataReport, $date, $inputs->idAgent, $inputs->dataId]);

    if (is_array($result)) {
      return true;
    }

    return false;
  }

  /**
   * Delete one report
   * @return void
   */
  public function deleteOne($input): bool
  {
    // Delete report
    $result = Database::getInstance()->prepare('DELETE FROM Releve WHERE idReleve = ?', [$input]);

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
   * Find an agent in array with an id
   */
  function findAgentById($agents, $idAgent)
  {
    foreach ($agents as $agent) {
      if ($agent->idAgent === $idAgent) {
        return $agent;
      }
    }
    return null; // Retourne null si aucun agent n'est trouvé
  }
}
