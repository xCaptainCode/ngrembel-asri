{% set d = dashboard is defined ? dashboard : [] %}

{% if d['slide_img_1'] is defined and d['slide_img_1'] is not null and d['slide_img_1'] != '' %}
<style>
    .slide-1 {
        background-image: url("{{ url(d['slide_img_1']) }}") !important;
    }
</style>
{% endif %}
{% if d['slide_img_2'] is defined and d['slide_img_2'] is not null and d['slide_img_2'] != '' %}
<style>
    .slide-2 {
        background-image: url("{{ url(d['slide_img_2']) }}") !important;
    }
</style>
{% endif %}
{% if d['slide_img_3'] is defined and d['slide_img_3'] is not null and d['slide_img_3'] != '' %}
<style>
    .slide-3 {
        background-image: url("{{ url(d['slide_img_3']) }}") !important;
    }
</style>
{% endif %}
{% if d['slide_img_4'] is defined and d['slide_img_4'] is not null and d['slide_img_4'] != '' %}
<style>
    .slide-4 {
        background-image: url("{{ url(d['slide_img_4']) }}") !important;
    }
</style>
{% endif %}
{% if d['slide_img_5'] is defined and d['slide_img_5'] is not null and d['slide_img_5'] != '' %}
<style>
    .slide-5 {
        background-image: url("{{ url(d['slide_img_5']) }}") !important;
    }
</style>
{% endif %}

<section id="hero">
    <div class="slide slide-1 active"></div>
    <div class="slide slide-2"></div>
    <div class="slide slide-3"></div>
    <div class="slide slide-4"></div>
    {% if d['slide_img_5'] is defined and d['slide_img_5'] is not null and d['slide_img_5'] != '' %}
    <div class="slide slide-5"></div>
    {% endif %}

    <div class="hero-content">
        {% if d['tagline'] is defined and d['tagline'] is not null and d['tagline'] != '' %}
        <div class="hero-eyebrow"><span></span>{{ d['tagline'] }}<span></span></div>
        {% endif %}

        <h1 class="hero-title">
        Wisata<br />
        <strong>Ngrembel Asri</strong>
        </h1>

        {% if d['quote_1'] is defined and d['quote_1'] is not null and d['quote_1'] != '' %}
        <p class="hero-sub">{{ d['quote_1'] }}</p>
        {% endif %}

        <div class="hero-actions"></div>
    </div>

    <div class="slide-dots" id="slideDots"></div>
    <div class="slide-counter"><em id="slideNum">1</em> / 5</div>
    <div class="hero-scroll">Scroll<div class="scroll-line"></div></div>
</section>

<div id="stats">
    {% if d['stat_1_label'] is defined and d['stat_1_label'] is not null and d['stat_1_label'] != '' and d['stat_1_value'] is defined and d['stat_1_value'] is not null and d['stat_1_value'] != '' %}
    <div class="stat r"><span class="stat-num" data-count="{{ d['stat_1_value'] }}">0</span><span class="stat-label">{{ d['stat_1_label'] }}</span></div>
    {% endif %}

    {% if d['stat_2_label'] is defined and d['stat_2_label'] is not null and d['stat_2_label'] != '' and d['stat_2_value'] is defined and d['stat_2_value'] is not null and d['stat_2_value'] != '' %}
    <div class="stat r" style="transition-delay:.1s"><span class="stat-num" data-count="{{ d['stat_2_value'] }}">0</span><span class="stat-label">{{ d['stat_2_label'] }}</span></div>
    {% endif %}

    {% if d['stat_3_label'] is defined and d['stat_3_label'] is not null and d['stat_3_label'] != '' and d['stat_3_value'] is defined and d['stat_3_value'] is not null and d['stat_3_value'] != '' %}
    <div class="stat r" style="transition-delay:.2s"><span class="stat-num" data-count="{{ d['stat_3_value'] }}">0</span><span class="stat-label">{{ d['stat_3_label'] }}</span></div>
    {% endif %}

    {% if d['stat_4_label'] is defined and d['stat_4_label'] is not null and d['stat_4_label'] != '' and d['stat_4_value'] is defined and d['stat_4_value'] is not null and d['stat_4_value'] != '' %}
    <div class="stat r" style="transition-delay:.3s"><span class="stat-num" data-count="{{ d['stat_4_value'] }}">0</span><span class="stat-label">{{ d['stat_4_label'] }}</span></div>
    {% endif %}
