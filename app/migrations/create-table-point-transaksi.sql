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
