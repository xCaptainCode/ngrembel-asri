<section id="member-history-page">
   <div class="history-hero r">
      <div class="history-hero-bg"></div>
      <div class="history-hero-inner">
         <div class="history-hero-text">
            <p class="s-label">Point Member</p>
            <h1 class="history-hero-title">Riwayat <em>Transaksi</em></h1>
            <p class="history-hero-sub">Daftar seluruh transaksi point masuk dan keluar akun Anda.</p>
         </div>
         <div class="profile-point-card history-point-card">
            <div class="profile-point-icon text-center">
               <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
                  <polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/>
               </svg>
               <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
                  <polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/>
               </svg>
               <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
                  <polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/>
               </svg>
               <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
                  <polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/>
               </svg>
               <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
                  <polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/>
               </svg>
            </div>
            <div class="profile-point-body">
               <span class="profile-point-label">Total Point</span>
               <span class="profile-point-value">{{ Helpers.number(totalPoint) }}</span>
            </div>
            <span class="profile-point-type text-right">VVIP</span>
            {# <a href="{{ url('member-profile') }}" class="profile-point-link">← Kembali ke Profil</a> #}
         </div>
      </div>
   </div>

   <div class="history-content">
      <div class="history-table-card r">
         <div class="history-table-head">
            <h2 class="history-table-title">Riwayat Transaksi Point</h2>
            {% if transactions is not empty %}
            <span class="history-table-meta">
               Menampilkan {{ ((currentPage - 1) * perPage) + 1 }} – {{ ((currentPage - 1) * perPage) + transactions|length }} dari {{ totalTransactions }} transaksi
            </span>
            {% endif %}
         </div>

         {% if transactions is empty %}
         <div class="history-empty">
            <div class="history-empty-icon">
               <svg width="40" height="40" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
                  <circle cx="12" cy="12" r="10"/>
                  <polyline points="12 6 12 12 16 14"/>
               </svg>
            </div>
            <p>Belum ada transaksi point pada akun Anda.</p>
         </div>
         {% else %}
         <div class="history-table-wrap">
            <table class="history-table">
               <thead>
                  <tr>
                     <th>Tgl Transaksi</th>
                     <th>Kode Order</th>
                     <th class="text-right">Nominal</th>
                     <th class="text-center">Jenis</th>
                     <th class="text-right">Point</th>
                     <th>Kategori</th>
                     <!-- <th>Dibuat Oleh</th> -->
                  </tr>
               </thead>
               <tbody>
                  {% for t in transactions %}
                  <tr class="history-row">
                     <td>{{ Helpers.formatDateTime(t['tgl_transaksi'], 'd M Y H:i') }} WIB</td>
                     <td><span class="history-kode">{{ t['kode_order'] }}</span></td>
                     <td class="text-right">{{ Helpers.number(t['nominal_transaksi']) }}</td>
                     <td class="text-center">
                        {% if t['jenis_poin'] == 'keluar' %}
                        <span class="history-badge history-badge-keluar">Keluar</span>
                        {% else %}
                        <span class="history-badge history-badge-masuk">Masuk</span>
                        {% endif %}
                     </td>
                     <td class="text-right history-point-cell {% if t['jenis_poin'] == 'keluar' %}history-point-keluar{% else %}history-point-masuk{% endif %}">
                        {% if t['jenis_poin'] == 'keluar' %}-{% endif %}{{ Helpers.number(t['point']) }}
                     </td>
                     <td>{{ t['kategori'] ? t['kategori'] : '—' }}</td>
                     <!-- <td class="history-created-by">{{ t['created_by'] ? t['created_by'] : '—' }}</td> -->
                  </tr>
                  {% endfor %}
               </tbody>
            </table>
         </div>

         {% if totalPages > 1 %}
         <div class="history-pagination">
            {% if currentPage == 1 %}
            <span class="history-page-link disabled">← Sebelumnya</span>
            {% else %}
            <a href="{{ url('member-history') }}?page={{ currentPage - 1 }}" class="history-page-link">← Sebelumnya</a>
            {% endif %}

            {% for i in 1..totalPages %}
            {% if i == currentPage %}
            <span class="history-page-link active">{{ i }}</span>
            {% else %}
            <a href="{{ url('member-history') }}?page={{ i }}" class="history-page-link">{{ i }}</a>
            {% endif %}
            {% endfor %}

            {% if currentPage == totalPages %}
            <span class="history-page-link disabled">Selanjutnya →</span>
            {% else %}
            <a href="{{ url('member-history') }}?page={{ currentPage + 1 }}" class="history-page-link">Selanjutnya →</a>
            {% endif %}
         </div>
         {% endif %}
         {% endif %}
      </div>
   </div>
</section>
