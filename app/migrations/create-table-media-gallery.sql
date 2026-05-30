-- Active: 1779269040582@@localhost@5432@ngrembel_asri@public
CREATE TABLE media_gallery (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    title VARCHAR(255) NOT NULL,
    description TEXT,
    type VARCHAR(10) NOT NULL CHECK (type IN ('photo', 'video')),
    -- File original (for download)
    original_filename VARCHAR(255) NOT NULL,
    original_path VARCHAR(500) NOT NULL,
    original_size BIGINT NOT NULL, -- bytes
    mime_type VARCHAR(100) NOT NULL,
    -- Thumbnail foto (for display)
    thumb_sm_path VARCHAR(500), -- mansory grid display
    thumb_md_path VARCHAR(500), -- lightbox preview
    -- Khusus video
    poster_path VARCHAR(500), -- thumbnail gambar video
    duration_seconds INTEGER, -- panjang video dalam detik
    -- Metadata file
    width INTEGER,
    height INTEGER,
    -- Stats
    view_count INTEGER DEFAULT 0,
    download_count INTEGER DEFAULT 0,
    -- File status
    is_active BOOLEAN DEFAULT true,
    sort_order INTEGER DEFAULT 0,

    created_at TIMESTAMP DEFAULT NOW(),
    create_by UUID,
    updated_at TIMESTAMP DEFAULT NOW(),
    update_by UUID
);

CREATE INDEX idx_mg_type     ON media_gallery(type);
CREATE INDEX idx_mg_active   ON media_gallery(is_active, sort_order, created_at);

SELECT * FROM media_gallery;