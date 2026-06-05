<?php

use Phalcon\Mvc\Controller;
use Intervention\Image\ImageManagerStatic as Image;

class GalleryController extends Controller {

    private $originalDir;
    private $thumbSmDir;
    private $thumbMdDir;
    private $posterDir;

    public function initialize() {
        $this->originalDir = BASE_PATH . '/public/storage/originals/';
        $this->thumbSmDir  = BASE_PATH . '/public/storage/thumbnails/sm/';
        $this->thumbMdDir  = BASE_PATH . '/public/storage/thumbnails/md/';
        $this->posterDir   = BASE_PATH . '/public/storage/thumbnails/posters/';
    }

    private $perPage = 12;

    public function indexAction() {
        $search = trim((string)$this->request->getQuery('q', 'string', ''));

        $whereClause = "is_active = true";
        $params = ['limit' => $this->perPage];

        if ($search !== '') {
            $whereClause .= " AND (title ILIKE :search OR description ILIKE :search)";
            $params['search'] = '%' . $search . '%';
        }

        $galleryList = $this->db->fetchAll(
            "SELECT id, title, description, type, thumb_sm_path, poster_path, duration_seconds 
             FROM media_gallery 
             WHERE {$whereClause}
             ORDER BY sort_order ASC, created_at DESC
             LIMIT :limit",
            \Phalcon\Db::FETCH_ASSOC,
            $params
        );

        $countParams = [];
        if ($search !== '') {
            $countParams['search'] = '%' . $search . '%';
        }

        $totalCount = $this->db->fetchOne(
            "SELECT COUNT(*) as total FROM media_gallery WHERE {$whereClause}",
            \Phalcon\Db::FETCH_ASSOC,
            $countParams
        );

        $this->view->setVar('galleryList', $galleryList ?: []);
        $this->view->setVar('totalCount', (int)($totalCount['total'] ?? 0));
        $this->view->setVar('perPage', $this->perPage);
        $this->view->setVar('searchQuery', $search);
        $this->view->pick('galeri/index');
    }

    public function loadMoreAction() {
        $this->view->disable();

        $offset = (int)$this->request->getQuery('offset', 'int', 0);
        $limit  = (int)$this->request->getQuery('limit', 'int', $this->perPage);
        $filter = $this->request->getQuery('filter', 'string', 'all');
        $search = trim((string)$this->request->getQuery('q', 'string', ''));

        // Cap limit to prevent abuse
        if ($limit > 48) $limit = 48;
        if ($limit < 1) $limit = $this->perPage;

        $whereClause = "is_active = true";
        $params = ['limit' => $limit, 'offset' => $offset];

        if ($filter === 'photo' || $filter === 'video') {
            $whereClause .= " AND type = :type";
            $params['type'] = $filter;
        }

        if ($search !== '') {
            $whereClause .= " AND (title ILIKE :search OR description ILIKE :search)";
            $params['search'] = '%' . $search . '%';
        }

        $items = $this->db->fetchAll(
            "SELECT id, title, description, type, thumb_sm_path, poster_path, duration_seconds 
             FROM media_gallery 
             WHERE {$whereClause}
             ORDER BY sort_order ASC, created_at DESC
             LIMIT :limit OFFSET :offset",
            \Phalcon\Db::FETCH_ASSOC,
            $params
        );

        $countParams = [];
        if ($filter === 'photo' || $filter === 'video') {
            $countParams['type'] = $filter;
        }
        if ($search !== '') {
            $countParams['search'] = '%' . $search . '%';
        }

        $totalCount = $this->db->fetchOne(
            "SELECT COUNT(*) as total FROM media_gallery WHERE {$whereClause}",
            \Phalcon\Db::FETCH_ASSOC,
            $countParams
        );

        // Resolve URLs for thumbnails/posters
        $resolved = [];
        foreach ($items as $item) {
            $item['thumb_sm_url'] = $item['thumb_sm_path'] ? $this->url->get($item['thumb_sm_path']) : '';
            $item['poster_url'] = $item['poster_path'] ? $this->url->get($item['poster_path']) : '';
            $resolved[] = $item;
        }

        return $this->jsonResponse([
            'status' => 'ok',
            'data'   => $resolved,
            'total'  => (int)($totalCount['total'] ?? 0),
            'offset' => $offset,
            'limit'  => $limit,
        ]);
    }

