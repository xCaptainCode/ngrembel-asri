<?php

use Phalcon\Mvc\Controller;

class IndexController extends Controller {
   public function indexAction() {
      $dashboard = $this->db->fetchOne(
         "SELECT * FROM dashboard ORDER BY updated_at DESC NULLS LAST, created_at DESC NULLS LAST LIMIT 1",
         \Phalcon\Db::FETCH_ASSOC
      );
      $this->view->setVar('dashboard', $dashboard ?: []);
   }
}
