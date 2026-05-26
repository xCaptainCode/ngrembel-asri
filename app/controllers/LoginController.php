<?php

use Phalcon\Mvc\View;
use Member;

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
         $sql = "SELECT id, no_member, nama, no_hp, email, role
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
         $this->session->set('role', $result['role']);
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
      if ($this->session->has('id')) {
         return $this->response->redirect('');
      }
      $this->view->pick("login/forgot");
      $this->view->setRenderLevel(View::LEVEL_ACTION_VIEW);
   }

   public function kirimLinkAction() {
      $this->view->disable();

      if (!$this->request->isPost()) {
         return $this->response->redirect('lupa-password');
      }

      $email = trim($this->request->getPost('email', 'email'));

      if ($email === '' || !filter_var($email, FILTER_VALIDATE_EMAIL)) {
         $this->session->set('forgot_error', 'Format email tidak valid.');
         return $this->response->redirect('lupa-password');
      }

      try {
         $member = Member::findFirst([
            'conditions' => 'email = :email: AND is_active = TRUE',
            'bind' => ['email' => $email]
         ]);

         if ($member) {
            $token = bin2hex(random_bytes(32));
            
            $sql = "INSERT INTO password_resets (email, token, expired_at)
                    VALUES (:email, :token, NOW() + INTERVAL '1 hour')";
            
            $this->db->execute($sql, [
               'email' => $email,
               'token' => $token
            ]);

            $protocol = $this->request->getScheme() . '://';
            $host = $this->request->getHttpHost();
            $baseUri = $this->url->getBaseUri();
            
            $link = $protocol . $host . rtrim($baseUri, '/') . '/reset-password?token=' . $token;

            $subject = 'Reset Password Akun Member Ngrembel Asri';
            $body = '
               <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 20px; border: 1px solid #c8a84b; border-radius: 10px; background-color: #fcfcfc;">
                  <h2 style="color: #0d2416; text-align: center;">Pemulihan Password</h2>
                  <p>Halo,</p>
                  <p>Kami menerima permintaan untuk mengatur ulang password akun member Ngrembel Asri Anda.</p>
                  <p>Silakan klik tautan di bawah ini untuk mengatur ulang password Anda:</p>
                  <p style="text-align: center; margin: 30px 0;">
                     <a href="' . $link . '" style="background: linear-gradient(135deg, #c8a84b, #e8cc7a); color: #0d2416; padding: 12px 24px; text-decoration: none; border-radius: 20px; font-weight: bold; display: inline-block;">Reset Password</a>
                  </p>
                  <p>Tautan ini hanya akan aktif selama <strong>1 jam</strong>.</p>
                  <p>Jika Anda tidak merasa mengajukan permintaan ini, silakan abaikan email ini.</p>
                  <hr style="border: 0; border-top: 1px solid #eee; margin: 20px 0;">
                  <p style="font-size: 12px; color: #777; text-align: center;">Ngrembel Asri - Jl. Raya Manyaran - Gunungpati Km. 10 Semarang</p>
               </div>
            ';

            Helpers::sendMail($email, $subject, $body);
         }

         $this->session->set('forgot_success', 'Instruksi pemulihan telah dikirim ke email Anda jika terdaftar.');
      } catch (\Throwable $e) {
         $this->session->set('forgot_error', 'Terjadi kesalahan: ' . $e->getMessage());
      }

      return $this->response->redirect('lupa-password');
   }

   public function tampilkanFormAction() {
      if ($this->session->has('id')) {
         return $this->response->redirect('');
      }

      $token = trim($this->request->getQuery('token', 'string'));

      if ($token === '') {
         $this->session->set('forgot_error', 'Token reset password tidak ditemukan.');
         return $this->response->redirect('lupa-password');
      }

      try {
         $sql = "SELECT email, expired_at, is_used
                 FROM password_resets
                 WHERE token = :token
                 LIMIT 1";
         
         $reset = $this->db->fetchOne($sql, \Phalcon\Db::FETCH_ASSOC, ['token' => $token]);

         if (!$reset) {
            $this->session->set('forgot_error', 'Token tidak valid.');
            return $this->response->redirect('lupa-password');
         }

         if ($reset['is_used']) {
            $this->session->set('forgot_error', 'Token ini sudah pernah digunakan.');
            return $this->response->redirect('lupa-password');
         }

         if (strtotime($reset['expired_at']) < time()) {
            $this->session->set('forgot_error', 'Token reset password sudah kedaluwarsa.');
            return $this->response->redirect('lupa-password');
         }

         $this->view->setVar('token', $token);
         $this->view->pick("login/reset");
         $this->view->setRenderLevel(View::LEVEL_ACTION_VIEW);

      } catch (\Throwable $e) {
         $this->session->set('forgot_error', 'Terjadi kesalahan: ' . $e->getMessage());
         return $this->response->redirect('lupa-password');
      }
   }

   public function prosesResetAction() {
      $this->view->disable();

      if (!$this->request->isPost()) {
         return $this->response->redirect('lupa-password');
      }

      $token           = trim($this->request->getPost('token', 'string'));
      $password        = (string)$this->request->getPost('password');
      $confirmPassword = (string)$this->request->getPost('confirm_password');

      if ($password === '' || $confirmPassword === '') {
         $this->session->set('reset_error', 'Semua field password wajib diisi.');
         return $this->response->redirect('reset-password?token=' . $token);
      }

      if (strlen($password) < 8) {
         $this->session->set('reset_error', 'Password minimal terdiri dari 8 karakter.');
         return $this->response->redirect('reset-password?token=' . $token);
      }

      if ($password !== $confirmPassword) {
         $this->session->set('reset_error', 'Password dan Konfirmasi Password tidak cocok.');
         return $this->response->redirect('reset-password?token=' . $token);
      }

      try {
         $sql = "SELECT email, expired_at, is_used
                 FROM password_resets
                 WHERE token = :token
                 LIMIT 1";
         
         $reset = $this->db->fetchOne($sql, \Phalcon\Db::FETCH_ASSOC, ['token' => $token]);

         if (!$reset || $reset['is_used'] || strtotime($reset['expired_at']) < time()) {
            $this->session->set('forgot_error', 'Token pemulihan tidak valid atau sudah kedaluwarsa.');
            return $this->response->redirect('lupa-password');
         }

         $sqlUpdate = "UPDATE members
                       SET password = crypt(:password, gen_salt('bf'))
                       WHERE email = :email";
         
         $this->db->execute($sqlUpdate, [
            'password' => $password,
            'email'    => $reset['email']
         ]);

         $sqlToken = "UPDATE password_resets
                      SET is_used = TRUE
                      WHERE token = :token";
         
         $this->db->execute($sqlToken, ['token' => $token]);

         $this->session->set('reset_success', 'Password Anda telah berhasil diperbarui. Silakan masuk menggunakan password baru.');
         return $this->response->redirect('login');

      } catch (\Throwable $e) {
         $this->session->set('reset_error', 'Terjadi kesalahan: ' . $e->getMessage());
         return $this->response->redirect('reset-password?token=' . $token);
      }
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
         // Cek apakah sudah terdaftar di members
         $existingMember = Member::findFirst([
            'conditions' => 'email = :email: OR no_hp = :no_hp:',
            'bind' => [
               'email' => $email,
               'no_hp' => $noHp,
            ],
         ]);

         if ($existingMember) {
            $this->session->set('login_error', 'Registrasi gagal: email atau nomor telepon sudah terdaftar sebagai member.');
            return $this->response->redirect('registrasi');
         }

         // Cek apakah ada pendaftaran dengan email/no_hp yang sama berstatus pending
         $existingReg = Registrasi::findFirst([
            'conditions' => '(email = :email: OR no_hp = :no_hp:) AND status = :status:',
            'bind' => [
               'email' => $email,
               'no_hp' => $noHp,
               'status' => 'pending',
            ],
         ]);

         if ($existingReg) {
            $this->session->set('login_error', 'Registrasi gagal: email atau nomor telepon sudah diajukan dan sedang menunggu persetujuan admin.');
            return $this->response->redirect('registrasi');
         }

         // Masukkan ke tabel registrasi dengan status 'pending', role 'member', is_active = TRUE
         $sql = "INSERT INTO registrasi (nama, no_hp, email, tgl_lahir, gender, kota, alamat, password, status, role, is_active)
                 VALUES (:nama, :no_hp, :email, :tgl_lahir, :gender, :kota, :alamat, crypt(:password, gen_salt('bf')), 'pending', 'member', TRUE)";

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

         $this->session->set('registrasi_success', 'Pendaftaran berhasil dikirim! Akun Anda sedang ditinjau oleh Admin. Silakan tunggu hingga diaktifkan.');
      } catch (\Throwable $e) {
         $this->session->set('login_error', 'Registrasi gagal: ' . $e->getMessage());
         return $this->response->redirect('registrasi');
      }

      return $this->response->redirect('login');
   }
}
