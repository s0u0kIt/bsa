<?php

namespace Controllers;

use Exception;
use Framework\JWT;
use Framework\Config;
use Framework\Request;
use Controllers\CaseController;
use Controllers\ZonesController;
use Controllers\AgentsController;
use Controllers\ReportController;

class ApiController
{
  /**
   * -----------------
   * AGENTS MANAGEMENT
   * -----------------
   */


  /**
   * Get all agents
   * @return void
   */
  public function getAllAgent(): void
  {
    header('Content-Type: application/json');

    $request = new Request();
    if ($this->isContentJson()) {
      try {
        // Use the controller to get data
        $agentsController = new AgentsController();
        $data = $agentsController->getAll(true);

        if (!empty($data)) {
          http_response_code(200); // OK
          echo json_encode([
            "success" => true,
            "message" => "Data retrieved successfully",
            "data" => $data
          ]);
        } else {
          http_response_code(404); // Not Found
          echo json_encode([
            "success" => false,
            "message" => "No data found",
            "data" => []
          ]);
        }
      } catch (Exception $e) {
        http_response_code(500); // Internal Server Error
        echo json_encode([
          "success" => false,
          "message" => "An error occurred: " . $e->getMessage(),
          "data" => []
        ]);
      }
    }
  }


  /**
   * Generate random password of chosen length
   * @return string
   */
  function getOneAgent(): void {}

  /**
   * Add one agent
   * @return void
   */
  public function addOneAgent(): void
  {
    header('Content-Type: application/json');

    $request = new Request();

    if ($this->isContentJson()) {
      $inputs = $request->json(['nom:s*', 'prenom:s*', 'tel:s*', 'login:e*', 'role:s']);

      try {
        // Use the controller to get data
        $agentsController = new AgentsController();

        if ($agentsController->addOne($inputs)) {
          http_response_code(200); // OK
          echo json_encode([
            "success" => true,
            "message" => "Agent successfully added"
          ]);
        } else {
          http_response_code(404); // Not Found
          echo json_encode([
            "success" => false,
            "message" => "Couldn't add agent, verify inputs"
          ]);
        }
      } catch (Exception $e) {
        http_response_code(500); // Internal Server Error
        echo json_encode([
          "success" => false,
          "message" => "An error occurred: " . $e->getMessage()
        ]);
      }
    }
  }

  /**
   * Update one agent
   * @return void
   */
  public function updateOneAgent(): void
  {
    header('Content-Type: application/json');

    $request = new Request();

    if ($this->isContentJson()) {
      $input = $request->json(['idAgent:i*', 'nom:s*', 'prenom:s*', 'tel:s*', 'login:e*', 'role:s']);

      try {
        // Use the controller to get data
        $agentsController = new AgentsController();

        if ($agentsController->updateOne($input)) {
          http_response_code(200); // OK
          echo json_encode([
            "success" => true,
            "message" => "Agent successfully updated"
          ]);
        } else {
          http_response_code(404); // Not Found
          echo json_encode([
            "success" => false,
            "message" => "Couldn't update agent"
          ]);
        }
      } catch (Exception $e) {
        http_response_code(500); // Internal Server Error
        echo json_encode([
          "success" => false,
          "message" => "An error occurred: " . $e->getMessage()
        ]);
      }
    }
  }

  /**
   * Delete one agent
   * @return void
   */
  public function deleteOneAgent(): void
  {
    header('Content-Type: application/json');

    $request = new Request();

    if ($this->isContentJson()) {
      $input = $request->json(['idAgent:i*']);

      try {
        // Use the controller to get data
        $agentsController = new AgentsController();

        if ($agentsController->deleteOne($input)) {
          http_response_code(200); // OK
          echo json_encode([
            "success" => true,
            "message" => "Agent successfully deleted"
          ]);
        } else {
          http_response_code(404); // Not Found
          echo json_encode([
            "success" => false,
            "message" => "Couldn't delete agent"
          ]);
        }
      } catch (Exception $e) {
        http_response_code(500); // Internal Server Error
        echo json_encode([
          "success" => false,
          "message" => "An error occurred: " . $e->getMessage()
        ]);
      }
    }
  }

  /**
   * -----------------
   * CASES MANAGEMENT
   * -----------------
   */

