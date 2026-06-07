<?php

use Phalcon\Mvc\Controller;

class MemberController extends Controller {

   public function beforeExecuteRoute() {
      if (!$this->session->get('id')) {
         $this->response->redirect('login');
         return false;
      }
      return true;
   }

   public function profileAction() {
      $memberId = (string) $this->session->get('id');

      $member = $this->db->fetchOne(
         "SELECT id, no_member, nama, email, no_hp, tgl_lahir, gender, kota, alamat
          FROM members
          WHERE id = :id AND is_active = TRUE
          LIMIT 1",
         \Phalcon\Db::FETCH_ASSOC,
         ['id' => $memberId]
      );

      if (!$member) {
         $this->session->destroy();
         return $this->response->redirect('login');
      }

      $pointResult = $this->db->fetchOne(
         "SELECT COALESCE(SUM(
            CASE WHEN jenis_poin = 'keluar' THEN -point ELSE point END
         ), 0) AS total_point
          FROM poin_transaksi
          WHERE member_id = :member_id",
         \Phalcon\Db::FETCH_ASSOC,
         ['member_id' => $memberId]
      );

      $totalPoint = $pointResult ? (int) $pointResult['total_point'] : 0;

      $tglLahirFormatted = '';
      if (!empty($member['tgl_lahir'])) {
         $tglLahirFormatted = Helpers::formatDateTime($member['tgl_lahir'], 'j F Y');
      }

      $genderLabel = '';
      if ($member['gender'] === 'L') {
         $genderLabel = 'Laki-laki';
      } elseif ($member['gender'] === 'P') {
         $genderLabel = 'Perempuan';
      }

      $this->view->setVar('member', $member);
      $this->view->setVar('totalPoint', $totalPoint);
      $this->view->setVar('tglLahirFormatted', $tglLahirFormatted);
      $this->view->setVar('genderLabel', $genderLabel);
   }

   public function historyAction() {
      $memberId = (string) $this->session->get('id');

      $totalPointResult = $this->db->fetchOne(
         "SELECT COALESCE(SUM(
            CASE WHEN jenis_poin = 'keluar' THEN -point ELSE point END
         ), 0) AS total_point
          FROM poin_transaksi
          WHERE member_id = :member_id",
         \Phalcon\Db::FETCH_ASSOC,
         ['member_id' => $memberId]
      );

      $perPage     = 10;
      $currentPage = max(1, (int) $this->request->getQuery('page', 'int', 1));

      $countResult = $this->db->fetchOne(
         'SELECT COUNT(*) AS total FROM poin_transaksi WHERE member_id = :member_id',
         \Phalcon\Db::FETCH_ASSOC,
         ['member_id' => $memberId]
      );

      $totalTransactions = $countResult ? (int) $countResult['total'] : 0;
      $totalPages        = max(1, (int) ceil($totalTransactions / $perPage));

      if ($currentPage > $totalPages) {
         $currentPage = $totalPages;
      }

      $offset = ($currentPage - 1) * $perPage;

      $transactions = $this->db->fetchAll(
         'SELECT *
          FROM poin_transaksi
          WHERE member_id = :member_id
          ORDER BY tgl_transaksi DESC NULLS LAST, created_at DESC
          LIMIT ' . $perPage . ' OFFSET ' . $offset,
         \Phalcon\Db::FETCH_ASSOC,
         ['member_id' => $memberId]
      );

      $this->view->setVar('totalPoint', $totalPointResult ? (int) $totalPointResult['total_point'] : 0);
      $this->view->setVar('transactions', $transactions ?: []);
      $this->view->setVar('currentPage', $currentPage);
      $this->view->setVar('totalPages', $totalPages);
      $this->view->setVar('totalTransactions', $totalTransactions);
      $this->view->setVar('perPage', $perPage);
      $this->view->setVar('historyError', $this->session->get('history_error'));
      $this->session->remove('history_error');
   }

   public function order_detailAction() {
      $jenis = strtoupper(trim((string) $this->dispatcher->getParam('jenis', 'string')));
      $kodeOrder = trim((string) $this->dispatcher->getParam('kode_order', 'string'));
      $memberId = (string) $this->session->get('id');
      $historyPage = max(1, (int) $this->request->getQuery('page', 'int', 1));

      if ($jenis === '' || $kodeOrder === '' || $memberId === '') {
         return $this->response->redirect('member-history');
      }

      $owned = $this->db->fetchOne(
         'SELECT id FROM poin_transaksi
          WHERE member_id = :member_id
            AND kode_order = :kode_order
            AND UPPER(kategori) = :jenis
          LIMIT 1',
         \Phalcon\Db::FETCH_ASSOC,
         [
            'member_id' => $memberId,
            'kode_order' => $kodeOrder,
            'jenis' => $jenis,
         ]
      );

      if (! $owned) {
         $this->session->set('history_error', 'Anda tidak memiliki akses ke detail order tersebut.');
         return $this->response->redirect('member-history');
      }

      $order = $this->db->fetchOne(
         'SELECT * FROM orders WHERE kode_order = :kode_order AND jenis = :jenis LIMIT 1',
         \Phalcon\Db::FETCH_ASSOC,
         ['kode_order' => $kodeOrder, 'jenis' => $jenis]
      );

      $items = [];
      if ($order) {
         $items = $this->db->fetchAll(
            'SELECT * FROM order_items
             WHERE kode_order = :kode_order AND jenis = :jenis
             ORDER BY item ASC',
            \Phalcon\Db::FETCH_ASSOC,
            ['kode_order' => $kodeOrder, 'jenis' => $jenis]
         ) ?: [];
      }

      $this->view->pick('settings/order_detail');
      $this->view->setVar('order', $order ?: null);
      $this->view->setVar('items', $items);
      $this->view->setVar('jenis', $jenis);
      $this->view->setVar('kodeOrder', $kodeOrder);
      $this->view->setVar('memberId', '');
      $this->view->setVar('returnTo', 'history');
      $this->view->setVar('historyPage', $historyPage);
   }

   public function updateFieldAction() {
      $this->view->disable();

      if (!$this->request->isPost()) {
         return $this->jsonResponse(false, 'Metode tidak diizinkan.');
      }

      $memberId = (string) $this->session->get('id');
      $field    = trim((string) $this->request->getPost('field', 'string'));
      $value    = trim((string) $this->request->getPost('value', 'string'));

      $allowedFields = ['nama', 'no_hp', 'email', 'tgl_lahir', 'gender', 'kota', 'alamat', 'password'];

      if (!in_array($field, $allowedFields, true)) {
         return $this->jsonResponse(false, 'Field tidak valid.');
      }

      if ($value === '') {
         return $this->jsonResponse(false, 'Field tidak boleh kosong.');
      }

      try {
         switch ($field) {
            case 'nama':
               if (strlen($value) < 2) {
                  return $this->jsonResponse(false, 'Nama minimal 2 karakter.');
               }
               $this->updateMemberField($memberId, 'nama', $value);
               $this->session->set('nama', $value);
               return $this->jsonResponse(true, 'Nama berhasil diperbarui.', ['display' => $value]);

            case 'no_hp':
               if (!preg_match('/^[0-9+\-\s]{8,20}$/', $value)) {
                  return $this->jsonResponse(false, 'Format nomor HP tidak valid.');
               }
               if ($this->isDuplicate($memberId, 'no_hp', $value)) {
                  return $this->jsonResponse(false, 'Nomor HP sudah terdaftar.');
               }
               $this->updateMemberField($memberId, 'no_hp', $value);
               $this->session->set('no_hp', $value);
               return $this->jsonResponse(true, 'No. HP berhasil diperbarui.', ['display' => $value]);

            case 'email':
               if (!filter_var($value, FILTER_VALIDATE_EMAIL)) {
                  return $this->jsonResponse(false, 'Format email tidak valid.');
               }
               if ($this->isDuplicate($memberId, 'email', $value)) {
                  return $this->jsonResponse(false, 'Email sudah terdaftar.');
               }
               $this->updateMemberField($memberId, 'email', $value);
               $this->session->set('email', $value);
               return $this->jsonResponse(true, 'Email berhasil diperbarui.', ['display' => $value]);

            case 'tgl_lahir':
               $date = \DateTime::createFromFormat('Y-m-d', $value);
               if (!$date || $date->format('Y-m-d') !== $value) {
                  return $this->jsonResponse(false, 'Format tanggal tidak valid.');
               }
               $this->updateMemberField($memberId, 'tgl_lahir', $value);
               $formatted = Helpers::formatDateTime($value, 'j F Y');
               return $this->jsonResponse(true, 'Tanggal lahir berhasil diperbarui.', [
                  'display' => $formatted,
                  'raw'     => $value,
               ]);

            case 'gender':
               if (!in_array($value, ['L', 'P'], true)) {
                  return $this->jsonResponse(false, 'Jenis kelamin tidak valid.');
               }
               $this->updateMemberField($memberId, 'gender', $value);
               $label = $value === 'L' ? 'Laki-laki' : 'Perempuan';
               return $this->jsonResponse(true, 'Jenis kelamin berhasil diperbarui.', [
                  'display' => $label,
                  'raw'     => $value,
               ]);

            case 'kota':
               $this->updateMemberField($memberId, 'kota', $value);
               return $this->jsonResponse(true, 'Kota berhasil diperbarui.', ['display' => $value]);

            case 'alamat':
               $this->updateMemberField($memberId, 'alamat', $value);
               return $this->jsonResponse(true, 'Alamat berhasil diperbarui.', ['display' => $value]);

            case 'password':
               if (strlen($value) < 8) {
                  return $this->jsonResponse(false, 'Password minimal 8 karakter.');
               }
               $this->db->execute(
                  "UPDATE members SET password = crypt(:password, gen_salt('bf')) WHERE id = :id",
                  ['password' => $value, 'id' => $memberId]
               );
               return $this->jsonResponse(true, 'Password berhasil diperbarui.', ['display' => '••••••••']);

            default:
               return $this->jsonResponse(false, 'Field tidak valid.');
         }
      } catch (\Throwable $e) {
         return $this->jsonResponse(false, 'Gagal menyimpan: ' . $e->getMessage());
      }
   }

   private function updateMemberField($memberId, $column, $value) {
      $allowed = ['nama', 'no_hp', 'email', 'tgl_lahir', 'gender', 'kota', 'alamat'];
      if (!in_array($column, $allowed, true)) {
         throw new \InvalidArgumentException('Kolom tidak valid.');
      }

      $sql = "UPDATE members SET {$column} = :value WHERE id = :id";
      $this->db->execute($sql, ['value' => $value, 'id' => $memberId]);
   }

   private function isDuplicate($memberId, $column, $value) {
      $allowed = ['email', 'no_hp'];
      if (!in_array($column, $allowed, true)) {
         return false;
      }

      $row = $this->db->fetchOne(
         "SELECT id FROM members WHERE {$column} = :value AND id <> :id LIMIT 1",
         \Phalcon\Db::FETCH_ASSOC,
         ['value' => $value, 'id' => $memberId]
      );

      return (bool) $row;
   }

   private function jsonResponse($success, $message, $extra = []) {
      $payload = array_merge(['success' => $success, 'message' => $message], $extra);
      $this->response->setContentType('application/json', 'UTF-8');
      $this->response->setJsonContent($payload);
      return $this->response;
   }
}
