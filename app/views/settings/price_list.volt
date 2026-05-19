<style>
   .pricelist-row-editable {
      cursor: pointer;
      transition: background 0.2s ease-in-out;
   }
   .pricelist-row-editable:hover {
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
   .category-badge {
      background: rgba(212, 177, 90, 0.15);
      color: #d4b15a;
      border: 1px solid rgba(212, 177, 90, 0.3);
      padding: 3px 6px;
      border-radius: 4px;
      font-size: 0.8rem;
      font-weight: 600;
   }
</style>

<section style="padding: 120px 5% 60px; min-height: 70vh;">
   <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; flex-wrap: wrap; gap: 12px;">
      <div>
         <h1 style="margin: 0 0 4px 0;">Settings - Price List</h1>
         <p style="margin: 0;">Klik pada baris tabel untuk meng-edit data item Price List.</p>
      </div>
      <div style="display: flex; gap: 10px;">
         <button type="button" id="addJenisBtn" style="padding: 10px 20px; border-radius: 8px; border: none; background: #2a9d52; color: #fff; font-weight: 700; cursor: pointer; display: flex; align-items: center; gap: 6px; transition: all 0.2s; box-shadow: 0 4px 10px rgba(42, 157, 82, 0.2);">
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" style="vertical-align: middle;"><line x1="12" y1="5" x2="12" y2="19"></line><line x1="5" y1="12" x2="19" y2="12"></line></svg>
            Tambah Jenis Masakan Baru
         </button>
         <button type="button" id="addBtn" style="padding: 10px 20px; border-radius: 8px; border: none; background: #d4b15a; color: #102417; font-weight: 700; cursor: pointer; display: flex; align-items: center; gap: 6px; transition: all 0.2s; box-shadow: 0 4px 10px rgba(212, 177, 90, 0.2);">
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" style="vertical-align: middle;"><line x1="12" y1="5" x2="12" y2="19"></line><line x1="5" y1="12" x2="19" y2="12"></line></svg>
            Tambah Item Baru
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
      <h2 style="color: #d4b15a; margin-top: 0; margin-bottom: 16px; font-family: 'Cormorant Garamond', serif; font-size: 1.8rem; font-style: italic; border-bottom: 1px solid rgba(212,177,90,0.2); padding-bottom: 8px;">Daftar Jenis Masakan</h2>
      {% if jenisMasakan is empty %}
      <p>Data Jenis Masakan belum tersedia.</p>
      {% else %}
      <div class="table-responsive" style="overflow-x: auto; background: rgba(16, 36, 23, 0.6); border: 1px solid rgba(255,255,255,0.1); border-radius: 12px; padding: 10px;">
         <table class="table table-sm text-white" style="width:100%; border-collapse: collapse;">
            <thead>
               <tr style="background: rgba(0,0,0,0.2);">
                  <th style="text-align:left; padding:12px 10px; border-bottom:2px solid rgba(255,255,255,.15); width: 15%;">Nama</th>
                  <th style="text-align:left; padding:12px 10px; border-bottom:2px solid rgba(255,255,255,.15); width: 35%;">Deskripsi</th>
                  <th style="text-align:center; padding:12px 10px; border-bottom:2px solid rgba(255,255,255,.15); width: 10%;">Gambar</th>
                  <th style="text-align:center; padding:12px 10px; border-bottom:2px solid rgba(255,255,255,.15); width: 8%;">No Urut</th>
                  <th style="text-align:center; padding:12px 10px; border-bottom:2px solid rgba(255,255,255,.15); width: 10%;">Status</th>
                  <th style="text-align:left; padding:12px 10px; border-bottom:2px solid rgba(255,255,255,.15); width: 12%;">Updated At</th>
                  <th style="text-align:left; padding:12px 10px; border-bottom:2px solid rgba(255,255,255,.15); width: 10%;">Updated By</th>
               </tr>
            </thead>
            <tbody id="jenisMasakanTableBody">
               {% for item in jenisMasakan %}
               <tr class="jenismasakan-row-editable pricelist-row-editable"
                   data-id="{{ item['id'] }}"
                   data-nama="{{ item['nama'] }}"
                   data-deskripsi="{{ item['deskripsi'] }}"
                   data-no-urut="{{ item['no_urut'] }}"
                   data-is-active="{{ item['is_active'] == 't' or item['is_active'] === true or item['is_active'] === '1' or item['is_active'] === 1 ? '1' : '0' }}"
                   data-img-url="{{ item['img_url'] ? url(item['img_url']) : '' }}">
                  
                  <td style="padding:12px 10px; border-bottom:1px solid rgba(255,255,255,.08); font-weight: 600; color: #d4b15a;">
                     {{ item['nama'] }}
                  </td>
                  
                  <td style="padding:12px 10px; border-bottom:1px solid rgba(255,255,255,.08); font-size: 0.9rem; opacity: 0.9; line-height: 1.4;">
                     {{ item['deskripsi'] }}
                  </td>
                  
                  <td style="padding:12px 10px; border-bottom:1px solid rgba(255,255,255,.08); text-align: center;">
                     {% if item['img_url'] %}
                        <img src="{{ url(item['img_url']) }}" alt="{{ item['nama'] }}" style="max-height:50px; max-width:80px; border-radius:6px; object-fit:cover; border:1px solid rgba(255,255,255,0.15);">
                     {% else %}
                        <em style="opacity:.5; font-size:0.9rem;">(tidak ada)</em>
                     {% endif %}
                  </td>
                  
                  <td style="padding:12px 10px; border-bottom:1px solid rgba(255,255,255,.08); text-align: center;">
                     {{ item['no_urut'] }}
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
                  </td>
                  
                  <td style="padding:12px 10px; border-bottom:1px solid rgba(255,255,255,.08); font-size: 0.85rem; opacity: 0.85;">
                     {{ item['updated_by_nama'] ? item['updated_by_nama'] : (item['created_by_nama'] ? item['created_by_nama'] : '-') }}
                  </td>
               </tr>
               {% endfor %}
            </tbody>
         </table>
      </div>
      {% endif %}
   </div>

   <h2 style="color: #d4b15a; margin-top: 30px; margin-bottom: 16px; font-family: 'Cormorant Garamond', serif; font-size: 1.8rem; font-style: italic; border-bottom: 1px solid rgba(212,177,90,0.2); padding-bottom: 8px;">Daftar Price List</h2>

   {% if priceList is empty %}
   <p>Data Price List belum tersedia.</p>
   {% else %}
   <div class="table-responsive" style="overflow-x: auto; background: rgba(16, 36, 23, 0.6); border: 1px solid rgba(255,255,255,0.1); border-radius: 12px; padding: 10px;">
      <table class="table table-sm text-white" style="width:100%; border-collapse: collapse;">
         <thead>
            <tr style="background: rgba(0,0,0,0.2);">
               <th style="text-align:left; padding:12px 10px; border-bottom:2px solid rgba(255,255,255,.15);">Kategori</th>
               <th style="text-align:left; padding:12px 10px; border-bottom:2px solid rgba(255,255,255,.15);">Nama</th>
               <th style="text-align:center; padding:12px 10px; border-bottom:2px solid rgba(255,255,255,.15);">Gambar</th>
               <th style="text-align:center; padding:12px 10px; border-bottom:2px solid rgba(255,255,255,.15);">No Urut</th>
               <th style="text-align:center; padding:12px 10px; border-bottom:2px solid rgba(255,255,255,.15);">Status</th>
               <th style="text-align:left; padding:12px 10px; border-bottom:2px solid rgba(255,255,255,.15);">Updated At</th>
               <th style="text-align:left; padding:12px 10px; border-bottom:2px solid rgba(255,255,255,.15);">Updated By</th>
            </tr>
         </thead>
         <tbody id="priceListTableBody">
            {% for item in priceList %}
            <tr class="pricelist-row-editable"
                data-id="{{ item['id'] }}"
                data-kategori="{{ item['kategori'] }}"
                data-nama="{{ item['nama'] }}"
                data-no-urut="{{ item['no_urut'] }}"
                data-is-active="{{ item['is_active'] == 't' or item['is_active'] === true or item['is_active'] === '1' or item['is_active'] === 1 ? '1' : '0' }}"
                data-img-url="{{ item['img_url'] ? url(item['img_url']) : '' }}">
               
               <td style="padding:12px 10px; border-bottom:1px solid rgba(255,255,255,.08);">
                  <span class="category-badge">{{ item['kategori'] }}</span>
               </td>
               
               <td style="padding:12px 10px; border-bottom:1px solid rgba(255,255,255,.08); font-weight: 500;">
                  {{ item['nama'] }}
               </td>
               
               <td style="padding:12px 10px; border-bottom:1px solid rgba(255,255,255,.08); text-align: center;">
                  {% if item['img_url'] %}
                     <img src="{{ url(item['img_url']) }}" alt="{{ item['nama'] }}" style="max-height:50px; max-width:80px; border-radius:6px; object-fit:cover; border:1px solid rgba(255,255,255,0.15);">
                  {% else %}
                     <em style="opacity:.5; font-size:0.9rem;">(tidak ada)</em>
                  {% endif %}
               </td>
               
               <td style="padding:12px 10px; border-bottom:1px solid rgba(255,255,255,.08); text-align: center;">
                  {{ item['no_urut'] }}
               </td>
               
               <td style="padding:12px 10px; border-bottom:1px solid rgba(255,255,255,.08); text-align: center;">
                  {% if item['is_active'] == 't' or item['is_active'] === true or item['is_active'] === '1' or item['is_active'] === 1 %}
                     <span class="badge-active">Aktif</span>
                  {% else %}
                     <span class="badge-inactive">Tidak Aktif</span>
                  {% endif %}
               </td>
               
               <td style="padding:12px 10px; border-bottom:1px solid rgba(255,255,255,.08); font-size: 0.9rem; opacity: 0.85;">
                  {{ item['updated_at'] ? item['updated_at'] : item['created_at'] }}
               </td>
               
               <td style="padding:12px 10px; border-bottom:1px solid rgba(255,255,255,.08); font-size: 0.9rem; opacity: 0.85;">
                  {{ item['updated_by_nama'] ? item['updated_by_nama'] : (item['created_by_nama'] ? item['created_by_nama'] : '-') }}
               </td>
            </tr>
            {% endfor %}
         </tbody>
      </table>
   </div>
   {% endif %}
</section>

<!-- EDIT MODAL -->
<div id="editModal" style="display:none; position:fixed; inset:0; background:rgba(0,0,0,.65); z-index:9999; align-items:center; justify-content:center; backdrop-filter: blur(4px);">
   <div style="width:min(600px, 92vw); background:#102417; color:#fff; border:1px solid rgba(255,255,255,.2); border-radius:16px; padding:24px; box-shadow: 0 10px 25px rgba(0,0,0,0.5);">
      <h3 style="margin:0 0 18px; font-size: 1.5rem; color:#d4b15a; border-bottom: 1px solid rgba(255,255,255,0.1); padding-bottom: 10px;">Edit Price List Item</h3>
      
      <form method="post" action="{{ url('settings/update_pricelist') }}" enctype="multipart/form-data">
         <input type="hidden" name="MAX_FILE_SIZE" value="5242880">
         <input type="hidden" name="id" id="editId">
         
         <div style="margin-bottom:14px;">
            <label for="editKategori" style="display:block; margin-bottom:6px; font-weight: 600;">Kategori</label>
            <input id="editKategori" name="kategori" type="text" required style="width:100%; padding:10px; border-radius:8px; border:1px solid rgba(255,255,255,.2); background:#203729; color:#fff;">
         </div>

         <div style="margin-bottom:14px;">
            <label for="editNama" style="display:block; margin-bottom:6px; font-weight: 600;">Nama Item</label>
            <input id="editNama" name="nama" type="text" required style="width:100%; padding:10px; border-radius:8px; border:1px solid rgba(255,255,255,.2); background:#203729; color:#fff;">
         </div>

         <div style="margin-bottom:14px; display: flex; gap: 12px;">
            <div style="flex: 1;">
               <label for="editNoUrut" style="display:block; margin-bottom:6px; font-weight: 600;">No Urut</label>
               <input id="editNoUrut" name="no_urut" type="number" required min="1" style="width:100%; padding:10px; border-radius:8px; border:1px solid rgba(255,255,255,.2); background:#203729; color:#fff;">
            </div>
            <div style="flex: 1;">
               <label for="editIsActive" style="display:block; margin-bottom:6px; font-weight: 600;">Status</label>
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

<!-- EDIT JENIS MASAKAN MODAL -->
<div id="editJenisMasakanModal" style="display:none; position:fixed; inset:0; background:rgba(0,0,0,.65); z-index:9999; align-items:center; justify-content:center; backdrop-filter: blur(4px);">
   <div style="width:min(600px, 92vw); background:#102417; color:#fff; border:1px solid rgba(255,255,255,.2); border-radius:16px; padding:24px; box-shadow: 0 10px 25px rgba(0,0,0,0.5);">
      <h3 style="margin:0 0 18px; font-size: 1.5rem; color:#d4b15a; border-bottom: 1px solid rgba(255,255,255,0.1); padding-bottom: 10px;">Edit Jenis Masakan</h3>
      
      <form method="post" action="{{ url('settings/update_jenis_masakan') }}" enctype="multipart/form-data">
         <input type="hidden" name="MAX_FILE_SIZE" value="5242880">
         <input type="hidden" name="id" id="editJenisId">
         
         <div style="margin-bottom:14px;">
            <label for="editJenisNama" style="display:block; margin-bottom:6px; font-weight: 600;">Nama Jenis Masakan</label>
            <input id="editJenisNama" name="nama" type="text" required style="width:100%; padding:10px; border-radius:8px; border:1px solid rgba(255,255,255,.2); background:#203729; color:#fff;">
         </div>

         <div style="margin-bottom:14px;">
            <label for="editJenisDeskripsi" style="display:block; margin-bottom:6px; font-weight: 600;">Deskripsi</label>
            <textarea id="editJenisDeskripsi" name="deskripsi" rows="4" style="width:100%; padding:10px; border-radius:8px; border:1px solid rgba(255,255,255,.2); background:#203729; color:#fff; resize: vertical; font-family: inherit; line-height: 1.4;"></textarea>
         </div>

         <div style="margin-bottom:14px; display: flex; gap: 12px;">
            <div style="flex: 1;">
               <label for="editJenisNoUrut" style="display:block; margin-bottom:6px; font-weight: 600;">No Urut</label>
               <input id="editJenisNoUrut" name="no_urut" type="number" required min="1" style="width:100%; padding:10px; border-radius:8px; border:1px solid rgba(255,255,255,.2); background:#203729; color:#fff;">
            </div>
            <div style="flex: 1;">
               <label for="editJenisIsActive" style="display:block; margin-bottom:6px; font-weight: 600;">Status</label>
               <select id="editJenisIsActive" name="is_active" style="width:100%; padding:10px; border-radius:8px; border:1px solid rgba(255,255,255,.2); background:#203729; color:#fff; cursor: pointer;">
                  <option value="1">Aktif</option>
                  <option value="0">Tidak Aktif</option>
               </select>
            </div>
         </div>

         <div style="margin-bottom:18px;">
            <label style="display:block; margin-bottom:6px; font-weight: 600;">Gambar Saat Ini</label>
            <div id="currentJenisImageContainer" style="margin-bottom: 8px;">
               <img id="editJenisImagePreview" src="" alt="Preview" style="max-height:100px; border-radius:8px; display:none; border:1px solid rgba(255,255,255,0.2);">
               <span id="noJenisImageText" style="font-style: italic; opacity: 0.6; display: none;">Tidak ada gambar</span>
            </div>
            <label for="editJenisImage" style="display:block; margin-bottom:6px; font-weight: 600;">Upload Gambar Baru (Maks 5MB)</label>
            <input type="file" name="image_file" id="editJenisImage" accept="image/*" style="width:100%; padding:8px; border-radius:8px; border:1px solid rgba(255,255,255,.2); background:#203729; color:#fff;">
         </div>

         <div style="display:flex; gap:10px; justify-content:flex-end; border-top: 1px solid rgba(255,255,255,0.1); padding-top: 15px;">
            <button type="button" id="closeJenisModalBtn" style="padding:10px 18px; border-radius:8px; border:1px solid rgba(255,255,255,.25); background:transparent; color:#fff; cursor: pointer; transition: all 0.2s;">Batal</button>
            <button type="submit" style="padding:10px 18px; border-radius:8px; border:none; background:#d4b15a; color:#102417; font-weight:700; cursor: pointer; transition: all 0.2s;">Simpan Perubahan</button>
         </div>
      </form>
   </div>
</div>


<!-- ADD MODAL -->
<div id="addModal" style="display:none; position:fixed; inset:0; background:rgba(0,0,0,.65); z-index:9999; align-items:center; justify-content:center; backdrop-filter: blur(4px);">
   <div style="width:min(600px, 92vw); background:#102417; color:#fff; border:1px solid rgba(255,255,255,.2); border-radius:16px; padding:24px; box-shadow: 0 10px 25px rgba(0,0,0,0.5);">
      <h3 style="margin:0 0 18px; font-size: 1.5rem; color:#d4b15a; border-bottom: 1px solid rgba(255,255,255,0.1); padding-bottom: 10px;">Tambah Price List Baru</h3>
      
      <form method="post" action="{{ url('settings/create_pricelist') }}" enctype="multipart/form-data">
         <input type="hidden" name="MAX_FILE_SIZE" value="5242880">
         
         <div style="margin-bottom:14px;">
            <label for="addKategori" style="display:block; margin-bottom:6px; font-weight: 600;">Kategori</label>
            <input id="addKategori" name="kategori" type="text" placeholder="Contoh: RESOTRAN, WAHANA" required style="width:100%; padding:10px; border-radius:8px; border:1px solid rgba(255,255,255,.2); background:#203729; color:#fff;">
         </div>

         <div style="margin-bottom:14px;">
            <label for="addNama" style="display:block; margin-bottom:6px; font-weight: 600;">Nama Item</label>
            <input id="addNama" name="nama" type="text" placeholder="Contoh: MENU MAKANAN BARU" required style="width:100%; padding:10px; border-radius:8px; border:1px solid rgba(255,255,255,.2); background:#203729; color:#fff;">
         </div>

         <div style="margin-bottom:14px; display: flex; gap: 12px;">
            <div style="flex: 1;">
               <label for="addNoUrut" style="display:block; margin-bottom:6px; font-weight: 600;">No Urut</label>
               <input id="addNoUrut" name="no_urut" type="number" required min="1" value="1" style="width:100%; padding:10px; border-radius:8px; border:1px solid rgba(255,255,255,.2); background:#203729; color:#fff;">
            </div>
            <div style="flex: 1;">
               <label for="addIsActive" style="display:block; margin-bottom:6px; font-weight: 600;">Status</label>
               <select id="addIsActive" name="is_active" style="width:100%; padding:10px; border-radius:8px; border:1px solid rgba(255,255,255,.2); background:#203729; color:#fff; cursor: pointer;">
                  <option value="1">Aktif</option>
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
            <button type="submit" style="padding:10px 18px; border-radius:8px; border:none; background:#d4b15a; color:#102417; font-weight:700; cursor: pointer; transition: all 0.2s;">Simpan Item</button>
         </div>
      </form>
   </div>
</div>

<!-- ADD JENIS MASAKAN MODAL -->
<div id="addJenisMasakanModal" style="display:none; position:fixed; inset:0; background:rgba(0,0,0,.65); z-index:9999; align-items:center; justify-content:center; backdrop-filter: blur(4px);">
   <div style="width:min(600px, 92vw); background:#102417; color:#fff; border:1px solid rgba(255,255,255,.2); border-radius:16px; padding:24px; box-shadow: 0 10px 25px rgba(0,0,0,0.5);">
      <h3 style="margin:0 0 18px; font-size: 1.5rem; color:#d4b15a; border-bottom: 1px solid rgba(255,255,255,0.1); padding-bottom: 10px;">Tambah Jenis Masakan Baru</h3>
      
      <form method="post" action="{{ url('settings/insert_jenis_masakan') }}" enctype="multipart/form-data">
         <input type="hidden" name="MAX_FILE_SIZE" value="5242880">
         
         <div style="margin-bottom:14px;">
            <label for="addJenisNama" style="display:block; margin-bottom:6px; font-weight: 600;">Nama Jenis Masakan</label>
            <input id="addJenisNama" name="nama" type="text" placeholder="Contoh: BAKAR MADU" required style="width:100%; padding:10px; border-radius:8px; border:1px solid rgba(255,255,255,.2); background:#203729; color:#fff;">
         </div>

         <div style="margin-bottom:14px;">
            <label for="addJenisDeskripsi" style="display:block; margin-bottom:6px; font-weight: 600;">Deskripsi</label>
            <textarea id="addJenisDeskripsi" name="deskripsi" rows="4" placeholder="Deskripsikan menu ini..." style="width:100%; padding:10px; border-radius:8px; border:1px solid rgba(255,255,255,.2); background:#203729; color:#fff; resize: vertical; font-family: inherit; line-height: 1.4;"></textarea>
         </div>

         <div style="margin-bottom:14px; display: flex; gap: 12px;">
            <div style="flex: 1;">
               <label for="addJenisNoUrut" style="display:block; margin-bottom:6px; font-weight: 600;">No Urut</label>
               <input id="addJenisNoUrut" name="no_urut" type="number" required min="1" value="1" style="width:100%; padding:10px; border-radius:8px; border:1px solid rgba(255,255,255,.2); background:#203729; color:#fff;">
            </div>
            <div style="flex: 1;">
               <label for="addJenisIsActive" style="display:block; margin-bottom:6px; font-weight: 600;">Status</label>
               <select id="addJenisIsActive" name="is_active" style="width:100%; padding:10px; border-radius:8px; border:1px solid rgba(255,255,255,.2); background:#203729; color:#fff; cursor: pointer;">
                  <option value="1">Aktif</option>
                  <option value="0">Tidak Aktif</option>
               </select>
            </div>
         </div>

         <div style="margin-bottom:18px;">
            <label for="addJenisImage" style="display:block; margin-bottom:6px; font-weight: 600;">Upload Gambar (Maks 5MB)</label>
            <input type="file" name="image_file" id="addJenisImage" accept="image/*" style="width:100%; padding:8px; border-radius:8px; border:1px solid rgba(255,255,255,.2); background:#203729; color:#fff;">
         </div>

         <div style="display:flex; gap:10px; justify-content:flex-end; border-top: 1px solid rgba(255,255,255,0.1); padding-top: 15px;">
            <button type="button" id="closeAddJenisModalBtn" style="padding:10px 18px; border-radius:8px; border:1px solid rgba(255,255,255,.25); background:transparent; color:#fff; cursor: pointer; transition: all 0.2s;">Batal</button>
            <button type="submit" style="padding:10px 18px; border-radius:8px; border:none; background:#d4b15a; color:#102417; font-weight:700; cursor: pointer; transition: all 0.2s;">Simpan Item</button>
         </div>
      </form>
   </div>
</div>

<script>
   (function () {
      // Edit Modal elements
      const editModal = document.getElementById('editModal');
      const closeModalBtn = document.getElementById('closeModalBtn');
      const editId = document.getElementById('editId');
      const editKategori = document.getElementById('editKategori');
      const editNama = document.getElementById('editNama');
      const editNoUrut = document.getElementById('editNoUrut');
      const editIsActive = document.getElementById('editIsActive');
      const editImagePreview = document.getElementById('editImagePreview');
      const noImageText = document.getElementById('noImageText');
      const editImage = document.getElementById('editImage');

      // Edit Jenis Masakan Modal elements
      const editJenisMasakanModal = document.getElementById('editJenisMasakanModal');
      const closeJenisModalBtn = document.getElementById('closeJenisModalBtn');
      const editJenisId = document.getElementById('editJenisId');
      const editJenisNama = document.getElementById('editJenisNama');
      const editJenisDeskripsi = document.getElementById('editJenisDeskripsi');
      const editJenisNoUrut = document.getElementById('editJenisNoUrut');
      const editJenisIsActive = document.getElementById('editJenisIsActive');
      const editJenisImagePreview = document.getElementById('editJenisImagePreview');
      const noJenisImageText = document.getElementById('noJenisImageText');
      const editJenisImage = document.getElementById('editJenisImage');
      const jenisTableBody = document.getElementById('jenisMasakanTableBody');

      // Add Modal elements
      const addModal = document.getElementById('addModal');
      const addBtn = document.getElementById('addBtn');
      const closeAddModalBtn = document.getElementById('closeAddModalBtn');
      const addImage = document.getElementById('addImage');

      // Add Jenis Masakan Modal elements
      const addJenisMasakanModal = document.getElementById('addJenisMasakanModal');
      const addJenisBtn = document.getElementById('addJenisBtn');
      const closeAddJenisModalBtn = document.getElementById('closeAddJenisModalBtn');
      const addJenisImage = document.getElementById('addJenisImage');

      const tableBody = document.getElementById('priceListTableBody');

      function closeEditModal() {
         editModal.style.display = 'none';
         if (editImage) editImage.value = '';
      }

      function closeJenisEditModal() {
         editJenisMasakanModal.style.display = 'none';
         if (editJenisImage) editJenisImage.value = '';
      }

      function closeAddModal() {
         addModal.style.display = 'none';
         if (addImage) addImage.value = '';
      }

      function closeAddJenisModal() {
         addJenisMasakanModal.style.display = 'none';
         if (addJenisImage) addJenisImage.value = '';
      }

      if (tableBody) {
         tableBody.addEventListener('click', function (event) {
            const row = event.target.closest('.pricelist-row-editable');
            // If the row clicked is actually in the jenisMasakan table (since both have pricelist-row-editable), let's ignore it if it's jenismasakan-row-editable
            if (!row || row.classList.contains('jenismasakan-row-editable')) return;

            editId.value = row.dataset.id || '';
            editKategori.value = row.dataset.kategori || '';
            editNama.value = row.dataset.nama || '';
            editNoUrut.value = row.dataset.noUrut || '';
            editIsActive.value = row.dataset.isActive || '0';

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

      if (jenisTableBody) {
         jenisTableBody.addEventListener('click', function (event) {
            const row = event.target.closest('.jenismasakan-row-editable');
            if (!row) return;

            editJenisId.value = row.dataset.id || '';
            editJenisNama.value = row.dataset.nama || '';
            editJenisDeskripsi.value = row.dataset.deskripsi || '';
            editJenisNoUrut.value = row.dataset.noUrut || '';
            editJenisIsActive.value = row.dataset.isActive || '0';

            const imgUrl = row.dataset.imgUrl || '';
            if (imgUrl) {
               editJenisImagePreview.src = imgUrl;
               editJenisImagePreview.style.display = 'block';
               noJenisImageText.style.display = 'none';
            } else {
               editJenisImagePreview.src = '';
               editJenisImagePreview.style.display = 'none';
               noJenisImageText.style.display = 'inline';
            }

            editJenisMasakanModal.style.display = 'flex';
         });
      }

      if (addBtn) {
         addBtn.addEventListener('click', function () {
            addModal.style.display = 'flex';
         });
      }

      if (addJenisBtn) {
         addJenisBtn.addEventListener('click', function () {
            addJenisMasakanModal.style.display = 'flex';
         });
      }

      if (closeModalBtn) {
         closeModalBtn.addEventListener('click', closeEditModal);
      }

      if (closeJenisModalBtn) {
         closeJenisModalBtn.addEventListener('click', closeJenisEditModal);
      }

      if (closeAddModalBtn) {
         closeAddModalBtn.addEventListener('click', closeAddModal);
      }

      if (closeAddJenisModalBtn) {
         closeAddJenisModalBtn.addEventListener('click', closeAddJenisModal);
      }

      if (editModal) {
         editModal.addEventListener('click', function (e) {
            if (e.target === editModal) {
               closeEditModal();
            }
         });
      }

      if (editJenisMasakanModal) {
         editJenisMasakanModal.addEventListener('click', function (e) {
            if (e.target === editJenisMasakanModal) {
               closeJenisEditModal();
            }
         });
      }

      if (addModal) {
         addModal.addEventListener('click', function (e) {
            if (e.target === addModal) {
               closeAddModal();
            }
         });
      }

      if (addJenisMasakanModal) {
         addJenisMasakanModal.addEventListener('click', function (e) {
            if (e.target === addJenisMasakanModal) {
               closeAddJenisModal();
            }
         });
      }

      if (editImage) {
         editImage.addEventListener('change', function () {
            const maxBytes = 5 * 1024 * 1024;
            const file = editImage.files && editImage.files[0] ? editImage.files[0] : null;
            if (file && file.size > maxBytes) {
               alert('Ukuran file maksimal adalah 5MB.');
               editImage.value = '';
            }
         });
      }

      if (editJenisImage) {
         editJenisImage.addEventListener('change', function () {
            const maxBytes = 5 * 1024 * 1024;
            const file = editJenisImage.files && editJenisImage.files[0] ? editJenisImage.files[0] : null;
            if (file && file.size > maxBytes) {
               alert('Ukuran file maksimal adalah 5MB.');
               editJenisImage.value = '';
            }
         });
      }

      if (addImage) {
         addImage.addEventListener('change', function () {
            const maxBytes = 5 * 1024 * 1024;
            const file = addImage.files && addImage.files[0] ? addImage.files[0] : null;
            if (file && file.size > maxBytes) {
               alert('Ukuran file maksimal adalah 5MB.');
               addImage.value = '';
            }
         });
      }

      if (addJenisImage) {
         addJenisImage.addEventListener('change', function () {
            const maxBytes = 5 * 1024 * 1024;
            const file = addJenisImage.files && addJenisImage.files[0] ? addJenisImage.files[0] : null;
            if (file && file.size > maxBytes) {
               alert('Ukuran file maksimal adalah 5MB.');
               addJenisImage.value = '';
            }
         });
      }
   })();
</script>
