<?php

class KritikSaran extends \Phalcon\Mvc\Model
{

    /**
     * @var string (UUID)
     */
    public $id;

    /**
     * @var string (kritik / saran)
     */
    public $type;

    /**
     * @var string
     */
    public $nama;

    /**
     * @var string
     */
    public $kritik_saran;

    /**
     * @var string
     */
    public $created_at;

    /**
     * @var string
     */
    public $response;

    /**
     * @var string
     */
    public $responded_at;

    /**
     * @var boolean
     */
    public $is_published;

    /**
     * @var string (UUID)
     */
    public $responded_by;

    /**
     * Initialize method for model.
     */
    public function initialize()
    {
        $this->setSchema("public");
        $this->setSource("kritik_saran");
    }

    /**
     * Returns table name mapped in the model.
     *
     * @return string
     */
    public function getSource()
    {
        return 'kritik_saran';
    }

}
