<?php

class Registrasi extends \Phalcon\Mvc\Model
{
    public $id;
    public $nama;
    public $no_hp;
    public $email;
    public $tgl_lahir;
    public $gender;
    public $kota;
    public $alamat;
    public $password;
    public $tgl_daftar;
    public $is_active;
    public $role;
    public $status;
    public $updated_at;
    public $updated_by;

    public function initialize()
    {
        $this->setSource('registrasi');
    }

    public function getSource()
    {
        return 'registrasi';
    }

    public static function find($parameters = null)
    {
        return parent::find($parameters);
    }

    public static function findFirst($parameters = null)
    {
        return parent::findFirst($parameters);
    }
}
