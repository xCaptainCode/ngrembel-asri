<?php

class Setting extends \Phalcon\Mvc\Model
{
    public $type_value;
    public $name;
    public $value;
    public $updated_at;
    public $updated_by;

    public function initialize()
    {
        $this->setSource('settings');
    }

    public function getSource()
    {
        return 'settings';
    }

    /**
     * Helper to get setting value by key
     */
    public static function getVal($name, $default = null)
    {
        $setting = self::findFirstByName($name);
        return $setting ? $setting->value : $default;
    }
}
