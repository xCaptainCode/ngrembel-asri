<?php

use Phalcon\Mvc\Controller;

class FasilitasController extends Controller {
    public function indexAction() {
        $fasilitasList = $this->db->fetchAll(
            "SELECT * FROM fasilitas WHERE is_active = true ORDER BY created_at ASC",
            \Phalcon\Db::FETCH_ASSOC
        );

        $this->view->setVar('fasilitasList', $fasilitasList ?: []);
    }
}
