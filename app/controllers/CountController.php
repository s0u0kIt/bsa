<?php

namespace Controllers;

use Libs\Smarty\SmartyWrapper;
use Framework\Database;
use stdClass;

class CountController
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
  
   public function getAll(bool $api = false): mixed
  {
    // Fetch data
    $data = Database::getInstance()->prepare('SELECT * FROM Releve;');
    $isles = Database::getInstance()->prepare('SELECT * FROM Ile ORDER BY lib ASC;');

    // Convert objects to arrays
    if (is_array($data)) {
      $arrayData = array_map(function ($obj) {
        return (array)$obj;
      }, $data);
    } else {
      $arrayData = null;
    }

    // Convert objects to arrays
    if (is_array($isles)) {
      $arrayIsles = array_map(function ($obj) {
        return (array)$obj;
      }, $isles);
    } else {
      $arrayIsles = null;
    }

    // Return the raw array if controller has been called by api
    if ($api) {
      return $arrayData;
    }

    $smarty = SmartyWrapper::getSmarty();
    $smarty->assign('reports', $arrayData);
    $smarty->assign('isles', $arrayIsles);
    $smarty->display('report.tpl');
    return true;
  }

  /**
   * Add one count
   * @return void
   */
  public function addOne($inputs): bool
  {
    $date = date('Y-m-d H:i:s');
    // Insert new report
    $result = Database::getInstance()->prepare('INSERT INTO Comptage (qtt, date, idAgent, idZone) VALUES (?, ?, ?, ?)', [$inputs->count, $date, $inputs->idAgent, $inputs->idZone]);

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

}
