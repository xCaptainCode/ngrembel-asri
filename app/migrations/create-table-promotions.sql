-- Active: 1776004703790@@127.0.0.1@5432@ngrembel_asri@public
CREATE TABLE promotions (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    image_url VARCHAR(255),
    start_date TIMESTAMP NOT NULL,
    end_date TIMESTAMP NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
COMMENT ON TABLE promotions IS 'Tabel promosi yang berisi informasi promosi berupa gambar, deskripsi, dan tanggal berlaku';
COMMENT ON COLUMN promotions.id IS 'ID promosi';
COMMENT ON COLUMN promotions.name IS 'Nama promosi';
COMMENT ON COLUMN promotions.description IS 'Deskripsi promosi';
COMMENT ON COLUMN promotions.image_url IS 'URL gambar promosi';
COMMENT ON COLUMN promotions.start_date IS 'Tanggal mulai promosi';
COMMENT ON COLUMN promotions.end_date IS 'Tanggal berakhirnya promosi';
COMMENT ON COLUMN promotions.is_active IS 'Status promosi aktif atau tidak (1 = aktif, 0 = tidak aktif)';
COMMENT ON COLUMN promotions.created_at IS 'Tanggal promosi dibuat';
COMMENT ON COLUMN promotions.updated_at IS 'Tanggal promosi terakhir diupdate';