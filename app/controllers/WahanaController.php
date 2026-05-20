<?php

use Phalcon\Mvc\Controller;

class WahanaController extends Controller {
    public function indexAction() {
        // Halaman Wahana
    }
    public function permainanAction() {
        $wahanaList = $this->db->fetchAll(
            "SELECT * FROM wahana 
             WHERE kategori = 'PERMAINAN' AND is_active = true 
             ORDER BY urutan ASC, nama ASC",
            \Phalcon\Db::FETCH_ASSOC
        );
        $this->view->setVar('wahanaList', $wahanaList ?: []);
    }
    public function paintballAction() {
        // Halaman Paintball
    }
    public function field_tripAction() {
        // Halaman Field Trip
    }
    public function fun_gameAction() {
        // Halaman Fun Game
    }
}
