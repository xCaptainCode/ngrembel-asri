-- Active: 1776057900509@@192.168.1.3@5432@ngrembel_asri
-- wahana   id, nama, slug, deskripsi, foto, harga_tiket, syarat, is_active, urutan

-- DROP TABLE wahana;
CREATE TABLE wahana (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid (),
    kategori VARCHAR(255) NOT NULL, -- PERMAINAN, PAINTBALL, FIELD TRIP, FUN GAME
    nama VARCHAR(255) NOT NULL, -- ATV, 
    deskripsi TEXT,
    is_free BOOLEAN DEFAULT FALSE,
    harga_tiket INTEGER,
    img_url TEXT,
    urutan INTEGER,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by UUID,
    updated_by UUID
);

COMMENT ON TABLE wahana IS 'tabel untuk menyimpan data wahana';
COMMENT ON COLUMN wahana.kategori IS 'kategori wahana (PERMAINAN, PAINTBALL, FIELD TRIP, FUN GAME)';
COMMENT ON COLUMN wahana.is_free IS 'status tiket gratis';
COMMENT ON COLUMN wahana.harga_tiket IS 'harga tiket wahana';
COMMENT ON COLUMN wahana.img_url IS 'url gambar wahana';
COMMENT ON COLUMN wahana.urutan IS 'nomor urut wahana';
COMMENT ON COLUMN wahana.is_active IS 'status keaktifan wahana';

INSERT INTO wahana(kategori, nama, deskripsi, is_free, harga_tiket, img_url, urutan) VALUES
('PERMAINAN', 'Kuda Tunggang', 'Biarkan putra-putri Anda menikmati serunya mengelilingi area Satwa dengan berkuda.', false, 35000, '', 1),
('PERMAINAN', 'ATV', 'Rasakan sensasi mengendarai armada segala medan di sirkuit yang menantang hanya di Ngremebel Asri.', false, 35000, '', 1),
('PERMAINAN', 'Flying Fox', 'Merupakan wahana permainanoutbound yang diperuntukkan untuk kamu yang suka tantangan sekligus memacu andrenalin, meluncur dari ketinggian diatas Kolam.', false, 30000, '', 2),
('PERMAINAN', 'Kereta Mini', 'Diperuntukkan khusus anak-anak, dengan kereta bertajuk binatang membuat anak-anak semakin berimajinasi dengan duia satwa.', false, 30000, '', 3),
('PERMAINAN', 'Kolam Renang', 'Kolam Renang anak-anak dengan suasana jurassic yang semakin menambah pengetahuan putra-putri Anda untuk mengenal hewan purba.', true, 0, '', 4),
('PERMAINAN', 'Omah Playon', 'Menguji ketangkasan di setiap ruang karena wahana ini terdiri dari berbagar macam halang rintang seperti spidertrap, rumah sesat, bambu goyang dan masih banyak lagi yang lainnya.', true, 0, '', 5),
('PERMAINAN', 'Omah Kayu', 'Permainan ini menguji ketangkasan putra-putri Anda. Mayoritas terbuat dari material alam yang tetap mengutamakan keselamatan dan kenyamanan.', true, 0, '', 6);

SELECT * FROM wahana;