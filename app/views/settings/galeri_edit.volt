<style>
   #edit-section {
      padding: 120px 5% 80px;
      background: var(--forest, #07190e);
      min-height: 100vh;
      display: flex;
      justify-content: center;
      align-items: center;
   }

   .edit-card {
      width: 100%;
      max-width: 760px;
      background: rgba(16, 36, 23, 0.65);
      border: 1px solid rgba(255, 255, 255, 0.08);
      border-radius: 20px;
      backdrop-filter: blur(15px);
      -webkit-backdrop-filter: blur(15px);
      padding: 2.5rem;
      box-shadow: 0 30px 60px rgba(0, 0, 0, 0.5), 0 0 0 1px rgba(212, 177, 90, 0.1);
   }

   .edit-title {
      font-family: 'Cormorant Garamond', serif;
      font-size: 2.2rem;
      font-weight: 700;
      color: #fff;
      margin-bottom: 0.5rem;
      text-align: center;
   }

   .edit-title em {
      color: var(--gold2, #e8cc7a);
      font-style: italic;
   }

   .edit-subtitle {
      font-size: 0.9rem;
      color: rgba(255, 255, 255, 0.6);
      text-align: center;
      margin-bottom: 2rem;
   }

   .form-group {
      margin-bottom: 1.2rem;
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

   .form-control-custom {
      width: 100%;
      padding: 10px;
      background: rgba(7, 25, 14, 0.5);
      border: 1px solid rgba(255, 255, 255, 0.1);
      border-radius: 10px;
      color: #fff;
      font-family: 'Jost', sans-serif;
      font-size: 0.95rem;
      transition: all 0.3s ease;
   }

   .form-control-custom:focus {
      outline: none;
      border-color: var(--gold, #c8a84b);
      box-shadow: 0 0 15px rgba(200, 168, 75, 0.25);
      background: rgba(7, 25, 14, 0.8);
   }

   select.form-control-custom option {
      background: #0d2416;
      color: #fff;
   }

   .btn-submit,
   .btn-back {
      width: 100%;
      padding: 14px;
      border: none;
      border-radius: 30px;
      font-weight: 700;
      font-size: 0.9rem;
      text-transform: uppercase;
      letter-spacing: 1.5px;
      cursor: pointer;
      transition: all 0.3s ease;
      text-decoration: none;
      display: flex;
      justify-content: center;
      align-items: center;
   }

   .btn-submit {
      background: linear-gradient(135deg, var(--gold, #c8a84b), var(--gold2, #e8cc7a));
      color: var(--forest, #0d2416);
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

   .btn-back {
      background: linear-gradient(135deg, var(--forest, #0d2416), var(--forest-dark, #07180e));
      color: var(--gold2, #e8cc7a);
      box-shadow: 0 8px 25px rgba(13, 36, 22, 0.3);
      margin-top: 1rem;
   }

   .btn-back:hover {
      transform: translateY(-2px);
      box-shadow: 0 12px 30px rgba(13, 36, 22, 0.5);
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

   .preview-card {
      border: 1px solid rgba(255, 255, 255, 0.08);
      background: rgba(7, 25, 14, 0.35);
      border-radius: 14px;
      padding: 1rem;
      margin-bottom: 1.4rem;
   }
</style>

<section id="edit-section">
   <div class="edit-card">
      <h1 class="edit-title">Edit <em>Media Galeri</em></h1>
      <p class="edit-subtitle">Perbarui metadata atau ganti file media untuk item galeri yang sudah ada.</p>

      {% if updateSuccess %}
      <div style="padding:10px 12px; border:1px solid #2a9d52; background:#11361f; color:#c9f7d8; border-radius:8px; margin-bottom:14px;">
         {{ updateSuccess }}
      </div>
      {% endif %}

      {% if updateError %}
      <div style="padding:10px 12px; border:1px solid #b84141; background:#3a1616; color:#ffd1d1; border-radius:8px; margin-bottom:14px;">
         {{ updateError }}
      </div>
      {% endif %}

      <div class="preview-card">
         <div style="display:flex; gap:16px; flex-wrap:wrap; align-items:center;">
            <div style="flex:0 0 auto;">
               {% if galleryItem['type'] == 'photo' %}
                  {% if galleryItem['thumb_md_path'] %}
                     <img src="{{ url(galleryItem['thumb_md_path']) }}" alt="{{ galleryItem['title'] }}"
                        style="width:160px; max-width:100%; border-radius:12px; border:1px solid rgba(255,255,255,0.12); object-fit:cover;">
                  {% elseif galleryItem['original_path'] %}
                     <img src="{{ url(galleryItem['original_path']) }}" alt="{{ galleryItem['title'] }}"
                        style="width:160px; max-width:100%; border-radius:12px; border:1px solid rgba(255,255,255,0.12); object-fit:cover;">
                  {% endif %}
               {% else %}
                  {% if galleryItem['poster_path'] %}
                     <img src="{{ url(galleryItem['poster_path']) }}" alt="{{ galleryItem['title'] }}"
                        style="width:160px; max-width:100%; border-radius:12px; border:1px solid rgba(255,255,255,0.12); object-fit:cover;">
                  {% elseif galleryItem['original_path'] %}
                     <video controls style="width:160px; max-width:100%; border-radius:12px; border:1px solid rgba(255,255,255,0.12);">
                        <source src="{{ url(galleryItem['original_path']) }}" type="video/mp4">
                     </video>
                  {% endif %}
               {% endif %}
            </div>
            <div style="min-width:220px; flex:1;">
               <div style="color:#e8cc7a; font-weight:700; text-transform:uppercase; letter-spacing:1.2px; font-size:0.8rem; margin-bottom:6px;">Media Saat Ini</div>
               <div style="font-size:1.25rem; color:#fff; font-weight:700; margin-bottom:8px;">{{ galleryItem['title'] }}</div>
               <div style="color:rgba(255,255,255,0.7); line-height:1.55; margin-bottom:8px;">{{ galleryItem['description'] ? galleryItem['description'] : 'Tidak ada deskripsi.' }}</div>
               <div style="display:flex; gap:8px; flex-wrap:wrap;">
                  <span style="padding:4px 10px; border-radius:999px; background:rgba(212,177,90,0.15); color:#e8cc7a; border:1px solid rgba(212,177,90,0.25); font-size:0.8rem;">{{ galleryItem['category'] }}</span>
                  <span style="padding:4px 10px; border-radius:999px; background:rgba(120,196,255,0.12); color:#8fd3ff; border:1px solid rgba(120,196,255,0.2); font-size:0.8rem;">{{ galleryItem['type'] }}</span>
                  <span style="padding:4px 10px; border-radius:999px; background:rgba(255,255,255,0.08); color:#fff; border:1px solid rgba(255,255,255,0.1); font-size:0.8rem;">Urutan: {{ galleryItem['sort_order'] }}</span>
               </div>
            </div>
         </div>
      </div>

      <form id="editForm" enctype="multipart/form-data">
         <input type="hidden" name="id" value="{{ galleryItem['id'] }}" />

         <div class="form-group">
            <label for="title">Judul Media</label>
            <input type="text" id="title" name="title" class="form-control-custom" value="{{ galleryItem['title'] }}" placeholder="Masukkan judul..." required />
         </div>

         <div class="form-group">
            <label for="description">Deskripsi</label>
            <textarea id="description" name="description" class="form-control-custom" rows="3" placeholder="Masukkan deskripsi singkat...">{{ galleryItem['description'] }}</textarea>
         </div>

         <div style="display:flex; gap:1rem; flex-wrap:wrap;">
            <div class="form-group" style="flex:1; min-width:150px;">
               <label for="category">Kategori</label>
               <select id="category" name="category" class="form-control-custom" required>
                  <option value="EVENT" {{ galleryItem['category'] == 'EVENT' ? 'selected' : '' }}>EVENT</option>
                  <option value="WAHANA" {{ galleryItem['category'] == 'WAHANA' ? 'selected' : '' }}>WAHANA</option>
                  <option value="AREA" {{ galleryItem['category'] == 'AREA' ? 'selected' : '' }}>AREA</option>
               </select>
            </div>

            <div class="form-group" style="flex:1; min-width:150px;">
               <label for="type">Tipe Media</label>
               <select id="type" name="type" class="form-control-custom" required>
                  <option value="photo" {{ galleryItem['type'] == 'photo' ? 'selected' : '' }}>Foto</option>
                  <option value="video" {{ galleryItem['type'] == 'video' ? 'selected' : '' }}>Video</option>
               </select>
            </div>
         </div>

         <div style="display:flex; gap:1rem; flex-wrap:wrap;">
            <div class="form-group" style="flex:1; min-width:150px;">
               <label for="is_active">Status Tampil</label>
               <select id="is_active" name="is_active" class="form-control-custom" required>
                  <option value="1" {{ galleryItem['is_active'] == 1 ? 'selected' : '' }}>Aktif</option>
                  <option value="0" {{ galleryItem['is_active'] == 0 ? 'selected' : '' }}>Sembunyikan</option>
               </select>
            </div>

            <div class="form-group" style="flex:1; min-width:150px;">
               <label for="sort_order">Urutan Tampil</label>
               <input type="number" id="sort_order" name="sort_order" class="form-control-custom" value="{{ galleryItem['sort_order'] }}" min="0" required />
            </div>
         </div>

         <div class="form-group">
            <label for="media_file">Ganti File Media</label>
            <input type="file" id="media_file" name="media_file" class="form-control-custom" style="padding:8px;" />
            <small id="fileHelpText" style="display:block; margin-top:5px; color:rgba(255,255,255,0.45); font-size:0.75rem;">
               Kosongkan jika tidak ingin mengganti file. Foto: JPG, PNG, WEBP (Maks 10MB) | Video: MP4, WEBM, MOV (Maks 100MB)
            </small>
         </div>

         <button type="submit" id="btnSubmit" class="btn-submit">Simpan Perubahan</button>
         <a href="{{ url('settings/galeri') }}" id="btnBack" class="btn-back">Kembali</a>

         <div id="progressContainer" class="progress-bar-container">
            <div id="progressBar" class="progress-bar-fill"></div>
         </div>
         <p id="progressStatus" class="progress-status" style="display:none;"></p>
      </form>
   </div>
</section>

<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script>
   document.addEventListener('DOMContentLoaded', () => {
      const form = document.getElementById('editForm');
      const fileInput = document.getElementById('media_file');
      const typeSelect = document.getElementById('type');
      const fileHelpText = document.getElementById('fileHelpText');
      const btnSubmit = document.getElementById('btnSubmit');
      const progressContainer = document.getElementById('progressContainer');
      const progressBar = document.getElementById('progressBar');
      const progressStatus = document.getElementById('progressStatus');

      let capturedPosterDataUrl = null;
      let capturedVideoDuration = null;
      let capturedVideoWidth = null;
      let capturedVideoHeight = null;

      function updateFileHelp() {
         if (typeSelect.value === 'photo') {
            fileInput.accept = 'image/jpeg,image/png,image/webp';
            fileHelpText.textContent = 'Kosongkan jika tidak ingin mengganti file. Foto: JPG, PNG, WEBP (Maks 10MB)';
         } else {
            fileInput.accept = 'video/mp4,video/webm,video/quicktime,video/x-m4v';
            fileHelpText.textContent = 'Kosongkan jika tidak ingin mengganti file. Video: MP4, WEBM, MOV (Maks 100MB)';
         }
      }

      typeSelect.addEventListener('change', () => {
         capturedPosterDataUrl = null;
         capturedVideoDuration = null;
         capturedVideoWidth = null;
         capturedVideoHeight = null;
         fileInput.value = '';
         updateFileHelp();
      });

      updateFileHelp();

      function captureVideoPoster(file) {
         return new Promise((resolve, reject) => {
            const videoEl = document.createElement('video');
            videoEl.preload = 'auto';
            videoEl.muted = true;
            videoEl.playsInline = true;

            const objectUrl = URL.createObjectURL(file);
            videoEl.src = objectUrl;

            const timeout = setTimeout(() => {
               URL.revokeObjectURL(objectUrl);
               reject(new Error('Video poster capture timed out'));
            }, 15000);

            videoEl.addEventListener('loadedmetadata', () => {
               const seekTime = Math.min(1, videoEl.duration * 0.1);
               videoEl.currentTime = seekTime;
            });

            videoEl.addEventListener('seeked', () => {
               clearTimeout(timeout);
               try {
                  const canvas = document.createElement('canvas');
                  canvas.width = videoEl.videoWidth;
                  canvas.height = videoEl.videoHeight;
                  const ctx = canvas.getContext('2d');
                  ctx.drawImage(videoEl, 0, 0, canvas.width, canvas.height);

                  const posterDataUrl = canvas.toDataURL('image/jpeg', 0.85);
                  resolve({
                     posterDataUrl,
                     duration: videoEl.duration,
                     width: videoEl.videoWidth,
                     height: videoEl.videoHeight
                  });
               } catch (e) {
                  reject(e);
               } finally {
                  URL.revokeObjectURL(objectUrl);
               }
            });

            videoEl.addEventListener('error', () => {
               clearTimeout(timeout);
               URL.revokeObjectURL(objectUrl);
               reject(new Error('Failed to load video for poster capture'));
            });
         });
      }

      fileInput.addEventListener('change', async () => {
         capturedPosterDataUrl = null;
         capturedVideoDuration = null;
         capturedVideoWidth = null;
         capturedVideoHeight = null;

         const file = fileInput.files[0];
         if (!file || typeSelect.value !== 'video') return;

         fileHelpText.innerHTML = '<span style="color: var(--gold, #c8a84b);">Memproses preview video...</span>';
         btnSubmit.disabled = true;

         try {
            const result = await captureVideoPoster(file);
            capturedPosterDataUrl = result.posterDataUrl;
            capturedVideoDuration = result.duration;
            capturedVideoWidth = result.width;
            capturedVideoHeight = result.height;

            const durationFormatted = new Date(result.duration * 1000).toISOString().substr(11, 8);
            fileHelpText.innerHTML = '<span style="color: #6bcf7f;">Poster berhasil diambil</span> - ' + result.width + 'x' + result.height + ', durasi: ' + durationFormatted;
         } catch (err) {
            console.warn('Poster capture failed:', err);
            fileHelpText.innerHTML = '<span style="color: #e8a84b;">Gagal membuat preview otomatis, video tetap bisa diupload</span>';
         } finally {
            btnSubmit.disabled = false;
         }
      });

      form.addEventListener('submit', (e) => {
         e.preventDefault();

         const file = fileInput.files[0];
         const type = typeSelect.value;
         if (file) {
            const maxSize = type === 'photo' ? 10 * 1024 * 1024 : 100 * 1024 * 1024;
            if (file.size > maxSize) {
               Swal.fire({
                  icon: 'error',
                  title: 'Ukuran file terlalu besar',
                  text: type === 'photo' ? 'Ukuran foto maksimal adalah 10MB.' : 'Ukuran video maksimal adalah 100MB.',
                  confirmButtonColor: '#d4b15a'
               });
               return;
            }
         }

         btnSubmit.disabled = true;
         btnSubmit.textContent = 'Menyimpan...';
         progressContainer.style.display = 'block';
         progressStatus.style.display = 'block';
         progressStatus.textContent = 'Mengirim data ke server...';
         progressBar.style.width = '0%';

         const xhr = new XMLHttpRequest();
         xhr.open('POST', '{{ url("settings/update_galeri") }}', true);
         xhr.setRequestHeader('X-Requested-With', 'XMLHttpRequest');

         xhr.upload.addEventListener('progress', (event) => {
            if (event.lengthComputable) {
               const percent = Math.round((event.loaded / event.total) * 100);
               progressBar.style.width = percent + '%';
               progressStatus.textContent = 'Mengirim: ' + percent + '%...';
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
                  text: res.message || 'Media berhasil diperbarui.',
                  confirmButtonColor: '#d4b15a'
               }).then(() => {
                  window.location.href = '{{ url("settings/galeri") }}';
               });
            } else {
               btnSubmit.disabled = false;
               btnSubmit.textContent = 'Simpan Perubahan';
               progressContainer.style.display = 'none';
               progressStatus.style.display = 'none';
               Swal.fire({
                  icon: 'error',
                  title: 'Update Gagal',
                  text: res.message || 'Terjadi kesalahan saat memperbarui media.',
                  confirmButtonColor: '#d4b15a'
               });
            }
         };

         xhr.onerror = () => {
            btnSubmit.disabled = false;
            btnSubmit.textContent = 'Simpan Perubahan';
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
         if (type === 'video' && file) {
            if (capturedPosterDataUrl) {
               formData.append('poster_data', capturedPosterDataUrl);
            }
            if (capturedVideoDuration !== null) {
               formData.append('video_duration', capturedVideoDuration);
            }
            if (capturedVideoWidth !== null) {
               formData.append('video_width', capturedVideoWidth);
            }
            if (capturedVideoHeight !== null) {
               formData.append('video_height', capturedVideoHeight);
            }
         }

         xhr.send(formData);
      });
   });
</script>
