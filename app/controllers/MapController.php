<?php

namespace Controllers;

use Libs\Smarty\SmartyWrapper;
use Framework\Database;

class MapController
{
  /**
   * Handle the main home page
   * @return void
   */
  public function getMap(): void
  {
    // Fetch active towns from database
    $data = Database::getInstance()->prepare('SELECT * FROM Zone WHERE type = "commune" AND active = 1 ORDER BY lib;');

    // Convert objects to arrays because Database return OBJECTS array.
    if (is_array($data)) {
      $arrayData = array_map(function ($obj) {
        return (array)$obj;
      }, $data);
    } else {
      $arrayData = null;
    }

    $smarty = SmartyWrapper::getSmarty();
    $smarty->assign('towns', $arrayData);
    $smarty->display('map.tpl');
  }
}