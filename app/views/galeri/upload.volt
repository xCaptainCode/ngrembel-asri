<style>
    #upload-section {
        padding: 120px 5% 80px;
        background: var(--forest, #07190e);
        min-height: 100vh;
        display: flex;
        justify-content: center;
        align-items: center;
    }

    .upload-card {
        width: 100%;
        max-width: 650px;
        background: rgba(16, 36, 23, 0.65);
        border: 1px solid rgba(255, 255, 255, 0.08);
        border-radius: 20px;
        backdrop-filter: blur(15px);
        -webkit-backdrop-filter: blur(15px);
        padding: 2.5rem;
        box-shadow: 0 30px 60px rgba(0, 0, 0, 0.5), 0 0 0 1px rgba(212, 177, 90, 0.1);
    }

    .upload-title {
        font-family: 'Cormorant Garamond', serif;
        font-size: 2.2rem;
        font-weight: 700;
        color: #fff;
        margin-bottom: 0.5rem;
        text-align: center;
    }

    .upload-title em {
        color: var(--gold2, #e8cc7a);
        font-style: italic;
    }

    .upload-subtitle {
        font-size: 0.9rem;
        color: rgba(255, 255, 255, 0.6);
        text-align: center;
        margin-bottom: 2rem;
    }

    .form-group {
        margin-bottom: 1.5rem;
    }

    .form-group label {
        display: block;
        font-size: 0.85rem;
        font-weight: 600;
        color: var(--gold2, #e8cc7a);
        text-transform: uppercase;
        letter-spacing: 1.5px;
        margin-bottom: 0.5rem;
    }

    .form-control {
        width: 100%;
        padding: 12px 16px;
        background: rgba(7, 25, 14, 0.5);
        border: 1px solid rgba(255, 255, 255, 0.1);
        border-radius: 10px;
        color: #fff;
        font-family: 'Jost', sans-serif;
        font-size: 0.95rem;
        transition: all 0.3s ease;
    }

    .form-control:focus {
        outline: none;
        border-color: var(--gold, #c8a84b);
        box-shadow: 0 0 15px rgba(200, 168, 75, 0.25);
        background: rgba(7, 25, 14, 0.8);
    }

    select.form-control option {
        background: #0d2416;
        color: #fff;
    }

    .btn-submit {
        width: 100%;
        padding: 14px;
        border: none;
        border-radius: 30px;
        background: linear-gradient(135deg, var(--gold, #c8a84b), var(--gold2, #e8cc7a));
        color: var(--forest, #0d2416);
        font-weight: 700;
        font-size: 0.9rem;
        text-transform: uppercase;
        letter-spacing: 1.5px;
        cursor: pointer;
        transition: all 0.3s ease;
        box-shadow: 0 8px 25px rgba(200, 168, 75, 0.3);
        margin-top: 1rem;
    }

    .btn-submit:hover {
        transform: translateY(-2px);
        box-shadow: 0 12px 30px rgba(200, 168, 75, 0.5);
    }

    .btn-submit:disabled {
        opacity: 0.6;
        cursor: not-allowed;
        transform: none !important;
        box-shadow: none !important;
    }

    .progress-bar-container {
        display: none;
        margin-top: 1.5rem;
        background: rgba(255, 255, 255, 0.05);
        border-radius: 8px;
        overflow: hidden;
        height: 8px;
        border: 1px solid rgba(255, 255, 255, 0.05);
    }

    .progress-bar-fill {
        height: 100%;
        width: 0%;
        background: linear-gradient(90deg, var(--gold, #c8a84b), var(--gold2, #e8cc7a));
        transition: width 0.1s ease;
    }

    .progress-status {
        font-size: 0.8rem;
        color: rgba(255, 255, 255, 0.7);
        text-align: center;
        margin-top: 0.5rem;
    }
</style>

<section id="upload-section">
    <div class="upload-card">
        <h1 class="upload-title">Upload <em>Media Baru</em></h1>
        <p class="upload-subtitle">Tambahkan foto atau video berkualitas tinggi ke dalam Galeri Ngrembel Asri.</p>

        <form id="uploadForm" enctype="multipart/form-data">
            <div class="form-group">
                <label for="title">Judul Media</label>
                <input type="text" id="title" name="title" class="form-control" placeholder="Masukkan judul..." required />
            </div>

            <div class="form-group">
                <label for="description">Deskripsi</label>
                <textarea id="description" name="description" class="form-control" rows="3" placeholder="Masukkan deskripsi singkat..."></textarea>
            </div>

            <div style="display: flex; gap: 1rem; flex-wrap: wrap;">
                <div class="form-group" style="flex: 1; min-width: 150px;">
                    <label for="category">Kategori</label>
                    <select id="category" name="category" class="form-control" required>
                        <option value="EVENT">EVENT</option>
                        <option value="WAHANA">WAHANA</option>
                        <option value="AREA">AREA</option>
                    </select>
                </div>

                <div class="form-group" style="flex: 1; min-width: 150px;">
                    <label for="type">Tipe Media</label>
                    <select id="type" name="type" class="form-control" required>
                        <option value="photo">Foto</option>
                        <option value="video">Video</option>
                    </select>
                </div>
            </div>

            <div style="display: flex; gap: 1rem; flex-wrap: wrap;">
                <div class="form-group" style="flex: 1; min-width: 150px;">
                    <label for="is_active">Status Tampil</label>
                    <select id="is_active" name="is_active" class="form-control" required>
                        <option value="1">Aktif</option>
                        <option value="0">Sembunyikan</option>
                    </select>
                </div>

                <div class="form-group" style="flex: 1; min-width: 150px;">
                    <label for="sort_order">Urutan Tampil</label>
                    <input type="number" id="sort_order" name="sort_order" class="form-control" value="0" min="0" required />
                </div>
            </div>

            <div class="form-group">
                <label for="media_file">Pilih File Media</label>
                <input type="file" id="media_file" name="media_file" class="form-control" style="padding: 8px;" required />
                <small id="fileHelpText" style="display: block; margin-top: 5px; color: rgba(255,255,255,0.45); font-size: 0.75rem;">
                    Foto: JPG, PNG, WEBP (Maks 10MB) | Video: MP4, WEBM (Maks 200MB)
                </small>
            </div>

            <button type="submit" id="btnSubmit" class="btn-submit">Mulai Upload</button>
            
            <div id="progressContainer" class="progress-bar-container">
                <div id="progressBar" class="progress-bar-fill"></div>
            </div>
            <p id="progressStatus" class="progress-status" style="display: none;"></p>
        </form>
    </div>
</section>

<!-- SweetAlert2 for beautiful modern notifications -->
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script>
    document.addEventListener('DOMContentLoaded', () => {
        const form = document.getElementById('uploadForm');
        const fileInput = document.getElementById('media_file');
        const typeSelect = document.getElementById('type');
        const fileHelpText = document.getElementById('fileHelpText');
        const btnSubmit = document.getElementById('btnSubmit');
        const progressContainer = document.getElementById('progressContainer');
        const progressBar = document.getElementById('progressBar');
        const progressStatus = document.getElementById('progressStatus');

        // Dynamic file input restrictions based on selected type
        typeSelect.addEventListener('change', () => {
            if (typeSelect.value === 'photo') {
                fileInput.accept = 'image/jpeg,image/png,image/webp';
                fileHelpText.textContent = 'Foto: JPG, PNG, WEBP (Maks 10MB)';
            } else {
                fileInput.accept = 'video/mp4,video/webm,video/quicktime,video/x-m4v';
                fileHelpText.textContent = 'Video: MP4, WEBM (Maks 200MB)';
            }
        });

        // Set default accept attribute
        fileInput.accept = 'image/jpeg,image/png,image/webp';

        form.addEventListener('submit', (e) => {
            e.preventDefault();

            const file = fileInput.files[0];
            if (!file) return;

            // Validate size
            const type = typeSelect.value;
            const maxSize = type === 'photo' ? 10 * 1024 * 1024 : 200 * 1024 * 1024;
            if (file.size > maxSize) {
                Swal.fire({
                    icon: 'error',
                    title: 'Ukuran file terlalu besar',
                    text: type === 'photo' ? 'Ukuran foto maksimal adalah 10MB.' : 'Ukuran video maksimal adalah 200MB.',
                    confirmButtonColor: '#d4b15a'
                });
                return;
            }

            // Lock UI
            btnSubmit.disabled = true;
            btnSubmit.textContent = 'Sedang Mengunggah...';
            progressContainer.style.display = 'block';
            progressStatus.style.display = 'block';
            progressStatus.textContent = 'Memulai proses upload...';
            progressBar.style.width = '0%';

            // Use XHR to track progress
            const xhr = new XMLHttpRequest();
            xhr.open('POST', '{{ url("galeri/upload") }}', true);

            xhr.upload.addEventListener('progress', (event) => {
                if (event.lengthComputable) {
                    const percent = Math.round((event.loaded / event.total) * 100);
                    progressBar.style.width = percent + '%';
                    progressStatus.textContent = `Mengunggah: ${percent}%...`;
                }
            });

            xhr.onload = () => {
                let res;
                try {
                    res = JSON.parse(xhr.responseText);
                } catch (err) {
                    res = { status: 'error', message: 'Respon server tidak valid' };
                }

                if (xhr.status === 200 && res.status === 'success') {
                    progressStatus.textContent = 'Selesai!';
                    Swal.fire({
                        icon: 'success',
                        title: 'Berhasil!',
                        text: 'Media berhasil diupload dan diproses.',
                        confirmButtonColor: '#d4b15a'
                    }).then(() => {
                        window.location.href = '{{ url("galeri") }}';
                    });
                } else {
                    btnSubmit.disabled = false;
                    btnSubmit.textContent = 'Mulai Upload';
                    progressContainer.style.display = 'none';
                    progressStatus.style.display = 'none';
                    Swal.fire({
                        icon: 'error',
                        title: 'Upload Gagal',
                        text: res.message || 'Terjadi kesalahan saat mengupload media.',
                        confirmButtonColor: '#d4b15a'
                    });
                }
            };

            xhr.onerror = () => {
                btnSubmit.disabled = false;
                btnSubmit.textContent = 'Mulai Upload';
                progressContainer.style.display = 'none';
                progressStatus.style.display = 'none';
                Swal.fire({
                    icon: 'error',
                    title: 'Kesalahan Jaringan',
                    text: 'Koneksi jaringan terputus atau server tidak merespon.',
                    confirmButtonColor: '#d4b15a'
                });
            };

            const formData = new FormData(form);
            xhr.send(formData);
        });
    });
</script>
