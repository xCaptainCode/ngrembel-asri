<style>
   .masonry-grid {
      column-count: 3;
      column-gap: 1rem;
      width: 100%;
      margin-top: 2rem;
   }
   .masonry-card {
      /* display: inline-block; */
      width: 100%;
      margin-bottom: 1.5rem;
      break-inside: avoid;
      position: relative;
      border-radius: 16px;
      overflow: hidden;
      background: var(--mid, #102417);
      border: 1px solid rgba(255, 255, 255, .06);
      transition: transform .4s cubic-bezier(0.16, 1, 0.3, 1), box-shadow .4s, opacity .4s, scale .4s;
      cursor: default;
   }
   .masonry-card:hover {
      transform: translateY(-6px) scale(1.01);
      box-shadow: 0 24px 60px rgba(0, 0, 0, .4);
   }
   .masonry-card.hidden {
      opacity: 0;
      transform: scale(0.9);
      display: none !important;
   }
   .masonry-img {
      width: 100%;
      height: auto;
      display: block;
      transition: transform .8s cubic-bezier(0.16, 1, 0.3, 1);
   }
   .masonry-card:hover .masonry-img {
      transform: scale(1.07);
   }
   .masonry-overlay {
      position: absolute;
      inset: 0;
      background: linear-gradient(to top, rgba(10, 28, 18, 0.95) 0%, rgba(10, 28, 18, 0.4) 50%, transparent 100%);
      pointer-events: none;
      z-index: 1;
   }
   .masonry-body {
      position: absolute;
      bottom: 0;
      left: 0;
      right: 0;
      padding: 1.5rem;
      z-index: 2;
   }
   .masonry-icon {
      width: 36px;
      height: 36px;
      border-radius: 10px;
      background: rgba(200, 168, 75, .15);
      border: 1px solid rgba(200, 168, 75, .3);
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 1.1rem;
      margin-bottom: .8rem;
      backdrop-filter: blur(4px);
      color: #d4b15a;
      font-weight: bold;
   }
   .masonry-title {
      font-family: 'Cormorant Garamond', serif;
      font-size: 1.45rem;
      font-weight: 600;
      color: #fff;
      margin-bottom: .3rem;
   }
   .masonry-desc {
      font-size: 0.85rem;
      color: rgba(255, 255, 255, .7);
      line-height: 1.6;
   }
   .masonry-tag-container {
      display: flex;
      gap: 8px;
      margin-top: .8rem;
      flex-wrap: wrap;
   }
   .masonry-tag {
      display: inline-block;
      font-size: .68rem;
      letter-spacing: 2px;
      text-transform: uppercase;
      color: #d4b15a;
      background: rgba(200, 168, 75, .12);
      padding: .25rem .75rem;
      border-radius: 20px;
      border: 1px solid rgba(200, 168, 75, .2);
   }
   .masonry-tag.free {
      color: #2a9d8f;
      background: rgba(42, 157, 143, .12);
      border-color: rgba(42, 157, 143, .2);
   }

   /* Premium category filter styling */
   .filter-tabs-container {
      display: flex;
      justify-content: center;
      gap: 12px;
      flex-wrap: wrap;
      margin-bottom: 2.5rem;
   }
   .filter-tab {
      background: rgba(255, 255, 255, 0.05);
      color: #fff;
      border: 1px solid rgba(255, 255, 255, 0.1);
      padding: 10px 24px;
      border-radius: 30px;
      font-weight: 600;
      cursor: pointer;
      transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
      font-size: 0.9rem;
      text-transform: uppercase;
      letter-spacing: 0.5px;
   }
   .filter-tab:hover {
      background: rgba(212, 177, 90, 0.15);
      border-color: rgba(212, 177, 90, 0.4);
      color: #d4b15a;
      transform: translateY(-2px);
   }
   .filter-tab.active {
      background: #d4b15a;
      color: #102417;
      border-color: #d4b15a;
      box-shadow: 0 4px 15px rgba(212, 177, 90, 0.3);
   }

   @media (max-width: 992px) {
      .masonry-grid {
         column-count: 2;
         column-gap: 1.2rem;
      }
   }
   @media (max-width: 576px) {
      .masonry-grid {
         column-count: 1;
      }
   }
</style>

<section id="page-header" style="padding-top: 140px; padding-bottom: 2rem; text-align: center; display: flex; flex-direction: column; justify-content: center; align-items: center; background: radial-gradient(circle at center, rgba(16, 36, 23, 0.4) 0%, rgba(7, 25, 14, 0) 70%);">
    <p class="s-label r">Permainan Seru</p>
    <h1 class="s-title r">Wahana <em>Permainan</em></h1>
    <div class="divider-gold r" style="margin: 1.4rem auto;"></div>
</section>

<section id="wahana" style="padding: 2rem 5% 8rem;">
   <!-- DYNAMIC FILTER TABS -->
   <div class="filter-tabs-container r" id="filterTabs">
      <button class="filter-tab active" data-filter="all">Semua</button>
      <button class="filter-tab" data-filter="gratis">Gratis</button>
      <button class="filter-tab" data-filter="berbayar">Berbayar</button>
   </div>

   {% if wahanaList is empty %}
      <p style="text-align: center; color: rgba(255,255,255,0.6); margin-top: 2rem;">Tidak ada wahana permainan aktif saat ini.</p>
   {% else %}
      <div class="masonry-grid" id="wahanaGrid">
         {% for item in wahanaList %}
            {% set image_src = item['img_url'] %}
            {% if not image_src %}
               {# fallback based on name mapping #}
               {% set name_lower = item['nama']|lower %}
               {% if name_lower == 'atv' %}
                  {% set image_src = 'images/wahana/atv.jpg' %}
               {% elseif name_lower == 'flying fox' %}
                  {% set image_src = 'images/wahana/flying-fox.jpg' %}
               {% elseif name_lower == 'kolam renang' %}
                  {% set image_src = 'images/wahana/kolam-renang.jpg' %}
               {% elseif name_lower == 'omah playon' %}
                  {% set image_src = 'images/wahana/omah-playon.jpg' %}
               {% elseif name_lower == 'omah kayu' %}
                  {% set image_src = 'images/wahana/aviary.jpg' %}
               {% elseif name_lower == 'kuda tunggang' %}
                  {% set image_src = 'images/wahana/pasar-kembang.jpg' %}
               {% else %}
                  {% set image_src = 'images/wahana/ember-tumpah.jpg' %}
               {% endif %}
            {% endif %}

            {% set tag_category = "FAMILY" %}
            {% set name_lower = item['nama']|lower %}
            {% if name_lower == 'atv' or name_lower == 'flying fox' %}
               {% set tag_category = "ADVENTURE" %}
            {% endif %}

            {% set is_free_val = (item['is_free'] == 't' or item['is_free'] === true or item['is_free'] === '1' or item['is_free'] === 1) ? '1' : '0' %}

            <div class="masonry-card r" data-is-free="{{ is_free_val }}">
               <img class="masonry-img" src="{{ url(image_src) }}" alt="{{ item['nama'] }}" />
               <div class="masonry-overlay"></div>
               <div class="masonry-body">
                  {# <div class="masonry-icon">{{ loop.index }}</div> #}
                  <div class="masonry-title">{{ item['nama'] }}</div>
                  {% if item['deskripsi'] %}
                     <div class="masonry-desc">{{ item['deskripsi'] }}</div>
                  {% endif %}
                  <div class="masonry-tag-container">
                     {# <span class="masonry-tag">{{ tag_category }}</span> #}
                     {% if is_free_val == '1' %}
                        <span class="masonry-tag free">GRATIS</span>
                     {% else %}
                        <span class="masonry-tag">Rp {{ Helpers.number(item['harga_tiket']) }}</span>
                     {% endif %}
                  </div>
               </div>
            </div>
         {% endfor %}
      </div>
   {% endif %}
</section>

<script>
   document.addEventListener('DOMContentLoaded', () => {
      const cards = document.querySelectorAll('.masonry-card');
      
      // Apply staggered transition delays via JavaScript to avoid CSS property value parsing issues
      cards.forEach((card, idx) => {
         card.style.transitionDelay = `${idx * 0.05}s`;
      });

      // Filter logic
      const tabs = document.querySelectorAll('.filter-tab');
      tabs.forEach(tab => {
         tab.addEventListener('click', () => {
            tabs.forEach(t => t.classList.remove('active'));
            tab.classList.add('active');

            const filterValue = tab.getAttribute('data-filter');

            cards.forEach(card => {
               const isFree = card.getAttribute('data-is-free') === '1';
               if (filterValue === 'all' || 
                   (filterValue === 'gratis' && isFree) || 
                   (filterValue === 'berbayar' && !isFree)) {
                  card.classList.remove('hidden');
                  setTimeout(() => {
                     card.style.opacity = '1';
                     card.style.transform = 'scale(1)';
                  }, 50);
               } else {
                  card.style.opacity = '0';
                  card.style.transform = 'scale(0.9)';
                  setTimeout(() => {
                     card.classList.add('hidden');
                  }, 300);
               }
            });
         });
      });
   });
</script>