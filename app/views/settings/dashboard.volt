<style>
   .dashboard-row-readonly {
      cursor: default;
   }

   .dashboard-row-editable {
      cursor: pointer;
   }
</style>

<section style="padding: 120px 5% 60px; min-height: 70vh;">
   <h1 style="margin-bottom: 12px;">Settings - Dashboard</h1>
   <p style="margin-bottom: 16px;">Klik salah satu baris untuk edit value.</p>

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
   <p>Data dashboard belum tersedia.</p>
   {% else %}
   {% set hiddenColumns = ['id', 'created_at', 'created_by', 'updated_by', 'created_by_nama' ] %}
   {% set readonlyColumns = ['updated_at', 'created_by_nama', 'updated_by_nama'] %}
   <div class="table-responsive">
      <table class="table table-sm table-striped text-white" style="width:100%; border-collapse: collapse;">
         <thead>
            <tr>
               <th style="text-align:left; padding:10px; border-bottom:1px solid rgba(255,255,255,.2);">Kolom</th>
               <th style="text-align:left; padding:10px; border-bottom:1px solid rgba(255,255,255,.2);">Value</th>
            </tr>
         </thead>
         <tbody id="dashboardTableBody">
            {% for key, value in dashboard %}
            {% if key not in hiddenColumns %}
            <tr class="{{ key in readonlyColumns ? 'dashboard-row-readonly' : 'dashboard-row-editable' }}"
               {% if key not in readonlyColumns %}
               data-editable="1"
               data-id="{{ dashboard['id'] }}"
               data-column="{{ key }}"
               data-value="{{ (value is null ? '' : value) }}"
               {% endif %}
               >
               <td style="padding:10px; border-bottom:1px solid rgba(255,255,255,.08);">{{ key }}</td>
               <td style="padding:10px; border-bottom:1px solid rgba(255,255,255,.08);">
                  {% if value is null or value == '' %}
                  <em style="opacity:.6;">(kosong)</em>
                  {% else %}
                  {{ value }}
                  {% endif %}
               </td>
            </tr>
            {% endif %}
            {% endfor %}
         </tbody>
      </table>
   </div>
   {% endif %}
</section>

<div id="editModal" style="display:none; position:fixed; inset:0; background:rgba(0,0,0,.55); z-index:9999; align-items:center; justify-content:center;">
   <div style="width:min(620px, 92vw); background:#102417; color:#fff; border:1px solid rgba(255,255,255,.2); border-radius:12px; padding:18px;">
      <h3 style="margin:0 0 10px;">Edit Dashboard Field</h3>
      <form method="post" action="{{ url('settings/update_dashboard') }}" enctype="multipart/form-data">
         <input type="hidden" name="MAX_FILE_SIZE" value="5242880">
         <input type="hidden" name="id" id="editId">
         <input type="hidden" name="column" id="editColumn">
         <div style="margin-bottom:12px;">
            <label for="editColumnLabel" style="display:block; margin-bottom:6px;">Kolom</label>
            <input id="editColumnLabel" type="text" readonly style="width:100%; padding:10px; border-radius:8px; border:1px solid rgba(255,255,255,.2); background:#203729; color:#fff;">
         </div>
         <div id="valueInputWrap" style="margin-bottom:14px;">
            <label for="editValue" style="display:block; margin-bottom:6px;">Value</label>
            <textarea name="value" id="editValue" rows="6" style="width:100%; padding:10px; border-radius:8px; border:1px solid rgba(255,255,255,.2); background:#203729; color:#fff;"></textarea>
         </div>
         <div id="imageInputWrap" style="display:none; margin-bottom:14px;">
            <label for="editImage" style="display:block; margin-bottom:6px;">Upload Gambar (Maks 5MB)</label>
            <input type="file" name="image_file" id="editImage" accept="image/*" style="width:100%; padding:10px; border-radius:8px; border:1px solid rgba(255,255,255,.2); background:#203729; color:#fff;">
         </div>
         <div style="display:flex; gap:8px; justify-content:flex-end;">
            <button type="button" id="closeModalBtn" style="padding:8px 14px; border-radius:8px; border:1px solid rgba(255,255,255,.25); background:transparent; color:#fff;">Batal</button>
            <button type="submit" style="padding:8px 14px; border-radius:8px; border:none; background:#d4b15a; color:#102417; font-weight:700;">Simpan</button>
         </div>
      </form>
   </div>
</div>

<script>
   (function () {
      const modal = document.getElementById('editModal');
      const closeModalBtn = document.getElementById('closeModalBtn');
      const editId = document.getElementById('editId');
      const editColumn = document.getElementById('editColumn');
      const editColumnLabel = document.getElementById('editColumnLabel');
      const editValue = document.getElementById('editValue');
      const editImage = document.getElementById('editImage');
      const valueInputWrap = document.getElementById('valueInputWrap');
      const imageInputWrap = document.getElementById('imageInputWrap');
      const imageColumns = ['sejarah_img_url', 'slide_img_1', 'slide_img_2', 'slide_img_3', 'slide_img_4', 'slide_img_5'];

      const tableBody = document.getElementById('dashboardTableBody');

      function closeModal() {
         modal.style.display = 'none';
      }

      if (tableBody) {
         tableBody.addEventListener('click', function (event) {
            const row = event.target.closest('tr[data-editable="1"]');
            if (!row) {
               return;
            }

            editId.value = row.dataset.id || '';
            editColumn.value = row.dataset.column || '';
            editColumnLabel.value = row.dataset.column || '';
            editValue.value = row.dataset.value || '';
            if (imageColumns.includes(row.dataset.column || '')) {
               valueInputWrap.style.display = 'none';
               imageInputWrap.style.display = 'block';
               editValue.value = '';
            } else {
               valueInputWrap.style.display = 'block';
               imageInputWrap.style.display = 'none';
               if (editImage) editImage.value = '';
            }
            modal.style.display = 'flex';
         });
      }

      if (closeModalBtn) {
         closeModalBtn.addEventListener('click', closeModal);
      }

      if (modal) {
         modal.addEventListener('click', function (e) {
            if (e.target === modal) {
               closeModal();
            }
         });
      }

      if (editImage) {
         editImage.addEventListener('change', function () {
            const maxBytes = 5 * 1024 * 1024;
            const file = editImage.files && editImage.files[0] ? editImage.files[0] : null;
            if (file && file.size > maxBytes) {
               alert('Ukuran file maksimal 5MB.');
               editImage.value = '';
            }
         });
      }
   })();
</script>