    public function detailAction() {
        $this->view->disable();
        $id = $this->dispatcher->getParam('id', 'string');

        if (!$id) {
            return $this->jsonResponse(['status' => 'error', 'message' => 'ID is required'], 400);
        }

        $item = $this->db->fetchOne(
            "SELECT id, title, description, type, thumb_md_path, original_path, poster_path, duration_seconds, view_count, is_active 
             FROM media_gallery 
             WHERE id = :id AND is_active = true LIMIT 1",
            \Phalcon\Db::FETCH_ASSOC,
            ['id' => $id]
        );

        if (!$item) {
            return $this->jsonResponse(['status' => 'error', 'message' => 'Media not found'], 404);
        }

        // Increment view_count
        $this->db->execute(
            "UPDATE media_gallery SET view_count = view_count + 1 WHERE id = :id",
            ['id' => $id]
        );

        $mediaUrl = ($item['type'] === 'photo') ? $item['thumb_md_path'] : $item['original_path'];

        $response = [
            'status' => 'ok',
            'data' => [
                'id' => $item['id'],
                'title' => $item['title'],
                'description' => $item['description'] ?: '',
                'type' => $item['type'],
                'media_url' => $this->url->get($mediaUrl),
                'download_url' => $this->url->get('galeri/download/' . $item['id'])
            ]
        ];

        return $this->jsonResponse($response);
    }

    public function downloadAction() {
        $this->view->disable();

        // Release session lock to prevent blocking concurrent page loads/reloads
        if (session_status() === PHP_SESSION_ACTIVE) {
            session_write_close();
        }

        $id = $this->dispatcher->getParam('id', 'string');

        if (!$id) {
            $this->response->setStatusCode(400);
            return $this->response->setContent('Bad Request: ID required');
        }

        $item = $this->db->fetchOne(
            "SELECT original_path, original_filename, mime_type, is_active 
             FROM media_gallery 
             WHERE id = :id AND is_active = true LIMIT 1",
            \Phalcon\Db::FETCH_ASSOC,
            ['id' => $id]
        );

        if (!$item) {
            $this->response->setStatusCode(404);
            return $this->response->setContent('Media not found');
        }

        $fullPath = BASE_PATH . '/public/' . $item['original_path'];

        if (!file_exists($fullPath)) {
            $this->response->setStatusCode(404);
            return $this->response->setContent('File not found on server');
        }

        // Increment download_count
        $this->db->execute(
            "UPDATE media_gallery SET download_count = download_count + 1 WHERE id = :id",
            ['id' => $id]
        );

        // Safe fallback MIME type if none is stored
        $mimeType = $item['mime_type'] ?: 'application/octet-stream';

        // Clear output buffering to avoid corrupted file downloads
        while (ob_get_level() > 0) {
            ob_end_clean();
        }

        $this->response->setContentType($mimeType);
        $this->response->setHeader(
            'Content-Disposition',
            'attachment; filename="' . basename($item['original_filename']) . '"'
        );
        $this->response->setHeader('Content-Length', filesize($fullPath));

        $this->response->sendHeaders();
        readfile($fullPath);
        exit;
    }

    public function uploadFormAction() {
        // Protect: Admin only
        if (strtolower((string)$this->session->get('role')) !== 'admin') {
            return $this->response->redirect('');
        }
        $this->view->pick('galeri/upload');
    }

