-- Active: 1775871655040@@127.0.0.1@5432@ngrembel_asri
-- members	id, no_member, nama, email, no_hp, password (hashed), level, total_poin, foto, created_at
-- poin_transaksi	id, member_id (FK), tipe [masuk|keluar], jumlah_poin, keterangan, created_by, tanggal
-- transaksi	id, member_id (FK), kode_transaksi, total_bayar, keterangan, tanggal_transaksi
-- promo	id, judul, deskripsi, syarat, level_minimum, berlaku_mulai, berlaku_sampai, kuota, sisa_kuota
-- wahana	id, nama, slug, deskripsi, foto, harga_tiket, syarat, is_active, urutan
-- menu	id, nama, kategori, deskripsi, foto, harga, is_available, urutan
-- fasilitas	id, nama, ikon, deskripsi, foto, urutan
-- feedback	id, nama, email, kategori, rating (1-5), pesan, ip_address, created_at
-- password_resets	email, token (hashed), created_at, used_at
-- sessions	id, member_id (FK), token, ip_address, user_agent, last_activity, expired_at

CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- CREATE TABLE users (
--    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
--    username VARCHAR(255) UNIQUE NOT NULL,
--    password TEXT NOT NULL
-- );
-- INSERT INTO users (username, password) VALUES ('admin', crypt('admin123', gen_salt('bf')));
-- SELECT * FROM users;
-- SELECT * FROM users WHERE username = 'admin' AND password = crypt('admin123', password);

CREATE TABLE members (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid (),
    no_member VARCHAR(255) UNIQUE NOT NULL,
    nama VARCHAR(255) NOT NULL,
    no_hp VARCHAR(255) UNIQUE,
    email VARCHAR(255) UNIQUE,
    tgl_lahir DATE,
    gender CHAR(1) CHECK (gender IN ('L', 'P')),
    kota VARCHAR(255),
    alamat TEXT,
    password TEXT NOT NULL,
    tgl_daftar TIMESTAMP DEFAULT NOW(),
    is_active BOOLEAN DEFAULT TRUE
);

COMMENT ON TABLE members IS 'tabel untuk menyimpan data member NGREMBEL ASRI';

COMMENT ON COLUMN members.no_member IS 'nomor member unik yang terdiri dari 3 bagian: prefix + tanggal daftar + nomor urut, contoh: MBR202406010001';

COMMENT ON COLUMN members.nama IS 'nama lengkap member';

COMMENT ON COLUMN members.no_hp IS 'nomor handphone member';

COMMENT ON COLUMN members.email IS 'alamat email member';

COMMENT ON COLUMN members.tgl_lahir IS 'tanggal lahir member';

COMMENT ON COLUMN members.gender IS 'jenis kelamin member';

COMMENT ON COLUMN members.kota IS 'kota tempat tinggal member';

COMMENT ON COLUMN members.alamat IS 'alamat lengkap member';

COMMENT ON COLUMN members.password IS 'password member yang sudah di-hash menggunakan algoritma bcrypt';

COMMENT ON COLUMN members.tgl_daftar IS 'tanggal pendaftaran member';

COMMENT ON COLUMN members.is_active IS 'status keaktifan member: TRUE jika aktif, FALSE jika nonaktif';

CREATE TABLE poin_transaksi (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid (),
    kode_order VARCHAR(12) UNIQUE NOT NULL,
    member_id UUID REFERENCES members (id) ON DELETE CASCADE,
    tipe VARCHAR(10) CHECK (tipe IN ('masuk', 'keluar')),
    jumlah_poin INTEGER NOT NULL,
    keterangan TEXT,
    created_by VARCHAR(255),
    created_at TIMESTAMP DEFAULT NOW()
);

SELECT * FROM members;

SELECT * FROM poin_transaksi;

-- =========================================
-- FUNCTION GENERATE NO MEMBER
-- FORMAT:
-- MBR202605110001
-- =========================================

CREATE OR REPLACE FUNCTION generate_no_member()
RETURNS VARCHAR AS
$$
DECLARE
    v_tanggal VARCHAR;
    v_urut INTEGER;
    v_no_member VARCHAR;
BEGIN

    -- Ambil tanggal hari ini
    v_tanggal := TO_CHAR(NOW(), 'YYYYMMDD');

    -- Ambil nomor urut terakhir hari ini
    SELECT COALESCE(
        MAX(RIGHT(no_member, 4)::INTEGER),
        0
    ) + 1
    INTO v_urut
    FROM members
    WHERE no_member LIKE 'MBR' || v_tanggal || '%';

    -- Generate no_member
    v_no_member :=
        'MBR' ||
        v_tanggal ||
        LPAD(v_urut::TEXT, 4, '0');

    RETURN v_no_member;

END;
$$
LANGUAGE plpgsql;

SELECT * FROM generate_no_member ();

ALTER TABLE members
ALTER COLUMN no_member
SET DEFAULT generate_no_member ();

INSERT INTO
    members (nama, no_hp, email, password)
VALUES (
        'John Doe',
        '081234567890',
        'john.doe@example.com',
        crypt (
            'password123',
            gen_salt ('bf')
        )
    );

SELECT * FROM members;

SELECT id, no_member, nama, no_hp, email
FROM members
WHERE
    email = 'john.doe@example.com'
    AND password = crypt ('password123', password)
    AND is_active = TRUE
LIMIT 1

ALTER TABLE members ADD COLUMN role VARCHAR(10) DEFAULT 'member';

SELECT * FROM members;

-- INSERT INTO members (nama, no_hp, email, password, role) VALUES ('Admin', '08135792468', 'admin@example.com', crypt('admin123', gen_salt('bf')), 'admin');