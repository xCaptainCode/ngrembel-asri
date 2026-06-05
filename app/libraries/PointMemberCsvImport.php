<?php

class PointMemberCsvImport {
   public const MAX_FILE_BYTES = 5242880;

   public const EXPECTED_HEADERS = [
      'no_hp',
      'tgl_transaksi',
      'kode_order',
      'nominal_transaksi',
      'jenis_transaksi',
      'point',
      'kategori',
   ];

   /** @var \Phalcon\Db\Adapter\Pdo\Postgresql */
   private $db;

   public function __construct($db) {
      $this->db = $db;
   }

   public static function storageDir() {
      $dir = BASE_PATH . '/storage/imports/point_member';
      if (!is_dir($dir)) {
         mkdir($dir, 0755, true);
      }
      return $dir;
   }

   public function parseFile($filePath) {
      if (!is_readable($filePath)) {
         throw new \RuntimeException('File impor tidak dapat dibaca.');
      }

      $handle = fopen($filePath, 'rb');
      if ($handle === false) {
         throw new \RuntimeException('Gagal membuka file CSV.');
      }

      try {
         $firstLine = fgets($handle);
         if ($firstLine === false) {
            throw new \RuntimeException('File CSV kosong.');
         }

         $delimiter = $this->detectDelimiter($firstLine);
         rewind($handle);

         if (stripos($firstLine, 'sep=') === 0) {
            fgets($handle);
         }

         $headerRow = fgetcsv($handle, 0, $delimiter);
         if (!$headerRow || count($headerRow) === 1 && trim((string) $headerRow[0]) === '') {
            throw new \RuntimeException('Header CSV tidak ditemukan.');
         }

         $headers = $this->normalizeHeaderRow($headerRow);
         $this->validateHeaders($headers);

         $rows = [];
         $lineNumber = 1;
         $seenKodeOrder = [];

         while (($data = fgetcsv($handle, 0, $delimiter)) !== false) {
            $lineNumber++;

            if ($this->isEmptyRow($data)) {
               continue;
            }

            if (count($data) !== count($headers)) {
               $rows[] = $this->buildInvalidRow(
                  $lineNumber,
                  $data,
                  'Jumlah kolom (' . count($data) . ') tidak sesuai header (' . count($headers) . ').'
               );
               continue;
            }

            $assoc = [];
            foreach ($headers as $index => $header) {
               $assoc[$header] = trim((string) ($data[$index] ?? ''));
            }

            $rows[] = $this->validateDataRow($lineNumber, $assoc, $seenKodeOrder);
         }
      } finally {
         fclose($handle);
      }

      return $rows;
   }

   public function buildSummary(array $rows) {
      $summary = [
         'total' => count($rows),
         'ready' => 0,
         'duplicate' => 0,
         'duplicate_in_file' => 0,
         'member_not_found' => 0,
         'invalid' => 0,
      ];

      foreach ($rows as $row) {
         $status = $row['status'] ?? 'invalid';
         if (isset($summary[$status])) {
            $summary[$status]++;
         } else {
            $summary['invalid']++;
         }
      }

      return $summary;
   }

   public function importReadyRows(array $rows, $createdBy, $fileName) {
      $inserted = 0;
      $skippedDuplicate = 0;
      $skippedError = 0;
      $errors = [];

      $this->db->begin();

      try {
         foreach ($rows as $row) {
            if (($row['status'] ?? '') !== 'ready' || empty($row['payload'])) {
               if (in_array($row['status'] ?? '', ['duplicate', 'duplicate_in_file'], true)) {
                  $skippedDuplicate++;
               } elseif (($row['status'] ?? '') !== 'ready') {
                  $skippedError++;
               }
               continue;
            }

            $payload = $row['payload'];

            $exists = $this->db->fetchOne(
               'SELECT id FROM poin_transaksi WHERE kode_order = :kode_order LIMIT 1',
               \Phalcon\Db::FETCH_ASSOC,
               ['kode_order' => $payload['kode_order']]
            );

            if ($exists) {
               $skippedDuplicate++;
               continue;
            }

            $this->db->execute(
               'INSERT INTO poin_transaksi (
                   member_id, tgl_transaksi, kode_order, nominal_transaksi,
                   jenis_poin, point, kategori, created_by
                ) VALUES (
                   :member_id, :tgl_transaksi, :kode_order, :nominal_transaksi,
                   :jenis_poin, :point, :kategori, :created_by
                )',
               [
                  'member_id' => $payload['member_id'],
                  'tgl_transaksi' => $payload['tgl_transaksi'],
                  'kode_order' => $payload['kode_order'],
                  'nominal_transaksi' => $payload['nominal_transaksi'],
                  'jenis_poin' => $payload['jenis_poin'],
                  'point' => $payload['point'],
                  'kategori' => $payload['kategori'],
                  'created_by' => $createdBy,
               ]
            );

            $inserted++;
         }

         $this->writeImportLog(
            $fileName,
            count($rows),
            $inserted,
            $skippedDuplicate,
            $skippedError,
            $errors,
            $createdBy
         );

         $this->db->commit();
      } catch (\Throwable $e) {
         $this->db->rollback();
         throw $e;
      }

