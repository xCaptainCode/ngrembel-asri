<?php

use Phalcon\Mvc\Controller;

class GaleriController extends Controller {
    public function indexAction() {
        $galleryList = $this->db->fetchAll(
            "SELECT * FROM gallery 
             WHERE is_active = true 
               AND resource_url IS NOT NULL 
               AND resource_url <> ''
             ORDER BY created_at DESC, id ASC",
            \Phalcon\Db::FETCH_ASSOC
        );

        $this->view->setVar('galleryList', $galleryList ?: []);
    }
}