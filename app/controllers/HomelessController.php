<?php
namespace Controllers;

use Libs\Smarty\SmartyWrapper;

class HomelessController
{
  /**
   * Handle the main home page
   * @return void
   */
  public function getAll(): void
  {
    $smarty = SmartyWrapper::getSmarty();
    $smarty->assign('name', 'User');
    $smarty->display('homeless.tpl');
  }
}