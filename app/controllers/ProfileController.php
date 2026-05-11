<?php

use User;
use Phalcon\Mvc\Controller;
use Phalcon\Db;

class ProfileController extends Controller
{
   public function indexAction()
   {
      $this->view->pick('profile/index');

      $user_id = $this->session->get('id');

      $sql = "SELECT count(*) as qty, sum(total) as total FROM orders WHERE user_id = :uid;";
      $total = $this->db->fetchOne($sql, Db::FETCH_ASSOC,['uid' => $user_id]);
      $this->view->qty_order = $total['qty'];
      $this->view->total_order = $total['total'];

      
   }

   public function updateAction()
   {
      $this->view->disable();

      if (!$this->request->isPost()) {
         return $this->response->redirect('profile');
      }

      $id   = $this->session->get('id');
      $user = User::findFirstById($id);

      if (!$user) {
         $this->flashSession->error('User tidak ditemukan.');
         return $this->response->redirect('profile');
      }

      $user->name = $this->request->getPost('name', 'string');
      $user->username = $this->request->getPost('username', 'string');
      
      $password = $this->request->getPost('password', 'string');
      if (!empty($password)) {
         $user->password = md5($password);
      }

      try {
         if ($user->save()) {
            $this->session->set('name', $user->name);
            $this->session->set('username', $user->username);
            $this->flashSession->notice('Profile berhasil diperbarui.');
         } else {
            foreach ($user->getMessages() as $message) {
               $this->flashSession->error((string) $message);
            }
         }
      } catch (\Exception $e) {
         $this->flashSession->error($e->getMessage());
      }
      
      return $this->response->redirect('profile');
   }
}