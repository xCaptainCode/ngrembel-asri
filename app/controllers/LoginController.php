<?php

use Phalcon\Mvc\View;
use User;

class LoginController extends \Phalcon\Mvc\Controller {

   public function indexAction() {
      $this->view->pick("login/index");
      $this->view->setRenderLevel(View::LEVEL_ACTION_VIEW);

   }

   public function prosesAction() {
      $this->view->disable();

      if ($this->request->isPost()) {
         $username = $this->request->getPost("txtusername");
         $password = $this->request->getPost("txtpassword");

         $user = User::findFirst([
            "conditions" => "username = :username: AND password = :password: AND is_active = true",
            "bind"       => [
               "username" => $username,
               "password" => md5($password),
            ],
         ]);

         if ($user === false) {
            return $this->response->redirect('');
         } else {
            $this->session->set('id', $user->id);
            $this->session->set('name', $user->name);
            $this->session->set('role', $user->role);
            $this->session->set('username', $user->username);
            $this->session->set('user_photo', $user->id . ".png");
            return $this->response->redirect('');
         }
      }
   }

   public function logoutAction() {
      $this->view->disable();
      $this->session->destroy();
      $this->response->redirect('');
   }

   public function forgotAction() {
      $this->view->pick("login/forgot");
      $this->view->setRenderLevel(View::LEVEL_ACTION_VIEW);
   }

   public function registrasiAction() {
      $this->view->pick("login/registrasi");
      $this->view->setRenderLevel(View::LEVEL_ACTION_VIEW);
   }
}