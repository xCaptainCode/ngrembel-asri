<style>
   .gallery-row-editable {
      cursor: pointer;
      transition: background 0.2s ease-in-out;
   }
   .gallery-row-editable:hover {
      background: rgba(255, 255, 255, 0.05) !important;
   }
   .table th, .table td {
      vertical-align: middle;
   }
   .badge-active {
      background: #11361f;
      color: #c9f7d8;
      border: 1px solid #2a9d52;
      padding: 4px 8px;
      border-radius: 6px;
      font-size: 0.85rem;
      font-weight: 600;
   }
   .badge-inactive {
      background: #3a1616;
      color: #ffd1d1;
      border: 1px solid #b84141;
      padding: 4px 8px;
      border-radius: 6px;
      font-size: 0.85rem;
      font-weight: 600;
   }
</style>

<section style="padding: 120px 5% 60px; min-height: 70vh;">
   <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; flex-wrap: wrap; gap: 12px;">
      <div>
         <h1 style="margin: 0 0 4px 0;">Settings - Mini Zoo</h1>
         <p style="margin: 0;">Klik pada baris tabel untuk meng-edit data Mini Zoo.</p>
      </div>
      <div>
         <button type="button" id="addBtn" style="padding: 10px 20px; border-radius: 8px; border: none; background: #d4b15a; color: #102417; font-weight: 700; cursor: pointer; display: flex; align-items: center; gap: 6px; transition: all 0.2s; box-shadow: 0 4px 10px rgba(212, 177, 90, 0.2);">
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" style="vertical-align: middle;">
               <line x1="12" y1="5" x2="12" y2="19"></line>
               <line x1="5" y1="12" x2="19" y2="12"></line>
            </svg>
            Tambah Data Mini Zoo
         </button>
      </div>
   </div>

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

   {% if miniZooList is empty %}
   <p>Data Mini Zoo belum tersedia.</p>
   {% else %}
   <div class="table-responsive" style="overflow-x: auto; background: rgba(16, 36, 23, 0.6); border: 1px solid rgba(255,255,255,0.1); border-radius: 12px; padding: 10px;">
      <table class="table table-sm text-white" style="width:100%; border-collapse: collapse;">
         <thead>
            <tr style="background: rgba(0,0,0,0.2);">
               <th style="text-align:left; padding:12px 10px; border-bottom:2px solid rgba(255,255,255,.15);">Nama Satwa</th>
               <th style="text-align:left; padding:12px 10px; border-bottom:2px solid rgba(255,255,255,.15); width: 50%;">Deskripsi</th>
               <th style="text-align:center; padding:12px 10px; border-bottom:2px solid rgba(255,255,255,.15);">Preview</th>
               <th style="text-align:center; padding:12px 10px; border-bottom:2px solid rgba(255,255,255,.15);">Status</th>
               <th style="text-align:left; padding:12px 10px; border-bottom:2px solid rgba(255,255,255,.15);">Updated At</th>
            </tr>
         </thead>
         <tbody id="galleryTableBody">
            {% for item in miniZooList %}
            <tr class="gallery-row-editable"
                data-id="{{ item['id'] }}"
                data-nama="{{ item['nama'] }}"
                data-deskripsi="{{ item['deskripsi'] }}"
                data-img-url="{{ item['img_url'] }}"
                data-is-active="{{ item['is_active'] == 't' or item['is_active'] === true or item['is_active'] === '1' or item['is_active'] === 1 ? '1' : '0' }}"
                data-img-url-full="{{ item['img_url'] ? url(item['img_url']) : '' }}">
               <td style="padding:12px 10px; border-bottom:1px solid rgba(255,255,255,.08); font-weight: 600; color: #d4b15a;">{{ item['nama'] }}</td>
               <td style="padding:12px 10px; border-bottom:1px solid rgba(255,255,255,.08); font-size: 0.9rem; opacity: 0.9; line-height: 1.4;">{{ item['deskripsi'] ? item['deskripsi'] : '-' }}</td>
               <td style="padding:12px 10px; border-bottom:1px solid rgba(255,255,255,.08); text-align: center;">
                  {% if item['img_url'] %}
                     <img src="{{ url(item['img_url']) }}" alt="{{ item['nama'] }}" style="max-height:50px; max-width:80px; border-radius:6px; object-fit:cover; border:1px solid rgba(255,255,255,0.15);">
                  {% else %}
                     <em style="opacity:.5; font-size:0.9rem;">(tidak ada)</em>
                  {% endif %}
               </td>
               <td style="padding:12px 10px; border-bottom:1px solid rgba(255,255,255,.08); text-align: center;">
                  {% if item['is_active'] == 't' or item['is_active'] === true or item['is_active'] === '1' or item['is_active'] === 1 %}
                     <span class="badge-active">Aktif</span>
                  {% else %}
                     <span class="badge-inactive">Tidak Aktif</span>
                  {% endif %}
               </td>
               <td style="padding:12px 10px; border-bottom:1px solid rgba(255,255,255,.08); font-size: 0.85rem; opacity: 0.85;">
                  {{ item['updated_at'] ? item['updated_at'] : item['created_at'] }}
                  <div style="font-size: 0.75rem; opacity: 0.7; margin-top: 2px;">
                     Oleh: {{ item['updated_by_nama'] ? item['updated_by_nama'] : (item['created_by_nama'] ? item['created_by_nama'] : '-') }}
                  </div>
               </td>
            </tr>
            {% endfor %}
         </tbody>
      </table>
   </div>
   {% endif %}
