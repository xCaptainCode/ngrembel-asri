<section id="auth-page">
    <div class="auth-wrap r">
        <div class="auth-card">
            <div class="auth-head">
                <h2 class="auth-title">Daftar <em>Akun</em></h2>
                <p class="auth-subtitle">Bergabunglah dengan keluarga Ngrembel Asri</p>
            </div>

            <form action="{{ url('registrasi/proses') }}" method="POST">
                <div class="auth-field">
                    <label class="auth-label" for="name">Nama Lengkap</label>
                    <input class="auth-input" id="name" type="text" name="name" required placeholder="Masukkan nama lengkap">
                </div>

                <div class="auth-field">
                    <label class="auth-label" for="username">Username</label>
                    <input class="auth-input" id="username" type="text" name="username" required placeholder="Masukkan username">
                </div>

                <div class="auth-field">
                    <label class="auth-label" for="password">Password</label>
                    <input class="auth-input" id="password" type="password" name="password" required placeholder="Masukkan password">
                </div>

                <button type="submit" class="btn-gold auth-submit">Daftar Sekarang</button>
            </form>

            <div class="auth-foot">
                Sudah punya akun? <a href="{{ url('login') }}">Masuk</a>
            </div>
        </div>
    </div>
</section>
