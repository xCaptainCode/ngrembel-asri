<style>
    /* ═══════════════════════════════════════════
   GALERI SLIDESHOW FULL
   ═══════════════════════════════════════════ */
    #galeri {
        padding: 1rem 5%;
        background: var(--forest);
    }

    .galeri-main {
        position: relative;
    }

    .galeri-stage {
        position: relative;
        aspect-ratio: 16/9;
        border-radius: 20px;
        overflow: hidden;
        /* background: var(--mid); */
        box-shadow: 0 40px 80px rgba(0, 0, 0, .5);
    }

    .gslide {
        position: absolute;
        inset: 0;
        opacity: 0;
        transition: opacity 1s var(--ease-out);
    }

    .gslide.active {
        opacity: 1;
    }

    .gslide img {
        width: 100%;
        height: 100%;
        object-fit: contain;
    }

    .gslide-overlay {
        position: absolute;
        inset: 0;
        background: linear-gradient(to top, rgba(13, 36, 22, .8) 0%, transparent 40%);
    }

    .gslide-title {
        position: absolute;
        bottom: 2rem;
        left: 2.5rem;
        z-index: 2;
        font-family: 'Cormorant Garamond', serif;
        font-size: 1.4rem;
        font-style: italic;
        font-weight: bold;
        color: #fff;
    }

    .gslide-caption {
        position: absolute;
        bottom: 1rem;
        left: 2.5rem;
        z-index: 2;
        font-family: 'Cormorant Garamond', serif;
        font-size: 1rem;
        font-style: italic;
        color: #fff;
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

    /* Grid layout adjustments */
    .fav-menu-grid {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(285px, 1fr));
        gap: 28px;
        transition: all 0.5s ease;
    }

    .fav-card {
        transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
        opacity: 1;
        transform: scale(1);
    }

    .fav-card.hidden {
        opacity: 0;
        transform: scale(0.9);
        display: none !important;
    }

    .fav-card.landscape-card {
        background: transparent !important;
        border-color: transparent !important;
        box-shadow: none !important;
        justify-content: center !important;
    }

    .lightbox-img {
        max-height: 85vh;
        max-width: 90vw;
        border-radius: 12px;
        box-shadow: 0 10px 30px rgba(0, 0, 0, 0.8);
        border: 2px solid rgba(212, 177, 90, 0.5);
    }

    /* nav arrows */
    .garrow {
        position: absolute;
        top: 50%;
        z-index: 3;
        transform: translateY(-50%);
        width: 50px;
        height: 50px;
        border-radius: 50%;
        border: none;
        background: rgba(255, 255, 255, .12);
        backdrop-filter: blur(8px);
        color: #fff;
        font-size: 1.2rem;
        cursor: pointer;
        transition: background .3s;
        display: flex;
        align-items: center;
        justify-content: center;
    }

    .garrow:hover {
        background: rgba(200, 168, 75, .4);
    }

    .garrow.prev {
        left: 1.5rem;
    }

    .garrow.next {
        right: 1.5rem;
    }

    /* thumbnails */
    .galeri-thumbs {
        display: flex;
        gap: .5rem;
        margin-top: 1.2rem;
        overflow-x: auto;
        padding-bottom: .4rem;
        scrollbar-width: thin;
        scrollbar-color: var(--sage) transparent;
    }

    .gthumb {
        flex-shrink: 0;
        width: 120px;
        height: 72px;
        border-radius: 10px;
        overflow: hidden;
        border: 2px solid transparent;
        cursor: pointer;
        transition: border-color .3s, transform .3s;
    }

    .gthumb img {
        width: 100%;
        height: 100%;
        object-fit: cover;
        transition: transform .4s;
    }

    .gthumb:hover img,
    .gthumb.active img {
        transform: scale(1.08);
    }

    .gthumb.active {
        border-color: var(--gold);
    }

    /* mobile responsive */
    @media (max-width: 520px) {
        .gslide-title {
            position: absolute;
            bottom: .5rem;
            left: 1rem;
            z-index: 2;
            font-family: 'Cormorant Garamond', serif;
            font-size: 1rem;
            font-style: italic;
            font-weight: bold;
            color: #fff;
        }

        .gslide-caption {
            display: none !important;
        }

        .garrow {
            position: absolute;
            top: 50%;
            z-index: 3;
            transform: translateY(-50%);
            width: 25px;
            height: 25px;
            border-radius: 50%;
            border: none;
            background: rgba(255, 255, 255, .12);
            backdrop-filter: blur(8px);
            color: #fff;
            font-size: 1rem;
            cursor: pointer;
            transition: background .3s;
            display: flex;
            align-items: center;
            justify-content: center;
            text-align: center;
        }

        .garrow.prev {
            left: 15px;
        }

        .garrow.next {
            right: 15px;
        }
    }
</style>

<section id="page-header" style="padding-top: 120px; text-align: center;">
    <p class="s-label r">Pilihan Menu</p>
    <h1 class="s-title r">Ahlinya <em>Ikan Bakar</em></h1>
    <div class="divider-gold r" style="margin: 1.4rem auto;"></div>
</section>

