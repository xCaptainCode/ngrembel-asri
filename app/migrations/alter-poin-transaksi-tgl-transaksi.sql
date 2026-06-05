-- Perbaiki typo kolom dan perpanjang kapasitas tanggal transaksi (jika tabel sudah ada)
DO $$
BEGIN
    IF EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_name = 'poin_transaksi' AND column_name = 'tgl_transaski'
    ) THEN
        ALTER TABLE poin_transaksi RENAME COLUMN tgl_transaski TO tgl_transaksi;
    END IF;
END $$;

ALTER TABLE poin_transaksi
ALTER COLUMN tgl_transaksi TYPE VARCHAR(19);