    public function uploadProcessAction() {
        $this->view->disable();
        
        $role = (string)$this->session->get('role');
        $userId = (string)$this->session->get('id');

        // Close session immediately so other requests aren't blocked during upload processing
        if (session_status() === PHP_SESSION_ACTIVE) {
            session_write_close();
        }

        // Protect: Admin only
        if (strtolower($role) !== 'admin') {
            return $this->jsonResponse(['status' => 'error', 'message' => 'Unauthorized'], 403);
        }

        if (!$this->request->isPost() || !isset($_FILES['media_file'])) {
            return $this->jsonResponse(['status' => 'error', 'message' => 'Invalid request'], 400);
        }

        $file = $_FILES['media_file'];
        if ($file['error'] !== UPLOAD_ERR_OK) {
            return $this->jsonResponse(['status' => 'error', 'message' => 'Upload error: ' . $file['error']], 400);
        }

        // Retrieve and sanitize post fields
        $title = trim((string)$this->request->getPost('title', 'string'));
        $description = trim((string)$this->request->getPost('description', 'string'));
        $category = strtoupper(trim((string)$this->request->getPost('category', 'string')));
        $type = strtolower(trim((string)$this->request->getPost('type', 'string')));
        $is_active = $this->request->getPost('is_active') ? true : false;
        $sort_order = (int)$this->request->getPost('sort_order', 'int', 0);

        if ($title === '') {
            return $this->jsonResponse(['status' => 'error', 'message' => 'Title is required'], 400);
        }

        // Validate MIME type
        $finfo = finfo_open(FILEINFO_MIME_TYPE);
        $mimeType = finfo_file($finfo, $file['tmp_name']);
        finfo_close($finfo);

        $allowedPhotoMimes = ['image/jpeg', 'image/png', 'image/webp'];
        $allowedVideoMimes = ['video/mp4', 'video/webm', 'video/quicktime', 'video/x-m4v'];

        if ($type === 'photo') {
            if (!in_array($mimeType, $allowedPhotoMimes, true)) {
                return $this->jsonResponse(['status' => 'error', 'message' => 'Invalid photo type. Allowed: JPG, PNG, WEBP'], 400);
            }
            if ($file['size'] > 10 * 1024 * 1024) { // 10MB
                return $this->jsonResponse(['status' => 'error', 'message' => 'Photo size exceeds 10MB limit'], 400);
            }
        } elseif ($type === 'video') {
            if (!in_array($mimeType, $allowedVideoMimes, true)) {
                return $this->jsonResponse(['status' => 'error', 'message' => 'Invalid video type. Allowed: MP4, WEBM'], 400);
            }
            if ($file['size'] > 100 * 1024 * 1024) { // 100MB
                return $this->jsonResponse(['status' => 'error', 'message' => 'Video size exceeds 100MB limit'], 400);
            }
        } else {
            return $this->jsonResponse(['status' => 'error', 'message' => 'Invalid media type'], 400);
        }

        // Setup paths
        $extension = pathinfo($file['name'], PATHINFO_EXTENSION);
        $uniqueName = uniqid('', true) . '_' . time();
        $originalFilename = $uniqueName . '.' . $extension;
        $originalPath = 'storage/originals/' . $originalFilename;
        $absoluteOriginalPath = $this->originalDir . $originalFilename;

        // Move to originals
        if (!move_uploaded_file($file['tmp_name'], $absoluteOriginalPath)) {
            return $this->jsonResponse(['status' => 'error', 'message' => 'Failed to save original file'], 500);
        }

        $thumbSmPath = null;
        $thumbMdPath = null;
        $posterPath = null;
        $durationSeconds = null;
        $width = null;
        $height = null;

        try {
            if ($type === 'photo') {
                // Dimensions & Resizing
                $img = Image::make($absoluteOriginalPath);
                $width = $img->width();
                $height = $img->height();

                // SM Thumbnail (max width 600px)
                $thumbSmFilename = $uniqueName . '_sm.webp';
                $absoluteThumbSm = $this->thumbSmDir . $thumbSmFilename;
                $img->resize(600, null, function ($constraint) {
                    $constraint->aspectRatio();
                    $constraint->upsize();
                })->encode('webp', 80)->save($absoluteThumbSm);
                $thumbSmPath = 'storage/thumbnails/sm/' . $thumbSmFilename;

                // MD Thumbnail (max width 1200px)
                $thumbMdFilename = $uniqueName . '_md.webp';
                $absoluteThumbMd = $this->thumbMdDir . $thumbMdFilename;
                // Re-read or reuse instance
                $imgMd = Image::make($absoluteOriginalPath);
                $imgMd->resize(1200, null, function ($constraint) {
                    $constraint->aspectRatio();
                    $constraint->upsize();
                })->encode('webp', 85)->save($absoluteThumbMd);
                $thumbMdPath = 'storage/thumbnails/md/' . $thumbMdFilename;

            } elseif ($type === 'video') {
                // Process client-side poster frame (captured via <canvas> in browser)
                $posterDataUrl = $this->request->getPost('poster_data');
                if ($posterDataUrl && preg_match('/^data:image\/(png|jpeg|webp);base64,/', $posterDataUrl, $matches)) {
                    try {
                        $base64Data = preg_replace('/^data:image\/\w+;base64,/', '', $posterDataUrl);
                        $binaryData = base64_decode($base64Data);

                        if ($binaryData !== false && strlen($binaryData) > 0) {
                            $posterFilename = $uniqueName . '_poster.webp';
                            $absolutePoster = $this->posterDir . $posterFilename;

                            // Use Intervention Image to convert the poster frame to webp
                            $posterImg = Image::make($binaryData);
                            $posterImg->resize(1280, null, function ($constraint) {
                                $constraint->aspectRatio();
                                $constraint->upsize();
                            })->encode('webp', 80)->save($absolutePoster);

                            $posterPath = 'storage/thumbnails/posters/' . $posterFilename;

                            // Also create SM thumbnail from poster (max 600px)
                            $thumbSmFilename = $uniqueName . '_sm.webp';
                            $absoluteThumbSm = $this->thumbSmDir . $thumbSmFilename;
                            $posterImgSm = Image::make($binaryData);
                            $posterImgSm->resize(600, null, function ($constraint) {
                                $constraint->aspectRatio();
                                $constraint->upsize();
                            })->encode('webp', 75)->save($absoluteThumbSm);
                            $thumbSmPath = 'storage/thumbnails/sm/' . $thumbSmFilename;

                            // MD thumbnail reuses the poster
                            $thumbMdPath = $posterPath;
                        }
                    } catch (\Exception $e) {
                        error_log("Poster processing failed: " . $e->getMessage());
                    }
                }

                // Accept video metadata from client-side (captured via HTML5 <video> element)
                $clientDuration = $this->request->getPost('video_duration');
                $clientWidth = $this->request->getPost('video_width');
                $clientHeight = $this->request->getPost('video_height');

                if ($clientDuration !== null && $clientDuration !== '' && is_numeric($clientDuration)) {
                    $durationSeconds = (int)round((float)$clientDuration);
                }
                if ($clientWidth !== null && $clientWidth !== '' && is_numeric($clientWidth)) {
                    $width = (int)$clientWidth;
                }
                if ($clientHeight !== null && $clientHeight !== '' && is_numeric($clientHeight)) {
                    $height = (int)$clientHeight;
                }
            }

            // Save to DB
            $sql = "INSERT INTO media_gallery (
                        title, description, category, type, original_filename, original_path,
                        original_size, mime_type, thumb_sm_path, thumb_md_path,
                        poster_path, duration_seconds, width, height, is_active, sort_order, create_by
                    ) VALUES (
                        :title, :description, :category, :type, :original_filename, :original_path,
                        :original_size, :mime_type, :thumb_sm_path, :thumb_md_path,
                        :poster_path, :duration_seconds, :width, :height, :is_active, :sort_order, :create_by
                    )";

            $this->db->execute($sql, [
                'title' => $title,
                'description' => $description === '' ? null : $description,
                'category' => $category,
                'type' => $type,
                'original_filename' => $file['name'],
                'original_path' => $originalPath,
                'original_size' => $file['size'],
                'mime_type' => $mimeType,
                'thumb_sm_path' => $thumbSmPath,
                'thumb_md_path' => $thumbMdPath,
                'poster_path' => $posterPath,
                'duration_seconds' => $durationSeconds,
                'width' => $width,
                'height' => $height,
                'is_active' => $is_active ? 'true' : 'false',
                'sort_order' => $sort_order,
                'create_by' => $userId ?: null
            ]);

            return $this->jsonResponse([
                'status' => 'success',
                'message' => 'Media successfully uploaded and processed'
            ]);

        } catch (\Throwable $e) {
            // Cleanup on error
            if (file_exists($absoluteOriginalPath)) @unlink($absoluteOriginalPath);
            if ($thumbSmPath && file_exists(BASE_PATH . '/public/' . $thumbSmPath)) @unlink(BASE_PATH . '/public/' . $thumbSmPath);
            if ($thumbMdPath && file_exists(BASE_PATH . '/public/' . $thumbMdPath)) @unlink(BASE_PATH . '/public/' . $thumbMdPath);
            if ($posterPath && file_exists(BASE_PATH . '/public/' . $posterPath)) @unlink(BASE_PATH . '/public/' . $posterPath);

            return $this->jsonResponse(['status' => 'error', 'message' => 'Processing failed: ' . $e->getMessage()], 500);
        }
    }

    private function jsonResponse(array $data, int $statusCode = 200) {
        $this->response->setStatusCode($statusCode);
        $this->response->setContentType('application/json');
        $this->response->setJsonContent($data);
        return $this->response->send();
    }
}
