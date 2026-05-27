<style>
   .settings-row-editable {
      cursor: pointer;
      transition: background 0.2s ease-in-out;
   }
   .settings-row-editable:hover {
      background: rgba(255, 255, 255, 0.05) !important;
   }
   .table th, .table td {
      vertical-align: middle;
   }
   .badge-type {
      background: rgba(212, 177, 90, 0.15);
      color: #d4b15a;
      border: 1px solid rgba(212, 177, 90, 0.35);
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
   <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; flex-wrap: wrap; gap: 12px;">
      <div>
         <h1
            style="margin: 0 0 4px 0; font-family: 'Cormorant Garamond', serif; font-size: clamp(2rem, 5vw, 3rem); font-weight: 400;">Settings - Dashboard</h1>
         <p style="margin: 0;">Klik pada baris tabel untuk edit data</p>
         <form id="searchForm" method="GET"
            style="display:flex; gap:8px; align-items:center; flex-wrap:wrap; margin-top:12px;">
            <input type="text" name="search" placeholder="Cari Satwa..." value="{{ search }}"
               style="padding:8px 100px; border-radius:6px; border:1px solid rgba(255,255,255,0.2); background:rgba(255,255,255,0.04); color:#fff; font-family: 'Jost', sans-serif;" />
            <button type="submit" class="btn-cari">Cari</button>
            {% if search is not empty %}
            <a href="{{ url('settings/dashboard') }}" class="btn-reset">Reset</a>
            {% endif %}
         </form>
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

   {% if dashboard is empty %}
   <p>Data settings belum tersedia.</p>
   {% else %}
   <div class="table-responsive" style="overflow-x: auto; background: rgba(16, 36, 23, 0.6); border: 1px solid rgba(255,255,255,0.1); border-radius: 12px; padding: 10px;">
      <div style="margin-bottom:8px; color:#e8cc7a; font-size:0.9rem;">
         Menampilkan {{ ((currentPage - 1) * perPage) + 1 }} – {{ ((currentPage - 1) * perPage) + dashboard|length }} dari
         {{ totalData }} data
      </div>
      <table class="table table-sm text-white" style="width:100%; border-collapse: collapse;">
         <thead>
            <tr style="background: rgba(0,0,0,0.2);">
               <th style="text-align:left; padding:12px 10px; border-bottom:2px solid rgba(255,255,255,.15);">Nama</th>
               <th style="text-align:center; padding:12px 10px; border-bottom:2px solid rgba(255,255,255,.15);">Tipe</th>
               <th style="text-align:left; padding:12px 10px; border-bottom:2px solid rgba(255,255,255,.15);">Nilai</th>
               <th style="text-align:left; padding:12px 10px; border-bottom:2px solid rgba(255,255,255,.15);">Updated At</th>
            </tr>
         </thead>
         <tbody id="settingsTableBody">
            {% for item in dashboard %}
            <tr class="settings-row-editable"
                data-id="{{ item['id'] }}"
                data-name="{{ item['name'] }}"
                data-type-value="{{ item['type_value'] }}"
                data-value="{{ item['value'] }}"
                data-value-url="{{ item['value'] ? url(item['value']) : '' }}">
               <td style="padding:12px 10px; border-bottom:1px solid rgba(255,255,255,.08); font-weight: 600; color: #d4b15a;">{{ item['name'] }}</td>
               <td style="padding:12px 10px; border-bottom:1px solid rgba(255,255,255,.08); text-align: center;"><span class="badge-type">{{ item['type_value'] }}</span></td>
               <td style="padding:12px 10px; border-bottom:1px solid rgba(255,255,255,.08); font-size: 0.9rem; opacity: 0.9; line-height: 1.4;">
                  {% if item['type_value'] == 'FOTO' %}
                     {% if item['value'] %}
                        <img src="{{ url(item['value']) }}" alt="{{ item['name'] }}" style="max-height:50px; max-width:100px; border-radius:6px; object-fit:cover; border:1px solid rgba(255,255,255,0.15);">
                        <div style="font-size:0.75rem; opacity:.75; margin-top:4px;">{{ item['value'] }}</div>
                     {% else %}
                        <em style="opacity:.5; font-size:0.9rem;">(tidak ada)</em>
                     {% endif %}
                  {% else %}
                     {{ item['value'] ? (item['value']|length > 120 ? item['value']|slice(0, 120) ~ '...' : item['value']) : '-' }}
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
   <!-- Pagination Controls -->
   <div style="display:flex; justify-content:center; align-items:center; margin-top:12px; gap:8px;">
      {% set prevPage = currentPage > 1 ? currentPage - 1 : 1 %}
      {% set nextPage = currentPage < totalPages ? currentPage + 1 : totalPages %}
      
      {% if currentPage == 1 %} 
         <span class="pagination-link disabled">Previous</span>
      {% else %}
         <a href="{{ url('settings/dashboard') }}?{{ http_build_query({'search': search, 'page': prevPage, 'per_page': perPage}) }}"
            class="pagination-link">Previous</a>
      {% endif %}
      
      {% for i in 1..totalPages %}
         {% if i == currentPage %}
            <span class="pagination-link active">{{ i }}</span>
         {% else %}
            <a href="{{ url('settings/dashboard') }}?{{ http_build_query({'search': search, 'page': i, 'per_page': perPage}) }}"
               class="pagination-link">{{ i }}</a>
         {% endif %}
      {% endfor %}
      
      {% if currentPage == totalPages %}
         <span class="pagination-link disabled">Next</span>
      {% else %}
         <a href="{{ url('settings/dashboard') }}?{{ http_build_query({'search': search, 'page': nextPage, 'per_page': perPage}) }}"
            class="pagination-link">Next</a>
      {% endif %}
   </div>
   {% endif %}
</section>

<div id="settingModal" style="display:none; position:fixed; inset:0; background:rgba(0,0,0,.65); z-index:9999; align-items:center; justify-content:center; backdrop-filter: blur(4px);">
   <div style="width:min(640px, 92vw); background:#102417; color:#fff; border:1px solid rgba(255,255,255,.2); border-radius:16px; padding:24px; box-shadow: 0 10px 25px rgba(0,0,0,0.5);">
      <h3 id="settingModalTitle" style="margin:0 0 18px; font-size: 1.5rem; color:#d4b15a; border-bottom: 1px solid rgba(255,255,255,0.1); padding-bottom: 10px;">Edit Setting</h3>
      <form method="post" action="{{ url('settings/update_dashboard') }}" enctype="multipart/form-data" id="settingForm">
         <input type="hidden" name="id" id="formId">

         <div style="margin-bottom:14px;">
            <label for="formName" style="display:block; margin-bottom:6px; font-weight: 600;">Nama Setting</label>
            <input id="formName" name="name" type="text" required style="width:100%; padding:10px; border-radius:8px; border:1px solid rgba(255,255,255,.2); background:#203729; color:#fff;">
         </div>

         <div style="margin-bottom:14px;">
            <label for="formType" style="display:block; margin-bottom:6px; font-weight: 600;">Tipe Value</label>
            <select id="formType" name="type_value" required style="width:100%; padding:10px; border-radius:8px; border:1px solid rgba(255,255,255,.2); background:#203729; color:#fff; cursor: pointer;">
               <option value="TEXT">TEXT</option>
               <option value="FOTO">FOTO</option>
               <option value="VIDEO">VIDEO</option>
            </select>
         </div>

         <div id="textValueContainer" style="margin-bottom:14px;">
            <label for="formValue" style="display:block; margin-bottom:6px; font-weight: 600;">Value</label>
            <textarea id="formValue" name="value" rows="4" style="width:100%; padding:10px; border-radius:8px; border:1px solid rgba(255,255,255,.2); background:#203729; color:#fff; resize: vertical; font-family: inherit; line-height: 1.4;"></textarea>
         </div>

         <div id="imageValueContainer" style="margin-bottom:14px; display:none;">
            <label style="display:block; margin-bottom:6px; font-weight: 600;">Gambar Saat Ini</label>
            <div style="margin-bottom: 8px;">
               <img id="imagePreview" src="" alt="Preview" style="max-height:120px; border-radius:8px; display:none; border:1px solid rgba(255,255,255,0.2);">
               <span id="noImageText" style="font-style: italic; opacity: 0.6; display: none;">Tidak ada gambar</span>
            </div>
            <label for="formImage" style="display:block; margin-bottom:6px; font-weight: 600;">Upload Gambar (Maks 5MB)</label>
            <input type="file" id="formImage" name="image_file" accept="image/*" style="width:100%; padding:8px; border-radius:8px; border:1px solid rgba(255,255,255,.2); background:#203729; color:#fff;">
            <p style="margin:6px 0 0; font-size: 0.8rem; opacity: 0.7;">Untuk edit data FOTO, upload kosong berarti memakai gambar lama.</p>
         </div>

         <div style="display:flex; gap:10px; justify-content:flex-end; border-top: 1px solid rgba(255,255,255,0.1); padding-top: 15px;">
            <button type="button" id="closeModalBtn" style="padding:10px 18px; border-radius:8px; border:1px solid rgba(255,255,255,.25); background:transparent; color:#fff; cursor: pointer;">Batal</button>
            <button type="submit" style="padding:10px 18px; border-radius:8px; border:none; background:#d4b15a; color:#102417; font-weight:700; cursor: pointer;">Simpan</button>
         </div>
      </form>
   </div>
</div>

<script>
(function () {
   const modal = document.getElementById('settingModal');
   const addBtn = document.getElementById('addBtn');
   const closeModalBtn = document.getElementById('closeModalBtn');
   const tableBody = document.getElementById('settingsTableBody');

   const modalTitle = document.getElementById('settingModalTitle');
   const formId = document.getElementById('formId');
   const formName = document.getElementById('formName');
   const formType = document.getElementById('formType');
   const formValue = document.getElementById('formValue');
   const formImage = document.getElementById('formImage');

   const textValueContainer = document.getElementById('textValueContainer');
   const imageValueContainer = document.getElementById('imageValueContainer');
   const imagePreview = document.getElementById('imagePreview');
   const noImageText = document.getElementById('noImageText');

   function syncValueFieldByType() {
      const isFoto = formType.value === 'FOTO';
      textValueContainer.style.display = isFoto ? 'none' : 'block';
      imageValueContainer.style.display = isFoto ? 'block' : 'none';
   }

   function openModalForCreate() {
      modalTitle.textContent = 'Tambah Setting';
      formId.value = '';
      formName.value = '';
      formType.value = 'TEXT';
      formValue.value = '';
      formImage.value = '';
      imagePreview.src = '';
      imagePreview.style.display = 'none';
      noImageText.style.display = 'none';
      syncValueFieldByType();
      modal.style.display = 'flex';
   }

   function openModalForEdit(row) {
      modalTitle.textContent = 'Edit Setting';
      formId.value = row.dataset.id || '';
      formName.value = row.dataset.name || '';
      formType.value = row.dataset.typeValue || 'TEXT';
      formValue.value = row.dataset.value || '';
      formImage.value = '';

      if (formType.value === 'FOTO') {
         const fullUrl = row.dataset.valueUrl || '';
         if (fullUrl) {
            imagePreview.src = fullUrl;
            imagePreview.style.display = 'block';
            noImageText.style.display = 'none';
         } else {
            imagePreview.src = '';
            imagePreview.style.display = 'none';
            noImageText.style.display = 'inline';
         }
      } else {
         imagePreview.src = '';
         imagePreview.style.display = 'none';
         noImageText.style.display = 'none';
      }

      syncValueFieldByType();
      modal.style.display = 'flex';
   }

   function closeModal() {
      modal.style.display = 'none';
   }

   if (addBtn) {
      addBtn.addEventListener('click', openModalForCreate);
   }

   if (tableBody) {
      tableBody.addEventListener('click', function (event) {
         const row = event.target.closest('.settings-row-editable');
         if (!row) return;
         openModalForEdit(row);
      });
   }

   if (formType) {
      formType.addEventListener('change', syncValueFieldByType);
   }

   if (closeModalBtn) {
      closeModalBtn.addEventListener('click', closeModal);
   }

   window.addEventListener('click', function (event) {
      if (event.target === modal) {
         closeModal();
      }
   });
})();
</script>