</div>

<section id="sejarah">
    <div class="sejarah-bg" id="sejarahBg"></div>
    <div class="sejarah-inner">
        <div class="sejarah-media r-left">
            {% if d['sejarah_img_url'] is defined and d['sejarah_img_url'] is not null and d['sejarah_img_url'] != '' %}
            <div class="sejarah-img-wrap">
                <img src="{{ url(d['sejarah_img_url']) }}" alt="Ngrembel Asri" />
                <div class="sejarah-frame"></div>
            </div>
            {% endif %}

            {% if d['sejarah_tahun_berdiri'] is defined and d['sejarah_tahun_berdiri'] is not null and d['sejarah_tahun_berdiri'] != '' %}
            <div class="sejarah-badge">
                <strong>{{ d['sejarah_tahun_berdiri'] }}</strong>
                <span>Est.</span>
            </div>
            {% endif %}
        </div>

        <div class="sejarah-text r-right">
            <p class="s-label">Tentang Kami</p>

            {% if d['sejarah_title'] is defined and d['sejarah_title'] is not null and d['sejarah_title'] != '' %}
            <h2 class="s-title">{{ d['sejarah_title'] }}</h2>
            {% endif %}

            <div class="divider-gold"></div>

            {% if d['sejarah_paragraf_1'] is defined and d['sejarah_paragraf_1'] is not null and d['sejarah_paragraf_1'] != '' %}
            <p class="s-body">{{ d['sejarah_paragraf_1'] }}</p>
            {% endif %}
            {% if d['sejarah_paragraf_2'] is defined and d['sejarah_paragraf_2'] is not null and d['sejarah_paragraf_2'] != '' %}
            <p class="s-body">{{ d['sejarah_paragraf_2'] }}</p>
            {% endif %}

            <div class="timeline" style="margin-top:2rem;">
                {% if d['sejarah_year_1_lable'] is defined and d['sejarah_year_1_lable'] is not null and d['sejarah_year_1_lable'] != '' and d['sejarah_year_1_value'] is defined and d['sejarah_year_1_value'] is not null and d['sejarah_year_1_value'] != '' %}
                <div class="tl-item">
                    <div class="tl-dot"></div>
                    <div class="tl-year">{{ d['sejarah_year_1_lable'] }}</div>
                    {% if d['sejarah_year_1_value'] is defined and d['sejarah_year_1_value'] is not null and d['sejarah_year_1_value'] != '' %}<div class="tl-desc">{{ d['sejarah_year_1_value'] }} - </div>{% endif %}
                </div>
                {% endif %}
                {% if d['sejarah_year_2_lable'] is defined and d['sejarah_year_2_lable'] is not null and d['sejarah_year_2_lable'] != '' and d['sejarah_year_2_value'] is defined and d['sejarah_year_2_value'] is not null and d['sejarah_year_2_value'] != '' %}
                <div class="tl-item">
                    <div class="tl-dot"></div>
                    <div class="tl-year">{{ d['sejarah_year_2_lable'] }}</div>
                    {% if d['sejarah_year_2_value'] is defined and d['sejarah_year_2_value'] is not null and d['sejarah_year_2_value'] != '' %}<div class="tl-desc">{{ d['sejarah_year_2_value'] }} - </div>{% endif %}
                </div>
                {% endif %}
                {% if d['sejarah_year_3_lable'] is defined and d['sejarah_year_3_lable'] is not null and d['sejarah_year_3_lable'] != '' and d['sejarah_year_3_value'] is defined and d['sejarah_year_3_value'] is not null and d['sejarah_year_3_value'] != '' %}
                <div class="tl-item">
                    <div class="tl-dot"></div>
                    <div class="tl-year">{{ d['sejarah_year_3_lable'] }}</div>
                    {% if d['sejarah_year_3_value'] is defined and d['sejarah_year_3_value'] is not null and d['sejarah_year_3_value'] != '' %}<div class="tl-desc">{{ d['sejarah_year_3_value'] }} - </div>{% endif %}
                </div>
                {% endif %}
                {% if d['sejarah_year_4_lable'] is defined and d['sejarah_year_4_lable'] is not null and d['sejarah_year_4_lable'] != '' and d['sejarah_year_4_value'] is defined and d['sejarah_year_4_value'] is not null and d['sejarah_year_4_value'] != '' %}
                <div class="tl-item">
                    <div class="tl-dot"></div>
                    <div class="tl-year">{{ d['sejarah_year_4_lable'] }}</div>
                    {% if d['sejarah_year_4_value'] is defined and d['sejarah_year_4_value'] is not null and d['sejarah_year_4_value'] != '' %}<div class="tl-desc">{{ d['sejarah_year_4_value'] }} - </div>{% endif %}
                </div>
                {% endif %}
                {% if d['sejarah_year_5_lable'] is defined and d['sejarah_year_5_lable'] is not null and d['sejarah_year_5_lable'] != '' %}
                <div class="tl-item">
                    <div class="tl-dot"></div>
                    <div class="tl-year">{{ d['sejarah_year_5_lable'] }}</div>
                    {% if d['sejarah_year_5_value'] is defined and d['sejarah_year_5_value'] is not null and d['sejarah_year_5_value'] != '' %}<div class="tl-desc">{{ d['sejarah_year_5_value'] }} - </div>{% endif %}
                </div>
                {% endif %}
            </div>
        </div>
    </div>
