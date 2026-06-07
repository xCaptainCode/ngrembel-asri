<style>
   .promo-row-editable {
      cursor: pointer;
      transition: background 0.2s ease-in-out;
   }
   .promo-row-editable:hover {
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
   .badge-upcoming {
      background: #142b3b;
      color: #d1f0ff;
      border: 1px solid #3fa8eb;
      padding: 4px 8px;
      border-radius: 6px;
      font-size: 0.85rem;
      font-weight: 600;
   }
   .badge-expired {
      background: #2b2b2b;
      color: #e0e0e0;
      border: 1px solid #666666;
      padding: 4px 8px;
      border-radius: 6px;
      font-size: 0.85rem;
      font-weight: 600;
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
   <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; flex-wrap: wrap; gap: 12px;">
      <div>
         <h1 style="margin: 0 0 4px 0; font-family: 'Cormorant Garamond', serif; font-size: clamp(2rem, 5vw, 3rem); font-weight: 400;">Settings - Promosi</h1>
         <p style="margin: 0;">Klik pada baris tabel untuk meng-edit atau menghapus data Promosi.</p>
         <form id="searchForm" method="GET" style="display:flex; gap:8px; align-items:center; flex-wrap:wrap; margin-top:12px;">
            <input type="text" name="search" placeholder="Cari Promosi..." value="{{ search }}" style="padding:8px 20px; border-radius:6px; border:1px solid rgba(255,255,255,0.2); background:rgba(255,255,255,0.04); color:#fff; font-family: 'Jost', sans-serif;" />
            <button type="submit" class="btn-cari">Cari</button>
            {% if search is not empty %}
            <a href="{{ url('settings/promotions') }}" class="btn-reset">Reset</a>
            {% endif %}
         </form>
      </div>
      <div>
         <button type="button" id="addBtn" style="padding: 10px 20px; border-radius: 8px; border: none; background: #d4b15a; color: #102417; font-weight: 700; cursor: pointer; display: flex; align-items: center; gap: 6px; transition: all 0.2s; box-shadow: 0 4px 10px rgba(212, 177, 90, 0.2);">
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" style="vertical-align: middle;">
               <line x1="12" y1="5" x2="12" y2="19"></line>
               <line x1="5" y1="12" x2="19" y2="12"></line>
            </svg>
            Tambah Promosi
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

   {% if promotionsList is empty %}
   <p>Data promosi belum tersedia.</p>
   {% else %}
   <div class="table-responsive" style="overflow-x: auto; background: rgba(16, 36, 23, 0.6); border: 1px solid rgba(255,255,255,0.1); border-radius: 12px; padding: 10px;">
      <div style="margin-bottom:8px; color:#e8cc7a; font-size:0.9rem;">
         Menampilkan {{ ((currentPage - 1) * perPage) + 1 }} – {{ ((currentPage - 1) * perPage) + promotionsList|length }} dari {{ totalData }} data
      </div>
      <table class="table table-sm text-white" style="width:100%; border-collapse: collapse;">
         <thead>
            <tr style="background: rgba(0,0,0,0.2);">
               <th style="text-align:left; padding:12px 10px; border-bottom:2px solid rgba(255,255,255,.15);">Nama Promosi</th>
               <th style="text-align:left; padding:12px 10px; border-bottom:2px solid rgba(255,255,255,.15); width: 35%;">Deskripsi</th>
               <th style="text-align:center; padding:12px 10px; border-bottom:2px solid rgba(255,255,255,.15);">Mulai</th>
               <th style="text-align:center; padding:12px 10px; border-bottom:2px solid rgba(255,255,255,.15);">Selesai</th>
               <th style="text-align:center; padding:12px 10px; border-bottom:2px solid rgba(255,255,255,.15);">Preview</th>
               <th style="text-align:center; padding:12px 10px; border-bottom:2px solid rgba(255,255,255,.15);">Masa Aktif</th>
               <th style="text-align:center; padding:12px 10px; border-bottom:2px solid rgba(255,255,255,.15);">Status</th>
            </tr>
         </thead>
         <tbody id="promoTableBody">
            {% for item in promotionsList %}
            <tr class="promo-row-editable"
                data-id="{{ item['id'] }}"
                data-name="{{ item['name'] }}"
                data-description="{{ item['description'] }}"
                data-image-url="{{ item['image_url'] }}"
                data-start-date="{{ date('Y-m-d\TH:i', strtotime(item['start_date'])) }}"
                data-end-date="{{ date('Y-m-d\TH:i', strtotime(item['end_date'])) }}"
                data-is-active="{{ item['is_active'] == 't' or item['is_active'] === true or item['is_active'] === '1' or item['is_active'] === 1 ? '1' : '0' }}"
                data-image-url-full="{{ item['image_url'] ? url(item['image_url']) : '' }}">
               <td style="padding:12px 10px; border-bottom:1px solid rgba(255,255,255,.08); font-weight: 600; color: #d4b15a;">{{ item['name'] }}</td>
               <td style="padding:12px 10px; border-bottom:1px solid rgba(255,255,255,.08); font-size: 0.9rem; opacity: 0.9; line-height: 1.4;">{{ item['description'] ? item['description'] : '-' }}</td>
               <td style="padding:12px 10px; border-bottom:1px solid rgba(255,255,255,.08); text-align: center; font-size: 0.85rem;">{{ date('d M Y H:i', strtotime(item['start_date'])) }}</td>
               <td style="padding:12px 10px; border-bottom:1px solid rgba(255,255,255,.08); text-align: center; font-size: 0.85rem;">{{ date('d M Y H:i', strtotime(item['end_date'])) }}</td>
               <td style="padding:12px 10px; border-bottom:1px solid rgba(255,255,255,.08); text-align: center;">
                  {% if item['image_url'] %}
                     <img src="{{ url(item['image_url']) }}" alt="{{ item['name'] }}" style="max-height:50px; max-width:80px; border-radius:6px; object-fit:cover; border:1px solid rgba(255,255,255,0.15);">
                  {% else %}
                     <em style="opacity:.5; font-size:0.9rem;">(tidak ada)</em>
                  {% endif %}
               </td>
               <td style="padding:12px 10px; border-bottom:1px solid rgba(255,255,255,.08); text-align: center;">
                  {% set nowTime = strtotime('now') %}
                  {% set startTime = strtotime(item['start_date']) %}
                  {% set endTime = strtotime(item['end_date']) %}
                  {% if nowTime < startTime %}
                     <span class="badge-upcoming">Mendatang</span>
                  {% elseif nowTime > endTime %}
                     <span class="badge-expired">Kadaluarsa</span>
                  {% else %}
                     <span class="badge-active">Berjalan</span>
                  {% endif %}
               </td>
               <td style="padding:12px 10px; border-bottom:1px solid rgba(255,255,255,.08); text-align: center;">
                  {% if item['is_active'] == 't' or item['is_active'] === true or item['is_active'] === '1' or item['is_active'] === 1 %}
                     <span class="badge-active">Aktif</span>
                  {% else %}
                     <span class="badge-inactive">Tidak Aktif</span>
                  {% endif %}
               </td>
            </tr>
            {% endfor %}
         </tbody>
      </table>
   </div>

   <!-- Paginasi -->
   <div style="display:flex; justify-content:center; align-items:center; margin-top:12px; gap:8px;">
      {% set prevPage = currentPage > 1 ? currentPage - 1 : 1 %}
      {% set nextPage = currentPage < totalPages ? currentPage + 1 : totalPages %}
      
      {% if currentPage == 1 %} 
         <span class="pagination-link disabled">Previous</span>
      {% else %}
         <a href="{{ url('settings/promotions') }}?{{ http_build_query({'search': search, 'page': prevPage, 'per_page': perPage}) }}" class="pagination-link">Previous</a>
      {% endif %}
      
      {% for i in 1..totalPages %}
         {% if i == currentPage %}
            <span class="pagination-link active">{{ i }}</span>
         {% else %}
            <a href="{{ url('settings/promotions') }}?{{ http_build_query({'search': search, 'page': i, 'per_page': perPage}) }}" class="pagination-link">{{ i }}</a>
         {% endif %}
      {% endfor %}
      
      {% if currentPage == totalPages %}
         <span class="pagination-link disabled">Next</span>
      {% else %}
         <a href="{{ url('settings/promotions') }}?{{ http_build_query({'search': search, 'page': nextPage, 'per_page': perPage}) }}" class="pagination-link">Next</a>
      {% endif %}
   </div>
   {% endif %}
</section>

<!-- Edit Modal -->
<div id="editModal" style="display:none; position:fixed; inset:0; background:rgba(0,0,0,.65); z-index:9999; align-items:center; justify-content:center; backdrop-filter: blur(4px);">
   <div style="width:min(640px, 92vw); background:#102417; color:#fff; border:1px solid rgba(255,255,255,.2); border-radius:16px; padding:24px; box-shadow: 0 10px 25px rgba(0,0,0,0.5);">
      <h3 style="margin:0 0 18px; font-size: 1.5rem; color:#d4b15a; border-bottom: 1px solid rgba(255,255,255,0.1); padding-bottom: 10px;">Edit Promosi</h3>
      <form method="post" action="{{ url('settings/update_promotion') }}">
         <input type="hidden" name="id" id="editId">
         <input type="hidden" name="image_url" id="editImgUrl" value="">

         <div style="margin-bottom:14px;">
            <label for="editName" style="display:block; margin-bottom:6px; font-weight: 600;">Nama Promosi</label>
            <input id="editName" name="name" type="text" required style="width:100%; padding:10px; border-radius:8px; border:1px solid rgba(255,255,255,.2); background:#203729; color:#fff;">
         </div>

         <div style="margin-bottom:14px;">
            <label for="editDescription" style="display:block; margin-bottom:6px; font-weight: 600;">Deskripsi</label>
            <textarea id="editDescription" name="description" rows="3" style="width:100%; padding:10px; border-radius:8px; border:1px solid rgba(255,255,255,.2); background:#203729; color:#fff; resize: vertical; font-family: inherit; line-height: 1.4;"></textarea>
         </div>

         <div style="display:grid; grid-template-columns: 1fr 1fr; gap: 14px; margin-bottom: 14px;">
            <div>
               <label for="editStartDate" style="display:block; margin-bottom:6px; font-weight: 600;">Tanggal Mulai</label>
               <input id="editStartDate" name="start_date" type="datetime-local" required style="width:100%; padding:10px; border-radius:8px; border:1px solid rgba(255,255,255,.2); background:#203729; color:#fff;">
            </div>
            <div>
               <label for="editEndDate" style="display:block; margin-bottom:6px; font-weight: 600;">Tanggal Selesai</label>
               <input id="editEndDate" name="end_date" type="datetime-local" required style="width:100%; padding:10px; border-radius:8px; border:1px solid rgba(255,255,255,.2); background:#203729; color:#fff;">
            </div>
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

         <div style="display:flex; gap:10px; justify-content:space-between; border-top: 1px solid rgba(255,255,255,0.1); padding-top: 15px;">
            <button type="button" id="deleteBtn" style="padding:10px 18px; border-radius:8px; border:1px solid #b84141; background:#3a1616; color:#ffd1d1; cursor: pointer; font-weight: 600;">Hapus</button>
            <div style="display:flex; gap:10px;">
               <button type="button" id="closeModalBtn" style="padding:10px 18px; border-radius:8px; border:1px solid rgba(255,255,255,.25); background:transparent; color:#fff; cursor: pointer;">Batal</button>
               <button type="submit" style="padding:10px 18px; border-radius:8px; border:none; background:#d4b15a; color:#102417; font-weight:700; cursor: pointer;">Simpan Perubahan</button>
            </div>
         </div>
      </form>
   </div>
</div>

<!-- Add Modal -->
<div id="addModal" style="display:none; position:fixed; inset:0; background:rgba(0,0,0,.65); z-index:9999; align-items:center; justify-content:center; backdrop-filter: blur(4px);">
   <div style="width:min(640px, 92vw); background:#102417; color:#fff; border:1px solid rgba(255,255,255,.2); border-radius:16px; padding:24px; box-shadow: 0 10px 25px rgba(0,0,0,0.5);">
      <h3 style="margin:0 0 18px; font-size: 1.5rem; color:#d4b15a; border-bottom: 1px solid rgba(255,255,255,0.1); padding-bottom: 10px;">Tambah Promosi</h3>
      <form method="post" action="{{ url('settings/create_promotion') }}">
         <input type="hidden" name="image_url" id="addImgUrl" value="">

         <div style="margin-bottom:14px;">
            <label for="addName" style="display:block; margin-bottom:6px; font-weight: 600;">Nama Promosi</label>
            <input id="addName" name="name" type="text" required style="width:100%; padding:10px; border-radius:8px; border:1px solid rgba(255,255,255,.2); background:#203729; color:#fff;">
         </div>

         <div style="margin-bottom:14px;">
            <label for="addDescription" style="display:block; margin-bottom:6px; font-weight: 600;">Deskripsi</label>
            <textarea id="addDescription" name="description" rows="3" style="width:100%; padding:10px; border-radius:8px; border:1px solid rgba(255,255,255,.2); background:#203729; color:#fff; resize: vertical; font-family: inherit; line-height: 1.4;"></textarea>
         </div>

         <div style="display:grid; grid-template-columns: 1fr 1fr; gap: 14px; margin-bottom: 14px;">
            <div>
               <label for="addStartDate" style="display:block; margin-bottom:6px; font-weight: 600;">Tanggal Mulai</label>
               <input id="addStartDate" name="start_date" type="datetime-local" required style="width:100%; padding:10px; border-radius:8px; border:1px solid rgba(255,255,255,.2); background:#203729; color:#fff;">
            </div>
            <div>
               <label for="addEndDate" style="display:block; margin-bottom:6px; font-weight: 600;">Tanggal Selesai</label>
               <input id="addEndDate" name="end_date" type="datetime-local" required style="width:100%; padding:10px; border-radius:8px; border:1px solid rgba(255,255,255,.2); background:#203729; color:#fff;">
            </div>
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

<!-- Delete Form -->
<form id="deleteForm" method="post" action="{{ url('settings/delete_promotion') }}" style="display:none;">
   <input type="hidden" name="id" id="deleteId">
</form>

<script>
(function () {
   const editModal = document.getElementById('editModal');
   const addModal = document.getElementById('addModal');
   const addBtn = document.getElementById('addBtn');
   const closeModalBtn = document.getElementById('closeModalBtn');
   const closeAddModalBtn = document.getElementById('closeAddModalBtn');
   const deleteBtn = document.getElementById('deleteBtn');
   const deleteForm = document.getElementById('deleteForm');
   const deleteId = document.getElementById('deleteId');

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

   const tableBody = document.getElementById('promoTableBody');
   if (tableBody) {
      tableBody.addEventListener('click', function (event) {
         const row = event.target.closest('.promo-row-editable');
         if (!row) return;

         document.getElementById('editId').value = row.dataset.id || '';
         document.getElementById('editName').value = row.dataset.name || '';
         document.getElementById('editDescription').value = row.dataset.description || '';
         document.getElementById('editStartDate').value = row.dataset.startDate || '';
         document.getElementById('editEndDate').value = row.dataset.endDate || '';
         document.getElementById('editIsActive').value = row.dataset.isActive || '1';
         document.getElementById('editImgUrl').value = '';

         const fullUrl = row.dataset.imageUrlFull || '';
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

   if (deleteBtn) {
      deleteBtn.addEventListener('click', function() {
         const id = document.getElementById('editId').value;
         if (id && confirm('Apakah Anda yakin ingin menghapus promosi ini?')) {
            deleteId.value = id;
            deleteForm.submit();
         }
      });
   }

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
         const metaResp = await fetch("{{ url('settings/save_extension_promotions') }}", {
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

            const resp = await fetch("{{ url('settings/chunk_upload_promotions') }}", {
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
         alert('Pilih gambar promosi terlebih dahulu.');
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
