<!-- ═══ NAVBAR ═══ -->
<nav id="nav">
   <a href="{{ url('') }}" class="nav-logo">
      <img src="{{ url('images/logo-white.png') }}" alt="Logo Ngrembel Asri" width="250px">
   </a>
   <ul class="nav-menu" id="navMenu">
      <li class="{{ this.request.getURI() == url('') ? 'active' : '' }}"><a href="{{ url('') }}">Dashboard</a></li>
      <li class="{{ this.request.getURI() == url('fasilitas') ? 'active' : '' }}"><a
            href="{{ url('fasilitas') }}">Fasilitas</a></li>
      <li class="{{ this.request.getURI() == url('menu') ? 'active' : '' }}"><a href="{{ url('menu') }}">Restoran</a>
      </li>
      <li class="{{ request.getURI() == url('wahana') ? 'active' : '' }}"><a href="{{ url('wahana') }}">Wahana</a></li>
      <li class="{{ request.getURI() == url('kritiksaran') ? 'active' : '' }}"><a href="{{ url('kritiksaran') }}">Kritik
            & Saran</a></li>
      {% if session.get('id') %}
      <li><a href="{{ url('login/logout') }}" class="nav-book">Logout</a></li>
      {% else %}
      <li><a href="{{ url('login') }}" class="nav-book">Masuk / Daftar</a></li>
      {% endif %}
   </ul>

   <div class="nav-toggle" id="navToggle">
      <span></span>
      <span></span>
      <span></span>
   </div>
</nav>