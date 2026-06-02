# Dokumentasi Project Ngrembel Asri

## Ringkasan Aplikasi

Project ini adalah aplikasi web berbasis **Phalcon PHP (MVC)** untuk operasional dan informasi wisata/edukasi Ngrembel Asri. Aplikasi menyediakan halaman publik (informasi wahana, fasilitas, harga, galeri, kritik saran) serta panel admin untuk mengelola konten dan data member.

## Teknologi yang Digunakan

- Backend: PHP + Phalcon `3.4.5`
- Frontend templating: Volt (`.volt`)
- Database utama: PostgreSQL
- Session: File-based session (Phalcon session adapter)
- Env management: `vlucas/phpdotenv`
- Mail: `phpmailer/phpmailer` (dipakai via helper)
- Image processing: `intervention/image`

Dependensi didefinisikan pada `composer.json`.

## Arsitektur Singkat

Entry point aplikasi ada di:

- `public/index.php`

Alur bootstrapping:

1. Start session.
2. Load service container (`app/config/services.php`).
3. Load `.env` menggunakan Dotenv.
4. Register autoloader (`app/config/loader.php`).
5. Handle request melalui `Phalcon\Mvc\Application`.

Routing aplikasi didefinisikan di:

- `app/config/router.php`

## Struktur Direktori Penting

- `app/controllers`: seluruh controller fitur
- `app/models`: model data
- `app/views`: template Volt untuk halaman publik dan admin
- `app/config`: konfigurasi app, services, router, loader
- `app/migrations`: skrip SQL pembuatan tabel/seed data
- `app/helpers`: helper utilitas (termasuk helper pengiriman email)
- `public`: web root, asset statis, dan storage media
- `public/storage`:
  - `originals`
  - `thumbnails/sm`
  - `thumbnails/md`
  - `thumbnails/posters`

## Modul/Fitur Utama

### 1) Halaman Publik

- Home: `/`
- Fasilitas: `/fasilitas`
- Price list: `/price-list`
- Wahana:
  - `/wahana-permainan`
  - `/wahana-paintball`
  - `/wahana-field-trip`
  - `/wahana-fun-game`
- Mini zoo: `/mini-zoo`
- Kritik saran:
  - `/kritik-saran`
  - `/kritik-saran/load-more`

### 2) Autentikasi & Akun

Endpoint utama:

- Login: `/login`, submit ke `/login/proses`
- Logout: `/login/logout`
- Registrasi: `/registrasi`, submit ke `/registrasi/proses_registrasi`
- Lupa password:
  - GET `/lupa-password`
  - POST `/lupa-password` (kirim link reset via email)
  - GET `/reset-password?token=...`
  - POST `/reset-password`

Catatan:

- Password di-hash di PostgreSQL (`crypt` + `gen_salt('bf')`).
- Reset password menggunakan tabel `password_resets` dengan masa berlaku token 1 jam.

### 3) Galeri Media

Endpoint:

- Publik:
  - `/galeri`
  - `/galeri/load-more`
  - `/galeri/detail/{id}`
  - `/galeri/download/{id}`
- Upload (admin):
  - GET `/galeri/upload`
  - POST `/galeri/upload`

Fitur galeri:

- Dukungan tipe `photo` dan `video`
- Validasi MIME type dan batas ukuran file
- Pembuatan thumbnail (small/medium) untuk foto
- Penyimpanan metadata ke tabel `media_gallery`
- Counter `view_count` dan `download_count`

### 4) Panel Admin (`SettingsController`)

Seluruh action settings dilindungi role admin (`beforeExecuteRoute`).

Modul admin meliputi:

- Manajemen member (`settings/member`)
- Persetujuan/penolakan registrasi (`settings/registrasi`)
- Pengaturan dashboard (`settings/dashboard`)
- Pengelolaan:
  - price list
  - permainan
  - paintball
  - field trip
  - fun game
  - mini zoo
  - fasilitas
  - galeri
  - kritik saran

## Konfigurasi Environment

Variabel `.env` minimal yang dibutuhkan (berdasarkan `app/config/config.php`):

- `DB_HOST`
- `DB_PORT`
- `DB_USER`
- `DB_PASS`
- `DB_NAME`
- `SMTP_HOST` (opsional, default `localhost`)
- `SMTP_PORT` (opsional, default `1025`)
- `SMTP_USER` (opsional)
- `SMTP_PASS` (opsional)
- `SMTP_ENCRYPTION` (opsional)
- `SMTP_FROM_EMAIL` (opsional)
- `SMTP_FROM_NAME` (opsional)

## Setup Lokal (Ringkas)

1. Pastikan PHP, Composer, dan PostgreSQL tersedia.
2. Install dependency:
  - `composer install`
3. Buat file `.env` di root project, isi variabel DB/SMTP.
4. Eksekusi SQL migration pada folder `app/migrations` sesuai urutan kebutuhan tabel.
5. Pastikan folder berikut dapat ditulis oleh web server:
  - `cache`
  - `public/storage/originals`
  - `public/storage/thumbnails/sm`
  - `public/storage/thumbnails/md`
  - `public/storage/thumbnails/posters`
6. Jalankan aplikasi lewat web server dengan document root ke folder `public`.

## Daftar Skrip SQL (Referensi)

Folder `app/migrations` berisi skrip seperti:

- `create-table-members.sql`
- `create-table-registrasi.sql`
- `create-table-dashboard.sql`
- `create-table-price-list.sql`
- `create-table-media-gallery.sql`
- `create-table-kritik-saran.sql`
- `create-table-settings.sql`
- `create-table-password-resets.sql`
- `create-table-wahana.sql`
- `create-table-mini-zoo.sql`
- `seed-mini-zoo.sql`
- `seed-fasilitas.sql`
- `seed-member.sql`

Gunakan sebagai referensi struktur tabel dan data awal.

## Catatan Operasional & Keamanan

- Akses panel admin mengandalkan session `role=admin`.
- Upload media sudah memiliki validasi tipe/ukuran, namun tetap disarankan menambahkan antivirus scanning jika deployment publik.
- `Volt` diset `compileAlways = true`, cocok untuk development, tetapi untuk production sebaiknya dipertimbangkan strategi cache compile yang lebih efisien.

## Saran Pengembangan Dokumentasi Lanjutan

- Tambahkan ERD database.
- Tambahkan sequence flow login/registrasi/reset password.
- Tambahkan panduan deployment production (Nginx/Apache, SSL, backup DB).
- Tambahkan API contract (jika endpoint JSON akan diperluas).

