<?php

namespace Controllers;

use Libs\Smarty\SmartyWrapper;
use Framework\Database;

class StatsController
{
  /**
   * Handle the main home page
   * @return void
   */
  public function getStats(): void
  {
    $smarty = SmartyWrapper::getSmarty();
    $smarty->display('stats.tpl');
  }

  /**
   * Get gender distribution
   * @return mixed
   */
  public function getGenderDistribution($api = false): mixed
  {
    $data = Database::getInstance()->prepare('SELECT genre, count(*) AS "quantite" FROM `Personne` GROUP BY genre;');

    if ($api) {
      return $data;
    }
  }

  /**
   * Get gender distribution
   * @return mixed
   */
  public function getSixMonthsProgression($api = false): mixed
  {
    $data = Database::getInstance()->prepare("
    SELECT mois, nombre
    FROM (
        SELECT 
            DATE_FORMAT(mois, '%b %Y') AS mois, 
            (SELECT COUNT(*) FROM Personne p2 WHERE p2.dateCreation <= p1.mois) AS nombre
        FROM (
            SELECT DISTINCT LAST_DAY(dateCreation) AS mois FROM Personne
            UNION 
            SELECT LAST_DAY(CURDATE())
        ) p1
        ORDER BY p1.mois DESC
        LIMIT 6
    ) sub
    ORDER BY STR_TO_DATE(sub.mois, '%b %Y');");

    if ($api) {
      return $data;
    }
  }

  /**
   * Get typology distribution
   * @return mixed
   */
  public function getTypologyDistribution($api = false): mixed
  {
    $data = Database::getInstance()->prepare('SELECT typologie, count(*) AS "quantite" FROM `Personne` GROUP BY typologie;');

    if ($api) {
      return $data;
    }
  }

  /**
   * Get population distribution
   * @return mixed
   */
  public function getPopulationDistribution($api = false): mixed
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
}
