<?php
namespace Controllers;

use Libs\Smarty\SmartyWrapper;

class PoliciesController
{
  /**
   * Handle the main home page
   * @return void
   */
  public function policiesLm(): void
  {
    $smarty = SmartyWrapper::getSmarty();
    $smarty->display('legal-mention.tpl');
  }

  public function policiesPp(): void
  {
    $smarty = SmartyWrapper::getSmarty();
    $smarty->display('privacy-policy.tpl');
  }

  public function policiesGc(): void
  {
    $smarty = SmartyWrapper::getSmarty();
    $smarty->display('general-condition.tpl');
  }
}