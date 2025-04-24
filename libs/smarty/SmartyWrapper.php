<?php

namespace Libs\Smarty;

use Framework\Config;

class SmartyWrapper
{
  private static ?\Smarty $smarty = null;

  public static function getSmarty(): \Smarty
  {
    if (self::$smarty === null) {
      require_once 'Smarty.class.php';

      $config = Config::getInstance();
      self::$smarty = new \Smarty();
      self::$smarty->setTemplateDir($_SERVER['DOCUMENT_ROOT'] . $config->getConfig('smarty_template_dir'));
      self::$smarty->setCompileDir($_SERVER['DOCUMENT_ROOT'] . $config->getConfig('smarty_compile_dir'));
      self::$smarty->setCacheDir($_SERVER['DOCUMENT_ROOT'] . $config->getConfig('smarty_cache_dir'));
      self::$smarty->setConfigDir($_SERVER['DOCUMENT_ROOT'] . $config->getConfig('smarty_configs_dir'));
    }

    return self::$smarty;
  }
}
