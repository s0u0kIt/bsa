<?php

namespace Controllers;

use Libs\Smarty\SmartyWrapper;
use Framework\Database;
use stdClass;

class ZonesController
{

  /**
   * 
   * GETTERS AND SETTERS
   * 
   */


  /**
   * List all zones
   * @return void
   */
  public function getOne(int $id, bool $api = false, string $login = null): bool|stdClass|array
  {
    // Fetch data via id
    $data = Database::getInstance()->prepare('SELECT * FROM Zone WHERE idZone = ?;', [$id]);

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

    return true;
  }

  /**
   * Get all zones and their info
   */
  public function getAll(bool $api = false): array|bool
  {
    // Fetch all zones
    $data = Database::getInstance()->prepare('SELECT * FROM Zone;');

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

    // Returns to API
    if ($api) {
      return $arrayData;
    }

    // Build hierarchy for templating
    $organizedData = $this->buildHierarchy($arrayData);

    $smarty = SmartyWrapper::getSmarty();
    $smarty->assign('zones', $organizedData);
    $smarty->display('zones.tpl');
    return true;
  }

  /**
   * Get all zones and their info
   */
  public function getAllActive(bool $api = false): array|bool
  {
    // Step 1: Fetch all active zones
    $zones = Database::getInstance()->prepare('SELECT * FROM Zone WHERE active = 1');

    // Step 2: Fetch direct counts for each zone
    $directCounts = Database::getInstance()->prepare('
      SELECT idZone, qtt AS last_qtt, date AS dernier_date
      FROM (
          SELECT 
              idZone, 
              qtt, 
              date,
              ROW_NUMBER() OVER (PARTITION BY idZone ORDER BY date DESC) AS rn
          FROM Comptage
      ) AS subquery
      WHERE rn = 1;
    ');

    // Step 3: Build an associative array for direct counts
    $directCountsMap = [];
    if (is_array($directCounts)) { // Check if $directCounts is an array
      foreach ($directCounts as $count) {
        $directCountsMap[$count->idZone] = $count->last_qtt;
      }
    }

    // Step 4: Build an associative array for the zone hierarchy
    $zonesMap = [];
    foreach ($zones as $zone) {
      $zonesMap[$zone->idZone] = (array)$zone;
    }

    // Step 5: Recursive function to calculate the final count
    $calculateFinalCount = function ($idZone, &$zonesMap, &$directCountsMap) use (&$calculateFinalCount) {
      $zone = $zonesMap[$idZone];

      // If the zone has active children, sum their counts
      $lastCount = 0;
      foreach ($zonesMap as $childZone) {
        if ($childZone['idParent'] == $idZone && $childZone['active'] == 1) {
          $lastCount += $calculateFinalCount($childZone['idZone'], $zonesMap, $directCountsMap);
        }
      }

      // If the zone has no active children, use its direct count
      if ($lastCount == 0 && isset($directCountsMap[$idZone])) {
        $lastCount = $directCountsMap[$idZone];
      }

      return $lastCount;
    };

    // Step 6: Calculate the final count for each active zone
    $results = [];
    foreach ($zones as $zone) {
      $lastCount = $calculateFinalCount($zone->idZone, $zonesMap, $directCountsMap);
      $results[] = [
        'idZone' => $zone->idZone,
        'type' => $zone->type,
        'lib' => $zone->lib,
        'lat_1' => $zone->lat_1,
        'long_1' => $zone->long_1,
        'lat_2' => $zone->lat_2,
        'long_2' => $zone->long_2,
        'lat_center' => $zone->lat_centre,
        'long_center' => $zone->long_centre,
        'active' => $zone->active,
        'idParent' => $zone->idParent,
        'dernier_comptage' => round($lastCount),
      ];
    }

    // Step 7: Return the results
    if ($api) {
      return $results;
    }

    return true;
  }

  /**
   * Add one zone
   * @return void
   */
  public function addOne($inputs): bool
  {

    // Insert new zones
    $result = Database::getInstance()->prepare('INSERT INTO Zone (type, lib, lat_1, long_1, lat_2, long_2, idParent) VALUES (?, ?, ?, ?, ?, ?, ?)', [$inputs->type, $inputs->lib, $inputs->lat_1, $inputs->long_1, $inputs->lat_2, $inputs->long_2, $inputs->idParent ?? null]);

    if (is_array($result)) {
      return true;
    }

    return false;
  }

  /**
   * Erase one zone
   * @return void
   */
  public function deleteOne($input): bool
  {
    // Delete zone
    $result = Database::getInstance()->prepare('DELETE FROM Zone WHERE idZone = ?', [$input]);

    if (is_array($result)) {
      return true;
    }

    return false;
  }

  /**
   * Erase one zone
   * @return void
   */
  public function toggleOne($inputs): bool
  {
    // Delete zone
    $result = Database::getInstance()->prepare('UPDATE Zone SET active = ? WHERE idZone = ?', [$inputs->active, $inputs->idZone]);

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

  function buildHierarchy(array $zones): array
  {
    $tree = [];
    $references = [];

    // Première passe : créer une référence pour chaque zone
    foreach ($zones as $zone) {
      $zone['children'] = []; // Ajoute un tableau pour stocker les enfants
      $references[$zone['idZone']] = $zone;
    }

    // Deuxième passe : attribuer chaque zone à son parent ou à la racine
    foreach ($zones as $zone) {
      if ($zone['idParent'] === NULL) {
        $tree[] = &$references[$zone['idZone']];
      } else {
        $references[$zone['idParent']]['children'][] = &$references[$zone['idZone']];
      }
    }

    return $tree;
  }
}
