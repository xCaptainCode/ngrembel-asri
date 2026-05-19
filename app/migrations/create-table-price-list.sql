-- Active: 1775871811697@@192.168.1.3@5432@ngrembel_asri
-- DROP TABLE IF EXISTS price_list CASCADE;
CREATE TABLE price_list (
   id UUID PRIMARY KEY DEFAULT gen_random_uuid (),
   kategori VARCHAR(50) NOT NULL, -- RESTORAN, WAHANA, PAINTBALL, FIELD TRIP, FUN GAME
   nama VARCHAR(255) NOT NULL, -- IKAN, MAKANAN, MINUMAN, PAKET A, PAKET B, PERMAINAN 1, PERMAINAN 2
   img_url VARCHAR(255),
   no_urut INTEGER,
   is_active BOOLEAN DEFAULT TRUE,
   created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
   created_by UUID REFERENCES "public"."members" (id),
   updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
   updated_by UUID REFERENCES "public"."members" (id)
);

COMMENT ON TABLE price_list IS 'tabel untuk menyimpan daftar harga';
COMMENT ON COLUMN price_list.kategori IS 'kategori harga (RESTORAN, WAHANA, PAINTBALL, FIELD TRIP, FUN GAME)';
COMMENT ON COLUMN price_list.nama IS 'nama price list (IKAN, MAKANAN, MINUMAN, PAKET A, PAKET B, PERMAINAN 1, PERMAINAN 2)';
COMMENT ON COLUMN price_list.img_url IS 'url gambar price list';
COMMENT ON COLUMN price_list.no_urut IS 'nomor urut price list';
COMMENT ON COLUMN price_list.is_active IS 'status keaktifan price list';
COMMENT ON COLUMN price_list.created_at IS 'tanggal pembuatan price list';
COMMENT ON COLUMN price_list.created_by IS 'user yang membuat price list';
COMMENT ON COLUMN price_list.updated_at IS 'tanggal pembaruan price list';
COMMENT ON COLUMN price_list.updated_by IS 'user yang memperbarui price list';

INSERT INTO price_list (kategori, nama, img_url, no_urut, is_active, created_at, created_by, updated_at, updated_by) 
VALUES
('RESOTRAN', 'MENU IKAN', '', 1, TRUE, CURRENT_TIMESTAMP, NULL, CURRENT_TIMESTAMP, NULL),
('RESOTRAN', 'MENU MAKANAN', '', 2, TRUE, CURRENT_TIMESTAMP, NULL, CURRENT_TIMESTAMP, NULL),
('RESOTRAN', 'MENU MINUMAN', '', 3, TRUE, CURRENT_TIMESTAMP, NULL, CURRENT_TIMESTAMP, NULL),
('RESOTRAN', 'PAKET MAKAN 10 ORANG', '', 4, TRUE, CURRENT_TIMESTAMP, NULL, CURRENT_TIMESTAMP, NULL),
('RESOTRAN', 'PAKET MAKAN & PAINTBALL 10 ORANG', '', 5, TRUE, CURRENT_TIMESTAMP, NULL, CURRENT_TIMESTAMP, NULL),
('WAHANA', 'WAHANA 1', '', 1, TRUE, CURRENT_TIMESTAMP, NULL, CURRENT_TIMESTAMP, NULL),
('WAHANA', 'WAHANA 2', '', 2, TRUE, CURRENT_TIMESTAMP, NULL, CURRENT_TIMESTAMP, NULL),
('PAINTBALL', 'PAINTBALL', '', 3, TRUE, CURRENT_TIMESTAMP, NULL, CURRENT_TIMESTAMP, NULL),
('FIELD TRIP', 'FIELD TRIP', '', 4, TRUE, CURRENT_TIMESTAMP, NULL, CURRENT_TIMESTAMP, NULL),
('FUN GAME', 'FUN GAME', '', 5, TRUE, CURRENT_TIMESTAMP, NULL, CURRENT_TIMESTAMP, NULL);

SELECT * FROM price_list;

