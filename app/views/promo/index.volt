<style>
    .promo-grid {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
        gap: 2.5rem;
        width: 100%;
        margin-top: 2rem;
    }

    .promo-card {
        background: transparent;
        border: none;
        transition: transform .4s cubic-bezier(0.16, 1, 0.3, 1);
        display: flex;
        flex-direction: column;
    }

    .promo-card:hover {
        transform: translateY(-6px);
    }

    .promo-img-container {
        position: relative;
        width: 100%;
        overflow: hidden;
        border-radius: 12px;
        border: 1px solid rgba(255, 255, 255, .06);
    }

    .promo-img {
        display: block;
        width: 100%;
        height: auto;
        transition: transform .8s cubic-bezier(0.16, 1, 0.3, 1);
    }

    .promo-card:hover .promo-img {
        transform: scale(1.03);
    }

    .promo-status-badge {
        position: absolute;
        top: 1rem;
        right: 1rem;
        padding: 0.35rem 0.9rem;
        font-size: 0.75rem;
        font-weight: 700;
        border-radius: 30px;
        text-transform: uppercase;
        letter-spacing: 1px;
        box-shadow: 0 4px 10px rgba(0,0,0,0.3);
        z-index: 2;
    }

    .status-aktif {
        background: #11361f;
        color: #c9f7d8;
        border: 1px solid #2a9d52;
    }

    .status-mendatang {
        background: #142b3b;
        color: #d1f0ff;
        border: 1px solid #3fa8eb;
    }

    .status-kadaluarsa {
        background: #3a1616;
        color: #ffd1d1;
        border: 1px solid #b84141;
    }

    .promo-body {
        padding: 1.2rem 0.2rem 0;
        display: flex;
        flex-direction: column;
        flex-grow: 1;
    }

    .promo-date-range {
        font-size: 0.8rem;
        color: #d4b15a;
        display: flex;
        align-items: center;
        gap: 6px;
        margin-bottom: 0.6rem;
        font-weight: 500;
    }

    .promo-title {
        font-family: 'Cormorant Garamond', serif;
        font-size: 1.6rem;
        font-weight: 600;
        color: #fff;
        margin-bottom: 0.5rem;
        line-height: 1.2;
    }

    .promo-desc {
        font-size: 0.9rem;
        color: rgba(255, 255, 255, .7);
        line-height: 1.6;
        margin-bottom: 0;
        flex-grow: 1;
    }

    @media (max-width: 576px) {
        .promo-grid {
            grid-template-columns: 1fr;
        }
    }
</style>

<section id="page-header"
    style="padding-top: 140px; padding-bottom: 2rem; text-align: center; display: flex; flex-direction: column; justify-content: center; align-items: center; background: radial-gradient(circle at center, rgba(16, 36, 23, 0.4) 0%, rgba(7, 25, 14, 0) 70%);">
    <p class="s-label r">Penawaran Spesial</p>
    <h1 class="s-title r">Promosi <em>Menarik</em></h1>
    <div class="divider-gold r" style="margin: 1.4rem auto;"></div>
</section>