</section>

<div id="editModal" style="display:none; position:fixed; inset:0; background:rgba(0,0,0,.65); z-index:9999; align-items:center; justify-content:center; backdrop-filter: blur(4px);">
   <div style="width:min(640px, 92vw); background:#102417; color:#fff; border:1px solid rgba(255,255,255,.2); border-radius:16px; padding:24px; box-shadow: 0 10px 25px rgba(0,0,0,0.5);">
      <h3 style="margin:0 0 18px; font-size: 1.5rem; color:#d4b15a; border-bottom: 1px solid rgba(255,255,255,0.1); padding-bottom: 10px;">Edit Mini Zoo</h3>
      <form method="post" action="{{ url('settings/update_minizoo') }}">
         <input type="hidden" name="id" id="editId">
         <input type="hidden" name="img_url" id="editImgUrl" value="">

         <div style="margin-bottom:14px;">
            <label for="editNama" style="display:block; margin-bottom:6px; font-weight: 600;">Nama Satwa</label>
            <input id="editNama" name="nama" type="text" required style="width:100%; padding:10px; border-radius:8px; border:1px solid rgba(255,255,255,.2); background:#203729; color:#fff;">
         </div>

         <div style="margin-bottom:14px;">
            <label for="editDeskripsi" style="display:block; margin-bottom:6px; font-weight: 600;">Deskripsi</label>
            <textarea id="editDeskripsi" name="deskripsi" rows="3" style="width:100%; padding:10px; border-radius:8px; border:1px solid rgba(255,255,255,.2); background:#203729; color:#fff; resize: vertical; font-family: inherit; line-height: 1.4;"></textarea>
         </div>

         <div id="editImageUploadContainer" style="margin-bottom:14px;">
            <label style="display:block; margin-bottom:6px; font-weight: 600;">Foto Saat Ini</label>
            <div style="margin-bottom: 8px;">
               <img id="editImagePreview" src="" alt="Preview" style="max-height:100px; border-radius:8px; display:none; border:1px solid rgba(255,255,255,0.2);">
               <span id="editNoImageText" style="font-style: italic; opacity: 0.6; display: none;">Tidak ada foto</span>
            </div>
            <label for="editImage" id="editUploadLabel" style="display:block; margin-bottom:6px; font-weight: 600;">Upload Foto Baru (Maks 5MB)</label>
            <input type="file" id="editImage" accept="image/*" style="width:100%; padding:8px; border-radius:8px; border:1px solid rgba(255,255,255,.2); background:#203729; color:#fff;">
            <div id="editProgressContainer" style="display:none; margin-top:10px;">
                <div style="background:rgba(255,255,255,0.1); border-radius:6px; height:10px; overflow:hidden;">
                    <div id="editProgressBar" style="height:100%; width:0%; background:#d4b15a; transition:width 0.3s ease; border-radius:6px;"></div>
                </div>
                <p id="editProgressText" style="margin:6px 0 0; font-size:0.8rem; opacity:0.8;">Mengupload...</p>
            </div>
         </div>

         <div style="margin-bottom:18px;">
            <label for="editIsActive" style="display:block; margin-bottom:6px; font-weight: 600;">Status Keaktifan</label>
            <select id="editIsActive" name="is_active" style="width:100%; padding:10px; border-radius:8px; border:1px solid rgba(255,255,255,.2); background:#203729; color:#fff; cursor: pointer;">
               <option value="1">Aktif</option>
               <option value="0">Tidak Aktif</option>
            </select>
         </div>

         <div style="display:flex; gap:10px; justify-content:flex-end; border-top: 1px solid rgba(255,255,255,0.1); padding-top: 15px;">
            <button type="button" id="closeModalBtn" style="padding:10px 18px; border-radius:8px; border:1px solid rgba(255,255,255,.25); background:transparent; color:#fff; cursor: pointer;">Batal</button>
            <button type="submit" style="padding:10px 18px; border-radius:8px; border:none; background:#d4b15a; color:#102417; font-weight:700; cursor: pointer;">Simpan Perubahan</button>
         </div>
      </form>
   </div>
