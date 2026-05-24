<style>
   .settings-row-editable {
      cursor: pointer;
      transition: background 0.2s ease-in-out;
   }
   .settings-row-editable:hover {
      background: rgba(255, 255, 255, 0.05) !important;
   }
   .table th, .table td {
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
      box-shadow: 0 4px 15px rgba(0,0,0,0.25);
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
      box-shadow: 0 2px 5px rgba(0,0,0,0.3);
      animation: pulse 2.5s infinite;
   }
   @keyframes pulse {
      0% { transform: scale(1); }
      50% { transform: scale(1.1); box-shadow: 0 0 10px rgba(224, 94, 94, 0.6); }
      100% { transform: scale(1); }
   }
</style>

<section style="padding: 120px 5% 60px; min-height: 70vh;">
   <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 24px; flex-wrap: wrap; gap: 16px;">
      <div>
         <h1 style="margin: 0 0 4px 0; font-family: 'Cormorant Garamond', serif; font-size: clamp(2rem, 5vw, 3rem); font-weight: 400;">Settings - Member</h1>
         <p style="margin: 0; opacity: 0.85;">Klik pada baris tabel untuk mengubah data member</p>
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
   <div style="padding:12px 16px; border:1px solid #2a9d52; background:#11361f; color:#c9f7d8; border-radius:10px; margin-bottom:18px; font-weight: 500;">
      {{ updateSuccess }}
   </div>
   {% endif %}

   {% if updateError %}
   <div style="padding:12px 16px; border:1px solid #b84141; background:#3a1616; color:#ffd1d1; border-radius:10px; margin-bottom:18px; font-weight: 500;">
      {{ updateError }}
   </div>
   {% endif %}

   {% if members is empty %}
   <div style="background: rgba(16, 36, 23, 0.6); border: 1px solid rgba(255,255,255,0.1); border-radius: 12px; padding: 30px; text-align: center;">
      <p style="margin: 0; opacity: 0.7;">Data member belum tersedia.</p>
   </div>
   {% else %}
   <div class="table-responsive" style="overflow-x: auto; background: rgba(16, 36, 23, 0.6); border: 1px solid rgba(255,255,255,0.1); border-radius: 12px; padding: 10px;">
      <table class="table table-sm text-white" style="width:100%; border-collapse: collapse; min-width: 800px;">
         <thead>
            <tr style="background: rgba(0,0,0,0.25);">
               <th style="text-align:left; padding:14px 12px; border-bottom:2px solid rgba(255,255,255,.15);">No. Member</th>
               <th style="text-align:left; padding:14px 12px; border-bottom:2px solid rgba(255,255,255,.15);">Nama</th>
               <th style="text-align:left; padding:14px 12px; border-bottom:2px solid rgba(255,255,255,.15);">Email</th>
               <th style="text-align:left; padding:14px 12px; border-bottom:2px solid rgba(255,255,255,.15);">No. HP</th>
               <th style="text-align:center; padding:14px 12px; border-bottom:2px solid rgba(255,255,255,.15);">Role</th>
               <th style="text-align:center; padding:14px 12px; border-bottom:2px solid rgba(255,255,255,.15);">Status</th>
               <th style="text-align:left; padding:14px 12px; border-bottom:2px solid rgba(255,255,255,.15);">Tgl Daftar</th>
            </tr>
         </thead>
         <tbody id="memberTableBody">
            {% for m in members %}
            <tr class="settings-row-editable"
                data-id="{{ m['id'] }}"
                data-no-member="{{ m['no_member'] }}"
                data-nama="{{ m['nama'] }}"
                data-email="{{ m['email'] }}"
                data-no-hp="{{ m['no_hp'] }}"
                data-role="{{ m['role'] }}"
                data-is-active="{{ m['is_active'] ? '1' : '0' }}">
               <td style="padding:14px 12px; border-bottom:1px solid rgba(255,255,255,.08); font-family: monospace; font-size: 0.95rem; color: #e8cc7a; font-weight: 600;">{{ m['no_member'] }}</td>
               <td style="padding:14px 12px; border-bottom:1px solid rgba(255,255,255,.08); font-weight: 600;">{{ m['nama'] }}</td>
               <td style="padding:14px 12px; border-bottom:1px solid rgba(255,255,255,.08); opacity: 0.9;">{{ m['email'] }}</td>
               <td style="padding:14px 12px; border-bottom:1px solid rgba(255,255,255,.08); opacity: 0.9;">{{ m['no_hp'] }}</td>
               <td style="padding:14px 12px; border-bottom:1px solid rgba(255,255,255,.08); text-align: center;">
                  <span class="badge-role">{{ m['role']|upper }}</span>
               </td>
               <td style="padding:14px 12px; border-bottom:1px solid rgba(255,255,255,.08); text-align: center;">
                  {% if m['is_active'] %}
                     <span class="badge-active">AKTIF</span>
                  {% else %}
                     <span class="badge-inactive">NONAKTIF</span>
                  {% endif %}
               </td>
               <td style="padding:14px 12px; border-bottom:1px solid rgba(255,255,255,.08); font-size: 0.85rem; opacity: 0.8;">
                  {{ m['tgl_daftar'] }}
               </td>
            </tr>
            {% endfor %}
         </tbody>
      </table>
   </div>
   {% endif %}
