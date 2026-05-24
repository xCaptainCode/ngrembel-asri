<style>
   /* Custom Styles for Kritik & Saran */
   .krisa-grid {
      display: grid;
      grid-template-columns: 1fr;
      gap: 40px;
      margin-top: 40px;
   }

   @media (min-width: 992px) {
      .krisa-grid {
         grid-template-columns: 1.1fr 1.9fr;
      }
   }

   /* Glassmorphic Form Card */
   .glass-card {
      background: rgba(30, 77, 48, 0.2);
      border: 1px solid rgba(200, 168, 75, 0.25);
      border-radius: 16px;
      padding: 30px;
      backdrop-filter: blur(12px);
      box-shadow: 0 10px 30px rgba(0, 0, 0, 0.25);
      position: sticky;
      top: 100px;
      height: fit-content;
   }

   .glass-card h3 {
      font-family: 'Cormorant Garamond', serif;
      font-size: 1.8rem;
      color: var(--gold2);
      margin-bottom: 20px;
      border-bottom: 1px solid rgba(200, 168, 75, 0.15);
      padding-bottom: 10px;
   }

   /* Form Controls */
   .form-group {
      margin-bottom: 20px;
   }

   .form-group label {
      display: block;
      margin-bottom: 8px;
      font-size: 0.85rem;
      letter-spacing: 1px;
      text-transform: uppercase;
      color: var(--mint);
      font-weight: 500;
   }

   .form-input {
      width: 100%;
      padding: 12px 16px;
      background: rgba(13, 36, 22, 0.6);
      border: 1px solid rgba(255, 255, 255, 0.15);
      border-radius: 10px;
      color: #fff;
      font-family: 'Jost', sans-serif;
      font-size: 0.95rem;
      transition: all 0.3s ease;
   }

   .form-input:focus {
      outline: none;
      border-color: var(--gold);
      box-shadow: 0 0 10px rgba(200, 168, 75, 0.25);
      background: rgba(13, 36, 22, 0.85);
   }

   /* Premium Option Selector Cards for Type */
   .type-selector {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 12px;
      margin-bottom: 20px;
   }

   .type-option {
      position: relative;
   }

   .type-option input {
      position: absolute;
      opacity: 0;
      cursor: pointer;
      height: 0;
      width: 0;
   }

   .type-label {
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      padding: 14px;
      background: rgba(13, 36, 22, 0.6);
      border: 1.5px solid rgba(255, 255, 255, 0.15);
      border-radius: 10px;
      cursor: pointer;
      transition: all 0.3s ease;
      text-align: center;
   }

   .type-label .icon {
      font-size: 1.5rem;
      margin-bottom: 4px;
   }

   .type-label .title {
      font-size: 0.85rem;
      font-weight: 600;
      letter-spacing: 0.5px;
      text-transform: uppercase;
      color: rgba(255, 255, 255, 0.7);
   }

   .type-option input:checked + .type-label {
      border-color: var(--gold);
      background: rgba(200, 168, 75, 0.12);
      box-shadow: 0 0 12px rgba(200, 168, 75, 0.2);
   }

   .type-option input:checked + .type-label .title {
      color: var(--gold2);
   }

   /* Live Search Controls */
   .search-box-wrap {
      position: relative;
      margin-bottom: 24px;
   }

   .search-input {
      width: 100%;
      padding: 14px 20px 14px 45px;
      background: rgba(30, 77, 48, 0.15);
      border: 1px solid rgba(200, 168, 75, 0.2);
      border-radius: 30px;
      color: #fff;
      font-family: 'Jost', sans-serif;
      font-size: 0.95rem;
      backdrop-filter: blur(8px);
      transition: all 0.3s ease;
   }

   .search-input:focus {
      outline: none;
      border-color: var(--gold);
      box-shadow: 0 0 12px rgba(200, 168, 75, 0.25);
      background: rgba(30, 77, 48, 0.25);
   }

   .search-icon-svg {
      position: absolute;
      left: 18px;
      top: 50%;
      transform: translateY(-50%);
      color: var(--gold);
      opacity: 0.7;
      pointer-events: none;
   }

   /* Feedback List and Cards */
   .feedback-list {
      display: flex;
      flex-direction: column;
      gap: 20px;
   }

   .feedback-card {
      background: rgba(21, 46, 30, 0.5);
      border: 1px solid rgba(255, 255, 255, 0.08);
      border-radius: 14px;
      padding: 24px;
      box-shadow: 0 4px 15px rgba(0, 0, 0, 0.15);
      transition: all 0.3s var(--ease-out);
      animation: fadeInUp 0.5s ease-out both;
   }

   .feedback-card:hover {
      transform: translateY(-2px);
      border-color: rgba(200, 168, 75, 0.2);
      box-shadow: 0 8px 25px rgba(0, 0, 0, 0.25);
   }

   .feedback-header {
      display: flex;
      justify-content: space-between;
      align-items: flex-start;
      margin-bottom: 12px;
      gap: 12px;
      flex-wrap: wrap;
   }

   .user-meta {
      display: flex;
      flex-direction: column;
      gap: 2px;
   }

   .user-name {
      font-family: 'Cormorant Garamond', serif;
      font-size: 1.4rem;
      font-weight: 600;
      color: #fff;
      line-height: 1.2;
   }

   .post-date {
      font-size: 0.75rem;
      color: var(--mint);
      opacity: 0.75;
   }

   /* Badges */
   .badge {
      display: inline-block;
      padding: 4px 10px;
      border-radius: 6px;
      font-size: 0.75rem;
      font-weight: 700;
      letter-spacing: 0.8px;
      text-transform: uppercase;
   }

   .badge-kritik {
      background: rgba(224, 94, 94, 0.12);
      color: #ffd1d1;
      border: 1px solid rgba(224, 94, 94, 0.3);
   }

   .badge-saran {
      background: rgba(92, 170, 120, 0.12);
      color: #c9f7d8;
      border: 1px solid rgba(92, 170, 120, 0.3);
   }

   .feedback-content {
      font-size: 0.95rem;
      color: rgba(255, 255, 255, 0.8);
      line-height: 1.7;
      white-space: pre-wrap;
   }

   /* Administrator Reply Section */
   .admin-reply-box {
      margin-top: 18px;
      padding: 16px;
      background: rgba(13, 36, 22, 0.7);
      border-left: 3px solid var(--gold);
      border-radius: 0 10px 10px 0;
      box-shadow: inset 0 2px 5px rgba(0,0,0,0.2);
   }

   .reply-header {
      display: flex;
      justify-content: space-between;
      margin-bottom: 6px;
      font-size: 0.8rem;
      font-weight: 700;
      letter-spacing: 0.5px;
      color: var(--gold2);
      text-transform: uppercase;
   }

   .reply-content {
      font-size: 0.9rem;
      color: rgba(237, 230, 212, 0.9);
      line-height: 1.6;
      font-style: italic;
      white-space: pre-wrap;
   }

   .reply-date {
      font-size: 0.7rem;
      opacity: 0.65;
      font-weight: normal;
   }

   /* Pagination Center */
   .pagination-wrap {
      text-align: center;
      margin-top: 30px;
   }

   .btn-load-more {
      min-width: 180px;
   }

   /* Animations */
   @keyframes fadeInUp {
      from {
         opacity: 0;
         transform: translateY(20px);
      }
      to {
         opacity: 1;
         transform: translateY(0);
      }
   }

   /* Feedback Notifications */
   .krisa-alert {
      padding: 15px 20px;
      border-radius: 10px;
      font-weight: 500;
      font-size: 0.95rem;
      margin-bottom: 25px;
      animation: fadeInUp 0.4s ease-out;
   }
   
   .krisa-alert-success {
      background: rgba(17, 54, 31, 0.8);
      border: 1px solid #2a9d52;
      color: #c9f7d8;
   }

   .krisa-alert-error {
      background: rgba(58, 22, 22, 0.8);
      border: 1px solid #b84141;
      color: #ffd1d1;
   }

   .empty-state {
      text-align: center;
      padding: 40px;
      background: rgba(21, 46, 30, 0.3);
      border: 1px dashed rgba(255, 255, 255, 0.1);
      border-radius: 12px;
      color: rgba(255,255,255,0.5);
   }
