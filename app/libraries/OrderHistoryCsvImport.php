<?php

class OrderHistoryCsvImport {
   public const MAX_FILE_BYTES = 5242880;
   public const PREVIEW_LIMIT = 10;

   public const ORDERS_HEADERS = [
      'jenis',
      'kode_order',
      'tanggal',
      'jam',
      'nama',
      'jml_org',
      'meja',
      'sub_total',
      'discount',
      'pajak',
      'total_bayar',
      'nom_uang',
      'kembalian',
      'note',
   ];

   public const ORDER_ITEMS_HEADERS = [
      'jenis',
      'kode_order',
      'item',
      'qty',
      'satuan',
      'qty_ekor',
      'harga',
      'discount',
      'total',
   ];

   /** @var \Phalcon\Db\Adapter\Pdo\Postgresql */
   private $db;

   public function __construct($db) {
      $this->db = $db;
   }

   public static function storageDir() {
      $dir = BASE_PATH . '/storage/imports/order_history';
      if (!is_dir($dir)) {
         mkdir($dir, 0755, true);
      }
      return $dir;
   }

   public function parseOrdersFile($filePath) {
      return $this->parseFile($filePath, self::ORDERS_HEADERS, 'orders');
   }

   public function parseOrderItemsFile($filePath) {
      return $this->parseFile($filePath, self::ORDER_ITEMS_HEADERS, 'order_items');
   }

   public function buildSummary(array $rows) {
      $summary = [
         'total' => count($rows),
         'ready' => 0,
         'duplicate' => 0,
         'duplicate_in_file' => 0,
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

   public function buildPreviewRows(array $rows, $limit = self::PREVIEW_LIMIT) {
      $preview = [];
      $count = 0;

      foreach ($rows as $row) {
         if ($count >= $limit) {
            break;
         }
         $preview[] = $row;
         $count++;
      }

      return $preview;
   }

   public function importAll(array $orderRows, array $itemRows, $createdBy, $ordersFileName, $itemsFileName) {
      $ordersInserted = 0;
      $ordersSkippedDuplicate = 0;
      $ordersSkippedError = 0;
      $itemsInserted = 0;
      $itemsSkippedDuplicate = 0;
      $itemsSkippedError = 0;

      $this->db->begin();

      try {
         foreach ($orderRows as $row) {
            if (($row['status'] ?? '') !== 'ready' || empty($row['payload'])) {
               if (in_array($row['status'] ?? '', ['duplicate', 'duplicate_in_file'], true)) {
                  $ordersSkippedDuplicate++;
               } elseif (($row['status'] ?? '') !== 'ready') {
                  $ordersSkippedError++;
               }
               continue;
            }

            $payload = $row['payload'];
            $exists = $this->db->fetchOne(
               'SELECT id FROM orders WHERE kode_order = :kode_order LIMIT 1',
               \Phalcon\Db::FETCH_ASSOC,
               ['kode_order' => $payload['kode_order']]
            );

            if ($exists) {
               $ordersSkippedDuplicate++;
               continue;
            }

            $this->db->execute(
               'INSERT INTO orders (
                   jenis, kode_order, tanggal, jam, nama, jml_org, meja,
                   sub_total, discount, pajak, total_bayar, nom_uang, kembalian, note
                ) VALUES (
                   :jenis, :kode_order, :tanggal, :jam, :nama, :jml_org, :meja,
                   :sub_total, :discount, :pajak, :total_bayar, :nom_uang, :kembalian, :note
                )',
               $payload
            );

            $ordersInserted++;
         }

         foreach ($itemRows as $row) {
            if (($row['status'] ?? '') !== 'ready' || empty($row['payload'])) {
               if (in_array($row['status'] ?? '', ['duplicate', 'duplicate_in_file'], true)) {
                  $itemsSkippedDuplicate++;
               } elseif (($row['status'] ?? '') !== 'ready') {
                  $itemsSkippedError++;
               }
               continue;
            }

            $payload = $row['payload'];
            $exists = $this->db->fetchOne(
               'SELECT 1 AS found FROM order_items
                WHERE kode_order = :kode_order AND item = :item
                LIMIT 1',
               \Phalcon\Db::FETCH_ASSOC,
               [
                  'kode_order' => $payload['kode_order'],
                  'item' => $payload['item'],
               ]
            );

            if ($exists) {
               $itemsSkippedDuplicate++;
               continue;
            }

            $this->db->execute(
               'INSERT INTO order_items (
                   jenis, kode_order, item, qty, satuan, qty_ekor, harga, discount, total
                ) VALUES (
                   :jenis, :kode_order, :item, :qty, :satuan, :qty_ekor, :harga, :discount, :total
                )',
               $payload
            );

            $itemsInserted++;
         }

         $totalRows = count($orderRows) + count($itemRows);
         $insertedRows = $ordersInserted + $itemsInserted;
         $skippedDuplicate = $ordersSkippedDuplicate + $itemsSkippedDuplicate;
         $skippedError = $ordersSkippedError + $itemsSkippedError;

         $this->db->execute(
            'INSERT INTO tsync_import_log (
                import_type, file_name, total_rows, inserted_rows,
                skipped_duplicate, skipped_error, error_summary, imported_by
             ) VALUES (
                :import_type, :file_name, :total_rows, :inserted_rows,
                :skipped_duplicate, :skipped_error, :error_summary, :imported_by
             )',
            [
               'import_type' => 'order_history',
               'file_name' => $ordersFileName . ' + ' . $itemsFileName,
               'total_rows' => $totalRows,
               'inserted_rows' => $insertedRows,
               'skipped_duplicate' => $skippedDuplicate,
               'skipped_error' => $skippedError,
               'error_summary' => json_encode([
                  'orders_inserted' => $ordersInserted,
                  'orders_skipped_duplicate' => $ordersSkippedDuplicate,
                  'orders_skipped_error' => $ordersSkippedError,
                  'items_inserted' => $itemsInserted,
                  'items_skipped_duplicate' => $itemsSkippedDuplicate,
                  'items_skipped_error' => $itemsSkippedError,
               ], JSON_UNESCAPED_UNICODE),
               'imported_by' => $createdBy,
            ]
         );

         $this->db->commit();
      } catch (\Throwable $e) {
         $this->db->rollback();
         throw $e;
      }

