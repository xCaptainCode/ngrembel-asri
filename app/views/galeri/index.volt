<style>
    /* ═══════════════════════════════════════════
       GALLERY STYLES & LAYOUT SYSTEM
       ═══════════════════════════════════════════ */
    #gallery-section {
        padding: 2rem 3% 8rem;
        background: var(--forest, #07190e);
        min-height: 100vh;
    }

    /* Responsive Masonry Grid */
    .masonry-grid {
        column-count: 5;
        column-gap: 1rem;
        width: 100%;
        margin-top: 1rem;
        transition: all 0.4s ease;
    }
    .masonry-grid.js-masonry-enabled {
        column-count: initial;
        column-gap: 0;
        position: relative;
    }

    .masonry-card {
        width: 100%;
        margin-bottom: 1.5rem;
        break-inside: avoid;
        position: relative;
        border-radius: 16px;
        overflow: hidden;
        background: rgba(16, 36, 23, 0.55);
        border: 1px solid rgba(255, 255, 255, 0.05);
        backdrop-filter: blur(10px);
        -webkit-backdrop-filter: blur(10px);
        transition: transform 0.4s cubic-bezier(0.16, 1, 0.3, 1), 
                    box-shadow 0.4s ease, 
                    border-color 0.4s ease,
                    opacity 0.4s ease;
        cursor: pointer;
    }

    .masonry-card:hover {
        transform: translateY(-8px);
        box-shadow: 0 20px 40px rgba(0, 0, 0, 0.5), 0 0 0 1px rgba(212, 177, 90, 0.3);
        border-color: rgba(212, 177, 90, 0.4);
    }

    .masonry-card.hidden {
        opacity: 0;
        transform: scale(0.85) translateY(15px);
        display: none !important;
    }
    .masonry-grid.js-masonry-enabled .masonry-card {
        position: absolute;
        margin-bottom: 0;
        will-change: transform;
    }

    /* Media Wrapper & Hover Interactions */
    .card-media-wrapper {
        position: relative;
        overflow: hidden;
        width: 100%;
    }

    .masonry-img {
        width: 100%;
        height: auto;
        display: block;
        transition: transform 0.8s cubic-bezier(0.16, 1, 0.3, 1);
    }

    .masonry-card:hover .masonry-img {
        transform: scale(1.06);
    }

    /* Badges & Media Indicators */
    .media-badge {
        position: absolute;
        top: 14px;
        right: 14px;
        z-index: 5;
        pointer-events: none;
    }

    .badge-icon {
        display: flex;
        align-items: center;
        gap: 6px;
        padding: 6px 14px;
        border-radius: 20px;
        font-size: 0.65rem;
        font-weight: 700;
        letter-spacing: 1.5px;
        text-transform: uppercase;
        backdrop-filter: blur(12px);
        -webkit-backdrop-filter: blur(12px);
        color: #fff;
        border: 1px solid rgba(255, 255, 255, 0.15);
        transition: all 0.3s ease;
    }

    .badge-icon.video {
        background: rgba(212, 177, 90, 0.25);
        border-color: rgba(212, 177, 90, 0.45);
        color: #ffd875;
    }

    .badge-icon.foto {
        background: rgba(16, 36, 23, 0.4);
        border-color: rgba(255, 255, 255, 0.1);
    }

    .media-overlay {
        position: absolute;
        inset: 0;
        background: rgba(7, 25, 14, 0.45);
        opacity: 0;
        display: flex;
        align-items: center;
        justify-content: center;
        transition: opacity 0.35s ease;
        z-index: 3;
    }

    .masonry-card:hover .media-overlay {
        opacity: 1;
    }

    .play-btn-circle, .zoom-btn-circle {
        width: 64px;
        height: 64px;
        border-radius: 50%;
        background: rgba(212, 177, 90, 0.9);
        color: #07190e;
        display: flex;
        align-items: center;
        justify-content: center;
        box-shadow: 0 0 25px rgba(212, 177, 90, 0.5);
        transform: scale(0.7);
        transition: transform 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275), 
                    background 0.3s ease, 
                    color 0.3s ease, 
                    box-shadow 0.3s ease;
    }

    .play-btn-circle svg {
        margin-left: 4px; /* visual alignment of play triangle */
    }

    .masonry-card:hover .play-btn-circle,
    .masonry-card:hover .zoom-btn-circle {
        transform: scale(1);
    }

    .play-btn-circle:hover, .zoom-btn-circle:hover {
        background: #ffffff;
        color: #07190e;
        transform: scale(1.08) !important;
        box-shadow: 0 0 35px rgba(255, 255, 255, 0.8);
    }

    /* Card Details Body */
    .masonry-body {
        padding: 1.25rem 1.5rem 1.5rem;
        background: linear-gradient(180deg, rgba(16, 36, 23, 0.35) 0%, rgba(16, 36, 23, 0.95) 100%);
        border-top: 1px solid rgba(255, 255, 255, 0.03);
    }

    .card-category {
        font-size: 0.65rem;
        font-weight: 700;
        color: #d4b15a;
        letter-spacing: 2px;
        text-transform: uppercase;
        display: block;
        margin-bottom: 0.4rem;
    }

    .masonry-title {
        font-family: 'Cormorant Garamond', serif;
        font-size: 1.4rem;
        font-weight: 600;
        color: #fff;
        margin-bottom: 0.3rem;
        line-height: 1.2;
    }

    .masonry-desc {
        font-size: 0.85rem;
        color: rgba(255, 255, 255, 0.65);
        line-height: 1.5;
    }

    /* Search & Controls Layout */
    .gallery-controls {
        display: flex;
        flex-direction: column;
        align-items: center;
        gap: 1.5rem;
        margin-bottom: 3.5rem;
        width: 100%;
        max-width: 600px;
        margin-left: auto;
        margin-right: auto;
        padding: 0 1rem;
    }

    .search-wrapper {
        position: relative;
        width: 100%;
    }

    .search-input {
        width: 100%;
        padding: 14px 20px 14px 50px;
        border-radius: 30px;
        background: rgba(16, 36, 23, 0.65);
        border: 1.5px solid rgba(212, 177, 90, 0.2);
        color: #fff;
        font-size: 0.95rem;
        font-weight: 500;
        transition: all 0.35s cubic-bezier(0.4, 0, 0.2, 1);
        outline: none;
        backdrop-filter: blur(12px);
        -webkit-backdrop-filter: blur(12px);
    }

    .search-input:focus {
        border-color: rgba(212, 177, 90, 0.75);
        box-shadow: 0 0 25px rgba(212, 177, 90, 0.2);
        background: rgba(16, 36, 23, 0.85);
    }

    .search-input::placeholder {
        color: rgba(255, 255, 255, 0.45);
    }

    .search-icon {
        position: absolute;
        left: 20px;
        top: 50%;
        transform: translateY(-50%);
        color: rgba(212, 177, 90, 0.6);
        transition: color 0.3s ease;
        pointer-events: none;
        display: flex;
        align-items: center;
        justify-content: center;
    }

    .search-input:focus ~ .search-icon {
        color: rgba(212, 177, 90, 1);
    }

    .clear-search-btn {
        position: absolute;
        right: 20px;
        top: 50%;
        transform: translateY(-50%);
        color: rgba(255, 255, 255, 0.4);
        background: none;
        border: none;
        cursor: pointer;
        transition: color 0.3s ease;
        padding: 0;
        display: none;
        align-items: center;
        justify-content: center;
    }

    .clear-search-btn:hover {
        color: #fff;
    }

    .clear-search-btn.show {
        display: flex;
    }

    /* Dynamic Filter Tabs */
    .filter-tabs-container {
        display: flex;
        justify-content: center;
        gap: 12px;
        flex-wrap: wrap;
    }

    .filter-tab {
        background: rgba(255, 255, 255, 0.03);
        color: rgba(255, 255, 255, 0.7);
        border: 1px solid rgba(255, 255, 255, 0.08);
        padding: 10px 28px;
        border-radius: 30px;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        font-size: 0.85rem;
        text-transform: uppercase;
        letter-spacing: 1px;
    }

    .filter-tab:hover {
        background: rgba(212, 177, 90, 0.12);
        border-color: rgba(212, 177, 90, 0.3);
        color: #d4b15a;
        transform: translateY(-2px);
    }

    .filter-tab.active {
        background: #d4b15a;
        color: #07190e;
        border-color: #d4b15a;
        box-shadow: 0 4px 20px rgba(212, 177, 90, 0.4);
    }

    /* ═══════════════════════════════════════════
       PREMIUM GLASSMORPHIC LIGHTBOX
       ═══════════════════════════════════════════ */
    .lightbox-modal {
        position: fixed;
        inset: 0;
        z-index: 10000;
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        opacity: 0;
        pointer-events: none;
        transition: opacity 0.4s ease;
        padding: 24px;
    }

    .lightbox-modal.active {
        opacity: 1;
        pointer-events: all;
    }

    .lightbox-backdrop {
        position: absolute;
        inset: 0;
        background: rgba(3, 10, 6, 0.85);
        backdrop-filter: blur(15px);
        -webkit-backdrop-filter: blur(15px);
        z-index: -1;
    }

    .lightbox-close {
        position: absolute;
        top: 24px;
        right: 24px;
        background: rgba(255, 255, 255, 0.08);
        border: 1px solid rgba(255, 255, 255, 0.1);
        color: #fff;
        width: 48px;
        height: 48px;
        border-radius: 50%;
        cursor: pointer;
        display: flex;
        align-items: center;
        justify-content: center;
        transition: all 0.3s ease;
        z-index: 10002;
    }

    .lightbox-close:hover {
        background: #d4b15a;
        border-color: #d4b15a;
        color: #07190e;
        transform: rotate(90deg) scale(1.05);
    }

    .lightbox-content-container {
        width: 100%;
        max-width: 900px;
        display: flex;
        flex-direction: column;
        align-items: center;
        z-index: 10001;
        transform: scale(0.92);
        transition: transform 0.4s cubic-bezier(0.16, 1, 0.3, 1);
    }

    .lightbox-modal.active .lightbox-content-container {
        transform: scale(1);
    }

    .lightbox-media-wrapper {
        width: 100%;
        background: rgba(0, 0, 0, 0.3);
        border-radius: 20px 20px 0 0;
        border: 1px solid rgba(255, 255, 255, 0.05);
        border-bottom: none;
        overflow: hidden;
        display: flex;
        justify-content: center;
        align-items: center;
        position: relative;
        box-shadow: 0 30px 60px rgba(0, 0, 0, 0.65);
    }

    .lightbox-media-element {
        max-width: 100%;
        max-height: 70vh;
        object-fit: contain;
        display: block;
        border-radius: 20px 20px 0 0;
    }

    #lightboxVideoWrapper {
        width: 100%;
        aspect-ratio: 16/9;
        background: #000;
        display: flex;
        align-items: center;
        justify-content: center;
    }

    .lightbox-video-tag {
        width: 100%;
        height: 100%;
        outline: none;
    }

    .lightbox-caption-panel {
        width: 100%;
        background: rgba(16, 36, 23, 0.9);
        backdrop-filter: blur(10px);
        -webkit-backdrop-filter: blur(10px);
        border: 1px solid rgba(255, 255, 255, 0.05);
        border-top: none;
        border-radius: 0 0 20px 20px;
        padding: 1.5rem 2.2rem;
        color: #fff;
        box-sizing: border-box;
        box-shadow: 0 30px 60px rgba(0, 0, 0, 0.65);
    }

    .lightbox-info-row {
        display: flex;
        gap: 10px;
        margin-bottom: 0.5rem;
    }

    .lightbox-badge {
        font-size: 0.65rem;
        font-weight: 700;
        letter-spacing: 1px;
        padding: 4px 10px;
        border-radius: 4px;
        background: rgba(255, 255, 255, 0.08);
        color: rgba(255, 255, 255, 0.8);
        text-transform: uppercase;
    }

    .lightbox-badge.type {
        background: rgba(212, 177, 90, 0.15);
        color: #d4b15a;
        border: 1px solid rgba(212, 177, 90, 0.2);
    }

    .lightbox-title {
        font-family: 'Cormorant Garamond', serif;
        font-size: 1.7rem;
        font-weight: 700;
        color: #fff;
        margin: 0 0 0.4rem 0;
        line-height: 1.2;
    }

    .lightbox-desc {
        font-size: 0.9rem;
        color: rgba(255, 255, 255, 0.7);
        margin: 0;
        line-height: 1.6;
    }

    .hidden {
        display: none !important;
    }

    /* Responsive Breakpoints */
    @media (max-width: 992px) {
        .masonry-grid {
            column-count: 2;
            column-gap: 1rem;
        }
        .lightbox-content-container {
            max-width: 100%;
        }
    }

    @media (max-width: 576px) {
        .masonry-grid {
            column-count: 1;
            column-gap: 0;
        }
        .filter-tab {
            padding: 8px 20px;
            font-size: 0.8rem;
        }
        .lightbox-close {
            top: 16px;
            right: 16px;
            width: 40px;
            height: 40px;
        }
        .lightbox-caption-panel {
            padding: 1.25rem 1.5rem;
        }
        .lightbox-title {
            font-size: 1.4rem;
        }
    }

    /* Icon play permanent untuk thumbnail video */
    .video-play-indicator {
        position: absolute;
        bottom: 14px;
        left: 14px;
        z-index: 4;
        width: 40px;
        height: 40px;
        border-radius: 50%;
        background: rgba(7, 25, 14, 0.72);
        border: 2px solid rgba(212, 177, 90, 0.7);
        display: flex;
        align-items: center;
        justify-content: center;
        pointer-events: none;
        backdrop-filter: blur(6px);
        -webkit-backdrop-filter: blur(6px);
        transition: opacity 0.3s ease;
    }

    /* Sembunyikan indicator saat hover karena .play-btn-circle sudah muncul */
    .masonry-card:hover .video-play-indicator {
        opacity: 0;
    }

    /* ═══════════════════════════════════════════
       LOAD MORE BUTTON
       ═══════════════════════════════════════════ */
    .load-more-container {
        display: flex;
        flex-direction: column;
        align-items: center;
        gap: 1rem;
        margin-top: 3rem;
        padding-bottom: 2rem;
    }

    .load-more-counter {
        font-size: 0.8rem;
        color: rgba(255, 255, 255, 0.45);
        letter-spacing: 1px;
        font-weight: 500;
    }

    .load-more-btn {
        display: inline-flex;
        align-items: center;
        gap: 10px;
        padding: 14px 42px;
        border-radius: 50px;
        background: rgba(212, 177, 90, 0.1);
        border: 1.5px solid rgba(212, 177, 90, 0.4);
        color: #d4b15a;
        font-size: 0.9rem;
        font-weight: 700;
        letter-spacing: 1.5px;
        text-transform: uppercase;
        cursor: pointer;
        backdrop-filter: blur(12px);
        -webkit-backdrop-filter: blur(12px);
        transition: all 0.4s cubic-bezier(0.16, 1, 0.3, 1);
        position: relative;
        overflow: hidden;
    }

    .load-more-btn::before {
        content: '';
        position: absolute;
        inset: 0;
        background: linear-gradient(135deg, rgba(212, 177, 90, 0.15), rgba(212, 177, 90, 0));
        opacity: 0;
        transition: opacity 0.4s ease;
    }

    .load-more-btn:hover {
        background: rgba(212, 177, 90, 0.2);
        border-color: #d4b15a;
        transform: translateY(-3px);
        box-shadow: 0 12px 35px rgba(212, 177, 90, 0.25), 0 0 0 1px rgba(212, 177, 90, 0.1);
    }

    .load-more-btn:hover::before {
        opacity: 1;
    }

    .load-more-btn:active {
        transform: translateY(-1px);
    }

    .load-more-btn.loading {
        pointer-events: none;
        opacity: 0.7;
    }

    .load-more-btn .spinner {
        display: none;
        width: 18px;
        height: 18px;
        border: 2.5px solid rgba(212, 177, 90, 0.3);
        border-top-color: #d4b15a;
        border-radius: 50%;
        animation: loadSpin 0.7s linear infinite;
    }

    .load-more-btn.loading .spinner {
        display: block;
    }

    .load-more-btn.loading .btn-label {
        display: none;
    }

    .load-more-progress {
        width: 200px;
        height: 3px;
        background: rgba(255, 255, 255, 0.06);
        border-radius: 3px;
        overflow: hidden;
        margin-top: 0.5rem;
    }

    .load-more-progress-bar {
        height: 100%;
        background: linear-gradient(90deg, #d4b15a, #e8cc73);
        border-radius: 3px;
        transition: width 0.6s cubic-bezier(0.16, 1, 0.3, 1);
        width: 0%;
    }

    @keyframes loadSpin {
        to { transform: rotate(360deg); }
    }

    .load-more-hidden {
        display: none !important;
    }
</style>

<!-- HEADER SECTION -->
<section id="page-header" style="padding-top: 140px; padding-bottom: 2rem; text-align: center; display: flex; flex-direction: column; justify-content: center; align-items: center; background: radial-gradient(circle at center, rgba(16, 36, 23, 0.4) 0%, rgba(7, 25, 14, 0) 70%);">
    <p class="s-label r">Memori Kebahagiaan</p>
    <h1 class="s-title r">Galeri <em>Kenangan</em></h1>
    <div class="divider-gold r" style="margin: 1.4rem auto;"></div>
    <p class="s-body r" style="max-width: 600px; margin: 0 auto; color: rgba(255, 255, 255, 0.75); font-size: 1.05rem; line-height: 1.6; padding: 0 1rem;">
        Telusuri momen-momen penuh kebersamaan, keindahan alam, dan petualangan seru yang terabadikan di Ngrembel Asri.
    </p>
</section>

<!-- MAIN GALLERY SECTION -->
<section id="gallery-section">
    <div class="gallery-controls r">
        <!-- SEARCH BAR -->
        <div class="search-wrapper">
            <input type="text" id="gallerySearch" class="search-input" placeholder="Cari foto atau video kenangan..." value="{{ searchQuery|default('') }}">
            <span class="search-icon">
                <svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                    <circle cx="11" cy="11" r="8"></circle>
                    <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
                </svg>
            </span>
            <button id="clearSearchBtn" class="clear-search-btn" title="Hapus pencarian">
                <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                    <line x1="18" y1="6" x2="6" y2="18"></line>
                    <line x1="6" y1="6" x2="18" y2="18"></line>
                </svg>
            </button>
        </div>

        <!-- DYNAMIC FILTER TABS -->
        <div class="filter-tabs-container" id="filterTabs">
            <button class="filter-tab active" data-filter="all">Semua</button>
            <button class="filter-tab" data-filter="photo">Foto</button>
            <button class="filter-tab" data-filter="video">Video</button>
        </div>
    </div>

    <!-- GALLERY GRID -->
    {% if galleryList is empty %}
        <div style="text-align: center; padding: 5rem 0; color: rgba(255, 255, 255, 0.65);">
            <svg viewBox="0 0 24 24" width="48" height="48" fill="none" stroke="currentColor" stroke-width="1.5" style="margin: 0 auto 1rem; opacity: 0.6;">
                <rect x="3" y="3" width="18" height="18" rx="2" ry="2"></rect>
                <circle cx="8.5" cy="8.5" r="1.5"></circle>
                <polyline points="21 15 16 10 5 21"></polyline>
            </svg>
            <p style="font-size: 1.15rem; margin: 0;">Belum ada konten galeri yang dipublikasikan saat ini.</p>
        </div>
    {% else %}
        <div class="masonry-grid" id="galleryGrid">
            {% for item in galleryList %}
                <div class="masonry-card r" 
                     data-media-type="{{ item['type'] }}" 
                     data-id="{{ item['id'] }}">
                    
                    <div class="card-media-wrapper">
                        {% if item['type'] == 'video' %}
                            {% if item['poster_path'] is not empty %}
                                <img class="masonry-img" src="{{ url(item['poster_path']) }}" alt="{{ item['title'] }}" style="background:#07190e;" />
                            {% else %}
                                <div class="masonry-img" style="aspect-ratio: 16/9; background:#07190e; display: flex; align-items: center; justify-content: center; color: rgba(255,255,255,0.3);">
                                    <i class="fas fa-video fa-2x"></i>
                                </div>
                            {% endif %}
                            <div class="video-play-indicator">
                                <svg viewBox="0 0 24 24" width="18" height="18" fill="#d4b15a">
                                    <polygon points="8 5 19 12 8 19 8 5"></polygon>
                                </svg>
                            </div>
                        {% else %}
                            <img class="masonry-img" src="{{ url(item['thumb_sm_path']) }}" alt="{{ item['title'] }}" />
                        {% endif %}
                        
                        <!-- Media Type Badges -->
                        <div class="media-badge">
                            {% if item['type'] == 'video' %}
                                <span class="badge-icon video">
                                    <i class="fas fa-video"></i>
                                    {% if item['duration_seconds'] > 0 %}
                                        {{ sprintf("%02d:%02d", item['duration_seconds'] / 60, item['duration_seconds'] % 60) }}
                                    {% else %}
                                        Video
                                    {% endif %}
                                </span>
                            {% else %}
                                <span class="badge-icon foto">
                                    <svg viewBox="0 0 24 24" width="12" height="12" fill="none" stroke="currentColor" stroke-width="2.5" style="display:inline-block; vertical-align:middle; margin-right:4px;">
                                        <rect x="3" y="3" width="18" height="18" rx="2" ry="2"></rect>
                                        <circle cx="8.5" cy="8.5" r="1.5"></circle>
                                        <polyline points="21 15 16 10 5 21"></polyline>
                                    </svg>
                                    Foto
                                </span>
                            {% endif %}
                        </div>

                        <!-- Hover Overlay & Media Indicators -->
                        <div class="media-overlay">
                            <div class="action-btn">
                                {% if item['type'] == 'video' %}
                                    <div class="play-btn-circle">
                                        <svg viewBox="0 0 24 24" width="28" height="28" fill="currentColor">
                                            <polygon points="8 5 19 12 8 19 8 5"></polygon>
                                        </svg>
                                    </div>
                                {% else %}
                                    <div class="zoom-btn-circle">
                                        <svg viewBox="0 0 24 24" width="24" height="24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                                            <circle cx="11" cy="11" r="8"></circle>
                                            <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
                                            <line x1="11" y1="8" x2="11" y2="14"></line>
                                            <line x1="8" y1="11" x2="14" y2="11"></line>
                                        </svg>
                                    </div>
                                {% endif %}
                            </div>
                        </div>
                    </div>

                    <!-- Card Body -->
                    <div class="masonry-body">
                        <h3 class="masonry-title">{{ item['title'] }}</h3>
                        {% if item['description'] %}
                            <p class="masonry-desc">{{ item['description'] }}</p>
                        {% endif %}
                    </div>
                </div>
            {% endfor %}
        </div>

        <!-- LOAD MORE BUTTON -->
        {% if totalCount > perPage %}
        <div class="load-more-container" id="loadMoreContainer">
            <span class="load-more-counter" id="loadMoreCounter">
                Menampilkan <span id="shownCount">{{ galleryList|length }}</span> dari <span id="totalCountDisplay">{{ totalCount }}</span> item
            </span>
            <button class="load-more-btn" id="loadMoreBtn">
                <span class="btn-label">Muat Lebih Banyak</span>
                <span class="spinner"></span>
                <svg class="btn-label" viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                    <polyline points="7 13 12 18 17 13"></polyline>
                    <line x1="12" y1="18" x2="12" y2="6"></line>
                </svg>
            </button>
            <div class="load-more-progress">
                <div class="load-more-progress-bar" id="loadMoreProgress"></div>
            </div>
        </div>
        {% endif %}
    {% endif %}
</section>

<!-- LIGHTBOX MODAL -->
<div id="galleryLightbox" class="lightbox-modal">
    <div class="lightbox-backdrop"></div>
    <button class="lightbox-close" id="lightboxCloseBtn" aria-label="Tutup galeri">
        <svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
            <line x1="18" y1="6" x2="6" y2="18"></line>
            <line x1="6" y1="6" x2="18" y2="18"></line>
        </svg>
    </button>
    
    <div class="lightbox-content-container">
        <!-- Media Container -->
        <div class="lightbox-media-wrapper">
            <img src="" alt="Full view" id="lightboxImage" class="lightbox-media-element hidden">
            <div id="lightboxVideoWrapper" class="lightbox-media-element hidden">
                <video src="" id="lightboxVideo" controls autoplay playsinline loop class="lightbox-video-tag"></video>
            </div>
        </div>
        
        <!-- Caption Panel -->
        <div class="lightbox-caption-panel">
            <div class="lightbox-info-row" style="justify-content: space-between; align-items: center; width: 100%;">
                <div style="display: flex; gap: 10px;">
                    <span id="lightboxType" class="lightbox-badge type">FOTO</span>
                </div>
                <div>
                    <a href="" id="lightboxDownloadBtn" class="btn-gold" style="padding: 6px 16px; font-size: 0.75rem; border-radius: 20px; text-decoration: none; display: inline-flex; align-items: center; gap: 6px; font-weight: 600; line-height: 1;">
                        <svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"></path>
                            <polyline points="7 10 12 15 17 10"></polyline>
                            <line x1="12" y1="15" x2="12" y2="3"></line>
                        </svg>
                        Unduh
                    </a>
                </div>
            </div>
            <h3 id="lightboxTitle" class="lightbox-title" style="margin-top: 0.8rem;">Title</h3>
            <p id="lightboxDesc" class="lightbox-desc">Description</p>
        </div>
    </div>
</div>

<script id="galleryConfig" type="application/json">
    {
        "perPage": {{ perPage }},
        "initialCount": {{ galleryList|length }},
        "totalCount": {{ totalCount }},
        "loadMoreUrl": "{{ url('galeri/load-more') }}",
        "detailUrl": "{{ url('galeri/detail/') }}",
        "searchQuery": "{{ searchQuery|default('') }}"
    }
</script>

<script>
    document.addEventListener('DOMContentLoaded', () => {
        const grid = document.getElementById('galleryGrid');
        const tabs = document.querySelectorAll('.filter-tab');
        
        // Lightbox elements
        const lightbox = document.getElementById('galleryLightbox');
        const lbImg = document.getElementById('lightboxImage');
        const lbVideoWrapper = document.getElementById('lightboxVideoWrapper');
        const lbVideo = document.getElementById('lightboxVideo');
        const lbClose = document.getElementById('lightboxCloseBtn');
        const lbType = document.getElementById('lightboxType');
        const lbTitle = document.getElementById('lightboxTitle');
        const lbDesc = document.getElementById('lightboxDesc');
        const lbDownloadBtn = document.getElementById('lightboxDownloadBtn');

        // Load More elements
        const loadMoreContainer = document.getElementById('loadMoreContainer');
        const loadMoreBtn = document.getElementById('loadMoreBtn');
        const shownCountEl = document.getElementById('shownCount');
        const totalCountEl = document.getElementById('totalCountDisplay');
        const progressBar = document.getElementById('loadMoreProgress');

        // State (from server-side config)
        const cfgEl = document.getElementById('galleryConfig');
        const cfg = cfgEl ? JSON.parse(cfgEl.textContent) : {};
        const PER_PAGE = cfg.perPage || 12;
        let currentOffset = cfg.initialCount || 0;
        let currentFilter = 'all';
        let currentSearch = cfg.searchQuery || '';
        let totalItems = cfg.totalCount || 0;
        let isLoading = false;

        // Search DOM elements
        const searchInput = document.getElementById('gallerySearch');
        const clearSearchBtn = document.getElementById('clearSearchBtn');

        // Helper: get all cards currently in the grid
        const getAllCards = () => grid ? [...grid.querySelectorAll('.masonry-card')] : [];

        // Apply staggered animation delay to card elements on page load
        getAllCards().forEach((card, idx) => {
            card.style.transitionDelay = `${(idx % 12) * 0.04}s`;
        });
        
        if (!grid) {
            return;
        }

        // Toggle clear button on load
        if (searchInput && searchInput.value) {
            if (clearSearchBtn) clearSearchBtn.classList.add('show');
        }

        const updateClearButton = () => {
            if (clearSearchBtn) {
                if (searchInput && searchInput.value) {
                    clearSearchBtn.classList.add('show');
                } else {
                    clearSearchBtn.classList.remove('show');
                }
            }
        };

        // ═══════════════════════════════════════════
        // MASONRY LAYOUT ENGINE
        // ═══════════════════════════════════════════
        const getColumnCount = () => {
            if (window.innerWidth <= 576) return 1;
            if (window.innerWidth <= 992) return 2;
            return 5;
        };

        const getGap = () => (window.innerWidth <= 992 ? 20 : 24);

        const layoutMasonry = () => {
            if (!grid) return;
            const allCards = getAllCards();
            const visibleCards = allCards.filter(c => !c.classList.contains('hidden'));
            
            if (visibleCards.length === 0) {
                grid.classList.remove('js-masonry-enabled');
                grid.style.height = 'auto';
                return;
            }

            grid.classList.add('js-masonry-enabled');

            const columnCount = getColumnCount();
            const gap = getGap();
            const gridWidth = grid.clientWidth;
            const columnWidth = (gridWidth - (gap * (columnCount - 1))) / columnCount;
            const columnHeights = Array(columnCount).fill(0);

            visibleCards.forEach((card) => {
                card.style.width = `${columnWidth}px`;
                card.style.left = '0px';
                card.style.top = '0px';
            });

            visibleCards.forEach((card) => {
                const minHeight = Math.min(...columnHeights);
                const targetColumn = columnHeights.indexOf(minHeight);
                const x = targetColumn * (columnWidth + gap);
                const y = minHeight;

                card.style.left = `${x}px`;
                card.style.top = `${y}px`;
                columnHeights[targetColumn] = minHeight + card.offsetHeight + gap;
            });

            grid.style.height = `${Math.max(...columnHeights)}px`;
        };

        let resizeTimeout = null;
        const relayout = () => {
            if (resizeTimeout) clearTimeout(resizeTimeout);
            resizeTimeout = setTimeout(layoutMasonry, 100);
        };

        window.addEventListener('resize', relayout);

        // Wait for all images to load before initial masonry layout
        const waitForImages = (container, callback) => {
            const images = container.querySelectorAll('img');
            let pending = images.length;
            if (pending === 0) {
                callback();
                return;
            }
            const onDone = () => {
                pending--;
                if (pending <= 0) callback();
            };
            images.forEach(img => {
                if (img.complete) {
                    onDone();
                } else {
                    img.addEventListener('load', onDone, { once: true });
                    img.addEventListener('error', onDone, { once: true });
                }
            });
        };

        waitForImages(grid, layoutMasonry);

        // ═══════════════════════════════════════════
        // PROGRESS BAR & COUNTER UPDATE
        // ═══════════════════════════════════════════
        const updateProgress = () => {
            if (!loadMoreContainer) return;
            const visibleCount = getAllCards().filter(c => !c.classList.contains('hidden')).length;
            if (shownCountEl) shownCountEl.textContent = visibleCount;
            if (totalCountEl) totalCountEl.textContent = totalItems;
            if (progressBar) {
                const pct = totalItems > 0 ? Math.min((visibleCount / totalItems) * 100, 100) : 100;
                progressBar.style.width = `${pct}%`;
            }
            // Hide the button when all items are loaded
            if (currentOffset >= totalItems) {
                if (loadMoreBtn) loadMoreBtn.classList.add('load-more-hidden');
            } else {
                if (loadMoreBtn) loadMoreBtn.classList.remove('load-more-hidden');
            }
        };

        updateProgress();

        // ═══════════════════════════════════════════
        // CREATE CARD HTML FROM DATA
        // ═══════════════════════════════════════════
        const createCardElement = (item) => {
            const card = document.createElement('div');
            card.className = 'masonry-card r';
            card.setAttribute('data-media-type', item.type);
            card.setAttribute('data-id', item.id);
            card.style.opacity = '0';
            card.style.transform = 'translateY(30px)';

            const isVideo = item.type === 'video';
            const imgSrc = isVideo
                ? (item.poster_url || '')
                : (item.thumb_sm_url || '');

            const durationText = item.duration_seconds > 0
                ? `${String(Math.floor(item.duration_seconds / 60)).padStart(2, '0')}:${String(item.duration_seconds % 60).padStart(2, '0')}`
                : 'Video';

            let mediaHTML = '';
            if (isVideo) {
                if (imgSrc) {
                    mediaHTML = `<img class="masonry-img" src="${imgSrc}" alt="${item.title}" style="background:#07190e;" />`;
                } else {
                    mediaHTML = `<div class="masonry-img" style="aspect-ratio: 16/9; background:#07190e; display: flex; align-items: center; justify-content: center; color: rgba(255,255,255,0.3);"><i class="fas fa-video fa-2x"></i></div>`;
                }
                mediaHTML += `<div class="video-play-indicator"><svg viewBox="0 0 24 24" width="18" height="18" fill="#d4b15a"><polygon points="8 5 19 12 8 19 8 5"></polygon></svg></div>`;
            } else {
                mediaHTML = `<img class="masonry-img" src="${imgSrc}" alt="${item.title}" />`;
            }

            const badgeHTML = isVideo
                ? `<span class="badge-icon video"><i class="fas fa-video"></i> ${durationText}</span>`
                : `<span class="badge-icon foto"><svg viewBox="0 0 24 24" width="12" height="12" fill="none" stroke="currentColor" stroke-width="2.5" style="display:inline-block; vertical-align:middle; margin-right:4px;"><rect x="3" y="3" width="18" height="18" rx="2" ry="2"></rect><circle cx="8.5" cy="8.5" r="1.5"></circle><polyline points="21 15 16 10 5 21"></polyline></svg> Foto</span>`;

            const overlayBtnHTML = isVideo
                ? `<div class="play-btn-circle"><svg viewBox="0 0 24 24" width="28" height="28" fill="currentColor"><polygon points="8 5 19 12 8 19 8 5"></polygon></svg></div>`
                : `<div class="zoom-btn-circle"><svg viewBox="0 0 24 24" width="24" height="24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"></circle><line x1="21" y1="21" x2="16.65" y2="16.65"></line><line x1="11" y1="8" x2="11" y2="14"></line><line x1="8" y1="11" x2="14" y2="11"></line></svg></div>`;

            const descHTML = item.description ? `<p class="masonry-desc">${item.description}</p>` : '';

            card.innerHTML = `
                <div class="card-media-wrapper">
                    ${mediaHTML}
                    <div class="media-badge">${badgeHTML}</div>
                    <div class="media-overlay"><div class="action-btn">${overlayBtnHTML}</div></div>
                </div>
                <div class="masonry-body">
                    <h3 class="masonry-title">${item.title}</h3>
                    ${descHTML}
                </div>
            `;

            return card;
        };

        // ═══════════════════════════════════════════
        // UNIFIED SEARCH AND FILTER LOGIC (Server-Side)
        // ═══════════════════════════════════════════
        const performSearchAndFilter = (resetOffset = true) => {
            if (isLoading) return;
            isLoading = true;
            
            if (resetOffset) {
                currentOffset = 0;
            }

            if (loadMoreBtn) loadMoreBtn.classList.add('loading');

            const params = new URLSearchParams({
                offset: currentOffset,
                limit: PER_PAGE,
                filter: currentFilter,
                q: currentSearch,
            });

            fetch(`${cfg.loadMoreUrl}?${params.toString()}`)
                .then(res => res.json())
                .then(res => {
                    if (res.status === 'ok') {
                        totalItems = res.total;
                        
                        if (resetOffset) {
                            grid.innerHTML = '';
                        }

                        if (res.data.length > 0) {
                            const fragment = document.createDocumentFragment();
                            const newCards = [];

                            res.data.forEach((item, idx) => {
                                const card = createCardElement(item);
                                card.style.transitionDelay = `${(idx % 12) * 0.04}s`;
                                fragment.appendChild(card);
                                newCards.push(card);
                            });

                            grid.appendChild(fragment);
                            currentOffset = resetOffset ? res.data.length : currentOffset + res.data.length;

                            waitForImages(grid, () => {
                                layoutMasonry();
                                requestAnimationFrame(() => {
                                    newCards.forEach(card => {
                                        card.style.transition = 'opacity 0.5s ease, transform 0.5s cubic-bezier(0.16, 1, 0.3, 1)';
                                        card.style.opacity = '1';
                                        card.style.transform = 'translateY(0)';
                                    });
                                });
                            });
                        } else {
                            if (resetOffset) {
                                grid.style.height = 'auto';
                                grid.classList.remove('js-masonry-enabled');
                                grid.innerHTML = `
                                    <div class="no-results r" style="text-align: center; padding: 5rem 1rem; color: rgba(255, 255, 255, 0.5); width: 100%; grid-column: 1 / -1;">
                                        <svg viewBox="0 0 24 24" width="48" height="48" fill="none" stroke="currentColor" stroke-width="1.5" style="margin: 0 auto 1rem; opacity: 0.6; color: #d4b15a;">
                                            <circle cx="11" cy="11" r="8"></circle>
                                            <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
                                            <line x1="8" y1="11" x2="14" y2="11"></line>
                                        </svg>
                                        <p style="font-size: 1.15rem; margin-bottom: 0.5rem; font-weight: 600; color: #d4b15a;">Tidak ada hasil ditemukan</p>
                                        <p style="font-size: 0.95rem; margin: 0; max-width: 400px; margin: 0 auto;">Kami tidak dapat menemukan foto atau video dengan kata kunci "${currentSearch}". Coba kata kunci lain.</p>
                                    </div>
                                `;
                            }
                        }

                        updateProgress();
                    } else {
                        if (loadMoreBtn) loadMoreBtn.classList.add('load-more-hidden');
                    }
                })
                .catch(err => {
                    console.error('Error loading items:', err);
                })
                .finally(() => {
                    isLoading = false;
                    if (loadMoreBtn) loadMoreBtn.classList.remove('loading');
                });
        };

        if (loadMoreBtn) {
            loadMoreBtn.addEventListener('click', () => performSearchAndFilter(false));
        }

        // Debounced Live Search
        let debounceTimer = null;
        if (searchInput) {
            searchInput.addEventListener('input', () => {
                updateClearButton();
                currentSearch = searchInput.value.trim();
                
                clearTimeout(debounceTimer);
                debounceTimer = setTimeout(() => {
                    performSearchAndFilter(true);
                }, 400);
            });
        }

        if (clearSearchBtn) {
            clearSearchBtn.addEventListener('click', () => {
                if (searchInput) {
                    searchInput.value = '';
                    updateClearButton();
                    currentSearch = '';
                    performSearchAndFilter(true);
                }
            });
        }

        // Filter tabs trigger search reload
        tabs.forEach(tab => {
            tab.addEventListener('click', () => {
                tabs.forEach(t => t.classList.remove('active'));
                tab.classList.add('active');

                currentFilter = tab.getAttribute('data-filter');
                performSearchAndFilter(true);
            });
        });

        // ═══════════════════════════════════════════
        // LIGHTBOX SHOW LOGIC
        // ═══════════════════════════════════════════
        if (grid) {
            grid.addEventListener('click', (e) => {
                const card = e.target.closest('.masonry-card');
                if (!card) return;

                const mediaId = card.getAttribute('data-id');

                // Tampilkan loading state
                lbTitle.textContent = 'Memuat...';
                lbDesc.textContent = '';
                lbType.textContent = '...';
                
                lbImg.classList.add('hidden');
                lbVideoWrapper.classList.add('hidden');
                lbVideo.pause();
                lbVideo.src = '';
                lbImg.src = '';
                lbDownloadBtn.href = '#';

                // Activate Lightbox
                lightbox.classList.add('active');
                document.body.style.overflow = 'hidden';

                // Fetch details via AJAX
                fetch(`${cfg.detailUrl}${mediaId}`)
                    .then(response => response.json())
                    .then(res => {
                        if (res.status === 'ok') {
                            const data = res.data;
                            lbTitle.textContent = data.title;
                            lbDesc.textContent = data.description;
                            lbType.textContent = data.type.toUpperCase();
                            lbDownloadBtn.href = data.download_url;

                            if (data.type === 'video') {
                                lbVideo.src = data.media_url;
                                lbVideoWrapper.classList.remove('hidden');
                                lbVideo.load();
                                const playPromise = lbVideo.play();
                                if (playPromise !== undefined) {
                                    playPromise.catch(error => {
                                        console.log("Autoplay prevented, user interaction required: " + error);
                                    });
                                }
                            } else {
                                lbImg.src = data.media_url;
                                lbImg.classList.remove('hidden');
                            }
                        } else {
                            lbTitle.textContent = 'Gagal memuat konten.';
                        }
                    })
                    .catch(err => {
                        console.error('Error fetching detail:', err);
                        lbTitle.textContent = 'Kesalahan koneksi.';
                    });
            });
        }

        // ═══════════════════════════════════════════
        // LIGHTBOX HIDE LOGIC
        // ═══════════════════════════════════════════
        const closeLightbox = () => {
            lightbox.classList.remove('active');
            document.body.style.overflow = '';
            
            // Clean up resources to stop network/media activity
            lbVideo.pause();
            lbVideo.src = '';
            lbImg.src = '';
        };

        if (lbClose) {
            lbClose.addEventListener('click', closeLightbox);
        }

        if (lightbox) {
            lightbox.addEventListener('click', (e) => {
                // Close if clicked outside the content container
                if (e.target.classList.contains('lightbox-backdrop') || e.target === lightbox) {
                    closeLightbox();
                }
            });
        }

        // Close on escape key
        document.addEventListener('keydown', (e) => {
            if (e.key === 'Escape' && lightbox.classList.contains('active')) {
                closeLightbox();
            }
        });
    });
</script>
