<!-- ═══ FOOTER ═══ -->
<footer>
   <div class="footer-grid">
      <div>
         <div class="footer-brand-name">Ngrembel Asri</div>
         <p class="footer-tagline">{{ get_val('tagline_footer', 'Ngrembel Asri — tempat keluarga menyatu dengan alam, merasakan ketenangan, dan menciptakan kenangan abadi.') }}</p>
         <div class="footer-social">
            {% if get_val('link_instagram') != '' %}
            <a href="{{ get_val('link_instagram', '#') }}" class="fsoc" title="Instagram"><i class="fa-brands fa-instagram"></i></a>
            {% endif %}
            {% if get_val('link_tiktok') != '' %}
            <a href="{{ get_val('link_tiktok', 'https://www.tiktok.com/@ngrembelasriofficial?_t=ZS-90kqpNZCsdE&_r=1') }}" class="fsoc" title="Tiktok"><i class="fa-brands fa-tiktok"></i></a>
            {% endif %}
            {% if get_val('link_facebook') != '' %}
            <a href="{{ get_val('link_facebook', 'https://www.facebook.com/ngrembelasriofficial/') }}" class="fsoc" title="Facebook"><i class="fa-brands fa-facebook"></i></a>
            {% endif %}
            {% if get_val('link_youtube') != '' %}
            <a href="{{ get_val('link_youtube', 'https://www.youtube.com/@ngrembelasriofficial') }}" class="fsoc" title="Youtube"><i class="fa-brands fa-youtube"></i></a>
            {% endif %}
            {% if get_val('link_whatsapp') != '' %}
            <a href="{{ get_val('link_whatsapp', 'https://wa.me/6285743460206') }}" class="fsoc" title="WhatsApp"><i class="fa-brands fa-whatsapp"></i></a>
            {% endif %}
         </div>
      </div>
      <div class="footer-col">
         <h4>Navigasi</h4>
         <ul>
            <li><a href="#sejarah">Sejarah</a></li>
            <li><a href="#fasilitas">Fasilitas</a></li>
            <li><a href="#menu">Restoran</a></li>
            <li><a href="#galeri">Galeri</a></li>
            <li><a href="#tiket">Harga Tiket</a></li>
         </ul>
      </div>
      <div class="footer-col">
         <h4>Kontak</h4>
         <ul>
            <li> 📍 {{ get_val('alamat', '-') }}</li>
            <li> 📱 {{ get_val('telp', '') }} (WA)</li>
         </ul>
      </div>
      <div class="footer-col">
         <h4>Fasilitas</h4>
         <ul>
            <li><a href="#">Mini Zoo</a></li>
            <li><a href="#">Arena Paintball</a></li>
            <li><a href="#">Field Trip</a></li>
            <li><a href="#">Outbound</a></li>
            <li><a href="#">Restoran</a></li>
         </ul>
      </div>
   </div>
   <div class="footer-bottom">© 2026 Ngrembel Asri. Dibuat dengan <em>❤</em> untuk keluarga Indonesia.
   </div>
</footer>