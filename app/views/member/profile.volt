<section id="member-profile-page">
   <div class="profile-hero r">
      <div class="profile-hero-bg"></div>
      <div class="profile-hero-inner">
         <div class="profile-hero-avatar">
            <span>{{ member['nama']|slice(0,1)|upper }}</span>
            <div class="profile-hero-avatar-ring"></div>
         </div>
         <div class="profile-hero-info">
            <p class="s-label">Profil Member</p>
            <h1 class="profile-hero-name">{{ member['nama'] }}</h1>
            <span class="profile-hero-badge">{{ member['no_member'] }}</span>
         </div>
         <div class="profile-point-card">
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
               <span class="profile-point-value" id="totalPointDisplay">{{ Helpers.number(totalPoint) }}</span>
            </div>
            <span class="profile-point-type text-right">VVIP</span>
            {# <a href="{{ url('member-history') }}" class="profile-point-link">Lihat detail →</a> #}
         </div>
      </div>
   </div>

   <div class="profile-content">
      <div class="profile-grid">

         {# ── Data Diri ── #}
         <div class="profile-card r">
            <div class="profile-card-head">
               <div class="profile-card-icon">
                  <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
               </div>
               <h2 class="profile-card-title">Data Diri</h2>
            </div>
            <div class="profile-card-body">

               <div class="profile-field" data-field="nama" data-type="text" data-raw="{{ member['nama'] }}">
                  <span class="profile-field-label">Nama</span>
                  <div class="profile-field-row">
                     <span class="profile-field-value">{{ member['nama'] }}</span>
                     <button type="button" class="profile-field-edit" aria-label="Edit Nama">Edit</button>
                  </div>
                  <div class="profile-field-form" hidden>
                     <input type="text" class="profile-input" value="{{ member['nama'] }}" maxlength="255" />
                     <div class="profile-field-actions">
                        <button type="button" class="profile-btn-save">Simpan</button>
                        <button type="button" class="profile-btn-cancel">Batal</button>
                     </div>
                  </div>
               </div>

               <div class="profile-field" data-field="email" data-type="email" data-raw="{{ member['email'] }}">
                  <span class="profile-field-label">Email</span>
                  <div class="profile-field-row">
                     <span class="profile-field-value">{{ member['email'] }}</span>
                     <button type="button" class="profile-field-edit" aria-label="Edit Email">Edit</button>
                  </div>
                  <div class="profile-field-form" hidden>
                     <input type="email" class="profile-input" value="{{ member['email'] }}" maxlength="255" />
                     <div class="profile-field-actions">
                        <button type="button" class="profile-btn-save">Simpan</button>
                        <button type="button" class="profile-btn-cancel">Batal</button>
                     </div>
                  </div>
               </div>

               <div class="profile-field" data-field="no_hp" data-type="tel" data-raw="{{ member['no_hp'] }}">
                  <span class="profile-field-label">No. HP</span>
                  <div class="profile-field-row">
                     <span class="profile-field-value">{{ member['no_hp'] }}</span>
                     <button type="button" class="profile-field-edit" aria-label="Edit No. HP">Edit</button>
                  </div>
                  <div class="profile-field-form" hidden>
                     <input type="tel" class="profile-input" value="{{ member['no_hp'] }}" maxlength="20" />
                     <div class="profile-field-actions">
                        <button type="button" class="profile-btn-save">Simpan</button>
                        <button type="button" class="profile-btn-cancel">Batal</button>
                     </div>
                  </div>
               </div>

               <div class="profile-field" data-field="tgl_lahir" data-type="date" data-raw="{{ member['tgl_lahir'] }}">
                  <span class="profile-field-label">Tanggal Lahir</span>
                  <div class="profile-field-row">
                     <span class="profile-field-value">{{ tglLahirFormatted ? tglLahirFormatted : '—' }}</span>
                     <button type="button" class="profile-field-edit" aria-label="Edit Tanggal Lahir">Edit</button>
                  </div>
                  <div class="profile-field-form" hidden>
                     <input type="date" class="profile-input" value="{{ member['tgl_lahir'] }}" />
                     <div class="profile-field-actions">
                        <button type="button" class="profile-btn-save">Simpan</button>
                        <button type="button" class="profile-btn-cancel">Batal</button>
                     </div>
                  </div>
               </div>

               <div class="profile-field" data-field="gender" data-type="select" data-raw="{{ member['gender'] }}">
                  <span class="profile-field-label">Jenis Kelamin</span>
                  <div class="profile-field-row">
                     <span class="profile-field-value">{{ genderLabel ? genderLabel : '—' }}</span>
                     <button type="button" class="profile-field-edit" aria-label="Edit Jenis Kelamin">Edit</button>
                  </div>
                  <div class="profile-field-form" hidden>
                     <select class="profile-input profile-select">
                        <option value="" disabled {% if not member['gender'] %}selected{% endif %}>Pilih jenis kelamin</option>
                        <option value="L" {% if member['gender'] == 'L' %}selected{% endif %}>Laki-laki</option>
                        <option value="P" {% if member['gender'] == 'P' %}selected{% endif %}>Perempuan</option>
                     </select>
                     <div class="profile-field-actions">
                        <button type="button" class="profile-btn-save">Simpan</button>
                        <button type="button" class="profile-btn-cancel">Batal</button>
                     </div>
                  </div>
               </div>

            </div>
         </div>

         {# ── Alamat ── #}
         <div class="profile-card r">
            <div class="profile-card-head">
               <div class="profile-card-icon">
                  <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"/><circle cx="12" cy="10" r="3"/></svg>
               </div>
               <h2 class="profile-card-title">Alamat</h2>
            </div>
            <div class="profile-card-body">

               <div class="profile-field" data-field="kota" data-type="text" data-raw="{{ member['kota'] }}">
                  <span class="profile-field-label">Kota</span>
                  <div class="profile-field-row">
                     <span class="profile-field-value">{{ member['kota'] ? member['kota'] : '—' }}</span>
                     <button type="button" class="profile-field-edit" aria-label="Edit Kota">Edit</button>
                  </div>
                  <div class="profile-field-form" hidden>
                     <input type="text" class="profile-input" value="{{ member['kota'] }}" maxlength="255" />
                     <div class="profile-field-actions">
                        <button type="button" class="profile-btn-save">Simpan</button>
                        <button type="button" class="profile-btn-cancel">Batal</button>
                     </div>
                  </div>
               </div>

               <div class="profile-field" data-field="alamat" data-type="textarea" data-raw="{{ member['alamat'] }}">
                  <span class="profile-field-label">Alamat Lengkap</span>
                  <div class="profile-field-row">
                     <span class="profile-field-value">{{ member['alamat'] ? member['alamat'] : '—' }}</span>
                     <button type="button" class="profile-field-edit" aria-label="Edit Alamat">Edit</button>
                  </div>
                  <div class="profile-field-form" hidden>
                     <textarea class="profile-input profile-textarea" rows="3">{{ member['alamat'] }}</textarea>
                     <div class="profile-field-actions">
                        <button type="button" class="profile-btn-save">Simpan</button>
                        <button type="button" class="profile-btn-cancel">Batal</button>
                     </div>
                  </div>
               </div>

            </div>
         </div>

         {# ── Keamanan ── #}
         <div class="profile-card r profile-card-full">
            <div class="profile-card-head">
               <div class="profile-card-icon profile-card-icon-security">
                  <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="11" width="18" height="11" rx="2" ry="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>
               </div>
               <h2 class="profile-card-title">Keamanan</h2>
            </div>
            <div class="profile-card-body">

               <div class="profile-field" data-field="password" data-type="password" data-raw="">
                  <span class="profile-field-label">Password</span>
                  <div class="profile-field-row">
                     <span class="profile-field-value profile-field-masked">••••••••</span>
                     <button type="button" class="profile-field-edit" aria-label="Edit Password">Edit</button>
                  </div>
                  <div class="profile-field-form" hidden>
                     <input type="password" class="profile-input" placeholder="Password baru (min. 8 karakter)" minlength="8" autocomplete="new-password" />
                     <div class="profile-field-actions">
                        <button type="button" class="profile-btn-save">Simpan</button>
                        <button type="button" class="profile-btn-cancel">Batal</button>
                     </div>
                  </div>
               </div>

            </div>
         </div>

      </div>
   </div>
</section>

<script>
   window.MEMBER_PROFILE_UPDATE_URL = "{{ url('member-profile/update') }}";
</script>
