<?php
namespace Controllers;

use Libs\Smarty\SmartyWrapper;

class QNAController
{
  /**
   * Handle the main home page
   * @return void
   */
  public function faq(): void
  {
    $smarty = SmartyWrapper::getSmarty();
    $smarty->display('qna.tpl');
  }
}