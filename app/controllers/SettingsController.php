<?php

use Phalcon\Mvc\Controller;
use Intervention\Image\ImageManagerStatic as Image;

class SettingsController extends Controller {
   private $galleryOriginalDir;
   private $galleryThumbSmDir;
   private $galleryThumbMdDir;
   private $galleryPosterDir;

   public function initialize() {
      $this->galleryOriginalDir = BASE_PATH . '/public/storage/originals/';
      $this->galleryThumbSmDir  = BASE_PATH . '/public/storage/thumbnails/sm/';
      $this->galleryThumbMdDir  = BASE_PATH . '/public/storage/thumbnails/md/';
      $this->galleryPosterDir   = BASE_PATH . '/public/storage/thumbnails/posters/';
   }

   public function beforeExecuteRoute() {
      $role = strtolower((string) $this->session->get('role'));
      if (! $this->session->get('id') || $role !== 'admin') {
         $this->response->redirect('');
         return false;
      }
      return true;
   }

   public function memberAction() {
      // Retrieve query parameters
      $search  = trim((string) $this->request->getQuery('search', 'string', ''));
      $page    = max(1, (int) $this->request->getQuery('page', 'int', 1));
      $perPage = (int) $this->request->getQuery('per_page', 'int', 10);

      if (!in_array($perPage, [10, 25, 50], true)) {
          $perPage = 10;
      }

      $whereClause = '';
      $params = [];

      if ($search !== '') {
          $whereClause = "WHERE (m.nama ILIKE :search 
                          OR m.email ILIKE :search 
                          OR m.no_hp ILIKE :search 
                          OR m.no_member ILIKE :search)";
          $params['search'] = '%' . $search . '%';
      }

      // Count total members matching criteria
      $countResult = $this->db->fetchOne(
          "SELECT COUNT(*) AS total FROM members m {$whereClause}",
          \Phalcon\Db::FETCH_ASSOC,
          $params
      );
      $totalMembers = $countResult ? (int) $countResult['total'] : 0;
      $totalPages = max(1, (int) ceil($totalMembers / $perPage));

      if ($page > $totalPages) $page = $totalPages;
      $offset = ($page - 1) * $perPage;

      // Fetch members for current page
      $params['limit'] = $perPage;
      $params['offset'] = $offset;
      $members = $this->db->fetchAll(
          "SELECT m.*,
                  COALESCE(pt_agg.total_point, 0) AS total_point
           FROM members m
           LEFT JOIN (
              SELECT member_id,
                     SUM(
                        CASE
                           WHEN jenis_poin = 'keluar' THEN -point
                           ELSE point
                        END
                     ) AS total_point
              FROM poin_transaksi
              GROUP BY member_id
           ) pt_agg ON pt_agg.member_id = m.id
           {$whereClause}
           ORDER BY m.nama ASC
           LIMIT :limit OFFSET :offset",
          \Phalcon\Db::FETCH_ASSOC,
          $params
      );

      // Pending registrations count
      $pendingCountResult = $this->db->fetchOne(
          "SELECT COUNT(*) AS total FROM registrasi WHERE status = 'pending'",
          \Phalcon\Db::FETCH_ASSOC
      );
      $pendingCount = $pendingCountResult ? (int) $pendingCountResult['total'] : 0;

      // Pass variables to view
      $this->view->setVar('members', $members ?: []);
      $this->view->setVar('pendingCount', $pendingCount);
      $this->view->setVar('totalMembers', $totalMembers);
      $this->view->setVar('currentPage', $page);
      $this->view->setVar('perPage', $perPage);
      $this->view->setVar('totalPages', $totalPages);
      $this->view->setVar('search', $search);
      $this->view->setVar('updateSuccess', $this->session->get('member_update_success'));
      $this->view->setVar('updateError', $this->session->get('member_update_error'));
      $this->session->remove('member_update_success');
      $this->session->remove('member_update_error');