<section id="promo" style="padding: 2rem 5% 8rem;">
    {% if promotionsList is empty %}
    <p style="text-align: center; color: rgba(255,255,255,0.6); margin-top: 2rem;">Tidak ada promo aktif saat ini. Silakan kunjungi halaman ini kembali di lain waktu.</p>
    {% else %}
    <div class="promo-grid">
        {% for item in promotionsList %}
        {% set image_src = item['image_url'] ? item['image_url'] : 'images/placeholder.jpg' %}
        {% set nowTime = strtotime('now') %}
        {% set startTime = strtotime(item['start_date']) %}
        {% set endTime = strtotime(item['end_date']) %}
        <div class="promo-card r" style="cursor: pointer;" 
             data-name="{{ item['name']|escape }}" 
             data-description="{{ item['description']|escape }}" 
             data-image-url="{{ url(image_src) }}"
             data-dates="{{ date('d M Y', startTime) }} - {{ date('d M Y', endTime) }}"
             data-status-text="{% if nowTime < startTime %}Mendatang{% elseif nowTime > endTime %}Kadaluarsa{% else %}Aktif{% endif %}"
             data-status-class="{% if nowTime < startTime %}status-mendatang{% elseif nowTime > endTime %}status-kadaluarsa{% else %}status-aktif{% endif %}">
            <div class="promo-img-container">
                {% if nowTime < startTime %}
                    <span class="promo-status-badge status-mendatang">Mendatang</span>
                {% elseif nowTime > endTime %}
                    <span class="promo-status-badge status-kadaluarsa">Kadaluarsa</span>
                {% else %}
                    <span class="promo-status-badge status-aktif">Aktif</span>
                {% endif %}
                <img class="promo-img" src="{{ url(image_src) }}" alt="{{ item['name'] }}" />
            </div>
            <div class="promo-body">
                <div class="promo-date-range">
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="vertical-align: middle;">
                        <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                        <line x1="16" y1="2" x2="16" y2="6"></line>
                        <line x1="8" y1="2" x2="8" y2="6"></line>
                        <line x1="3" y1="10" x2="21" y2="10"></line>
                    </svg>
                    <span>
                        {{ date('d M Y', startTime) }} - {{ date('d M Y', endTime) }}
                    </span>
                </div>
                <div class="promo-title">{{ item['name'] }}</div>
                {% if item['description'] %}
                <div class="promo-desc">{{ item['description'] }}</div>
                {% endif %}
            </div>
        </div>
        {% endfor %}
    </div>
    {% endif %}
</section>

<!-- Lightbox Modal -->
<div id="promoLightbox" style="display:none; position:fixed; inset:0; background:rgba(0,0,0,.85); z-index:99999; align-items:center; justify-content:center; backdrop-filter: blur(8px); padding: 20px;">
    <!-- Close Button -->
    <button id="closeLightbox" style="position:absolute; top: 20px; right: 20px; background:rgba(0,0,0,0.6); border:none; color:#fff; font-size:30px; width:45px; height:45px; border-radius:50%; cursor:pointer; display:flex; align-items:center; justify-content:center; z-index:100000; transition: background 0.2s;">&times;</button>
    
    <img id="lightboxImg" src="" alt="" style="max-width:90vw; max-height:90vh; object-fit:contain; border-radius:12px; box-shadow: 0 10px 40px rgba(0,0,0,0.8); display:block; border: 1px solid rgba(255,255,255,0.1);">
</div>

<script>
document.addEventListener('DOMContentLoaded', () => {
    const lightbox = document.getElementById('promoLightbox');
    const lightboxImg = document.getElementById('lightboxImg');
    const closeBtn = document.getElementById('closeLightbox');

    const promoCards = document.querySelectorAll('.promo-card');
    promoCards.forEach(card => {
        card.addEventListener('click', () => {
            const name = card.dataset.name;
            const imgUrl = card.dataset.imageUrl;

            lightboxImg.src = imgUrl;
            lightboxImg.alt = name;

            lightbox.style.display = 'flex';
            document.body.style.overflow = 'hidden'; // Disable page scrolling
        });
    });

    const closeLightbox = () => {
        lightbox.style.display = 'none';
        document.body.style.overflow = ''; // Re-enable page scrolling
        lightboxImg.src = '';
    };

    if (closeBtn) {
        closeBtn.addEventListener('click', closeLightbox);
    }

    lightbox.addEventListener('click', (e) => {
        if (e.target === lightbox) {
            closeLightbox();
        }
    });

    // Support escape key to close
    document.addEventListener('keydown', (e) => {
        if (e.key === 'Escape' && lightbox.style.display === 'flex') {
            closeLightbox();
        }
    });
});
</script>
