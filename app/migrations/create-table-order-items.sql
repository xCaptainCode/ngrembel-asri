-- Active: 1779269040582@@localhost@5432@ngrembel_asri@public
CREATE TABLE order_items (
  jenis VARCHAR(15), -- (RESTO, PAINTBALL, FIELDTRIP)
	kode_order VARCHAR(15),
	item VARCHAR(100),
	qty NUMERIC,
	satuan VARCHAR(15),
	qty_ekor INT,
	harga NUMERIC,
	discount NUMERIC,
	total NUMERIC
);

COMMENT ON TABLE order_items IS 'tabel untuk menyimpan data order items';
COMMENT ON COLUMN order_items.jenis IS 'jenis order: (RESTO, PAINTBALL, FIELDTRIP)';
