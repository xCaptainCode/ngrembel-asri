<!-- ═══ NAVBAR ═══ -->
<nav id="nav">
   <a href="{{ url('') }}" class="nav-logo">
      <img src="{{ url('images/logo-white.png') }}" alt="Logo Ngrembel Asri" width="250px">
   </a>
   <ul class="nav-menu" id="navMenu">
      <li class="{{ this.request.getURI() == url('') ? 'active' : '' }}"><a href="{{ url('') }}">Dashboard</a></li>
      <li class="{{ this.request.getURI() == url('promo') ? 'active' : '' }}"><a href="{{ url('promo') }}">Promo</a></li>
      <li class="{{ this.request.getURI() == url('price-list') ? 'active' : '' }}"><a href="{{ url('price-list') }}">Price List</a></li>
      <li class="nav-item-dropdown {{ this.request.getURI() == url('wahana') ? 'active' : '' }}">
         <a href="javascript:void(0);" class="nav-link-main nav-sub-toggle" data-target="wahanaSubmenu">
            <span>Wahana</span>
            <svg class="dropdown-chevron" width="10" height="10" viewBox="0 0 12 12" fill="none">
               <path d="M2 4l4 4 4-4" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
            </svg>
         </a>
         <ul class="nav-submenu" id="wahanaSubmenu">
            <li class="{{ this.request.getURI() == url('wahana-permainan') ? 'active' : '' }}"><a href="{{ url('wahana-permainan') }}">Permainan</a></li>
            <li class="{{ this.request.getURI() == url('wahana-paintball') ? 'active' : '' }}"><a href="{{ url('wahana-paintball') }}">Paintball</a></li>
            <li class="{{ this.request.getURI() == url('wahana-field-trip') ? 'active' : '' }}"><a href="{{ url('wahana-field-trip') }}">Field Trip</a></li>
            <li class="{{ this.request.getURI() == url('wahana-fun-game') ? 'active' : '' }}"><a href="{{ url('wahana-fun-game') }}">Fun Game</a></li>
         </ul>
      </li>
      <li class="{{ this.request.getURI() == url('mini-zoo') ? 'active' : '' }}"><a href="{{ url('mini-zoo') }}">Mini Zoo</a></li>
      <li class="{{ this.request.getURI() == url('fasilitas') ? 'active' : '' }}"><a href="{{ url('fasilitas') }}">Fasilitas</a></li>
      <li class="{{ this.request.getURI() == url('galeri') ? 'active' : '' }}"><a href="{{ url('galeri') }}">Galeri</a></li>
      <li class="{{ this.request.getURI() == url('kritik-saran') ? 'active' : '' }}"><a href="{{ url('kritik-saran') }}">Kritik & Saran</a></li>
      {% if session.get('role') == 'admin' %}
      <li class="nav-item-dropdown">
         <a href="javascript:void(0);" class="nav-link-main nav-sub-toggle" data-target="settingsSubmenu">
            <span>Settings</span>
            <svg class="dropdown-chevron" width="10" height="10" viewBox="0 0 12 12" fill="none">
               <path d="M2 4l4 4 4-4" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
            </svg>
         </a>
         <ul class="nav-submenu" id="settingsSubmenu">
            <li class="{{ this.request.getURI() == url('settings/member') ? 'active' : '' }}"><a href="{{ url('settings/member') }}">Member <i class="fas fa-check-circle"></i></a></li>
            <li class="{{ this.request.getURI() == url('settings/dashboard') ? 'active' : '' }}"><a href="{{ url('settings/dashboard') }}">Dashboard <i class="fas fa-check-circle"></i></a></li>
            <li class="{{ this.request.getURI() == url('settings/promotions') ? 'active' : '' }}"><a href="{{ url('settings/promotions') }}">Promo <i class="fas fa-check-circle"></i></a></li>
            <li class="{{ this.request.getURI() == url('settings/price_list') ? 'active' : '' }}"><a href="{{ url('settings/price_list') }}">Price List <i class="fas fa-check-circle"></i></a></li>
            <li class="{{ this.request.getURI() == url('settings/permainan') ? 'active' : '' }}"><a href="{{ url('settings/permainan') }}">Permainan <i class="fas fa-check-circle"></i></a></li>
            <li class="{{ this.request.getURI() == url('settings/paintball') ? 'active' : '' }}"><a href="{{ url('settings/paintball') }}">Paintball <i class="fas fa-check-circle"></i></a></li>
            <li class="{{ this.request.getURI() == url('settings/field_trip') ? 'active' : '' }}"><a href="{{ url('settings/field_trip') }}">Field Trip <i class="fas fa-check-circle"></i></a></li>
            <li class="{{ this.request.getURI() == url('settings/fun_game') ? 'active' : '' }}"><a href="{{ url('settings/fun_game') }}">Fun Game <i class="fas fa-check-circle"></i></a></li>
            <li class="{{ this.request.getURI() == url('settings/mini_zoo') ? 'active' : '' }}"><a href="{{ url('settings/mini_zoo') }}">Mini Zoo <i class="fas fa-check-circle"></i></a></li>
            <li class="{{ this.request.getURI() == url('settings/fasilitas') ? 'active' : '' }}"><a href="{{ url('settings/fasilitas') }}">Fasilitas <i class="fas fa-check-circle"></i></a></li>
            <li class="{{ this.request.getURI() == url('settings/galeri') ? 'active' : '' }}"><a href="{{ url('settings/galeri') }}">Galeri <i class="fas fa-check-circle"></i></a></li>
            <li class="{{ this.request.getURI() == url('settings/kritik_saran') ? 'active' : '' }}"><a href="{{ url('settings/kritik_saran') }}">Kritik & Saran <i class="fas fa-check-circle"></i></a></li>
         </ul>
      </li>
      {% endif %}
      <!-- session  -->
      {% if session.get('id') %}
      <li class="profile-wrap">
         <a href="javascript:void(0);" class="nav-book profile-btn" id="profileButton">
            <span class="profile-avatar">{{ session.get('nama')|slice(0,1)|upper }}</span>
            <span>{{ session.get('nama') }}</span>
            <svg class="profile-chevron" width="12" height="12" viewBox="0 0 12 12" fill="none">
               <path d="M2 4l4 4 4-4" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
            </svg>
         </a>

         <div class="nav-profile-menu" id="profileMenu">
            <div class="profile-header">
               <div class="profile-avatar-lg">{{ session.get('nama')|slice(0,1)|upper }}</div>
               <div class="profile-info">
                  <span class="profile-name">{{ session.get('nama') }}</span>
                  <span class="profile-badge">Member</span>
               </div>
            </div>

            <div class="profile-divider"></div>

            <a href="{{ url('member-profile') }}" class="profile-item">
               <span class="profile-icon">
                  <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
               </span>
               Profil Saya
            </a>

            {# <a href="{{ url('member-point') }}" class="profile-item">
               <span class="profile-icon">
                  <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/></svg>
               </span>
               Point Saya
            </a> #}
            
            <a href="{{ url('member-history') }}" class="profile-item">
               <span class="profile-icon">
                  <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>
               </span>
               Riwayat Transaksi
            </a>

            <div class="profile-divider"></div>

            <a href="{{ url('login/logout') }}" class="profile-item profile-logout">
               <span class="profile-icon">
                  <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/><polyline points="16 17 21 12 16 7"/><line x1="21" y1="12" x2="9" y2="12"/></svg>
               </span>
               Keluar
            </a>
         </div>
      </li>
      {% else %}
      <li><a href="{{ url('login') }}" class="nav-book px-3">Masuk / Daftar</a></li>
      {% endif %}
   </ul>

   <!-- Mobile burger (non-profile) -->
   <button class="nav-toggle" id="navToggleMobile" aria-expanded="false" aria-controls="navMenu" style="background-color: transparent; border: none; color:var(--gold); cursor: pointer;">
      <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
         <line x1="3" y1="12" x2="21" y2="12"></line>
         <line x1="3" y1="6" x2="21" y2="6"></line>
         <line x1="3" y1="18" x2="21" y2="18"></line>
      </svg>
   </button>
</nav>
