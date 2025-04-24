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
    $smarty->display('home.tpl');
  }
  public function mapBSA(): void
  {
    $smarty = SmartyWrapper::getSmarty();
    $smarty->display('home.tpl');
  }
}