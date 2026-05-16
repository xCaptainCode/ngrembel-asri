<!-- ═══ HERO SLIDESHOW ═══ -->
<section id="hero">
    <div class="slide slide-1 active"></div>
    <div class="slide slide-2"></div>
    <div class="slide slide-3"></div>
    <div class="slide slide-4"></div>

    <div class="hero-content">
        <div class="hero-eyebrow"><span></span>Wisata Termurah Sedunia<span></span></div>
        <h1 class="hero-title">
        Wisata<br />
        <strong>Ngrembel Asri</strong>
        </h1>
        <p class="hero-sub">Pelarian sempurna dari hiruk-pikuk kota —<br />alam hijau dan kenangan tak
        terlupakan.</p>
        <div class="hero-actions">
        {# <a href="#fasilitas" class="btn-gold">✦ Jelajahi Taman</a>
        <a href="#tiket" class="btn-ghost">Harga Tiket</a> #}
        </div>
    </div>

    <div class="slide-dots" id="slideDots"></div>
    <div class="slide-counter"><em id="slideNum">1</em> / 4</div>
    <div class="hero-scroll">Scroll<div class="scroll-line"></div>
    </div>
</section>

<!-- ═══ STATS ═══ -->
<div id="stats">
    <div class="stat r"><span class="stat-num" data-count="4">0</span><span class="stat-label">Hektar Lahan
        Hijau</span></div>
    <div class="stat r" style="transition-delay:.1s"><span class="stat-num" data-count="50">0</span><span
        class="stat-label">Jenis Satwa</span></div>
    <div class="stat r" style="transition-delay:.2s"><span class="stat-num" data-count="25">0</span><span
        class="stat-label">Tahun Berdiri</span></div>
    <div class="stat r" style="transition-delay:.3s"><span class="stat-num" data-count="260">0</span><span
        class="stat-label">Ribu Pengunjung/Tahun</span></div>
</div>

<!-- ═══ SEJARAH ═══ -->
<section id="sejarah">
    <div class="sejarah-bg" id="sejarahBg"></div>
    <div class="sejarah-inner">
        <div class="sejarah-media r-left">
        <div class="sejarah-img-wrap">
            <img src="{{ url("images/fasilitas/curug-sewu.jpg") }}" alt="Ngrembel Asri" />
            <div class="sejarah-frame"></div>
        </div>
        <div class="sejarah-badge">
            <strong>2001</strong>
            <span>Est.</span>
        </div>
        </div>
        <div class="sejarah-text r-right">
        <p class="s-label">Tentang Kami</p>
        <h2 class="s-title">Perjalanan<br /><em>Lebih Dari Dua Dekade</em></h2>
        <div class="divider-gold"></div>
        <p class="s-body">Wisata Ngrembel Asri lahir dari mimpi sederhana — menjaga kelestarian alam lokal
            sekaligus menciptakan ruang bermain yang edukatif. Berdiri di kaki perbukitan yang sejuk, wisata ini
            telah menjadi destinasi favorit keluarga Indonesia.</p>
        <div class="timeline" style="margin-top:2rem;">
            <div class="tl-item">
                <div class="tl-dot"></div>
                <div class="tl-year">2001 — Pendirian</div>
                <div class="tl-desc">H. Zaenal membuka lahan 3 hektar sebagai kebun edukasi keluarga
                    sederhana.</div>
            </div>
            <div class="tl-item">
                <div class="tl-dot"></div>
                <div class="tl-year">2005 — Ekspansi</div>
                <div class="tl-desc">Perluasan taman dan peluncuran mini zoo pertama dengan 12 jenis satwa lokal
                    pilihan.</div>
            </div>
            <div class="tl-item">
                <div class="tl-dot"></div>
                <div class="tl-year">2013 — Kebangkitan</div>
                <div class="tl-desc">Paintball arena, restoran utama, dan mushola permanen hadir. 50.000 pengunjung
                    per tahun.</div>
            </div>
            <div class="tl-item">
                <div class="tl-dot"></div>
                <div class="tl-year">2023 — Transformasi</div>
                <div class="tl-desc">Renovasi total, field trip school program, dan koleksi satwa berkembang menjadi
                    50+ jenis.</div>
            </div>
        </div>
        </div>
    </div>
</section>

<!-- ═══ PARALLAX QUOTE ═══ -->
{# <div class="parallax-divider">
    <div class="pd-bg" id="pdBg1"
        style="background-image:url('https://images.unsplash.com/photo-1448375240586-882707db888b?w=1400&q=70')"></div>
    <div class="pd-overlay"></div>
    <div class="pd-content r">
        <p class="pd-quote">"Di sini, waktu melambat —<br /><em>alam bicara, jiwa beristirahat."</em></p>
        <p class="pd-author">— Wisata Ngrembel Asri</p>
    </div>
</div> #}

<!-- ═══ FASILITAS ═══ -->
{# <section id="fasilitas">
    <p class="s-label r">Apa yang Kami Tawarkan</p>
    <h2 class="s-title r">Fasilitas <em>Premium</em></h2>
    <div class="divider-gold r"></div>
    <p class="s-body r" style="max-width:560px;">Setiap sudut dirancang untuk memberikan pengalaman yang tak
        terlupakan — dari petualangan hingga ketenangan.</p>

    <div class="bento">
        <!-- big card -->
        <div class="bento-card big r" style="transition-delay:0s">
        <img class="bento-img" src="{{ url("images/slideshow/rusa.jpg") }}"
            alt="Mini Zoo" />
        <div class="bento-overlay"></div>
        <div class="bento-body">
            <div class="bento-icon">🦁</div>
            <div class="bento-title">Mini Zoo & Satwa Eksotis</div>
            <div class="bento-desc">40+ jenis satwa lokal dan eksotis. Zona petting zoo interaktif yang aman untuk
                seluruh keluarga, dengan pemandu bersertifikat.</div>
            <span class="bento-tag">Interaktif • Edukatif</span>
        </div>
        </div>

        <div class="bento-card r" style="transition-delay:.1s">
        <img class="bento-img" src="{{ url("images/wahana/paintball.jpg") }}"
            alt="Paintball" />
        <div class="bento-overlay"></div>
        <div class="bento-body">
            <div class="bento-icon">🎯</div>
            <div class="bento-title">Arena Paintball</div>
            <div class="bento-desc">Outdoor 1.500 m², cocok for team building & gathering.</div>
            <span class="bento-tag">Adventure</span>
        </div>
        </div>

        <div class="bento-card r" style="transition-delay:.15s">
        <img class="bento-img" src="{{ url("images/wahana/kolam-renang.jpg") }}"
            alt="Kolam Renang" />
        <div class="bento-overlay"></div>
        <div class="bento-body">
            <div class="bento-icon">🏊</div>
            <div class="bento-title">Kolam & Wahana Air</div>
            <div class="bento-desc">Air alami, 3 kedalaman, water slide & area bermain anak.</div>
            <span class="bento-tag">Family Friendly</span>
        </div>
        </div>

        <div class="bento-card tall r" style="transition-delay:.2s">
        <img class="bento-img" src="{{ url("images/wahana/flying-fox.jpg") }}"
            alt="Outbound" />
        <div class="bento-overlay"></div>
        <div class="bento-body">
            <div class="bento-icon">🧗</div>
            <div class="bento-title">Outbound & Flying Fox</div>
            <div class="bento-desc">Trek outbound, flying fox 200 m, jembatan gantung & wall climbing. Instruktur
                bersertifikat internasional.</div>
            <span class="bento-tag">Adrenaline</span>
        </div>
        </div>

        <div class="bento-card r" style="transition-delay:.25s">
        <img class="bento-img" src="{{ url("images/wahana/aviary.jpg") }}"
            alt="Satwa" />
        <div class="bento-overlay"></div>
        <div class="bento-body">
            <div class="bento-icon">🦜</div>
            <div class="bento-title">Aviary</div>
            <div class="bento-desc">Taman burung tropis terbuka dengan 10+ spesies.</div>
            <span class="bento-tag">Nature</span>
        </div>
        </div>

        <div class="bento-card no-img r"
        style="transition-delay:.3s;background:linear-gradient(135deg,rgba(30,77,48,.8),rgba(21,46,30,.9));border-color:rgba(200,168,75,.2);">
        <div class="bento-icon" style="font-size:1.6rem;width:48px;height:48px;">🕌</div>
        <div class="bento-title" style="font-size:1.1rem;color:var(--gold2);">Mushola & Fasilitas Ibadah</div>
        <div class="bento-desc" style="margin-top:.4rem;">Bersih, nyaman, kapasitas 60 orang. Mukena & sajadah
            tersedia.</div>
        <span class="bento-tag" style="margin-top:.6rem;">Nyaman • Bersih</span>
        </div>

        <div class="bento-card r" style="transition-delay:.35s">
        <img class="bento-img" src="{{ url("images/fasilitas/fieldtrip.jpg") }}"
            alt="Field Trip" />
        <div class="bento-overlay"></div>
        <div class="bento-body">
            <div class="bento-icon">🎒</div>
            <div class="bento-title">Program Field Trip</div>
            <div class="bento-desc">Paket TK–SMA, pemandu edukatif, buku aktivitas.</div>
            <span class="bento-tag">Sekolah & Instansi</span>
        </div>
        </div>

        <div class="bento-card no-img r"
        style="transition-delay:.4s;background:linear-gradient(135deg,rgba(107,58,31,.3),rgba(21,46,30,.9));border-color:rgba(200,168,75,.2);">
        <div class="bento-icon" style="font-size:1.6rem;width:48px;height:48px;">🚗</div>
        <div class="bento-title" style="color:var(--gold2);">Parkir Luas & Aman</div>
        <div class="bento-desc" style="margin-top:.4rem;">Area parkir 500+ kendaraan, CCTV 24 jam, petugas keamanan.
        </div>
        </div>
    </div>
</section> #}

<!-- ═══ PARALLAX 2 ═══ -->
{# <div class="parallax-divider">
    <div class="pd-bg" id="pdBg2"
        style="background-image:url('https://images.unsplash.com/photo-1555244162-803834f70033?w=1400&q=70')"></div>
    <div class="pd-overlay"></div>
    <div class="pd-content r">
        <p class="pd-quote">Restoran kami hadir with cita rasa<br /><em>autentik</em>, bahan segar.</p>
        <p class="pd-author">— Dapur Ngrembel Asri</p>
    </div>
</div> #}

<!-- ═══ MENU ═══ -->
{# <section id="menu">
    <p class="s-label r">Restoran Ngrembel Asri</p>
    <h2 class="s-title r">Menu <em>Favorit</em></h2>
    <div class="divider-gold r"></div>

    <div class="fav-menu-grid">
        <!-- Card 1 -->
        <div class="fav-card r" style="transition-delay: 0s;">
        <div class="fav-img-wrap">
            <img src="{{ url('images/restoran/bakar-klasik.jpg') }}" alt="Bakar Klasik">
        </div>
        <div class="fav-body">
            <div class="fav-head">
                <h3 class="fav-title">Gurami Bakar Klasik</h3>
                <span class="fav-icon">✦</span>
            </div>
            <p class="fav-desc">Bakar kelasik adalah menu ikan legendaris dinNgrembel asri yang paling diminati. Menu ini merupakan varian menu pertama yang dikeluarkan, sehingga menjadikan Ngrembel Asri mendapatkan gelar Ahlinya Ikan Bakar.</p>
            <div class="fav-price">Rp 123.000/Kg</div>
        </div>
        </div>

        <!-- Card 2 -->
        <div class="fav-card r" style="transition-delay: .15s;">
        <div class="fav-img-wrap">
            <img src="{{ url('images/restoran/gulai.jpg') }}" alt="Gurami Gulai">
        </div>
        <div class="fav-body">
            <div class="fav-head">
                <h3 class="fav-title">Gurami Gulai</h3>
                <span class="fav-icon">✦</span>
            </div>
            <p class="fav-desc">Menu ikan dengan rasa yang khas gurih berasal dari rempah-rempah dan santan segar, Menu terbaru dari Ngrembel Asri ini diciptakan oleh tangan ahli khusus untuk anda penikmat masakan ikan berkuah.</p>
            <div class="fav-price">Rp 129.000/Kg</div>
        </div>
        </div>

        <!-- Card 3 -->
        <div class="fav-card r" style="transition-delay: .3s;">
        <div class="fav-img-wrap">
            <img src="{{ url('images/restoran/asam-manis.jpg') }}" alt="Kopi Ngrembel">
        </div>
        <div class="fav-body">
            <div class="fav-head">
                <h3 class="fav-title">Gurami Asam Manis</h3>
                <span class="fav-icon">✦</span>
            </div>
            <p class="fav-desc">Cocok bagi penikmat kuliner yang rasanya kompleks. Ikan goreng dengan dipadukan saus asam manis dan taburan nanas segar, daun bawang dan wortel dnggan bahan-bahan berkualitas menjadikan perpaduan yang istimewa.</p>
            <div class="fav-price">Rp 129.000/Kg</div>
        </div>
        </div>

        <!-- Card 4 -->
        <div class="fav-card r" style="transition-delay: .3s;">
        <div class="fav-img-wrap">
            <img src="{{ url('images/restoran/acar.jpg') }}" alt="Kopi Ngrembel">
        </div>
        <div class="fav-body">
            <div class="fav-head">
                <h3 class="fav-title">Gurami Acar</h3>
                <span class="fav-icon">✦</span>
            </div>
            <p class="fav-desc">Warna kuning alami yang berasal dari kunyit dengan tekstur kental yakni perpaduan antara bumbu kemiri dan racikan bahan lainnya menghadirkan aroma yang khas dari ikan bumbu acar ini..</p>
            <div class="fav-price">Rp 129.000/Kg</div>
        </div>
        </div>
    </div>
</section> #}

<!-- ═══ GALERI SLIDESHOW ═══ -->
{# <section id="galeri">
    <p class="s-label r">Potret Keindahan</p>
    <h2 class="s-title r">Galeri <em style="color: var(--gold2);">Keseruan</em></h2>
    <div class="divider-gold r"></div>

    <div class="galeri-main r">
        <div class="galeri-stage">
        <div class="gslide active" data-caption="Aviary">
            <img src="{{ url('images/wahana/aviary.jpg') }}" alt="Aviary" />
            <div class="gslide-overlay"></div>
            <div class="gslide-caption">Aviary</div>
        </div>
        <div class="gslide" data-caption="Ember Tumpah">
            <img src="{{ url('images/wahana/ember-tumpah.jpg') }}" alt="Ember Tumpah" />
            <div class="gslide-overlay"></div>
            <div class="gslide-caption">Ember Tumpah</div>
        </div>
        <div class="gslide" data-caption="Kolam Renang">
            <img src="{{ url('images/wahana/kolam-tm.jpg') }}" alt="Kolam Renang" />
            <div class="gslide-overlay"></div>
            <div class="gslide-caption">Kolam Renang</div>
        </div>
        <div class="gslide" data-caption="Paintball">
            <img src="{{ url('images/wahana/paintball.jpg') }}" alt="Paintball" />
            <div class="gslide-overlay"></div>
            <div class="gslide-caption">Paintball</div>
        </div>
        <div class="gslide" data-caption="Pasar Kembang">
            <img src="{{ url('images/wahana/pasar-kembang.jpg') }}" alt="Pasar Kembang" />
            <div class="gslide-overlay"></div>
            <div class="gslide-caption">Pasar Kembang</div>
        </div>
        <div class="gslide" data-caption="Omah Playon">
            <img src="{{ url('images/wahana/omah-playon.jpg') }}" alt="Omah Playon" />
            <div class="gslide-overlay"></div>
            <div class="gslide-caption">Omah Playon</div>
        </div>
        <button class="garrow prev" onclick="moveGaleri(-1)">&#8592;</button>
        <button class="garrow next" onclick="moveGaleri(1)">&#8594;</button>
        </div>
        <div class="galeri-thumbs" id="galThumbsWrap"></div>
    </div>
</section> #}

<!-- ═══ TIKET / CTA ═══ -->
<section id="tiket">
    <div class="tiket-bg"></div>
    <div class="tiket-inner">
        <div>
        <p class="s-label r">Rencanakan Kunjungan</p>
        <h2 class="s-title r">Harga Tiket &<br /><em>Jam Buka</em></h2>
        <div class="divider-gold r"></div>
        <p class="s-body r" style="max-width:420px;margin-bottom:2.5rem;">Tiket masuk sudah termasuk akses penuh ke
            semua area taman. Diskon khusus tersedia untuk rombongan, pelajar, dan lansia.</p>
        <a href="https://wa.me/6281200000000?text=Halo,%20saya%20ingin%20info%20Taman%20Asri%20Nusantara"
            class="btn-gold r" target="_blank">
            📱 Hubungi via WhatsApp
        </a>
        </div>
        <div>
        <div class="tiket-cards r">
            <div class="tcard featured">
                <div class="tcard-type">Weekday</div>
                <div class="tcard-price">Rp 5.000<small>/orang</small></div>
            </div>
            <div class="tcard featured">
                <div class="tcard-type">Weekend</div>
                <div class="tcard-price">Rp 9.000<small>/orang</small></div>
            </div>
        </div>
        <div class="hours-box r" style="margin-top:1.5rem;">
            <div class="hours-icon">🕗</div>
            <div>
                <div class="hours-label">Jam Operasional</div>
                <div class="hours-val">08.30 — 17.00 WIB</div>
            </div>
            <div style="margin-left:auto">
                <div class="hours-label">Buka</div>
                <div class="hours-val" style="font-size:1rem;color:var(--mint);">Setiap Hari</div>
            </div>
        </div>
        </div>
    </div>
</section>