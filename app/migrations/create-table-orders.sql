-- Active: 1779269040582@@localhost@5432@ngrembel_asri@public
CREATE TABLE orders (
	id SERIAL PRIMARY KEY,
    jenis VARCHAR(15), -- (RESTO, PAINTBALL,, FIELDTRIP)
	kode_order VARCHAR(15),
	tanggal DATE,
	jam TIME,
	nama VARCHAR(50),
    jml_org INT,
	meja VARCHAR(50),
	sub_total NUMERIC,
	discount NUMERIC,
	pajak NUMERIC,
	total_bayar NUMERIC,
	nom_uang NUMERIC,
	kembalian NUMERIC,
	note VARCHAR(100)
);

COMMENT ON TABLE orders IS 'tabel untuk menyimpan data order';
COMMENT ON COLUMN orders.jenis IS 'jenis order: (RESTO, PAINTBALL, FIELDTRIP)';
