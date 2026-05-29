<style>
   .gallery-row-editable {
      cursor: pointer;
      transition: background 0.2s ease-in-out;
   }

   .gallery-row-editable:hover {
      background: rgba(255, 255, 255, 0.05) !important;
   }

   .table th,
   .table td {
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

   .badge-category {
      background: rgba(212, 177, 90, 0.15);
      color: #d4b15a;
      border: 1px solid rgba(212, 177, 90, 0.35);
      padding: 4px 8px;
      border-radius: 6px;
      font-size: 0.8rem;
      font-weight: 700;
      letter-spacing: 0.4px;
   }

   .badge-media {
      background: rgba(120, 196, 255, 0.12);
      color: #8fd3ff;
      border: 1px solid rgba(120, 196, 255, 0.3);
      padding: 4px 8px;
      border-radius: 6px;
      font-size: 0.8rem;
      font-weight: 700;
      letter-spacing: 0.4px;
   }
   .pagination-link {
      display: inline-block;
      padding: 6px 12px;
      border-radius: 6px;
      background: rgba(255, 255, 255, 0.08);
      color: #fff;
      text-decoration: none;
      margin: 0 2px;
      transition: all 0.2s ease;
      border: 1px solid rgba(255, 255, 255, 0.1);
      cursor: pointer;
   }

   .pagination-link:hover {
      background: rgba(212, 177, 90, 0.2);
      border-color: rgba(212, 177, 90, 0.4);
      color: #d4b15a;
   }

   .pagination-link.active {
      background: #d4b15a;
      color: #102417;
      font-weight: 700;
      border-color: #d4b15a;
   }

   .pagination-link.disabled {
      pointer-events: none;
      opacity: 0.4;
      background: rgba(255, 255, 255, 0.02);
      border-color: rgba(255, 255, 255, 0.05);
      color: rgba(255, 255, 255, 0.4);
   }

   .btn-cari {
      padding: 8px 16px;
      border-radius: 6px;
      border: 1px solid #d4b15a;
      background: #d4b15a;
      color: #102417;
      font-weight: 700;
      cursor: pointer;
      font-family: 'Jost', sans-serif;
      transition: all 0.2s ease;
      display: inline-flex;
      align-items: center;
      justify-content: center;
   }

   .btn-cari:hover {
      background: #c29f4f;
      border-color: #c29f4f;
      transform: translateY(-1px);
   }

   .btn-reset {
      padding: 8px 16px;
      border-radius: 6px;
      border: 1px solid rgba(255, 255, 255, 0.2);
      background: rgba(255, 255, 255, 0.08);
      color: #fff;
      text-decoration: none;
      font-weight: 600;
      cursor: pointer;
      font-family: 'Jost', sans-serif;
      transition: all 0.2s ease;
      display: inline-flex;
      align-items: center;
      justify-content: center;
   }

   .btn-reset:hover {
      background: rgba(255, 255, 255, 0.15);
      border-color: rgba(255, 255, 255, 0.35);
      transform: translateY(-1px);
      color: #fff;
   }
</style>

<section style="padding: 120px 5% 60px; min-height: 70vh;">
   <div
      style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; flex-wrap: wrap; gap: 12px;">
      <div>
         <h1 style="margin: 0 0 4px 0;">Settings - Galeri</h1>
         <p style="margin: 0;">Klik pada baris tabel untuk meng-edit data galeri.</p>
      </div>
      <div>
         <button type="button" id="addBtn"
            style="padding: 10px 20px; border-radius: 8px; border: none; background: #d4b15a; color: #102417; font-weight: 700; cursor: pointer; display: flex; align-items: center; gap: 6px; transition: all 0.2s; box-shadow: 0 4px 10px rgba(212, 177, 90, 0.2);">
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"
               style="vertical-align: middle;">
               <line x1="12" y1="5" x2="12" y2="19"></line>
               <line x1="5" y1="12" x2="19" y2="12"></line>
            </svg>
            Tambah Galeri
         </button>
      </div>
   </div>

   <form id="searchForm" method="get" action="{{ url('settings/galeri') }}"
      style="display:flex; gap:10px; align-items:center; flex-wrap:wrap; margin-bottom:16px;">
      <input type="text" name="search" id="search" value="{{ searchQuery }}"
         placeholder="Cari judul, deskripsi, kategori, tipe media..."
         style="min-width:280px; max-width:420px; width:100%; padding:10px 12px; border-radius:8px; border:1px solid rgba(255,255,255,.2); background:#203729; color:#fff; font-family: 'Jost', sans-serif;">
      <button type="submit" class="btn-cari">Cari</button>
      {% if searchQuery is not empty %}
      <a href="{{ url('settings/galeri') }}" class="btn-reset">Reset</a>
      {% endif %}
   </form>

   {% if updateSuccess %}
   <div
      style="padding:10px 12px; border:1px solid #2a9d52; background:#11361f; color:#c9f7d8; border-radius:8px; margin-bottom:14px;">
      {{ updateSuccess }}
   </div>
   {% endif %}

   {% if updateError %}
   <div
      style="padding:10px 12px; border:1px solid #b84141; background:#3a1616; color:#ffd1d1; border-radius:8px; margin-bottom:14px;">
      {{ updateError }}
   </div>
   {% endif %}

   {% if galleryList is empty %}
   <p>Data galeri belum tersedia.</p>
   {% else %}
   <div class="table-responsive"
      style="overflow-x: auto; background: rgba(16, 36, 23, 0.6); border: 1px solid rgba(255,255,255,0.1); border-radius: 12px; padding: 10px;">
      <div style="margin-bottom:8px; color:#e8cc7a; font-size:0.9rem;">
         Menampilkan {{ ((currentPage - 1) * perPage) + 1 }} – {{ ((currentPage - 1) * perPage) + galleryList|length }} dari {{ totalItems }} data
      </div>
      <table class="table table-sm text-white" style="width:100%; border-collapse: collapse;">
         <thead>
            <tr style="background: rgba(0,0,0,0.2);">
               <th style="text-align:left; padding:12px 10px; border-bottom:2px solid rgba(255,255,255,.15);">Judul</th>
               <th style="text-align:left; padding:12px 10px; border-bottom:2px solid rgba(255,255,255,.15);">Deskripsi
               </th>
               <th style="text-align:center; padding:12px 10px; border-bottom:2px solid rgba(255,255,255,.15);">Kategori
               </th>
               <th style="text-align:center; padding:12px 10px; border-bottom:2px solid rgba(255,255,255,.15);">Tipe
                  Media</th>
               <th style="text-align:center; padding:12px 10px; border-bottom:2px solid rgba(255,255,255,.15);">Preview
               </th>
               <th style="text-align:center; padding:12px 10px; border-bottom:2px solid rgba(255,255,255,.15);">Status
               </th>
               <th style="text-align:left; padding:12px 10px; border-bottom:2px solid rgba(255,255,255,.15);">Updated At
               </th>
            </tr>
         </thead>
         <tbody id="galleryTableBody">
            {% for item in galleryList %}
            <tr class="gallery-row-editable" data-id="{{ item['id'] }}" data-title="{{ item['title'] }}"
               data-description="{{ item['description'] }}" data-category="{{ item['category'] }}"
               data-type-media="{{ item['type_media'] }}" data-resource-url="{{ item['resource_url'] }}"
               data-is-active="{{ item['is_active'] == 't' or item['is_active'] === true or item['is_active'] === '1' or item['is_active'] === 1 ? '1' : '0' }}"
               data-resource-full-url="{{ item['resource_url'] ? url(item['resource_url']) : '' }}">
               <td
                  style="padding:12px 10px; border-bottom:1px solid rgba(255,255,255,.08); font-weight: 600; color: #d4b15a;">
                  {{ item['title'] }}</td>
               <td
                  style="padding:12px 10px; border-bottom:1px solid rgba(255,255,255,.08); font-size: 0.9rem; opacity: 0.9; line-height: 1.4;">
                  {{ item['description'] ? item['description'] : '-' }}</td>
               <td style="padding:12px 10px; border-bottom:1px solid rgba(255,255,255,.08); text-align: center;"><span
                     class="badge-category">{{ item['category'] }}</span></td>
               <td style="padding:12px 10px; border-bottom:1px solid rgba(255,255,255,.08); text-align: center;"><span
                     class="badge-media">{{ item['type_media'] }}</span></td>
               <td style="padding:12px 10px; border-bottom:1px solid rgba(255,255,255,.08); text-align: center;">
                  {% if item['type_media'] == 'FOTO' %}
                  {% if item['resource_url'] %}
                  <img src="{{ url(item['resource_url']) }}" alt="{{ item['title'] }}"
                     style="max-height:50px; max-width:80px; border-radius:6px; object-fit:cover; border:1px solid rgba(255,255,255,0.15);">
                  {% else %}
                  <em style="opacity:.5; font-size:0.9rem;">(tidak ada)</em>
                  {% endif %}
                  {% else %}
                  {% if item['resource_url'] %}
                  <a href="{{ url(item['resource_url']) }}" target="_blank" rel="noopener"
                     style="color:#8fd3ff; text-decoration:none;">Lihat Video</a>
                  {% else %}
                  <em style="opacity:.5; font-size:0.9rem;">(tidak ada)</em>
                  {% endif %}
                  {% endif %}
               </td>
               <td style="padding:12px 10px; border-bottom:1px solid rgba(255,255,255,.08); text-align: center;">
                  {% if item['is_active'] == 't' or item['is_active'] === true or item['is_active'] === '1' or
                  item['is_active'] === 1 %}
                  <span class="badge-active">Aktif</span>
                  {% else %}
                  <span class="badge-inactive">Tidak Aktif</span>
                  {% endif %}
               </td>
               <td
                  style="padding:12px 10px; border-bottom:1px solid rgba(255,255,255,.08); font-size: 0.85rem; opacity: 0.85;">
                  {{ item['updated_at'] ? item['updated_at'] : item['created_at'] }}
                  <div style="font-size: 0.75rem; opacity: 0.7; margin-top: 2px;">
                     Oleh: {{ item['updated_by_nama'] ? item['updated_by_nama'] : (item['created_by_nama'] ?
                     item['created_by_nama'] : '-') }}
                  </div>
               </td>
            </tr>
            {% endfor %}
         </tbody>
      </table>
   </div>
   <!-- Pagination Controls -->
   <div style="display:flex; justify-content:center; align-items:center; margin-top:12px; gap:8px;">
      {% set prevPage = currentPage > 1 ? currentPage - 1 : 1 %}
      {% set nextPage = currentPage < totalPages ? currentPage + 1 : totalPages %}
      
      {% if currentPage == 1 %} 
         <span class="pagination-link disabled">Prev</span>
      {% else %}
         <a href="{{ url('settings/galeri') }}?{{ http_build_query({'search': searchQuery, 'page': prevPage}) }}"
            class="pagination-link">Prev</a>
      {% endif %}
      
      {% for i in 1..totalPages %}
         {% if i == currentPage %}
            <span class="pagination-link active">{{ i }}</span>
         {% else %}
            <a href="{{ url('settings/galeri') }}?{{ http_build_query({'search': searchQuery, 'page': i}) }}"
               class="pagination-link">{{ i }}</a>
         {% endif %}
      {% endfor %}
      
      {% if currentPage == totalPages %}
         <span class="pagination-link disabled">Next</span>
      {% else %}
         <a href="{{ url('settings/galeri') }}?{{ http_build_query({'search': searchQuery, 'page': nextPage}) }}"
            class="pagination-link">Next</a>
      {% endif %}
   </div>
   {% endif %}
</section>

<div id="editModal"
   style="display:none; position:fixed; inset:0; background:rgba(0,0,0,.65); z-index:9999; align-items:center; justify-content:center; backdrop-filter: blur(4px);">
   <div
      style="width:min(640px, 92vw); background:#102417; color:#fff; border:1px solid rgba(255,255,255,.2); border-radius:16px; padding:24px; box-shadow: 0 10px 25px rgba(0,0,0,0.5);">
      <h3
         style="margin:0 0 18px; font-size: 1.5rem; color:#d4b15a; border-bottom: 1px solid rgba(255,255,255,0.1); padding-bottom: 10px;">
         Edit Galeri</h3>
      <form method="post" action="{{ url('settings/update_galeri') }}">
         <input type="hidden" name="id" id="editId">
         <input type="hidden" name="resource_url" id="editResourceUrl" value="">

         <div style="margin-bottom:14px;">
            <label for="editTitle" style="display:block; margin-bottom:6px; font-weight: 600;">Judul</label>
            <input id="editTitle" name="title" type="text" required
               style="width:100%; padding:10px; border-radius:8px; border:1px solid rgba(255,255,255,.2); background:#203729; color:#fff;">
         </div>

         <div style="margin-bottom:14px;">
            <label for="editDescription" style="display:block; margin-bottom:6px; font-weight: 600;">Deskripsi</label>
            <textarea id="editDescription" name="description" rows="3"
               style="width:100%; padding:10px; border-radius:8px; border:1px solid rgba(255,255,255,.2); background:#203729; color:#fff; resize: vertical; font-family: inherit; line-height: 1.4;"></textarea>
         </div>

         <div style="margin-bottom:14px; display: flex; gap: 12px; flex-wrap: wrap;">
            <div style="flex: 1; min-width: 150px;">
               <label for="editCategory" style="display:block; margin-bottom:6px; font-weight: 600;">Kategori</label>
               <select id="editCategory" name="category" required
                  style="width:100%; padding:10px; border-radius:8px; border:1px solid rgba(255,255,255,.2); background:#203729; color:#fff; cursor: pointer;">
                  <option value="WAHANA">WAHANA</option>
                  <option value="AREA">AREA</option>
                  <option value="EVENT">EVENT</option>
               </select>
            </div>
            <div style="flex: 1; min-width: 150px;">
               <label for="editTypeMedia" style="display:block; margin-bottom:6px; font-weight: 600;">Tipe Media</label>
               <select id="editTypeMedia" name="type_media" required
                  style="width:100%; padding:10px; border-radius:8px; border:1px solid rgba(255,255,255,.2); background:#203729; color:#fff; cursor: pointer;">
                  <option value="FOTO">FOTO</option>
                  <option value="VIDEO">VIDEO</option>
               </select>
            </div>
         </div>

         <div id="editImageUploadContainer" style="margin-bottom:14px;">
            <label style="display:block; margin-bottom:6px; font-weight: 600;">Foto Saat Ini</label>
            <div style="margin-bottom: 8px;">
               <img id="editImagePreview" src="" alt="Preview"
                  style="max-height:100px; border-radius:8px; display:none; border:1px solid rgba(255,255,255,0.2);">
               <span id="editNoImageText" style="font-style: italic; opacity: 0.6; display: none;">Tidak ada foto</span>
            </div>
            <label for="editImage" id="editUploadLabel"
               style="display:block; margin-bottom:6px; font-weight: 600;">Upload Foto Baru (Maks 5MB)</label>
            <input type="file" id="editImage" accept="image/*,video/mp4,video/webm,video/quicktime,video/x-m4v"
               style="width:100%; padding:8px; border-radius:8px; border:1px solid rgba(255,255,255,.2); background:#203729; color:#fff;">
            <div id="editProgressContainer" style="display:none; margin-top:10px;">
               <div style="background:rgba(255,255,255,0.1); border-radius:6px; height:10px; overflow:hidden;">
                  <div id="editProgressBar"
                     style="height:100%; width:0%; background:#d4b15a; transition:width 0.3s ease; border-radius:6px;">
                  </div>
               </div>
               <p id="editProgressText" style="margin:6px 0 0; font-size:0.8rem; opacity:0.8;">Mengupload...</p>
            </div>
         </div>

         <div style="margin-bottom:18px;">
            <label for="editIsActive" style="display:block; margin-bottom:6px; font-weight: 600;">Status
               Keaktifan</label>
            <select id="editIsActive" name="is_active"
               style="width:100%; padding:10px; border-radius:8px; border:1px solid rgba(255,255,255,.2); background:#203729; color:#fff; cursor: pointer;">
               <option value="1">Aktif</option>
               <option value="0">Tidak Aktif</option>
            </select>
         </div>

         <div
            style="display:flex; gap:10px; justify-content:flex-end; border-top: 1px solid rgba(255,255,255,0.1); padding-top: 15px;">
            <button type="button" id="closeModalBtn"
               style="padding:10px 18px; border-radius:8px; border:1px solid rgba(255,255,255,.25); background:transparent; color:#fff; cursor: pointer;">Batal</button>
            <button type="submit"
               style="padding:10px 18px; border-radius:8px; border:none; background:#d4b15a; color:#102417; font-weight:700; cursor: pointer;">Simpan
               Perubahan</button>
         </div>
      </form>
   </div>
</div>

<div id="addModal"
   style="display:none; position:fixed; inset:0; background:rgba(0,0,0,.65); z-index:9999; align-items:center; justify-content:center; backdrop-filter: blur(4px);">
   <div
      style="width:min(640px, 92vw); background:#102417; color:#fff; border:1px solid rgba(255,255,255,.2); border-radius:16px; padding:24px; box-shadow: 0 10px 25px rgba(0,0,0,0.5);">
      <h3
         style="margin:0 0 18px; font-size: 1.5rem; color:#d4b15a; border-bottom: 1px solid rgba(255,255,255,0.1); padding-bottom: 10px;">
         Tambah Galeri</h3>
      <form method="post" action="{{ url('settings/create_galeri') }}">
         <input type="hidden" name="resource_url" id="addResourceUrl" value="">

         <div style="margin-bottom:14px;">
            <label for="addTitle" style="display:block; margin-bottom:6px; font-weight: 600;">Judul</label>
            <input id="addTitle" name="title" type="text" required
               style="width:100%; padding:10px; border-radius:8px; border:1px solid rgba(255,255,255,.2); background:#203729; color:#fff;">
         </div>

         <div style="margin-bottom:14px;">
            <label for="addDescription" style="display:block; margin-bottom:6px; font-weight: 600;">Deskripsi</label>
            <textarea id="addDescription" name="description" rows="3"
               style="width:100%; padding:10px; border-radius:8px; border:1px solid rgba(255,255,255,.2); background:#203729; color:#fff; resize: vertical; font-family: inherit; line-height: 1.4;"></textarea>
         </div>

         <div style="margin-bottom:14px; display: flex; gap: 12px; flex-wrap: wrap;">
            <div style="flex: 1; min-width: 150px;">
               <label for="addCategory" style="display:block; margin-bottom:6px; font-weight: 600;">Kategori</label>
               <select id="addCategory" name="category" required
                  style="width:100%; padding:10px; border-radius:8px; border:1px solid rgba(255,255,255,.2); background:#203729; color:#fff; cursor: pointer;">
                  <option value="EVENT" selected>EVENT</option>
                  <option value="WAHANA">WAHANA</option>
                  <option value="AREA">AREA</option>
               </select>
            </div>
            <div style="flex: 1; min-width: 150px;">
               <label for="addTypeMedia" style="display:block; margin-bottom:6px; font-weight: 600;">Tipe Media</label>
               <select id="addTypeMedia" name="type_media" required
                  style="width:100%; padding:10px; border-radius:8px; border:1px solid rgba(255,255,255,.2); background:#203729; color:#fff; cursor: pointer;">
                  <option value="FOTO" selected>FOTO</option>
                  <option value="VIDEO">VIDEO</option>
               </select>
            </div>
         </div>

         <div id="addImageUploadContainer" style="margin-bottom:14px;">
            <label for="addImage" id="addUploadLabel" style="display:block; margin-bottom:6px; font-weight: 600;">Upload
               Foto (Maks 5MB)</label>
            <input type="file" id="addImage" accept="image/*,video/mp4,video/webm,video/quicktime,video/x-m4v"
               style="width:100%; padding:8px; border-radius:8px; border:1px solid rgba(255,255,255,.2); background:#203729; color:#fff;">
            <div id="addProgressContainer" style="display:none; margin-top:10px;">
               <div style="background:rgba(255,255,255,0.1); border-radius:6px; height:10px; overflow:hidden;">
                  <div id="addProgressBar"
                     style="height:100%; width:0%; background:#d4b15a; transition:width 0.3s ease; border-radius:6px;">
                  </div>
               </div>
               <p id="addProgressText" style="margin:6px 0 0; font-size:0.8rem; opacity:0.8;">Mengupload...</p>
            </div>
         </div>

         <div style="margin-bottom:18px;">
            <label for="addIsActive" style="display:block; margin-bottom:6px; font-weight: 600;">Status
               Keaktifan</label>
            <select id="addIsActive" name="is_active"
               style="width:100%; padding:10px; border-radius:8px; border:1px solid rgba(255,255,255,.2); background:#203729; color:#fff; cursor: pointer;">
               <option value="1" selected>Aktif</option>
               <option value="0">Tidak Aktif</option>
            </select>
         </div>

         <div
            style="display:flex; gap:10px; justify-content:flex-end; border-top: 1px solid rgba(255,255,255,0.1); padding-top: 15px;">
            <button type="button" id="closeAddModalBtn"
               style="padding:10px 18px; border-radius:8px; border:1px solid rgba(255,255,255,.25); background:transparent; color:#fff; cursor: pointer;">Batal</button>
            <button type="submit"
               style="padding:10px 18px; border-radius:8px; border:none; background:#d4b15a; color:#102417; font-weight:700; cursor: pointer;">Simpan
               Galeri</button>
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

      const editTypeMedia = document.getElementById('editTypeMedia');
      const addTypeMedia = document.getElementById('addTypeMedia');

      const editUploadLabel = document.getElementById('editUploadLabel');
      const addUploadLabel = document.getElementById('addUploadLabel');

      const editImageUploadContainer = document.getElementById('editImageUploadContainer');
      const addImageUploadContainer = document.getElementById('addImageUploadContainer');

      const editImagePreview = document.getElementById('editImagePreview');
      const editNoImageText = document.getElementById('editNoImageText');

      const editImage = document.getElementById('editImage');
      const addImage = document.getElementById('addImage');

      const editFormEl = editModal.querySelector('form');
      const addFormEl = addModal.querySelector('form');

      function toggleMediaFields(typeMediaSelect, uploadLabelEl, fileInputEl, imageContainerEl) {
         const isFoto = typeMediaSelect.value === 'FOTO';
         imageContainerEl.style.display = 'block';
         uploadLabelEl.textContent = isFoto
            ? 'Upload Foto (Maks 5MB)'
            : 'Upload Video (Maks 200MB)';
         if (fileInputEl) {
            fileInputEl.accept = isFoto
               ? 'image/*'
               : 'video/mp4,video/webm,video/quicktime,video/x-m4v';
         }
      }

      if (editTypeMedia) {
         editTypeMedia.addEventListener('change', function () {
            toggleMediaFields(editTypeMedia, editUploadLabel, editImage, editImageUploadContainer);
         });
      }

      if (addTypeMedia) {
         addTypeMedia.addEventListener('change', function () {
            toggleMediaFields(addTypeMedia, addUploadLabel, addImage, addImageUploadContainer);
         });
      }

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
            submitBtn.textContent = 'Simpan Galeri';
         }
      }

      const tableBody = document.getElementById('galleryTableBody');
      if (tableBody) {
         tableBody.addEventListener('click', function (event) {
            const row = event.target.closest('.gallery-row-editable');
            if (!row) return;

            document.getElementById('editId').value = row.dataset.id || '';
            document.getElementById('editTitle').value = row.dataset.title || '';
            document.getElementById('editDescription').value = row.dataset.description || '';
            document.getElementById('editCategory').value = row.dataset.category || 'EVENT';
            editTypeMedia.value = row.dataset.typeMedia || 'FOTO';
            document.getElementById('editIsActive').value = row.dataset.isActive || '1';
            document.getElementById('editResourceUrl').value = ''; // Reset resource_url hidden input

            const isFoto = editTypeMedia.value === 'FOTO';
            const fullUrl = row.dataset.resourceFullUrl || '';
            if (isFoto && fullUrl) {
               editImagePreview.src = fullUrl;
               editImagePreview.style.display = 'block';
               editNoImageText.style.display = 'none';
            } else if (isFoto) {
               editImagePreview.src = '';
               editImagePreview.style.display = 'none';
               editNoImageText.style.display = 'inline';
            } else {
               editImagePreview.src = '';
               editImagePreview.style.display = 'none';
               editNoImageText.style.display = 'none';
            }

            toggleMediaFields(editTypeMedia, editUploadLabel, editImage, editImageUploadContainer);
            editModal.style.display = 'flex';
         });
      }

      if (addBtn) {
         addBtn.addEventListener('click', function () {
            document.getElementById('addResourceUrl').value = ''; // Reset resource_url hidden input
            toggleMediaFields(addTypeMedia, addUploadLabel, addImage, addImageUploadContainer);
            addModal.style.display = 'flex';
         });
      }

      if (closeModalBtn) closeModalBtn.addEventListener('click', closeEditModal);
      if (closeAddModalBtn) closeAddModalBtn.addEventListener('click', closeAddModal);

      window.addEventListener('click', function (e) {
         if (e.target === editModal) closeEditModal();
         if (e.target === addModal) closeAddModal();
      });

      // ─── CHUNK UPLOAD LOGIC ───────────────────────────────────────────────
      const CHUNK_SIZE = 2 * 1024 * 1024; // 2MB per chunk

      function generateUploadId() {
         return 'upload_' + Date.now() + '_' + Math.random().toString(36).slice(2, 9);
      }

      async function chunkUploadFile(file, typeMedia, category, progressBar, progressText, progressContainer, resourceUrlInput) {
         const uploadId = generateUploadId();
         const totalChunks = Math.ceil(file.size / CHUNK_SIZE);
         const extension = file.name.split('.').pop().toLowerCase();

         progressContainer.style.display = 'block';
         progressText.textContent = 'Mempersiapkan upload...';
         progressBar.style.width = '0%';

         // Step 1: Kirim metadata ekstensi
         const metaForm = new FormData();
         metaForm.append('upload_id', uploadId);
         metaForm.append('extension', extension);

         try {
            const metaResp = await fetch("{{ url('settings/save_extension_galeri') }}", {
               method: 'POST',
               body: metaForm,
            });
            const metaData = await metaResp.json();
            if (!metaData.success) {
               progressText.textContent = 'Gagal: ' + (metaData.message || 'Error metadata.');
               return false;
            }

            // Step 2: Kirim chunk satu per satu (sequential)
            for (let i = 0; i < totalChunks; i++) {
               const start = i * CHUNK_SIZE;
               const end = Math.min(start + CHUNK_SIZE, file.size);
               const chunk = file.slice(start, end);

               const chunkForm = new FormData();
               chunkForm.append('upload_id', uploadId);
               chunkForm.append('chunk_index', i);
               chunkForm.append('total_chunks', totalChunks);
               chunkForm.append('type_media', typeMedia);
               chunkForm.append('category', category);
               chunkForm.append('chunk_data', chunk, 'chunk');

               const resp = await fetch("{{ url('settings/chunk_upload_galeri') }}", {
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

               // Update progress bar
               const percent = Math.round(((i + 1) / totalChunks) * 100);
               progressBar.style.width = percent + '%';
               progressText.textContent = `Mengupload... ${percent}% (${i + 1}/${totalChunks} bagian)`;

               // Jika chunk terakhir dan server return file_path
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

      // ─── ATTACH CHUNK UPLOAD KE FORM TAMBAH ──────────────────────────────
      addFormEl.addEventListener('submit', async function (e) {
         e.preventDefault(); // Tahan submit dulu

         const file = addImage.files[0];
         const typeMedia = document.getElementById('addTypeMedia').value;
         const category = document.getElementById('addCategory').value;

         if (!file) {
            alert('Pilih file media terlebih dahulu.');
            return;
         }

         // Validasi ukuran file di frontend
         const maxSize = typeMedia === 'VIDEO' ? 200 * 1024 * 1024 : 5 * 1024 * 1024;
         if (file.size > maxSize) {
            alert(typeMedia === 'VIDEO' ? 'Ukuran video maksimal 200MB.' : 'Ukuran foto maksimal 5MB.');
            return;
         }

         const submitBtn = addFormEl.querySelector('button[type="submit"]');
         submitBtn.disabled = true;
         submitBtn.textContent = 'Mengupload...';

         const addResourceUrl = document.getElementById('addResourceUrl');
         const addProgress = document.getElementById('addProgressContainer');
         const addProgressBar = document.getElementById('addProgressBar');
         const addProgressText = document.getElementById('addProgressText');

         const success = await chunkUploadFile(
            file, typeMedia, category,
            addProgressBar, addProgressText, addProgress, addResourceUrl
         );

         if (success) {
            // Upload berhasil, lanjut submit form ke controller
            addFormEl.submit();
         } else {
            submitBtn.disabled = false;
            submitBtn.textContent = 'Simpan Galeri';
         }
      });

      // ─── ATTACH CHUNK UPLOAD KE FORM EDIT ────────────────────────────────
      editFormEl.addEventListener('submit', async function (e) {
         e.preventDefault();

         const file = editImage.files[0];

         if (!file) {
            // Tidak ada file baru dipilih, submit form langsung (pertahankan resource_url lama)
            editFormEl.submit();
            return;
         }

         const typeMedia = document.getElementById('editTypeMedia').value;
         const category = document.getElementById('editCategory').value;
         const maxSize = typeMedia === 'VIDEO' ? 200 * 1024 * 1024 : 5 * 1024 * 1024;

         if (file.size > maxSize) {
            alert(typeMedia === 'VIDEO' ? 'Ukuran video maksimal 200MB.' : 'Ukuran foto maksimal 5MB.');
            return;
         }

         const submitBtn = editFormEl.querySelector('button[type="submit"]');
         submitBtn.disabled = true;
         submitBtn.textContent = 'Mengupload...';

         const editResourceUrl = document.getElementById('editResourceUrl');
         const editProgress = document.getElementById('editProgressContainer');
         const editProgressBar = document.getElementById('editProgressBar');
         const editProgressText = document.getElementById('editProgressText');

         const success = await chunkUploadFile(
            file, typeMedia, category,
            editProgressBar, editProgressText, editProgress, editResourceUrl
         );

         if (success) {
            editFormEl.submit();
         } else {
            submitBtn.disabled = false;
            submitBtn.textContent = 'Simpan Perubahan';
         }
      });

      // set btn F2 to focus search input
      document.addEventListener('keydown', function (event) {
         if (event.key === 'F2') {
            event.preventDefault();
            document.getElementById('search').focus();
         }
      });
   })();
</script>