  /**
   * Lists all cases
   * @return void
   */
  public function getAllCase(): void
  {
    header('Content-Type: application/json');

    $request = new Request();
    if ($this->isContentJson()) {
      try {
        // Use the controller to get data
        $casesController = new CaseController();
        $data = $casesController->getAll(true);

        if (!empty($data)) {
          http_response_code(200); // OK
          echo json_encode([
            "success" => true,
            "message" => "Cases successfully added!",
            "data" => $data
          ]);
        } else {
          http_response_code(404); // Not Found
          echo json_encode([
            "success" => false,
            "message" => "Couldn't add case",
            "data" => []
          ]);
        }
      } catch (Exception $e) {
        http_response_code(500); // Internal Server Error
        echo json_encode([
          "success" => false,
          "message" => "An error occurred: " . $e->getMessage(),
          "data" => []
        ]);
      }
    }
  }

  /**
   * Add one case
   * @return void
   */
  public function addOneCase(): void
  {
    header('Content-Type: application/json');

    $request = new Request();

    if ($this->isContentJson()) {

      try {
        $inputs = $request->json([
          'dataResidence:s',
          'dataLastName:s*',
          'dataFirstName:s*',
          'dataBorn:d',
          'dataDn:i',
          'dataGenre:s',
          'dataAct:s',
          'dataPhone:s',
          'dataEmail:e',
          'dataTypo:s',
          'dataChild:i',
          'dataIdTuteur:i',
          'dataIdIle:i*'
        ]);

        // Use the controller to get data
        $caseController = new CaseController();

        if ($caseController->addOne($inputs)) {
          http_response_code(200); // OK
          echo json_encode([
            "success" => true,
            "message" => "Case successfully added"
          ]);
        } else {
          http_response_code(404); // Not Found
          echo json_encode([
            "success" => false,
            "message" => "Couldn't add case, verify inputs"
          ]);
        }
      } catch (Exception $e) {
        http_response_code(500); // Internal Server Error
        echo json_encode([
          "success" => false,
          "message" => "An error occurred: " . $e->getMessage()
        ]);
      }
    }
  }

  /**
   * Modify one case
   * @return void
   */
  public function updateOneCase(): void
  {
    header('Content-Type: application/json');

    $request = new Request();

    if ($this->isContentJson()) {
      $inputs = $request->json([
        'idPersonne:i*',
        'dataResidence:s',
        'dataLastName:s*',
        'dataFirstName:s*',
        'dataBorn:d',
        'dataDn:i',
        'dataGenre:s',
        'dataAct:s',
        'dataPhone:s',
        'dataEmail:e',
        'dataTypo:s',
        'dataChild:i',
        'dataIdTuteur:i',
        'dataIdIle:i*'
      ]);

      try {
        // Use the controller to get data
        $caseController = new CaseController();

        if ($caseController->updateOne($inputs)) {
          http_response_code(200); // OK
          echo json_encode([
            "success" => true,
            "message" => "Case successfully modified"
          ]);
        } else {
          http_response_code(404); // Not Found
          echo json_encode([
            "success" => false,
            "message" => "Couldn't modify case, verify inputs"
          ]);
        }
      } catch (Exception $e) {
        http_response_code(500); // Internal Server Error
        echo json_encode([
          "success" => false,
          "message" => "An error occurred: " . $e->getMessage()
        ]);
      }
    }
  }

  /**
   * Delete one case
   * @return void
   */
  public function deleteOneCase(): void
  {
    header('Content-Type: application/json');

    $request = new Request();

    if ($this->isContentJson()) {
      $inputs = $request->json(['id:i*']);

      try {
        // Use the controller to get data
        $caseController = new CaseController();

        if ($caseController->deleteOne($inputs)) {
          http_response_code(200); // OK
          echo json_encode([
            "success" => true,
            "message" => "Case successfully deleted"
          ]);
        } else {
          http_response_code(404); // Not Found
          echo json_encode([
            "success" => false,
            "message" => "Couldn't delete case"
          ]);
        }
      } catch (Exception $e) {
        http_response_code(500); // Internal Server Error
        echo json_encode([
          "success" => false,
          "message" => "An error occurred: " . $e->getMessage()
        ]);
      }
    }
  }




  /**
   * -----------------
   * ZONES MANAGEMENT
   * -----------------
   */


