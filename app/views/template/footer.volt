<!-- ═══ FOOTER ═══ -->
<footer>
   <div class="footer-grid">
      <div>
         <div class="footer-brand-name">Ngrembel Asri</div>
         <p class="footer-tagline">{{ get_setting('Tagline Footer', 'Ngrembel Asri — tempat keluarga menyatu dengan alam, merasakan ketenangan, dan menciptakan kenangan abadi.') }}</p>
         <div class="footer-social">
            {% if get_setting('Link Instagram') != '' %}
            <a href="{{ get_setting('Link Instagram', '#') }}" class="fsoc" title="Instagram"><i class="fa-brands fa-instagram"></i></a>
            {% endif %}
            {% if get_setting('Link Tiktok') != '' %} 
            <a href="{{ get_setting('Link Tiktok', 'https://www.tiktok.com/@ngrembelasriofficial?_t=ZS-90kqpNZCsdE&_r=1') }}" class="fsoc" title="Tiktok"><i class="fa-brands fa-tiktok"></i></a>
            {% endif %}
            {% if get_setting('Link Facebook') != '' %}
            <a href="{{ get_setting('Link Facebook', 'https://www.facebook.com/ngrembelasriofficial/') }}" class="fsoc" title="Facebook"><i class="fa-brands fa-facebook"></i></a>
            {% endif %}
            {% if get_setting('Link Youtube') != '' %}
            <a href="{{ get_setting('Link Youtube', 'https://www.youtube.com/@ngrembelasriofficial') }}" class="fsoc" title="Youtube"><i class="fa-brands fa-youtube"></i></a>
            {% endif %}
            {% if get_setting('Link Whatsapp') != '' %}
            <a href="{{ get_setting('Link Whatsapp', 'https://wa.me/6285743460206') }}" class="fsoc" title="WhatsApp"><i class="fa-brands fa-whatsapp"></i></a>
            {% endif %}
         </div>
      </div>
      <div class="footer-col">
         <h4>Kontak</h4>
         <ul>
            <li> <i class="fas fa-map-marked-alt mr-2"></i> {{ get_setting('Alamat', '-') }}</li>
            <li> <i class="fas fa-envelope mr-2"></i> {{ get_setting('Email', '-') }}</li>
            <li> <i class="fas fa-phone mr-2"></i> {{ get_setting('Telp', '') }}</li>
         </ul>
      </div>
      <div class="footer-col">
         <h4>Navigasi</h4>
         <ul>
            <li><a href="{{ url('') }}">Home</a></li>
            <li><a href="{{ url('price-list') }}">Price List</a></li>
            <li><a href="{{ url('mini-zoo') }}">Mini Zoo</a></li>
            <li><a href="{{ url('fasilitas') }}">Fasilitas</a></li>
            <li><a href="{{ url('galeri') }}">Galeri</a></li>
            <li><a href="{{ url('kritik-saran') }}">Kritik & Saran</a></li>
         </ul>
      </div>
      <div class="footer-col">
         <h4>Wahana</h4>
         <ul>
            <li><a href="{{ url('wahana-permainan') }}">Permainan</a></li>
            <li><a href="{{ url('wahana-paintball') }}">Paintball</a></li>
            <li><a href="{{ url('wahana-field-trip') }}">Field Trip</a></li>
            <li><a href="{{ url('wahana-fun-game') }}">Fun Game</a></li>
         </ul>
      </div>
   </div>
   <div class="footer-bottom">© 2026 Ngrembel Asri. Dibuat dengan <em>❤</em> untuk keluarga Indonesia.
   </div>
</footer>