-- table jenis_masakan
CREATE TABLE jenis_masakan (
   id UUID PRIMARY KEY DEFAULT gen_random_uuid (),
   nama VARCHAR(255) NOT NULL,
   deskripsi TEXT,
   img_url VARCHAR(255),
   no_urut INTEGER,
   is_active BOOLEAN DEFAULT TRUE,
   created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
   created_by UUID REFERENCES "public"."members" (id),
   updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
   updated_by UUID REFERENCES "public"."members" (id)
);

COMMENT ON TABLE jenis_masakan IS 'tabel untuk menyimpan jenis masakan';
COMMENT ON COLUMN jenis_masakan.nama IS 'nama jenis masakan (IKAN, MAKANAN, MINUMAN)';
COMMENT ON COLUMN jenis_masakan.deskripsi IS 'deskripsi jenis masakan';
COMMENT ON COLUMN jenis_masakan.img_url IS 'url gambar jenis masakan';
COMMENT ON COLUMN jenis_masakan.no_urut IS 'nomor urut jenis masakan';
COMMENT ON COLUMN jenis_masakan.is_active IS 'status keaktifan jenis masakan';
COMMENT ON COLUMN jenis_masakan.created_at IS 'tanggal pembuatan jenis masakan';
COMMENT ON COLUMN jenis_masakan.created_by IS 'user yang membuat jenis masakan';
COMMENT ON COLUMN jenis_masakan.updated_at IS 'tanggal pembaruan jenis masakan';
COMMENT ON COLUMN jenis_masakan.updated_by IS 'user yang memperbarui jenis masakan';

INSERT INTO jenis_masakan (nama, deskripsi, img_url, no_urut, is_active, created_at, created_by, updated_at, updated_by) 
VALUES
('BAKAR KLASIK', 'Bakar klasik adalah menu ikan legendaris di Ngrembel Asri yang paling diminati. Menu ini merupakan varian menu pertama yang dikeluarkan, sehingga menjadikan Ngrembel Asri mendapatkan gelar Ahlinya Ikan Bakar.', '', 1, TRUE, CURRENT_TIMESTAMP, NULL, CURRENT_TIMESTAMP, NULL),
('ACAR', 'Warna kuning alami yang berasal dari kunyit dengan tekstur kental yakni perpaduan antara bumbu kemiri dan racikan bahan lainnya menghadirkan aroma yang khas dari ikan bumbu acar ini.', '', 2, TRUE, CURRENT_TIMESTAMP, NULL, CURRENT_TIMESTAMP, NULL),
('ASAM MANIS', 'Cocok bagi penikmat kuliner yang rasanya kompleks. Ikan goreng dengan dipadukan saus asam manis dan taburan nanas segar, daun bawang dan wortel dnggan bahan-bahan berkualitas menjadikan perpaduan yang istimewa.', '', 3, TRUE, CURRENT_TIMESTAMP, NULL, CURRENT_TIMESTAMP, NULL),
('BAKAR ORI', 'Menu masakan ikan dengan daging ikan yang lembut tanpa melalui proses penggorengan melainkan dari ikan segar langsung diproses bakar dengan bara api kecil demi menghasilkan cita rasa kematangan daging yang sempurna.', '', 4, TRUE, CURRENT_TIMESTAMP, NULL, CURRENT_TIMESTAMP, NULL),
('BAKAR PEDAS', 'Menu iikan bakar pedas diciptakan bagi para pecinta masakan pedas, pemilihan rempah-rempah dengan aroma dan cita rasa yang khas dengan irisan bawang bobay diatasnya menjadikan ikan bakar pedas menggugah selera.', '', 5, TRUE, CURRENT_TIMESTAMP, NULL, CURRENT_TIMESTAMP, NULL),
('BUMBU BALI', 'Ikan goreng yang di celupkan bumbu alami yakni perpaduan dari cabe merah segar, rempah-rempah asli insdonesia kemudian diolah oleh tangan ahli menjadikan menu masakan bumbu bali semakin menggoda untuk segera dinikmati.', '', 6, TRUE, CURRENT_TIMESTAMP, NULL, CURRENT_TIMESTAMP, NULL);

SELECT * FROM jenis_masakan;