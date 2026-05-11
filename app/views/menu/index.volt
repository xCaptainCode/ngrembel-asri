<section id="page-header" style="padding-top: 120px; text-align: center;">
    <p class="s-label r">Ahlinya Ikan Bakar</p>
    <h1 class="s-title r">Menu <em>Pricelist</em> Restoran</h1>
    <div class="divider-gold r" style="margin: 1.4rem auto;"></div>
</section>

<section id="menu-pricelist" style="padding: 2rem 5% 8rem;">
    <div class="fav-menu-grid">
        <!-- Pricelist Images -->
        <div class="fav-card r" style="transition-delay: 0s;">
            <div class="fav-img-wrap zoom-trigger" data-src="{{ url('images/pricelist/ikan.png') }}">
                <img src="{{ url('images/pricelist/ikan.png') }}" alt="Menu Ikan">
                <div class="zoom-hint">Klik untuk Zoom</div>
            </div>
        </div>
        <div class="fav-card r" style="transition-delay: .1s;">
            <div class="fav-img-wrap zoom-trigger" data-src="{{ url('images/pricelist/makanan.png') }}">
                <img src="{{ url('images/pricelist/makanan.png') }}" alt="Menu Makanan">
                <div class="zoom-hint">Klik untuk Zoom</div>
            </div>
        </div>
        <div class="fav-card r" style="transition-delay: .2s;">
            <div class="fav-img-wrap zoom-trigger" data-src="{{ url('images/pricelist/minuman.png') }}">
                <img src="{{ url('images/pricelist/minuman.png') }}" alt="Menu Minuman">
                <div class="zoom-hint">Klik untuk Zoom</div>
            </div>
        </div>
        <div class="fav-card r" style="transition-delay: .3s;">
            <div class="fav-img-wrap zoom-trigger" data-src="{{ url('images/pricelist/makan-10.png') }}">
                <img src="{{ url('images/pricelist/makan-10.png') }}" alt="Menu Makan 10">
                <div class="zoom-hint">Klik untuk Zoom</div>
            </div>
        </div>
        <div class="fav-card r" style="transition-delay: .4s;">
            <div class="fav-img-wrap zoom-trigger" data-src="{{ url('images/pricelist/makan-pb.png') }}">
                <img src="{{ url('images/pricelist/makan-pb.png') }}" alt="Menu Makan PB">
                <div class="zoom-hint">Klik untuk Zoom</div>
            </div>
        </div>
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
    const lb = document.getElementById('menuLightbox');
    const lbImg = document.getElementById('lightboxImg');
    const lbClose = document.getElementById('closeLightbox');
    const triggers = document.querySelectorAll('.zoom-trigger');

    triggers.forEach(t => {
        t.addEventListener('click', () => {
            const src = t.getAttribute('data-src');
            lbImg.src = src;
            lb.classList.add('active');
            document.body.style.overflow = 'hidden';
        });
    });

    const closeLB = () => {
        lb.classList.remove('active');
        document.body.style.overflow = '';
        lbImg.src = '';
    };

    lbClose.addEventListener('click', closeLB);
    lb.addEventListener('click', (e) => {
        if (e.target === lb) closeLB();
    });

    document.addEventListener('keydown', (e) => {
        if (e.key === 'Escape' && lb.classList.contains('active')) {
            closeLB();
        }
    });
});
</script>