</section>

<!-- MODAL EDIT MEMBER -->
<div id="memberModal" style="display:none; position:fixed; inset:0; background:rgba(0,0,0,.65); z-index:9999; align-items:center; justify-content:center; backdrop-filter: blur(4px);">
   <div style="width:min(580px, 92vw); background:#102417; color:#fff; border:1px solid rgba(255,255,255,.2); border-radius:16px; padding:24px; box-shadow: 0 10px 25px rgba(0,0,0,0.5);">
      <h3 style="margin:0 0 18px; font-size: 1.5rem; color:#d4b15a; border-bottom: 1px solid rgba(255,255,255,0.1); padding-bottom: 10px; font-family: 'Cormorant Garamond', serif;">Edit Member</h3>
      <form method="post" action="{{ url('settings/update_member') }}" id="memberForm">
         <input type="hidden" name="id" id="formId">

         <div style="margin-bottom:14px;">
            <label style="display:block; margin-bottom:6px; font-weight: 600; font-size: 0.85rem; letter-spacing: 0.5px; opacity: 0.8;">NOMOR MEMBER</label>
            <input id="formNoMember" type="text" readonly style="width:100%; padding:10px; border-radius:8px; border:1px solid rgba(255,255,255,.15); background:rgba(255,255,255,0.04); color:rgba(255,255,255,0.6); font-family: monospace;">
         </div>

         <div style="margin-bottom:14px;">
            <label for="formNama" style="display:block; margin-bottom:6px; font-weight: 600; font-size: 0.85rem; letter-spacing: 0.5px;">NAMA LENGKAP</label>
            <input id="formNama" name="nama" type="text" required style="width:100%; padding:10px; border-radius:8px; border:1px solid rgba(255,255,255,.2); background:#203729; color:#fff; font-family: 'Jost', sans-serif;">
         </div>

         <div style="margin-bottom:14px;">
            <label for="formEmail" style="display:block; margin-bottom:6px; font-weight: 600; font-size: 0.85rem; letter-spacing: 0.5px;">EMAIL</label>
            <input id="formEmail" name="email" type="email" required style="width:100%; padding:10px; border-radius:8px; border:1px solid rgba(255,255,255,.2); background:#203729; color:#fff; font-family: 'Jost', sans-serif;">
         </div>

         <div style="margin-bottom:14px;">
            <label for="formNoHp" style="display:block; margin-bottom:6px; font-weight: 600; font-size: 0.85rem; letter-spacing: 0.5px;">NO TELEPON</label>
            <input id="formNoHp" name="no_hp" type="tel" required style="width:100%; padding:10px; border-radius:8px; border:1px solid rgba(255,255,255,.2); background:#203729; color:#fff; font-family: 'Jost', sans-serif;">
         </div>

         <div style="margin-bottom:14px; display: grid; grid-template-columns: 1fr 1fr; gap: 12px;">
            <div>
               <label for="formRole" style="display:block; margin-bottom:6px; font-weight: 600; font-size: 0.85rem; letter-spacing: 0.5px;">ROLE</label>
               <select id="formRole" name="role" required style="width:100%; padding:10px; border-radius:8px; border:1px solid rgba(255,255,255,.2); background:#203729; color:#fff; cursor: pointer; font-family: 'Jost', sans-serif;">
                  <option value="member">MEMBER</option>
                  <option value="admin">ADMIN</option>
               </select>
            </div>
            <div>
               <label for="formIsActive" style="display:block; margin-bottom:6px; font-weight: 600; font-size: 0.85rem; letter-spacing: 0.5px;">STATUS</label>
               <select id="formIsActive" name="is_active" required style="width:100%; padding:10px; border-radius:8px; border:1px solid rgba(255,255,255,.2); background:#203729; color:#fff; cursor: pointer; font-family: 'Jost', sans-serif;">
                  <option value="1">AKTIF</option>
                  <option value="0">NONAKTIF</option>
               </select>
            </div>
         </div>

         <div style="display:flex; gap:10px; justify-content:flex-end; border-top: 1px solid rgba(255,255,255,0.1); padding-top: 15px;">
            <button type="button" id="closeMemberModalBtn" style="padding:10px 18px; border-radius:8px; border:1px solid rgba(255,255,255,.25); background:transparent; color:#fff; cursor: pointer;">Batal</button>
            <button type="submit" style="padding:10px 18px; border-radius:8px; border:none; background:#d4b15a; color:#102417; font-weight:700; cursor: pointer;">Simpan</button>
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
   const formRole = document.getElementById('formRole');
   const formIsActive = document.getElementById('formIsActive');

   function openModalForEdit(row) {
      formId.value = row.dataset.id || '';
      formNoMember.value = row.dataset.noMember || '';
      formNama.value = row.dataset.nama || '';
      formEmail.value = row.dataset.email || '';
      formNoHp.value = row.dataset.noHp || '';
      formRole.value = row.dataset.role || 'member';
      formIsActive.value = row.dataset.isActive || '1';

      modal.style.display = 'flex';
   }

   function closeModal() {
      modal.style.display = 'none';
   }

   if (tableBody) {
      tableBody.addEventListener('click', function (event) {
         const row = event.target.closest('.settings-row-editable');
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
})();
</script>
