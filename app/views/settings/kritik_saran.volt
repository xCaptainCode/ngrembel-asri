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
   .badge-active {
      background: rgba(92, 170, 120, 0.15);
      color: #5caa78;
      border: 1px solid rgba(92, 170, 120, 0.35);
      padding: 4px 8px;
      border-radius: 6px;
      font-size: 0.8rem;
      font-weight: 700;
   }
   .badge-inactive {
      background: rgba(184, 65, 65, 0.15);
      color: #ffd1d1;
      border: 1px solid rgba(184, 65, 65, 0.35);
      padding: 4px 8px;
      border-radius: 6px;
      font-size: 0.8rem;
      font-weight: 700;
   }
   .badge-role-kritik {
      background: rgba(224, 94, 94, 0.15);
      color: #ffd1d1;
      border: 1px solid rgba(224, 94, 94, 0.35);
      padding: 4px 8px;
      border-radius: 16px;
      font-size: 0.8rem;
      font-weight: 700;
      letter-spacing: 0.4px;
   }
   .badge-role-saran {
      background: rgba(92, 170, 120, 0.15);
      color: #c9f7d8;
      border: 1px solid rgba(92, 170, 120, 0.35);
      padding: 4px 8px;
      border-radius: 16px;
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
   <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 24px; flex-wrap: wrap; gap: 16px;">
      <div>
         <h1 style="margin: 0 0 4px 0; font-family: 'Cormorant Garamond', serif; font-size: clamp(2rem, 5vw, 3rem); font-weight: 400;">Settings - Kritik & Saran</h1>
         <p style="margin: 0; opacity: 0.85;">Klik pada baris tabel untuk menanggapi dan mengelola publikasi kritik & saran</p>
         <form id="searchForm" method="GET" style="display:flex; gap:8px; align-items:center; flex-wrap:wrap; margin-top:12px;">
            <input type="text" name="search" id="search" placeholder="Cari Kritik / Saran..." value="{{ search }}" style="padding:8px 100px; border-radius:6px; border:1px solid rgba(255,255,255,0.2); background:rgba(255,255,255,0.04); color:#fff; font-family: 'Jost', sans-serif;" />
            <button type="submit" class="btn-cari">Cari</button>
            {% if search is not empty %}
            <a href="{{ url('settings/kritik_saran') }}" class="btn-reset">Reset</a>
            {% endif %}
         </form>
      </div>
   </div>

   {% if updateSuccess %}
   <div style="padding:12px 16px; border:1px solid #2a9d52; background:#11361f; color:#c9f7d8; border-radius:10px; margin-bottom:18px; font-weight: 500;">
      {{ updateSuccess }}
   </div>
   {% endif %}

   {% if updateError %}
   <div style="padding:12px 16px; border:1px solid #b84141; background:#3a1616; color:#ffd1d1; border-radius:10px; margin-bottom:18px; font-weight: 500;">
      {{ updateError }}
   </div>
   {% endif %}

   {% if items is empty %}
   <div style="background: rgba(16, 36, 23, 0.6); border: 1px solid rgba(255,255,255,0.1); border-radius: 12px; padding: 30px; text-align: center;">
      <p style="margin: 0; opacity: 0.7;">Belum ada data kritik dan saran.</p>
   </div>
   {% else %}
   <div class="table-responsive" style="overflow-x: auto; background: rgba(16, 36, 23, 0.6); border: 1px solid rgba(255,255,255,0.1); border-radius: 12px; padding: 10px;">
      <div style="margin-bottom:8px; color:#e8cc7a; font-size:0.9rem;">
         Menampilkan {{ ((currentPage - 1) * perPage) + 1 }} – {{ ((currentPage - 1) * perPage) + items|length }} dari {{ totalData }} data
      </div>
      <table class="table table-sm text-white" style="width:100%; border-collapse: collapse; min-width: 900px;">
         <thead>
            <tr style="background: rgba(0,0,0,0.25);">
               <th style="text-align:left; padding:14px 12px; border-bottom:2px solid rgba(255,255,255,.15); width: 140px;">Tgl Masuk</th>
               <th style="text-align:left; padding:14px 12px; border-bottom:2px solid rgba(255,255,255,.15); width: 150px;">Nama</th>
               <th style="text-align:center; padding:14px 12px; border-bottom:2px solid rgba(255,255,255,.15); width: 100px;">Tipe</th>
               <th style="text-align:left; padding:14px 12px; border-bottom:2px solid rgba(255,255,255,.15);">Kritik / Saran</th>
               <th style="text-align:left; padding:14px 12px; border-bottom:2px solid rgba(255,255,255,.15);">Tanggapan Admin</th>
               <th style="text-align:center; padding:14px 12px; border-bottom:2px solid rgba(255,255,255,.15); width: 140px;">Status</th>
               <th style="text-align:left; padding:14px 12px; border-bottom:2px solid rgba(255,255,255,.15); width: 140px;">Direspon Oleh</th>
            </tr>
         </thead>
         <tbody id="krisaTableBody">
            {% for item in items %}
            <tr class="settings-row-editable"
                data-id="{{ item['id'] }}"
                data-nama="{{ item['nama'] }}"
                data-type="{{ item['type'] }}"
                data-kritik-saran="{{ item['kritik_saran'] }}"
                data-response="{{ item['response'] }}"
                data-is-published="{{ item['is_published'] ? '1' : '0' }}">
               <td style="padding:14px 12px; border-bottom:1px solid rgba(255,255,255,.08); font-size: 0.85rem; opacity: 0.8;">
                  {{ Helpers.formatDateTime(item['created_at'], 'd M Y - H:i') }}
               </td>
               <td style="padding:14px 12px; border-bottom:1px solid rgba(255,255,255,.08); font-weight: 600;">{{ item['nama'] }}</td>
               <td style="padding:14px 12px; border-bottom:1px solid rgba(255,255,255,.08); text-align: center;">
                  {% if item['type'] == 'kritik' %}
                     <span class="badge-role-kritik">KRITIK</span>
                  {% else %}
                     <span class="badge-role-saran">SARAN</span>
                  {% endif %}
               </td>
               <td style="padding:14px 12px; border-bottom:1px solid rgba(255,255,255,.08); font-size: 0.9rem; max-width: 250px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; opacity: 0.9;">
                  {{ item['kritik_saran'] }}
               </td>
               <td style="padding:14px 12px; border-bottom:1px solid rgba(255,255,255,.08); font-size: 0.9rem; max-width: 250px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; color: #e8cc7a; font-style: italic;">
                  {{ item['response'] ? item['response'] : '-' }}
               </td>
               <td style="padding:14px 12px; border-bottom:1px solid rgba(255,255,255,.08); text-align: center;">
                  {% if item['is_published'] %}
                     <span class="badge-active">TAMPIL</span>
                  {% else %}
                     <span class="badge-inactive">DISEMBUNYIKAN</span>
                  {% endif %}
               </td>
               <td style="padding:14px 12px; border-bottom:1px solid rgba(255,255,255,.08); font-size: 0.85rem; opacity: 0.8;">
                  {{ item['admin_nama'] ? item['admin_nama'] : '-' }}
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
            <a href="{{ url('settings/kritik_saran') }}?{{ http_build_query({'search': search, 'page': prevPage, 'per_page': perPage}) }}"
               class="pagination-link">Previous</a>
         {% endif %}
         
         {% for i in 1..totalPages %}
            {% if i == currentPage %}
               <span class="pagination-link active">{{ i }}</span>
            {% else %}
               <a href="{{ url('settings/kritik_saran') }}?{{ http_build_query({'search': search, 'page': i, 'per_page': perPage}) }}"
                  class="pagination-link">{{ i }}</a>
            {% endif %}
         {% endfor %}
         
         {% if currentPage == totalPages %}
            <span class="pagination-link disabled">Next</span>
         {% else %}
            <a href="{{ url('settings/kritik_saran') }}?{{ http_build_query({'search': search, 'page': nextPage, 'per_page': perPage}) }}"
               class="pagination-link">Next</a>
         {% endif %}
      </div>
   {% endif %}
</section>

<!-- MODAL EDIT TANGGAPAN / STATUS KRITIK SARAN -->
<div id="krisaModal" style="display:none; position:fixed; inset:0; background:rgba(0,0,0,.65); z-index:9999; align-items:center; justify-content:center; backdrop-filter: blur(4px);">
   <div style="width:min(640px, 92vw); background:#102417; color:#fff; border:1px solid rgba(255,255,255,.2); border-radius:16px; padding:24px; box-shadow: 0 10px 25px rgba(0,0,0,0.5);">
      <h3 style="margin:0 0 18px; font-size: 1.5rem; color:#d4b15a; border-bottom: 1px solid rgba(255,255,255,0.1); padding-bottom: 10px; font-family: 'Cormorant Garamond', serif;">Kelola Kritik & Saran</h3>
      <form method="post" action="{{ url('settings/update_kritik_saran') }}" id="krisaForm">
         <input type="hidden" name="id" id="formId">

         <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 14px; margin-bottom: 14px;">
            <div>
               <label style="display:block; margin-bottom:6px; font-weight: 600; font-size: 0.85rem; letter-spacing: 0.5px; opacity: 0.8;">PENGIRIM</label>
               <input id="formNama" type="text" readonly style="width:100%; padding:10px; border-radius:8px; border:1px solid rgba(255,255,255,.15); background:rgba(255,255,255,0.04); color:rgba(255,255,255,0.75);">
            </div>
            <div>
               <label style="display:block; margin-bottom:6px; font-weight: 600; font-size: 0.85rem; letter-spacing: 0.5px; opacity: 0.8;">JENIS MASUKAN</label>
               <input id="formType" type="text" readonly style="width:100%; padding:10px; border-radius:8px; border:1px solid rgba(255,255,255,.15); background:rgba(255,255,255,0.04); color:rgba(255,255,255,0.75); text-transform: uppercase;">
            </div>
         </div>

         <div style="margin-bottom:14px;">
            <label style="display:block; margin-bottom:6px; font-weight: 600; font-size: 0.85rem; letter-spacing: 0.5px; opacity: 0.8;">ISI KRITIK & SARAN</label>
            <textarea id="formIsi" readonly style="width:100%; padding:10px; border-radius:8px; border:1px solid rgba(255,255,255,.15); background:rgba(255,255,255,0.04); color:rgba(255,255,255,0.85); min-height: 100px; resize: vertical; font-family: 'Jost', sans-serif; font-size: 0.95rem;"></textarea>
         </div>

         <div style="margin-bottom:14px;">
            <label for="formResponse" style="display:block; margin-bottom:6px; font-weight: 600; font-size: 0.85rem; letter-spacing: 0.5px; color: var(--gold2);">TANGGAPAN / JAWABAN ADMINISTRATOR</label>
            <textarea id="formResponse" name="response" style="width:100%; padding:10px; border-radius:8px; border:1px solid rgba(255,255,255,.2); background:#203729; color:#fff; min-height: 100px; resize: vertical; font-family: 'Jost', sans-serif; font-size: 0.95rem;" placeholder="Tulis tanggapan atau jawaban resmi di sini..."></textarea>
         </div>

         <div style="margin-bottom:18px;">
            <label for="formIsPublished" style="display:block; margin-bottom:6px; font-weight: 600; font-size: 0.85rem; letter-spacing: 0.5px;">STATUS PUBLIKASI</label>
            <select id="formIsPublished" name="is_published" required style="width:100%; padding:10px; border-radius:8px; border:1px solid rgba(255,255,255,.2); background:#203729; color:#fff; cursor: pointer; font-family: 'Jost', sans-serif;">
               <option value="1">TAMPILKAN (DAPAT DILIHAT PUBLIK)</option>
               <option value="0">SEMBUNYIKAN (ARSIP ADMIN)</option>
            </select>
         </div>

         <div style="display:flex; gap:10px; justify-content:flex-end; border-top: 1px solid rgba(255,255,255,0.1); padding-top: 15px;">
            <button type="button" id="closeKrisaModalBtn" style="padding:10px 18px; border-radius:8px; border:1px solid rgba(255,255,255,.25); background:transparent; color:#fff; cursor: pointer;">Batal</button>
            <button type="submit" style="padding:10px 18px; border-radius:8px; border:none; background:#d4b15a; color:#102417; font-weight:700; cursor: pointer;">Simpan</button>
         </div>
      </form>
   </div>
</div>

<script>
(function () {
   const modal = document.getElementById('krisaModal');
   const closeBtn = document.getElementById('closeKrisaModalBtn');
   const tableBody = document.getElementById('krisaTableBody');

   const formId = document.getElementById('formId');
   const formNama = document.getElementById('formNama');
   const formType = document.getElementById('formType');
   const formIsi = document.getElementById('formIsi');
   const formResponse = document.getElementById('formResponse');
   const formIsPublished = document.getElementById('formIsPublished');

   function openModalForEdit(row) {
      formId.value = row.dataset.id || '';
      formNama.value = row.dataset.nama || '';
      formType.value = row.dataset.type || '';
      formIsi.value = row.dataset.kritikSaran || '';
      formResponse.value = row.dataset.response || '';
      formIsPublished.value = row.dataset.isPublished || '1';

      modal.style.display = 'flex';
      
      // Auto focus to response textarea
      setTimeout(() => {
         formResponse.focus();
      }, 50);
   }

   function closeModal() {
      modal.style.display = 'none';
   }

   if (tableBody) {
      tableBody.addEventListener('click', function (event) {
         const row = event.target.closest('.settings-row-editable');
         if (!row) return;
         openModalForEdit(row);
      });
   }

   if (closeBtn) {
      closeBtn.addEventListener('click', closeModal);
   }

   window.addEventListener('click', function (event) {
      if (event.target === modal) {
         closeModal();
      }
   });

   // set btn F2 to focus search input
   document.addEventListener('keydown', function (event) {
      if (event.key === 'F2') {
         event.preventDefault();
         document.getElementById('search').focus();
      }

      if (event.key === 'Escape') {
         closeModal();
      }
   });
})();
</script>
