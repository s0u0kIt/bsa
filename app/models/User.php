<?php
namespace App\Models;

class User {
  public ?int $id;
  public string $firstname;
  public string $lastname;

  public function __construct(int $id = null, string $firstname, string $lastname) {
    $this->id = $id;
    $this->firstname = $firstname;
    $this->lastname = $lastname;
  }
}