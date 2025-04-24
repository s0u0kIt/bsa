<?php
namespace teachframe;

class IO {
  /**
  * @param fields the list of required fields with type ['field:type', ...]
  *  - types: 's' (string), 'i' (int), 'f' (float), 'b' (bool), 'e' (email), 'u' (url)
  *          'd' (date), 't' (time)
  *  - prefix with a '*' for mandatory fields
  *  - example: ['firstname:*s', 'email:e']
  * @return an object containing the valid or sanitized inputs
  * @die on invalid input data
  **/
  public static function getInputs (array $fields): mixed {
    $format = $_SERVER['CONTENT_TYPE'];
    if ($format == 'application/x-www-form-urlencoded') {
      $inputs = IO::getFormInputs($fields);
    } else if ($format == 'application/xml') {
      $inputs = IO::getXMLInputs($fields);
    } else if ($format == 'application/json') {
      $inputs = IO::getJSONInputs($fields);
    } else {
        http_response_code(400);
        die('error: incorrect content type format');
    }
    return $inputs;
  }
 
  private static function getFormInputs(array $fields): mixed {
    $method = $_SERVER['REQUEST_METHOD'];
    if ($method == 'GET' || $method == 'POST') {
      $assoc = $_REQUEST;
    } else { //method should be 'PUT'
      parse_str('php://input', $assoc);
    }
    $inputs = new \StdClass(); //associative array to object (normalization)
    foreach ($assoc as $key => $value) {
      $inputs->$key = $value;
    }
    return IO::getInputsCommon($fields, $inputs);
  }
 
  private static function getXMLInputs(array $fields): mixed {
    $inputs = simplexml_load_file('php://input');
    if ($inputs == false) {
      http_response_code(400);
      die('error: malformed XML');
    }
    return IO::getInputsCommon($fields, $inputs);
  }
 
  private static function getJSONInputs(array $fields): mixed {
    $inputs = json_decode(file_get_contents('php://input'));
    if ($inputs == null) {
      http_response_code(400);
      die('error: malformed JSON');
    }
    return IO::getInputsCommon($fields, $inputs);
  }
 
  private static function getInputsCommon(array $fields, mixed $inputs): mixed {
    $obj = new \stdClass();
    foreach ($fields as $field) {
      $field_type = explode(':', $field);
      $field = $field_type[0];
      $type = $field_type[1];
      if (isset($inputs->$field) && $inputs->$field != '') {
        $obj->$field = IO::valSan($inputs->$field, $type, $field);
      } else if ($type[0] == '*') {
        http_response_code(400);
        die('error: missing required parameter \'' . $field . '\'');
      }
    }
    return $obj;
  }
 
  private static function valSan(string $str, string $type, string $field): mixed {
     //Initialize value
    $value = null;

    //Remove mendatory '*' indicator
    if ($type[0] == '*') {
      $type = substr($type, 1);
    }

    //Per type sanitization
    if ($type == 's') { //string sanitization 
      $value = htmlentities(addslashes($str));
    } else if ($type == 'i') { //int sanitization
      $type = 'integer';
      $value = filter_var($str, FILTER_VALIDATE_INT, FILTER_NULL_ON_FAILURE);
    } else if ($type == 'f') { //float sanitization
      $type = 'float';
      $value = filter_var($str, FILTER_VALIDATE_FLOAT, FILTER_NULL_ON_FAILURE);
    } else if ($type == 'd') { //date sanitization
      $type = 'date (YYYY-MM-DD)';
      if (date_create_immutable_from_format('Y-m-d', $str)) {
        $value = $str;
      } else {
        $value = null;
      }
    } else if ($type == 't') { //time sanitization
        $type = 'time (HH:MM:SS)';
        if (date_create_immutable_from_format('H:i:s', $str)) {
          $value = $str;
        } else {
          $value = null;
        }
    } else if ($type == 'e') { //email sanitization
        $type = 'email';
        $value = filter_var($str, FILTER_VALIDATE_EMAIL, FILTER_NULL_ON_FAILURE);
    }  else if ($type == 'b') { //bool sanitization
        $type = 'boolean';
        $value = filter_var($str, FILTER_VALIDATE_BOOLEAN, FILTER_NULL_ON_FAILURE);
    } else if ($type == 'u') { //url sanitization
        $type = 'url';
        $value = htmlentities(addslashes(filter_var($str, FILTER_VALIDATE_URL, FILTER_NULL_ON_FAILURE)));
    }
    
    //Throw error if type of parameter is invalid
    if ($value === null) {
      http_response_code(400);
      die('error: invalid ' . $type . ' value for parameter \'' . $field . '\'');
    }

    return $value;
  }
}