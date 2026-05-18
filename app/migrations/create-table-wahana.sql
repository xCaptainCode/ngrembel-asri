-- wahana   id, nama, slug, deskripsi, foto, harga_tiket, syarat, is_active, urutan
CREATE TABLE wahana (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid (),
    nama VARCHAR(255) NOT NULL,
    slug VARCHAR(255) UNIQUE NOT NULL,
    harga_tiket INTEGER,
    deskripsi TEXT,
    foto_url TEXT,
    urutan INTEGER,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by UUID,
    updated_by UUID
);