<!-- ═══ MASAKAN IKAN SLIDESHOW ═══ -->
<section id="galeri">
    <div class="galeri-main r" id="galeriMain"
        data-images='[{% if jenisMasakan is not empty %}{% for index, item in jenisMasakan %}"{{ item["img_url"] ? url(item["img_url"]) : "https://images.unsplash.com/photo-1544025162-d76694265947?w=1400&q=80" }}"{% if not loop.last %},{% endif %}{% endfor %}{% else %}"https://images.unsplash.com/photo-1544025162-d76694265947?w=1400&q=80"{% endif %}]'>
        <div class="galeri-stage">
            {% if jenisMasakan is not empty %}
            {% for index, item in jenisMasakan %}
            <div class="gslide {% if index == 0 %}active{% endif %}" data-caption="{{ item['nama'] }}">
                <img src="{{ item['img_url'] ? url(item['img_url']) : 'https://images.unsplash.com/photo-1544025162-d76694265947?w=1400&q=80' }}"
                    alt="{{ item['nama'] }}" />
                <div class="gslide-overlay"></div>
                <div class="gslide-title">{{ item['nama'] }}</div>
                <div class="gslide-caption">{{ item['deskripsi'] }}</div>
            </div>
            {% endfor %}
            {% else %}
            <div class="gslide active" data-caption="Ngrembel Asri">
                <img src="https://images.unsplash.com/photo-1544025162-d76694265947?w=1400&q=80" alt="Ngrembel Asri" />
                <div class="gslide-overlay"></div>
                <div class="gslide-title">Ngrembel Asri</div>
                <div class="gslide-caption">Ahlinya Ikan Bakar</div>
            </div>
            {% endif %}
            <button class="garrow prev" onclick="moveGaleri(-1)">&#8592;</button>
            <button class="garrow next" onclick="moveGaleri(1)">&#8594;</button>
        </div>
        <div class="galeri-thumbs" id="galThumbsWrap"></div>
    </div>
</section>

<section id="page-header" style="padding-top: 120px; text-align: center;">
    <p class="s-label r">Ngrembel Asri</p>
    <h1 class="s-title r">Price <em>List</em></h1>
    <div class="divider-gold r" style="margin: 1.4rem auto;"></div>
</section>

<section id="menu-pricelist" style="padding: 2rem 5% 8rem;">
    <!-- DYNAMIC FILTER TABS -->
    <div class="filter-tabs-container r" id="filterTabs">
        <button class="filter-tab active" data-filter="all">Semua</button>
    </div>

    <div class="fav-menu-grid" id="pricelistGrid">
        {% if priceList is empty %}
        <div style="grid-column: 1/-1; text-align: center; padding: 40px; color: #fff;">
            <p style="font-size: 1.2rem; opacity: 0.7;">Data price list belum tersedia.</p>
        </div>
        {% else %}
        {% for index, item in priceList %}
        <div class="fav-card r" data-category="{{ item['kategori']|lower }}">
            <div class="fav-img-wrap {% if item['img_url'] %}zoom-trigger{% endif %}" {% if item['img_url']
                %}data-src="{{ url(item['img_url']) }}" {% endif %}
                style="border-radius:12px; overflow:hidden; position:relative;">
                {% if item['img_url'] %}
                <img src="{{ url(item['img_url']) }}" alt="{{ item['nama'] }}"
                    onload="if(this.naturalWidth > this.naturalHeight) { this.closest('.fav-card').classList.add('landscape-card'); }"
                    style="width:100%; display:block; height: auto;">
                <div class="zoom-hint">Klik untuk Zoom</div>
                <div
                    style="position: absolute; bottom: 0; left: 0; right: 0; background: linear-gradient(transparent, rgba(0,0,0,0.9)); padding: 16px; text-align: left; z-index: 2;">
                    <h4
                        style="margin: 0 0 4px; color: #fff; font-size: 1.15rem; text-shadow: 1px 1px 3px rgba(0,0,0,0.8); font-weight: 600;">
                        {{ item['nama'] }}</h4>
                    <span
                        style="font-size: 0.75rem; color: #d4b15a; text-transform: uppercase; font-weight: 700; letter-spacing: 0.8px;">{{
                        item['kategori'] }}</span>
                </div>
                {% else %}
                <div class="no-image-placeholder"
                    style="display:flex; flex-direction:column; justify-content:center; align-items:center; min-height:320px; background:#102417; border:2px dashed rgba(212,177,90,0.3); border-radius:12px; color:#d4b15a; padding: 24px; text-align: center; position: relative;">
                    <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"
                        style="margin-bottom:12px; opacity:0.7;">
                        <rect x="3" y="3" width="18" height="18" rx="2" ry="2"></rect>
                        <circle cx="8.5" cy="8.5" r="1.5"></circle>
                        <polyline points="21 15 16 10 5 21"></polyline>
                    </svg>
                    <h4 style="margin:0 0 6px; font-size:1.2rem; color:#fff;">{{ item['nama'] }}</h4>
                    <span
                        style="display: inline-block; background: rgba(212,177,90,0.15); color: #d4b15a; font-size: 0.75rem; font-weight: 700; text-transform: uppercase; padding: 4px 8px; border-radius: 4px; border: 1px solid rgba(212,177,90,0.3); letter-spacing: 0.5px; margin-bottom: 8px;">{{
                        item['kategori'] }}</span>
                    <p style="margin:0; font-size:0.85rem; opacity:0.6;">(Gambar belum tersedia)</p>
                </div>
                {% endif %}
            </div>
        </div>
        {% endfor %}
        {% endif %}
    </div>
