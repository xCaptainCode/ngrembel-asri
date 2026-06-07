<style>
   .order-detail-wrap {
      padding: 120px 5% 60px;
      min-height: 70vh;
   }

   .order-detail-toolbar {
      display: flex;
      justify-content: space-between;
      align-items: center;
      flex-wrap: wrap;
      gap: 12px;
      margin-bottom: 24px;
   }

   .btn-back {
      display: inline-flex;
      align-items: center;
      gap: 8px;
      padding: 8px 16px;
      border-radius: 8px;
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

   .btn-print {
      padding: 8px 16px;
      border-radius: 8px;
      border: 1px solid rgba(212, 177, 90, 0.45);
      background: rgba(212, 177, 90, 0.15);
      color: #e8cc7a;
      font-weight: 600;
      cursor: pointer;
      font-family: 'Jost', sans-serif;
      transition: all 0.2s ease;
   }

   .btn-print:hover {
      background: rgba(212, 177, 90, 0.28);
   }

   .invoice-empty {
      background: rgba(16, 36, 23, 0.6);
      border: 1px solid rgba(255, 255, 255, 0.1);
      border-radius: 16px;
      padding: 40px 24px;
      text-align: center;
      color: rgba(255, 255, 255, 0.75);
   }

   .invoice-card {
      max-width: 920px;
      margin: 0 auto;
      background: #f8f6f0;
      color: #1a2e22;
      border-radius: 20px;
      overflow: hidden;
      box-shadow: 0 24px 60px rgba(0, 0, 0, 0.35), 0 0 0 1px rgba(212, 177, 90, 0.15);
   }

   .invoice-header {
      background: linear-gradient(135deg, #102417 0%, #1a3d2b 55%, #2d5a3d 100%);
      color: #fff;
      padding: 28px 32px;
      display: flex;
      justify-content: space-between;
      align-items: flex-start;
      flex-wrap: wrap;
      gap: 20px;
   }

   .invoice-brand h1 {
      margin: 0 0 4px;
      font-family: 'Cormorant Garamond', serif;
      font-size: clamp(1.6rem, 4vw, 2.2rem);
      font-weight: 600;
      color: #e8cc7a;
      letter-spacing: 0.5px;
   }

   .invoice-brand p {
      margin: 0;
      opacity: 0.8;
      font-size: 0.88rem;
   }

   .invoice-meta {
      text-align: right;
   }

   .invoice-meta-label {
      font-size: 0.72rem;
      letter-spacing: 1px;
      text-transform: uppercase;
      opacity: 0.7;
      margin-bottom: 4px;
   }

   .invoice-meta-value {
      font-family: monospace;
      font-size: 1.05rem;
      font-weight: 700;
      color: #e8cc7a;
   }

   .invoice-badge {
      display: inline-block;
      margin-top: 8px;
      padding: 4px 10px;
      border-radius: 20px;
      background: rgba(232, 204, 122, 0.15);
      border: 1px solid rgba(232, 204, 122, 0.35);
      color: #e8cc7a;
      font-size: 0.75rem;
      font-weight: 700;
      letter-spacing: 0.5px;
   }

   .invoice-body {
      padding: 28px 32px 32px;
   }

   .invoice-info-grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
      gap: 20px;
      margin-bottom: 28px;
      padding-bottom: 24px;
      border-bottom: 2px dashed rgba(16, 36, 23, 0.12);
   }

   .invoice-info-label {
      font-size: 0.72rem;
      text-transform: uppercase;
      letter-spacing: 0.6px;
      color: #6b7c72;
      font-weight: 700;
      margin-bottom: 4px;
   }

   .invoice-info-value {
      font-size: 0.95rem;
      font-weight: 600;
      color: #102417;
      word-break: break-word;
   }

   .invoice-table-wrap {
      overflow-x: auto;
      margin-bottom: 24px;
      border-radius: 12px;
      border: 1px solid rgba(16, 36, 23, 0.08);
   }

   .invoice-table {
      width: 100%;
      border-collapse: collapse;
      min-width: 640px;
      font-size: 0.9rem;
   }

   .invoice-table thead {
      background: #102417;
      color: #e8cc7a;
   }

   .invoice-table th {
      padding: 12px 14px;
      text-align: left;
      font-size: 0.75rem;
      letter-spacing: 0.5px;
      text-transform: uppercase;
      font-weight: 700;
   }

   .invoice-table th.num,
   .invoice-table td.num {
      text-align: right;
   }

   .invoice-table td {
      padding: 12px 14px;
      border-bottom: 1px solid rgba(16, 36, 23, 0.07);
      vertical-align: middle;
   }

   .invoice-table tbody tr:last-child td {
      border-bottom: none;
   }

   .invoice-table tbody tr:hover {
      background: rgba(16, 36, 23, 0.03);
   }

   .invoice-footer {
      display: grid;
      grid-template-columns: 1fr minmax(240px, 300px);
      gap: 24px;
      align-items: start;
   }

   .invoice-note {
      background: rgba(16, 36, 23, 0.04);
      border-radius: 12px;
      padding: 16px;
      font-size: 0.88rem;
      color: #3d5248;
      line-height: 1.5;
   }

   .invoice-note strong {
      display: block;
      margin-bottom: 6px;
      color: #102417;
      font-size: 0.75rem;
      text-transform: uppercase;
      letter-spacing: 0.5px;
   }

   .invoice-totals {
      background: #102417;
      color: #fff;
      border-radius: 14px;
      padding: 18px 20px;
   }

   .invoice-total-row {
      display: flex;
      justify-content: space-between;
      gap: 12px;
      padding: 6px 0;
      font-size: 0.88rem;
      opacity: 0.9;
   }

   .invoice-total-row.grand {
      margin-top: 8px;
      padding-top: 12px;
      border-top: 1px solid rgba(255, 255, 255, 0.15);
      font-size: 1.1rem;
      font-weight: 700;
      opacity: 1;
      color: #e8cc7a;
   }

   .invoice-total-row .val {
      font-family: monospace;
      font-weight: 600;
   }

   @media (max-width: 720px) {
      .invoice-header,
      .invoice-body {
         padding: 20px 18px;
      }

      .invoice-meta {
         text-align: left;
         width: 100%;
      }

      .invoice-footer {
         grid-template-columns: 1fr;
      }
   }

   @media print {
      .order-detail-toolbar,
      nav,
      footer,
      .navbar {
         display: none !important;
      }

      .order-detail-wrap {
         padding: 0;
      }

      .invoice-card {
         box-shadow: none;
         max-width: 100%;
      }
   }
</style>

<section class="order-detail-wrap">
   <div class="order-detail-toolbar">
      {% if returnTo == 'history' %}
      <a href="{{ url('member-history') }}{% if historyPage > 1 %}?page={{ historyPage }}{% endif %}" class="btn-back">← Kembali ke Riwayat Transaksi</a>
      {% elseif returnTo == 'admin_point_detail' and memberId is not empty %}
      <a href="{{ url('settings/member_point_detail/' ~ memberId) }}" class="btn-back">← Kembali ke Detail Point Member</a>
      {% else %}
      <a href="{{ url('settings/member') }}" class="btn-back">← Kembali ke Daftar Member</a>
      {% endif %}
      {% if order %}
      <button type="button" class="btn-print" onclick="window.print()">Cetak Invoice</button>
      {% endif %}
   </div>

   {% if order is empty %}
   <div class="invoice-empty">
      <h2 style="margin:0 0 8px; color:#e8cc7a; font-family:'Cormorant Garamond',serif;">Order Tidak Ditemukan</h2>
      <p style="margin:0;">Data order <strong>{{ jenis }}</strong> / <strong>{{ kodeOrder }}</strong> belum tersedia di sistem.</p>
   </div>
   {% else %}
   <article class="invoice-card" id="invoiceCard">
      <header class="invoice-header">
         <div class="invoice-brand">
            <h1>NGREMBEL ASRI</h1>
            <p>Invoice / Bukti Transaksi</p>
         </div>
         <div class="invoice-meta">
            <div class="invoice-meta-label">Jenis Transaksi</div>
            {# <div class="invoice-meta-value">{{ order['kode_order'] }}</div> #}
            <span class="invoice-badge">{{ order['jenis'] }}</span>
         </div>
      </header>

      <div class="invoice-body">
         <div class="invoice-info-grid">
            <div>
               <div class="invoice-info-label">Tanggal</div>
               <div class="invoice-info-value">
                  {% if order['tanggal'] %}{{ Helpers.formatDateTime(order['tanggal'], 'd M Y') }}{% else %}—{% endif %}
               </div>
            </div>
            <div>
               <div class="invoice-info-label">Jam</div>
               <div class="invoice-info-value">
                  {% if order['jam'] %}{{ Helpers.formatJam(order['jam'], 'H:i') }} WIB{% else %}—{% endif %}
               </div>
            </div>
            <div>
               <div class="invoice-info-label">Nama Pelanggan</div>
               <div class="invoice-info-value">{{ order['nama'] ? order['nama'] : '—' }}</div>
            </div>
            <div>
               <div class="invoice-info-label">Jumlah Orang</div>
               <div class="invoice-info-value">{{ order['jml_org'] ? order['jml_org'] : '—' }}</div>
            </div>
            <div>
               <div class="invoice-info-label">Meja / Area</div>
               <div class="invoice-info-value">{{ order['meja'] ? order['meja'] : '—' }}</div>
            </div>
         </div>

         {% if items is not empty %}
         <div class="invoice-table-wrap">
            <table class="invoice-table">
               <thead>
                  <tr>
                     <th>Item</th>
                     <th class="num">Qty</th>
                     <th>Satuan</th>
                     <th class="num">Harga</th>
                     {# <th class="num">Diskon</th> #}
                     <th class="num">Total</th>
                  </tr>
               </thead>
               <tbody>
                  {% for item in items %}
                  <tr>
                     <td>{{ item['item'] }}</td>
                     <td class="num">{{ item['qty'] }}</td>
                     <td>{{ item['satuan'] ? item['satuan'] : '—' }}</td>
                     <td class="num">{{ Helpers.number(item['harga']) }}</td>
                     {# <td class="num">{{ Helpers.number(item['discount']) }}</td> #}
                     <td class="num">{{ Helpers.number(item['total']) }}</td>
                  </tr>
                  {% endfor %}
               </tbody>
            </table>
         </div>
         {% else %}
         <p style="margin:0 0 24px; color:#6b7c72; font-size:0.9rem;">Tidak ada rincian item untuk order ini.</p>
         {% endif %}

         <div class="invoice-footer">
            <div class="invoice-note">
               <strong>Catatan</strong>
               {{ order['note'] ? order['note'] : '—' }}
            </div>
            <div class="invoice-totals">
               <div class="invoice-total-row">
                  <span>Sub Total</span>
                  <span class="val">Rp {{ Helpers.number(order['sub_total']) }}</span>
               </div>
               <div class="invoice-total-row">
                  <span>Diskon</span>
                  <span class="val">Rp {{ Helpers.number(order['discount']) }}</span>
               </div>
               <div class="invoice-total-row">
                  <span>Pajak</span>
                  <span class="val">Rp {{ Helpers.number(order['pajak']) }}</span>
               </div>
               <div class="invoice-total-row grand">
                  <span>Total Bayar</span>
                  <span class="val">Rp {{ Helpers.number(order['total_bayar']) }}</span>
               </div>
               <div class="invoice-total-row" style="margin-top:10px; font-size:0.82rem;">
                  <span>Nominal Uang</span>
                  <span class="val">Rp {{ Helpers.number(order['nom_uang']) }}</span>
               </div>
               <div class="invoice-total-row" style="font-size:0.82rem;">
                  <span>Kembalian</span>
                  <span class="val">Rp {{ Helpers.number(order['kembalian']) }}</span>
               </div>
            </div>
         </div>
      </div>
   </article>
   {% endif %}
</section>
