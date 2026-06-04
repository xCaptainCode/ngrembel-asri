
CREATE TABLE registrasi (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid (),
    nama VARCHAR(255) NOT NULL,
    no_hp VARCHAR(255) UNIQUE,
    email VARCHAR(255) UNIQUE,
    tgl_lahir DATE,
    gender CHAR(1) CHECK (gender IN ('L', 'P')),
    kota VARCHAR(255),
    alamat TEXT,
    password TEXT NOT NULL,
    tgl_daftar TIMESTAMP DEFAULT NOW(),
    is_active BOOLEAN DEFAULT TRUE,
    role VARCHAR(10) CHECK (role IN ('admin', 'member')), -- di isi oleh admin, berisi: admin / member
    status VARCHAR(10) CHECK (status IN ('pending', 'active', 'inactive')) DEFAULT 'pending', -- di isi oleh admin, berisi: pending / active / inactive
    updated_at TIMESTAMP DEFAULT NOW(),
    updated_by UUID
);

COMMENT ON TABLE registrasi IS 'tabel untuk menyimpan data registrasi member NGREMBEL ASRI';
COMMENT ON COLUMN registrasi.nama IS 'nama lengkap member, di isi oleh member saat registrasi';
COMMENT ON COLUMN registrasi.no_hp IS 'nomor handphone member, di isi oleh member saat registrasi';
COMMENT ON COLUMN registrasi.email IS 'email member, di isi oleh member saat registrasi';
COMMENT ON COLUMN registrasi.tgl_lahir IS 'tanggal lahir member, di isi oleh member saat registrasi';
COMMENT ON COLUMN registrasi.gender IS 'jenis kelamin member (L/P), di isi oleh member saat registrasi';
COMMENT ON COLUMN registrasi.kota IS 'kota tempat tinggal member, di isi oleh member saat registrasi';
COMMENT ON COLUMN registrasi.alamat IS 'alamat lengkap member, di isi oleh member saat registrasi';
COMMENT ON COLUMN registrasi.password IS 'password member (bcrypt), di isi oleh member saat registrasi';
COMMENT ON COLUMN registrasi.tgl_daftar IS 'tanggal pendaftaran member, di isi oleh sistem saat registrasi';
COMMENT ON COLUMN registrasi.is_active IS 'status keaktifan member (TRUE/FALSE), di isi oleh admin saat registrasi';
COMMENT ON COLUMN registrasi.role IS 'role member (admin/member), di isi oleh admin saat registrasi';
COMMENT ON COLUMN registrasi.status IS 'status member (pending/active/inactive), di isi oleh admin saat registrasi';
COMMENT ON COLUMN registrasi.updated_at IS 'tanggal update data member, di isi oleh admin saat update data';
COMMENT ON COLUMN registrasi.updated_by IS 'user yang update data member, di isi oleh admin saat update data';

SELECT * FROM registrasi;
SELECT * FROM members;