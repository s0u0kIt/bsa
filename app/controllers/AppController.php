<?php
namespace Controllers;

use Libs\Smarty\SmartyWrapper;

class AppController
{
  /**
   * Handle the main home page
   * @return void
   */
  public function app(): void
  {
    $smarty = SmartyWrapper::getSmarty();
    $smarty->display('app.tpl');
  }
}