      return [
         'inserted' => $inserted,
         'skipped_duplicate' => $skippedDuplicate,
         'skipped_error' => $skippedError,
      ];
   }

   private function writeImportLog($fileName, $totalRows, $inserted, $skippedDuplicate, $skippedError, array $errors, $createdBy) {
      $errorSummary = $errors ? json_encode($errors, JSON_UNESCAPED_UNICODE) : null;

      $this->db->execute(
         'INSERT INTO tsync_import_log (
             import_type, file_name, total_rows, inserted_rows,
             skipped_duplicate, skipped_error, error_summary, imported_by
          ) VALUES (
             :import_type, :file_name, :total_rows, :inserted_rows,
             :skipped_duplicate, :skipped_error, :error_summary, :imported_by
          )',
         [
            'import_type' => 'point_member',
            'file_name' => $fileName,
            'total_rows' => $totalRows,
            'inserted_rows' => $inserted,
            'skipped_duplicate' => $skippedDuplicate,
            'skipped_error' => $skippedError,
            'error_summary' => $errorSummary,
            'imported_by' => $createdBy,
         ]
      );
   }

   private function validateDataRow($lineNumber, array $row, array &$seenKodeOrder) {
      $noHp = $this->normalizePhone($row['no_hp'] ?? '');
      $kodeOrder = trim((string) ($row['kode_order'] ?? ''));
      $jenis = strtolower(trim((string) ($row['jenis_transaksi'] ?? '')));
      $pointRaw = trim((string) ($row['point'] ?? ''));
      $kategori = strtoupper(trim((string) ($row['kategori'] ?? '')));
      $tglTransaksi = trim((string) ($row['tgl_transaksi'] ?? ''));
      $nominalRaw = trim((string) ($row['nominal_transaksi'] ?? ''));

      $base = [
         'line' => $lineNumber,
         'no_hp' => $noHp,
         'tgl_transaksi' => $tglTransaksi,
         'kode_order' => $kodeOrder,
         'nominal_transaksi' => $nominalRaw,
         'jenis_transaksi' => $jenis,
         'point' => $pointRaw,
         'kategori' => $kategori,
         'member_nama' => null,
      ];

      if ($noHp === '' || $kodeOrder === '' || $tglTransaksi === '' || $nominalRaw === '' || $jenis === '' || $pointRaw === '' || $kategori === '') {
         return $this->finalizeRow($base, 'invalid', 'Semua kolom wajib diisi.');
      }

      if (strlen($kodeOrder) > 12) {
         return $this->finalizeRow($base, 'invalid', 'kode_order maksimal 12 karakter.');
      }

      if (!in_array($jenis, ['masuk', 'keluar'], true)) {
         return $this->finalizeRow($base, 'invalid', 'jenis_transaksi harus masuk atau keluar.');
      }

      if (!is_numeric($nominalRaw)) {
         return $this->finalizeRow($base, 'invalid', 'nominal_transaksi harus angka.');
      }

      if (!is_numeric($pointRaw)) {
         return $this->finalizeRow($base, 'invalid', 'point harus angka.');
      }

      $point = (int) round((float) $pointRaw);
      if ($point === 0) {
         return $this->finalizeRow($base, 'invalid', 'point tidak boleh 0.');
      }

      if ($jenis === 'keluar' && $point > 0) {
         $point = -$point;
      } elseif ($jenis === 'masuk' && $point < 0) {
         $point = abs($point);
      }

      $point = abs($point);

      if (isset($seenKodeOrder[$kodeOrder])) {
         return $this->finalizeRow($base, 'duplicate_in_file', 'kode_order duplikat dalam file CSV.');
      }
      $seenKodeOrder[$kodeOrder] = true;

      $duplicate = $this->db->fetchOne(
         'SELECT id FROM poin_transaksi WHERE kode_order = :kode_order LIMIT 1',
         \Phalcon\Db::FETCH_ASSOC,
         ['kode_order' => $kodeOrder]
      );
      if ($duplicate) {
         return $this->finalizeRow($base, 'duplicate', 'kode_order sudah ada di database.');
      }

      $member = $this->findMemberByPhone($noHp);
      if (!$member) {
         return $this->finalizeRow($base, 'member_not_found', 'Member dengan no_hp tersebut tidak ditemukan.');
      }

      $base['member_nama'] = $member['nama'];

      $payload = [
         'member_id' => $member['id'],
         'tgl_transaksi' => $this->normalizeTglTransaksi($tglTransaksi),
         'kode_order' => $kodeOrder,
         'nominal_transaksi' => (float) $nominalRaw,
         'jenis_poin' => $jenis,
         'point' => $point,
         'kategori' => $kategori,
      ];

      return $this->finalizeRow($base, 'ready', null, $payload);
   }

   private function findMemberByPhone($noHp) {
      $candidates = array_unique(array_filter([
         $noHp,
         ltrim($noHp, '0'),
         '0' . ltrim($noHp, '0'),
      ]));

      foreach ($candidates as $phone) {
         $member = $this->db->fetchOne(
            'SELECT id, nama, no_hp FROM members WHERE no_hp = :no_hp LIMIT 1',
            \Phalcon\Db::FETCH_ASSOC,
            ['no_hp' => $phone]
         );
         if ($member) {
            return $member;
         }
      }

      return null;
   }

   private function normalizeTglTransaksi($value) {
      $value = trim($value, " \t\n\r\0\x0B\"'");
      $timestamp = strtotime($value);
      if ($timestamp !== false) {
         return date('Y-m-d H:i:s', $timestamp);
      }
      return substr($value, 0, 19);
   }

   private function normalizePhone($value) {
      return preg_replace('/\s+/', '', trim($value, " \t\n\r\0\x0B\"'"));
   }

   private function finalizeRow(array $base, $status, $message = null, array $payload = null) {
      return [
         'line' => $base['line'],
         'no_hp' => $base['no_hp'],
         'tgl_transaksi' => $base['tgl_transaksi'],
         'kode_order' => $base['kode_order'],
         'nominal_transaksi' => $base['nominal_transaksi'],
         'jenis_transaksi' => $base['jenis_transaksi'],
         'point' => $base['point'],
         'kategori' => $base['kategori'],
         'member_nama' => $base['member_nama'],
         'status' => $status,
         'message' => $message,
         'payload' => $payload,
      ];
   }

   private function buildInvalidRow($lineNumber, array $data, $message) {
      return [
         'line' => $lineNumber,
         'no_hp' => (string) ($data[0] ?? ''),
         'tgl_transaksi' => (string) ($data[1] ?? ''),
         'kode_order' => (string) ($data[2] ?? ''),
         'nominal_transaksi' => (string) ($data[3] ?? ''),
         'jenis_transaksi' => (string) ($data[4] ?? ''),
         'point' => (string) ($data[5] ?? ''),
         'kategori' => (string) ($data[6] ?? ''),
         'member_nama' => null,
         'status' => 'invalid',
         'message' => $message,
         'payload' => null,
      ];
   }

   private function validateHeaders(array $headers) {
      $missing = array_diff(self::EXPECTED_HEADERS, $headers);
      $extra = array_diff($headers, self::EXPECTED_HEADERS);

      if ($missing || $extra || count($headers) !== count(self::EXPECTED_HEADERS)) {
         throw new \RuntimeException(
            'Header CSV tidak valid. Kolom wajib: ' . implode(', ', self::EXPECTED_HEADERS)
         );
      }
   }

   private function normalizeHeaderRow(array $headerRow) {
      $normalized = [];
      foreach ($headerRow as $header) {
         $normalized[] = $this->normalizeHeaderName($header);
      }
      return $normalized;
   }

   private function normalizeHeaderName($header) {
      $header = trim((string) $header);
      if (strncmp($header, "\xEF\xBB\xBF", 3) === 0) {
         $header = substr($header, 3);
      }
      return strtolower(trim($header, " \t\n\r\0\x0B\"'"));
   }

   private function detectDelimiter($line) {
      $semicolons = substr_count($line, ';');
      $commas = substr_count($line, ',');
      return $semicolons > $commas ? ';' : ',';
   }

   private function isEmptyRow(array $data) {
      foreach ($data as $value) {
         if (trim((string) $value) !== '') {
            return false;
         }
      }
      return true;
   }
}
