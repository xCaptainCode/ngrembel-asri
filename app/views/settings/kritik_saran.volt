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
</style>

<section style="padding: 120px 5% 60px; min-height: 70vh;">
   <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 24px; flex-wrap: wrap; gap: 16px;">
      <div>
         <h1 style="margin: 0 0 4px 0; font-family: 'Cormorant Garamond', serif; font-size: clamp(2rem, 5vw, 3rem); font-weight: 400;">Settings - Kritik & Saran</h1>
         <p style="margin: 0; opacity: 0.85;">Klik pada baris tabel untuk menanggapi dan mengelola publikasi kritik & saran</p>
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
})();
</script>
