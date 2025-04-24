<?php

namespace teachframe;
use \ArrayAccess;
use \ArrayIterator;
use \Countable;
use \IteratorAggregate;

/**
 * Class Collection
 *
 * Cette classe abstraite représente une collection d'éléments qui peut être manipulée
 * comme un tableau. Elle permet de compenser l'absence de type 'Array<NomClasse>' du PHP.
 * Elle doit être utilisée par les classes du modèle ayant une collection comme attribut.
 * Exemple :
 *    use teachframe\Collection;
 *    class NomClasseCollection extends Collection {}'
 *    class AutreClasse {
 *      NomClasseCollection $items;
 *    }
 * Le nom doit impérativement respecter la forme indiquée pour que l'ORM fonctionne.
 */
abstract class Collection implements ArrayAccess, Countable, IteratorAggregate {
  private array $items;
  /**
   * Collection constructor.
   *
   * @param $items Tableau des éléments pour initialiser la collection (vide par défaut).
   */
  final public function __construct(array $items = []) {
    $this->items = $items;
  }
  final public function offsetExists(mixed $offset) : bool {
    return isset($this->items[$offset]);
  }
  final public function offsetGet(mixed $offset) : mixed {
    return $this->items[$offset];
  }
  final public function offsetSet(mixed $offset, mixed $value) : void {
    $this->items[$offset] = $value;
  }
  final public function offsetUnset(mixed $offset) : void {
    unset($this->items[$offset]);
  }
  final public function count() : int {
    return count($this->items);
  }
  final public function getIterator() : ArrayIterator {
    return new ArrayIterator($this->items);
  }
}
