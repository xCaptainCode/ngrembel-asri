<section id="auth-page">
    <div class="auth-wrap r">
        <div class="auth-card">
            <div class="auth-head">
                <h2 class="auth-title">Selamat <em>Datang</em></h2>
                <p class="auth-subtitle">Silakan masuk untuk melanjutkan</p>
            </div>

            <form action="{{ url('login/proses') }}" method="POST">
                <div class="auth-field">
                    <label class="auth-label" for="txtusername">Username</label>
                    <input class="auth-input" id="txtusername" type="text" name="txtusername" required placeholder="Masukkan username">
                </div>

                <div class="auth-field">
                    <label class="auth-label" for="txtpassword">Password</label>
                    <input class="auth-input" id="txtpassword" type="password" name="txtpassword" required placeholder="Masukkan password">
                </div>

                <button type="submit" class="btn-gold auth-submit">Masuk Sekarang</button>
            </form>

            <div class="auth-foot">
                Belum punya akun? <a href="{{ url('registrasi') }}">Daftar</a>
            </div>
        </div>
    </div>
</section>
