<?php

use Phalcon\Mvc\View;

class LoginController extends \Phalcon\Mvc\Controller {

   public function indexAction() {
      $this->view->pick("login/index");
      $this->view->setRenderLevel(View::LEVEL_ACTION_VIEW);

   }

   public function prosesAction() {
      $this->view->disable();

      if (! $this->request->isPost()) {
         return $this->response->redirect('login');
      }

      $email    = trim($this->request->getPost("txtemail", "email"));
      $password = (string) $this->request->getPost("txtpassword");

      if ($email === '' || $password === '') {
         // Tampilkan error via SweetAlert di redirect (simpan ke session dulu)
         $this->session->set('login_error', 'Email dan password wajib diisi.');
         return $this->response->redirect('login');
      }

      try {
         // Verifikasi password langsung di query menggunakan crypt() PostgreSQL
         $sql = "SELECT id, no_member, nama, no_hp, email
            FROM members
            WHERE email = :email
              AND password = crypt(:password, password)
              AND is_active = TRUE
            LIMIT 1
        ";

         $result = $this->db->fetchOne($sql, \Phalcon\Db::FETCH_ASSOC, ["email" => $email, "password" => $password]);

         if (! $result) {
            $this->session->set('login_error', 'Email atau password salah, atau akun tidak aktif.');
            return $this->response->redirect('login');
         }

         // Set session dari data member
         $this->session->set('id', $result['id']);
         $this->session->set('nama', $result['nama']);
         $this->session->set('no_member', $result['no_member']);
         $this->session->set('no_hp', $result['no_hp']);
         $this->session->set('email', $result['email']);
         $this->session->set('user_photo', $result['id'] . '.png');

      } catch (\Throwable $e) {
         $this->session->set('login_error', 'Terjadi kesalahan: ' . $e->getMessage());
         return $this->response->redirect('login');
      }

      return $this->response->redirect('');
   }

   public function logoutAction() {
      $this->view->disable();
      $this->session->destroy();
      $this->response->redirect('login');
   }

   public function forgotAction() {
      $this->view->pick("login/forgot");
      $this->view->setRenderLevel(View::LEVEL_ACTION_VIEW);
   }

   public function registrasiAction() {
      $this->view->pick("login/registrasi");
      $this->view->setRenderLevel(View::LEVEL_ACTION_VIEW);
   }

   public function prosesRegistrasiAction() {
      $this->view->disable();

      if (!$this->request->isPost()) {
         return $this->response->redirect('registrasi');
      }

      $nama = trim($this->request->getPost('name', 'string'));
      $noHp = trim($this->request->getPost('no_hp', 'string'));
      $email = trim($this->request->getPost('email', 'email'));
      $tglLahir = $this->request->getPost('tgl_lahir', 'string');
      $gender = trim($this->request->getPost('gender', 'string'));
      $kota = trim($this->request->getPost('kota', 'string'));
      $alamat = trim($this->request->getPost('alamat', 'string'));
      $password = (string) $this->request->getPost('password');

      if ($nama === '' || $noHp === '' || $email === '' || $tglLahir === '' || $gender === '' || $kota === '' || $alamat === '' || $password === '') {
         $this->session->set('login_error', 'Registrasi gagal: semua data wajib diisi.');
         return $this->response->redirect('registrasi');
      }

      if (!in_array($gender, ['L', 'P'], true)) {
         $this->session->set('login_error', 'Registrasi gagal: pilihan jenis kelamin tidak valid.');
         return $this->response->redirect('registrasi');
      }

      try {
         $existing = Member::findFirst([
            'conditions' => 'email = :email: OR no_hp = :no_hp:',
            'bind' => [
               'email' => $email,
               'no_hp' => $noHp,
            ],
         ]);

         if ($existing) {
            $this->session->set('login_error', 'Registrasi gagal: email atau nomor telepon sudah terdaftar.');
            return $this->response->redirect('registrasi');
         }

         $sql = "INSERT INTO members (nama, no_hp, email, tgl_lahir, gender, kota, alamat, password, is_active)
                 VALUES (:nama, :no_hp, :email, :tgl_lahir, :gender, :kota, :alamat, crypt(:password, gen_salt('bf')), TRUE)";

         $this->db->execute($sql, [
            'nama' => $nama,
            'no_hp' => $noHp,
            'email' => $email,
            'tgl_lahir' => $tglLahir,
            'gender' => $gender,
            'kota' => $kota,
            'alamat' => $alamat,
            'password' => $password,
         ]);
      } catch (\Throwable $e) {
         $this->session->set('login_error', 'Registrasi gagal: ' . $e->getMessage());
         return $this->response->redirect('registrasi');
      }

      return $this->response->redirect('login');
   }
}
