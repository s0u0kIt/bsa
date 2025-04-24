<?php

namespace Controllers;

use Libs\Smarty\SmartyWrapper;
use Framework\Database;
use stdClass;

class CaseController
{
  /**
   * 
   * GETTERS AND SETTERS
   * 
   */


  /**
   * List one case
   * @return void
   */

  public function getOne(int $id, bool $api = false, string $mail = null): bool|stdClass|array
  {
    if ($id === 0 && isset($mail)) {
      // Fetch data via mail
      $data = Database::getInstance()->prepare('SELECT * FROM Personne WHERE email = ?;', [$mail]);
    } else {
      // Fetch data via id
      $data = Database::getInstance()->prepare('SELECT * FROM Personne WHERE idPersonne = ?;', [$id]);
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
    $smarty->assign('case', $arrayData);
    $smarty->display('case.tpl');
    return true;
  }

  public function getAll(bool $api = false): mixed
  {
    // Fetch data
    $data = Database::getInstance()->prepare('SELECT * FROM Personne;');
    $archipelagos = Database::getInstance()->prepare('SELECT * FROM Zone WHERE type = "archipel" ORDER BY lib ASC;');
    $isles = Database::getInstance()->prepare('SELECT * FROM Zone WHERE type = "ile" ORDER BY lib ASC;');
    $tutors = Database::getInstance()->prepare('SELECT * FROM Tuteur ORDER BY nom ASC;');

    // Convert objects to arrays
    if (is_array($data)) {
      $arrayData = array_map(function ($obj) {
        return (array)$obj;
      }, $data);
    } else {
      $arrayData = null;
    }

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

    // Return the raw array if controller has been called by api
    if ($api) {
      return $arrayData;
    }

    $smarty = SmartyWrapper::getSmarty();
    $smarty->assign('cases', $arrayData);
    $smarty->assign('archipelagos', $arrayArchipelagos);
    $smarty->assign('isles', $arrayIsles);
    $smarty->assign('tutors', $arrayTutors);
    $smarty->display('case.tpl');
    return true;
  }

  /**
   * Add one case
   * @return void
   */
  public function addOne($inputs): bool
  {
    //Si lors d'un nouveau dossier, aucune entrée dans les cases ci-dessous, alors :
    if ($inputs->dataBorn == '') {
      $inputs->dataBorn = null;
    }
    if ($inputs->dataResidence == '') {
      $inputs->dataResidence = 'Autre';
    }
    if ($inputs->dataGenre == '') {
      $inputs->dataGenre = 'Autre';
    }
    if ($inputs->dataAct == '') {
      $inputs->dataAct = null;
    }
    if ($inputs->dataPhone == '') {
      $inputs->dataPhone = 'Aucun Numéro';
    }
    if ($inputs->dataTypo == '') {
      $inputs->dataTypo = 'Autre';
    }
    if ($inputs->dataChild == '') {
      $inputs->dataChild = '0';
    }

    $date = date('Y-m-d H:i:s');
    // Insert new case
    $insertResult = Database::getInstance()->prepare('INSERT INTO Personne (residence, nom, prenom, dateNaiss, dn, genre, activite, tel, email, typologie, nbEnfant, dateCreation, idTuteur, idIle) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)', [$inputs->dataResidence, $inputs->dataLastName, $inputs->dataFirstName, $inputs->dataBorn, $inputs->dataDn, $inputs->dataGenre, $inputs->dataAct, $inputs->dataPhone, $inputs->dataEmail, $inputs->dataTypo, $inputs->dataChild, $date, $inputs->dataIdTuteur, $inputs->dataIdIle]);

    if (is_array($insertResult)) {
      return true;
    }

    return false;
  }

  /**
   * Modify one case
   * @return void
   */
  public function updateOne($inputs): bool
  {
    //Si lors d'un nouveau dossier, aucune entrée dans les cases ci-dessous, alors :
    if ($inputs->dataBorn == '') {
      $inputs->dataBorn = null;
    }
    if ($inputs->dataResidence == '') {
      $inputs->dataResidence = 'Autre';
    }
    if ($inputs->dataGenre == '') {
      $inputs->dataGenre = 'Autre';
    }
    if ($inputs->dataAct == '') {
      $inputs->dataAct = null;
    }
    if ($inputs->dataPhone == '') {
      $inputs->dataPhone = 'Aucun Numéro';
    }
    if ($inputs->dataTypo == '') {
      $inputs->dataTypo = 'Autre';
    }
    if ($inputs->dataChild == '') {
      $inputs->dataChild = '0';
    }

    // Update new case
    $result = Database::getInstance()->prepare('UPDATE Personne SET residence = ?, nom = ?, prenom = ? , dateNaiss = ?, dn = ?, genre = ?, activite = ?, tel = ?, email = ?, typologie = ?, nbEnfant = ?, idTuteur = ?, idIle = ? WHERE idPersonne = ?', [$inputs->dataResidence ?? "Autre", $inputs->dataLastName, $inputs->dataFirstName, $inputs->dataBorn, $inputs->dataDn, $inputs->dataGenre, $inputs->dataAct, $inputs->dataPhone, $inputs->dataEmail, $inputs->dataTypo, $inputs->dataChild, $inputs->dataIdTuteur, $inputs->dataIdIle, $inputs->idPersonne]);

    if (is_array($result)) {
      return true;
    }

    return false;
  }

  /**
   * Delete one case
   * @return void
   */
  public function deleteOne($input): bool
  {
    // Delete case
    $result = Database::getInstance()->prepare('DELETE FROM Personne WHERE idPersonne = ?', [$input]);

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
