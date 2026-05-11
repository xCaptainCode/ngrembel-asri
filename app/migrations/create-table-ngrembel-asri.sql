-- CREATE EXTENSION IF NOT EXISTS pgcrypto;
members	id, no_member, nama, email, no_hp, password (hashed), level, total_poin, foto, created_at
poin_transaksi	id, member_id (FK), tipe [masuk|keluar], jumlah_poin, keterangan, created_by, tanggal
transaksi	id, member_id (FK), kode_transaksi, total_bayar, keterangan, tanggal_transaksi
promo	id, judul, deskripsi, syarat, level_minimum, berlaku_mulai, berlaku_sampai, kuota, sisa_kuota
wahana	id, nama, slug, deskripsi, foto, harga_tiket, syarat, is_active, urutan
menu	id, nama, kategori, deskripsi, foto, harga, is_available, urutan
fasilitas	id, nama, ikon, deskripsi, foto, urutan
feedback	id, nama, email, kategori, rating (1-5), pesan, ip_address, created_at
password_resets	email, token (hashed), created_at, used_at
sessions	id, member_id (FK), token, ip_address, user_agent, last_activity, expired_at

CREATE TABLE members(  
   id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
   no_member VARCHAR(255) UNIQUE NOT NULL,
   nama VARCHAR(255) NOT NULL,
   email VARCHAR(255) UNIQUE,
   no_hp VARCHAR(255) UNIQUE,
   password VARCHAR(255) NOT NULL,
   level VARCHAR(255) NOT NULL,
   total_poin INTEGER DEFAULT 0,
   foto VARCHAR(255),
   created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
COMMENT ON TABLE members IS '';
COMMENT ON COLUMN members.name IS '';