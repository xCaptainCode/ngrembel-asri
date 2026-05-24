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

<section id="page-header"
    style="padding-top: 140px; padding-bottom: 2rem; text-align: center; display: flex; flex-direction: column; justify-content: center; align-items: center; background: radial-gradient(circle at center, rgba(16, 36, 23, 0.4) 0%, rgba(7, 25, 14, 0) 70%);">
    <p class="s-label r">Satwa Eksotis</p>
    <h1 class="s-title r">Mini <em>Zoo</em></h1>
    <div class="divider-gold r" style="margin: 1.4rem auto;"></div>
</section>

<section id="mini-zoo" style="padding: 2rem 5% 8rem;">
    {% if miniZooList is empty %}
    <p style="text-align: center; color: rgba(255,255,255,0.6); margin-top: 2rem;">Tidak ada data mini zoo aktif saat
        ini.</p>
    {% else %}
    <div class="masonry-grid" id="miniZooGrid">
        {% for item in miniZooList %}
        {% set image_src = item['img_url'] ? item['img_url'] : 'images/placeholder.jpg' %}
        <div class="masonry-card r">
            <img class="masonry-img" src="{{ url(image_src) }}" alt="{{ item['nama'] }}" />
            <div class="masonry-overlay"></div>
            <div class="masonry-body">
                <div class="masonry-title">{{ item['nama'] }}</div>
                {% if item['deskripsi'] %}
                <div class="masonry-desc">{{ item['deskripsi'] }}</div>
                {% endif %}
            </div>
        </div>
        {% endfor %}
    </div>
    {% endif %}
</section>

<script>
    document.addEventListener('DOMContentLoaded', () => {
        const cards = document.querySelectorAll('.masonry-card');
        cards.forEach((card, idx) => {
            card.style.transitionDelay = `${idx * 0.05}s`;
        });
    });
</script>