</div>

<div id="addModal" style="display:none; position:fixed; inset:0; background:rgba(0,0,0,.65); z-index:9999; align-items:center; justify-content:center; backdrop-filter: blur(4px);">
   <div style="width:min(640px, 92vw); background:#102417; color:#fff; border:1px solid rgba(255,255,255,.2); border-radius:16px; padding:24px; box-shadow: 0 10px 25px rgba(0,0,0,0.5);">
      <h3 style="margin:0 0 18px; font-size: 1.5rem; color:#d4b15a; border-bottom: 1px solid rgba(255,255,255,0.1); padding-bottom: 10px;">Tambah Data Mini Zoo</h3>
      <form method="post" action="{{ url('settings/create_minizoo') }}">
         <input type="hidden" name="img_url" id="addImgUrl" value="">

         <div style="margin-bottom:14px;">
            <label for="addNama" style="display:block; margin-bottom:6px; font-weight: 600;">Nama Satwa</label>
            <input id="addNama" name="nama" type="text" required style="width:100%; padding:10px; border-radius:8px; border:1px solid rgba(255,255,255,.2); background:#203729; color:#fff;">
         </div>

         <div style="margin-bottom:14px;">
            <label for="addDeskripsi" style="display:block; margin-bottom:6px; font-weight: 600;">Deskripsi</label>
            <textarea id="addDeskripsi" name="deskripsi" rows="3" style="width:100%; padding:10px; border-radius:8px; border:1px solid rgba(255,255,255,.2); background:#203729; color:#fff; resize: vertical; font-family: inherit; line-height: 1.4;"></textarea>
         </div>

         <div id="addImageUploadContainer" style="margin-bottom:14px;">
            <label for="addImage" id="addUploadLabel" style="display:block; margin-bottom:6px; font-weight: 600;">Upload Foto (Maks 5MB)</label>
            <input type="file" id="addImage" accept="image/*" style="width:100%; padding:8px; border-radius:8px; border:1px solid rgba(255,255,255,.2); background:#203729; color:#fff;">
            <div id="addProgressContainer" style="display:none; margin-top:10px;">
                <div style="background:rgba(255,255,255,0.1); border-radius:6px; height:10px; overflow:hidden;">
                    <div id="addProgressBar" style="height:100%; width:0%; background:#d4b15a; transition:width 0.3s ease; border-radius:6px;"></div>
                </div>
                <p id="addProgressText" style="margin:6px 0 0; font-size:0.8rem; opacity:0.8;">Mengupload...</p>
            </div>
         </div>

         <div style="margin-bottom:18px;">
            <label for="addIsActive" style="display:block; margin-bottom:6px; font-weight: 600;">Status Keaktifan</label>
            <select id="addIsActive" name="is_active" style="width:100%; padding:10px; border-radius:8px; border:1px solid rgba(255,255,255,.2); background:#203729; color:#fff; cursor: pointer;">
               <option value="1" selected>Aktif</option>
               <option value="0">Tidak Aktif</option>
            </select>
         </div>

         <div style="display:flex; gap:10px; justify-content:flex-end; border-top: 1px solid rgba(255,255,255,0.1); padding-top: 15px;">
            <button type="button" id="closeAddModalBtn" style="padding:10px 18px; border-radius:8px; border:1px solid rgba(255,255,255,.25); background:transparent; color:#fff; cursor: pointer;">Batal</button>
            <button type="submit" style="padding:10px 18px; border-radius:8px; border:none; background:#d4b15a; color:#102417; font-weight:700; cursor: pointer;">Simpan Data</button>
         </div>
      </form>
   </div>