</section>

<!-- LIGHTBOX MODAL -->
<div id="menuLightbox" class="lightbox">
    <div class="lightbox-content">
        <button class="lightbox-close" id="closeLightbox">&times;</button>
        <img src="" alt="Zoomed Menu" id="lightboxImg" class="lightbox-img">
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', () => {
        // Lightbox Setup
        const lb = document.getElementById('menuLightbox');
        const lbImg = document.getElementById('lightboxImg');
        const lbClose = document.getElementById('closeLightbox');
        const grid = document.getElementById('pricelistGrid');

        // Dynamic Filter Tabs Setup
        const tabsContainer = document.getElementById('filterTabs');
        const cards = document.querySelectorAll('.fav-card');
        cards.forEach((card, idx) => {
            card.style.transitionDelay = `${idx * 0.05}s`;
        });

        // Get unique categories from cards
        const categories = new Set();
        cards.forEach(card => {
            const cat = card.getAttribute('data-category');
            if (cat) {
                categories.add(cat);
            }
        });

        // Create a mapping for pretty names if needed, or uppercase
        categories.forEach(cat => {
            const btn = document.createElement('button');
            btn.className = 'filter-tab';
            btn.setAttribute('data-filter', cat);
            btn.textContent = cat.toUpperCase();
            tabsContainer.appendChild(btn);
        });

        // Filtering logic
        const tabs = document.querySelectorAll('.filter-tab');
        tabs.forEach(tab => {
            tab.addEventListener('click', () => {
                tabs.forEach(t => t.classList.remove('active'));
                tab.classList.add('active');

                const filterValue = tab.getAttribute('data-filter');

                cards.forEach(card => {
                    if (filterValue === 'all' || card.getAttribute('data-category') === filterValue) {
                        card.classList.remove('hidden');
                        // Add smooth transition effects
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

        // Lightbox event delegation (handles dynamically hidden/shown items safely)
        if (grid) {
            grid.addEventListener('click', (e) => {
                const trigger = e.target.closest('.zoom-trigger');
                if (trigger) {
                    const src = trigger.getAttribute('data-src');
                    if (src) {
                        lbImg.src = src;
                        lb.classList.add('active');
                        document.body.style.overflow = 'hidden';
                    }
                }
            });
        }

        const closeLB = () => {
            lb.classList.remove('active');
            document.body.style.overflow = '';
            lbImg.src = '';
        };

        if (lbClose) {
            lbClose.addEventListener('click', closeLB);
        }

        if (lb) {
            lb.addEventListener('click', (e) => {
                if (e.target === lb) closeLB();
            });
        }

        document.addEventListener('keydown', (e) => {
            if (e.key === 'Escape' && lb && lb.classList.contains('active')) {
                closeLB();
            }
        });

        // Detect landscape images to center them and remove white background
        const cardImages = document.querySelectorAll('.fav-card img');
        cardImages.forEach(img => {
            const checkRatio = () => {
                if (img.naturalWidth > img.naturalHeight) {
                    const card = img.closest('.fav-card');
                    if (card) {
                        card.classList.add('landscape-card');
                    }
                }
            };
            if (img.complete) {
                checkRatio();
            } else {
                img.addEventListener('load', checkRatio);
            }
        });
    });


    /* ─ GALLERY SLIDESHOW ─ */
    const gslides = document.querySelectorAll('.gslide');
    const thumbsWrap = document.getElementById('galThumbsWrap');
    let gcur = 0;
    const galeriMain = document.getElementById('galeriMain');
    const gImgs = galeriMain ? JSON.parse(galeriMain.getAttribute('data-images') || '[]') : [];

    if (thumbsWrap && gslides.length > 0) {
        gImgs.forEach((src, i) => {
            const t = document.createElement('div');
            t.className = 'gthumb' + (i === 0 ? ' active' : '');
            t.innerHTML = `<img src="${src}" alt="thumb ${i + 1}"/>`;
            t.onclick = () => goGaleri(i);
            thumbsWrap.appendChild(t);
        });
    }

    function goGaleri(n) {
        if (gslides.length === 0) return;
        gslides[gcur].classList.remove('active');
        const thumbs = document.querySelectorAll('.gthumb');
        if (thumbs[gcur]) thumbs[gcur].classList.remove('active');
        gcur = (n + gslides.length) % gslides.length;
        gslides[gcur].classList.add('active');
        if (thumbs[gcur]) thumbs[gcur].classList.add('active');
    }
    function moveGaleri(dir) { if (gslides.length > 0) goGaleri(gcur + dir); }
    if (gslides.length > 0) setInterval(() => goGaleri(gcur + 1), 5000); // Auto-rotate every 5 seconds

</script>