<?php

use Phalcon\Mvc\Controller;

class MinizooController extends Controller {
    public function indexAction() {
        $miniZooList = $this->db->fetchAll(
            "SELECT * FROM mini_zoo WHERE is_active = true ORDER BY nama ASC, created_at ASC",
            \Phalcon\Db::FETCH_ASSOC
        );

        $this->view->setVar('miniZooList', $miniZooList ?: []);
    }
}
