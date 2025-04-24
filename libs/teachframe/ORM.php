<?php

namespace teachframe;
use \PDO;
use \ReflectionClass;
use \ReflectionProperty;

/**
 * Class ORM
 *
 * Cette classe fournit des méthodes statiques pour interagir avec la base de données
 * en utilisant le mapping relationnel objet.
 * Contraintes :
 *  - la classe du modèle doit avoir le même nom que la table ;
 *  - la clé primaire de la table doit être 'id' ; pour les nouveaux enregistrements, 
 *    id doit être initialisé à 0 si auto-incrémenté, 
 *  - le nom des attributs de la classe doit être identique à celui des champs ;
 *  - les clés étrangères doivent être nommées 'idNomTable' et les attributs associés
 *    déclarés `NomClasse $nomClasse;` ;
 *  - les collections doivent être déclarées `NomClasseCollection $nomClasseAupluriel;` ;
 *  - Ajouter l'attribut '#[ORM\NomTable]' pour les collections de type ManyToMany (N-N).  
 */
class ORM {
  /**
   * Récupère les enregistrements d'une table.
   *
   * @param string $modelClass classe modèle (avec namespace).
   * @param string $selectFields champs à récupérer (par défaut '*').
   * @param string|null $filter clause WHERE optionnelle pour filtrer les résultats.
   * @return tableau d'objets récupérés.
   */
  public static function getAll (string $modelClass, string $selectFields = '*', string $filter = null): array {
    $filter = ($filter != null ? ' WHERE ' . $filter : '');
    $stmt = PDOWrapper::getInstance()->query('SELECT ' . $selectFields . ' FROM ' . ORM::getBaseName($modelClass) . addslashes($filter));
    $collection = [];
    while ($item = $stmt->fetch(PDO::FETCH_ASSOC)) {
      $collection[] = ORM::buildObj($modelClass, $item); //cut recursivity
    }
    return $collection;
  }

  /**
   * Récupère un enregistrement d'une table à partir de son identifiant.
   *
   * @param string $modelClass classe modèle (avec namespace).
   * @param mixed $id identifiant de l'enregistrement à récupérer.
   * @param bool $followLinks pour charger (par défaut) ou pas les données des objets liés.
   * @return objet récupéré ou null si non trouvé.
   */
  public static function getOne (string $modelClass, mixed $id, bool $followLinks = true): mixed {
    $filter = ' WHERE id = ' . (!is_int($id) ? '\'' . addslashes($id) . '\'' : $id);
    $stmt = PDOWrapper::getInstance()->query('SELECT * FROM ' . ORM::getBaseName($modelClass) . $filter);
    $obj = null;
    if ($item = $stmt->fetch(PDO::FETCH_ASSOC)) {
      $obj = ORM::buildObj($modelClass, $item, $followLinks);
    }
    return $obj;
  }

  /**
   * Ajoute ou modifie un enregistrement.
   *
   * @param mixed $obj objet à insérer ou mettre à jour.
   */
  public static function persist (mixed $obj) {
    $table = ORM::getBaseName(get_class($obj));
    
    $columns = []; $values = []; $updates = []; $collections = [];
    $reflect = new ReflectionClass($obj);
    $modelClass = $reflect->getName();
    foreach ( $reflect->getProperties() as $property) {
      $propertyType = (string) $property->getType();
      $propertyName = $property->getName();
      $propertyValue = $property->getValue($obj);  
      if ($propertyName != 'id') {
        switch ($propertyType) {
          case 'bool':
          case 'int':
          case 'float':
            $columns[] = $propertyName;
            $values[] = $propertyValue;
            $updates[] = $columns[count($columns) - 1] . ' = ' . $values[count($columns) - 1];
            break;
          case 'string':
          case 'DateTime':
            $columns[] = $propertyName;
            $values[] = "'" . addslashes((string) $propertyValue) . "'";
            $updates[] = $columns[count($columns) - 1] . ' = ' . $values[count($columns) - 1];
            break;
          default: //is_object($propertyValue))
            if (str_ends_with($propertyType, 'Collection')) {
              $collections[] = $property;
            } else {
              $columns[] = 'id' . ucfirst($propertyName);
              echo $propertyValue;
              $values[] = $propertyValue->getId();
              $updates[] = $columns[count($columns) - 1] . ' = ' . $values[count($columns) - 1];
            }
        }
      }
    }
    
    $existingObj = ORM::getOne($modelClass, $obj->getId(), false);
    if (null == $existingObj) {
      $sql = 'INSERT INTO ' . $table . '(' . implode(', ', $columns) . ') VALUES (' . implode(', ', $values) . ')';
      if (0 == $obj->getId()) {
        $obj->setId(PDOWrapper::getInstance()->lastInsertId());
      }
    } else {
      $sql = 'UPDATE ' . $table . ' SET ' . implode(', ', $updates) . ' WHERE id = ' . $obj->getId();
    }
    PDOWrapper::getInstance()->exec($sql);
    foreach($collections as $property) {
      ORM::persistSubCollection($modelClass, $obj, $property);
    }
  }