</section>

<section id="tiket">
    <div class="tiket-bg"></div>
    <div class="tiket-inner">
        <div>
            <p class="s-label r">Rencanakan Kunjungan</p>
            <h2 class="s-title r">Harga Tiket &<br /><em>Jam Buka</em></h2>
            <div class="divider-gold r"></div>

            {% if d['tiket_deskripsi'] is defined and d['tiket_deskripsi'] is not null and d['tiket_deskripsi'] != '' %}
            <p class="s-body r" style="max-width:420px;margin-bottom:2.5rem;">{{ d['tiket_deskripsi'] }}</p>
            {% endif %}

            {% if d['link_whatsapp'] is defined and d['link_whatsapp'] is not null and d['link_whatsapp'] != '' %}
            <a href="{{ d['link_whatsapp'] }}" class="btn-gold r" target="_blank">Hubungi via WhatsApp</a>
            {% endif %}
        </div>

        <div>
            <div class="tiket-cards r">
                {% if d['tiket_weekday'] is defined and d['tiket_weekday'] is not null and d['tiket_weekday'] != '' %}
                <div class="tcard featured">
                    <div class="tcard-type">Weekday</div>
                    <div class="tcard-price">Rp {{ d['tiket_weekday'] }}<small>/orang</small></div>
                </div>
                {% endif %}

                {% if d['tiket_weekend'] is defined and d['tiket_weekend'] is not null and d['tiket_weekend'] != '' %}
                <div class="tcard featured">
                    <div class="tcard-type">Weekend</div>
                    <div class="tcard-price">Rp {{ d['tiket_weekend'] }}<small>/orang</small></div>
                </div>
                {% endif %}
            </div>

            {% if d['jam_operasional'] is defined and d['jam_operasional'] is not null and d['jam_operasional'] != '' %}
            <div class="hours-box r" style="margin-top:1.5rem;">
                <div class="hours-icon">🕗</div>
                <div>
                    <div class="hours-label">Jam Operasional</div>
                    <div class="hours-val">{{ d['jam_operasional'] }} WIB</div>
                </div>
                <div style="margin-left:auto">
                    <div class="hours-label">Buka</div>
                    <div class="hours-val" style="font-size:1rem;color:var(--mint);">Setiap Hari</div>
                </div>
            </div>
            {% endif %}
        </div>
    </div>
</section>