</div>

<script>
(function () {
   const editModal = document.getElementById('editModal');
   const addModal = document.getElementById('addModal');
   const addBtn = document.getElementById('addBtn');
   const closeModalBtn = document.getElementById('closeModalBtn');
   const closeAddModalBtn = document.getElementById('closeAddModalBtn');

   const editImagePreview = document.getElementById('editImagePreview');
   const editNoImageText = document.getElementById('editNoImageText');
   const editImage = document.getElementById('editImage');
   const addImage = document.getElementById('addImage');

   const editFormEl = editModal.querySelector('form');
   const addFormEl = addModal.querySelector('form');

   function closeEditModal() {
      editModal.style.display = 'none';
      if (editImage) editImage.value = '';
      const progressContainer = document.getElementById('editProgressContainer');
      const progressBar = document.getElementById('editProgressBar');
      const progressText = document.getElementById('editProgressText');
      if (progressContainer) progressContainer.style.display = 'none';
      if (progressBar) {
         progressBar.style.width = '0%';
         progressBar.style.background = '#d4b15a';
      }
      if (progressText) progressText.textContent = '';
      const submitBtn = editFormEl.querySelector('button[type="submit"]');
      if (submitBtn) {
         submitBtn.disabled = false;
         submitBtn.textContent = 'Simpan Perubahan';
      }
   }

   function closeAddModal() {
      addModal.style.display = 'none';
      if (addImage) addImage.value = '';
      const progressContainer = document.getElementById('addProgressContainer');
      const progressBar = document.getElementById('addProgressBar');
      const progressText = document.getElementById('addProgressText');
      if (progressContainer) progressContainer.style.display = 'none';
      if (progressBar) {
         progressBar.style.width = '0%';
         progressBar.style.background = '#d4b15a';
      }
      if (progressText) progressText.textContent = '';
      const submitBtn = addFormEl.querySelector('button[type="submit"]');
      if (submitBtn) {
         submitBtn.disabled = false;
         submitBtn.textContent = 'Simpan Data';
      }
   }

   const tableBody = document.getElementById('galleryTableBody');
   if (tableBody) {
      tableBody.addEventListener('click', function (event) {
         const row = event.target.closest('.gallery-row-editable');
         if (!row) return;

         document.getElementById('editId').value = row.dataset.id || '';
         document.getElementById('editNama').value = row.dataset.nama || '';
         document.getElementById('editDeskripsi').value = row.dataset.deskripsi || '';
         document.getElementById('editIsActive').value = row.dataset.isActive || '1';
         document.getElementById('editImgUrl').value = '';

         const fullUrl = row.dataset.imgUrlFull || '';
         if (fullUrl) {
            editImagePreview.src = fullUrl;
            editImagePreview.style.display = 'block';
            editNoImageText.style.display = 'none';
         } else {
            editImagePreview.src = '';
            editImagePreview.style.display = 'none';
            editNoImageText.style.display = 'inline';
         }

         editModal.style.display = 'flex';
      });
   }

   if (addBtn) {
      addBtn.addEventListener('click', function () {
         document.getElementById('addImgUrl').value = '';
         addModal.style.display = 'flex';
      });
   }

   if (closeModalBtn) closeModalBtn.addEventListener('click', closeEditModal);
   if (closeAddModalBtn) closeAddModalBtn.addEventListener('click', closeAddModal);

   window.addEventListener('click', function (e) {
      if (e.target === editModal) closeEditModal();
      if (e.target === addModal) closeAddModal();
   });

   const CHUNK_SIZE = 2 * 1024 * 1024;

   function generateUploadId() {
      return 'upload_' + Date.now() + '_' + Math.random().toString(36).slice(2, 9);
   }

   async function chunkUploadFile(file, progressBar, progressText, progressContainer, resourceUrlInput) {
      const uploadId = generateUploadId();
      const totalChunks = Math.ceil(file.size / CHUNK_SIZE);
      const extension = file.name.split('.').pop().toLowerCase();

      progressContainer.style.display = 'block';
      progressText.textContent = 'Mempersiapkan upload...';
      progressBar.style.width = '0%';

      const metaForm = new FormData();
      metaForm.append('upload_id', uploadId);
      metaForm.append('extension', extension);

      try {
         const metaResp = await fetch("{{ url('settings/save_extension_minizoo') }}", {
            method: 'POST',
            body: metaForm,
         });
         const metaData = await metaResp.json();
         if (!metaData.success) {
            progressText.textContent = 'Gagal: ' + (metaData.message || 'Error metadata.');
            return false;
         }

         for (let i = 0; i < totalChunks; i++) {
            const start = i * CHUNK_SIZE;
            const end = Math.min(start + CHUNK_SIZE, file.size);
            const chunk = file.slice(start, end);

            const chunkForm = new FormData();
            chunkForm.append('upload_id', uploadId);
            chunkForm.append('chunk_index', i);
            chunkForm.append('total_chunks', totalChunks);
            chunkForm.append('chunk_data', chunk, 'chunk');

            const resp = await fetch("{{ url('settings/chunk_upload_minizoo') }}", {
               method: 'POST',
               body: chunkForm,
            });

            if (!resp.ok) {
               progressText.textContent = 'Upload gagal pada chunk ke-' + (i + 1) + '.';
               return false;
            }

            const data = await resp.json();
            if (!data.success) {
               progressText.textContent = 'Error: ' + (data.message || 'Upload chunk gagal.');
               return false;
            }

            const percent = Math.round(((i + 1) / totalChunks) * 100);
            progressBar.style.width = percent + '%';
            progressText.textContent = `Mengupload... ${percent}% (${i + 1}/${totalChunks} bagian)`;

            if (data.done && data.file_path) {
               resourceUrlInput.value = data.file_path;
               progressText.textContent = 'Upload selesai! File siap disimpan.';
               progressBar.style.background = '#2a9d52';
               return true;
            }
         }
      } catch (err) {
         progressText.textContent = 'Terjadi kesalahan jaringan atau server: ' + err.message;
         return false;
      }

      progressText.textContent = 'Semua chunk terkirim tapi server tidak mengembalikan path file.';
      return false;
   }

   addFormEl.addEventListener('submit', async function (e) {
      e.preventDefault();

      const file = addImage.files[0];
      if (!file) {
         alert('Pilih foto terlebih dahulu.');
         return;
      }

      if (file.size > (5 * 1024 * 1024)) {
         alert('Ukuran foto maksimal 5MB.');
         return;
      }

      const submitBtn = addFormEl.querySelector('button[type="submit"]');
      submitBtn.disabled = true;
      submitBtn.textContent = 'Mengupload...';

      const addImgUrl = document.getElementById('addImgUrl');
      const addProgress = document.getElementById('addProgressContainer');
      const addProgressBar = document.getElementById('addProgressBar');
      const addProgressText = document.getElementById('addProgressText');

      const success = await chunkUploadFile(file, addProgressBar, addProgressText, addProgress, addImgUrl);

      if (success) {
         addFormEl.submit();
      } else {
         submitBtn.disabled = false;
         submitBtn.textContent = 'Simpan Data';
      }
   });

   editFormEl.addEventListener('submit', async function (e) {
      e.preventDefault();

      const file = editImage.files[0];
      if (!file) {
         editFormEl.submit();
         return;
      }

      if (file.size > (5 * 1024 * 1024)) {
         alert('Ukuran foto maksimal 5MB.');
         return;
      }

      const submitBtn = editFormEl.querySelector('button[type="submit"]');
      submitBtn.disabled = true;
      submitBtn.textContent = 'Mengupload...';

      const editImgUrl = document.getElementById('editImgUrl');
      const editProgress = document.getElementById('editProgressContainer');
      const editProgressBar = document.getElementById('editProgressBar');
      const editProgressText = document.getElementById('editProgressText');

      const success = await chunkUploadFile(file, editProgressBar, editProgressText, editProgress, editImgUrl);

      if (success) {
         editFormEl.submit();
      } else {
         submitBtn.disabled = false;
         submitBtn.textContent = 'Simpan Perubahan';
      }
   });
})();
</script>
