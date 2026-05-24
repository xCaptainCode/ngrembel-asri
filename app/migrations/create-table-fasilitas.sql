-- Active: 1776004703790@@127.0.0.1@5432@ngrembel_asri@public
CREATE TABLE fasilitas (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nama VARCHAR NOT NULL,
    deskripsi TEXT,
    img_url TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP,
    created_by UUID,
    updated_at TIMESTAMP,
    updated_by UUID
);

COMMENT ON TABLE fasilitas IS 'tabel untuk menyimpan data fasilitas';
COMMENT ON COLUMN fasilitas.nama IS 'nama fasilitas';
COMMENT ON COLUMN fasilitas.deskripsi IS 'deskripsi fasilitas';
COMMENT ON COLUMN fasilitas.img_url IS 'url gambar fasilitas';
COMMENT ON COLUMN fasilitas.is_active IS 'status keaktifan fasilitas';
COMMENT ON COLUMN fasilitas.created_at IS 'tanggal dibuat';
COMMENT ON COLUMN fasilitas.created_by IS 'user pembuat';
COMMENT ON COLUMN fasilitas.updated_at IS 'tanggal diupdate';
COMMENT ON COLUMN fasilitas.updated_by IS 'user pengupdate';

SELECT * FROM fasilitas;
