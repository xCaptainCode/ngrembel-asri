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
        $wahanaList = $this->db->fetchAll(
            "SELECT * FROM wahana 
             WHERE kategori = 'PAINTBALL' AND is_active = true 
             ORDER BY urutan ASC, nama ASC",
            \Phalcon\Db::FETCH_ASSOC
        );
        $this->view->setVar('wahanaList', $wahanaList ?: []);
    }
    public function field_tripAction() {
        $wahanaList = $this->db->fetchAll(
            "SELECT * FROM wahana 
             WHERE kategori = 'FIELD TRIP' AND is_active = true 
             ORDER BY urutan ASC, nama ASC",
            \Phalcon\Db::FETCH_ASSOC
        );
        $this->view->setVar('wahanaList', $wahanaList ?: []);
    }
    public function fun_gameAction() {
        $wahanaList = $this->db->fetchAll(
            "SELECT * FROM wahana 
             WHERE kategori = 'FUN GAME' AND is_active = true 
             ORDER BY urutan ASC, nama ASC",
            \Phalcon\Db::FETCH_ASSOC
        );
        $this->view->setVar('wahanaList', $wahanaList ?: []);
    }
}
