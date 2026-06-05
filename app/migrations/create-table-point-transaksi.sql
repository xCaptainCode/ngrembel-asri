-- DROP TABLE IF EXISTS poin_transaksi;
CREATE TABLE poin_transaksi (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid (),
    member_id UUID REFERENCES members (id) ON DELETE CASCADE,
    tgl_transaksi VARCHAR(19),
    kode_order VARCHAR(12) UNIQUE NOT NULL,
    nominal_transaksi NUMERIC,
    jenis_poin VARCHAR(10) CHECK (jenis_poin IN ('masuk', 'keluar')),
    point INTEGER NOT NULL,
    kategori VARCHAR(10),
    created_by VARCHAR(255),
    created_at TIMESTAMP DEFAULT NOW()
);

SELECT * FROM members;

SELECT * FROM poin_transaksi;
