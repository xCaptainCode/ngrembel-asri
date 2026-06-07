<?php

class Promotion extends \Phalcon\Mvc\Model
{
    public $id;
    public $name;
    public $description;
    public $image_url;
    public $start_date;
    public $end_date;
    public $is_active;
    public $created_at;
    public $updated_at;

    public function initialize()
    {
        $this->setSource('promotions');
    }

    public function getSource()
    {
        return 'promotions';
    }
}
