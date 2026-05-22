<style>
   .wahana-row-editable {
      cursor: pointer;
      transition: background 0.2s ease-in-out;
   }
   .wahana-row-editable:hover {
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
   .badge-free {
      background: rgba(42, 157, 143, 0.15);
      color: #2a9d8f;
      border: 1px solid rgba(42, 157, 143, 0.3);
      padding: 4px 8px;
      border-radius: 6px;
      font-size: 0.85rem;
      font-weight: 600;
   }
   .badge-paid {
      background: rgba(212, 177, 90, 0.15);
      color: #d4b15a;
      border: 1px solid rgba(212, 177, 90, 0.3);
      padding: 4px 8px;
      border-radius: 6px;
      font-size: 0.85rem;
      font-weight: 600;
   }
</style>

<section style="padding: 120px 5% 60px; min-height: 70vh;">
   <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; flex-wrap: wrap; gap: 12px;">
      <div>
         <h1 style="margin: 0 0 4px 0;">Settings - Fun Games</h1>
         <p style="margin: 0;">Klik pada baris tabel untuk meng-edit data wahana Fun Games.</p>
      </div>
      <div>
         <button type="button" id="addBtn" style="padding: 10px 20px; border-radius: 8px; border: none; background: #d4b15a; color: #102417; font-weight: 700; cursor: pointer; display: flex; align-items: center; gap: 6px; transition: all 0.2s; box-shadow: 0 4px 10px rgba(212, 177, 90, 0.2);">
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" style="vertical-align: middle;">
               <line x1="12" y1="5" x2="12" y2="19"></line>
               <line x1="5" y1="12" x2="19" y2="12"></line>
            </svg>
            Tambah Wahana Baru
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

   <div style="margin-bottom: 40px;">
      <h2 style="color: #d4b15a; margin-top: 0; margin-bottom: 16px; font-family: 'Cormorant Garamond', serif; font-size: 1.8rem; font-style: italic; border-bottom: 1px solid rgba(212,177,90,0.2); padding-bottom: 8px;">Daftar Wahana Fun Games</h2>
      
      {% if wahanaList is empty %}
      <p>Data Wahana Fun Games belum tersedia.</p>
      {% else %}
      <div class="table-responsive" style="overflow-x: auto; background: rgba(16, 36, 23, 0.6); border: 1px solid rgba(255,255,255,0.1); border-radius: 12px; padding: 10px;">
         <table class="table table-sm text-white" style="width:100%; border-collapse: collapse;">
            <thead>
               <tr style="background: rgba(0,0,0,0.2);">
                  <th style="text-align:left; padding:12px 10px; border-bottom:2px solid rgba(255,255,255,.15); width: 15%;">Nama</th>
                  <th style="text-align:left; padding:12px 10px; border-bottom:2px solid rgba(255,255,255,.15); width: 30%;">Deskripsi</th>
                  <th style="text-align:center; padding:12px 10px; border-bottom:2px solid rgba(255,255,255,.15); width: 10%;">Tipe</th>
                  <th style="text-align:right; padding:12px 10px; border-bottom:2px solid rgba(255,255,255,.15); width: 10%;">Harga Tiket</th>
                  <th style="text-align:center; padding:12px 10px; border-bottom:2px solid rgba(255,255,255,.15); width: 10%;">Gambar</th>
                  <th style="text-align:center; padding:12px 10px; border-bottom:2px solid rgba(255,255,255,.15); width: 5%;">Urutan</th>
                  <th style="text-align:center; padding:12px 10px; border-bottom:2px solid rgba(255,255,255,.15); width: 8%;">Status</th>
                  <th style="text-align:left; padding:12px 10px; border-bottom:2px solid rgba(255,255,255,.15); width: 12%;">Updated At</th>
               </tr>
            </thead>
            <tbody id="wahanaTableBody">
               {% for item in wahanaList %}
               <tr class="wahana-row-editable"
                   data-id="{{ item['id'] }}"
                   data-nama="{{ item['nama'] }}"
                   data-deskripsi="{{ item['deskripsi'] }}"
                   data-is-free="{{ item['is_free'] == 't' or item['is_free'] === true or item['is_free'] === '1' or item['is_free'] === 1 ? '1' : '0' }}"
                   data-harga-tiket="{{ item['harga_tiket'] }}"
                   data-urutan="{{ item['urutan'] }}"
                   data-is-active="{{ item['is_active'] == 't' or item['is_active'] === true or item['is_active'] === '1' or item['is_active'] === 1 ? '1' : '0' }}"
                   data-img-url="{{ item['img_url'] ? url(item['img_url']) : '' }}">
                  
                  <td style="padding:12px 10px; border-bottom:1px solid rgba(255,255,255,.08); font-weight: 600; color: #d4b15a;">
                     {{ item['nama'] }}
                  </td>
                  
                  <td style="padding:12px 10px; border-bottom:1px solid rgba(255,255,255,.08); font-size: 0.9rem; opacity: 0.9; line-height: 1.4;">
                     {{ item['deskripsi'] }}
                  </td>

                  <td style="padding:12px 10px; border-bottom:1px solid rgba(255,255,255,.08); text-align: center;">
                     {% if item['is_free'] == 't' or item['is_free'] === true or item['is_free'] === '1' or item['is_free'] === 1 %}
                        <span class="badge-free">Gratis</span>
                     {% else %}
                        <span class="badge-paid">Berbayar</span>
                     {% endif %}
                  </td>

                  <td style="padding:12px 10px; border-bottom:1px solid rgba(255,255,255,.08); text-align: right; font-family: monospace;">
                     Rp {{ item['harga_tiket'] }}
                  </td>
                  
                  <td style="padding:12px 10px; border-bottom:1px solid rgba(255,255,255,.08); text-align: center;">
                     {% if item['img_url'] %}
                        <img src="{{ url(item['img_url']) }}" alt="{{ item['nama'] }}" style="max-height:50px; max-width:80px; border-radius:6px; object-fit:cover; border:1px solid rgba(255,255,255,0.15);">
                     {% else %}
                        <em style="opacity:.5; font-size:0.9rem;">(tidak ada)</em>
                     {% endif %}
                  </td>
                  
                  <td style="padding:12px 10px; border-bottom:1px solid rgba(255,255,255,.08); text-align: center;">
                     {{ item['urutan'] }}
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
   </div>
</section>

<!-- EDIT MODAL -->
<div id="editModal" style="display:none; position:fixed; inset:0; background:rgba(0,0,0,.65); z-index:9999; align-items:center; justify-content:center; backdrop-filter: blur(4px);">
   <div style="width:min(600px, 92vw); background:#102417; color:#fff; border:1px solid rgba(255,255,255,.2); border-radius:16px; padding:24px; box-shadow: 0 10px 25px rgba(0,0,0,0.5);">
      <h3 style="margin:0 0 18px; font-size: 1.5rem; color:#d4b15a; border-bottom: 1px solid rgba(255,255,255,0.1); padding-bottom: 10px;">Edit Wahana Fun Game</h3>
      
      <form method="post" action="{{ url('settings/update_fun_game') }}" enctype="multipart/form-data">
         <input type="hidden" name="MAX_FILE_SIZE" value="5242880">
         <input type="hidden" name="id" id="editId">
         
         <div style="margin-bottom:14px;">
            <label for="editNama" style="display:block; margin-bottom:6px; font-weight: 600;">Nama Wahana</label>
            <input id="editNama" name="nama" type="text" required style="width:100%; padding:10px; border-radius:8px; border:1px solid rgba(255,255,255,.2); background:#203729; color:#fff;">
         </div>

         <div style="margin-bottom:14px;">
            <label for="editDeskripsi" style="display:block; margin-bottom:6px; font-weight: 600;">Deskripsi</label>
            <textarea id="editDeskripsi" name="deskripsi" rows="3" style="width:100%; padding:10px; border-radius:8px; border:1px solid rgba(255,255,255,.2); background:#203729; color:#fff; resize: vertical; font-family: inherit; line-height: 1.4;"></textarea>
         </div>

         <div style="margin-bottom:14px; display: flex; gap: 12px; flex-wrap: wrap;">
            <div style="flex: 1; min-width: 120px;">
               <label for="editIsFree" style="display:block; margin-bottom:6px; font-weight: 600;">Tipe Tiket</label>
               <select id="editIsFree" name="is_free" style="width:100%; padding:10px; border-radius:8px; border:1px solid rgba(255,255,255,.2); background:#203729; color:#fff; cursor: pointer;">
                  <option value="0">Berbayar</option>
                  <option value="1">Gratis</option>
               </select>
            </div>
            <div style="flex: 1; min-width: 120px;" id="editHargaTiketContainer">
               <label for="editHargaTiket" style="display:block; margin-bottom:6px; font-weight: 600;">Harga Tiket (Rp)</label>
               <input id="editHargaTiket" name="harga_tiket" type="number" min="0" style="width:100%; padding:10px; border-radius:8px; border:1px solid rgba(255,255,255,.2); background:#203729; color:#fff;">
            </div>
         </div>

         <div style="margin-bottom:14px; display: flex; gap: 12px;">
            <div style="flex: 1;">
               <label for="editUrutan" style="display:block; margin-bottom:6px; font-weight: 600;">Urutan</label>
               <input id="editUrutan" name="urutan" type="number" required min="1" style="width:100%; padding:10px; border-radius:8px; border:1px solid rgba(255,255,255,.2); background:#203729; color:#fff;">
            </div>
            <div style="flex: 1;">
               <label for="editIsActive" style="display:block; margin-bottom:6px; font-weight: 600;">Status Keaktifan</label>
               <select id="editIsActive" name="is_active" style="width:100%; padding:10px; border-radius:8px; border:1px solid rgba(255,255,255,.2); background:#203729; color:#fff; cursor: pointer;">
                  <option value="1">Aktif</option>
                  <option value="0">Tidak Aktif</option>
               </select>
            </div>
         </div>

         <div style="margin-bottom:18px;">
            <label style="display:block; margin-bottom:6px; font-weight: 600;">Gambar Saat Ini</label>
            <div id="currentImageContainer" style="margin-bottom: 8px;">
               <img id="editImagePreview" src="" alt="Preview" style="max-height:100px; border-radius:8px; display:none; border:1px solid rgba(255,255,255,0.2);">
               <span id="noImageText" style="font-style: italic; opacity: 0.6; display: none;">Tidak ada gambar</span>
            </div>
            <label for="editImage" style="display:block; margin-bottom:6px; font-weight: 600;">Upload Gambar Baru (Maks 5MB)</label>
            <input type="file" name="image_file" id="editImage" accept="image/*" style="width:100%; padding:8px; border-radius:8px; border:1px solid rgba(255,255,255,.2); background:#203729; color:#fff;">
         </div>

         <div style="display:flex; gap:10px; justify-content:flex-end; border-top: 1px solid rgba(255,255,255,0.1); padding-top: 15px;">
            <button type="button" id="closeModalBtn" style="padding:10px 18px; border-radius:8px; border:1px solid rgba(255,255,255,.25); background:transparent; color:#fff; cursor: pointer; transition: all 0.2s;">Batal</button>
            <button type="submit" style="padding:10px 18px; border-radius:8px; border:none; background:#d4b15a; color:#102417; font-weight:700; cursor: pointer; transition: all 0.2s;">Simpan Perubahan</button>
         </div>
      </form>
   </div>
</div>

<!-- ADD MODAL -->
<div id="addModal" style="display:none; position:fixed; inset:0; background:rgba(0,0,0,.65); z-index:9999; align-items:center; justify-content:center; backdrop-filter: blur(4px);">
   <div style="width:min(600px, 92vw); background:#102417; color:#fff; border:1px solid rgba(255,255,255,.2); border-radius:16px; padding:24px; box-shadow: 0 10px 25px rgba(0,0,0,0.5);">
      <h3 style="margin:0 0 18px; font-size: 1.5rem; color:#d4b15a; border-bottom: 1px solid rgba(255,255,255,0.1); padding-bottom: 10px;">Tambah Wahana Baru</h3>
      
      <form method="post" action="{{ url('settings/create_fun_game') }}" enctype="multipart/form-data">
         <input type="hidden" name="MAX_FILE_SIZE" value="5242880">
         
         <div style="margin-bottom:14px;">
            <label for="addNama" style="display:block; margin-bottom:6px; font-weight: 600;">Nama Wahana</label>
            <input id="addNama" name="nama" type="text" placeholder="Contoh: Flying Fox Mini" required style="width:100%; padding:10px; border-radius:8px; border:1px solid rgba(255,255,255,.2); background:#203729; color:#fff;">
         </div>

         <div style="margin-bottom:14px;">
            <label for="addDeskripsi" style="display:block; margin-bottom:6px; font-weight: 600;">Deskripsi</label>
            <textarea id="addDeskripsi" name="deskripsi" rows="3" placeholder="Deskripsikan wahana baru ini..." style="width:100%; padding:10px; border-radius:8px; border:1px solid rgba(255,255,255,.2); background:#203729; color:#fff; resize: vertical; font-family: inherit; line-height: 1.4;"></textarea>
         </div>

         <div style="margin-bottom:14px; display: flex; gap: 12px; flex-wrap: wrap;">
            <div style="flex: 1; min-width: 120px;">
               <label for="addIsFree" style="display:block; margin-bottom:6px; font-weight: 600;">Tipe Tiket</label>
               <select id="addIsFree" name="is_free" style="width:100%; padding:10px; border-radius:8px; border:1px solid rgba(255,255,255,.2); background:#203729; color:#fff; cursor: pointer;">
                  <option value="0" selected>Berbayar</option>
                  <option value="1">Gratis</option>
               </select>
            </div>
            <div style="flex: 1; min-width: 120px;" id="addHargaTiketContainer">
               <label for="addHargaTiket" style="display:block; margin-bottom:6px; font-weight: 600;">Harga Tiket (Rp)</label>
               <input id="addHargaTiket" name="harga_tiket" type="number" min="0" value="0" style="width:100%; padding:10px; border-radius:8px; border:1px solid rgba(255,255,255,.2); background:#203729; color:#fff;">
            </div>
         </div>

         <div style="margin-bottom:14px; display: flex; gap: 12px;">
            <div style="flex: 1;">
               <label for="addUrutan" style="display:block; margin-bottom:6px; font-weight: 600;">Urutan</label>
               <input id="addUrutan" name="urutan" type="number" required min="1" value="1" style="width:100%; padding:10px; border-radius:8px; border:1px solid rgba(255,255,255,.2); background:#203729; color:#fff;">
            </div>
            <div style="flex: 1;">
               <label for="addIsActive" style="display:block; margin-bottom:6px; font-weight: 600;">Status Keaktifan</label>
               <select id="addIsActive" name="is_active" style="width:100%; padding:10px; border-radius:8px; border:1px solid rgba(255,255,255,.2); background:#203729; color:#fff; cursor: pointer;">
                  <option value="1" selected>Aktif</option>
                  <option value="0">Tidak Aktif</option>
               </select>
            </div>
         </div>

         <div style="margin-bottom:18px;">
            <label for="addImage" style="display:block; margin-bottom:6px; font-weight: 600;">Upload Gambar (Maks 5MB)</label>
            <input type="file" name="image_file" id="addImage" accept="image/*" style="width:100%; padding:8px; border-radius:8px; border:1px solid rgba(255,255,255,.2); background:#203729; color:#fff;">
         </div>

         <div style="display:flex; gap:10px; justify-content:flex-end; border-top: 1px solid rgba(255,255,255,0.1); padding-top: 15px;">
            <button type="button" id="closeAddModalBtn" style="padding:10px 18px; border-radius:8px; border:1px solid rgba(255,255,255,.25); background:transparent; color:#fff; cursor: pointer; transition: all 0.2s;">Batal</button>
            <button type="submit" style="padding:10px 18px; border-radius:8px; border:none; background:#d4b15a; color:#102417; font-weight:700; cursor: pointer; transition: all 0.2s;">Simpan Wahana</button>
         </div>
      </form>
   </div>
</div>

<script>
   (function () {
      // Modals
      const editModal = document.getElementById('editModal');
      const addModal = document.getElementById('addModal');
      
      // Open / Close Buttons
      const addBtn = document.getElementById('addBtn');
      const closeModalBtn = document.getElementById('closeModalBtn');
      const closeAddModalBtn = document.getElementById('closeAddModalBtn');
      
      // Fields - Edit Form
      const editId = document.getElementById('editId');
      const editNama = document.getElementById('editNama');
      const editDeskripsi = document.getElementById('editDeskripsi');
      const editIsFree = document.getElementById('editIsFree');
      const editHargaTiket = document.getElementById('editHargaTiket');
      const editHargaTiketContainer = document.getElementById('editHargaTiketContainer');
      const editUrutan = document.getElementById('editUrutan');
      const editIsActive = document.getElementById('editIsActive');
      const editImagePreview = document.getElementById('editImagePreview');
      const noImageText = document.getElementById('noImageText');
      const editImage = document.getElementById('editImage');
      
      // Fields - Add Form
      const addIsFree = document.getElementById('addIsFree');
      const addHargaTiket = document.getElementById('addHargaTiket');
      const addHargaTiketContainer = document.getElementById('addHargaTiketContainer');
      const addImage = document.getElementById('addImage');

      const tableBody = document.getElementById('wahanaTableBody');

      // Toggle Ticket Price display based on is_free
      function togglePriceInput(isFreeSelect, priceInput, priceContainer) {
         if (isFreeSelect.value === '1') {
            priceContainer.style.opacity = '0.5';
            priceInput.disabled = true;
            priceInput.value = '0';
         } else {
            priceContainer.style.opacity = '1';
            priceInput.disabled = false;
         }
      }

      if (editIsFree) {
         editIsFree.addEventListener('change', function () {
            togglePriceInput(editIsFree, editHargaTiket, editHargaTiketContainer);
         });
      }

      if (addIsFree) {
         addIsFree.addEventListener('change', function () {
            togglePriceInput(addIsFree, addHargaTiket, addHargaTiketContainer);
         });
      }

      function closeEditModal() {
         editModal.style.display = 'none';
         if (editImage) editImage.value = '';
      }

      function closeAddModal() {
         addModal.style.display = 'none';
         if (addImage) addImage.value = '';
      }

      if (tableBody) {
         tableBody.addEventListener('click', function (event) {
            const row = event.target.closest('.wahana-row-editable');
            if (!row) return;

            editId.value = row.dataset.id || '';
            editNama.value = row.dataset.nama || '';
            editDeskripsi.value = row.dataset.deskripsi || '';
            editIsFree.value = row.dataset.isFree || '0';
            editHargaTiket.value = row.dataset.hargaTiket || '0';
            editUrutan.value = row.dataset.urutan || '1';
            editIsActive.value = row.dataset.isActive || '0';

            togglePriceInput(editIsFree, editHargaTiket, editHargaTiketContainer);

            const imgUrl = row.dataset.imgUrl || '';
            if (imgUrl) {
               editImagePreview.src = imgUrl;
               editImagePreview.style.display = 'block';
               noImageText.style.display = 'none';
            } else {
               editImagePreview.src = '';
               editImagePreview.style.display = 'none';
               noImageText.style.display = 'inline';
            }

            editModal.style.display = 'flex';
         });
      }

      if (addBtn) {
         addBtn.addEventListener('click', function () {
            addModal.style.display = 'flex';
            togglePriceInput(addIsFree, addHargaTiket, addHargaTiketContainer);
         });
      }

      if (closeModalBtn) closeModalBtn.addEventListener('click', closeEditModal);
      if (closeAddModalBtn) closeAddModalBtn.addEventListener('click', closeAddModal);

      // Close modal on click outside content
      window.addEventListener('click', function (e) {
         if (e.target === editModal) closeEditModal();
         if (e.target === addModal) closeAddModal();
      });

      // File size validation
      const maxBytes = 5 * 1024 * 1024;
      function validateFileSize(input) {
         const file = input.files && input.files[0] ? input.files[0] : null;
         if (file && file.size > maxBytes) {
            alert('Ukuran file maksimal adalah 5MB.');
            input.value = '';
         }
      }

      if (editImage) {
         editImage.addEventListener('change', function () {
            validateFileSize(editImage);
         });
      }

      if (addImage) {
         addImage.addEventListener('change', function () {
            validateFileSize(addImage);
         });
      }
   })();
</script>