      $this->view->setVar('pointImportPreview', $this->session->get('point_import_preview'));
      $this->view->setVar('pointImportSummary', $this->session->get('point_import_summary'));
      $this->view->setVar('pointImportToken', $this->session->get('point_import_token'));
      $this->view->setVar('pointImportFileName', $this->session->get('point_import_original_name'));
      $this->view->setVar('pointImportSuccess', $this->session->get('point_import_success'));
      $this->view->setVar('pointImportError', $this->session->get('point_import_error'));
      $this->session->remove('point_import_success');
      $this->session->remove('point_import_error');
   }

   public function member_point_detailAction() {
      $id = trim((string) $this->dispatcher->getParam('id', 'string'));

      if ($id === '') {
         return $this->response->redirect('settings/member');
      }

      $member = $this->db->fetchOne(
         'SELECT * FROM members WHERE id = :id LIMIT 1',
         \Phalcon\Db::FETCH_ASSOC,
         ['id' => $id]
      );

      if (! $member) {
         $this->session->set('member_update_error', 'Member tidak ditemukan.');
         return $this->response->redirect('settings/member');
      }

      $totalPointResult = $this->db->fetchOne(
         "SELECT COALESCE(SUM(
             CASE WHEN jenis_poin = 'keluar' THEN -point ELSE point END
          ), 0) AS total_point
          FROM poin_transaksi
          WHERE member_id = :member_id",
         \Phalcon\Db::FETCH_ASSOC,
         ['member_id' => $id]
      );

      // Pagination
      $perPage = 5;
      $currentPage = max(1, (int) $this->request->getQuery('page', 'int', 1));

      $countResult = $this->db->fetchOne(
         'SELECT COUNT(*) AS total FROM poin_transaksi WHERE member_id = :member_id',
         \Phalcon\Db::FETCH_ASSOC,
         ['member_id' => $id]
      );
      $totalTransactions = $countResult ? (int) $countResult['total'] : 0;
      $totalPages = max(1, (int) ceil($totalTransactions / $perPage));
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
         ['member_id' => $id]
      );

      $this->view->setVar('member', $member);
      $this->view->setVar('totalPoint', $totalPointResult ? (int) $totalPointResult['total_point'] : 0);
      $this->view->setVar('transactions', $transactions ?: []);
      $this->view->setVar('currentPage', $currentPage);
      $this->view->setVar('totalPages', $totalPages);
      $this->view->setVar('totalTransactions', $totalTransactions);
      $this->view->setVar('perPage', $perPage);
   }

   public function download_member_csvAction() {
      $this->view->disable();

      $search = trim((string) $this->request->getQuery('search', 'string', ''));
      $whereClause = '';
      $params = [];

      if ($search !== '') {
         $whereClause = "WHERE (nama ILIKE :search
                         OR email ILIKE :search
                         OR no_hp ILIKE :search
                         OR no_member ILIKE :search)";
         $params['search'] = '%' . $search . '%';
      }

      $members = $this->db->fetchAll(
         "SELECT nama, email, no_hp, tgl_lahir, gender, alamat, tgl_daftar
          FROM members {$whereClause}
          ORDER BY nama ASC",
         \Phalcon\Db::FETCH_ASSOC,
         $params
      );

      $handle = fopen('php://temp', 'r+');
      if ($handle === false) {
         $this->response->setStatusCode(500);
         return $this->response->setContent('Gagal membuat file CSV.');
      }

      fwrite($handle, "\xEF\xBB\xBF");
      fputcsv($handle, ['nama', 'email', 'no_telp', 'tgl_lahir', 'gender', 'alamat', 'tgl_daftar']);

      foreach ($members ?: [] as $member) {
         $gender = (string) ($member['gender'] ?? '');
         if ($gender === 'L') {
            $gender = 'Laki-laki';
         } elseif ($gender === 'P') {
            $gender = 'Perempuan';
         }

         fputcsv($handle, [
            (string) ($member['nama'] ?? ''),
            (string) ($member['email'] ?? ''),
            (string) ($member['no_hp'] ?? ''),
            $this->formatCsvDate($member['tgl_lahir'] ?? ''),
            $gender,
            (string) ($member['alamat'] ?? ''),
            $this->formatCsvDate($member['tgl_daftar'] ?? ''),
         ]);
      }

      rewind($handle);
      $csv = stream_get_contents($handle);
      fclose($handle);

      $filename = 'data_member_' . date('Y-m-d_His') . '.csv';

      $this->response->setHeader('Content-Type', 'text/csv; charset=UTF-8');
      $this->response->setHeader('Content-Disposition', 'attachment; filename="' . $filename . '"');
      $this->response->setHeader('Cache-Control', 'no-store, no-cache, must-revalidate');
      $this->response->setContent($csv !== false ? $csv : '');

      return $this->response;
   }

   private function formatCsvDate($value) {
      if ($value === null || $value === '') {
         return '';
      }

      $str = trim((string) $value);
      if (preg_match('/^\d{4}-\d{2}-\d{2}/', $str)) {
         return substr($str, 0, 10);
      }

      $timestamp = strtotime($str);
      return $timestamp ? date('Y-m-d', $timestamp) : $str;
   }

   public function upload_point_memberAction() {
      $this->view->disable();

      if (! $this->request->isPost()) {
         return $this->response->redirect('settings/member');
      }

      $this->clearPointImportSession(true);

      if (! $this->request->hasFiles()) {
         $this->session->set('point_import_error', 'File CSV wajib dipilih.');
         return $this->response->redirect('settings/member');
      }

      $upload = null;
      foreach ($this->request->getUploadedFiles() as $file) {
         if ($file->getKey() === 'csv_file') {
            $upload = $file;
            break;
         }
      }
      if (! $upload) {
         $files = $this->request->getUploadedFiles();
         $upload = $files[0] ?? null;
      }

      if (! $upload || $upload->getError() !== UPLOAD_ERR_OK) {
         $this->session->set('point_import_error', 'Upload file gagal. Periksa ukuran file (maks. 5MB).');
         return $this->response->redirect('settings/member');
      }

      $size = (int) $upload->getSize();
      if ($size <= 0 || $size > PointMemberCsvImport::MAX_FILE_BYTES) {
         $this->session->set('point_import_error', 'Ukuran file melebihi batas 5MB atau file kosong.');
         return $this->response->redirect('settings/member');
      }

      $originalName = (string) $upload->getName();
      $extension = strtolower(pathinfo($originalName, PATHINFO_EXTENSION));
      if ($extension !== 'csv') {
         $this->session->set('point_import_error', 'Hanya file berformat .csv yang diperbolehkan.');
         return $this->response->redirect('settings/member');
      }

      $token = bin2hex(random_bytes(16));
      $storedPath = PointMemberCsvImport::storageDir() . DIRECTORY_SEPARATOR . $token . '.csv';

      if (! $upload->moveTo($storedPath)) {
         $this->session->set('point_import_error', 'Gagal menyimpan file sementara.');
         return $this->response->redirect('settings/member');
      }

      try {
         $importer = new PointMemberCsvImport($this->db);
         $rows = $importer->parseFile($storedPath);
         $summary = $importer->buildSummary($rows);

         $previewRows = [];
         foreach ($rows as $row) {
            $previewRows[] = [
               'line' => $row['line'],
               'no_hp' => $row['no_hp'],
               'tgl_transaksi' => $row['tgl_transaksi'],
               'kode_order' => $row['kode_order'],
               'nominal_transaksi' => $row['nominal_transaksi'],
               'jenis_transaksi' => $row['jenis_transaksi'],
               'point' => $row['point'],
               'kategori' => $row['kategori'],
               'member_nama' => $row['member_nama'],
               'status' => $row['status'],
               'message' => $row['message'],
            ];
         }

         $this->session->set('point_import_token', $token);
         $this->session->set('point_import_file', $storedPath);
         $this->session->set('point_import_original_name', $originalName);
         $this->session->set('point_import_preview', $previewRows);
         $this->session->set('point_import_summary', $summary);
      } catch (\Throwable $e) {
         if (is_file($storedPath)) {
            @unlink($storedPath);
         }
         $this->session->set('point_import_error', 'Gagal memproses CSV: ' . $e->getMessage());
      }

      return $this->response->redirect('settings/member#point-import-preview');
   }

   public function confirm_point_member_importAction() {
      $this->view->disable();

      if (! $this->request->isPost()) {
         return $this->response->redirect('settings/member');
      }

      $token = trim((string) $this->request->getPost('import_token', 'string'));
      $sessionToken = (string) $this->session->get('point_import_token');
      $storedPath = (string) $this->session->get('point_import_file');
      $originalName = (string) $this->session->get('point_import_original_name');

      if ($token === '' || $token !== $sessionToken || $storedPath === '' || ! is_file($storedPath)) {
         $this->clearPointImportSession(true);
         $this->session->set('point_import_error', 'Sesi impor tidak valid atau file sudah kedaluwarsa. Upload ulang CSV.');
         return $this->response->redirect('settings/member');
      }

      try {
         $importer = new PointMemberCsvImport($this->db);
         $rows = $importer->parseFile($storedPath);
         $result = $importer->importReadyRows(
            $rows,
            $this->getPointImportActor(),
            $originalName !== '' ? $originalName : basename($storedPath)
         );

         $this->clearPointImportSession(true);

         $this->session->set(
            'point_import_success',
            sprintf(
               'Impor selesai: %d data masuk DB, %d duplikat dilewati, %d baris error/ditolak. Log audit tercatat.',
               $result['inserted'],
               $result['skipped_duplicate'],
               $result['skipped_error']
            )
         );
      } catch (\Throwable $e) {
         $this->session->set('point_import_error', 'Gagal mengimpor data: ' . $e->getMessage());
      }

      return $this->response->redirect('settings/member');
   }

   public function cancel_point_member_importAction() {
      $this->view->disable();
      $this->clearPointImportSession(true);
      $this->session->set('point_import_error', 'Impor dibatalkan.');
      return $this->response->redirect('settings/member');
   }

   private function clearPointImportSession($deleteFile = false) {
      if ($deleteFile) {
         $storedPath = (string) $this->session->get('point_import_file');
         if ($storedPath !== '' && is_file($storedPath)) {
            @unlink($storedPath);
         }
      }

      $this->session->remove('point_import_token');
      $this->session->remove('point_import_file');
      $this->session->remove('point_import_original_name');
      $this->session->remove('point_import_preview');
      $this->session->remove('point_import_summary');
   }

   private function getPointImportActor() {
      $nama = trim((string) $this->session->get('nama'));
      $id = trim((string) $this->session->get('id'));
      if ($nama !== '' && $id !== '') {
         return $nama . ' (' . $id . ')';
      }
      if ($nama !== '') {
         return $nama;
      }
      return $id !== '' ? $id : 'admin';
   }

   public function update_memberAction() {
      $this->view->disable();

      if (! $this->request->isPost()) {
         return $this->response->redirect('settings/member');
      }

      $id = trim((string) $this->request->getPost('id', 'string'));
      $nama = trim((string) $this->request->getPost('nama', 'string'));
      $email = trim((string) $this->request->getPost('email', 'email'));
      $noHp = trim((string) $this->request->getPost('no_hp', 'string'));
      $tglLahir = trim((string) $this->request->getPost('tgl_lahir', 'string'));
      $gender = trim((string) $this->request->getPost('gender', 'string'));
      $kota = trim((string) $this->request->getPost('kota', 'string'));
      $alamat = trim((string) $this->request->getPost('alamat', 'string'));
      $role = trim((string) $this->request->getPost('role', 'string'));
      $isActiveVal = trim((string) $this->request->getPost('is_active', 'string'));

      if ($id === '' || $nama === '' || $email === '' || $noHp === '' || $tglLahir === '' || $gender === '' || $kota === '' || $alamat === ''
         || !in_array($role, ['admin', 'member'], true)) {
         $this->session->set('member_update_error', 'Data input member tidak valid.');
         return $this->response->redirect('settings/member');
      }

      if (!in_array($gender, ['L', 'P'], true)) {
         $this->session->set('member_update_error', 'Jenis kelamin tidak valid.');
         return $this->response->redirect('settings/member');
      }

      $isActive = ($isActiveVal === '1');

      try {
         // Cek duplikasi email atau no_hp di members lain
         $duplicate = $this->db->fetchOne(
            "SELECT id FROM members WHERE (email = :email OR no_hp = :no_hp) AND id <> :id LIMIT 1",
            \Phalcon\Db::FETCH_ASSOC,
            ['email' => $email, 'no_hp' => $noHp, 'id' => $id]
         );

         if ($duplicate) {
            $this->session->set('member_update_error', 'Gagal memperbarui: Email atau No HP sudah terdaftar pada member lain.');
            return $this->response->redirect('settings/member');
         }

         // Update data member
         $this->db->execute(
            "UPDATE members
             SET nama = :nama,
                 email = :email,
                 no_hp = :no_hp,
                 tgl_lahir = :tgl_lahir,
                 gender = :gender,
                 kota = :kota,
                 alamat = :alamat,
                 role = :role,
                 is_active = :is_active
             WHERE id = :id",
            [
               'nama' => $nama,
               'email' => $email,
               'no_hp' => $noHp,
               'tgl_lahir' => $tglLahir,
               'gender' => $gender,
               'kota' => $kota,
               'alamat' => $alamat,
               'role' => $role,
               'is_active' => $isActive ? 'TRUE' : 'FALSE',
               'id' => $id
            ]
         );

         $this->session->set('member_update_success', "Data member {$nama} berhasil diperbarui.");
      } catch (\Throwable $e) {
         $this->session->set('member_update_error', 'Gagal memperbarui data member: ' . $e->getMessage());
      }

              // Preserve search and pagination params on redirect
        $search  = $this->request->getQuery('search', 'string', '');
        $page    = $this->request->getQuery('page', 'int', 1);
        $perPage = $this->request->getQuery('per_page', 'int', 10);
        $query   = http_build_query(['search' => $search, 'page' => $page, 'per_page' => $perPage]);
        return $this->response->redirect('settings/member?' . $query);
   }

   public function registrasiAction() {
      // Ambil daftar seluruh pendaftaran dengan status 'pending'
      $pendingList = $this->db->fetchAll(
         "SELECT * FROM registrasi WHERE status = 'pending' ORDER BY tgl_daftar DESC",
         \Phalcon\Db::FETCH_ASSOC
      );

      $this->view->setVar('pendingList', $pendingList ?: []);
      $this->view->setVar('updateSuccess', $this->session->get('registrasi_update_success'));
      $this->view->setVar('updateError', $this->session->get('registrasi_update_error'));
      $this->session->remove('registrasi_update_success');
      $this->session->remove('registrasi_update_error');
   }

   public function approve_registrasiAction() {
      $this->view->disable();

      if (! $this->request->isPost()) {
         return $this->response->redirect('settings/registrasi');
      }

      $id = trim((string) $this->request->getPost('id', 'string'));

      if ($id === '') {
         $this->session->set('registrasi_update_error', 'ID pendaftaran tidak valid.');
         return $this->response->redirect('settings/registrasi');
      }

      try {
         $this->db->begin();

         // Ambil data pendaftaran
         $reg = $this->db->fetchOne(
            "SELECT * FROM registrasi WHERE id = :id AND status = 'pending' LIMIT 1",
            \Phalcon\Db::FETCH_ASSOC,
            ['id' => $id]
         );

         if (! $reg) {
            $this->db->rollback();
            $this->session->set('registrasi_update_error', 'Data pendaftaran tidak ditemukan atau sudah diproses.');
            return $this->response->redirect('settings/registrasi');
         }

         // Cek apakah email/no_hp duplikat di members
         $dupMember = $this->db->fetchOne(
            "SELECT id FROM members WHERE email = :email OR no_hp = :no_hp LIMIT 1",
            \Phalcon\Db::FETCH_ASSOC,
            ['email' => $reg['email'], 'no_hp' => $reg['no_hp']]
         );

         if ($dupMember) {
            $this->db->rollback();
            $this->session->set('registrasi_update_error', 'Gagal menyetujui: Email atau No HP pendaftar sudah terdaftar di tabel member.');
            return $this->response->redirect('settings/registrasi');
         }

         $adminId = $this->session->get('id');

         // 1. Update status registrasi menjadi 'active'
         $this->db->execute(
            "UPDATE registrasi 
             SET status = 'active', 
                 is_active = TRUE, 
                 updated_at = NOW(), 
                 updated_by = :admin_id 
             WHERE id = :id",
            ['id' => $id, 'admin_id' => $adminId]
         );

         // 2. Masukkan ke tabel members (kata sandi sudah di-hash dari registrasi)
         $this->db->execute(
            "INSERT INTO members (nama, no_hp, email, tgl_lahir, gender, kota, alamat, password, is_active, role, tgl_daftar)
             VALUES (:nama, :no_hp, :email, :tgl_lahir, :gender, :kota, :alamat, :password, TRUE, :role, NOW())",
            [
               'nama' => $reg['nama'],
               'no_hp' => $reg['no_hp'],
               'email' => $reg['email'],
               'tgl_lahir' => $reg['tgl_lahir'],
               'gender' => $reg['gender'],
               'kota' => $reg['kota'],
               'alamat' => $reg['alamat'],
               'password' => $reg['password'],
               'role' => $reg['role'] ?: 'member'
            ]
         );

         $this->db->commit();
         $this->session->set('registrasi_update_success', "Pendaftaran {$reg['nama']} berhasil disetujui (ACC) dan diaktifkan sebagai member baru.");
      } catch (\Throwable $e) {
         $this->db->rollback();
         $this->session->set('registrasi_update_error', 'Gagal memproses persetujuan pendaftaran: ' . $e->getMessage());
      }

      return $this->response->redirect('settings/registrasi');
   }

   public function reject_registrasiAction() {
      $this->view->disable();

      if (! $this->request->isPost()) {
         return $this->response->redirect('settings/registrasi');
      }

      $id = trim((string) $this->request->getPost('id', 'string'));

      if ($id === '') {
         $this->session->set('registrasi_update_error', 'ID pendaftaran tidak valid.');
         return $this->response->redirect('settings/registrasi');
      }

      try {
         $adminId = $this->session->get('id');

         // Update status registrasi menjadi 'inactive'
         $this->db->execute(
            "UPDATE registrasi 
             SET status = 'inactive', 
                 is_active = FALSE, 
                 updated_at = NOW(), 
                 updated_by = :admin_id 
             WHERE id = :id",
            ['id' => $id, 'admin_id' => $adminId]
         );

         $this->session->set('registrasi_update_success', "Pendaftaran berhasil ditolak (status diubah menjadi inactive).");
      } catch (\Throwable $e) {
         $this->session->set('registrasi_update_error', 'Gagal memproses penolakan pendaftaran: ' . $e->getMessage());
      }

      return $this->response->redirect('settings/registrasi');
   }

   public function dashboardAction() {
      $search  = trim((string) $this->request->getQuery('search', 'string', ''));
      $page    = max(1, (int) $this->request->getQuery('page', 'int', 1));
      $perPage = (int) $this->request->getQuery('per_page', 'int', 10);

      if (!in_array($perPage, [10, 25, 50], true)) {
         $perPage = 10;
      }

      $whereClause = "";
      $params = [];

      if ($search !== '') {
         $whereClause .= "WHERE (s.name ILIKE :search OR s.value ILIKE :search)";
         $params['search'] = '%' . $search . '%';
      }

      // Count total data matching criteria
      $countResult = $this->db->fetchOne(
         "SELECT COUNT(*) AS total FROM settings s {$whereClause}",
         \Phalcon\Db::FETCH_ASSOC,
         $params
      );
      $totalData = $countResult ? (int) $countResult['total'] : 0;
      $totalPages = max(1, (int) ceil($totalData / $perPage));

      if ($page > $totalPages) $page = $totalPages;
      $offset = ($page - 1) * $perPage;

      // Fetch data for current page
      $params['limit'] = $perPage;
      $params['offset'] = $offset;
      $dashboard = $this->db->fetchAll(
         "SELECT s.*,
               m_created.nama AS created_by_nama,
               m_updated.nama AS updated_by_nama
         FROM settings s
         LEFT JOIN members m_created ON CAST(s.created_by AS TEXT) = CAST(m_created.id AS TEXT)
         LEFT JOIN members m_updated ON CAST(s.updated_by AS TEXT) = CAST(m_updated.id AS TEXT)
         {$whereClause}
         ORDER BY s.id ASC
         LIMIT :limit
         OFFSET :offset",
         \Phalcon\Db::FETCH_ASSOC,
         $params
      );

      $this->view->setVar('dashboard', $dashboard ?: []);
      $this->view->setVar('search', $search);
      $this->view->setVar('currentPage', $page);
      $this->view->setVar('totalPages', $totalPages);
      $this->view->setVar('perPage', $perPage);
      $this->view->setVar('totalData', $totalData);
      $this->view->setVar('updateSuccess', $this->session->get('dashboard_update_success'));
      $this->view->setVar('updateError', $this->session->get('dashboard_update_error'));
      $this->session->remove('dashboard_update_success');
      $this->session->remove('dashboard_update_error');
   }

   public function update_dashboardAction() {
      $this->view->disable();

      if (! $this->request->isPost()) {
         return $this->response->redirect('settings/dashboard');
      }

      $id = trim((string) $this->request->getPost('id', 'string'));
      $name = trim((string) $this->request->getPost('name', 'string'));
      $typeValue = strtoupper(trim((string) $this->request->getPost('type_value', 'string')));
      $value = $this->request->getPost('value');

      $allowedType = ['TEXT', 'FOTO', 'VIDEO'];
      if ($name === '' || ! in_array($typeValue, $allowedType, true)) {
         $this->session->set('dashboard_update_error', 'Data settings tidak valid.');
         return $this->response->redirect('settings/dashboard');
      }

      $normalizedValue = is_string($value) ? trim($value) : '';

      try {
         if ($typeValue === 'FOTO') {
            $fileInfo = $_FILES['image_file'] ?? null;
            if (is_array($fileInfo) && (int) ($fileInfo['error'] ?? UPLOAD_ERR_NO_FILE) !== UPLOAD_ERR_NO_FILE) {
               $uploadError = (int) ($fileInfo['error'] ?? UPLOAD_ERR_NO_FILE);
               if ($uploadError !== UPLOAD_ERR_OK) {
                  $this->session->set('dashboard_update_error', 'Upload gambar gagal. Kode error: ' . $uploadError);
                  return $this->response->redirect('settings/dashboard');
               }

               $tmpName = (string) ($fileInfo['tmp_name'] ?? '');
               $originalName = (string) ($fileInfo['name'] ?? '');
               $fileSize = (int) ($fileInfo['size'] ?? 0);

               if ($tmpName === '' || ! is_uploaded_file($tmpName) || $fileSize <= 0) {
                  $this->session->set('dashboard_update_error', 'File gambar tidak valid.');
                  return $this->response->redirect('settings/dashboard');
               }

               if ($fileSize > (5 * 1024 * 1024)) {
                  $this->session->set('dashboard_update_error', 'Ukuran file maksimal 5MB.');
                  return $this->response->redirect('settings/dashboard');
               }

               $extension = strtolower((string) pathinfo($originalName, PATHINFO_EXTENSION));
               $allowedExtensions = ['jpg', 'jpeg', 'png', 'gif', 'webp'];
               if (! in_array($extension, $allowedExtensions, true)) {
                  $this->session->set('dashboard_update_error', 'Format gambar tidak didukung. Gunakan JPG, JPEG, PNG, GIF, atau WEBP.');
                  return $this->response->redirect('settings/dashboard');
               }

               $targetDir = BASE_PATH . '/public/images';
               if (! is_dir($targetDir)) {
                  @mkdir($targetDir, 0755, true);
               }

               $safePrefix = preg_replace('/[^a-z0-9_]/i', '_', strtolower($name));
               $fileName = $safePrefix . '_' . date('Ymd_His') . '_' . bin2hex(random_bytes(4)) . '.' . $extension;
               $targetPath = $targetDir . '/' . $fileName;
               if (! move_uploaded_file($tmpName, $targetPath)) {
                  $this->session->set('dashboard_update_error', 'Gagal menyimpan file gambar ke server.');
                  return $this->response->redirect('settings/dashboard');
               }

               $normalizedValue = 'images/' . $fileName;
            }

            if ($normalizedValue === '') {
               if ($id !== '') {
                  $existing = $this->db->fetchOne("SELECT value FROM settings WHERE id = :id", \Phalcon\Db::FETCH_ASSOC, ['id' => $id]);
                  $normalizedValue = isset($existing['value']) ? (string) $existing['value'] : '';
               }

               if ($normalizedValue === '') {
                  $this->session->set('dashboard_update_error', 'Nilai gambar wajib diisi untuk tipe FOTO.');
                  return $this->response->redirect('settings/dashboard');
               }
            }
         }

         if ($typeValue !== 'FOTO' && $normalizedValue === '') {
            $normalizedValue = '';
         }

         $userId = (string) $this->session->get('id');
         if ($id === '') {
            $this->db->execute(
               "INSERT INTO settings (type_value, name, value, created_at, created_by, updated_at, updated_by)
                VALUES (:type_value, :name, :value, NOW(), :created_by, NOW(), :updated_by)",
               [
                  'type_value' => $typeValue,
                  'name' => $name,
                  'value' => $normalizedValue,
                  'created_by' => $userId,
                  'updated_by' => $userId,
               ]
            );

            $this->session->set('dashboard_update_success', "Setting {$name} berhasil ditambahkan.");
         } else {
            $this->db->execute(
               "UPDATE settings
                SET type_value = :type_value,
                    name = :name,
                    value = :value,
                    updated_at = NOW(),
                    updated_by = :updated_by
                WHERE id = :id",
               [
                  'type_value' => $typeValue,
                  'name' => $name,
                  'value' => $normalizedValue,
                  'updated_by' => $userId,
                  'id' => $id,
               ]
            );

            $this->session->set('dashboard_update_success', "Setting {$name} berhasil diperbarui.");
         }
      } catch (\Throwable $e) {
         $this->session->set('dashboard_update_error', 'Gagal memperbarui data dashboard: ' . $e->getMessage());
      }

      return $this->response->redirect('settings/dashboard');
   }

   public function price_listAction() {
      $jenisMasakan = $this->db->fetchAll(
         "SELECT j.*,
                m_created.nama AS created_by_nama,
                m_updated.nama AS updated_by_nama
          FROM jenis_masakan j
          LEFT JOIN members m_created ON CAST(j.created_by AS TEXT) = CAST(m_created.id AS TEXT)
          LEFT JOIN members m_updated ON CAST(j.updated_by AS TEXT) = CAST(m_updated.id AS TEXT)
          ORDER BY j.no_urut ASC, j.nama ASC",
         \Phalcon\Db::FETCH_ASSOC
      );

      $priceList = $this->db->fetchAll(
         "SELECT p.*,
                m_created.nama AS created_by_nama,
                m_updated.nama AS updated_by_nama
          FROM price_list p
          LEFT JOIN members m_created ON CAST(p.created_by AS TEXT) = CAST(m_created.id AS TEXT)
          LEFT JOIN members m_updated ON CAST(p.updated_by AS TEXT) = CAST(m_updated.id AS TEXT)
          ORDER BY p.kategori ASC, p.no_urut ASC, p.nama ASC",
         \Phalcon\Db::FETCH_ASSOC
      );

      $this->view->setVar('jenisMasakan', $jenisMasakan ?: []);
      $this->view->setVar('priceList', $priceList ?: []);
      $this->view->setVar('updateSuccess', $this->session->get('price_list_update_success') ?: $this->session->get('jenis_masakan_update_success'));
      $this->view->setVar('updateError', $this->session->get('price_list_update_error') ?: $this->session->get('jenis_masakan_update_error'));
      $this->session->remove('price_list_update_success');
      $this->session->remove('price_list_update_error');
      $this->session->remove('jenis_masakan_update_success');
      $this->session->remove('jenis_masakan_update_error');
   }

   public function update_pricelistAction() {
      $this->view->disable();

      if (! $this->request->isPost()) {
         return $this->response->redirect('settings/price_list');
      }

      $id = (string) $this->request->getPost('id', 'string');
      $kategori = trim((string) $this->request->getPost('kategori', 'string'));
      $nama = trim((string) $this->request->getPost('nama', 'string'));
      $no_urut = (int) $this->request->getPost('no_urut', 'int');
      $is_active = $this->request->getPost('is_active') ? true : false;

      if ($id === '' || $kategori === '' || $nama === '') {
         $this->session->set('price_list_update_error', 'ID, Kategori, dan Nama tidak boleh kosong.');
         return $this->response->redirect('settings/price_list');
      }

      try {
         $imgUrl = null;

         if (isset($_FILES['image_file']) && $_FILES['image_file']['error'] !== UPLOAD_ERR_NO_FILE) {
            $fileInfo = $_FILES['image_file'];
            $uploadError = (int) $fileInfo['error'];

            if ($uploadError !== UPLOAD_ERR_OK) {
               $errorMessage = 'Upload gambar gagal. Kode error: ' . $uploadError;
               if ($uploadError === UPLOAD_ERR_INI_SIZE) {
                  $errorMessage = 'Upload gagal: ukuran file melebihi batas server.';
               }
               $this->session->set('price_list_update_error', $errorMessage);
               return $this->response->redirect('settings/price_list');
            }

            $tmpName = (string) $fileInfo['tmp_name'];
            $originalName = (string) $fileInfo['name'];
            $fileSize = (int) $fileInfo['size'];

            if ($tmpName === '' || ! is_uploaded_file($tmpName) || $fileSize <= 0) {
               $this->session->set('price_list_update_error', 'File gambar tidak valid.');
               return $this->response->redirect('settings/price_list');
            }

            if ($fileSize > (5 * 1024 * 1024)) {
               $this->session->set('price_list_update_error', 'Ukuran file maksimal 5MB.');
               return $this->response->redirect('settings/price_list');
            }

            $extension = strtolower((string) pathinfo($originalName, PATHINFO_EXTENSION));
            $allowedExtensions = ['jpg', 'jpeg', 'png', 'gif', 'webp'];
            if (! in_array($extension, $allowedExtensions, true)) {
               $this->session->set('price_list_update_error', 'Format gambar tidak didukung. Gunakan JPG, JPEG, PNG, GIF, atau WEBP.');
               return $this->response->redirect('settings/price_list');
            }

            $targetDir = BASE_PATH . '/public/images/pricelist';
            if (! is_dir($targetDir)) {
               @mkdir($targetDir, 0755, true);
            }

            $safePrefix = preg_replace('/[^a-z0-9_]/i', '_', strtolower($kategori));
            $fileName = $safePrefix . '_' . date('Ymd_His') . '_' . bin2hex(random_bytes(4)) . '.' . $extension;
            $targetPath = $targetDir . '/' . $fileName;

            if (! move_uploaded_file($tmpName, $targetPath)) {
               $this->session->set('price_list_update_error', 'Gagal menyimpan file gambar ke server.');
               return $this->response->redirect('settings/price_list');
            }
            $imgUrl = 'images/pricelist/' . $fileName;
         }

         $params = [
            'kategori' => $kategori,
            'nama' => $nama,
            'no_urut' => $no_urut,
            'is_active' => $is_active ? 'true' : 'false',
            'updated_by' => (string) $this->session->get('id'),
            'id' => $id,
         ];

         if ($imgUrl !== null) {
            $sql = "UPDATE price_list
                  SET kategori = :kategori, nama = :nama, no_urut = :no_urut, is_active = :is_active, img_url = :img_url, updated_at = NOW(), updated_by = :updated_by
                  WHERE id = :id";
            $params['img_url'] = $imgUrl;
         } else {
            $sql = "UPDATE price_list
                  SET kategori = :kategori, nama = :nama, no_urut = :no_urut, is_active = :is_active, updated_at = NOW(), updated_by = :updated_by
                  WHERE id = :id";
         }

         $this->db->execute($sql, $params);
         $this->session->set('price_list_update_success', "Item {$nama} berhasil diperbarui.");
      } catch (\Throwable $e) {
         $this->session->set('price_list_update_error', 'Gagal memperbarui data price list: ' . $e->getMessage());
      }

      return $this->response->redirect('settings/price_list');
   }

   public function update_jenis_masakanAction() {
      $this->view->disable();

      if (! $this->request->isPost()) {
         return $this->response->redirect('settings/price_list');
      }

      $id = (string) $this->request->getPost('id', 'string');
      $nama = trim((string) $this->request->getPost('nama', 'string'));
      $deskripsi = trim((string) $this->request->getPost('deskripsi', 'string'));
      $no_urut = (int) $this->request->getPost('no_urut', 'int');
      $is_active = $this->request->getPost('is_active') ? true : false;

      if ($id === '' || $nama === '') {
         $this->session->set('jenis_masakan_update_error', 'ID dan Nama tidak boleh kosong.');
         return $this->response->redirect('settings/price_list');
      }

      try {
         $imgUrl = null;

         if (isset($_FILES['image_file']) && $_FILES['image_file']['error'] !== UPLOAD_ERR_NO_FILE) {
            $fileInfo = $_FILES['image_file'];
            $uploadError = (int) $fileInfo['error'];

            if ($uploadError !== UPLOAD_ERR_OK) {
               $errorMessage = 'Upload gambar gagal. Kode error: ' . $uploadError;
               if ($uploadError === UPLOAD_ERR_INI_SIZE) {
                  $errorMessage = 'Upload gagal: ukuran file melebihi batas server.';
               }
               $this->session->set('jenis_masakan_update_error', $errorMessage);
               return $this->response->redirect('settings/price_list');
            }

            $tmpName = (string) $fileInfo['tmp_name'];
            $originalName = (string) $fileInfo['name'];
            $fileSize = (int) $fileInfo['size'];

            if ($tmpName === '' || ! is_uploaded_file($tmpName) || $fileSize <= 0) {
               $this->session->set('jenis_masakan_update_error', 'File gambar tidak valid.');
               return $this->response->redirect('settings/price_list');
            }

            if ($fileSize > (5 * 1024 * 1024)) {
               $this->session->set('jenis_masakan_update_error', 'Ukuran file maksimal 5MB.');
               return $this->response->redirect('settings/price_list');
            }

            $extension = strtolower((string) pathinfo($originalName, PATHINFO_EXTENSION));
            $allowedExtensions = ['jpg', 'jpeg', 'png', 'gif', 'webp'];
            if (! in_array($extension, $allowedExtensions, true)) {
               $this->session->set('jenis_masakan_update_error', 'Format gambar tidak didukung. Gunakan JPG, JPEG, PNG, GIF, atau WEBP.');
               return $this->response->redirect('settings/price_list');
            }

            $targetDir = BASE_PATH . '/public/images/pricelist';
            if (! is_dir($targetDir)) {
               @mkdir($targetDir, 0755, true);
            }

            $safePrefix = 'jenis_masakan';
            $fileName = $safePrefix . '_' . date('Ymd_His') . '_' . bin2hex(random_bytes(4)) . '.' . $extension;
            $targetPath = $targetDir . '/' . $fileName;

            if (! move_uploaded_file($tmpName, $targetPath)) {
               $this->session->set('jenis_masakan_update_error', 'Gagal menyimpan file gambar ke server.');
               return $this->response->redirect('settings/price_list');
            }
            $imgUrl = 'images/pricelist/' . $fileName;
         }

         $params = [
            'nama' => $nama,
            'deskripsi' => $deskripsi,
            'no_urut' => $no_urut,
            'is_active' => $is_active ? 'true' : 'false',
            'updated_by' => (string) $this->session->get('id'),
            'id' => $id,
         ];

         if ($imgUrl !== null) {
            $sql = "UPDATE jenis_masakan
                  SET nama = :nama, deskripsi = :deskripsi, no_urut = :no_urut, is_active = :is_active, img_url = :img_url, updated_at = NOW(), updated_by = :updated_by
                  WHERE id = :id";
            $params['img_url'] = $imgUrl;
         } else {
            $sql = "UPDATE jenis_masakan
                  SET nama = :nama, deskripsi = :deskripsi, no_urut = :no_urut, is_active = :is_active, updated_at = NOW(), updated_by = :updated_by
                  WHERE id = :id";
         }

         $this->db->execute($sql, $params);
         $this->session->set('jenis_masakan_update_success', "Jenis Masakan {$nama} berhasil diperbarui.");
      } catch (\Throwable $e) {
         $this->session->set('jenis_masakan_update_error', 'Gagal memperbarui jenis masakan: ' . $e->getMessage());
      }

      return $this->response->redirect('settings/price_list');
   }

   public function insert_jenis_masakanAction() {
      $this->view->disable();

      if (! $this->request->isPost()) {
         return $this->response->redirect('settings/price_list');
      }

      $nama = trim((string) $this->request->getPost('nama', 'string'));
      $deskripsi = trim((string) $this->request->getPost('deskripsi', 'string'));
      $no_urut = (int) $this->request->getPost('no_urut', 'int');
      $is_active = $this->request->getPost('is_active') ? true : false;

      if ($nama === '') {
         $this->session->set('jenis_masakan_update_error', 'Nama tidak boleh kosong.');
         return $this->response->redirect('settings/price_list');
      }

      try {
         $imgUrl = '';

         if (isset($_FILES['image_file']) && $_FILES['image_file']['error'] !== UPLOAD_ERR_NO_FILE) {
            $fileInfo = $_FILES['image_file'];
            $uploadError = (int) $fileInfo['error'];

            if ($uploadError !== UPLOAD_ERR_OK) {
               $errorMessage = 'Upload gambar gagal. Kode error: ' . $uploadError;
               if ($uploadError === UPLOAD_ERR_INI_SIZE) {
                  $errorMessage = 'Upload gagal: ukuran file melebihi batas server.';
               }
               $this->session->set('jenis_masakan_update_error', $errorMessage);
               return $this->response->redirect('settings/price_list');
            }

            $tmpName = (string) $fileInfo['tmp_name'];
            $originalName = (string) $fileInfo['name'];
            $fileSize = (int) $fileInfo['size'];

            if ($tmpName === '' || ! is_uploaded_file($tmpName) || $fileSize <= 0) {
               $this->session->set('jenis_masakan_update_error', 'File gambar tidak valid.');
               return $this->response->redirect('settings/price_list');
            }

            if ($fileSize > (5 * 1024 * 1024)) {
               $this->session->set('jenis_masakan_update_error', 'Ukuran file maksimal 5MB.');
               return $this->response->redirect('settings/price_list');
            }

            $extension = strtolower((string) pathinfo($originalName, PATHINFO_EXTENSION));
            $allowedExtensions = ['jpg', 'jpeg', 'png', 'gif', 'webp'];
            if (! in_array($extension, $allowedExtensions, true)) {
               $this->session->set('jenis_masakan_update_error', 'Format gambar tidak didukung. Gunakan JPG, JPEG, PNG, GIF, atau WEBP.');
               return $this->response->redirect('settings/price_list');
            }

            $targetDir = BASE_PATH . '/public/images/pricelist';
            if (! is_dir($targetDir)) {
               @mkdir($targetDir, 0755, true);
            }

            $safePrefix = 'jenis_masakan';
            $fileName = $safePrefix . '_' . date('Ymd_His') . '_' . bin2hex(random_bytes(4)) . '.' . $extension;
            $targetPath = $targetDir . '/' . $fileName;

            if (! move_uploaded_file($tmpName, $targetPath)) {
               $this->session->set('jenis_masakan_update_error', 'Gagal menyimpan file gambar ke server.');
               return $this->response->redirect('settings/price_list');
            }
            $imgUrl = 'images/pricelist/' . $fileName;
         }

         $sql = "INSERT INTO jenis_masakan (nama, deskripsi, img_url, no_urut, is_active, created_at, created_by, updated_at, updated_by)
                 VALUES (:nama, :deskripsi, :img_url, :no_urut, :is_active, NOW(), :created_by, NOW(), :updated_by)";

         $this->db->execute($sql, [
            'nama' => $nama,
            'deskripsi' => $deskripsi,
            'img_url' => $imgUrl,
            'no_urut' => $no_urut,
            'is_active' => $is_active ? 'true' : 'false',
            'created_by' => (string) $this->session->get('id'),
            'updated_by' => (string) $this->session->get('id'),
         ]);

         $this->session->set('jenis_masakan_update_success', "Jenis Masakan {$nama} berhasil ditambahkan.");
      } catch (\Throwable $e) {
         $this->session->set('jenis_masakan_update_error', 'Gagal menambahkan jenis masakan baru: ' . $e->getMessage());
      }

      return $this->response->redirect('settings/price_list');
   }

   public function create_pricelistAction() {
      $this->view->disable();

      if (! $this->request->isPost()) {
         return $this->response->redirect('settings/price_list');
      }

      $kategori = trim((string) $this->request->getPost('kategori', 'string'));
      $nama = trim((string) $this->request->getPost('nama', 'string'));
      $no_urut = (int) $this->request->getPost('no_urut', 'int');
      $is_active = $this->request->getPost('is_active') ? true : false;

      if ($kategori === '' || $nama === '') {
         $this->session->set('price_list_update_error', 'Kategori dan Nama tidak boleh kosong.');
         return $this->response->redirect('settings/price_list');
      }

      try {
         $imgUrl = '';

         if (isset($_FILES['image_file']) && $_FILES['image_file']['error'] !== UPLOAD_ERR_NO_FILE) {
            $fileInfo = $_FILES['image_file'];
            $uploadError = (int) $fileInfo['error'];

            if ($uploadError !== UPLOAD_ERR_OK) {
               $errorMessage = 'Upload gambar gagal. Kode error: ' . $uploadError;
               if ($uploadError === UPLOAD_ERR_INI_SIZE) {
                  $errorMessage = 'Upload gagal: ukuran file melebihi batas server.';
               }
               $this->session->set('price_list_update_error', $errorMessage);
               return $this->response->redirect('settings/price_list');
            }

            $tmpName = (string) $fileInfo['tmp_name'];
            $originalName = (string) $fileInfo['name'];
            $fileSize = (int) $fileInfo['size'];

            if ($tmpName === '' || ! is_uploaded_file($tmpName) || $fileSize <= 0) {
               $this->session->set('price_list_update_error', 'File gambar tidak valid.');
               return $this->response->redirect('settings/price_list');
            }

            if ($fileSize > (5 * 1024 * 1024)) {
               $this->session->set('price_list_update_error', 'Ukuran file maksimal 5MB.');
               return $this->response->redirect('settings/price_list');
            }

            $extension = strtolower((string) pathinfo($originalName, PATHINFO_EXTENSION));
            $allowedExtensions = ['jpg', 'jpeg', 'png', 'gif', 'webp'];
            if (! in_array($extension, $allowedExtensions, true)) {
               $this->session->set('price_list_update_error', 'Format gambar tidak didukung. Gunakan JPG, JPEG, PNG, GIF, atau WEBP.');
               return $this->response->redirect('settings/price_list');
            }

            $targetDir = BASE_PATH . '/public/images/pricelist';
            if (! is_dir($targetDir)) {
               @mkdir($targetDir, 0755, true);
            }

            $safePrefix = preg_replace('/[^a-z0-9_]/i', '_', strtolower($kategori));
            $fileName = $safePrefix . '_' . date('Ymd_His') . '_' . bin2hex(random_bytes(4)) . '.' . $extension;
            $targetPath = $targetDir . '/' . $fileName;

            if (! move_uploaded_file($tmpName, $targetPath)) {
               $this->session->set('price_list_update_error', 'Gagal menyimpan file gambar ke server.');
               return $this->response->redirect('settings/price_list');
            }
            $imgUrl = 'images/pricelist/' . $fileName;
         }

         $sql = "INSERT INTO price_list (kategori, nama, img_url, no_urut, is_active, created_at, created_by, updated_at, updated_by)
                 VALUES (:kategori, :nama, :img_url, :no_urut, :is_active, NOW(), :created_by, NOW(), :updated_by)";

         $this->db->execute($sql, [
            'kategori' => $kategori,
            'nama' => $nama,
            'img_url' => $imgUrl,
            'no_urut' => $no_urut,
            'is_active' => $is_active ? 'true' : 'false',
            'created_by' => (string) $this->session->get('id'),
            'updated_by' => (string) $this->session->get('id'),
         ]);

         $this->session->set('price_list_update_success', "Item {$nama} berhasil ditambahkan.");
      } catch (\Throwable $e) {
         $this->session->set('price_list_update_error', 'Gagal menambahkan price list baru: ' . $e->getMessage());
      }

      return $this->response->redirect('settings/price_list');
   }

   public function permainanAction() {
      $search  = trim((string) $this->request->getQuery('search', 'string', ''));
      $page    = max(1, (int) $this->request->getQuery('page', 'int', 1));
      $perPage = (int) $this->request->getQuery('per_page', 'int', 10);

      if (!in_array($perPage, [10, 25, 50], true)) {
          $perPage = 10;
      }

      $whereClause = "WHERE w.kategori = 'PERMAINAN'";
      $params = [];

      if ($search !== '') {
          $whereClause .= " AND (w.nama ILIKE :search OR w.deskripsi ILIKE :search)";
          $params['search'] = '%' . $search . '%';
      }

      // Count total matching
      $countResult = $this->db->fetchOne(
         "SELECT COUNT(*) AS total FROM wahana w {$whereClause}",
         \Phalcon\Db::FETCH_ASSOC,
         $params
      );
      $totalWahana = $countResult ? (int) $countResult['total'] : 0;
      $totalPages = max(1, (int) ceil($totalWahana / $perPage));

      if ($page > $totalPages) $page = $totalPages;
      $offset = ($page - 1) * $perPage;

      // Fetch matching records
      $params['limit'] = $perPage;
      $params['offset'] = $offset;
      $wahanaList = $this->db->fetchAll(
         "SELECT w.*,
                m_created.nama AS created_by_nama,
                m_updated.nama AS updated_by_nama
          FROM wahana w
          LEFT JOIN members m_created ON CAST(w.created_by AS TEXT) = CAST(m_created.id AS TEXT)
          LEFT JOIN members m_updated ON CAST(w.updated_by AS TEXT) = CAST(m_updated.id AS TEXT)
          {$whereClause}
          ORDER BY w.urutan ASC, w.nama ASC
          LIMIT :limit OFFSET :offset",
         \Phalcon\Db::FETCH_ASSOC,
         $params
      );

      $this->view->setVar('wahanaList', $wahanaList ?: []);
      $this->view->setVar('totalWahana', $totalWahana);
      $this->view->setVar('currentPage', $page);
      $this->view->setVar('perPage', $perPage);
      $this->view->setVar('totalPages', $totalPages);
      $this->view->setVar('search', $search);
      $this->view->setVar('updateSuccess', $this->session->get('wahana_update_success'));
      $this->view->setVar('updateError', $this->session->get('wahana_update_error'));
      $this->session->remove('wahana_update_success');
      $this->session->remove('wahana_update_error');
   }

   public function update_wahanaAction() {
      $this->view->disable();

      if (! $this->request->isPost()) {
         return $this->response->redirect('settings/permainan');
      }

      $id = (string) $this->request->getPost('id', 'string');
      $nama = trim((string) $this->request->getPost('nama', 'string'));
      $deskripsi = trim((string) $this->request->getPost('deskripsi', 'string'));
      $is_free = $this->request->getPost('is_free') ? true : false;
      $harga_tiket = $is_free ? 0 : (int) $this->request->getPost('harga_tiket', 'int');
      $urutan = (int) $this->request->getPost('urutan', 'int');
      $is_active = $this->request->getPost('is_active') ? true : false;

      if ($id === '' || $nama === '') {
         $this->session->set('wahana_update_error', 'ID dan Nama tidak boleh kosong.');
         return $this->response->redirect('settings/permainan');
      }

      try {
         $imgUrl = null;

         if (isset($_FILES['image_file']) && $_FILES['image_file']['error'] !== UPLOAD_ERR_NO_FILE) {
            $fileInfo = $_FILES['image_file'];
            $uploadError = (int) $fileInfo['error'];

            if ($uploadError !== UPLOAD_ERR_OK) {
               $errorMessage = 'Upload gambar gagal. Kode error: ' . $uploadError;
               if ($uploadError === UPLOAD_ERR_INI_SIZE) {
                  $errorMessage = 'Upload gagal: ukuran file melebihi batas server.';
               }
               $this->session->set('wahana_update_error', $errorMessage);
               return $this->response->redirect('settings/permainan');
            }

            $tmpName = (string) $fileInfo['tmp_name'];
            $originalName = (string) $fileInfo['name'];
            $fileSize = (int) $fileInfo['size'];

            if ($tmpName === '' || ! is_uploaded_file($tmpName) || $fileSize <= 0) {
               $this->session->set('wahana_update_error', 'File gambar tidak valid.');
               return $this->response->redirect('settings/permainan');
            }

            if ($fileSize > (5 * 1024 * 1024)) {
               $this->session->set('wahana_update_error', 'Ukuran file maksimal 5MB.');
               return $this->response->redirect('settings/permainan');
            }

            $extension = strtolower((string) pathinfo($originalName, PATHINFO_EXTENSION));
            $allowedExtensions = ['jpg', 'jpeg', 'png', 'gif', 'webp'];
            if (! in_array($extension, $allowedExtensions, true)) {
               $this->session->set('wahana_update_error', 'Format gambar tidak didukung. Gunakan JPG, JPEG, PNG, GIF, atau WEBP.');
               return $this->response->redirect('settings/permainan');
            }

            $targetDir = BASE_PATH . '/public/images/wahana';
            if (! is_dir($targetDir)) {
               @mkdir($targetDir, 0755, true);
            }

            $safePrefix = 'wahana_permainan';
            $fileName = $safePrefix . '_' . date('Ymd_His') . '_' . bin2hex(random_bytes(4)) . '.' . $extension;
            $targetPath = $targetDir . '/' . $fileName;

            if (! move_uploaded_file($tmpName, $targetPath)) {
               $this->session->set('wahana_update_error', 'Gagal menyimpan file gambar ke server.');
               return $this->response->redirect('settings/permainan');
            }
            $imgUrl = 'images/wahana/' . $fileName;
         }

         $params = [
            'nama' => $nama,
            'deskripsi' => $deskripsi,
            'is_free' => $is_free ? 'true' : 'false',
            'harga_tiket' => $harga_tiket,
            'urutan' => $urutan,
            'is_active' => $is_active ? 'true' : 'false',
            'updated_by' => (string) $this->session->get('id'),
            'id' => $id,
         ];

         if ($imgUrl !== null) {
            $sql = "UPDATE wahana
                  SET nama = :nama, deskripsi = :deskripsi, is_free = :is_free, harga_tiket = :harga_tiket, urutan = :urutan, is_active = :is_active, img_url = :img_url, updated_at = NOW(), updated_by = :updated_by
                  WHERE id = :id";
            $params['img_url'] = $imgUrl;
         } else {
            $sql = "UPDATE wahana
                  SET nama = :nama, deskripsi = :deskripsi, is_free = :is_free, harga_tiket = :harga_tiket, urutan = :urutan, is_active = :is_active, updated_at = NOW(), updated_by = :updated_by
                  WHERE id = :id";
         }

         $this->db->execute($sql, $params);
         $this->session->set('wahana_update_success', "Wahana {$nama} berhasil diperbarui.");
      } catch (\Throwable $e) {
         $this->session->set('wahana_update_error', 'Gagal memperbarui data wahana: ' . $e->getMessage());
      }

      return $this->response->redirect('settings/permainan');
   }
   public function create_wahanaAction() {
      $this->view->disable();

      if (! $this->request->isPost()) {
         return $this->response->redirect('settings/permainan');
      }

      $nama = trim((string) $this->request->getPost('nama', 'string'));
      $deskripsi = trim((string) $this->request->getPost('deskripsi', 'string'));
      $is_free = $this->request->getPost('is_free') ? true : false;
      $harga_tiket = $is_free ? 0 : (int) $this->request->getPost('harga_tiket', 'int');
      $urutan = (int) $this->request->getPost('urutan', 'int');
      $is_active = $this->request->getPost('is_active') ? true : false;

      if ($nama === '') {
         $this->session->set('wahana_update_error', 'Nama tidak boleh kosong.');
         return $this->response->redirect('settings/permainan');
      }

      try {
         $imgUrl = '';

         if (isset($_FILES['image_file']) && $_FILES['image_file']['error'] !== UPLOAD_ERR_NO_FILE) {
            $fileInfo = $_FILES['image_file'];
            $uploadError = (int) $fileInfo['error'];

            if ($uploadError !== UPLOAD_ERR_OK) {
               $errorMessage = 'Upload gambar gagal. Kode error: ' . $uploadError;
               if ($uploadError === UPLOAD_ERR_INI_SIZE) {
                  $errorMessage = 'Upload gagal: ukuran file melebihi batas server.';
               }
               $this->session->set('wahana_update_error', $errorMessage);
               return $this->response->redirect('settings/permainan');
            }

            $tmpName = (string) $fileInfo['tmp_name'];
            $originalName = (string) $fileInfo['name'];
            $fileSize = (int) $fileInfo['size'];

            if ($tmpName === '' || ! is_uploaded_file($tmpName) || $fileSize <= 0) {
               $this->session->set('wahana_update_error', 'File gambar tidak valid.');
               return $this->response->redirect('settings/permainan');
            }

            if ($fileSize > (5 * 1024 * 1024)) {
               $this->session->set('wahana_update_error', 'Ukuran file maksimal 5MB.');
               return $this->response->redirect('settings/permainan');
            }

            $extension = strtolower((string) pathinfo($originalName, PATHINFO_EXTENSION));
            $allowedExtensions = ['jpg', 'jpeg', 'png', 'gif', 'webp'];
            if (! in_array($extension, $allowedExtensions, true)) {
               $this->session->set('wahana_update_error', 'Format gambar tidak didukung. Gunakan JPG, JPEG, PNG, GIF, atau WEBP.');
               return $this->response->redirect('settings/permainan');
            }

            $targetDir = BASE_PATH . '/public/images/wahana';
            if (! is_dir($targetDir)) {
               @mkdir($targetDir, 0755, true);
            }

            $safePrefix = 'wahana_permainan';
            $fileName = $safePrefix . '_' . date('Ymd_His') . '_' . bin2hex(random_bytes(4)) . '.' . $extension;
            $targetPath = $targetDir . '/' . $fileName;

            if (! move_uploaded_file($tmpName, $targetPath)) {
               $this->session->set('wahana_update_error', 'Gagal menyimpan file gambar ke server.');
               return $this->response->redirect('settings/permainan');
            }
            $imgUrl = 'images/wahana/' . $fileName;
         }

         $sql = "INSERT INTO wahana (kategori, nama, deskripsi, harga_tiket, is_free, urutan, is_active, img_url, created_at, created_by, updated_at, updated_by)
                 VALUES ('PERMAINAN', :nama, :deskripsi, :harga_tiket, :is_free, :urutan, :is_active, :img_url, NOW(), :created_by, NOW(), :updated_by)";

         $this->db->execute($sql, [
            'nama' => $nama,
            'deskripsi' => $deskripsi,
            'harga_tiket' => $harga_tiket,
            'is_free' => $is_free ? 'true' : 'false',
            'urutan' => $urutan,
            'is_active' => $is_active ? 'true' : 'false',
            'img_url' => $imgUrl,
            'created_by' => (string) $this->session->get('id'),
            'updated_by' => (string) $this->session->get('id'),
         ]);

         $this->session->set('wahana_update_success', "Wahana {$nama} berhasil ditambahkan.");
      } catch (\Throwable $e) {
         $this->session->set('wahana_update_error', 'Gagal menambahkan wahana baru: ' . $e->getMessage());
      }

      return $this->response->redirect('settings/permainan');
   }

   public function paintballAction() {
      $search  = trim((string) $this->request->getQuery('search', 'string', ''));
      $page    = max(1, (int) $this->request->getQuery('page', 'int', 1));
      $perPage = (int) $this->request->getQuery('per_page', 'int', 10);

      if (!in_array($perPage, [10, 25, 50], true)) {
          $perPage = 10;
      }

      $whereClause = "WHERE w.kategori = 'PAINTBALL'";
      $params = [];

      if ($search !== '') {
          $whereClause .= " AND (w.nama ILIKE :search OR w.deskripsi ILIKE :search)";
          $params['search'] = '%' . $search . '%';
      }

      // Count total matching
      $countResult = $this->db->fetchOne(
         "SELECT COUNT(*) AS total FROM wahana w {$whereClause}",
         \Phalcon\Db::FETCH_ASSOC,
         $params
      );
      $totalWahana = $countResult ? (int) $countResult['total'] : 0;
      $totalPages = max(1, (int) ceil($totalWahana / $perPage));

      if ($page > $totalPages) $page = $totalPages;
      $offset = ($page - 1) * $perPage;

      // Fetch matching records
      $params['limit'] = $perPage;
      $params['offset'] = $offset;
      $wahanaList = $this->db->fetchAll(
         "SELECT w.*,
                m_created.nama AS created_by_nama,
                m_updated.nama AS updated_by_nama
          FROM wahana w
          LEFT JOIN members m_created ON CAST(w.created_by AS TEXT) = CAST(m_created.id AS TEXT)
          LEFT JOIN members m_updated ON CAST(w.updated_by AS TEXT) = CAST(m_updated.id AS TEXT)
          {$whereClause}
          ORDER BY w.urutan ASC, w.nama ASC
          LIMIT :limit OFFSET :offset",
         \Phalcon\Db::FETCH_ASSOC,
         $params
      );

      $this->view->setVar('wahanaList', $wahanaList ?: []);
      $this->view->setVar('totalWahana', $totalWahana);
      $this->view->setVar('currentPage', $page);
      $this->view->setVar('perPage', $perPage);
      $this->view->setVar('totalPages', $totalPages);
      $this->view->setVar('search', $search);
      $this->view->setVar('updateSuccess', $this->session->get('wahana_update_success'));
      $this->view->setVar('updateError', $this->session->get('wahana_update_error'));
      $this->session->remove('wahana_update_success');
      $this->session->remove('wahana_update_error');
   }

   public function update_paintballAction() {
      $this->view->disable();

      if (! $this->request->isPost()) {
         return $this->response->redirect('settings/paintball');
      }

      $id = (string) $this->request->getPost('id', 'string');
      $nama = trim((string) $this->request->getPost('nama', 'string'));
      $deskripsi = trim((string) $this->request->getPost('deskripsi', 'string'));
      $is_free = $this->request->getPost('is_free') ? true : false;
      $harga_tiket = $is_free ? 0 : (int) $this->request->getPost('harga_tiket', 'int');
      $urutan = (int) $this->request->getPost('urutan', 'int');
      $is_active = $this->request->getPost('is_active') ? true : false;

      if ($id === '' || $nama === '') {
         $this->session->set('wahana_update_error', 'ID dan Nama tidak boleh kosong.');
         return $this->response->redirect('settings/paintball');
      }

      try {
         $imgUrl = null;

         if (isset($_FILES['image_file']) && $_FILES['image_file']['error'] !== UPLOAD_ERR_NO_FILE) {
            $fileInfo = $_FILES['image_file'];
            $uploadError = (int) $fileInfo['error'];

            if ($uploadError !== UPLOAD_ERR_OK) {
               $errorMessage = 'Upload gambar gagal. Kode error: ' . $uploadError;
               if ($uploadError === UPLOAD_ERR_INI_SIZE) {
                  $errorMessage = 'Upload gagal: ukuran file melebihi batas server.';
               }
               $this->session->set('wahana_update_error', $errorMessage);
               return $this->response->redirect('settings/paintball');
            }

            $tmpName = (string) $fileInfo['tmp_name'];
            $originalName = (string) $fileInfo['name'];
            $fileSize = (int) $fileInfo['size'];

            if ($tmpName === '' || ! is_uploaded_file($tmpName) || $fileSize <= 0) {
               $this->session->set('wahana_update_error', 'File gambar tidak valid.');
               return $this->response->redirect('settings/paintball');
            }

            if ($fileSize > (5 * 1024 * 1024)) {
               $this->session->set('wahana_update_error', 'Ukuran file maksimal 5MB.');
               return $this->response->redirect('settings/paintball');
            }

            $extension = strtolower((string) pathinfo($originalName, PATHINFO_EXTENSION));
            $allowedExtensions = ['jpg', 'jpeg', 'png', 'gif', 'webp'];
            if (! in_array($extension, $allowedExtensions, true)) {
               $this->session->set('wahana_update_error', 'Format gambar tidak didukung. Gunakan JPG, JPEG, PNG, GIF, atau WEBP.');
               return $this->response->redirect('settings/paintball');
            }

            $targetDir = BASE_PATH . '/public/images/wahana';
            if (! is_dir($targetDir)) {
               @mkdir($targetDir, 0755, true);
            }

            $safePrefix = 'wahana_paintball';
            $fileName = $safePrefix . '_' . date('Ymd_His') . '_' . bin2hex(random_bytes(4)) . '.' . $extension;
            $targetPath = $targetDir . '/' . $fileName;

            if (! move_uploaded_file($tmpName, $targetPath)) {
               $this->session->set('wahana_update_error', 'Gagal menyimpan file gambar ke server.');
               return $this->response->redirect('settings/paintball');
            }
            $imgUrl = 'images/wahana/' . $fileName;
         }

         $params = [
            'nama' => $nama,
            'deskripsi' => $deskripsi,
            'is_free' => $is_free ? 'true' : 'false',
            'harga_tiket' => $harga_tiket,
            'urutan' => $urutan,
            'is_active' => $is_active ? 'true' : 'false',
            'updated_by' => (string) $this->session->get('id'),
            'id' => $id,
         ];

         if ($imgUrl !== null) {
            $sql = "UPDATE wahana
                  SET nama = :nama, deskripsi = :deskripsi, is_free = :is_free, harga_tiket = :harga_tiket, urutan = :urutan, is_active = :is_active, img_url = :img_url, updated_at = NOW(), updated_by = :updated_by
                  WHERE id = :id";
            $params['img_url'] = $imgUrl;
         } else {
            $sql = "UPDATE wahana
                  SET nama = :nama, deskripsi = :deskripsi, is_free = :is_free, harga_tiket = :harga_tiket, urutan = :urutan, is_active = :is_active, updated_at = NOW(), updated_by = :updated_by
                  WHERE id = :id";
         }

         $this->db->execute($sql, $params);
         $this->session->set('wahana_update_success', "Wahana {$nama} berhasil diperbarui.");
      } catch (\Throwable $e) {
         $this->session->set('wahana_update_error', 'Gagal memperbarui data wahana: ' . $e->getMessage());
      }

      return $this->response->redirect('settings/paintball');
   }

   public function create_paintballAction() {
      $this->view->disable();

      if (! $this->request->isPost()) {
         return $this->response->redirect('settings/paintball');
      }

      $nama = trim((string) $this->request->getPost('nama', 'string'));
      $deskripsi = trim((string) $this->request->getPost('deskripsi', 'string'));
      $is_free = $this->request->getPost('is_free') ? true : false;
      $harga_tiket = $is_free ? 0 : (int) $this->request->getPost('harga_tiket', 'int');
      $urutan = (int) $this->request->getPost('urutan', 'int');
      $is_active = $this->request->getPost('is_active') ? true : false;

      if ($nama === '') {
         $this->session->set('wahana_update_error', 'Nama tidak boleh kosong.');
         return $this->response->redirect('settings/paintball');
      }

      try {
         $imgUrl = '';

         if (isset($_FILES['image_file']) && $_FILES['image_file']['error'] !== UPLOAD_ERR_NO_FILE) {
            $fileInfo = $_FILES['image_file'];
            $uploadError = (int) $fileInfo['error'];

            if ($uploadError !== UPLOAD_ERR_OK) {
               $errorMessage = 'Upload gambar gagal. Kode error: ' . $uploadError;
               if ($uploadError === UPLOAD_ERR_INI_SIZE) {
                  $errorMessage = 'Upload gagal: ukuran file melebihi batas server.';
               }
               $this->session->set('wahana_update_error', $errorMessage);
               return $this->response->redirect('settings/paintball');
            }

            $tmpName = (string) $fileInfo['tmp_name'];
            $originalName = (string) $fileInfo['name'];
            $fileSize = (int) $fileInfo['size'];

            if ($tmpName === '' || ! is_uploaded_file($tmpName) || $fileSize <= 0) {
               $this->session->set('wahana_update_error', 'File gambar tidak valid.');
               return $this->response->redirect('settings/paintball');
            }

            if ($fileSize > (5 * 1024 * 1024)) {
               $this->session->set('wahana_update_error', 'Ukuran file maksimal 5MB.');
               return $this->response->redirect('settings/paintball');
            }

            $extension = strtolower((string) pathinfo($originalName, PATHINFO_EXTENSION));
            $allowedExtensions = ['jpg', 'jpeg', 'png', 'gif', 'webp'];
            if (! in_array($extension, $allowedExtensions, true)) {
               $this->session->set('wahana_update_error', 'Format gambar tidak didukung. Gunakan JPG, JPEG, PNG, GIF, atau WEBP.');
               return $this->response->redirect('settings/paintball');
            }

            $targetDir = BASE_PATH . '/public/images/wahana';
            if (! is_dir($targetDir)) {
               @mkdir($targetDir, 0755, true);
            }

            $safePrefix = 'wahana_paintball';
            $fileName = $safePrefix . '_' . date('Ymd_His') . '_' . bin2hex(random_bytes(4)) . '.' . $extension;
            $targetPath = $targetDir . '/' . $fileName;

            if (! move_uploaded_file($tmpName, $targetPath)) {
               $this->session->set('wahana_update_error', 'Gagal menyimpan file gambar ke server.');
               return $this->response->redirect('settings/paintball');
            }
            $imgUrl = 'images/wahana/' . $fileName;
         }

         $sql = "INSERT INTO wahana (kategori, nama, deskripsi, harga_tiket, is_free, urutan, is_active, img_url, created_at, created_by, updated_at, updated_by)
                 VALUES ('PAINTBALL', :nama, :deskripsi, :harga_tiket, :is_free, :urutan, :is_active, :img_url, NOW(), :created_by, NOW(), :updated_by)";

         $this->db->execute($sql, [
            'nama' => $nama,
            'deskripsi' => $deskripsi,
            'harga_tiket' => $harga_tiket,
            'is_free' => $is_free ? 'true' : 'false',
            'urutan' => $urutan,
            'is_active' => $is_active ? 'true' : 'false',
            'img_url' => $imgUrl,
            'created_by' => (string) $this->session->get('id'),
            'updated_by' => (string) $this->session->get('id'),
         ]);

         $this->session->set('wahana_update_success', "Wahana {$nama} berhasil ditambahkan.");
      } catch (\Throwable $e) {
         $this->session->set('wahana_update_error', 'Gagal menambahkan wahana baru: ' . $e->getMessage());
      }

      return $this->response->redirect('settings/paintball');
   }
   
   public function field_tripAction() {
      $search  = trim((string) $this->request->getQuery('search', 'string', ''));
      $page    = max(1, (int) $this->request->getQuery('page', 'int', 1));
      $perPage = (int) $this->request->getQuery('per_page', 'int', 10);

      if (!in_array($perPage, [10, 25, 50], true)) {
          $perPage = 10;
      }

      $whereClause = "WHERE w.kategori = 'FIELD TRIP'";
      $params = [];

      if ($search !== '') {
          $whereClause .= " AND (w.nama ILIKE :search OR w.deskripsi ILIKE :search)";
          $params['search'] = '%' . $search . '%';
      }

      // Count total matching
      $countResult = $this->db->fetchOne(
         "SELECT COUNT(*) AS total FROM wahana w {$whereClause}",
         \Phalcon\Db::FETCH_ASSOC,
         $params
      );
      $totalWahana = $countResult ? (int) $countResult['total'] : 0;
      $totalPages = max(1, (int) ceil($totalWahana / $perPage));

      if ($page > $totalPages) $page = $totalPages;
      $offset = ($page - 1) * $perPage;

      // Fetch matching records
      $params['limit'] = $perPage;
      $params['offset'] = $offset;
      $wahanaList = $this->db->fetchAll(
         "SELECT w.*,
                m_created.nama AS created_by_nama,
                m_updated.nama AS updated_by_nama
          FROM wahana w
          LEFT JOIN members m_created ON CAST(w.created_by AS TEXT) = CAST(m_created.id AS TEXT)
          LEFT JOIN members m_updated ON CAST(w.updated_by AS TEXT) = CAST(m_updated.id AS TEXT)
          {$whereClause}
          ORDER BY w.urutan ASC, w.nama ASC
          LIMIT :limit OFFSET :offset",
         \Phalcon\Db::FETCH_ASSOC,
         $params
      );

      $this->view->setVar('wahanaList', $wahanaList ?: []);
      $this->view->setVar('totalWahana', $totalWahana);
      $this->view->setVar('currentPage', $page);
      $this->view->setVar('perPage', $perPage);
      $this->view->setVar('totalPages', $totalPages);
      $this->view->setVar('search', $search);
      $this->view->setVar('updateSuccess', $this->session->get('wahana_update_success'));
      $this->view->setVar('updateError', $this->session->get('wahana_update_error'));
      $this->session->remove('wahana_update_success');
      $this->session->remove('wahana_update_error');
   }
   public function update_field_tripAction() {
      $this->view->disable();

      if (! $this->request->isPost()) {
         return $this->response->redirect('settings/field_trip');
      }

      $id = (string) $this->request->getPost('id', 'string');
      $nama = trim((string) $this->request->getPost('nama', 'string'));
      $deskripsi = trim((string) $this->request->getPost('deskripsi', 'string'));
      $is_free = $this->request->getPost('is_free') ? true : false;
      $harga_tiket = $is_free ? 0 : (int) $this->request->getPost('harga_tiket', 'int');
      $urutan = (int) $this->request->getPost('urutan', 'int');
      $is_active = $this->request->getPost('is_active') ? true : false;

      if ($id === '' || $nama === '') {
         $this->session->set('wahana_update_error', 'ID dan Nama tidak boleh kosong.');
         return $this->response->redirect('settings/field_trip');
      }

      try {
         $imgUrl = null;

         if (isset($_FILES['image_file']) && $_FILES['image_file']['error'] !== UPLOAD_ERR_NO_FILE) {
            $fileInfo = $_FILES['image_file'];
            $uploadError = (int) $fileInfo['error'];

            if ($uploadError !== UPLOAD_ERR_OK) {
               $errorMessage = 'Upload gambar gagal. Kode error: ' . $uploadError;
               if ($uploadError === UPLOAD_ERR_INI_SIZE) {
                  $errorMessage = 'Upload gagal: ukuran file melebihi batas server.';
               }
               $this->session->set('wahana_update_error', $errorMessage);
               return $this->response->redirect('settings/field_trip');
            }

            $tmpName = (string) $fileInfo['tmp_name'];
            $originalName = (string) $fileInfo['name'];
            $fileSize = (int) $fileInfo['size'];

            if ($tmpName === '' || ! is_uploaded_file($tmpName) || $fileSize <= 0) {
               $this->session->set('wahana_update_error', 'File gambar tidak valid.');
               return $this->response->redirect('settings/field_trip');
            }

            if ($fileSize > (5 * 1024 * 1024)) {
               $this->session->set('wahana_update_error', 'Ukuran file maksimal 5MB.');
               return $this->response->redirect('settings/field_trip');
            }

            $extension = strtolower((string) pathinfo($originalName, PATHINFO_EXTENSION));
            $allowedExtensions = ['jpg', 'jpeg', 'png', 'gif', 'webp'];
            if (! in_array($extension, $allowedExtensions, true)) {
               $this->session->set('wahana_update_error', 'Format gambar tidak didukung. Gunakan JPG, JPEG, PNG, GIF, atau WEBP.');
               return $this->response->redirect('settings/field_trip');
            }

            $targetDir = BASE_PATH . '/public/images/wahana';
            if (! is_dir($targetDir)) {
               @mkdir($targetDir, 0755, true);
            }

            $safePrefix = 'wahana_field_trip';
            $fileName = $safePrefix . '_' . date('Ymd_His') . '_' . bin2hex(random_bytes(4)) . '.' . $extension;
            $targetPath = $targetDir . '/' . $fileName;

            if (! move_uploaded_file($tmpName, $targetPath)) {
               $this->session->set('wahana_update_error', 'Gagal menyimpan file gambar ke server.');
               return $this->response->redirect('settings/field_trip');
            }
            $imgUrl = 'images/wahana/' . $fileName;
         }

         $params = [
            'nama' => $nama,
            'deskripsi' => $deskripsi,
            'is_free' => $is_free ? 'true' : 'false',
            'harga_tiket' => $harga_tiket,
            'urutan' => $urutan,
            'is_active' => $is_active ? 'true' : 'false',
            'updated_by' => (string) $this->session->get('id'),
            'id' => $id,
         ];

         if ($imgUrl !== null) {
            $sql = "UPDATE wahana
                  SET nama = :nama, deskripsi = :deskripsi, is_free = :is_free, harga_tiket = :harga_tiket, urutan = :urutan, is_active = :is_active, img_url = :img_url, updated_at = NOW(), updated_by = :updated_by
                  WHERE id = :id";
            $params['img_url'] = $imgUrl;
         } else {
            $sql = "UPDATE wahana
                  SET nama = :nama, deskripsi = :deskripsi, is_free = :is_free, harga_tiket = :harga_tiket, urutan = :urutan, is_active = :is_active, updated_at = NOW(), updated_by = :updated_by
                  WHERE id = :id";
         }

         $this->db->execute($sql, $params);
         $this->session->set('wahana_update_success', "Wahana {$nama} berhasil diperbarui.");
      } catch (\Throwable $e) {
         $this->session->set('wahana_update_error', 'Gagal memperbarui data wahana: ' . $e->getMessage());
      }

      return $this->response->redirect('settings/field_trip');
   }
   public function create_field_tripAction() {
      $this->view->disable();

      if (! $this->request->isPost()) {
         return $this->response->redirect('settings/field_trip');
      }

      $nama = trim((string) $this->request->getPost('nama', 'string'));
      $deskripsi = trim((string) $this->request->getPost('deskripsi', 'string'));
      $is_free = $this->request->getPost('is_free') ? true : false;
      $harga_tiket = $is_free ? 0 : (int) $this->request->getPost('harga_tiket', 'int');
      $urutan = (int) $this->request->getPost('urutan', 'int');
      $is_active = $this->request->getPost('is_active') ? true : false;

      if ($nama === '') {
         $this->session->set('wahana_update_error', 'Nama tidak boleh kosong.');
         return $this->response->redirect('settings/field_trip');
      }

      try {
         $imgUrl = '';

         if (isset($_FILES['image_file']) && $_FILES['image_file']['error'] !== UPLOAD_ERR_NO_FILE) {
            $fileInfo = $_FILES['image_file'];
            $uploadError = (int) $fileInfo['error'];

            if ($uploadError !== UPLOAD_ERR_OK) {
               $errorMessage = 'Upload gambar gagal. Kode error: ' . $uploadError;
               if ($uploadError === UPLOAD_ERR_INI_SIZE) {
                  $errorMessage = 'Upload gagal: ukuran file melebihi batas server.';
               }
               $this->session->set('wahana_update_error', $errorMessage);
               return $this->response->redirect('settings/field_trip');
            }

            $tmpName = (string) $fileInfo['tmp_name'];
            $originalName = (string) $fileInfo['name'];
            $fileSize = (int) $fileInfo['size'];

            if ($tmpName === '' || ! is_uploaded_file($tmpName) || $fileSize <= 0) {
               $this->session->set('wahana_update_error', 'File gambar tidak valid.');
               return $this->response->redirect('settings/field_trip');
            }

            if ($fileSize > (5 * 1024 * 1024)) {
               $this->session->set('wahana_update_error', 'Ukuran file maksimal 5MB.');
               return $this->response->redirect('settings/field_trip');
            }

            $extension = strtolower((string) pathinfo($originalName, PATHINFO_EXTENSION));
            $allowedExtensions = ['jpg', 'jpeg', 'png', 'gif', 'webp'];
            if (! in_array($extension, $allowedExtensions, true)) {
               $this->session->set('wahana_update_error', 'Format gambar tidak didukung. Gunakan JPG, JPEG, PNG, GIF, atau WEBP.');
               return $this->response->redirect('settings/field_trip');
            }

            $targetDir = BASE_PATH . '/public/images/wahana';
            if (! is_dir($targetDir)) {
               @mkdir($targetDir, 0755, true);
            }

            $safePrefix = 'wahana_field_trip';
            $fileName = $safePrefix . '_' . date('Ymd_His') . '_' . bin2hex(random_bytes(4)) . '.' . $extension;
            $targetPath = $targetDir . '/' . $fileName;

            if (! move_uploaded_file($tmpName, $targetPath)) {
               $this->session->set('wahana_update_error', 'Gagal menyimpan file gambar ke server.');
               return $this->response->redirect('settings/field_trip');
            }
            $imgUrl = 'images/wahana/' . $fileName;
         }

         $sql = "INSERT INTO wahana (kategori, nama, deskripsi, harga_tiket, is_free, urutan, is_active, img_url, created_at, created_by, updated_at, updated_by)
                 VALUES ('FIELD TRIP', :nama, :deskripsi, :harga_tiket, :is_free, :urutan, :is_active, :img_url, NOW(), :created_by, NOW(), :updated_by)";

         $this->db->execute($sql, [
            'nama' => $nama,
            'deskripsi' => $deskripsi,
            'harga_tiket' => $harga_tiket,
            'is_free' => $is_free ? 'true' : 'false',
            'urutan' => $urutan,
            'is_active' => $is_active ? 'true' : 'false',
            'img_url' => $imgUrl,
            'created_by' => (string) $this->session->get('id'),
            'updated_by' => (string) $this->session->get('id'),
         ]);

         $this->session->set('wahana_update_success', "Wahana {$nama} berhasil ditambahkan.");
      } catch (\Throwable $e) {
         $this->session->set('wahana_update_error', 'Gagal menambahkan wahana baru: ' . $e->getMessage());
      }

      return $this->response->redirect('settings/field_trip');
   }
   
   public function fun_gameAction() {
      $search  = trim((string) $this->request->getQuery('search', 'string', ''));
      $page    = max(1, (int) $this->request->getQuery('page', 'int', 1));
      $perPage = (int) $this->request->getQuery('per_page', 'int', 10);

      if (!in_array($perPage, [10, 25, 50], true)) {
          $perPage = 10;
      }

      $whereClause = "WHERE w.kategori = 'FUN GAME'";
      $params = [];

      if ($search !== '') {
          $whereClause .= " AND (w.nama ILIKE :search OR w.deskripsi ILIKE :search)";
          $params['search'] = '%' . $search . '%';
      }

      // Count total matching
      $countResult = $this->db->fetchOne(
         "SELECT COUNT(*) AS total FROM wahana w {$whereClause}",
         \Phalcon\Db::FETCH_ASSOC,
         $params
      );
      $totalWahana = $countResult ? (int) $countResult['total'] : 0;
      $totalPages = max(1, (int) ceil($totalWahana / $perPage));

      if ($page > $totalPages) $page = $totalPages;
      $offset = ($page - 1) * $perPage;

      // Fetch matching records
      $params['limit'] = $perPage;
      $params['offset'] = $offset;
      $wahanaList = $this->db->fetchAll(
         "SELECT w.*,
                m_created.nama AS created_by_nama,
                m_updated.nama AS updated_by_nama
          FROM wahana w
          LEFT JOIN members m_created ON CAST(w.created_by AS TEXT) = CAST(m_created.id AS TEXT)
          LEFT JOIN members m_updated ON CAST(w.updated_by AS TEXT) = CAST(m_updated.id AS TEXT)
          {$whereClause}
          ORDER BY w.urutan ASC, w.nama ASC
          LIMIT :limit OFFSET :offset",
         \Phalcon\Db::FETCH_ASSOC,
         $params
      );

      $this->view->setVar('wahanaList', $wahanaList ?: []);
      $this->view->setVar('totalWahana', $totalWahana);
      $this->view->setVar('currentPage', $page);
      $this->view->setVar('perPage', $perPage);
      $this->view->setVar('totalPages', $totalPages);
      $this->view->setVar('search', $search);
      $this->view->setVar('updateSuccess', $this->session->get('wahana_update_success'));
      $this->view->setVar('updateError', $this->session->get('wahana_update_error'));
      $this->session->remove('wahana_update_success');
      $this->session->remove('wahana_update_error');
   }
   public function update_fun_gameAction() {
      $this->view->disable();

      if (! $this->request->isPost()) {
         return $this->response->redirect('settings/fun_game');
      }

      $id = (string) $this->request->getPost('id', 'string');
      $nama = trim((string) $this->request->getPost('nama', 'string'));
      $deskripsi = trim((string) $this->request->getPost('deskripsi', 'string'));
      $is_free = $this->request->getPost('is_free') ? true : false;
      $harga_tiket = $is_free ? 0 : (int) $this->request->getPost('harga_tiket', 'int');
      $urutan = (int) $this->request->getPost('urutan', 'int');
      $is_active = $this->request->getPost('is_active') ? true : false;

      if ($id === '' || $nama === '') {
         $this->session->set('wahana_update_error', 'ID dan Nama tidak boleh kosong.');
         return $this->response->redirect('settings/fun_game');
      }

      try {
         $imgUrl = null;

         if (isset($_FILES['image_file']) && $_FILES['image_file']['error'] !== UPLOAD_ERR_NO_FILE) {
            $fileInfo = $_FILES['image_file'];
            $uploadError = (int) $fileInfo['error'];

            if ($uploadError !== UPLOAD_ERR_OK) {
               $errorMessage = 'Upload gambar gagal. Kode error: ' . $uploadError;
               if ($uploadError === UPLOAD_ERR_INI_SIZE) {
                  $errorMessage = 'Upload gagal: ukuran file melebihi batas server.';
               }
               $this->session->set('wahana_update_error', $errorMessage);
               return $this->response->redirect('settings/fun_game');
            }

            $tmpName = (string) $fileInfo['tmp_name'];
            $originalName = (string) $fileInfo['name'];
            $fileSize = (int) $fileInfo['size'];

            if ($tmpName === '' || ! is_uploaded_file($tmpName) || $fileSize <= 0) {
               $this->session->set('wahana_update_error', 'File gambar tidak valid.');
               return $this->response->redirect('settings/fun_game');
            }

            if ($fileSize > (5 * 1024 * 1024)) {
               $this->session->set('wahana_update_error', 'Ukuran file maksimal 5MB.');
               return $this->response->redirect('settings/fun_game');
            }

            $extension = strtolower((string) pathinfo($originalName, PATHINFO_EXTENSION));
            $allowedExtensions = ['jpg', 'jpeg', 'png', 'gif', 'webp'];
            if (! in_array($extension, $allowedExtensions, true)) {
               $this->session->set('wahana_update_error', 'Format gambar tidak didukung. Gunakan JPG, JPEG, PNG, GIF, atau WEBP.');
               return $this->response->redirect('settings/fun_game');
            }

            $targetDir = BASE_PATH . '/public/images/wahana';
            if (! is_dir($targetDir)) {
               @mkdir($targetDir, 0755, true);
            }

            $safePrefix = 'wahana_fun_game';
            $fileName = $safePrefix . '_' . date('Ymd_His') . '_' . bin2hex(random_bytes(4)) . '.' . $extension;
            $targetPath = $targetDir . '/' . $fileName;

            if (! move_uploaded_file($tmpName, $targetPath)) {
               $this->session->set('wahana_update_error', 'Gagal menyimpan file gambar ke server.');
               return $this->response->redirect('settings/fun_game');
            }
            $imgUrl = 'images/wahana/' . $fileName;
         }

         $params = [
            'nama' => $nama,
            'deskripsi' => $deskripsi,
            'is_free' => $is_free ? 'true' : 'false',
            'harga_tiket' => $harga_tiket,
            'urutan' => $urutan,
            'is_active' => $is_active ? 'true' : 'false',
            'updated_by' => (string) $this->session->get('id'),
            'id' => $id,
         ];

         if ($imgUrl !== null) {
            $sql = "UPDATE wahana
                  SET nama = :nama, deskripsi = :deskripsi, is_free = :is_free, harga_tiket = :harga_tiket, urutan = :urutan, is_active = :is_active, img_url = :img_url, updated_at = NOW(), updated_by = :updated_by
                  WHERE id = :id";
            $params['img_url'] = $imgUrl;
         } else {
            $sql = "UPDATE wahana
                  SET nama = :nama, deskripsi = :deskripsi, is_free = :is_free, harga_tiket = :harga_tiket, urutan = :urutan, is_active = :is_active, updated_at = NOW(), updated_by = :updated_by
                  WHERE id = :id";
         }

         $this->db->execute($sql, $params);
         $this->session->set('wahana_update_success', "Wahana {$nama} berhasil diperbarui.");
      } catch (\Throwable $e) {
         $this->session->set('wahana_update_error', 'Gagal memperbarui data wahana: ' . $e->getMessage());
      }

      return $this->response->redirect('settings/fun_game');
   }
   public function create_fun_gameAction() {
      $this->view->disable();

      if (! $this->request->isPost()) {
         return $this->response->redirect('settings/fun_game');
      }

      $nama = trim((string) $this->request->getPost('nama', 'string'));
      $deskripsi = trim((string) $this->request->getPost('deskripsi', 'string'));
      $is_free = $this->request->getPost('is_free') ? true : false;
      $harga_tiket = $is_free ? 0 : (int) $this->request->getPost('harga_tiket', 'int');
      $urutan = (int) $this->request->getPost('urutan', 'int');
      $is_active = $this->request->getPost('is_active') ? true : false;

      if ($nama === '') {
         $this->session->set('wahana_update_error', 'Nama tidak boleh kosong.');
         return $this->response->redirect('settings/fun_game');
      }

      try {
         $imgUrl = '';

         if (isset($_FILES['image_file']) && $_FILES['image_file']['error'] !== UPLOAD_ERR_NO_FILE) {
            $fileInfo = $_FILES['image_file'];
            $uploadError = (int) $fileInfo['error'];

            if ($uploadError !== UPLOAD_ERR_OK) {
               $errorMessage = 'Upload gambar gagal. Kode error: ' . $uploadError;
               if ($uploadError === UPLOAD_ERR_INI_SIZE) {
                  $errorMessage = 'Upload gagal: ukuran file melebihi batas server.';
               }
               $this->session->set('wahana_update_error', $errorMessage);
               return $this->response->redirect('settings/fun_game');
            }

            $tmpName = (string) $fileInfo['tmp_name'];
            $originalName = (string) $fileInfo['name'];
            $fileSize = (int) $fileInfo['size'];

            if ($tmpName === '' || ! is_uploaded_file($tmpName) || $fileSize <= 0) {
               $this->session->set('wahana_update_error', 'File gambar tidak valid.');
               return $this->response->redirect('settings/fun_game');
            }

            if ($fileSize > (5 * 1024 * 1024)) {
               $this->session->set('wahana_update_error', 'Ukuran file maksimal 5MB.');
               return $this->response->redirect('settings/fun_game');
            }

            $extension = strtolower((string) pathinfo($originalName, PATHINFO_EXTENSION));
            $allowedExtensions = ['jpg', 'jpeg', 'png', 'gif', 'webp'];
            if (! in_array($extension, $allowedExtensions, true)) {
               $this->session->set('wahana_update_error', 'Format gambar tidak didukung. Gunakan JPG, JPEG, PNG, GIF, atau WEBP.');
               return $this->response->redirect('settings/fun_game');
            }

            $targetDir = BASE_PATH . '/public/images/wahana';
            if (! is_dir($targetDir)) {
               @mkdir($targetDir, 0755, true);
            }

            $safePrefix = 'wahana_fun_game';
            $fileName = $safePrefix . '_' . date('Ymd_His') . '_' . bin2hex(random_bytes(4)) . '.' . $extension;
            $targetPath = $targetDir . '/' . $fileName;

            if (! move_uploaded_file($tmpName, $targetPath)) {
               $this->session->set('wahana_update_error', 'Gagal menyimpan file gambar ke server.');
               return $this->response->redirect('settings/fun_game');
            }
            $imgUrl = 'images/wahana/' . $fileName;
         }

         $sql = "INSERT INTO wahana (kategori, nama, deskripsi, harga_tiket, is_free, urutan, is_active, img_url, created_at, created_by, updated_at, updated_by)
                 VALUES ('FUN GAME', :nama, :deskripsi, :harga_tiket, :is_free, :urutan, :is_active, :img_url, NOW(), :created_by, NOW(), :updated_by)";

         $this->db->execute($sql, [
            'nama' => $nama,
            'deskripsi' => $deskripsi,
            'harga_tiket' => $harga_tiket,
            'is_free' => $is_free ? 'true' : 'false',
            'urutan' => $urutan,
            'is_active' => $is_active ? 'true' : 'false',
            'img_url' => $imgUrl,
            'created_by' => (string) $this->session->get('id'),
            'updated_by' => (string) $this->session->get('id'),
         ]);

         $this->session->set('wahana_update_success', "Wahana {$nama} berhasil ditambahkan.");
      } catch (\Throwable $e) {
         $this->session->set('wahana_update_error', 'Gagal menambahkan wahana baru: ' . $e->getMessage());
      }

      return $this->response->redirect('settings/fun_game');
   }

   public function mini_zooAction() {
      $search  = trim((string) $this->request->getQuery('search', 'string', ''));
      $page    = max(1, (int) $this->request->getQuery('page', 'int', 1));
      $perPage = (int) $this->request->getQuery('per_page', 'int', 10);

      if (!in_array($perPage, [10, 25, 50], true)) {
         $perPage = 10;
      }

      $whereClause = "";
      $params = [];

      if ($search !== '') {
         $whereClause .= "WHERE (m.nama ILIKE :search OR m.deskripsi ILIKE :search)";
         $params['search'] = '%' . $search . '%';
      }

      // Count total data matching criteria
      $countResult = $this->db->fetchOne(
         "SELECT COUNT(*) AS total FROM mini_zoo m {$whereClause}",
         \Phalcon\Db::FETCH_ASSOC,
         $params
      );
      $totalData = $countResult ? (int) $countResult['total'] : 0;
      $totalPages = max(1, (int) ceil($totalData / $perPage));

      if ($page > $totalPages) $page = $totalPages;
      $offset = ($page - 1) * $perPage;

      // Fetch data for current page
      $params['limit'] = $perPage;
      $params['offset'] = $offset;
      $miniZooList = $this->db->fetchAll(
         "SELECT m.*,
               m_created.nama AS created_by_nama,
               m_updated.nama AS updated_by_nama
         FROM mini_zoo m
         LEFT JOIN members m_created ON CAST(m.created_by AS TEXT) = CAST(m_created.id AS TEXT)
         LEFT JOIN members m_updated ON CAST(m.updated_by AS TEXT) = CAST(m_updated.id AS TEXT)
         {$whereClause}
         ORDER BY m.nama ASC, created_at DESC
         LIMIT :limit
         OFFSET :offset",
         \Phalcon\Db::FETCH_ASSOC,
         $params
      );

      $this->view->setVar('miniZooList', $miniZooList ?: []);
      $this->view->setVar('totalData', $totalData);
      $this->view->setVar('currentPage', $page);
      $this->view->setVar('perPage', $perPage);
      $this->view->setVar('totalPages', $totalPages);
      $this->view->setVar('search', $search);
      $this->view->setVar('updateSuccess', $this->session->get('mini_zoo_update_success'));
      $this->view->setVar('updateError', $this->session->get('mini_zoo_update_error'));
      $this->session->remove('mini_zoo_update_success');
      $this->session->remove('mini_zoo_update_error');
   }

   public function update_minizooAction() {
      $this->view->disable();
      if (! $this->request->isPost()) {
         return $this->response->redirect('settings/mini_zoo');
      }

      $id = (string) $this->request->getPost('id', 'string');
      $nama = trim((string) $this->request->getPost('nama', 'string'));
      $deskripsi = trim((string) $this->request->getPost('deskripsi', 'string'));
      $is_active = $this->request->getPost('is_active') ? true : false;

      if ($nama === '') {
         $this->session->set('mini_zoo_update_error', 'Nama tidak boleh kosong.');
         return $this->response->redirect('settings/mini_zoo');
      }

      try {
         if ($id === '') {
            $this->session->set('mini_zoo_update_error', 'ID mini zoo tidak valid.');
            return $this->response->redirect('settings/mini_zoo');
         }

         $existingMiniZoo = $this->db->fetchOne(
            "SELECT img_url FROM mini_zoo WHERE id = :id LIMIT 1",
            \Phalcon\Db::FETCH_ASSOC,
            ['id' => $id]
         );
         if (! $existingMiniZoo) {
            $this->session->set('mini_zoo_update_error', 'Data mini zoo tidak ditemukan.');
            return $this->response->redirect('settings/mini_zoo');
         }

         $newImgUrl = trim((string) $this->request->getPost('img_url', 'string'));
         if ($newImgUrl === '') {
            $newImgUrl = (string) ($existingMiniZoo['img_url'] ?? '');
         } else {
            if (strpos($newImgUrl, 'images/mini_zoo/') !== 0 || strpos($newImgUrl, '..') !== false) {
               $this->session->set('mini_zoo_update_error', 'Path foto mini zoo tidak valid.');
               return $this->response->redirect('settings/mini_zoo');
            }

            if (! file_exists(BASE_PATH . '/public/' . $newImgUrl)) {
               $this->session->set('mini_zoo_update_error', 'File foto mini zoo tidak ditemukan di server.');
               return $this->response->redirect('settings/mini_zoo');
            }
         }

         if ($newImgUrl === '') {
            $this->session->set('mini_zoo_update_error', 'Foto mini zoo wajib diupload.');
            return $this->response->redirect('settings/mini_zoo');
         }

         $sql = "UPDATE mini_zoo
               SET nama = :nama,
                   deskripsi = :deskripsi,
                   img_url = :img_url,
                   is_active = :is_active,
                   updated_at = NOW(),
                   updated_by = :updated_by
               WHERE id = :id";

         $this->db->execute($sql, [
            'nama' => $nama,
            'deskripsi' => $deskripsi === '' ? null : $deskripsi,
            'img_url' => $newImgUrl,
            'is_active' => $is_active ? 'true' : 'false',
            'updated_by' => (string) $this->session->get('id'),
            'id' => $id,
         ]);

         $this->session->set('mini_zoo_update_success', "Data mini zoo {$nama} berhasil diperbarui.");
      } catch (\Throwable $e) {
         $this->session->set('mini_zoo_update_error', 'Gagal memperbarui mini zoo: ' . $e->getMessage());
      }

      return $this->response->redirect('settings/mini_zoo');
   }

   public function create_minizooAction() {
      $this->view->disable();
      if (! $this->request->isPost()) {
         return $this->response->redirect('settings/mini_zoo');
      }

      $nama = trim((string) $this->request->getPost('nama', 'string'));
      $deskripsi = trim((string) $this->request->getPost('deskripsi', 'string'));
      $is_active = $this->request->getPost('is_active') ? true : false;

      if ($nama === '') {
         $this->session->set('mini_zoo_update_error', 'Nama tidak boleh kosong.');
         return $this->response->redirect('settings/mini_zoo');
      }

      try {
         $newImgUrl = trim((string) $this->request->getPost('img_url', 'string'));
         if ($newImgUrl === '') {
            $this->session->set('mini_zoo_update_error', 'Foto mini zoo wajib diupload terlebih dahulu.');
            return $this->response->redirect('settings/mini_zoo');
         }

         if (strpos($newImgUrl, 'images/mini_zoo/') !== 0 || strpos($newImgUrl, '..') !== false) {
            $this->session->set('mini_zoo_update_error', 'Path foto mini zoo tidak valid.');
            return $this->response->redirect('settings/mini_zoo');
         }

         if (! file_exists(BASE_PATH . '/public/' . $newImgUrl)) {
            $this->session->set('mini_zoo_update_error', 'File foto mini zoo tidak ditemukan di server.');
            return $this->response->redirect('settings/mini_zoo');
         }

         $sql = "INSERT INTO mini_zoo (nama, deskripsi, img_url, is_active, created_at, created_by, updated_at, updated_by)
                 VALUES (:nama, :deskripsi, :img_url, :is_active, NOW(), :created_by, NOW(), :updated_by)";

         $this->db->execute($sql, [
            'nama' => $nama,
            'deskripsi' => $deskripsi === '' ? null : $deskripsi,
            'img_url' => $newImgUrl,
            'is_active' => $is_active ? 'true' : 'false',
            'created_by' => (string) $this->session->get('id'),
            'updated_by' => (string) $this->session->get('id'),
         ]);

         $this->session->set('mini_zoo_update_success', "Mini zoo {$nama} berhasil ditambahkan.");
      } catch (\Throwable $e) {
         $this->session->set('mini_zoo_update_error', 'Gagal menambahkan mini zoo baru: ' . $e->getMessage());
      }

      return $this->response->redirect('settings/mini_zoo');
   }

   public function fasilitasAction() {
      $search  = trim((string) $this->request->getQuery('search', 'string', ''));
      $page    = max(1, (int) $this->request->getQuery('page', 'int', 1));
      $perPage = (int) $this->request->getQuery('per_page', 'int', 10);

      if (!in_array($perPage, [10, 25, 50], true)) {
         $perPage = 10;
      }

      $whereClause = "";
      $params = [];

      if ($search !== '') {
         $whereClause .= "WHERE (f.nama ILIKE :search OR f.deskripsi ILIKE :search)";
         $params['search'] = '%' . $search . '%';
      }

      // Count total data matching criteria
      $countResult = $this->db->fetchOne(
         "SELECT COUNT(*) AS total FROM fasilitas f {$whereClause}",
         \Phalcon\Db::FETCH_ASSOC,
         $params
      );
      $totalData = $countResult ? (int) $countResult['total'] : 0;
      $totalPages = max(1, (int) ceil($totalData / $perPage));

      if ($page > $totalPages) $page = $totalPages;
      $offset = ($page - 1) * $perPage;

      // Fetch data for current page
      $params['limit'] = $perPage;
      $params['offset'] = $offset;
      
      $fasilitasList = $this->db->fetchAll(
         "SELECT f.*,
                m_created.nama AS created_by_nama,
                m_updated.nama AS updated_by_nama
          FROM fasilitas f
          LEFT JOIN members m_created ON CAST(f.created_by AS TEXT) = CAST(m_created.id AS TEXT)
          LEFT JOIN members m_updated ON CAST(f.updated_by AS TEXT) = CAST(m_updated.id AS TEXT)
          {$whereClause}
          ORDER BY nama ASC, created_at DESC
          LIMIT :limit OFFSET :offset",
         \Phalcon\Db::FETCH_ASSOC,
         $params
      );

      $this->view->setVar('fasilitasList', $fasilitasList ?: []);
      $this->view->setVar('totalData', $totalData);
      $this->view->setVar('currentPage', $page);
      $this->view->setVar('perPage', $perPage);
      $this->view->setVar('totalPages', $totalPages);
      $this->view->setVar('search', $search);
      $this->view->setVar('updateSuccess', $this->session->get('fasilitas_update_success'));
      $this->view->setVar('updateError', $this->session->get('fasilitas_update_error'));
      $this->session->remove('fasilitas_update_success');
      $this->session->remove('fasilitas_update_error');
   }

   public function update_fasilitasAction() {
      $this->view->disable();
      if (! $this->request->isPost()) {
         return $this->response->redirect('settings/fasilitas');
      }

      $id = (string) $this->request->getPost('id', 'string');
      $nama = trim((string) $this->request->getPost('nama', 'string'));
      $deskripsi = trim((string) $this->request->getPost('deskripsi', 'string'));
      $is_active = $this->request->getPost('is_active') ? true : false;

      if ($nama === '') {
         $this->session->set('fasilitas_update_error', 'Nama tidak boleh kosong.');
         return $this->response->redirect('settings/fasilitas');
      }

      try {
         if ($id === '') {
            $this->session->set('fasilitas_update_error', 'ID fasilitas tidak valid.');
            return $this->response->redirect('settings/fasilitas');
         }

         $existingFasilitas = $this->db->fetchOne(
            "SELECT img_url FROM fasilitas WHERE id = :id LIMIT 1",
            \Phalcon\Db::FETCH_ASSOC,
            ['id' => $id]
         );
         if (! $existingFasilitas) {
            $this->session->set('fasilitas_update_error', 'Data fasilitas tidak ditemukan.');
            return $this->response->redirect('settings/fasilitas');
         }

         $newImgUrl = trim((string) $this->request->getPost('img_url', 'string'));
         if ($newImgUrl === '') {
            $newImgUrl = (string) ($existingFasilitas['img_url'] ?? '');
         } else {
            if (strpos($newImgUrl, 'images/fasilitas/') !== 0 || strpos($newImgUrl, '..') !== false) {
               $this->session->set('fasilitas_update_error', 'Path foto fasilitas tidak valid.');
               return $this->response->redirect('settings/fasilitas');
            }

            if (! file_exists(BASE_PATH . '/public/' . $newImgUrl)) {
               $this->session->set('fasilitas_update_error', 'File foto fasilitas tidak ditemukan di server.');
               return $this->response->redirect('settings/fasilitas');
            }
         }

         if ($newImgUrl === '') {
            $this->session->set('fasilitas_update_error', 'Foto fasilitas wajib diupload.');
            return $this->response->redirect('settings/fasilitas');
         }

         $sql = "UPDATE fasilitas
               SET nama = :nama,
                   deskripsi = :deskripsi,
                   img_url = :img_url,
                   is_active = :is_active,
                   updated_at = NOW(),
                   updated_by = :updated_by
               WHERE id = :id";

         $this->db->execute($sql, [
            'nama' => $nama,
            'deskripsi' => $deskripsi === '' ? null : $deskripsi,
            'img_url' => $newImgUrl,
            'is_active' => $is_active ? 'true' : 'false',
            'updated_by' => (string) $this->session->get('id'),
            'id' => $id,
         ]);

         $this->session->set('fasilitas_update_success', "Data fasilitas {$nama} berhasil diperbarui.");
      } catch (\Throwable $e) {
         $this->session->set('fasilitas_update_error', 'Gagal memperbarui fasilitas: ' . $e->getMessage());
      }

      return $this->response->redirect('settings/fasilitas');
   }

   public function create_fasilitasAction() {
      $this->view->disable();
      if (! $this->request->isPost()) {
         return $this->response->redirect('settings/fasilitas');
      }

      $nama = trim((string) $this->request->getPost('nama', 'string'));
      $deskripsi = trim((string) $this->request->getPost('deskripsi', 'string'));
      $is_active = $this->request->getPost('is_active') ? true : false;

      if ($nama === '') {
         $this->session->set('fasilitas_update_error', 'Nama tidak boleh kosong.');
         return $this->response->redirect('settings/fasilitas');
      }

      try {
         $newImgUrl = trim((string) $this->request->getPost('img_url', 'string'));
         if ($newImgUrl === '') {
            $this->session->set('fasilitas_update_error', 'Foto fasilitas wajib diupload terlebih dahulu.');
            return $this->response->redirect('settings/fasilitas');
         }

         if (strpos($newImgUrl, 'images/fasilitas/') !== 0 || strpos($newImgUrl, '..') !== false) {
            $this->session->set('fasilitas_update_error', 'Path foto fasilitas tidak valid.');
            return $this->response->redirect('settings/fasilitas');
         }

         if (! file_exists(BASE_PATH . '/public/' . $newImgUrl)) {
            $this->session->set('fasilitas_update_error', 'File foto fasilitas tidak ditemukan di server.');
            return $this->response->redirect('settings/fasilitas');
         }

         $sql = "INSERT INTO fasilitas (nama, deskripsi, img_url, is_active, created_at, created_by, updated_at, updated_by)
                 VALUES (:nama, :deskripsi, :img_url, :is_active, NOW(), :created_by, NOW(), :updated_by)";

         $this->db->execute($sql, [
            'nama' => $nama,
            'deskripsi' => $deskripsi === '' ? null : $deskripsi,
            'img_url' => $newImgUrl,
            'is_active' => $is_active ? 'true' : 'false',
            'created_by' => (string) $this->session->get('id'),
            'updated_by' => (string) $this->session->get('id'),
         ]);

         $this->session->set('fasilitas_update_success', "Fasilitas {$nama} berhasil ditambahkan.");
      } catch (\Throwable $e) {
         $this->session->set('fasilitas_update_error', 'Gagal menambahkan fasilitas baru: ' . $e->getMessage());
      }

      return $this->response->redirect('settings/fasilitas');
   }
   public function galeriAction() {
      $search = trim((string) $this->request->getQuery('search', 'string', ''));
      $currentPage = max(1, (int) $this->request->getQuery('page', 'int', 1));
      $perPage = 10;

      $bindParams = [];
      $whereSql = '';

      if ($search !== '') {
         $whereSql = " WHERE (
            g.title ILIKE :search
            OR COALESCE(g.description, '') ILIKE :search
            OR g.category ILIKE :search
            OR g.type ILIKE :search
         )";
         $bindParams['search'] = '%' . $search . '%';
      }

      $countRow = $this->db->fetchOne(
         "SELECT COUNT(*) AS total_items FROM media_gallery g" . $whereSql,
         \Phalcon\Db::FETCH_ASSOC,
         $bindParams
      );
      $totalItems = isset($countRow['total_items']) ? (int) $countRow['total_items'] : 0;
      $totalPages = $totalItems > 0 ? (int) ceil($totalItems / $perPage) : 1;

      if ($currentPage > $totalPages) {
         $currentPage = $totalPages;
      }

      $offset = ($currentPage - 1) * $perPage;
      $listBindParams = $bindParams;
      $listBindParams['limit'] = $perPage;
      $listBindParams['offset'] = $offset;

      $galleryList = $this->db->fetchAll(
         "SELECT g.*,
                m_created.nama AS created_by_nama,
                m_updated.nama AS updated_by_nama
          FROM media_gallery g
          LEFT JOIN members m_created ON CAST(g.create_by AS TEXT) = CAST(m_created.id AS TEXT)
          LEFT JOIN members m_updated ON CAST(g.update_by AS TEXT) = CAST(m_updated.id AS TEXT)
          {$whereSql}
          ORDER BY g.updated_at DESC NULLS LAST, g.created_at DESC NULLS LAST
          LIMIT :limit OFFSET :offset",
         \Phalcon\Db::FETCH_ASSOC,
         $listBindParams
      );

      $this->view->setVar('galleryList', $galleryList ?: []);
      $this->view->setVar('searchQuery', $search);
      $this->view->setVar('currentPage', $currentPage);
      $this->view->setVar('perPage', $perPage);
      $this->view->setVar('totalItems', $totalItems);
      $this->view->setVar('totalPages', $totalPages);
      $this->view->setVar('updateSuccess', $this->session->get('gallery_update_success'));
      $this->view->setVar('updateError', $this->session->get('gallery_update_error'));
      $this->session->remove('gallery_update_success');
      $this->session->remove('gallery_update_error');
   }

   public function edit_galeriAction() {
      $id = trim((string) $this->dispatcher->getParam('id', 'string'));

      if ($id === '') {
         $this->session->set('gallery_update_error', 'ID galeri tidak valid.');
         return $this->response->redirect('settings/galeri');
      }

      $galleryItem = $this->db->fetchOne(
         "SELECT g.*,
                 m_created.nama AS created_by_nama,
                 m_updated.nama AS updated_by_nama
          FROM media_gallery g
          LEFT JOIN members m_created ON CAST(g.create_by AS TEXT) = CAST(m_created.id AS TEXT)
          LEFT JOIN members m_updated ON CAST(g.update_by AS TEXT) = CAST(m_updated.id AS TEXT)
          WHERE g.id = :id
          LIMIT 1",
         \Phalcon\Db::FETCH_ASSOC,
         ['id' => $id]
      );

      if (! $galleryItem) {
         $this->session->set('gallery_update_error', 'Data galeri tidak ditemukan.');
         return $this->response->redirect('settings/galeri');
      }

      $this->view->setVar('galleryItem', $galleryItem);
      $this->view->setVar('updateSuccess', $this->session->get('gallery_update_success'));
      $this->view->setVar('updateError', $this->session->get('gallery_update_error'));
      $this->session->remove('gallery_update_success');
      $this->session->remove('gallery_update_error');
      $this->view->pick('settings/galeri_edit');
   }

   public function update_galeriAction() {
      $this->view->disable();

      $isAjax = $this->request->isAjax();
      $respondError = function (string $message, string $redirectUrl = 'settings/galeri', int $statusCode = 400) use ($isAjax) {
         if ($isAjax) {
            return $this->jsonResponse(['status' => 'error', 'message' => $message], $statusCode);
         }

         $this->session->set('gallery_update_error', $message);
         return $this->response->redirect($redirectUrl);
      };
      $respondSuccess = function (string $message, string $redirectUrl = 'settings/galeri') use ($isAjax) {
         if ($isAjax) {
            return $this->jsonResponse(['status' => 'success', 'message' => $message], 200);
         }

         $this->session->set('gallery_update_success', $message);
         return $this->response->redirect($redirectUrl);
      };

      if (! $this->request->isPost()) {
         return $respondError('Invalid request', 'settings/galeri', 405);
      }

      $id = trim((string) $this->request->getPost('id', 'string'));
      $title = trim((string) $this->request->getPost('title', 'string'));
      $description = trim((string) $this->request->getPost('description', 'string'));
      $category = strtoupper(trim((string) $this->request->getPost('category', 'string')));
      $type = strtolower(trim((string) $this->request->getPost('type', 'string')));
      $isActive = in_array((string) $this->request->getPost('is_active', 'string'), ['1', 'true', 'on'], true);
      $sortOrder = (int) $this->request->getPost('sort_order', 'int', 0);

      $allowedCategory = ['WAHANA', 'AREA', 'EVENT'];
      $allowedType = ['photo', 'video'];

      if ($id === '' || $title === '' || ! in_array($category, $allowedCategory, true) || ! in_array($type, $allowedType, true)) {
         return $respondError('Data galeri tidak valid.', 'settings/edit_galeri/' . $id);
      }

      $currentGallery = $this->db->fetchOne(
         "SELECT * FROM media_gallery WHERE id = :id LIMIT 1",
         \Phalcon\Db::FETCH_ASSOC,
         ['id' => $id]
      );

      if (! $currentGallery) {
         return $respondError('Data galeri tidak ditemukan.', 'settings/galeri');
      }

      $currentType = strtolower((string) ($currentGallery['type'] ?? ''));
      $fileInfo = $_FILES['media_file'] ?? null;
      $hasNewFile = is_array($fileInfo) && (int) ($fileInfo['error'] ?? UPLOAD_ERR_NO_FILE) !== UPLOAD_ERR_NO_FILE;

      if (! $hasNewFile && $type !== $currentType) {
         return $respondError('Untuk mengubah tipe media, unggah file baru terlebih dahulu.', 'settings/edit_galeri/' . $id);
      }

      $fileChanged = false;
      $absoluteOriginalPath = null;
      $absoluteThumbSm = null;
      $absoluteThumbMd = null;
      $absolutePoster = null;

      $newOriginalPath = (string) ($currentGallery['original_path'] ?? '');
      $newOriginalFilename = (string) ($currentGallery['original_filename'] ?? '');
      $newOriginalSize = (int) ($currentGallery['original_size'] ?? 0);
      $newMimeType = (string) ($currentGallery['mime_type'] ?? '');
      $newThumbSmPath = $currentGallery['thumb_sm_path'] ?? null;
      $newThumbMdPath = $currentGallery['thumb_md_path'] ?? null;
      $newPosterPath = $currentGallery['poster_path'] ?? null;
      $newDurationSeconds = $currentGallery['duration_seconds'] ?? null;
      $newWidth = $currentGallery['width'] ?? null;
      $newHeight = $currentGallery['height'] ?? null;

      try {
         if ($hasNewFile) {
            $uploadError = (int) ($fileInfo['error'] ?? UPLOAD_ERR_NO_FILE);
            if ($uploadError !== UPLOAD_ERR_OK) {
               return $respondError('Upload file gagal. Kode error: ' . $uploadError, 'settings/edit_galeri/' . $id);
            }

            $tmpName = (string) ($fileInfo['tmp_name'] ?? '');
            $originalName = (string) ($fileInfo['name'] ?? '');
            $fileSize = (int) ($fileInfo['size'] ?? 0);

            if ($tmpName === '' || ! is_uploaded_file($tmpName) || $fileSize <= 0) {
               return $respondError('File media tidak valid.', 'settings/edit_galeri/' . $id);
            }

            $finfo = finfo_open(FILEINFO_MIME_TYPE);
            $mimeType = $finfo ? finfo_file($finfo, $tmpName) : false;
            if ($finfo) {
               finfo_close($finfo);
            }

            if (! is_string($mimeType) || $mimeType === '') {
               return $respondError('Gagal membaca tipe file media.', 'settings/edit_galeri/' . $id);
            }

            $allowedPhotoMimes = ['image/jpeg', 'image/png', 'image/webp'];
            $allowedVideoMimes = ['video/mp4', 'video/webm', 'video/quicktime', 'video/x-m4v'];

            if ($type === 'photo') {
               if (! in_array($mimeType, $allowedPhotoMimes, true)) {
                  return $respondError('Format foto tidak didukung. Gunakan JPG, PNG, atau WEBP.', 'settings/edit_galeri/' . $id);
               }
               if ($fileSize > (10 * 1024 * 1024)) {
                  return $respondError('Ukuran foto maksimal 10MB.', 'settings/edit_galeri/' . $id);
               }
            } else {
               if (! in_array($mimeType, $allowedVideoMimes, true)) {
                  return $respondError('Format video tidak didukung. Gunakan MP4, WEBM, atau MOV.', 'settings/edit_galeri/' . $id);
               }
               if ($fileSize > (100 * 1024 * 1024)) {
                  return $respondError('Ukuran video maksimal 100MB.', 'settings/edit_galeri/' . $id);
               }
            }

            if (! is_dir($this->galleryOriginalDir)) {
               @mkdir($this->galleryOriginalDir, 0755, true);
            }
            if (! is_dir($this->galleryThumbSmDir)) {
               @mkdir($this->galleryThumbSmDir, 0755, true);
            }
            if (! is_dir($this->galleryThumbMdDir)) {
               @mkdir($this->galleryThumbMdDir, 0755, true);
            }
            if (! is_dir($this->galleryPosterDir)) {
               @mkdir($this->galleryPosterDir, 0755, true);
            }

            $extension = strtolower((string) pathinfo($originalName, PATHINFO_EXTENSION));
            if ($extension === '') {
               $extension = $type === 'photo' ? 'jpg' : 'mp4';
            }

            $uniqueName = uniqid('', true) . '_' . time();
            $originalFilename = $uniqueName . '.' . $extension;
            $newOriginalPath = 'storage/originals/' . $originalFilename;
            $absoluteOriginalPath = $this->galleryOriginalDir . $originalFilename;

            if (! move_uploaded_file($tmpName, $absoluteOriginalPath)) {
               return $respondError('Gagal menyimpan file media ke server.', 'settings/edit_galeri/' . $id);
            }

            $newOriginalFilename = $originalFilename;
            $newOriginalSize = $fileSize;
            $newMimeType = $mimeType;
            $newThumbSmPath = null;
            $newThumbMdPath = null;
            $newPosterPath = null;
            $newDurationSeconds = null;
            $newWidth = null;
            $newHeight = null;
            $fileChanged = true;

            if ($type === 'photo') {
               $img = Image::make($absoluteOriginalPath);
               $newWidth = $img->width();
               $newHeight = $img->height();

               $thumbSmFilename = $uniqueName . '_sm.webp';
               $absoluteThumbSm = $this->galleryThumbSmDir . $thumbSmFilename;
               $img->resize(600, null, function ($constraint) {
                  $constraint->aspectRatio();
                  $constraint->upsize();
               })->encode('webp', 80)->save($absoluteThumbSm);
               $newThumbSmPath = 'storage/thumbnails/sm/' . $thumbSmFilename;

               $thumbMdFilename = $uniqueName . '_md.webp';
               $absoluteThumbMd = $this->galleryThumbMdDir . $thumbMdFilename;
               $imgMd = Image::make($absoluteOriginalPath);
               $imgMd->resize(1200, null, function ($constraint) {
                  $constraint->aspectRatio();
                  $constraint->upsize();
               })->encode('webp', 85)->save($absoluteThumbMd);
               $newThumbMdPath = 'storage/thumbnails/md/' . $thumbMdFilename;
            } else {
               $posterDataUrl = (string) $this->request->getPost('poster_data');
               if ($posterDataUrl !== '' && preg_match('/^data:image\/(png|jpeg|webp);base64,/', $posterDataUrl)) {
                  $base64Data = preg_replace('/^data:image\/\w+;base64,/', '', $posterDataUrl);
                  $binaryData = base64_decode($base64Data);

                  if ($binaryData !== false && strlen($binaryData) > 0) {
                     $posterFilename = $uniqueName . '_poster.webp';
                     $absolutePoster = $this->galleryPosterDir . $posterFilename;

                     $posterImg = Image::make($binaryData);
                     $posterImg->resize(1280, null, function ($constraint) {
                        $constraint->aspectRatio();
                        $constraint->upsize();
                     })->encode('webp', 80)->save($absolutePoster);
                     $newPosterPath = 'storage/thumbnails/posters/' . $posterFilename;

                     $thumbSmFilename = $uniqueName . '_sm.webp';
                     $absoluteThumbSm = $this->galleryThumbSmDir . $thumbSmFilename;
                     $posterImgSm = Image::make($binaryData);
                     $posterImgSm->resize(600, null, function ($constraint) {
                        $constraint->aspectRatio();
                        $constraint->upsize();
                     })->encode('webp', 75)->save($absoluteThumbSm);
                     $newThumbSmPath = 'storage/thumbnails/sm/' . $thumbSmFilename;
                     $newThumbMdPath = $newPosterPath;
                  }
               }

               $clientDuration = $this->request->getPost('video_duration');
               $clientWidth = $this->request->getPost('video_width');
               $clientHeight = $this->request->getPost('video_height');

               if ($clientDuration !== null && $clientDuration !== '' && is_numeric($clientDuration)) {
                  $newDurationSeconds = (int) round((float) $clientDuration);
               }
               if ($clientWidth !== null && $clientWidth !== '' && is_numeric($clientWidth)) {
                  $newWidth = (int) $clientWidth;
               }
               if ($clientHeight !== null && $clientHeight !== '' && is_numeric($clientHeight)) {
                  $newHeight = (int) $clientHeight;
               }
            }
         }

         $this->db->execute(
            "UPDATE media_gallery
             SET title = :title,
                 description = :description,
                 category = :category,
                 type = :type,
                 original_filename = :original_filename,
                 original_path = :original_path,
                 original_size = :original_size,
                 mime_type = :mime_type,
                 thumb_sm_path = :thumb_sm_path,
                 thumb_md_path = :thumb_md_path,
                 poster_path = :poster_path,
                 duration_seconds = :duration_seconds,
                 width = :width,
                 height = :height,
                 is_active = :is_active,
                 sort_order = :sort_order,
                 updated_at = NOW(),
                 update_by = :update_by
             WHERE id = :id",
            [
               'title' => $title,
               'description' => $description === '' ? null : $description,
               'category' => $category,
               'type' => $type,
               'original_filename' => $newOriginalFilename,
               'original_path' => $newOriginalPath,
               'original_size' => $newOriginalSize,
               'mime_type' => $newMimeType,
               'thumb_sm_path' => $newThumbSmPath,
               'thumb_md_path' => $newThumbMdPath,
               'poster_path' => $newPosterPath,
               'duration_seconds' => $newDurationSeconds,
               'width' => $newWidth,
               'height' => $newHeight,
               'is_active' => $isActive ? 'true' : 'false',
               'sort_order' => $sortOrder,
               'update_by' => (string) $this->session->get('id'),
               'id' => $id,
            ]
         );

         if ($fileChanged) {
            $oldOriginalPath = BASE_PATH . '/public/' . (string) ($currentGallery['original_path'] ?? '');
            $oldThumbSmPath = ! empty($currentGallery['thumb_sm_path']) ? BASE_PATH . '/public/' . (string) $currentGallery['thumb_sm_path'] : '';
            $oldThumbMdPath = ! empty($currentGallery['thumb_md_path']) ? BASE_PATH . '/public/' . (string) $currentGallery['thumb_md_path'] : '';
            $oldPosterPath = ! empty($currentGallery['poster_path']) ? BASE_PATH . '/public/' . (string) $currentGallery['poster_path'] : '';

            if ($oldOriginalPath !== '' && is_file($oldOriginalPath)) {
               @unlink($oldOriginalPath);
            }
            if ($oldThumbSmPath !== '' && is_file($oldThumbSmPath)) {
               @unlink($oldThumbSmPath);
            }
            if ($oldThumbMdPath !== '' && $oldThumbMdPath !== $oldPosterPath && is_file($oldThumbMdPath)) {
               @unlink($oldThumbMdPath);
            }
            if ($oldPosterPath !== '' && is_file($oldPosterPath)) {
               @unlink($oldPosterPath);
            }
         }

         return $respondSuccess("Data galeri {$title} berhasil diperbarui.", 'settings/galeri');
      } catch (\Throwable $e) {
         if ($fileChanged && is_string($absoluteOriginalPath) && $absoluteOriginalPath !== '' && is_file($absoluteOriginalPath)) {
            @unlink($absoluteOriginalPath);
         }
         if ($fileChanged && is_string($absoluteThumbSm) && $absoluteThumbSm !== '' && is_file($absoluteThumbSm)) {
            @unlink($absoluteThumbSm);
         }
         if ($fileChanged && is_string($absoluteThumbMd) && $absoluteThumbMd !== '' && is_file($absoluteThumbMd)) {
            @unlink($absoluteThumbMd);
         }
         if ($fileChanged && is_string($absolutePoster) && $absolutePoster !== '' && is_file($absolutePoster)) {
            @unlink($absolutePoster);
         }

         return $respondError('Gagal memperbarui data galeri: ' . $e->getMessage(), 'settings/edit_galeri/' . $id, 500);
      }
   }
   public function create_galeriAction() {
      $this->view->disable();

      if (! $this->request->isPost()) {
         return $this->response->redirect('settings/galeri');
      }

      $title = trim((string) $this->request->getPost('title', 'string'));
      $description = trim((string) $this->request->getPost('description', 'string'));
      $category = strtoupper(trim((string) $this->request->getPost('category', 'string')));
      $typeMedia = strtoupper(trim((string) $this->request->getPost('type_media', 'string')));
      $isActive = $this->request->getPost('is_active') ? true : false;

      $allowedCategory = ['WAHANA', 'AREA', 'EVENT'];
      $allowedTypeMedia = ['VIDEO', 'FOTO'];

      if ($title === '' || ! in_array($category, $allowedCategory, true) || ! in_array($typeMedia, $allowedTypeMedia, true)) {
         $this->session->set('gallery_update_error', 'Data galeri tidak valid.');
         return $this->response->redirect('settings/galeri');
      }

      try {
         $newResourceUrl = trim((string) $this->request->getPost('resource_url', 'string'));

         if ($newResourceUrl === '') {
             $this->session->set('gallery_update_error', 'Media galeri wajib diupload terlebih dahulu.');
             return $this->response->redirect('settings/galeri');
         }

         // Validasi path: hanya boleh dari folder gallery kita
         $allowedPrefixes = ['images/gallery/', 'videos/gallery/'];
         $valid = false;
         foreach ($allowedPrefixes as $prefix) {
             if (strpos($newResourceUrl, $prefix) === 0) {
                 $valid = true;
                 break;
             }
         }
         if (!$valid || strpos($newResourceUrl, '..') !== false) {
             $this->session->set('gallery_update_error', 'Path media tidak valid.');
             return $this->response->redirect('settings/galeri');
         }

         // Pastikan file benar-benar ada di server
         if (!file_exists(BASE_PATH . '/public/' . $newResourceUrl)) {
             $this->session->set('gallery_update_error', 'File media tidak ditemukan di server.');
             return $this->response->redirect('settings/galeri');
         }

         $sql = "INSERT INTO gallery (title, description, category, type_media, resource_url, is_active, created_at, updated_at, create_by, update_by)
                 VALUES (:title, :description, :category, :type_media, :resource_url, :is_active, NOW(), NOW(), :create_by, :update_by)";

         $this->db->execute($sql, [
            'title' => $title,
            'description' => $description === '' ? null : $description,
            'category' => $category,
            'type_media' => $typeMedia,
            'resource_url' => $newResourceUrl,
            'is_active' => $isActive ? 'true' : 'false',
            'create_by' => (string) $this->session->get('id'),
            'update_by' => (string) $this->session->get('id'),
         ]);

         $this->session->set('gallery_update_success', "Galeri {$title} berhasil ditambahkan.");
      } catch (\Throwable $e) {
      $this->session->set('gallery_update_error', 'Gagal menambahkan data galeri: ' . $e->getMessage());
      }

      return $this->response->redirect('settings/galeri');
   }
   public function chunk_upload_galeriAction() {
      $this->view->disable();

      // Hanya terima POST + AJAX
      if (!$this->request->isPost()) {
          return $this->jsonResponse(['success' => false, 'message' => 'Invalid request.'], 405);
      }

      // Ambil parameter chunk
      $uploadId    = preg_replace('/[^a-zA-Z0-9_\-]/', '', (string) $this->request->getPost('upload_id'));
      $chunkIndex  = (int) $this->request->getPost('chunk_index');
      $totalChunks = (int) $this->request->getPost('total_chunks');
      $typeMedia   = strtoupper(trim((string) $this->request->getPost('type_media', 'string')));
      $category    = strtoupper(trim((string) $this->request->getPost('category', 'string')));

      // Validasi dasar
      if ($uploadId === '' || $totalChunks < 1 || $chunkIndex < 0 || $chunkIndex >= $totalChunks) {
          return $this->jsonResponse(['success' => false, 'message' => 'Parameter chunk tidak valid.']);
      }

      $allowedTypeMedia = ['VIDEO', 'FOTO'];
      $allowedCategory  = ['WAHANA', 'AREA', 'EVENT'];
      if (!in_array($typeMedia, $allowedTypeMedia, true) || !in_array($category, $allowedCategory, true)) {
          return $this->jsonResponse(['success' => false, 'message' => 'type_media atau category tidak valid.']);
      }

      // Validasi file chunk
      $fileInfo = $_FILES['chunk_data'] ?? null;
      if (!is_array($fileInfo) || (int)($fileInfo['error'] ?? UPLOAD_ERR_NO_FILE) !== UPLOAD_ERR_OK) {
          return $this->jsonResponse(['success' => false, 'message' => 'Chunk file tidak diterima.']);
      }

      $tmpName   = (string) $fileInfo['tmp_name'];
      $chunkSize = (int) $fileInfo['size'];

      if (!is_uploaded_file($tmpName) || $chunkSize <= 0) {
          return $this->jsonResponse(['success' => false, 'message' => 'Chunk tidak valid.']);
      }

      // Batas ukuran chunk: 4MB per chunk
      if ($chunkSize > (4 * 1024 * 1024)) {
          return $this->jsonResponse(['success' => false, 'message' => 'Ukuran chunk melebihi 4MB.']);
      }

      // Siapkan direktori temp untuk upload_id ini
      $tempDir = sys_get_temp_dir() . '/gallery_chunks/' . $uploadId;
      if (!is_dir($tempDir)) {
          mkdir($tempDir, 0750, true);
      }

      // Simpan chunk
      $chunkPath = $tempDir . '/chunk_' . $chunkIndex;
      if (!move_uploaded_file($tmpName, $chunkPath)) {
          return $this->jsonResponse(['success' => false, 'message' => 'Gagal menyimpan chunk ke server.']);
      }

      // Cek apakah semua chunk sudah diterima
      $receivedCount = count(glob($tempDir . '/chunk_*'));
      if ($receivedCount < $totalChunks) {
          // Belum semua chunk tiba
          return $this->jsonResponse([
              'success'   => true,
              'done'      => false,
              'received'  => $receivedCount,
              'total'     => $totalChunks,
              'message'   => "Chunk {$chunkIndex} diterima.",
          ]);
      }

      // ── Semua chunk sudah ada, rakit file ──
      $isFoto = $typeMedia === 'FOTO';

      // Tentukan ekstensi dari chunk pertama (simpan di metadata file)
      $metaFile = $tempDir . '/meta.json';
      $meta     = [];
      if (file_exists($metaFile)) {
          $meta = json_decode(file_get_contents($metaFile), true) ?: [];
      }
      $extension = $meta['extension'] ?? ($isFoto ? 'jpg' : 'mp4');

      $targetDir = $isFoto
          ? (BASE_PATH . '/public/images/gallery')
          : (BASE_PATH . '/public/videos/gallery');

      if (!is_dir($targetDir)) {
          mkdir($targetDir, 0755, true);
      }

      $safePrefix = 'gallery_' . strtolower($category) . '_' . strtolower($typeMedia);
      $fileName   = $safePrefix . '_' . date('Ymd_His') . '_' . bin2hex(random_bytes(4)) . '.' . $extension;
      $targetPath = $targetDir . '/' . $fileName;

      // Gabungkan semua chunk secara berurutan
      $outHandle = fopen($targetPath, 'wb');
      if (!$outHandle) {
          return $this->jsonResponse(['success' => false, 'message' => 'Gagal membuat file output.']);
      }

      for ($i = 0; $i < $totalChunks; $i++) {
          $chunkFile = $tempDir . '/chunk_' . $i;
          if (!file_exists($chunkFile)) {
              fclose($outHandle);
              return $this->jsonResponse(['success' => false, 'message' => "Chunk ke-{$i} hilang saat perakitan."]);
          }
          $chunkHandle = fopen($chunkFile, 'rb');
          stream_copy_to_stream($chunkHandle, $outHandle);
          fclose($chunkHandle);
      }
      fclose($outHandle);

      // Bersihkan folder temp
      foreach (glob($tempDir . '/*') as $f) {
          @unlink($f);
      }
      @rmdir($tempDir);

      $filePath = ($isFoto ? 'images/gallery/' : 'videos/gallery/') . $fileName;

      return $this->jsonResponse([
          'success'   => true,
          'done'      => true,
          'file_path' => $filePath,
          'message'   => 'Upload selesai.',
      ]);
   }

   public function save_extension_galeriAction() {
      $this->view->disable();

      if (!$this->request->isPost()) {
          return $this->jsonResponse(['success' => false], 405);
      }

      $uploadId  = preg_replace('/[^a-zA-Z0-9_\-]/', '', (string) $this->request->getPost('upload_id'));
      $extension = strtolower(preg_replace('/[^a-z0-9]/', '', (string) $this->request->getPost('extension')));

      $allowedExtensions = ['jpg', 'jpeg', 'png', 'gif', 'webp', 'mp4', 'webm', 'mov', 'm4v'];
      if ($uploadId === '' || !in_array($extension, $allowedExtensions, true)) {
          return $this->jsonResponse(['success' => false, 'message' => 'Parameter tidak valid.']);
      }

      $tempDir = sys_get_temp_dir() . '/gallery_chunks/' . $uploadId;
      if (!is_dir($tempDir)) {
          mkdir($tempDir, 0750, true);
      }

      file_put_contents($tempDir . '/meta.json', json_encode(['extension' => $extension]));

      return $this->jsonResponse(['success' => true]);
   }

   public function chunk_upload_minizooAction() {
      $this->view->disable();

      if (! $this->request->isPost()) {
         return $this->jsonResponse(['success' => false, 'message' => 'Invalid request.'], 405);
      }

      $uploadId = preg_replace('/[^a-zA-Z0-9_\-]/', '', (string) $this->request->getPost('upload_id'));
      $chunkIndex = (int) $this->request->getPost('chunk_index');
      $totalChunks = (int) $this->request->getPost('total_chunks');

      if ($uploadId === '' || $totalChunks < 1 || $chunkIndex < 0 || $chunkIndex >= $totalChunks) {
         return $this->jsonResponse(['success' => false, 'message' => 'Parameter chunk tidak valid.']);
      }

      $fileInfo = $_FILES['chunk_data'] ?? null;
      if (! is_array($fileInfo) || (int) ($fileInfo['error'] ?? UPLOAD_ERR_NO_FILE) !== UPLOAD_ERR_OK) {
         return $this->jsonResponse(['success' => false, 'message' => 'Chunk file tidak diterima.']);
      }

      $tmpName = (string) $fileInfo['tmp_name'];
      $chunkSize = (int) $fileInfo['size'];
      if (! is_uploaded_file($tmpName) || $chunkSize <= 0) {
         return $this->jsonResponse(['success' => false, 'message' => 'Chunk tidak valid.']);
      }

      if ($chunkSize > (4 * 1024 * 1024)) {
         return $this->jsonResponse(['success' => false, 'message' => 'Ukuran chunk melebihi 4MB.']);
      }

      $tempDir = sys_get_temp_dir() . '/minizoo_chunks/' . $uploadId;
      if (! is_dir($tempDir)) {
         mkdir($tempDir, 0750, true);
      }

      $chunkPath = $tempDir . '/chunk_' . $chunkIndex;
      if (! move_uploaded_file($tmpName, $chunkPath)) {
         return $this->jsonResponse(['success' => false, 'message' => 'Gagal menyimpan chunk ke server.']);
      }

      $receivedCount = count(glob($tempDir . '/chunk_*'));
      if ($receivedCount < $totalChunks) {
         return $this->jsonResponse([
            'success' => true,
            'done' => false,
            'received' => $receivedCount,
            'total' => $totalChunks,
            'message' => "Chunk {$chunkIndex} diterima.",
         ]);
      }

      $metaFile = $tempDir . '/meta.json';
      $meta = [];
      if (file_exists($metaFile)) {
         $meta = json_decode(file_get_contents($metaFile), true) ?: [];
      }
      $extension = strtolower((string) ($meta['extension'] ?? 'jpg'));
      $allowedExtensions = ['jpg', 'jpeg', 'png', 'webp'];
      if (! in_array($extension, $allowedExtensions, true)) {
         return $this->jsonResponse(['success' => false, 'message' => 'Ekstensi foto mini zoo tidak valid.']);
      }

      $targetDir = BASE_PATH . '/public/images/mini_zoo';
      if (! is_dir($targetDir)) {
         mkdir($targetDir, 0755, true);
      }

      $fileName = 'mini_zoo_' . date('Ymd_His') . '_' . bin2hex(random_bytes(4)) . '.' . $extension;
      $targetPath = $targetDir . '/' . $fileName;

      $outHandle = fopen($targetPath, 'wb');
      if (! $outHandle) {
         return $this->jsonResponse(['success' => false, 'message' => 'Gagal membuat file output.']);
      }

      for ($i = 0; $i < $totalChunks; $i++) {
         $chunkFile = $tempDir . '/chunk_' . $i;
         if (! file_exists($chunkFile)) {
            fclose($outHandle);
            return $this->jsonResponse(['success' => false, 'message' => "Chunk ke-{$i} hilang saat perakitan."]);
         }
         $chunkHandle = fopen($chunkFile, 'rb');
         stream_copy_to_stream($chunkHandle, $outHandle);
         fclose($chunkHandle);
      }
      fclose($outHandle);

      foreach (glob($tempDir . '/*') as $f) {
         @unlink($f);
      }
      @rmdir($tempDir);

      return $this->jsonResponse([
         'success' => true,
         'done' => true,
         'file_path' => 'images/mini_zoo/' . $fileName,
         'message' => 'Upload selesai.',
      ]);
   }

   public function save_extension_minizooAction() {
      $this->view->disable();

      if (! $this->request->isPost()) {
         return $this->jsonResponse(['success' => false], 405);
      }

      $uploadId = preg_replace('/[^a-zA-Z0-9_\-]/', '', (string) $this->request->getPost('upload_id'));
      $extension = strtolower(preg_replace('/[^a-z0-9]/', '', (string) $this->request->getPost('extension')));
      $allowedExtensions = ['jpg', 'jpeg', 'png', 'webp'];

      if ($uploadId === '' || ! in_array($extension, $allowedExtensions, true)) {
         return $this->jsonResponse(['success' => false, 'message' => 'Parameter tidak valid.']);
      }

      $tempDir = sys_get_temp_dir() . '/minizoo_chunks/' . $uploadId;
      if (! is_dir($tempDir)) {
         mkdir($tempDir, 0750, true);
      }

      file_put_contents($tempDir . '/meta.json', json_encode(['extension' => $extension]));

      return $this->jsonResponse(['success' => true]);
   }

   public function chunk_upload_fasilitasAction() {
      $this->view->disable();

      if (! $this->request->isPost()) {
         return $this->jsonResponse(['success' => false, 'message' => 'Invalid request.'], 405);
      }

      $uploadId = preg_replace('/[^a-zA-Z0-9_\-]/', '', (string) $this->request->getPost('upload_id'));
      $chunkIndex = (int) $this->request->getPost('chunk_index');
      $totalChunks = (int) $this->request->getPost('total_chunks');

      if ($uploadId === '' || $totalChunks < 1 || $chunkIndex < 0 || $chunkIndex >= $totalChunks) {
         return $this->jsonResponse(['success' => false, 'message' => 'Parameter chunk tidak valid.']);
      }

      $fileInfo = $_FILES['chunk_data'] ?? null;
      if (! is_array($fileInfo) || (int) ($fileInfo['error'] ?? UPLOAD_ERR_NO_FILE) !== UPLOAD_ERR_OK) {
         return $this->jsonResponse(['success' => false, 'message' => 'Chunk file tidak diterima.']);
      }

      $tmpName = (string) $fileInfo['tmp_name'];
      $chunkSize = (int) $fileInfo['size'];
      if (! is_uploaded_file($tmpName) || $chunkSize <= 0) {
         return $this->jsonResponse(['success' => false, 'message' => 'Chunk tidak valid.']);
      }

      if ($chunkSize > (4 * 1024 * 1024)) {
         return $this->jsonResponse(['success' => false, 'message' => 'Ukuran chunk melebihi 4MB.']);
      }

      $tempDir = sys_get_temp_dir() . '/fasilitas_chunks/' . $uploadId;
      if (! is_dir($tempDir)) {
         mkdir($tempDir, 0750, true);
      }

      $chunkPath = $tempDir . '/chunk_' . $chunkIndex;
      if (! move_uploaded_file($tmpName, $chunkPath)) {
         return $this->jsonResponse(['success' => false, 'message' => 'Gagal menyimpan chunk ke server.']);
      }

      $receivedCount = count(glob($tempDir . '/chunk_*'));
      if ($receivedCount < $totalChunks) {
         return $this->jsonResponse([
            'success' => true,
            'done' => false,
            'received' => $receivedCount,
            'total' => $totalChunks,
            'message' => "Chunk {$chunkIndex} diterima.",
         ]);
      }

      $metaFile = $tempDir . '/meta.json';
      $meta = [];
      if (file_exists($metaFile)) {
         $meta = json_decode(file_get_contents($metaFile), true) ?: [];
      }
      $extension = strtolower((string) ($meta['extension'] ?? 'jpg'));
      $allowedExtensions = ['jpg', 'jpeg', 'png', 'webp'];
      if (! in_array($extension, $allowedExtensions, true)) {
         return $this->jsonResponse(['success' => false, 'message' => 'Ekstensi foto fasilitas tidak valid.']);
      }

      $targetDir = BASE_PATH . '/public/images/fasilitas';
      if (! is_dir($targetDir)) {
         mkdir($targetDir, 0755, true);
      }

      $fileName = 'fasilitas_' . date('Ymd_His') . '_' . bin2hex(random_bytes(4)) . '.' . $extension;
      $targetPath = $targetDir . '/' . $fileName;

      $outHandle = fopen($targetPath, 'wb');
      if (! $outHandle) {
         return $this->jsonResponse(['success' => false, 'message' => 'Gagal membuat file output.']);
      }

      for ($i = 0; $i < $totalChunks; $i++) {
         $chunkFile = $tempDir . '/chunk_' . $i;
         if (! file_exists($chunkFile)) {
            fclose($outHandle);
            return $this->jsonResponse(['success' => false, 'message' => "Chunk ke-{$i} hilang saat perakitan."]);
         }
         $chunkHandle = fopen($chunkFile, 'rb');
         stream_copy_to_stream($chunkHandle, $outHandle);
         fclose($chunkHandle);
      }
      fclose($outHandle);

      foreach (glob($tempDir . '/*') as $f) {
         @unlink($f);
      }
      @rmdir($tempDir);

      return $this->jsonResponse([
         'success' => true,
         'done' => true,
         'file_path' => 'images/fasilitas/' . $fileName,
         'message' => 'Upload selesai.',
      ]);
   }

   public function save_extension_fasilitasAction() {
      $this->view->disable();

      if (! $this->request->isPost()) {
         return $this->jsonResponse(['success' => false], 405);
      }

      $uploadId = preg_replace('/[^a-zA-Z0-9_\-]/', '', (string) $this->request->getPost('upload_id'));
      $extension = strtolower(preg_replace('/[^a-z0-9]/', '', (string) $this->request->getPost('extension')));
      $allowedExtensions = ['jpg', 'jpeg', 'png', 'webp'];

      if ($uploadId === '' || ! in_array($extension, $allowedExtensions, true)) {
         return $this->jsonResponse(['success' => false, 'message' => 'Parameter tidak valid.']);
      }

      $tempDir = sys_get_temp_dir() . '/fasilitas_chunks/' . $uploadId;
      if (! is_dir($tempDir)) {
         mkdir($tempDir, 0750, true);
      }

      file_put_contents($tempDir . '/meta.json', json_encode(['extension' => $extension]));

      return $this->jsonResponse(['success' => true]);
   }

   private function jsonResponse(array $data, int $statusCode = 200): \Phalcon\Http\Response {
      $this->response->setStatusCode($statusCode);
      $this->response->setContentType('application/json');
      $this->response->setContent(json_encode($data));
      return $this->response->send();
   }

   public function kritik_saranAction() {
      $search  = trim((string) $this->request->getQuery('search', 'string', ''));
      $page    = max(1, (int) $this->request->getQuery('page', 'int', 1));
      $perPage = (int) $this->request->getQuery('per_page', 'int', 10);

      if (!in_array($perPage, [10, 25, 50], true)) {
         $perPage = 10;
      }

      $whereClause = "";
      $params = [];

      if ($search !== '') {
         $whereClause .= "WHERE (ks.nama ILIKE :search OR ks.kritik_saran ILIKE :search)";
         $params['search'] = '%' . $search . '%';
      }

      // Count total data matching criteria
      $countResult = $this->db->fetchOne(
         "SELECT COUNT(*) AS total FROM kritik_saran ks {$whereClause}",
         \Phalcon\Db::FETCH_ASSOC,
         $params
      );
      $totalData = $countResult ? (int) $countResult['total'] : 0;
      $totalPages = max(1, (int) ceil($totalData / $perPage));

      if ($page > $totalPages) $page = $totalPages;
      $offset = ($page - 1) * $perPage;

      // Fetch data for current page
      $params['limit'] = $perPage;
      $params['offset'] = $offset;
      $items = $this->db->fetchAll(
         "SELECT ks.*, m.nama AS admin_nama 
          FROM kritik_saran ks 
          LEFT JOIN members m ON CAST(ks.responded_by AS TEXT) = CAST(m.id AS TEXT) 
          {$whereClause}
          ORDER BY ks.created_at DESC
          LIMIT :limit
          OFFSET :offset",
         \Phalcon\Db::FETCH_ASSOC,
         $params
      );

      $this->view->setVar('items', $items ?: []);
      $this->view->setVar('search', $search);
      $this->view->setVar('currentPage', $page);
      $this->view->setVar('totalPages', $totalPages);
      $this->view->setVar('perPage', $perPage);
      $this->view->setVar('totalData', $totalData);
      $this->view->setVar('updateSuccess', $this->session->get('krisa_update_success'));
      $this->view->setVar('updateError', $this->session->get('krisa_update_error'));
      $this->session->remove('krisa_update_success');
      $this->session->remove('krisa_update_error');
   }

   public function update_kritik_saranAction() {
      $this->view->disable();

      if (!$this->request->isPost()) {
         return $this->response->redirect('settings/kritik_saran');
      }

      $id = trim((string) $this->request->getPost('id', 'string'));
      $response = trim((string) $this->request->getPost('response', 'string'));
      $isPublishedVal = trim((string) $this->request->getPost('is_published', 'string'));

      if ($id === '' || !in_array($isPublishedVal, ['0', '1'], true)) {
         $this->session->set('krisa_update_error', 'Data input tidak valid.');
         return $this->response->redirect('settings/kritik_saran');
      }

      $isPublished = ($isPublishedVal === '1');
      $adminId = $this->session->get('id');

      try {
         // Ambil data lama untuk memeriksa apakah response berubah
         $existing = $this->db->fetchOne(
            "SELECT response FROM kritik_saran WHERE id = :id LIMIT 1",
            \Phalcon\Db::FETCH_ASSOC,
            ['id' => $id]
         );

         if (!$existing) {
            $this->session->set('krisa_update_error', 'Data kritik dan saran tidak ditemukan.');
            return $this->response->redirect('settings/kritik_saran');
         }

         $oldResponse = isset($existing['response']) ? trim((string)$existing['response']) : '';

         if ($response === '') {
            // Hapus tanggapan
            $this->db->execute(
               "UPDATE kritik_saran 
                SET response = NULL,
                    responded_at = NULL,
                    responded_by = NULL,
                    is_published = :is_published
                WHERE id = :id",
               [
                  'is_published' => $isPublished ? 'TRUE' : 'FALSE',
                  'id' => $id
               ]
            );
         } else {
            // Tulis/ubah tanggapan. Update tanggal & admin penginput hanya jika tanggapannya berubah
            if ($response !== $oldResponse) {
               $this->db->execute(
                  "UPDATE kritik_saran 
                   SET response = :response,
                       responded_at = NOW(),
                       responded_by = :responded_by,
                       is_published = :is_published
                   WHERE id = :id",
                  [
                     'response' => $response,
                     'responded_by' => $adminId,
                     'is_published' => $isPublished ? 'TRUE' : 'FALSE',
                     'id' => $id
                  ]
               );
            } else {
               // Update status publikasi saja
               $this->db->execute(
                  "UPDATE kritik_saran 
                   SET is_published = :is_published
                   WHERE id = :id",
                  [
                     'is_published' => $isPublished ? 'TRUE' : 'FALSE',
                     'id' => $id
                  ]
               );
            }
         }

         $this->session->set('krisa_update_success', 'Data kritik dan saran berhasil diperbarui.');
      } catch (\Throwable $e) {
         $this->session->set('krisa_update_error', 'Gagal memperbarui data: ' . $e->getMessage());
      }

      return $this->response->redirect('settings/kritik_saran');
   }
}
