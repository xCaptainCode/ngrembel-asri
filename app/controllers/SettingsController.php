<?php

use Phalcon\Mvc\Controller;

class SettingsController extends Controller {
   public function beforeExecuteRoute() {
      $role = strtolower((string) $this->session->get('role'));
      if (! $this->session->get('id') || $role !== 'admin') {
         $this->response->redirect('');
         return false;
      }
      return true;
   }

   public function dashboardAction() {}
   public function price_listAction() {}
   public function permainanAction() {}
   public function paintballAction() {}
   public function field_tripAction() {}
   public function fun_gameAction() {}
   public function mini_zooAction() {}
   public function fasilitasAction() {}
   public function galeriAction() {}
   public function kritik_saranAction() {}
}
