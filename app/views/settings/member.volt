<style>
   .table th,
   .table td {
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

   .badge-role {
      background: rgba(212, 177, 90, 0.15);
      color: #d4b15a;
      border: 1px solid rgba(212, 177, 90, 0.35);
      padding: 4px 8px;
      border-radius: 6px;
      font-size: 0.8rem;
      font-weight: 700;
      letter-spacing: 0.4px;
   }

   .notification-btn {
      display: inline-flex;
      align-items: center;
      gap: 10px;
      background: linear-gradient(135deg, rgba(200, 168, 75, 0.2), rgba(232, 204, 122, 0.25));
      color: #e8cc7a;
      border: 1px solid rgba(200, 168, 75, 0.45);
      padding: 10px 20px;
      border-radius: 30px;
      text-decoration: none;
      font-weight: 600;
      font-size: 0.9rem;
      transition: all 0.25s ease;
      box-shadow: 0 4px 15px rgba(0, 0, 0, 0.25);
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

   .notification-btn:hover {
      transform: translateY(-2px);
      box-shadow: 0 6px 20px rgba(200, 168, 75, 0.35);
      background: linear-gradient(135deg, rgba(200, 168, 75, 0.25), rgba(232, 204, 122, 0.3));
   }

   .notification-badge {
      display: flex;
      align-items: center;
      justify-content: center;
      width: 22px;
      height: 22px;
      background: #e05e5e;
      color: #fff;
      font-size: 0.75rem;
      font-weight: 800;
      border-radius: 50%;
      box-shadow: 0 2px 5px rgba(0, 0, 0, 0.3);
      animation: pulse 2.5s infinite;
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

   .btn-download {
      padding: 8px 16px;
      border-radius: 6px;
      border: 1px solid rgba(200, 168, 75, 0.45);
      background: rgba(200, 168, 75, 0.15);
      color: #e8cc7a;
      text-decoration: none;
      font-weight: 600;
      cursor: pointer;
      font-family: 'Jost', sans-serif;
      transition: all 0.2s ease;
      display: inline-flex;
      align-items: center;
      justify-content: center;
   }

   .btn-download:hover {
      background: rgba(200, 168, 75, 0.28);
      border-color: rgba(212, 177, 90, 0.6);
      transform: translateY(-1px);
      color: #e8cc7a;
   }

   .btn-upload {
      padding: 8px 16px;
      border-radius: 6px;
      border: 1px solid rgba(92, 170, 120, 0.45);
      background: rgba(92, 170, 120, 0.15);
      color: #9fd4b0;
      font-weight: 600;
      cursor: pointer;
      font-family: 'Jost', sans-serif;
      transition: all 0.2s ease;
   }

   .btn-upload:hover {
      background: rgba(92, 170, 120, 0.28);
      transform: translateY(-1px);
   }

   .import-panel {
      background: rgba(16, 36, 23, 0.6);
      border: 1px solid rgba(255, 255, 255, 0.1);
      border-radius: 12px;
      padding: 18px;
      margin-bottom: 20px;
   }

   .import-status {
      display: inline-block;
      padding: 3px 8px;
      border-radius: 6px;
      font-size: 0.75rem;
      font-weight: 700;
      letter-spacing: 0.3px;
   }

   .import-status-ready {
      background: rgba(92, 170, 120, 0.15);
      color: #5caa78;
      border: 1px solid rgba(92, 170, 120, 0.35);
   }

   .import-status-duplicate,
   .import-status-duplicate_in_file {
      background: rgba(212, 177, 90, 0.15);
      color: #d4b15a;
      border: 1px solid rgba(212, 177, 90, 0.35);
   }

   .import-status-member_not_found,
   .import-status-invalid {
      background: rgba(184, 65, 65, 0.15);
      color: #ffd1d1;
      border: 1px solid rgba(184, 65, 65, 0.35);
   }

   .btn-action {
      display: inline-flex;
      align-items: center;
      justify-content: center;
      padding: 6px 12px;
      border-radius: 6px;
      font-size: 0.78rem;
      font-weight: 700;
      text-decoration: none;
      cursor: pointer;
      border: 1px solid transparent;
      font-family: 'Jost', sans-serif;
      transition: all 0.2s ease;
      letter-spacing: 0.3px;
   }

   .btn-action-edit {
      background: rgba(212, 177, 90, 0.15);
      color: #e8cc7a;
      border-color: rgba(212, 177, 90, 0.4);
   }

   .btn-action-edit:hover {
      background: rgba(212, 177, 90, 0.28);
   }

   .btn-action-detail {
      background: rgba(92, 170, 120, 0.15);
      color: #9fd4b0;
      border-color: rgba(92, 170, 120, 0.4);
   }

   .btn-action-detail:hover {
      background: rgba(92, 170, 120, 0.28);
      color: #9fd4b0;
   }

   .col-point {
      font-weight: 700;
      color: #e8cc7a;
      font-family: monospace;
      text-align: right;
   }

   .action-group {
      display: flex;
      gap: 6px;
      justify-content: center;
      flex-wrap: wrap;
   }

   @keyframes pulse {
      0% {
         transform: scale(1);
      }

      50% {
         transform: scale(1.1);
         box-shadow: 0 0 10px rgba(224, 94, 94, 0.6);
      }

      100% {
         transform: scale(1);
      }
   }
</style>

<section style="padding: 120px 5% 60px; min-height: 70vh;">
   <div
      style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 24px; flex-wrap: wrap; gap: 16px;">
      <div>
         <h1
            style="margin: 0 0 4px 0; font-family: 'Cormorant Garamond', serif; font-size: clamp(2rem, 5vw, 3rem); font-weight: 400;">
            Settings - Member</h1>
         <p style="margin: 0; opacity: 0.85;">Kelola data member dan point transaksi</p>
         <form id="searchForm" method="GET"
            style="display:flex; gap:8px; align-items:center; flex-wrap:wrap; margin-top:12px;">
            <input type="text" name="search" placeholder="Search members..." value="{{ search }}"
               style="padding:8px 100px; border-radius:6px; border:1px solid rgba(255,255,255,0.2); background:rgba(255,255,255,0.04); color:#fff;" />
            <button type="submit" class="btn-cari">Cari</button>
            {% if search is not empty %}
            <a href="{{ url('settings/member') }}" class="btn-reset">Reset</a>
            {% endif %}
            <a href="{{ url('settings/download_member_csv') }}{% if search is not empty %}?{{ http_build_query({'search': search}) }}{% endif %}"
               class="btn-download">Download CSV</a>
            <button type="button" class="btn-upload" id="togglePointImportBtn">Import Point CSV</button>
            <button type="button" class="btn-upload" id="toggleOrderImportBtn" style="border-color:rgba(120,160,220,0.45); color:#a8c4f0;">Import Riwayat Transaksi</button>
            <select name="per_page"
               style="padding:8px 12px; border-radius:6px; border:1px solid rgba(255,255,255,0.2); background:#203729; color:#fff;" hidden>
               <option value="10" {% if perPage==10 %}selected{% endif %}>10 per page</option>
               <option value="25" {% if perPage==25 %}selected{% endif %}>25 per page</option>
               <option value="50" {% if perPage==50 %}selected{% endif %}>50 per page</option>
            </select>
         </form>
      </div>

      {% if pendingCount > 0 %}
      <div>
         <a href="{{ url('settings/registrasi') }}" class="notification-btn">
            <span class="notification-badge">{{ pendingCount }}</span>
            <span>Registrasi Pending Menunggu Approval</span>
         </a>
      </div>
      {% endif %}
   </div>

   {% if updateSuccess %}
   <div
      style="padding:12px 16px; border:1px solid #2a9d52; background:#11361f; color:#c9f7d8; border-radius:10px; margin-bottom:18px; font-weight: 500;">
      {{ updateSuccess }}
   </div>
   {% endif %}

   {% if updateError %}
   <div
      style="padding:12px 16px; border:1px solid #b84141; background:#3a1616; color:#ffd1d1; border-radius:10px; margin-bottom:18px; font-weight: 500;">
      {{ updateError }}
   </div>
   {% endif %}

   {% if pointImportSuccess %}
   <div
      style="padding:12px 16px; border:1px solid #2a9d52; background:#11361f; color:#c9f7d8; border-radius:10px; margin-bottom:18px; font-weight: 500;">
      {{ pointImportSuccess }}
   </div>
   {% endif %}

   {% if pointImportError %}
   <div
      style="padding:12px 16px; border:1px solid #b84141; background:#3a1616; color:#ffd1d1; border-radius:10px; margin-bottom:18px; font-weight: 500;">
      {{ pointImportError }}
   </div>
   {% endif %}

   {% if orderImportSuccess %}
   <div
      style="padding:12px 16px; border:1px solid #2a9d52; background:#11361f; color:#c9f7d8; border-radius:10px; margin-bottom:18px; font-weight: 500;">
      {{ orderImportSuccess }}
   </div>
   {% endif %}

   {% if orderImportError %}
   <div
      style="padding:12px 16px; border:1px solid #b84141; background:#3a1616; color:#ffd1d1; border-radius:10px; margin-bottom:18px; font-weight: 500;">
      {{ orderImportError }}
   </div>
   {% endif %}

   <div class="import-panel" id="orderImportPanel" {% if orderImportOrdersPreview is empty %}style="display:none;"{% endif %}>
      <h3 style="margin:0 0 12px; font-family:'Cormorant Garamond',serif; color:#a8c4f0; font-size:1.35rem;">
         Import Riwayat Transaksi (orders + order_items)</h3>
      <p style="margin:0 0 14px; opacity:0.85; font-size:0.9rem;">
         Upload 2 file CSV sekaligus. Maks. 5MB per file. Duplikat <code>kode_order</code> (orders) dan
         <code>kode_order + item</code> (order_items) akan dilewati.
      </p>

      {% if orderImportOrdersPreview is empty %}
      <form method="post" action="{{ url('settings/upload_order_history') }}" enctype="multipart/form-data"
         style="display:grid; gap:12px; max-width:720px;">
         <label style="display:grid; gap:6px;">
            <span style="font-size:0.85rem; font-weight:600; opacity:0.85;">orders.csv</span>
            <input type="file" name="orders_csv" accept=".csv,text/csv" required
               style="padding:8px; border-radius:6px; border:1px solid rgba(255,255,255,0.2); background:rgba(255,255,255,0.04); color:#fff;" />
         </label>
         <label style="display:grid; gap:6px;">
            <span style="font-size:0.85rem; font-weight:600; opacity:0.85;">order_items.csv</span>
            <input type="file" name="order_items_csv" accept=".csv,text/csv" required
               style="padding:8px; border-radius:6px; border:1px solid rgba(255,255,255,0.2); background:rgba(255,255,255,0.04); color:#fff;" />
         </label>
         <div>
            <button type="submit" class="btn-cari">Upload &amp; Preview</button>
         </div>
      </form>
      {% else %}
      <div style="margin-bottom:12px; color:#e8cc7a; font-size:0.9rem;">
         <div><strong>orders:</strong> {{ orderImportOrdersFileName }}
            {% if orderImportSummary['orders'] is defined %}
            — Total {{ orderImportSummary['orders']['total'] }},
            siap {{ orderImportSummary['orders']['ready'] }},
            duplikat {{ orderImportSummary['orders']['duplicate'] + orderImportSummary['orders']['duplicate_in_file'] }},
            invalid {{ orderImportSummary['orders']['invalid'] }}
            {% endif %}
         </div>
         <div style="margin-top:4px;"><strong>order_items:</strong> {{ orderImportItemsFileName }}
            {% if orderImportSummary['items'] is defined %}
            — Total {{ orderImportSummary['items']['total'] }},
            siap {{ orderImportSummary['items']['ready'] }},
            duplikat {{ orderImportSummary['items']['duplicate'] + orderImportSummary['items']['duplicate_in_file'] }},
            invalid {{ orderImportSummary['items']['invalid'] }}
            {% endif %}
         </div>
      </div>

      <h4 style="margin:0 0 8px; color:#d4b15a; font-size:1rem;">Preview orders (10 baris pertama)</h4>
      <div class="table-responsive"
         style="overflow-x:auto; max-height:280px; border:1px solid rgba(255,255,255,0.08); border-radius:8px; margin-bottom:14px;">
         <table class="table table-sm text-white" style="width:100%; border-collapse:collapse; min-width:1000px;">
            <thead>
               <tr style="background:rgba(0,0,0,0.25); position:sticky; top:0;">
                  <th style="padding:8px;">Baris</th>
                  <th style="padding:8px;">Jenis</th>
                  <th style="padding:8px;">Kode Order</th>
                  <th style="padding:8px;">Tanggal</th>
                  <th style="padding:8px;">Jam</th>
                  <th style="padding:8px;">Nama</th>
                  <th style="padding:8px;">Total Bayar</th>
                  <th style="padding:8px;">Status</th>
               </tr>
            </thead>
            <tbody>
               {% for row in orderImportOrdersPreview %}
               <tr>
                  <td style="padding:8px; border-bottom:1px solid rgba(255,255,255,.08);">{{ row['line'] }}</td>
                  <td style="padding:8px; border-bottom:1px solid rgba(255,255,255,.08);">{{ row['jenis'] }}</td>
                  <td style="padding:8px; border-bottom:1px solid rgba(255,255,255,.08); font-family:monospace;">{{ row['kode_order'] }}</td>
                  <td style="padding:8px; border-bottom:1px solid rgba(255,255,255,.08);">{{ row['tanggal'] }}</td>
                  <td style="padding:8px; border-bottom:1px solid rgba(255,255,255,.08);">{{ row['jam'] }}</td>
                  <td style="padding:8px; border-bottom:1px solid rgba(255,255,255,.08);">{{ row['nama'] }}</td>
                  <td style="padding:8px; border-bottom:1px solid rgba(255,255,255,.08);">{{ row['total_bayar'] }}</td>
                  <td style="padding:8px; border-bottom:1px solid rgba(255,255,255,.08);">
                     <span class="import-status import-status-{{ row['status'] }}">{{ row['status']|upper }}</span>
                     {% if row['message'] %}<div style="font-size:0.72rem; opacity:0.8; margin-top:3px;">{{ row['message'] }}</div>{% endif %}
                  </td>
               </tr>
               {% endfor %}
            </tbody>
         </table>
      </div>

      <h4 style="margin:0 0 8px; color:#d4b15a; font-size:1rem;">Preview order_items (10 baris pertama)</h4>
      <div id="order-import-preview" class="table-responsive"
         style="overflow-x:auto; max-height:280px; border:1px solid rgba(255,255,255,0.08); border-radius:8px; margin-bottom:14px;">
         <table class="table table-sm text-white" style="width:100%; border-collapse:collapse; min-width:900px;">
            <thead>
               <tr style="background:rgba(0,0,0,0.25); position:sticky; top:0;">
                  <th style="padding:8px;">Baris</th>
                  <th style="padding:8px;">Jenis</th>
                  <th style="padding:8px;">Kode Order</th>
                  <th style="padding:8px;">Item</th>
                  <th style="padding:8px;">Qty</th>
                  <th style="padding:8px;">Satuan</th>
                  <th style="padding:8px;">Total</th>
                  <th style="padding:8px;">Status</th>
               </tr>
            </thead>
            <tbody>
               {% for row in orderImportItemsPreview %}
               <tr>
                  <td style="padding:8px; border-bottom:1px solid rgba(255,255,255,.08);">{{ row['line'] }}</td>
                  <td style="padding:8px; border-bottom:1px solid rgba(255,255,255,.08);">{{ row['jenis'] }}</td>
                  <td style="padding:8px; border-bottom:1px solid rgba(255,255,255,.08); font-family:monospace;">{{ row['kode_order'] }}</td>
                  <td style="padding:8px; border-bottom:1px solid rgba(255,255,255,.08);">{{ row['item'] }}</td>
                  <td style="padding:8px; border-bottom:1px solid rgba(255,255,255,.08);">{{ row['qty'] }}</td>
                  <td style="padding:8px; border-bottom:1px solid rgba(255,255,255,.08);">{{ row['satuan'] }}</td>
                  <td style="padding:8px; border-bottom:1px solid rgba(255,255,255,.08);">{{ row['total'] }}</td>
                  <td style="padding:8px; border-bottom:1px solid rgba(255,255,255,.08);">
                     <span class="import-status import-status-{{ row['status'] }}">{{ row['status']|upper }}</span>
                     {% if row['message'] %}<div style="font-size:0.72rem; opacity:0.8; margin-top:3px;">{{ row['message'] }}</div>{% endif %}
                  </td>
               </tr>
               {% endfor %}
            </tbody>
         </table>
      </div>

      {% set orderReady = orderImportSummary['orders']['ready'] %}
      {% set itemReady = orderImportSummary['items']['ready'] %}
      <div style="display:flex; gap:10px; flex-wrap:wrap;">
         <form method="post" action="{{ url('settings/confirm_order_history_import') }}">
            <input type="hidden" name="import_token" value="{{ orderImportToken }}">
            <button type="submit" class="btn-cari" {% if orderReady + itemReady == 0 %}disabled{% endif %}>
               Konfirmasi Import ({{ orderReady + itemReady }})
            </button>
         </form>
         <a href="{{ url('settings/cancel_order_history_import') }}" class="btn-reset">Batal</a>
      </div>
      {% endif %}
   </div>

   <div class="import-panel" id="pointImportPanel" {% if pointImportPreview is empty %}style="display:none;"{% endif %}>
      <h3 style="margin:0 0 12px; font-family:'Cormorant Garamond',serif; color:#d4b15a; font-size:1.35rem;">
         Import Point Member (CSV)</h3>
      <p style="margin:0 0 14px; opacity:0.85; font-size:0.9rem;">
         Kolom wajib: no_hp, tgl_transaksi, kode_order, nominal_transaksi, jenis_transaksi, point, kategori.
         Maks. 5MB. Duplikat <code>kode_order</code> akan dilewati.
      </p>

      {% if pointImportPreview is empty %}
      <form method="post" action="{{ url('settings/upload_point_member') }}" enctype="multipart/form-data"
         style="display:flex; gap:10px; align-items:center; flex-wrap:wrap;">
         <input type="file" name="csv_file" accept=".csv,text/csv" required
            style="padding:8px; border-radius:6px; border:1px solid rgba(255,255,255,0.2); background:rgba(255,255,255,0.04); color:#fff; max-width:100%;" />
         <button type="submit" class="btn-cari">Upload &amp; Preview</button>
      </form>
      {% else %}
      <div style="margin-bottom:12px; color:#e8cc7a; font-size:0.9rem;">
         File: <strong>{{ pointImportFileName }}</strong>
         {% if pointImportSummary %}
         — Total {{ pointImportSummary['total'] }} Data,
         siap impor {{ pointImportSummary['ready'] }},
         duplikat {{ (pointImportSummary['duplicate']) + (pointImportSummary['duplicate_in_file']) }},
         member tidak ditemukan {{ pointImportSummary['member_not_found'] }},
         invalid {{ pointImportSummary['invalid'] }}
         {% endif %}
      </div>

      <div id="point-import-preview" class="table-responsive"
         style="overflow-x:auto; max-height:360px; border:1px solid rgba(255,255,255,0.08); border-radius:8px; margin-bottom:14px;">
         <table class="table table-sm text-white" style="width:100%; border-collapse:collapse; min-width:900px;">
            <thead>
               <tr style="background:rgba(0,0,0,0.25); position:sticky; top:0;">
                  <th style="padding:10px;">Baris</th>
                  <th style="padding:10px;">No HP</th>
                  <th style="padding:10px;">Member</th>
                  <th style="padding:10px;">Tgl Transaksi</th>
                  <th style="padding:10px;">Kode Order</th>
                  <th style="padding:10px;">Nominal</th>
                  <th style="padding:10px;">Jenis</th>
                  <th style="padding:10px;">Point</th>
                  <th style="padding:10px;">Kategori</th>
                  <th style="padding:10px;">Status</th>
               </tr>
            </thead>
            <tbody>
               {# {% for row in pointImportPreview if row['status'] == 'ready' %} #}
               {% for row in pointImportPreview %}
               <tr>
                  <td style="padding:10px; border-bottom:1px solid rgba(255,255,255,.08);">{{ row['line'] }}</td>
                  <td style="padding:10px; border-bottom:1px solid rgba(255,255,255,.08);">{{ row['no_hp'] }}</td>
                  <td style="padding:10px; border-bottom:1px solid rgba(255,255,255,.08);">
                     {{ row['member_nama'] ? row['member_nama'] : '—' }}</td>
                  <td style="padding:10px; border-bottom:1px solid rgba(255,255,255,.08);">{{ row['tgl_transaksi'] }}</td>
                  <td style="padding:10px; border-bottom:1px solid rgba(255,255,255,.08); font-family:monospace;">{{ row['kode_order'] }}</td>
                  <td style="padding:10px; border-bottom:1px solid rgba(255,255,255,.08);">{{ row['nominal_transaksi'] }}</td>
                  <td style="padding:10px; border-bottom:1px solid rgba(255,255,255,.08);">{{ row['jenis_transaksi'] }}</td>
                  <td style="padding:10px; border-bottom:1px solid rgba(255,255,255,.08);">{{ row['point'] }}</td>
                  <td style="padding:10px; border-bottom:1px solid rgba(255,255,255,.08);">{{ row['kategori'] }}</td>
                  <td style="padding:10px; border-bottom:1px solid rgba(255,255,255,.08);">
                     <span class="import-status import-status-{{ row['status'] }}">{{ row['status']|upper }}</span>
                     {% if row['message'] %}
                     <div style="font-size:0.75rem; opacity:0.8; margin-top:4px;">{{ row['message'] }}</div>
                     {% endif %}
                  </td>
               </tr>
               {% endfor %}
            </tbody>
         </table>
      </div>

      <div style="display:flex; gap:10px; flex-wrap:wrap;">
         <form method="post" action="{{ url('settings/confirm_point_member_import') }}">
            <input type="hidden" name="import_token" value="{{ pointImportToken }}">
            <button type="submit" class="btn-cari"
               {% if pointImportSummary['ready'] is defined and pointImportSummary['ready'] == 0 %}disabled{% endif %}>
               Konfirmasi Import ({{ pointImportSummary['ready'] }})
            </button>
         </form>
         <a href="{{ url('settings/cancel_point_member_import') }}" class="btn-reset">Batal</a>
      </div>
      {% endif %}
   </div>

   {% if members is empty %}
   <div
      style="background: rgba(16, 36, 23, 0.6); border: 1px solid rgba(255,255,255,0.1); border-radius: 12px; padding: 30px; text-align: center;">
      <p style="margin: 0; opacity: 0.7;">Data member belum tersedia.</p>
   </div>
   {% else %}
   <div class="table-responsive"
      style="overflow-x: auto; background: rgba(16, 36, 23, 0.6); border: 1px solid rgba(255,255,255,0.1); border-radius: 12px; padding: 10px;">
      <div style="margin-bottom:8px; color:#e8cc7a; font-size:0.9rem;">
         Menampilkan {{ ((currentPage - 1) * perPage) + 1 }} – {{ ((currentPage - 1) * perPage) + members|length }} dari
         {{ totalMembers }} member
      </div>
      <table class="table table-sm text-white" style="width:100%; border-collapse: collapse; min-width: 800px;">
         <thead>
            <tr style="background: rgba(0,0,0,0.25);">
               <th style="text-align:left; padding:14px 12px; border-bottom:2px solid rgba(255,255,255,.15);">No. Member
               </th>
               <th style="text-align:left; padding:14px 12px; border-bottom:2px solid rgba(255,255,255,.15);">Nama</th>
               <th style="text-align:left; padding:14px 12px; border-bottom:2px solid rgba(255,255,255,.15);">Email</th>
               <th style="text-align:left; padding:14px 12px; border-bottom:2px solid rgba(255,255,255,.15);">No. HP
               </th>
               <th style="text-align:center; padding:14px 12px; border-bottom:2px solid rgba(255,255,255,.15);">Role
               </th>
               <th style="text-align:center; padding:14px 12px; border-bottom:2px solid rgba(255,255,255,.15);">Status
               </th>
               <th style="text-align:right; padding:14px 12px; border-bottom:2px solid rgba(255,255,255,.15);">Point
               </th>
               <th style="text-align:left; padding:14px 12px; border-bottom:2px solid rgba(255,255,255,.15);">Tgl Daftar
               </th>
               <th style="text-align:center; padding:14px 12px; border-bottom:2px solid rgba(255,255,255,.15);">Aksi
               </th>
            </tr>
         </thead>
         <tbody id="memberTableBody">
            {% for m in members %}
            <tr class="member-row" 
               data-id="{{ m['id'] }}" 
               data-no-member="{{ m['no_member'] }}"
               data-nama="{{ m['nama'] }}" 
               data-email="{{ m['email'] }}" 
               data-no-hp="{{ m['no_hp'] }}"
               data-tgl-lahir="{{ m['tgl_lahir'] }}"
               data-gender="{{ m['gender'] }}"
               data-kota="{{ m['kota'] }}"
               data-alamat="{{ m['alamat'] }}"
               data-role="{{ m['role'] }}" 
               data-is-active="{{ m['is_active'] ? '1' : '0' }}">
               <td
                  style="padding:14px 12px; border-bottom:1px solid rgba(255,255,255,.08); font-family: monospace; font-size: 0.95rem; color: #e8cc7a; font-weight: 600;">
                  {{ m['no_member'] }}</td>
               <td style="padding:14px 12px; border-bottom:1px solid rgba(255,255,255,.08); font-weight: 600;">{{
                  m['nama'] }}</td>
               <td style="padding:14px 12px; border-bottom:1px solid rgba(255,255,255,.08); opacity: 0.9;">{{ m['email']
                  }}</td>
               <td style="padding:14px 12px; border-bottom:1px solid rgba(255,255,255,.08); opacity: 0.9;">{{ m['no_hp']
                  }}</td>
               <td style="padding:14px 12px; border-bottom:1px solid rgba(255,255,255,.08); text-align: center;"><span
                     class="badge-role">{{ m['role']|upper }}</span></td>
               <td style="padding:14px 12px; border-bottom:1px solid rgba(255,255,255,.08); text-align: center;">
                  {% if m['is_active'] %}<span class="badge-active">AKTIF</span>{% else %}<span
                     class="badge-inactive">NONAKTIF</span>{% endif %}
               </td>
               <td class="col-point" style="padding:14px 12px; border-bottom:1px solid rgba(255,255,255,.08);">
                  {{ Helpers.number(m['total_point']) }}</td>
               <td
                  style="padding:14px 12px; border-bottom:1px solid rgba(255,255,255,.08); font-size: 0.85rem; opacity: 0.8;">
                  {{ m['tgl_daftar'] }}</td>
               <td style="padding:14px 12px; border-bottom:1px solid rgba(255,255,255,.08); text-align:center;">
                  <div class="action-group">
                     <button type="button" class="btn-action btn-action-edit btn-member-edit">Edit</button>
                     <a href="{{ url('settings/member_point_detail/' ~ m['id']) }}"
                        class="btn-action btn-action-detail">Detail</a>
                  </div>
               </td>
            </tr>
            {% endfor %}
         </tbody>
      </table>
      <!-- Pagination Controls -->
      <div style="display:flex; justify-content:center; align-items:center; margin-top:12px; gap:8px;">
         {% set prevPage = currentPage > 1 ? currentPage - 1 : 1 %}
         {% set nextPage = currentPage < totalPages ? currentPage + 1 : totalPages %}
         
         {% if currentPage==1 %} 
            <span class="pagination-link disabled">Previous</span>
         {% else %}
            <a href="{{ url('settings/member') }}?{{ http_build_query({'search': search, 'page': prevPage, 'per_page': perPage}) }}"
               class="pagination-link">Previous</a>
         {% endif %}
            {% for i in 1..totalPages %}
            {% if i == currentPage %}
            <span class="pagination-link active">{{ i }}</span>
            {% else %}
            <a href="{{ url('settings/member') }}?{{ http_build_query({'search': search, 'page': i, 'per_page': perPage}) }}"
               class="pagination-link">{{ i }}</a>
            {% endif %}
            {% endfor %}
            {% if currentPage == totalPages %}
            <span class="pagination-link disabled">Next</span>
            {% else %}
            <a href="{{ url('settings/member') }}?{{ http_build_query({'search': search, 'page': nextPage, 'per_page': perPage}) }}"
               class="pagination-link">Next</a>
            {% endif %}
      </div>
   </div>
   {% endif %}
</section>

<!-- MODAL EDIT MEMBER -->
<div id="memberModal"
   style="display:none; position:fixed; inset:0; background:rgba(0,0,0,.65); z-index:9999; align-items:center; justify-content:center; backdrop-filter: blur(4px);">
   <div
      style="width:min(620px, 92vw); max-height:90vh; overflow-y:auto; background:#102417; color:#fff; border:1px solid rgba(255,255,255,.2); border-radius:16px; padding:24px; box-shadow: 0 10px 25px rgba(0,0,0,0.5);">
      <h3
         style="margin:0 0 18px; font-size: 1.5rem; color:#d4b15a; border-bottom: 1px solid rgba(255,255,255,0.1); padding-bottom: 10px; font-family: 'Cormorant Garamond', serif;">
         Edit Member</h3>
      <form method="post" action="{{ url('settings/update_member') }}" id="memberForm">
         <input type="hidden" name="id" id="formId">

         <div style="margin-bottom:14px;">
            <label
               style="display:block; margin-bottom:6px; font-weight: 600; font-size: 0.85rem; letter-spacing: 0.5px; opacity: 0.8;">NOMOR
               MEMBER</label>
            <input id="formNoMember" type="text" readonly
               style="width:100%; padding:10px; border-radius:8px; border:1px solid rgba(255,255,255,.15); background:rgba(255,255,255,0.04); color:rgba(255,255,255,0.6); font-family: monospace;">
         </div>

         <div style="margin-bottom:14px;">
            <label for="formNama"
               style="display:block; margin-bottom:6px; font-weight: 600; font-size: 0.85rem; letter-spacing: 0.5px;">NAMA
               LENGKAP</label>
            <input id="formNama" name="nama" type="text" required
               style="width:100%; padding:10px; border-radius:8px; border:1px solid rgba(255,255,255,.2); background:#203729; color:#fff; font-family: 'Jost', sans-serif;">
         </div>

         <div style="margin-bottom:14px;">
            <label for="formEmail"
               style="display:block; margin-bottom:6px; font-weight: 600; font-size: 0.85rem; letter-spacing: 0.5px;">EMAIL</label>
            <input id="formEmail" name="email" type="email" required
               style="width:100%; padding:10px; border-radius:8px; border:1px solid rgba(255,255,255,.2); background:#203729; color:#fff; font-family: 'Jost', sans-serif;">
         </div>

         <div style="margin-bottom:14px;">
            <label for="formNoHp"
               style="display:block; margin-bottom:6px; font-weight: 600; font-size: 0.85rem; letter-spacing: 0.5px;">NO
               TELEPON</label>
            <input id="formNoHp" name="no_hp" type="tel" required
               style="width:100%; padding:10px; border-radius:8px; border:1px solid rgba(255,255,255,.2); background:#203729; color:#fff; font-family: 'Jost', sans-serif;">
         </div>

         <div style="margin-bottom:14px; display: grid; grid-template-columns: 1fr 1fr; gap: 12px;">
            <div>
               <label for="formTglLahir"
                  style="display:block; margin-bottom:6px; font-weight: 600; font-size: 0.85rem; letter-spacing: 0.5px;">TANGGAL
                  LAHIR</label>
               <input id="formTglLahir" name="tgl_lahir" type="date" required
                  style="width:100%; padding:10px; border-radius:8px; border:1px solid rgba(255,255,255,.2); background:#203729; color:#fff; font-family: 'Jost', sans-serif;">
            </div>
            <div>
               <label for="formGender"
                  style="display:block; margin-bottom:6px; font-weight: 600; font-size: 0.85rem; letter-spacing: 0.5px;">JENIS
                  KELAMIN</label>
               <select id="formGender" name="gender" required
                  style="width:100%; padding:10px; border-radius:8px; border:1px solid rgba(255,255,255,.2); background:#203729; color:#fff; cursor: pointer; font-family: 'Jost', sans-serif;">
                  <option value="L">Laki-laki</option>
                  <option value="P">Perempuan</option>
               </select>
            </div>
         </div>

         <div style="margin-bottom:14px;">
            <label for="formKota"
               style="display:block; margin-bottom:6px; font-weight: 600; font-size: 0.85rem; letter-spacing: 0.5px;">KOTA</label>
            <input id="formKota" name="kota" type="text" required
               style="width:100%; padding:10px; border-radius:8px; border:1px solid rgba(255,255,255,.2); background:#203729; color:#fff; font-family: 'Jost', sans-serif;">
         </div>

         <div style="margin-bottom:14px;">
            <label for="formAlamat"
               style="display:block; margin-bottom:6px; font-weight: 600; font-size: 0.85rem; letter-spacing: 0.5px;">ALAMAT</label>
            <input id="formAlamat" name="alamat" type="text" required
               style="width:100%; padding:10px; border-radius:8px; border:1px solid rgba(255,255,255,.2); background:#203729; color:#fff; font-family: 'Jost', sans-serif;">
         </div>

         <div style="margin-bottom:14px; display: grid; grid-template-columns: 1fr 1fr; gap: 12px;">
            <div>
               <label for="formRole"
                  style="display:block; margin-bottom:6px; font-weight: 600; font-size: 0.85rem; letter-spacing: 0.5px;">ROLE</label>
               <select id="formRole" name="role" required
                  style="width:100%; padding:10px; border-radius:8px; border:1px solid rgba(255,255,255,.2); background:#203729; color:#fff; cursor: pointer; font-family: 'Jost', sans-serif;">
                  <option value="member">MEMBER</option>
                  <option value="admin">ADMIN</option>
               </select>
            </div>
            <div>
               <label for="formIsActive"
                  style="display:block; margin-bottom:6px; font-weight: 600; font-size: 0.85rem; letter-spacing: 0.5px;">STATUS</label>
               <select id="formIsActive" name="is_active" required
                  style="width:100%; padding:10px; border-radius:8px; border:1px solid rgba(255,255,255,.2); background:#203729; color:#fff; cursor: pointer; font-family: 'Jost', sans-serif;">
                  <option value="1">AKTIF</option>
                  <option value="0">NONAKTIF</option>
               </select>
            </div>
         </div>

         <div
            style="display:flex; gap:10px; justify-content:flex-end; border-top: 1px solid rgba(255,255,255,0.1); padding-top: 15px;">
            <button type="button" id="closeMemberModalBtn"
               style="padding:10px 18px; border-radius:8px; border:1px solid rgba(255,255,255,.25); background:transparent; color:#fff; cursor: pointer;">Batal</button>
            <button type="submit"
               style="padding:10px 18px; border-radius:8px; border:none; background:#d4b15a; color:#102417; font-weight:700; cursor: pointer;">Simpan</button>
         </div>
      </form>
   </div>
</div>

<script>
   (function () {
      const modal = document.getElementById('memberModal');
      const closeBtn = document.getElementById('closeMemberModalBtn');
      const tableBody = document.getElementById('memberTableBody');

      const formId = document.getElementById('formId');
      const formNoMember = document.getElementById('formNoMember');
      const formNama = document.getElementById('formNama');
      const formEmail = document.getElementById('formEmail');
      const formNoHp = document.getElementById('formNoHp');
      const formTglLahir = document.getElementById('formTglLahir');
      const formGender = document.getElementById('formGender');
      const formKota = document.getElementById('formKota');
      const formAlamat = document.getElementById('formAlamat');
      const formRole = document.getElementById('formRole');
      const formIsActive = document.getElementById('formIsActive');

      function formatDateForInput(value) {
         if (!value) return '';
         const str = String(value).trim();
         if (/^\d{4}-\d{2}-\d{2}/.test(str)) {
            return str.substring(0, 10);
         }
         const parsed = new Date(str);
         if (Number.isNaN(parsed.getTime())) return '';
         return parsed.toISOString().substring(0, 10);
      }

      function openModalForEdit(row) {
         formId.value = row.dataset.id || '';
         formNoMember.value = row.dataset.noMember || '';
         formNama.value = row.dataset.nama || '';
         formEmail.value = row.dataset.email || '';
         formNoHp.value = row.dataset.noHp || '';
         formTglLahir.value = formatDateForInput(row.dataset.tglLahir);
         formGender.value = row.dataset.gender || 'L';
         formKota.value = row.dataset.kota || '';
         formAlamat.value = row.dataset.alamat || '';
         formRole.value = row.dataset.role || 'member';
         formIsActive.value = row.dataset.isActive || '1';

         modal.style.display = 'flex';
      }

      function closeModal() {
         modal.style.display = 'none';
      }



      if (tableBody) {
         tableBody.addEventListener('click', function (event) {
            const editBtn = event.target.closest('.btn-member-edit');
            if (!editBtn) return;
            const row = editBtn.closest('.member-row');
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

      const togglePointImportBtn = document.getElementById('togglePointImportBtn');
      const pointImportPanel = document.getElementById('pointImportPanel');
      if (togglePointImportBtn && pointImportPanel) {
         togglePointImportBtn.addEventListener('click', function () {
            const isHidden = pointImportPanel.style.display === 'none';
            pointImportPanel.style.display = isHidden ? 'block' : 'none';
         });
      }

      const toggleOrderImportBtn = document.getElementById('toggleOrderImportBtn');
      const orderImportPanel = document.getElementById('orderImportPanel');
      if (toggleOrderImportBtn && orderImportPanel) {
         toggleOrderImportBtn.addEventListener('click', function () {
            const isHidden = orderImportPanel.style.display === 'none';
            orderImportPanel.style.display = isHidden ? 'block' : 'none';
         });
      }

      if (window.location.hash === '#point-import-preview' && pointImportPanel) {
         pointImportPanel.style.display = 'block';
         pointImportPanel.scrollIntoView({ behavior: 'smooth', block: 'start' });
      }

      if (window.location.hash === '#order-import-preview' && orderImportPanel) {
         orderImportPanel.style.display = 'block';
         orderImportPanel.scrollIntoView({ behavior: 'smooth', block: 'start' });
      }
   })();
</script>