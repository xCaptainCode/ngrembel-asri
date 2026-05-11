<?php

use Phalcon\Db;
use Phalcon\Mvc\Controller;

class IndexController extends Controller {
   public function indexAction() {
      if ($this->hasDashboardAccess()) {
        
      }
   }


   private function hasDashboardAccess() {
      $role = strtoupper((string) $this->session->get('role'));
      return in_array($role, [], true);
   }

}
