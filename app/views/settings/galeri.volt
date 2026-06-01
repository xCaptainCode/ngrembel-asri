<style>
   .gallery-shell {
      padding: 120px 5% 60px;
      min-height: 70vh;
   }

   .gallery-panel {
      background: rgba(16, 36, 23, 0.65);
      border: 1px solid rgba(255, 255, 255, 0.08);
      border-radius: 18px;
      padding: 18px;
      overflow: hidden;
      box-shadow: 0 30px 60px rgba(0, 0, 0, 0.35);
   }

   .gallery-title {
      margin: 0 0 4px;
      color: #fff;
      font-family: 'Cormorant Garamond', serif;
      font-size: 2.1rem;
   }

   .gallery-subtitle {
      margin: 0;
      color: rgba(255, 255, 255, 0.72);
   }

   .btn-gold,
   .btn-ghost {
      display: inline-flex;
      align-items: center;
      justify-content: center;
      gap: 8px;
      padding: 10px 18px;
      border-radius: 10px;
      font-weight: 700;
      text-decoration: none;
      transition: all 0.2s ease;
      border: 1px solid transparent;
      cursor: pointer;
   }

   .btn-gold {
      background: #d4b15a;
      color: #102417;
      box-shadow: 0 4px 10px rgba(212, 177, 90, 0.2);
   }

   .btn-gold:hover {
      background: #c29f4f;
      transform: translateY(-1px);
      color: #102417;
   }

   .btn-ghost {
      background: rgba(255, 255, 255, 0.08);
      border-color: rgba(255, 255, 255, 0.16);
      color: #fff;
   }

   .btn-ghost:hover {
      background: rgba(255, 255, 255, 0.15);
      color: #fff;
      transform: translateY(-1px);
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

   .action-link {
      display: inline-flex;
      align-items: center;
      justify-content: center;
      padding: 7px 12px;
      border-radius: 8px;
      border: 1px solid rgba(212, 177, 90, 0.35);
      background: rgba(212, 177, 90, 0.12);
      color: #e8cc7a;
      text-decoration: none;
      font-weight: 700;
      transition: all 0.2s ease;
   }

   .action-link:hover {
      transform: translateY(-1px);
      background: rgba(212, 177, 90, 0.22);
      color: #fff;
   }
</style>

<section class="gallery-shell">
   <div style="display:flex; justify-content:space-between; align-items:flex-start; margin-bottom:20px; flex-wrap:wrap; gap:12px;">
      <div>
         <h1 class="gallery-title">Settings - Galeri</h1>
         <p class="gallery-subtitle">Kelola data media galeri dari tabel <code>media_gallery</code>.</p>
      </div>
      <div>
         <a href="{{ url('galeri/upload') }}" class="btn-gold">Tambah Media</a>
      </div>
   </div>

   <form id="searchForm" method="get" action="{{ url('settings/galeri') }}"
      style="display:flex; gap:10px; align-items:center; flex-wrap:wrap; margin-bottom:16px;">
      <input type="text" name="search" id="search" value="{{ searchQuery }}"
         placeholder="Cari judul, deskripsi, kategori, atau tipe media..."
         style="min-width:280px; max-width:420px; width:100%; padding:10px 12px; border-radius:8px; border:1px solid rgba(255,255,255,.2); background:#203729; color:#fff; font-family:'Jost', sans-serif;">
      <button type="submit" class="btn-gold" style="padding:8px 16px;">Cari</button>
      {% if searchQuery is not empty %}
      <a href="{{ url('settings/galeri') }}" class="btn-ghost" style="padding:8px 16px;">Reset</a>
      {% endif %}
   </form>

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

   <div class="gallery-panel">
      {% if galleryList is empty %}
      <p style="margin:0; color: rgba(255,255,255,0.7);">Data galeri belum tersedia.</p>
      {% else %}
      <div style="margin-bottom:8px; color:#e8cc7a; font-size:0.9rem;">
         Menampilkan {{ ((currentPage - 1) * perPage) + 1 }} - {{ ((currentPage - 1) * perPage) + galleryList|length }} dari {{ totalItems }} data
      </div>

      <div class="table-responsive" style="overflow-x:auto;">
         <table class="table table-sm text-white" style="width:100%; border-collapse:collapse;">
            <thead>
               <tr style="background:rgba(0,0,0,0.2);">
                  <th style="text-align:left; padding:12px 10px; border-bottom:2px solid rgba(255,255,255,.15);">Judul</th>
                  <th style="text-align:left; padding:12px 10px; border-bottom:2px solid rgba(255,255,255,.15);">Deskripsi</th>
                  <th style="text-align:center; padding:12px 10px; border-bottom:2px solid rgba(255,255,255,.15);">Kategori</th>
                  <th style="text-align:center; padding:12px 10px; border-bottom:2px solid rgba(255,255,255,.15);">Tipe</th>
                  <th style="text-align:center; padding:12px 10px; border-bottom:2px solid rgba(255,255,255,.15);">Preview</th>
                  <th style="text-align:center; padding:12px 10px; border-bottom:2px solid rgba(255,255,255,.15);">Status</th>
                  <th style="text-align:left; padding:12px 10px; border-bottom:2px solid rgba(255,255,255,.15);">Updated At</th>
                  <th style="text-align:center; padding:12px 10px; border-bottom:2px solid rgba(255,255,255,.15);">Aksi</th>
               </tr>
            </thead>
            <tbody>
               {% for item in galleryList %}
               <tr style="background: rgba(255,255,255,0.02);">
                  <td style="padding:12px 10px; border-bottom:1px solid rgba(255,255,255,.08); font-weight:600; color:#d4b15a;">
                     {{ item['title'] }}
                  </td>
                  <td style="padding:12px 10px; border-bottom:1px solid rgba(255,255,255,.08); font-size:0.9rem; opacity:0.9; line-height:1.4;">
                     {{ item['description'] ? item['description'] : '-' }}
                  </td>
                  <td style="padding:12px 10px; border-bottom:1px solid rgba(255,255,255,.08); text-align:center;">
                     <span class="badge-category">{{ item['category'] }}</span>
                  </td>
                  <td style="padding:12px 10px; border-bottom:1px solid rgba(255,255,255,.08); text-align:center;">
                     <span class="badge-media">{{ item['type'] }}</span>
                  </td>
                  <td style="padding:12px 10px; border-bottom:1px solid rgba(255,255,255,.08); text-align:center;">
                     {% if item['type'] == 'photo' %}
                        {% if item['thumb_sm_path'] %}
                           <img src="{{ url(item['thumb_sm_path']) }}" alt="{{ item['title'] }}"
                              style="max-height:50px; max-width:80px; border-radius:6px; object-fit:cover; border:1px solid rgba(255,255,255,0.15);">
                        {% elseif item['original_path'] %}
                           <img src="{{ url(item['original_path']) }}" alt="{{ item['title'] }}"
                              style="max-height:50px; max-width:80px; border-radius:6px; object-fit:cover; border:1px solid rgba(255,255,255,0.15);">
                        {% else %}
                           <em style="opacity:.5; font-size:0.9rem;">(tidak ada)</em>
                        {% endif %}
                     {% else %}
                        {% if item['poster_path'] %}
                           <img src="{{ url(item['poster_path']) }}" alt="{{ item['title'] }}"
                              style="max-height:50px; max-width:80px; border-radius:6px; object-fit:cover; border:1px solid rgba(255,255,255,0.15);">
                        {% elseif item['original_path'] %}
                           <a href="{{ url(item['original_path']) }}" target="_blank" rel="noopener" style="color:#8fd3ff; text-decoration:none;">Lihat Video</a>
                        {% else %}
                           <em style="opacity:.5; font-size:0.9rem;">(tidak ada)</em>
                        {% endif %}
                     {% endif %}
                  </td>
                  <td style="padding:12px 10px; border-bottom:1px solid rgba(255,255,255,.08); text-align:center;">
                     {% if item['is_active'] == 't' or item['is_active'] === true or item['is_active'] === '1' or item['is_active'] === 1 %}
                        <span class="badge-active">Aktif</span>
                     {% else %}
                        <span class="badge-inactive">Tidak Aktif</span>
                     {% endif %}
                  </td>
                  <td style="padding:12px 10px; border-bottom:1px solid rgba(255,255,255,.08); font-size:0.85rem; opacity:0.85;">
                     {{ item['updated_at'] ? item['updated_at'] : item['created_at'] }}
                     <div style="font-size:0.75rem; opacity:0.7; margin-top:2px;">
                        Oleh: {{ item['updated_by_nama'] ? item['updated_by_nama'] : (item['created_by_nama'] ? item['created_by_nama'] : '-') }}
                     </div>
                  </td>
                  <td style="padding:12px 10px; border-bottom:1px solid rgba(255,255,255,.08); text-align:center;">
                     <a href="{{ url('settings/edit_galeri/' ~ item['id']) }}" class="action-link">Edit</a>
                  </td>
               </tr>
               {% endfor %}
            </tbody>
         </table>
      </div>

      <div style="display:flex; justify-content:center; align-items:center; margin-top:14px; gap:8px; flex-wrap:wrap;">
         {% set prevPage = currentPage > 1 ? currentPage - 1 : 1 %}
         {% set nextPage = currentPage < totalPages ? currentPage + 1 : totalPages %}

         {% if currentPage == 1 %}
            <span class="pagination-link disabled">Prev</span>
         {% else %}
            <a href="{{ url('settings/galeri') }}?{{ http_build_query({'search': searchQuery, 'page': prevPage}) }}" class="pagination-link">Prev</a>
         {% endif %}

         {% for i in 1..totalPages %}
            {% if i == currentPage %}
               <span class="pagination-link active">{{ i }}</span>
            {% else %}
               <a href="{{ url('settings/galeri') }}?{{ http_build_query({'search': searchQuery, 'page': i}) }}" class="pagination-link">{{ i }}</a>
            {% endif %}
         {% endfor %}

         {% if currentPage == totalPages %}
            <span class="pagination-link disabled">Next</span>
         {% else %}
            <a href="{{ url('settings/galeri') }}?{{ http_build_query({'search': searchQuery, 'page': nextPage}) }}" class="pagination-link">Next</a>
         {% endif %}
      </div>
      {% endif %}
   </div>
</section>