  /**
   * Lists all zones
   * @return void
   */
  public function getAllZone(): void
  {
    header('Content-Type: application/json');

    $request = new Request();
    if ($this->isContentJson()) {
      try {
        // Use the controller to get data
        $zonesController = new ZonesController();
        $data = $zonesController->getAll(true);

        if (!empty($data)) {
          http_response_code(200); // OK
          echo json_encode([
            "success" => true,
            "message" => "Data retrieved successfully",
            "data" => $data
          ]);
        } else {
          http_response_code(404); // Not Found
          echo json_encode([
            "success" => false,
            "message" => "No data found",
            "data" => []
          ]);
        }
      } catch (Exception $e) {
        http_response_code(500); // Internal Server Error
        echo json_encode([
          "success" => false,
          "message" => "An error occurred: " . $e->getMessage(),
          "data" => []
        ]);
      }
    }
  }

  /**
   * Lists all active zones
   * @return void
   */
  public function getAllActiveZone(): void
  {
    header('Content-Type: application/json');

    $request = new Request();
    if ($this->isContentJson()) {
      try {
        // Use the controller to get data
        $zonesController = new ZonesController();
        $data = $zonesController->getAllActive(true);

        if (!empty($data)) {
          http_response_code(200); // OK
          echo json_encode([
            "success" => true,
            "message" => "Data retrieved successfully",
            "data" => $data
          ]);
        } else {
          http_response_code(404); // Not Found
          echo json_encode([
            "success" => false,
            "message" => "No data found",
            "data" => []
          ]);
        }
      } catch (Exception $e) {
        http_response_code(500); // Internal Server Error
        echo json_encode([
          "success" => false,
          "message" => "An error occurred: " . $e->getMessage(),
          "data" => []
        ]);
      }
    }
  }

  /**
   * Generate a zone in back ?
   * @return string
   */
  function getOneZone(): void {}

  /**
   * Add one zone
   * @return void
   */
  public function addOneZone(): void
  {
    header('Content-Type: application/json');

    $request = new Request();

    if ($this->isContentJson()) {
      $inputs = $request->json(['type:s*', 'lib:s*', 'lat_1:f*', 'long_1:f*', 'lat_2:f*', 'long_2:f*', 'idParent:i']);

      try {
        // Use the controller to get data
        $zonesController = new ZonesController();

        if ($zonesController->addOne($inputs)) {
          http_response_code(200); // OK
          echo json_encode([
            "success" => true,
            "message" => "Zone successfully added"
          ]);
        } else {
          http_response_code(404); // Not Found
          echo json_encode([
            "success" => false,
            "message" => "Couldn't add zone, verify inputs"
          ]);
        }
      } catch (Exception $e) {
        http_response_code(500); // Internal Server Error
        echo json_encode([
          "success" => false,
          "message" => "An error occurred: " . $e->getMessage()
        ]);
      }
    }
  }

  /**
   * Delete one zone
   * @return void
   */
  public function deleteOneZone(): void
  {
    header('Content-Type: application/json');

    $request = new Request();

    if ($this->isContentJson()) {
      $id = $request->json(['idZone:i*']);

      try {
        // Use the controller to get data
        $zonesController = new ZonesController();

        if ($zonesController->deleteOne($id)) {
          http_response_code(200); // OK
          echo json_encode([
            "success" => true,
            "message" => "Zone successfully deleted"
          ]);
        } else {
          http_response_code(404); // Not Found
          echo json_encode([
            "success" => false,
            "message" => "Couldn't delete zone"
          ]);
        }
      } catch (Exception $e) {
        http_response_code(500); // Internal Server Error
        echo json_encode([
          "success" => false,
          "message" => "An error occurred: " . $e->getMessage()
        ]);
      }
    }
  }

  /**
   * Toggle one zone
   * @return void
   */
  public function toggleOneZone(): void
  {
    header('Content-Type: application/json');

    $request = new Request();

    if ($this->isContentJson()) {
      $inputs = $request->json(['idZone:i*', 'active:i*']);

      try {
        // Use the controller to get data
        $zonesController = new ZonesController();

        if ($zonesController->toggleOne($inputs)) {
          http_response_code(200); // OK
          echo json_encode([
            "success" => true,
            "message" => "Zone successfully deleted"
          ]);
        } else {
          http_response_code(404); // Not Found
          echo json_encode([
            "success" => false,
            "message" => "Couldn't delete zone"
          ]);
        }
      } catch (Exception $e) {
        http_response_code(500); // Internal Server Error
        echo json_encode([
          "success" => false,
          "message" => "An error occurred: " . $e->getMessage()
        ]);
      }
    }
  }

