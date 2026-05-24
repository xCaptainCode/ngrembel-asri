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
      $dashboard = $this->db->fetchAll(
         "SELECT s.*,
               m_created.nama AS created_by_nama,
               m_updated.nama AS updated_by_nama
         FROM settings s
         LEFT JOIN members m_created ON CAST(s.created_by AS TEXT) = CAST(m_created.id AS TEXT)
         LEFT JOIN members m_updated ON CAST(s.updated_by AS TEXT) = CAST(m_updated.id AS TEXT)
         ORDER BY s.id ASC",
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
      $wahanaList = $this->db->fetchAll(
         "SELECT w.*,
                m_created.nama AS created_by_nama,
                m_updated.nama AS updated_by_nama
          FROM wahana w
          LEFT JOIN members m_created ON CAST(w.created_by AS TEXT) = CAST(m_created.id AS TEXT)
          LEFT JOIN members m_updated ON CAST(w.updated_by AS TEXT) = CAST(m_updated.id AS TEXT)
          WHERE w.kategori = 'PERMAINAN'
          ORDER BY w.urutan ASC, w.nama ASC",
         \Phalcon\Db::FETCH_ASSOC
      );

      $this->view->setVar('wahanaList', $wahanaList ?: []);
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
      $wahanaList = $this->db->fetchAll(
         "SELECT w.*,
                m_created.nama AS created_by_nama,
                m_updated.nama AS updated_by_nama
          FROM wahana w
          LEFT JOIN members m_created ON CAST(w.created_by AS TEXT) = CAST(m_created.id AS TEXT)
          LEFT JOIN members m_updated ON CAST(w.updated_by AS TEXT) = CAST(m_updated.id AS TEXT)
          WHERE w.kategori = 'PAINTBALL'
          ORDER BY w.urutan ASC, w.nama ASC",
         \Phalcon\Db::FETCH_ASSOC
      );

      $this->view->setVar('wahanaList', $wahanaList ?: []);
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
      $wahanaList = $this->db->fetchAll(
         "SELECT w.*,
                m_created.nama AS created_by_nama,
                m_updated.nama AS updated_by_nama
          FROM wahana w
          LEFT JOIN members m_created ON CAST(w.created_by AS TEXT) = CAST(m_created.id AS TEXT)
          LEFT JOIN members m_updated ON CAST(w.updated_by AS TEXT) = CAST(m_updated.id AS TEXT)
          WHERE w.kategori = 'FIELD TRIP'
          ORDER BY w.urutan ASC, w.nama ASC",
         \Phalcon\Db::FETCH_ASSOC
      );

      $this->view->setVar('wahanaList', $wahanaList ?: []);
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
      $wahanaList = $this->db->fetchAll(
         "SELECT w.*,
                m_created.nama AS created_by_nama,
                m_updated.nama AS updated_by_nama
          FROM wahana w
          LEFT JOIN members m_created ON CAST(w.created_by AS TEXT) = CAST(m_created.id AS TEXT)
          LEFT JOIN members m_updated ON CAST(w.updated_by AS TEXT) = CAST(m_updated.id AS TEXT)
          WHERE w.kategori = 'FUN GAME'
          ORDER BY w.urutan ASC, w.nama ASC",
         \Phalcon\Db::FETCH_ASSOC
      );

      $this->view->setVar('wahanaList', $wahanaList ?: []);
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
      $miniZooList = $this->db->fetchAll(
         "SELECT m.*,
               m_created.nama AS created_by_nama,
               m_updated.nama AS updated_by_nama
         FROM mini_zoo m
         LEFT JOIN members m_created ON CAST(m.created_by AS TEXT) = CAST(m_created.id AS TEXT)
         LEFT JOIN members m_updated ON CAST(m.updated_by AS TEXT) = CAST(m_updated.id AS TEXT)
         ORDER BY m.nama ASC, created_at DESC",
         \Phalcon\Db::FETCH_ASSOC
      );

      $this->view->setVar('miniZooList', $miniZooList ?: []);
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
      $fasilitasList = $this->db->fetchAll(
         "SELECT f.*,
                m_created.nama AS created_by_nama,
                m_updated.nama AS updated_by_nama
          FROM fasilitas f
          LEFT JOIN members m_created ON CAST(f.created_by AS TEXT) = CAST(m_created.id AS TEXT)
          LEFT JOIN members m_updated ON CAST(f.updated_by AS TEXT) = CAST(m_updated.id AS TEXT)
          ORDER BY nama ASC, created_at DESC",
         \Phalcon\Db::FETCH_ASSOC
      );

      $this->view->setVar('fasilitasList', $fasilitasList ?: []);
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
      $galleryList = $this->db->fetchAll(
         "SELECT g.*,
                m_created.nama AS created_by_nama,
                m_updated.nama AS updated_by_nama
          FROM gallery g
          LEFT JOIN members m_created ON CAST(g.create_by AS TEXT) = CAST(m_created.id AS TEXT)
          LEFT JOIN members m_updated ON CAST(g.update_by AS TEXT) = CAST(m_updated.id AS TEXT)
          ORDER BY g.updated_at DESC NULLS LAST, g.created_at DESC NULLS LAST",
         \Phalcon\Db::FETCH_ASSOC
      );

      $this->view->setVar('galleryList', $galleryList ?: []);
      $this->view->setVar('updateSuccess', $this->session->get('gallery_update_success'));
      $this->view->setVar('updateError', $this->session->get('gallery_update_error'));
      $this->session->remove('gallery_update_success');
      $this->session->remove('gallery_update_error');
   }
   public function update_galeriAction() {
      $this->view->disable();

      if (! $this->request->isPost()) {
         return $this->response->redirect('settings/galeri');
      }

      $id = (string) $this->request->getPost('id', 'string');
      $title = trim((string) $this->request->getPost('title', 'string'));
      $description = trim((string) $this->request->getPost('description', 'string'));
      $category = strtoupper(trim((string) $this->request->getPost('category', 'string')));
      $typeMedia = strtoupper(trim((string) $this->request->getPost('type_media', 'string')));
      $isActive = $this->request->getPost('is_active') ? true : false;

      $allowedCategory = ['WAHANA', 'AREA', 'EVENT'];
      $allowedTypeMedia = ['VIDEO', 'FOTO'];

      if ($id === '' || $title === '' || ! in_array($category, $allowedCategory, true) || ! in_array($typeMedia, $allowedTypeMedia, true)) {
         $this->session->set('gallery_update_error', 'Data galeri tidak valid.');
         return $this->response->redirect('settings/galeri');
      }

      try {
         $currentGallery = $this->db->fetchOne(
            "SELECT resource_url FROM gallery WHERE id = :id LIMIT 1",
            \Phalcon\Db::FETCH_ASSOC,
            ['id' => $id]
         );
         $oldResourceUrl = $currentGallery['resource_url'] ?? '';

         $newResourceUrl = trim((string) $this->request->getPost('resource_url', 'string'));

         if ($newResourceUrl === '') {
             $newResourceUrl = $oldResourceUrl;
         } else {
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
         }

         if ($newResourceUrl === '') {
            $this->session->set('gallery_update_error', 'Media galeri wajib diupload.');
            return $this->response->redirect('settings/galeri');
         }

         $sql = "UPDATE gallery
               SET title = :title,
                   description = :description,
                   category = :category,
                   type_media = :type_media,
                   resource_url = :resource_url,
                   is_active = :is_active,
                   updated_at = NOW(),
                   update_by = :update_by
               WHERE id = :id";

         $this->db->execute($sql, [
            'title' => $title,
            'description' => $description === '' ? null : $description,
            'category' => $category,
            'type_media' => $typeMedia,
            'resource_url' => $newResourceUrl,
            'is_active' => $isActive ? 'true' : 'false',
            'update_by' => (string) $this->session->get('id'),
            'id' => $id,
         ]);

         $this->session->set('gallery_update_success', "Data galeri {$title} berhasil diperbarui.");
      } catch (\Throwable $e) {
         $this->session->set('gallery_update_error', 'Gagal memperbarui data galeri: ' . $e->getMessage());
      }

      return $this->response->redirect('settings/galeri');
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

   public function kritik_saranAction() {}
}
