-- Active: 1779269040582@@localhost@5432@ngrembel_asri@public
CREATE TABLE mini_zoo (
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

COMMENT ON TABLE mini_zoo IS 'tabel untuk menyimpan data mini zoo';
COMMENT ON COLUMN mini_zoo.nama IS 'nama mini zoo';
COMMENT ON COLUMN mini_zoo.deskripsi IS 'deskripsi mini zoo';
COMMENT ON COLUMN mini_zoo.img_url IS 'url gambar mini zoo';
COMMENT ON COLUMN mini_zoo.is_active IS 'status keaktifan mini zoo';
COMMENT ON COLUMN mini_zoo.created_at IS 'tanggal dibuat';
COMMENT ON COLUMN mini_zoo.created_by IS 'user pembuat';
COMMENT ON COLUMN mini_zoo.updated_at IS 'tanggal diupdate';
COMMENT ON COLUMN mini_zoo.updated_by IS 'user pengupdate';

SELECT * FROM mini_zoo;
