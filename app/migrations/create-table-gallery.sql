-- Active: 1776057900509@@192.168.1.3@5432@ngrembel_asri@public
-- DROP TABLE gallery;
CREATE TABLE gallery (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    title VARCHAR(255) NOT NULL,
    description TEXT,
    category VARCHAR(20) NOT NULL, -- WAHANA / AREA / EVENT
    type_media VARCHAR(20) NOT NULL, -- VIDEO / FOTO
    resource_url TEXT, -- URL video atau path foto
    -- urutan INTEGER,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    create_by UUID,
    update_by UUID
);

COMMENT ON TABLE gallery IS 'tabel untuk menyimpan data gallery';
COMMENT ON COLUMN gallery.title IS 'judul gallery';
COMMENT ON COLUMN gallery.description IS 'deskripsi gallery';
COMMENT ON COLUMN gallery.category IS 'kategori gallery (WAHANA / AREA / EVENT)';
COMMENT ON COLUMN gallery.type_media IS 'tipe media (VIDEO / FOTO)';
COMMENT ON COLUMN gallery.resource_url IS 'url video atau path foto';
-- COMMENT ON COLUMN gallery.urutan IS 'nomor urut gallery';
COMMENT ON COLUMN gallery.is_active IS 'status keaktifan gallery';
SELECT * FROM gallery;
INSERT INTO gallery(title, description, category, type_media, resource_url) VALUES
('PT VERSIGENT', 'Acara FUN GAMES, PAINTBALL & MAKAN BARENG', 'EVENT', 'VIDEO', ''),
('PT VERSIGENT', 'Acara PAINTBALL', 'EVENT', 'FOTO', ''),
('PT VERSIGENT', 'Acara PAINTBALL', 'EVENT', 'FOTO', ''),
('PT VERSIGENT', 'Acara PAINTBALL', 'EVENT', 'FOTO', ''),
('PT VERSIGENT', 'Acara FUN GAMES', 'EVENT', 'FOTO', ''),
('PT VERSIGENT', 'Acara FUN GAMES', 'EVENT', 'FOTO', ''),
('PT VERSIGENT', 'Acara MAKAN BARENG', 'EVENT', 'FOTO', ''),
('TK CERIA ANAKKU GENUK', 'Acara FIELDTRIP dan MAKAN BARENG', 'EVENT', 'VIDEO', ''),
('TK CERIA ANAKKU GENUK', 'Acara FIELDTRIP dan MAKAN BARENG', 'EVENT', 'FOTO', ''),
('TK CERIA ANAKKU GENUK', 'Acara FIELDTRIP', 'EVENT', 'FOTO', ''),
('TK CERIA ANAKKU GENUK', 'Acara MAKAN BARENG', 'EVENT', 'FOTO', '');
