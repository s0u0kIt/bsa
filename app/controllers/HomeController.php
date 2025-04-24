<?php
namespace Controllers;

use Libs\Smarty\SmartyWrapper;

class HomeController
{
  /**
   * Handle the main home page
   * @return void
   */
  public function home(): void
  {
    $smarty = SmartyWrapper::getSmarty();
    $smarty->assign('name', 'User');
    $smarty->display('home.tpl');
  }
}