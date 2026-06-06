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
   }

   .badge-masuk {
      background: rgba(92, 170, 120, 0.15);
      color: #5caa78;
      border: 1px solid rgba(92, 170, 120, 0.35);
      padding: 4px 8px;
      border-radius: 6px;
      font-size: 0.8rem;
      font-weight: 700;
      text-transform: uppercase;
   }

   .badge-keluar {
      background: rgba(184, 65, 65, 0.15);
      color: #ffd1d1;
      border: 1px solid rgba(184, 65, 65, 0.35);
      padding: 4px 8px;
      border-radius: 6px;
      font-size: 0.8rem;
      font-weight: 700;
      text-transform: uppercase;
   }

   .btn-back {
      display: inline-flex;
      align-items: center;
      gap: 8px;
      padding: 8px 16px;
      border-radius: 6px;
      border: 1px solid rgba(255, 255, 255, 0.2);
      background: rgba(255, 255, 255, 0.08);
      color: #fff;
      text-decoration: none;
      font-weight: 600;
      transition: all 0.2s ease;
   }

   .btn-back:hover {
      background: rgba(255, 255, 255, 0.15);
      color: #fff;
   }

   .info-card,
   .table-card {
      background: rgba(16, 36, 23, 0.6);
      border: 1px solid rgba(255, 255, 255, 0.1);
      border-radius: 12px;
      padding: 20px;
      margin-bottom: 20px;
   }

   .info-grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
      gap: 14px 20px;
   }

   .info-label {
      font-size: 0.75rem;
      letter-spacing: 0.5px;
      text-transform: uppercase;
      opacity: 0.7;
      margin-bottom: 4px;
      font-weight: 600;
   }

   .info-value {
      font-size: 0.95rem;
      font-weight: 600;
   }

   .point-highlight {
      font-family: 'Cormorant Garamond', serif;
      font-size: 2rem;
      color: #e8cc7a;
      font-weight: 600;
   }

   .text-point-keluar {
      color: #ffd1d1;
   }

   .text-point-masuk {
      color: #9fd4b0;
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

   .btn-order-detail {
      display: inline-flex;
      align-items: center;
      justify-content: center;
      padding: 5px 12px;
      border-radius: 6px;
      font-size: 0.78rem;
      font-weight: 700;
      text-decoration: none;
      background: rgba(120, 160, 220, 0.15);
      color: #a8c4f0;
      border: 1px solid rgba(120, 160, 220, 0.4);
      transition: all 0.2s ease;
      white-space: nowrap;
   }

   .btn-order-detail:hover {
      background: rgba(120, 160, 220, 0.28);
      color: #a8c4f0;
   }
</style>

<section style="padding: 120px 5% 60px; min-height: 70vh;">
   <div style="display:flex; justify-content:space-between; align-items:flex-start; flex-wrap:wrap; gap:16px; margin-bottom:24px;">
      <div>
         <a href="{{ url('settings/member') }}" class="btn-back">← Kembali ke Member</a>
         <h1 style="margin:16px 0 4px; font-family:'Cormorant Garamond',serif; font-size:clamp(2rem,5vw,3rem); font-weight:400;">
            Detail Point Member</h1>
         <p style="margin:0; opacity:0.85;">{{ member['nama'] }} — {{ member['no_member'] }}</p>
      </div>
      <div style="text-align:right;">
         <div class="info-label">Total Point</div>
         <div class="point-highlight">{{ Helpers.number(totalPoint) }}</div>
      </div>
   </div>

   <div class="info-card">
      <h3 style="margin:0 0 16px; color:#d4b15a; font-family:'Cormorant Garamond',serif; font-size:1.35rem;">Data Diri</h3>
      <div class="info-grid">
         <div>
            <div class="info-label">No. Member</div>
            <div class="info-value" style="font-family:monospace; color:#e8cc7a;">{{ member['no_member'] }}</div>
         </div>
         <div>
            <div class="info-label">Nama</div>
            <div class="info-value">{{ member['nama'] }}</div>
         </div>
         <div>
            <div class="info-label">Email</div>
            <div class="info-value">{{ member['email'] }}</div>
         </div>
         <div>
            <div class="info-label">No. HP</div>
            <div class="info-value">{{ member['no_hp'] }}</div>
         </div>
         <div>
            <div class="info-label">Tanggal Lahir</div>
            <div class="info-value">{{ member['tgl_lahir'] ? member['tgl_lahir'] : '—' }}</div>
         </div>
         <div>
            <div class="info-label">Jenis Kelamin</div>
            <div class="info-value">
               {% if member['gender'] == 'L' %}Laki-laki{% elseif member['gender'] == 'P' %}Perempuan{% else %}—{% endif %}
            </div>
         </div>
         <div>
            <div class="info-label">Kota</div>
            <div class="info-value">{{ member['kota'] ? member['kota'] : '—' }}</div>
         </div>
         <div>
            <div class="info-label">Alamat</div>
            <div class="info-value">{{ member['alamat'] ? member['alamat'] : '—' }}</div>
         </div>
         <div>
            <div class="info-label">Role</div>
            <div class="info-value"><span class="badge-role">{{ member['role']|upper }}</span></div>
         </div>
         <div>
            <div class="info-label">Status</div>
            <div class="info-value">
               {% if member['is_active'] %}<span class="badge-active">AKTIF</span>{% else %}<span class="badge-inactive">NONAKTIF</span>{% endif %}
            </div>
         </div>
         <div>
            <div class="info-label">Tgl Daftar</div>
            <div class="info-value">{{ member['tgl_daftar'] }}</div>
         </div>
      </div>
   </div>

   <div class="table-card">
      <h3 style="margin:0 0 16px; color:#d4b15a; font-family:'Cormorant Garamond',serif; font-size:1.35rem;">
         Riwayat Transaksi Point</h3>

      {% if transactions is empty %}
      <p style="margin:0; opacity:0.7;">Belum ada transaksi point untuk member ini.</p>
      {% else %}
      <div style="margin-bottom:8px; color:#e8cc7a; font-size:0.9rem;">
         Menampilkan {{ ((currentPage - 1) * perPage) + 1 }} – {{ ((currentPage - 1) * perPage) + transactions|length }} dari {{ totalTransactions }} transaksi
      </div>
      <div class="table-responsive" style="overflow-x:auto;">
         <table class="table table-sm text-white" style="width:100%; border-collapse:collapse; min-width:900px;">
            <thead>
               <tr style="background:rgba(0,0,0,0.25);">
                  <th style="text-align:left; padding:12px;">Tgl Transaksi</th>
                  <th style="text-align:left; padding:12px;">Kode Order</th>
                  <th style="text-align:right; padding:12px;">Nominal</th>
                  <th style="text-align:center; padding:12px;">Jenis</th>
                  <th style="text-align:right; padding:12px;">Point</th>
                  <th style="text-align:left; padding:12px;">Kategori</th>
                  <th style="text-align:left; padding:12px;">Dibuat Oleh</th>
                  <th style="text-align:center; padding:12px;">Aksi</th>
               </tr>
            </thead>
            <tbody>
               {% for t in transactions %}
               <tr>
                  <td style="padding:12px; border-bottom:1px solid rgba(255,255,255,.08);">{{ Helpers.formatDateTime(t['tgl_transaksi'], 'd M Y H:i') }} WIB</td>
                  <td style="padding:12px; border-bottom:1px solid rgba(255,255,255,.08); font-family:monospace; color:#e8cc7a;">{{ t['kode_order'] }}</td>
                  <td style="padding:12px; border-bottom:1px solid rgba(255,255,255,.08); text-align:right;">
                     {{ Helpers.number(t['nominal_transaksi']) }}</td>
                  <td style="padding:12px; border-bottom:1px solid rgba(255,255,255,.08); text-align:center;">
                     {% if t['jenis_poin'] == 'keluar' %}
                     <span class="badge-keluar">Keluar</span>
                     {% else %}
                     <span class="badge-masuk">Masuk</span>
                     {% endif %}
                  </td>
                  <td class="{% if t['jenis_poin'] == 'keluar' %}text-point-keluar{% else %}text-point-masuk{% endif %}" style="padding:12px; border-bottom:1px solid rgba(255,255,255,.08); text-align:right; font-weight:700;">
                     {% if t['jenis_poin'] == 'keluar' %}-{% endif %}{{ Helpers.number(t['point']) }}
                  </td>
                  <td style="padding:12px; border-bottom:1px solid rgba(255,255,255,.08);">{{ t['kategori'] }}</td>
                  <td style="padding:12px; border-bottom:1px solid rgba(255,255,255,.08); opacity:0.85; font-size:0.85rem;">
                     {{ t['created_by'] ? t['created_by'] : '—' }}</td>
                  <td style="padding:12px; border-bottom:1px solid rgba(255,255,255,.08); text-align:center;">
                     {% if t['kode_order'] and t['kategori'] %}
                     <a href="{{ url('settings/order_detail/' ~ t['kategori']|upper ~ '/' ~ t['kode_order']) }}?member_id={{ member['id'] }}"
                        class="btn-order-detail">Detail Order</a>
                     {% else %}
                     —
                     {% endif %}
                  </td>
               </tr>
               {% endfor %}
            </tbody>
         </table>
      </div>

      {% if totalPages > 1 %}
      <div style="display:flex; justify-content:center; align-items:center; margin-top:12px; gap:8px;">
         {% if currentPage == 1 %}
            <span class="pagination-link disabled">Previous</span>
         {% else %}
            <a href="{{ url('settings/member_point_detail/' ~ member['id']) }}?page={{ currentPage - 1 }}" class="pagination-link">Previous</a>
         {% endif %}

         {% for i in 1..totalPages %}
            {% if i == currentPage %}
            <span class="pagination-link active">{{ i }}</span>
            {% else %}
            <a href="{{ url('settings/member_point_detail/' ~ member['id']) }}?page={{ i }}" class="pagination-link">{{ i }}</a>
            {% endif %}
         {% endfor %}

         {% if currentPage == totalPages %}
            <span class="pagination-link disabled">Next</span>
         {% else %}
            <a href="{{ url('settings/member_point_detail/' ~ member['id']) }}?page={{ currentPage + 1 }}" class="pagination-link">Next</a>
         {% endif %}
      </div>
      {% endif %}

      {% endif %}
   </div>
</section>