  /**
   * Supprime un enregistrement.
   *
   * @param mixed $obj objet à supprimer.
   */
  public static function delete (mixed $obj) {
    $table = ORM::getBaseName(get_class($obj));
    $filter = 'id = ' . (!is_int($obj->getId()) ? '\'' . $obj->getId() . '\'' : $obj->getId());
    PDOWrapper::getInstance()->exec('DELETE FROM ' . $table . ' WHERE ' . $filter);
  }

  /**
   * Supprime plusieurs enregistrement d'une table.
   *
   * @param string $modelClass classe modèle (avec namespace).
   * @param string $filter clause WHERE pour sélectionner les enregistrements à supprimer.
   */
  public static function deleteMany (string $modelClass, string $filter) {
    PDOWrapper::getInstance()->exec('DELETE FROM ' . ORM::getBaseName($modelClass) . ' WHERE ' . $filter);
  }

  private static function buildObj (string $modelClass, array $item, bool $followLinks = false) {
    $reflect = new ReflectionClass($modelClass);
    $properties = $reflect->getProperties();
    $obj = $reflect->newInstanceWithoutConstructor();
    foreach ($properties as $property) {
      $propertyName = $property->getName();
      if (array_key_exists($propertyName, $item)) {
        $property->setValue($obj, $item[$propertyName]);
      } else if ($followLinks) {
        if (!ORM::setSubObj($modelClass, $item, $obj, $property)) ORM::setSubCollection($modelClass, $item, $obj, $property);
      }
    }
    return $obj;
  }

  private static function setSubObj(string $modelClass, array $item, mixed $obj, ReflectionProperty $property): bool {
    $result = false;
    $externClassName = ucfirst($property->getName());
    $externClassField = 'id' . $externClassName;
    if (array_key_exists($externClassField, $item)) {
      $externObj = ORM::getOne(ORM::getDirName($modelClass) . '\\' . $externClassName, $item[$externClassField], false); //cut recursivity
      assert($externObj != null, 'DBMS integrity constraint error');
      $property->setValue($obj, $externObj);
      $result = true;
    }
    return $result;
  }

  private static function setSubCollection (string $modelClass, array $item, mixed $obj, ReflectionProperty $property): bool {
    $result = false;
    $typeName = (string) $property->getType();
    $externClass = substr($typeName, 0, -10);
    if (str_ends_with($typeName, 'Collection')) {
      $externClassField = 'id' . ORM::getBaseName($modelClass);
      
      $attributes = array_filter( $property->getAttributes(), fn($attr) => str_contains($attr->getName(), 'ORM\\'));
      
      if (count($attributes) == 1) { //if there is an intermediate table - cf ManyToMany (N-N)
        $interClass = substr($attributes[0]->getName(), strpos($attributes[0]->getName(), 'ORM\\') + 4);
        $stmt = PDOWrapper::getInstance()->query('SELECT id' . ORM::getBaseName($externClass) . ' FROM ' . $interClass . ' WHERE ' . $externClassField . ' = ' . $obj->getId());
        $filter = 'id IN ' . '(' . implode(', ',  $stmt->fetchAll(PDO::FETCH_COLUMN, 0)) . ')';
      
      } else { //OneToMany (1-N)
        $filter =  $externClassField . ' = ' . $obj->getId();
      }
      
      $items = ORM::getAll($externClass, '*', $filter);
      $property->setValue($obj, new $typeName($items));
      $result = true;
    }
    return $result;
  }
  
  private static function persistSubCollection (string $modelClass, mixed $obj, ReflectionProperty $property) {
    $externClassField = 'id' . ORM::getBaseName($modelClass);
    $attributes = array_filter( $property->getAttributes(), fn($attr) => str_contains($attr->getName(), 'ORM\\'));
    if (count($attributes) == 1) { //if there is an intermediate table - cf ManyToMany (N-N)
      $interClass = substr($attributes[0]->getName(), strpos($attributes[0]->getName(), 'ORM\\') + 4);
      $stmt = PDOWrapper::getInstance()->query('DELETE FROM ' . ORM::getBaseName($interClass) . ' WHERE ' . 
                                               $externClassField . ' = ' . $obj->getId());
      //TODO: insert
    }
  }

  private static function getBaseName(string $modelClass): string { // 'model\SomeClass' -> 'SomeClass'
    $classPath = explode('\\', $modelClass);
    return $classPath[count($classPath) - 1];
  }

  private static function getDirName(string $modelClass): string { // 'org\app\model\SomeClass' -> 'org\app\model'
    return join('\\', array_slice(explode('\\', $modelClass), 0, -1));
  }
}