  /**
   *  -------------------
   *  REPORTS MANAGEMENT
   *  -------------------
   */


  /**
   * Add one report
   * @return void
   */
  public function addOneReport(): void
  {
    header('Content-Type: application/json');

    $request = new Request();

    if ($this->isContentJson()) {
      $inputs = $request->json([
        'dataId:i*',
        'dataReport:s*'
      ]);

      // Get cookie from request header
      $cookie = $request->cookie([Config::getInstance()->getConfig('jwt_cookie_name') . ':s*']);
      $decodedCookie = JWT::getInstance()->decode($cookie);

      // Add agent's id to inputs
      $inputs->idAgent = $decodedCookie->idAgent;

      try {
        // Use the controller to get data
        $reportController = new ReportController();

        if ($reportController->addOne($inputs)) {
          http_response_code(200); // OK
          echo json_encode([
            "success" => true,
            "message" => "Case successfully added"
          ]);
        } else {
          http_response_code(404); // Not Found
          echo json_encode([
            "success" => false,
            "message" => "Couldn't add report, verify inputs"
          ]);
        }
      } catch (Exception $e) {
        http_response_code(500); // Internal Server Error
        echo json_encode([
          "success" => false,
          "message" => "An error occurred: " . $e->getMessage()
        ]);
      }
    }
  }

  /**
   * Get all reports
   * @return void
   */
  public function getAllReport(): void
  {
    header('Content-Type: application/json');

    $request = new Request();

    if ($this->isContentJson()) {
      $idPersonne = $request->get(['id:i']);

      try {
        // Use the controller to get data
        $reportController = new ReportController();
        $data = $reportController->getAll(true, $idPersonne);

        if (!empty($data)) {
          http_response_code(200); // OK
          echo json_encode([
            "success" => true,
            "message" => "Data retrieved successfully",
            "data" => $data
          ]);
        } else {
          http_response_code(404); // Not Found
          echo json_encode([
            "success" => false,
            "message" => "No data found",
            "data" => []
          ]);
        }
      } catch (Exception $e) {
        http_response_code(500); // Internal Server Error
        echo json_encode([
          "success" => false,
          "message" => "An error occurred: " . $e->getMessage(),
          "data" => []
        ]);
      }
    }
  }

  /**
   * Delete one agent
   * @return void
   */
  public function deleteOneReport(): void
  {
    header('Content-Type: application/json');

    $request = new Request();

    if ($this->isContentJson()) {
      $input = $request->json(['idReleve:i*']);

      try {
        // Use the controller to get data
        $reportController = new ReportController();

        if ($reportController->deleteOne($input)) {
          http_response_code(200); // OK
          echo json_encode([
            "success" => true,
            "message" => "Report successfully deleted"
          ]);
        } else {
          http_response_code(404); // Not Found
          echo json_encode([
            "success" => false,
            "message" => "Couldn't delete report"
          ]);
        }
      } catch (Exception $e) {
        http_response_code(500); // Internal Server Error
        echo json_encode([
          "success" => false,
          "message" => "An error occurred: " . $e->getMessage()
        ]);
      }
    }
  }


  /**
   *  -----------------
   *  COUNTS MANAGEMENT
   *  -----------------
   */


  /**
   * Add one count
   * @return void
   */
  public function addOneCount(): void
  {
    header('Content-Type: application/json');

    $request = new Request();

    if ($this->isContentJson()) {
      $inputs = $request->json([
        'idZone:i*',
        'count:i*'
      ]);

      // Get cookie from request header
      $cookie = $request->cookie([Config::getInstance()->getConfig('jwt_cookie_name') . ':s*']);
      $decodedCookie = JWT::getInstance()->decode($cookie);

      // Add agent's id to inputs
      $inputs->idAgent = $decodedCookie->idAgent;

      try {
        // Use the controller to get data
        $countController = new CountController();

        if ($countController->addOne($inputs)) {
          http_response_code(200); // OK
          echo json_encode([
            "success" => true,
            "message" => "Count successfully added"
          ]);
        } else {
          http_response_code(404); // Not Found
          echo json_encode([
            "success" => false,
            "message" => "Couldn't add count, verify inputs"
          ]);
        }
      } catch (Exception $e) {
        http_response_code(500); // Internal Server Error
        echo json_encode([
          "success" => false,
          "message" => "An error occurred: " . $e->getMessage()
        ]);
      }
    }
  }

