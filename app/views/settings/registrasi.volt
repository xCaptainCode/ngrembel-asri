<style>
   .table th, .table td {
      vertical-align: middle;
   }
   .badge-pending {
      background: rgba(212, 177, 90, 0.15);
      color: #d4b15a;
      border: 1px solid rgba(212, 177, 90, 0.35);
      padding: 4px 8px;
      border-radius: 6px;
      font-size: 0.8rem;
      font-weight: 700;
      letter-spacing: 0.4px;
   }
   .btn-tinjau {
      background: linear-gradient(135deg, var(--gold), var(--gold2));
      color: var(--forest);
      border: none;
      padding: 8px 16px;
      border-radius: 20px;
      font-size: 0.8rem;
      font-weight: 700;
      cursor: pointer;
      text-transform: uppercase;
      letter-spacing: 0.5px;
      box-shadow: 0 4px 10px rgba(200, 168, 75, 0.3);
      transition: all 0.2s ease;
      display: inline-flex;
      align-items: center;
      gap: 6px;
   }
   .btn-tinjau:hover {
      transform: translateY(-1px);
      box-shadow: 0 6px 15px rgba(200, 168, 75, 0.45);
      filter: brightness(1.1);
   }
   .btn-acc {
      background: linear-gradient(135deg, #5caa78, #3a7d54);
      color: #fff;
      border: none;
      padding: 10px 20px;
      border-radius: 8px;
      font-size: 0.85rem;
      font-weight: 700;
      cursor: pointer;
      text-transform: uppercase;
      letter-spacing: 0.5px;
      box-shadow: 0 4px 10px rgba(92, 170, 120, 0.3);
      transition: all 0.2s ease;
      display: inline-flex;
      align-items: center;
      gap: 6px;
   }
   .btn-acc:hover {
      transform: translateY(-1px);
      box-shadow: 0 6px 15px rgba(92, 170, 120, 0.45);
      filter: brightness(1.1);
   }
   .btn-reject {
      background: linear-gradient(135deg, #b84141, #801d1d);
      color: #fff;
      border: none;
      padding: 10px 20px;
      border-radius: 8px;
      font-size: 0.85rem;
      font-weight: 700;
      cursor: pointer;
      text-transform: uppercase;
      letter-spacing: 0.5px;
      box-shadow: 0 4px 10px rgba(184, 65, 65, 0.3);
      transition: all 0.2s ease;
      display: inline-flex;
      align-items: center;
      gap: 6px;
   }
   .btn-reject:hover {
      transform: translateY(-1px);
      box-shadow: 0 6px 15px rgba(184, 65, 65, 0.45);
      filter: brightness(1.1);
   }
</style>

<section style="padding: 120px 5% 60px; min-height: 70vh;">
   <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 24px; flex-wrap: wrap; gap: 16px;">
      <div>
         <h1 style="margin: 0 0 4px 0; font-family: 'Cormorant Garamond', serif; font-size: clamp(2rem, 5vw, 3rem); font-weight: 400;">Settings - Persetujuan Registrasi</h1>
         <p style="margin: 0; opacity: 0.85;">Daftar pendaftaran member baru yang sedang menunggu persetujuan (Pending)</p>
      </div>
      <div>
         <a href="{{ url('settings/member') }}" style="display: inline-flex; align-items: center; gap: 8px; border: 1px solid rgba(255,255,255,0.2); background: rgba(255,255,255,0.05); color: #fff; padding: 10px 20px; border-radius: 30px; text-decoration: none; font-weight: 600; font-size: 0.9rem; transition: background 0.2s;">
            <span>&larr; Kembali ke Member</span>
         </a>
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

   {% if pendingList is empty %}
   <div style="background: rgba(16, 36, 23, 0.6); border: 1px solid rgba(255,255,255,0.1); border-radius: 12px; padding: 40px; text-align: center;">
      <p style="margin: 0; opacity: 0.7; font-size: 1.1rem;">Tidak ada pendaftaran pending saat ini.</p>
   </div>
   {% else %}
   <div class="table-responsive" style="overflow-x: auto; background: rgba(16, 36, 23, 0.6); border: 1px solid rgba(255,255,255,0.1); border-radius: 12px; padding: 10px;">
      <table class="table table-sm text-white" style="width:100%; border-collapse: collapse; min-width: 1000px;">
         <thead>
            <tr style="background: rgba(0,0,0,0.25);">
               <th style="text-align:left; padding:14px 12px; border-bottom:2px solid rgba(255,255,255,.15);">Nama</th>
               <th style="text-align:left; padding:14px 12px; border-bottom:2px solid rgba(255,255,255,.15);">Kontak</th>
               <th style="text-align:left; padding:14px 12px; border-bottom:2px solid rgba(255,255,255,.15);">Tgl Lahir / Gender</th>
               <th style="text-align:left; padding:14px 12px; border-bottom:2px solid rgba(255,255,255,.15);">Alamat / Kota</th>
               <th style="text-align:center; padding:14px 12px; border-bottom:2px solid rgba(255,255,255,.15);">Status</th>
               <th style="text-align:left; padding:14px 12px; border-bottom:2px solid rgba(255,255,255,.15);">Tgl Daftar</th>
               <th style="text-align:center; padding:14px 12px; border-bottom:2px solid rgba(255,255,255,.15); width: 150px;">Aksi</th>
            </tr>
         </thead>
         <tbody id="registrasiTableBody">
            {% for r in pendingList %}
            <tr>
               <td style="padding:14px 12px; border-bottom:1px solid rgba(255,255,255,.08); font-weight: 600; color: #e8cc7a;">{{ r['nama'] }}</td>
               <td style="padding:14px 12px; border-bottom:1px solid rgba(255,255,255,.08); line-height: 1.4;">
                  <div>Email: {{ r['email'] }}</div>
                  <div style="font-size: 0.85rem; opacity: 0.8;">HP: {{ r['no_hp'] }}</div>
               </td>
               <td style="padding:14px 12px; border-bottom:1px solid rgba(255,255,255,.08);">
                  <div>{{ r['tgl_lahir'] }}</div>
                  <div style="font-size: 0.85rem; opacity: 0.8;">JK: {{ r['gender'] == 'L' ? 'Laki-laki' : 'Perempuan' }}</div>
               </td>
               <td style="padding:14px 12px; border-bottom:1px solid rgba(255,255,255,.08); line-height: 1.4; max-width: 250px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;">
                  <div>{{ r['alamat'] }}</div>
                  <div style="font-size: 0.85rem; opacity: 0.8;">Kota: {{ r['kota'] }}</div>
               </td>
               <td style="padding:14px 12px; border-bottom:1px solid rgba(255,255,255,.08); text-align: center;">
                  <span class="badge-pending">{{ r['status']|upper }}</span>
               </td>
               <td style="padding:14px 12px; border-bottom:1px solid rgba(255,255,255,.08); font-size: 0.85rem; opacity: 0.8;">
                  {{ r['tgl_daftar'] }}
               </td>
               <td style="padding:14px 12px; border-bottom:1px solid rgba(255,255,255,.08); text-align: center;">
                  <button type="button" class="btn-tinjau" 
                          data-id="{{ r['id'] }}"
                          data-nama="{{ r['nama'] }}"
                          data-email="{{ r['email'] }}"
                          data-no-hp="{{ r['no_hp'] }}"
                          data-tgl-lahir="{{ r['tgl_lahir'] }}"
                          data-gender="{{ r['gender'] == 'L' ? 'Laki-laki' : 'Perempuan' }}"
                          data-alamat="{{ r['alamat'] }}"
                          data-kota="{{ r['kota'] }}">
                     <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><circle cx="12" cy="12" r="10"/><line x1="12" y1="16" x2="12" y2="12"/><line x1="12" y1="8" x2="12.01" y2="8"/></svg>
                     Tinjau
                  </button>
               </td>
            </tr>
            {% endfor %}
         </tbody>
      </table>
   </div>
   {% endif %}
</section>

<!-- MODAL TINJAU PENDAFTARAN -->
<div id="registrasiModal" style="display:none; position:fixed; inset:0; background:rgba(0,0,0,.65); z-index:9999; align-items:center; justify-content:center; backdrop-filter: blur(4px);">
   <div style="width:min(600px, 92vw); background:#102417; color:#fff; border:1px solid rgba(200, 168, 75, 0.3); border-radius:16px; padding:24px; box-shadow: 0 10px 25px rgba(0,0,0,0.5);">
      <h3 style="margin:0 0 18px; font-size: 1.5rem; color:#d4b15a; border-bottom: 1px solid rgba(255,255,255,0.1); padding-bottom: 10px; font-family: 'Cormorant Garamond', serif;">Tinjau Pendaftaran Member</h3>
      
      <!-- Applicant Info Details -->
      <div style="background: rgba(255,255,255,0.03); border: 1px solid rgba(255,255,255,0.08); border-radius: 10px; padding: 16px; margin-bottom: 18px; line-height: 1.6; font-size: 0.95rem;">
         <div style="display: grid; grid-template-columns: 100px 1fr; gap: 8px 12px;">
            <div style="opacity: 0.7; font-weight: 600;">Nama:</div>
            <div id="detailNama" style="font-weight: 600; color: #e8cc7a;"></div>
            
            <div style="opacity: 0.7; font-weight: 600;">Email:</div>
            <div id="detailEmail"></div>
            
            <div style="opacity: 0.7; font-weight: 600;">No. HP:</div>
            <div id="detailNoHp"></div>
            
            <div style="opacity: 0.7; font-weight: 600;">Tgl Lahir:</div>
            <div id="detailTglLahir"></div>
            
            <div style="opacity: 0.7; font-weight: 600;">Gender:</div>
            <div id="detailGender"></div>
            
            <div style="opacity: 0.7; font-weight: 600;">Alamat:</div>
            <div id="detailAlamat" style="white-space: pre-wrap;"></div>
            
            <div style="opacity: 0.7; font-weight: 600;">Kota:</div>
            <div id="detailKota"></div>
         </div>
      </div>

      <!-- Action Form -->
      <form method="post" id="actionForm">
         <input type="hidden" name="id" id="formRegId">

         <div style="margin-bottom:20px;">
            <label for="formRole" style="display:block; margin-bottom:6px; font-weight: 600; font-size: 0.85rem; letter-spacing: 0.5px; color: #e8cc7a;">PILIH ROLE UNTUK MEMBER BARU</label>
            <select id="formRole" name="role" required style="width:100%; padding:10px; border-radius:8px; border:1px solid rgba(200, 168, 75, 0.4); background:#203729; color:#fff; cursor: pointer; font-family: 'Jost', sans-serif;">
               <option value="member">MEMBER</option>
               <option value="admin">ADMIN</option>
            </select>
         </div>

         <div style="display:flex; gap:12px; justify-content:flex-end; border-top: 1px solid rgba(255,255,255,0.1); padding-top: 18px; flex-wrap: wrap;">
            <button type="button" id="closeModalBtn" style="padding:10px 18px; border-radius:8px; border:1px solid rgba(255,255,255,.25); background:transparent; color:#fff; cursor: pointer;">Batal</button>
            <button type="button" id="btnRejectAction" class="btn-reject" style="padding:10px 18px; border-radius:8px;">
               <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/></svg>
               Tolak
            </button>
            <button type="button" id="btnApproveAction" class="btn-acc" style="padding:10px 18px; border-radius:8px;">
               <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="20 6 9 17 4 12"/></svg>
               Setujui & ACC
            </button>
         </div>
      </form>
   </div>
</div>

<script>
(function () {
   const modal = document.getElementById('registrasiModal');
   const tableBody = document.getElementById('registrasiTableBody');
   const closeModalBtn = document.getElementById('closeModalBtn');
   const btnApproveAction = document.getElementById('btnApproveAction');
   const btnRejectAction = document.getElementById('btnRejectAction');
   const actionForm = document.getElementById('actionForm');

   const formRegId = document.getElementById('formRegId');
   const detailNama = document.getElementById('detailNama');
   const detailEmail = document.getElementById('detailEmail');
   const detailNoHp = document.getElementById('detailNoHp');
   const detailTglLahir = document.getElementById('detailTglLahir');
   const detailGender = document.getElementById('detailGender');
   const detailAlamat = document.getElementById('detailAlamat');
   const detailKota = document.getElementById('detailKota');

   function openModalForTinjau(button) {
      formRegId.value = button.dataset.id || '';
      detailNama.textContent = button.dataset.nama || '';
      detailEmail.textContent = button.dataset.email || '';
      detailNoHp.textContent = button.dataset.noHp || '';
      detailTglLahir.textContent = button.dataset.tglLahir || '';
      detailGender.textContent = button.dataset.gender || '';
      detailAlamat.textContent = button.dataset.alamat || '';
      detailKota.textContent = button.dataset.kota || '';

      modal.style.display = 'flex';
   }

   function closeModal() {
      modal.style.display = 'none';
   }

   if (tableBody) {
      tableBody.addEventListener('click', function (event) {
         const button = event.target.closest('.btn-tinjau');
         if (!button) return;
         openModalForTinjau(button);
      });
   }

   if (closeModalBtn) {
      closeModalBtn.addEventListener('click', closeModal);
   }

   if (btnApproveAction) {
      btnApproveAction.addEventListener('click', function () {
         const nama = detailNama.textContent;
         if (confirm(`Apakah Anda yakin ingin MENYETUJUI pendaftaran ${nama}?`)) {
            actionForm.action = "{{ url('settings/approve_registrasi') }}";
            actionForm.submit();
         }
      });
   }

   if (btnRejectAction) {
      btnRejectAction.addEventListener('click', function () {
         const nama = detailNama.textContent;
         if (confirm(`Apakah Anda yakin ingin MENOLAK pendaftaran ${nama}?`)) {
            actionForm.action = "{{ url('settings/reject_registrasi') }}";
            actionForm.submit();
         }
      });
   }

   window.addEventListener('click', function (event) {
      if (event.target === modal) {
         closeModal();
      }
   });
})();
</script>
