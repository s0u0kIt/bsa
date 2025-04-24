<?php
namespace Libs\Smarty;

use Framework\Config;


class SmartyWrapper {
  public static function getSmarty() {
    // Initialize smarty
    require_once 'Smarty.class.php';

    $config = Config::getInstance();
    $smarty = new \Smarty();
    $smarty->setTemplateDir($config->getConfig('smarty_template_dir'));
    $smarty->setCompileDir($config->getConfig('smarty_compile_dir'));
    $smarty->setCacheDir($config->getConfig('smarty_cache_dir'));
    $smarty->setConfigDir($config->getConfig('smarty_configs_dir'));

    return $smarty;
  }
}