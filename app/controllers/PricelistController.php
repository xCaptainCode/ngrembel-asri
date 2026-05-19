<?php

use Phalcon\Mvc\Controller;

class PricelistController extends Controller {
    public function indexAction() {
        $priceList = $this->db->fetchAll(
            "SELECT * FROM price_list 
                WHERE is_active = 't' OR is_active = true
                ORDER BY kategori ASC, no_urut ASC, nama ASC",
            \Phalcon\Db::FETCH_ASSOC
        );
        $jenisMasakan = $this->db->fetchAll(
            "SELECT * FROM jenis_masakan 
                WHERE is_active = 't' OR is_active = true
                ORDER BY no_urut ASC, nama ASC",
            \Phalcon\Db::FETCH_ASSOC
        );
        $this->view->setVar('priceList', $priceList ?: []);
        $this->view->setVar('jenisMasakan', $jenisMasakan ?: []);
    }
}