  /**
   *  -----------------
   *  STATS MANAGEMENT
   *  -----------------
   */

  /**
   * Fetch gender distribution stats
   * @return void
   */
  public function getGenderDistribution(): void
  {
    header('Content-Type: application/json');

    $request = new Request();

    if ($this->isContentJson()) {
      try {
        // Use the controller to get data
        $statsController = new StatsController();
        $data = $statsController->getGenderDistribution(true);

        if (!empty($data)) {
          http_response_code(200); // OK
          echo json_encode([
            "success" => true,
            "message" => "Data retrieved successfully",
            "data" => $data
          ]);
        } else {
          http_response_code(404); // Not Found
          echo json_encode([
            "success" => false,
            "message" => "No data found",
            "data" => []
          ]);
        }
      } catch (Exception $e) {
        http_response_code(500); // Internal Server Error
        echo json_encode([
          "success" => false,
          "message" => "An error occurred: " . $e->getMessage(),
          "data" => []
        ]);
      }
    }
  }

  /**
   * Fetch last six months progression stats
   * @return void
   */
  public function getSixMonthsProgression(): void
  {
    header('Content-Type: application/json');

    $request = new Request();

    if ($this->isContentJson()) {
      try {
        // Use the controller to get data
        $statsController = new StatsController();
        $data = $statsController->getSixMonthsProgression(true);

        if (!empty($data)) {
          http_response_code(200); // OK
          echo json_encode([
            "success" => true,
            "message" => "Data retrieved successfully",
            "data" => $data
          ]);
        } else {
          http_response_code(404); // Not Found
          echo json_encode([
            "success" => false,
            "message" => "No data found",
            "data" => []
          ]);
        }
      } catch (Exception $e) {
        http_response_code(500); // Internal Server Error
        echo json_encode([
          "success" => false,
          "message" => "An error occurred: " . $e->getMessage(),
          "data" => []
        ]);
      }
    }
  }

  /**
   * Fetch typology distribution stats
   * @return void
   */
  public function getTypologyDistribution(): void
  {
    header('Content-Type: application/json');

    $request = new Request();

    if ($this->isContentJson()) {
      try {
        // Use the controller to get data
        $statsController = new StatsController();
        $data = $statsController->getTypologyDistribution(true);

        if (!empty($data)) {
          http_response_code(200); // OK
          echo json_encode([
            "success" => true,
            "message" => "Data retrieved successfully",
            "data" => $data
          ]);
        } else {
          http_response_code(404); // Not Found
          echo json_encode([
            "success" => false,
            "message" => "No data found",
            "data" => []
          ]);
        }
      } catch (Exception $e) {
        http_response_code(500); // Internal Server Error
        echo json_encode([
          "success" => false,
          "message" => "An error occurred: " . $e->getMessage(),
          "data" => []
        ]);
      }
    }
  }

  /**
   * Fetch population distribution stats
   * @return void
   */
  public function getPopulationDistribution(): void
  {
    header('Content-Type: application/json');

    $request = new Request();

    if ($this->isContentJson()) {
      try {
        // Use the controller to get data
        $statsController = new StatsController();
        $data = $statsController->getPopulationDistribution(true);

        if (!empty($data)) {
          http_response_code(200); // OK
          echo json_encode([
            "success" => true,
            "message" => "Data retrieved successfully",
            "data" => $data
          ]);
        } else {
          http_response_code(404); // Not Found
          echo json_encode([
            "success" => false,
            "message" => "No data found",
            "data" => []
          ]);
        }
      } catch (Exception $e) {
        http_response_code(500); // Internal Server Error
        echo json_encode([
          "success" => false,
          "message" => "An error occurred: " . $e->getMessage(),
          "data" => []
        ]);
      }
    }
  }

  /**
   * Check if content is json
   */
  private function isContentJson()
  {
    $request = new Request();

    if ($request->isContentJson()) {
      return true;
    }

    header('Location: /app');
    exit;
  }
}
