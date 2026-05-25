<?php

use Phalcon\Mvc\Controller;

class KritiksaranController extends Controller {

    public function indexAction() {
        if ($this->request->isPost()) {
            $type = trim((string) $this->request->getPost('type', 'string'));
            $nama = trim((string) $this->request->getPost('nama', 'string'));
            $kritikSaranInput = trim((string) $this->request->getPost('kritik_saran', 'string'));

            if ($nama === '' || $kritikSaranInput === '' || !in_array($type, ['kritik', 'saran'], true)) {
                $this->session->set('krisa_error', 'Semua field wajib diisi dengan benar.');
                return $this->response->redirect('kritik-saran');
            }

            try {
                // Insert using the model
                $krisa = new KritikSaran();
                $krisa->type = $type;
                $krisa->nama = $nama;
                $krisa->kritik_saran = $kritikSaranInput;
                $krisa->is_published = true;
                $krisa->created_at = date('Y-m-d H:i:s');

                if ($krisa->save() === false) {
                    $messages = [];
                    foreach ($krisa->getMessages() as $message) {
                        $messages[] = $message->getMessage();
                    }
                    $this->session->set('krisa_error', 'Gagal menyimpan: ' . implode(', ', $messages));
                } else {
                    $this->session->set('krisa_success', 'Terima kasih! Kritik dan saran Anda berhasil dikirim.');
                }
            } catch (\Throwable $e) {
                $this->session->set('krisa_error', 'Gagal menyimpan data: ' . $e->getMessage());
            }

            return $this->response->redirect('kritik-saran');
        }

        // Ambil 5 data pertama yang dipublikasikan
        $items = $this->db->fetchAll(
            "SELECT ks.*, m.nama AS admin_nama 
             FROM kritik_saran ks 
             LEFT JOIN members m ON CAST(ks.responded_by AS TEXT) = CAST(m.id AS TEXT) 
             WHERE ks.is_published = TRUE 
             ORDER BY ks.created_at DESC 
             LIMIT 5",
            \Phalcon\Db::FETCH_ASSOC
        );

        // implementasikan fungsi formatIndonesianDate()
        foreach ($items as &$item) {
            $item['created_at'] = $this->formatIndonesianDate($item['created_at']);
            $item['responded_at'] = $this->formatIndonesianDate($item['responded_at']);
        }

        $this->view->setVar('items', $items ?: []);
        $this->view->setVar('successMsg', $this->session->get('krisa_success'));
        $this->view->setVar('errorMsg', $this->session->get('krisa_error'));
        $this->session->remove('krisa_success');
        $this->session->remove('krisa_error');
    }

    public function loadMoreAction() {
        $this->view->disable();

        if (!$this->request->isAjax()) {
            return $this->response->setStatusCode(400, 'Bad Request')->setJsonContent([
                'status' => 'error',
                'message' => 'Only AJAX requests are allowed'
            ]);
        }

        $search = trim((string) $this->request->getQuery('search', 'string'));
        $offset = (int) $this->request->getQuery('offset', 'int', 5);
        if ($offset < 0) {
            $offset = 0;
        }

        try {
            $bindings = [];
            $whereClause = "WHERE ks.is_published = TRUE";

            if ($search !== '') {
                $whereClause .= " AND (ks.nama ILIKE :search OR ks.kritik_saran ILIKE :search)";
                $bindings['search'] = '%' . $search . '%';
            }

            // Gunakan LIMIT 6 untuk mendeteksi has_more
            $sql = "SELECT ks.*, m.nama AS admin_nama 
                    FROM kritik_saran ks 
                    LEFT JOIN members m ON CAST(ks.responded_by AS TEXT) = CAST(m.id AS TEXT) 
                    {$whereClause} 
                    ORDER BY ks.created_at DESC 
                    LIMIT 6 OFFSET :offset";

            $bindings['offset'] = $offset;

            $rows = $this->db->fetchAll($sql, \Phalcon\Db::FETCH_ASSOC, $bindings);
            
            $hasMore = false;
            if (count($rows) > 5) {
                $hasMore = true;
                array_pop($rows); // Hapus item ke-6
            }

            // Format tanggal Indonesia
            foreach ($rows as &$row) {
                if (!empty($row['created_at'])) {
                    $row['formatted_created'] = $this->formatIndonesianDate($row['created_at']);
                }
                if (!empty($row['responded_at'])) {
                    $row['formatted_responded'] = $this->formatIndonesianDate($row['responded_at']);
                }
            }

            return $this->response->setJsonContent([
                'status' => 'success',
                'data' => $rows,
                'has_more' => $hasMore
            ]);

        } catch (\Throwable $e) {
            return $this->response->setStatusCode(500, 'Internal Server Error')->setJsonContent([
                'status' => 'error',
                'message' => $e->getMessage()
            ]);
        }
    }

    private function formatIndonesianDate($timestamp) {
        $time = strtotime($timestamp);
        if (!$time) return '';

        $days = ['Minggu', 'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu'];
        $months = [
            1 => 'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni', 
            'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
        ];

        $dayName = $days[date('w', $time)];
        $dayNum = date('j', $time);
        $monthName = $months[(int)date('n', $time)];
        $year = date('Y', $time);
        $hourMin = date('H:i', $time);

        return "{$dayName}, {$dayNum} {$monthName} {$year} - {$hourMin}";
    }

}
