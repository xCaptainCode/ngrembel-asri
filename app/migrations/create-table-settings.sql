-- Active: 1779269040582@@localhost@5432@ngrembel_asri@public
-- DROP TABLE IF EXISTS settings CASCADE;
-- resert sequence
-- ALTER SEQUENCE setting RESTART WITH 1;
CREATE TABLE settings (
    id SERIAL PRIMARY KEY,
    type_value VARCHAR(255) NOT NULL, -- TEXT / FOTO / VIDEO
    name VARCHAR(255) NOT NULL,
    value TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT NOW(),
    created_by UUID,
    updated_at TIMESTAMP DEFAULT NOW(),
    updated_by UUID
);

INSERT INTO settings (type_value, name, value, created_by) VALUES
('FOTO', 'Slide Image 1', 'images/slide_img_1_20260518_164712_24303177.jpg', 'd2e2bce7-81df-4a9b-8285-9968f6729a65'),
('FOTO', 'Slide Image 2', 'images/slide_image_2_20260523_165837_fdb2fe52.jpg', 'd2e2bce7-81df-4a9b-8285-9968f6729a65'),
('FOTO', 'Slide Image 3', 'images/slide_image_3_20260523_165853_a878b010.jpg', 'd2e2bce7-81df-4a9b-8285-9968f6729a65'),
('FOTO', 'Slide Image 4', 'images/slide_image_4_20260523_165946_681b630e.jpg', 'd2e2bce7-81df-4a9b-8285-9968f6729a65'),
('FOTO', 'Slide Image 5', 'images/slide_image_5_20260523_165958_32f2cf06.jpg', 'd2e2bce7-81df-4a9b-8285-9968f6729a65'),
('TEXT', 'Tagline 1', 'Wisata Termurah Sedunia', 'd2e2bce7-81df-4a9b-8285-9968f6729a65'),
('TEXT', 'Quote 1', 'Pelarian sempurna dari hiruk-pikuk kota — <br> alam hijau dan kenangan tak terlupakan.', 'd2e2bce7-81df-4a9b-8285-9968f6729a65'),
('TEXT', 'Stat 1 Label', 'Hektar Lahan Hijau', 'd2e2bce7-81df-4a9b-8285-9968f6729a65'),
('TEXT', 'Stat 1 Value', '4', 'd2e2bce7-81df-4a9b-8285-9968f6729a65'),
('TEXT', 'Stat 2 Label', 'Jenis Satwa', 'd2e2bce7-81df-4a9b-8285-9968f6729a65'),
('TEXT', 'Stat 2 Value', '50', 'd2e2bce7-81df-4a9b-8285-9968f6729a65'),
('TEXT', 'Stat 3 Label', 'Tahun Berdiri', 'd2e2bce7-81df-4a9b-8285-9968f6729a65'),
('TEXT', 'Stat 3 Value', '25', 'd2e2bce7-81df-4a9b-8285-9968f6729a65'),
('TEXT', 'Stat 4 Label', 'Ribu Pengunjung/Tahun', 'd2e2bce7-81df-4a9b-8285-9968f6729a65'),
('TEXT', 'Stat 4 Value', '260', 'd2e2bce7-81df-4a9b-8285-9968f6729a65'),
('FOTO', 'Sejarah Image', 'images/sejarah_image_20260523_164507_45afcde5.jpg', 'd2e2bce7-81df-4a9b-8285-9968f6729a65'),
('TEXT', 'Sejarah Tahun Berdiri', '2001', 'd2e2bce7-81df-4a9b-8285-9968f6729a65'),
('TEXT', 'Sejarah Title', 'Perjalanan Lebih Dari Dua Dekade', 'd2e2bce7-81df-4a9b-8285-9968f6729a65'),
('TEXT', 'Sejarah Paragraf 1', 'Wisata Ngrembel Asri lahir dari mimpi sederhana — menjaga kelestarian alam lokal sekaligus menciptakan ruang bermain yang edukatif. Berdiri di kaki perbukitan yang sejuk, wisata ini telah menjadi destinasi favorit keluarga Indonesia.', 'd2e2bce7-81df-4a9b-8285-9968f6729a65'),
('TEXT', 'Sejarah Paragraf 2', 'Pendiri memulai perjalanan dari lahan 3 hektar sebagai kebun edukasi keluarga. Seiring waktu, Ngrembel Asri berkembang menjadi taman rekreasi terpadu dengan koleksi satwa, wahana permainan, fasilitas kuliner, dan program edukasi yang menyentuh hati pengunjung.', 'd2e2bce7-81df-4a9b-8285-9968f6729a65'),
('TEXT', 'Sejarah Paragraf 3', 'Dengan dedikasi pada konservasi alam dan kebahagiaan pengunjung, Ngrembel Asri terus bertransformasi — memperluas area taman, menambah koleksi satwa, dan menghadirkan pengalaman wisata yang autentik, edukatif, dan tak terlupakan.', 'd2e2bce7-81df-4a9b-8285-9968f6729a65'),
('TEXT', 'Sejarah Year 1 Label', '2001 - Pendirian', 'd2e2bce7-81df-4a9b-8285-9968f6729a65'),
('TEXT', 'Sejarah Year 1 Value', 'H. Zaenal membuka lahan 3 hektar sebagai kebun edukasi keluarga sederhana.', 'd2e2bce7-81df-4a9b-8285-9968f6729a65'),
('TEXT', 'Sejarah Year 2 Label', '2005 - Ekspansi', 'd2e2bce7-81df-4a9b-8285-9968f6729a65'),
('TEXT', 'Sejarah Year 2 Value', 'Perluasan taman dan peluncuran mini zoo pertama dengan 12 jenis satwa lokal pilihan.', 'd2e2bce7-81df-4a9b-8285-9968f6729a65'),
('TEXT', 'Sejarah Year 3 Label', '2013 - Kebangkitan', 'd2e2bce7-81df-4a9b-8285-9968f6729a65'),
('TEXT', 'Sejarah Year 3 Value', 'Re-opening taman dengan wahana permainan modern dan area kuliner.', 'd2e2bce7-81df-4a9b-8285-9968f6729a65'),
('TEXT', 'Sejarah Year 4 Label', '2020 - Transformasi', 'd2e2bce7-81df-4a9b-8285-9968f6729a65'),
('TEXT', 'Sejarah Year 4 Value', 'Pengembangan area satwa liar dan fasilitas edukasi modern.', 'd2e2bce7-81df-4a9b-8285-9968f6729a65'),
('TEXT', 'Sejarah Year 5 Label', '2023 - Renovasi', 'd2e2bce7-81df-4a9b-8285-9968f6729a65'),
('TEXT', 'Sejarah Year 5 Value', 'Renovasi total, field trip school program, dan koleksi satwa berkembang menjadi 50+ jenis.', 'd2e2bce7-81df-4a9b-8285-9968f6729a65'),
('TEXT', 'Tiket Deskripsi', 'Tiket masuk sudah termasuk akses penuh ke semua area taman. <br/> Diskon khusus tersedia untuk rombongan, pelajar, dan lansia.', 'd2e2bce7-81df-4a9b-8285-9968f6729a65'),
('TEXT', 'Tiket Weekday', '5000', 'd2e2bce7-81df-4a9b-8285-9968f6729a65'),
('TEXT', 'Tiket Weekend', '9000', 'd2e2bce7-81df-4a9b-8285-9968f6729a65'),
('TEXT', 'Jam Operasional', '08.00 - 17.00', 'd2e2bce7-81df-4a9b-8285-9968f6729a65'),
('TEXT', 'Tagline Footer', 'Wisata Ngrembel Asri — tempat keluarga menyatu dengan alam, merasakan ketenangan, dan menciptakan kenangan abadi.', 'd2e2bce7-81df-4a9b-8285-9968f6729a65'),
('TEXT', 'Alamat', 'Jl. Raya Manyaran-Gunungpati KM 10 Semarang', 'd2e2bce7-81df-4a9b-8285-9968f6729a65'),
('TEXT', 'Telp', '0857-4346-0206', 'd2e2bce7-81df-4a9b-8285-9968f6729a65'),
('TEXT', 'Email', '', 'd2e2bce7-81df-4a9b-8285-9968f6729a65'),
('TEXT', 'Link Google Maps', '', 'd2e2bce7-81df-4a9b-8285-9968f6729a65'),
('TEXT', 'Link Facebook', 'https://www.facebook.com/ngrembelasriofficial/', 'd2e2bce7-81df-4a9b-8285-9968f6729a65'),
('TEXT', 'Link Instagram', 'https://www.instagram.com/ngrembelasriofficial/?igsh=MWwxM3U0NXh4ZXV6bg%3D%3D', 'd2e2bce7-81df-4a9b-8285-9968f6729a65'),
('TEXT', 'Link Youtube', 'https://www.youtube.com/@WisataNgrembelAsri', 'd2e2bce7-81df-4a9b-8285-9968f6729a65'),
('TEXT', 'Link Tiktok', 'https://www.tiktok.com/@ngrembelasriofficial?_t=ZS-90kqpNZCsdE&_r=1', 'd2e2bce7-81df-4a9b-8285-9968f6729a65'),
('TEXT', 'Link Whatsapp', 'https://wa.me/6285743460206', 'd2e2bce7-81df-4a9b-8285-9968f6729a65');

SELECT * FROM settings;