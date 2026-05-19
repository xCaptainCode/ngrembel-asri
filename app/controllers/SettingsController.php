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

   public function dashboardAction() {
      $dashboard = $this->db->fetchOne(
         "SELECT d.*,
               m_created.nama AS created_by_nama,
               m_updated.nama AS updated_by_nama
         FROM dashboard d
         LEFT JOIN members m_created ON CAST(d.created_by AS TEXT) = CAST(m_created.id AS TEXT)
         LEFT JOIN members m_updated ON CAST(d.updated_by AS TEXT) = CAST(m_updated.id AS TEXT)
         ORDER BY d.updated_at DESC NULLS LAST, d.created_at DESC NULLS LAST
         LIMIT 1",
         \Phalcon\Db::FETCH_ASSOC
      );

      $this->view->setVar('dashboard', $dashboard ?: []);
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

      $id = (string) $this->request->getPost('id', 'string');
      $column = (string) $this->request->getPost('column', 'string');
      $value = $this->request->getPost('value');

      $allowedColumns = [
         'slide_img_1',
         'slide_img_2',
         'slide_img_3',
         'slide_img_4',
         'slide_img_5',
         'tagline',
         'quote_1',
         'stat_1_label',
         'stat_1_value',
         'stat_2_label',
         'stat_2_value',
         'stat_3_label',
         'stat_3_value',
         'stat_4_label',
         'stat_4_value',
         'sejarah_img_url',
         'sejarah_tahun_berdiri',
         'sejarah_title',
         'sejarah_paragraf_1',
         'sejarah_paragraf_2',
         'sejarah_paragraf_3',
         'sejarah_year_1_lable',
         'sejarah_year_1_value',
         'sejarah_year_2_lable',
         'sejarah_year_2_value',
         'sejarah_year_3_lable',
         'sejarah_year_3_value',
         'sejarah_year_4_lable',
         'sejarah_year_4_value',
         'sejarah_year_5_lable',
         'sejarah_year_5_value',
         'tiket_deskripsi',
         'tiket_weekday',
         'tiket_weekend',
         'jam_operasional',
         'tagline_footer',
         'alamat',
         'telp',
         'email',
         'link_google_maps',
         'link_facebook',
         'link_instagram',
         'link_youtube',
         'link_tiktok',
         'link_whatsapp',
      ];

      if ($id === '' || $column === '' || ! in_array($column, $allowedColumns, true)) {
         $this->session->set('dashboard_update_error', 'Data update tidak valid.');
         return $this->response->redirect('settings/dashboard');
      }

      $normalizedValue = is_string($value) ? trim($value) : $value;
      if ($normalizedValue === '') {
         $normalizedValue = null;
      }

      try {
         $imageColumns = ['sejarah_img_url', 'slide_img_1', 'slide_img_2', 'slide_img_3', 'slide_img_4', 'slide_img_5'];
         if (in_array($column, $imageColumns, true)) {
            $fileInfo = $_FILES['image_file'] ?? null;
            if (! is_array($fileInfo)) {
               $this->session->set('dashboard_update_error', 'File gambar tidak ditemukan.');
               return $this->response->redirect('settings/dashboard');
            }

            $uploadError = (int) ($fileInfo['error'] ?? UPLOAD_ERR_NO_FILE);
            if ($uploadError === UPLOAD_ERR_NO_FILE) {
               $this->session->set('dashboard_update_error', 'File gambar tidak ditemukan.');
               return $this->response->redirect('settings/dashboard');
            }
            if ($uploadError !== UPLOAD_ERR_OK) {
               $errorMessage = 'Upload gambar gagal. Kode error: ' . $uploadError;
               if ($uploadError === UPLOAD_ERR_INI_SIZE) {
                  $errorMessage = 'Upload gagal: ukuran file melebihi batas server (upload_max_filesize).';
               } elseif ($uploadError === UPLOAD_ERR_FORM_SIZE) {
                  $errorMessage = 'Upload gagal: ukuran file melebihi batas form.';
               } elseif ($uploadError === UPLOAD_ERR_PARTIAL) {
                  $errorMessage = 'Upload gagal: file hanya ter-upload sebagian.';
               }
               $this->session->set('dashboard_update_error', $errorMessage);
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

            $safePrefix = preg_replace('/[^a-z0-9_]/i', '_', $column);
            $fileName = $safePrefix . '_' . date('Ymd_His') . '_' . bin2hex(random_bytes(4)) . '.' . $extension;
            $targetPath = $targetDir . '/' . $fileName;
            if (! move_uploaded_file($tmpName, $targetPath)) {
               $this->session->set('dashboard_update_error', 'Gagal menyimpan file gambar ke server.');
               return $this->response->redirect('settings/dashboard');
            }
            $normalizedValue = 'images/' . $fileName;
         }

         $sql = "UPDATE dashboard
               SET {$column} = :value, updated_at = NOW(), updated_by = :updated_by
               WHERE id = :id";
         $this->db->execute($sql, [
            'value' => $normalizedValue,
            'updated_by' => (string) $this->session->get('id'),
            'id' => $id,
         ]);

         $this->session->set('dashboard_update_success', "Kolom {$column} berhasil diperbarui.");
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

   public function permainanAction() {}
   public function paintballAction() {}
   public function field_tripAction() {}
   public function fun_gameAction() {}
   public function mini_zooAction() {}
   public function fasilitasAction() {}
   public function galeriAction() {}
   public function kritik_saranAction() {}
}