      return [
         'orders_inserted' => $ordersInserted,
         'orders_skipped_duplicate' => $ordersSkippedDuplicate,
         'orders_skipped_error' => $ordersSkippedError,
         'items_inserted' => $itemsInserted,
         'items_skipped_duplicate' => $itemsSkippedDuplicate,
         'items_skipped_error' => $itemsSkippedError,
         'inserted' => $ordersInserted + $itemsInserted,
         'skipped_duplicate' => $ordersSkippedDuplicate + $itemsSkippedDuplicate,
         'skipped_error' => $ordersSkippedError + $itemsSkippedError,
      ];
   }

   private function parseFile($filePath, array $expectedHeaders, $type) {
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
         $this->validateHeaders($headers, $expectedHeaders);

         $rows = [];
         $lineNumber = 1;
         $seenKeys = [];

         while (($data = fgetcsv($handle, 0, $delimiter)) !== false) {
            $lineNumber++;

            if ($this->isEmptyRow($data)) {
               continue;
            }

            if (count($data) !== count($headers)) {
               $rows[] = $this->buildInvalidRow($lineNumber, $headers, $data, 'Jumlah kolom tidak sesuai header.');
               continue;
            }

            $assoc = [];
            foreach ($headers as $index => $header) {
               $assoc[$header] = $this->cleanCell($data[$index] ?? '');
            }

            if ($type === 'orders') {
               $rows[] = $this->validateOrderRow($lineNumber, $assoc, $seenKeys);
            } else {
               $rows[] = $this->validateOrderItemRow($lineNumber, $assoc, $seenKeys);
            }
         }
      } finally {
         fclose($handle);
      }

      return $rows;
   }

   private function validateOrderRow($lineNumber, array $row, array &$seenKeys) {
      $base = array_merge(['line' => $lineNumber, 'status' => 'invalid', 'message' => null, 'payload' => null], $row);

      $kodeOrder = trim((string) ($row['kode_order'] ?? ''));
      $jenis = trim((string) ($row['jenis'] ?? ''));
      $tanggal = trim((string) ($row['tanggal'] ?? ''));

      if ($kodeOrder === '' || $jenis === '' || $tanggal === '') {
         return $this->finalizeRow($base, 'invalid', 'jenis, kode_order, dan tanggal wajib diisi.');
      }

      if (strlen($kodeOrder) > 15) {
         return $this->finalizeRow($base, 'invalid', 'kode_order maksimal 15 karakter.');
      }

      if (!$this->isValidDate($tanggal)) {
         return $this->finalizeRow($base, 'invalid', 'Format tanggal tidak valid.');
      }

      if (isset($seenKeys[$kodeOrder])) {
         return $this->finalizeRow($base, 'duplicate_in_file', 'kode_order duplikat dalam file CSV.');
      }
      $seenKeys[$kodeOrder] = true;

      $duplicate = $this->db->fetchOne(
         'SELECT id FROM orders WHERE kode_order = :kode_order LIMIT 1',
         \Phalcon\Db::FETCH_ASSOC,
         ['kode_order' => $kodeOrder]
      );
      if ($duplicate) {
         return $this->finalizeRow($base, 'duplicate', 'kode_order sudah ada di database.');
      }

      $payload = [
         'jenis' => substr($jenis, 0, 15),
         'kode_order' => $kodeOrder,
         'tanggal' => $this->normalizeDate($tanggal),
         'jam' => $this->normalizeTime($row['jam'] ?? ''),
         'nama' => $this->nullableString($row['nama'] ?? '', 50),
         'jml_org' => $this->nullableInt($row['jml_org'] ?? ''),
         'meja' => $this->nullableString($row['meja'] ?? '', 50),
         'sub_total' => $this->nullableNumeric($row['sub_total'] ?? ''),
         'discount' => $this->nullableNumeric($row['discount'] ?? ''),
         'pajak' => $this->nullableNumeric($row['pajak'] ?? ''),
         'total_bayar' => $this->nullableNumeric($row['total_bayar'] ?? ''),
         'nom_uang' => $this->nullableNumeric($row['nom_uang'] ?? ''),
         'kembalian' => $this->nullableNumeric($row['kembalian'] ?? ''),
         'note' => $this->nullableString($row['note'] ?? '', 100),
      ];

      return $this->finalizeRow($base, 'ready', null, $payload);
   }

   private function validateOrderItemRow($lineNumber, array $row, array &$seenKeys) {
      $base = array_merge(['line' => $lineNumber, 'status' => 'invalid', 'message' => null, 'payload' => null], $row);

      $kodeOrder = trim((string) ($row['kode_order'] ?? ''));
      $item = trim((string) ($row['item'] ?? ''));
      $jenis = trim((string) ($row['jenis'] ?? ''));

      if ($kodeOrder === '' || $item === '' || $jenis === '') {
         return $this->finalizeRow($base, 'invalid', 'jenis, kode_order, dan item wajib diisi.');
      }

      if (strlen($kodeOrder) > 15) {
         return $this->finalizeRow($base, 'invalid', 'kode_order maksimal 15 karakter.');
      }

      if (strlen($item) > 100) {
         return $this->finalizeRow($base, 'invalid', 'item maksimal 100 karakter.');
      }

      $compositeKey = $kodeOrder . '||' . $item;
      if (isset($seenKeys[$compositeKey])) {
         return $this->finalizeRow($base, 'duplicate_in_file', 'kode_order + item duplikat dalam file CSV.');
      }
      $seenKeys[$compositeKey] = true;

      $duplicate = $this->db->fetchOne(
         'SELECT 1 AS found FROM order_items
          WHERE kode_order = :kode_order AND item = :item
          LIMIT 1',
         \Phalcon\Db::FETCH_ASSOC,
         ['kode_order' => $kodeOrder, 'item' => $item]
      );
      if ($duplicate) {
         return $this->finalizeRow($base, 'duplicate', 'kode_order + item sudah ada di database.');
      }

      $qty = trim((string) ($row['qty'] ?? ''));
      if ($qty !== '' && !is_numeric($qty)) {
         return $this->finalizeRow($base, 'invalid', 'qty harus angka.');
      }

      $payload = [
         'jenis' => substr($jenis, 0, 15),
         'kode_order' => $kodeOrder,
         'item' => $item,
         'qty' => $qty === '' ? null : (float) $qty,
         'satuan' => $this->nullableString($row['satuan'] ?? '', 15),
         'qty_ekor' => $this->nullableInt($row['qty_ekor'] ?? ''),
         'harga' => $this->nullableNumeric($row['harga'] ?? ''),
         'discount' => $this->nullableNumeric($row['discount'] ?? ''),
         'total' => $this->nullableNumeric($row['total'] ?? ''),
      ];

      return $this->finalizeRow($base, 'ready', null, $payload);
   }

   private function buildInvalidRow($lineNumber, array $headers, array $data, $message) {
      $row = ['line' => $lineNumber, 'status' => 'invalid', 'message' => $message, 'payload' => null];
      foreach ($headers as $index => $header) {
         $row[$header] = (string) ($data[$index] ?? '');
      }
      return $row;
   }

   private function finalizeRow(array $base, $status, $message = null, array $payload = null) {
      $base['status'] = $status;
      $base['message'] = $message;
      $base['payload'] = $payload;
      return $base;
   }

   private function validateHeaders(array $headers, array $expectedHeaders) {
      $missing = array_diff($expectedHeaders, $headers);
      $extra = array_diff($headers, $expectedHeaders);

      if ($missing || $extra || count($headers) !== count($expectedHeaders)) {
         throw new \RuntimeException(
            'Header CSV tidak valid. Kolom wajib: ' . implode(', ', $expectedHeaders)
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

   private function cleanCell($value) {
      return trim((string) $value, " \t\n\r\0\x0B\"'");
   }

   private function isValidDate($value) {
      return (bool) preg_match('/^\d{4}-\d{2}-\d{2}$/', $value);
   }

   private function normalizeDate($value) {
      return substr(trim($value), 0, 10);
   }

   private function normalizeTime($value) {
      $value = trim((string) $value, "\"'");
      if ($value === '') {
         return null;
      }
      if (preg_match('/^(\d{1,2}:\d{2}:\d{2})/', $value, $matches)) {
         return $matches[1];
      }
      return substr($value, 0, 8);
   }

   private function nullableString($value, $maxLength) {
      $value = trim((string) $value, "\"'");
      if ($value === '') {
         return null;
      }
      return substr($value, 0, $maxLength);
   }

   private function nullableInt($value) {
      $value = trim((string) $value, "\"'");
      if ($value === '' || !is_numeric($value)) {
         return null;
      }
      return (int) round((float) $value);
   }

   private function nullableNumeric($value) {
      $value = trim((string) $value, "\"'");
      if ($value === '' || !is_numeric($value)) {
         return null;
      }
      return (float) $value;
   }
}