</style>

<section id="page-header" style="padding-top: 140px; text-align: center; display: flex; flex-direction: column; justify-content: center; align-items: center;">
   <p class="s-label r">Suara Anda</p>
   <h1 class="s-title r">Kritik & <em>Saran</em></h1>
   <div class="divider-gold r" style="margin: 1.4rem auto;"></div>
   <p class="s-body r" style="max-width: 600px; margin: 0 auto; text-align: center; padding: 0 15px;">
      Masukan Anda sangat berharga bagi kami untuk terus meningkatkan fasilitas dan kenyamanan di Wisata Ngrembel Asri.
   </p>
</section>

<section style="padding: 40px 5% 80px; min-height: 50vh;">
   
   {% if successMsg %}
   <div class="krisa-alert krisa-alert-success r">
      {{ successMsg }}
   </div>
   {% endif %}

   {% if errorMsg %}
   <div class="krisa-alert krisa-alert-error r">
      {{ errorMsg }}
   </div>
   {% endif %}

   <div class="krisa-grid">
      
      <!-- COLUMN 1: FORMULIR -->
      <div class="r-left">
         <div class="glass-card">
            <h3>Kirim Masukan</h3>
            <form action="{{ url('kritiksaran') }}" method="POST" id="krisaForm">
               
               <div class="form-group">
                  <label>Jenis Masukan</label>
                  <div class="type-selector">
                     <div class="type-option">
                        <input type="radio" id="typeKritik" name="type" value="kritik" checked>
                        <label for="typeKritik" class="type-label">
                           <span class="icon">✍️</span>
                           <span class="title">Kritik</span>
                        </label>
                     </div>
                     <div class="type-option">
                        <input type="radio" id="typeSaran" name="type" value="saran">
                        <label for="typeSaran" class="type-label">
                           <span class="icon">💡</span>
                           <span class="title">Saran</span>
                        </label>
                     </div>
                  </div>
               </div>

               <div class="form-group">
                  <label for="inputNama">Nama Lengkap</label>
                  <input type="text" id="inputNama" name="nama" class="form-input" 
                         value="{% if session.get('nama') %}{{ session.get('nama') }}{% endif %}"
                         placeholder="Masukkan nama Anda..." required maxlength="255">
               </div>

               <div class="form-group">
                  <label for="inputPesan">Kritik / Saran Anda</label>
                  <textarea id="inputPesan" name="kritik_saran" class="form-input" rows="6" 
                            placeholder="Tuliskan masukan Anda dengan sopan dan detail di sini..." required></textarea>
               </div>

               <button type="submit" class="btn-gold" style="width: 100%; border: none; cursor: pointer; display: flex; justify-content: center; align-items: center; gap: 8px;">
                  <span>Kirim Masukan</span>
                  <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                     <line x1="22" y1="2" x2="11" y2="13"></line>
                     <polygon points="22 2 15 22 11 13 2 9 22 2"></polygon>
                  </svg>
               </button>
            </form>
         </div>
      </div>

      <!-- COLUMN 2: RIWAYAT & SEARCH -->
      <div class="r-right">
         
         <div class="search-box-wrap">
            <svg class="search-icon-svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
               <circle cx="11" cy="11" r="8"></circle>
               <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
            </svg>
            <input type="text" id="krisaSearch" class="search-input" placeholder="Cari kritik & saran dari riwayat...">
         </div>

         <div class="feedback-list" id="krisaList">
            {% if items is empty %}
            <div class="empty-state">
               <p style="margin: 0; font-size: 0.95rem;">Belum ada kritik dan saran yang dipublikasikan.</p>
            </div>
            {% else %}
               {% for item in items %}
               <div class="feedback-card">
                  <div class="feedback-header">
                     <div class="user-meta">
                        <span class="user-name">{{ item['nama'] }}</span>
                        <span class="post-date">
                           {# Format standard dari created_at #}
                           {{ item['created_at'] }}
                        </span>
                     </div>
                     <span class="badge {% if item['type'] == 'kritik' %}badge-kritik{% else %}badge-saran{% endif %}">
                        {{ item['type'] }}
                     </span>
                  </div>
                  <div class="feedback-content">{{ item['kritik_saran'] }}</div>
                  
                  {% if item['response'] is not empty %}
                  <div class="admin-reply-box">
                     <div class="reply-header">
                        <span>Wisata Ngrembel Asri {% if item['admin_nama'] %}({{ item['admin_nama'] }}){% endif %}</span>
                        <span class="reply-date">{{ item['responded_at'] }}</span>
                     </div>
                     <div class="reply-content">{{ item['response'] }}</div>
                  </div>
                  {% endif %}
               </div>
               {% endfor %}
            {% endif %}
         </div>

         <div class="pagination-wrap" id="paginationContainer" {% if items|length < 5 %}style="display:none;"{% endif %}>
            <button id="loadMoreBtn" class="btn-ghost btn-load-more" style="cursor: pointer; border-radius: 30px;">
               Muat Lebih Banyak
            </button>
         </div>

      </div>

   </div>
</section>

<script>
document.addEventListener('DOMContentLoaded', function () {
   let offset = 5;
   let searchVal = '';
   let debounceTimer = null;
   
   const loadMoreBtn = document.getElementById('loadMoreBtn');
   const krisaSearch = document.getElementById('krisaSearch');
   const krisaList = document.getElementById('krisaList');
   const paginationContainer = document.getElementById('paginationContainer');

   // URL Helper to resolve base domain path safely
   const baseUri = "{{ url('kritiksaran/loadMore') }}";

   // Fetch data function
   function fetchFeedback(isAppend = false) {
      if (!isAppend) {
         offset = 0;
      }

      const params = new URLSearchParams({
         search: searchVal,
         offset: offset
      });

      fetch(`${baseUri}?${params.toString()}`, {
         headers: {
            'X-Requested-With': 'XMLHttpRequest'
         }
      })
      .then(response => {
         if (!response.ok) {
            throw new Error('Network response was not ok');
         }
         return response.json();
      })
      .then(res => {
         if (res.status === 'success') {
            const data = res.data;
            const hasMore = res.has_more;

            if (!isAppend) {
               krisaList.innerHTML = '';
            }

            if (data.length === 0 && !isAppend) {
               krisaList.innerHTML = `
                  <div class="empty-state">
                     <p style="margin: 0; font-size: 0.95rem;">Tidak ada kritik dan saran yang cocok dengan pencarian Anda.</p>
                  </div>
               `;
               paginationContainer.style.display = 'none';
               return;
            }

            data.forEach((item, index) => {
               const card = document.createElement('div');
               card.className = 'feedback-card';
               card.style.animationDelay = `${index * 0.05}s`;

               const dateText = item.formatted_created || item.created_at;
               const badgeClass = item.type === 'kritik' ? 'badge-kritik' : 'badge-saran';

               let replyHtml = '';
               if (item.response) {
                  const replyDateText = item.formatted_responded || item.responded_at;
                  const adminNameText = item.admin_nama ? ` (${item.admin_nama})` : '';
                  replyHtml = `
                     <div class="admin-reply-box">
                        <div class="reply-header">
                           <span>Wisata Ngrembel Asri ${adminNameText}</span>
                           <span class="reply-date">${replyDateText}</span>
                        </div>
                        <div class="reply-content">${escapeHTML(item.response)}</div>
                     </div>
                  `;
               }

               card.innerHTML = `
                  <div class="feedback-header">
                     <div class="user-meta">
                        <span class="user-name">${escapeHTML(item.nama)}</span>
                        <span class="post-date">${dateText}</span>
                     </div>
                     <span class="badge ${badgeClass}">${item.type}</span>
                  </div>
                  <div class="feedback-content">${escapeHTML(item.kritik_saran)}</div>
                  ${replyHtml}
               `;

               krisaList.appendChild(card);
            });

            // Adjust offset and button visibility
            offset += data.length;
            if (hasMore) {
               paginationContainer.style.display = 'block';
               loadMoreBtn.innerText = 'Muat Lebih Banyak';
               loadMoreBtn.disabled = false;
            } else {
               paginationContainer.style.display = 'none';
            }
         }
      })
      .catch(error => {
         console.error('Error fetching feedback:', error);
         if (!isAppend) {
            krisaList.innerHTML = `
               <div class="empty-state" style="border-color: #b84141; background: rgba(58, 22, 22, 0.2);">
                  <p style="margin: 0; font-size: 0.95rem; color: #ffd1d1;">Terjadi kesalahan saat memuat data. Silakan muat ulang halaman.</p>
               </div>
            `;
            paginationContainer.style.display = 'none';
         }
      });
   }

   // Safe escape function for input elements
   function escapeHTML(str) {
      if (!str) return '';
      return str.replace(/[&<>'"]/g, 
         tag => ({
            '&': '&amp;',
            '<': '&lt;',
            '>': '&gt;',
            "'": '&#39;',
            '"': '&quot;'
         }[tag] || tag)
      );
   }

   // Search input event with 400ms Debounce
   krisaSearch.addEventListener('input', function (e) {
      searchVal = e.target.value.trim();
      
      clearTimeout(debounceTimer);
      debounceTimer = setTimeout(() => {
         fetchFeedback(false);
      }, 400);
   });

   // Load More button click event
   loadMoreBtn.addEventListener('click', function () {
      loadMoreBtn.innerText = 'Memproses...';
      loadMoreBtn.disabled = true;
      fetchFeedback(true);
   });

   // If initially we have 5 items, check formatting or initial dates
   // The initial rendering is server-side, but the dates can be formatted client-side or left standard.
   // Let's formatting them immediately using clean Javascript if necessary, but standard created_at is clean too.
});
</script>
