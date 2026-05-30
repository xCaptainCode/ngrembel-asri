<style>
    /* ═══════════════════════════════════════════
       GALLERY STYLES & LAYOUT SYSTEM
       ═══════════════════════════════════════════ */
    #gallery-section {
        padding: 2rem 5% 8rem;
        background: var(--forest, #07190e);
        min-height: 100vh;
    }

    /* Responsive Masonry Grid */
    .masonry-grid {
        column-count: 3;
        column-gap: 1.5rem;
        width: 100%;
        margin-top: 1rem;
        transition: all 0.4s ease;
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

    /* Dynamic Filter Tabs */
    .filter-tabs-container {
        display: flex;
        justify-content: center;
        gap: 12px;
        flex-wrap: wrap;
        margin-bottom: 3rem;
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
            column-gap: 1.25rem;
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
    <!-- DYNAMIC FILTER TABS -->
    <div class="filter-tabs-container r" id="filterTabs">
        <button class="filter-tab active" data-filter="all">Semua</button>
        <button class="filter-tab" data-filter="photo">Foto</button>
        <button class="filter-tab" data-filter="video">Video</button>
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

<script>
    document.addEventListener('DOMContentLoaded', () => {
        const grid = document.getElementById('galleryGrid');
        const cards = document.querySelectorAll('.masonry-card');
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
        
        // Apply staggered animation delay to card elements on page load
        cards.forEach((card, idx) => {
            card.style.transition = 'all 0.4s cubic-bezier(0.16, 1, 0.3, 1)';
            card.style.transitionDelay = `${(idx % 12) * 0.04}s`;
        });

        // 1. FILTERING LOGIC
        tabs.forEach(tab => {
            tab.addEventListener('click', () => {
                // Toggle active filter button states
                tabs.forEach(t => t.classList.remove('active'));
                tab.classList.add('active');

                const filterValue = tab.getAttribute('data-filter');

                cards.forEach(card => {
                    const cardType = card.getAttribute('data-media-type');

                    if (filterValue === 'all' || cardType === filterValue) {
                        card.classList.remove('hidden');
                        setTimeout(() => {
                            card.style.opacity = '1';
                            card.style.transform = 'scale(1) translateY(0)';
                        }, 50);
                    } else {
                        card.style.opacity = '0';
                        card.style.transform = 'scale(0.85) translateY(15px)';
                        setTimeout(() => {
                            card.classList.add('hidden');
                        }, 350);
                    }
                });
            });
        });

        // 2. LIGHTBOX SHOW LOGIC
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
                fetch(`{{ url('galeri/detail/') }}${mediaId}`)
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

        // 3. LIGHTBOX HIDE LOGIC
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
