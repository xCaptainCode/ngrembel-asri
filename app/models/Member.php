<?php

class Member extends \Phalcon\Mvc\Model
{

    /**
     *
     * @var string
     */
    public $id;
    /**
     *
     * @var string
     */
    public $no_member;
    /**
     *
     * @var string
     */
    public $nama;
    /**
     *
     * @var string
     */
    public $no_hp;
    /**
     *
     * @var string
     */
    public $email;
    /**
     *
     * @var string
     */
    public $password;
    /**
     *
     * @var boolean
     */
    public $is_active;


    /**
     * Initialize method for model.
     */
    public function initialize()
    {
        $this->setSchema("public");
        $this->setSource("members");
    }

    /**
     * Returns table name mapped in the model.
     *
     * @return string
     */
    public function getSource()
    {
        // return 'web_vusers_list';
        return 'members';
    }

    /**
     * Allows to query a set of records that match the specified conditions
     *
     * @param mixed $parameters
     * @return Member[]|Member|\Phalcon\Mvc\Model\ResultSetInterface
     */
    public static function find($parameters = null)
    {
        return parent::find($parameters);
    }

    /**
     * Allows to query the first record that match the specified conditions
     *
     * @param mixed $parameters
     * @return Member|\Phalcon\Mvc\Model\ResultInterface
     */
    public static function findFirst($parameters = null)
    {
        return parent::findFirst($parameters);
    }

}
