<style>
   :root {
      --forest: #0d2416;
      --deep: #152e1e;
      --mid: #1e4d30;
      --sage: #3a7d54;
      --leaf: #5caa78;
      --mint: #9fd4b3;
      --cream: #f5efe4;
      --parchment: #ede6d4;
      --gold: #c8a84b;
      --gold2: #e8cc7a;
      --brown: #6b3a1f;
      --white: #ffffff;
      --ease-out: cubic-bezier(0.22, 1, 0.36, 1);
   }

   *,
   *::before,
   *::after {
      box-sizing: border-box;
      margin: 0;
      padding: 0
   }

   html {
      scroll-behavior: smooth;
      font-size: 16px
   }

   body {
      font-family: 'Jost', sans-serif;
      background: var(--forest);
      color: var(--cream);
      overflow-x: hidden;
      cursor: basic;
   }

   .overflow-hidden {
      overflow: hidden !important;
   }

   /* ── NOISE OVERLAY ── */
   body::before {
      content: '';
      position: fixed;
      inset: 0;
      z-index: 1;
      pointer-events: none;
      background-image: url("data:image/svg+xml,%3Csvg viewBox='0 0 256 256' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='n'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='.9' numOctaves='4' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23n)' opacity='.04'/%3E%");
      background-size: 128px;
      opacity: .025;
   }

   #auth-page {
      padding: 120px 5% 4rem;
      min-height: 100vh;
      display: flex;
      align-items: center;
      justify-content: center;
      background:
         radial-gradient(circle at 15% 15%, rgba(200, 168, 75, .13), transparent 42%),
         radial-gradient(circle at 85% 85%, rgba(94, 183, 120, .12), transparent 44%),
         linear-gradient(165deg, var(--deep) 0%, var(--forest) 70%);
      position: relative;
      overflow: hidden;
   }

   #auth-page::before {
      content: '';
      position: absolute;
      inset: 0;
      pointer-events: none;
      background: linear-gradient(to bottom, rgba(13, 36, 22, .18), rgba(13, 36, 22, .6));
   }

   .auth-wrap {
      width: 100%;
      max-width: 460px;
      position: relative;
      z-index: 2;
   }

   .auth-card {
      background: rgba(255, 255, 255, .04);
      border: 1px solid rgba(200, 168, 75, .2);
      border-radius: 24px;
      padding: 2.2rem 2rem;
      backdrop-filter: blur(12px);
      box-shadow: 0 24px 64px rgba(0, 0, 0, .35);
   }

   .auth-head {
      text-align: center;
      margin-bottom: 1.8rem;
   }

   .auth-title {
      font-family: 'Cormorant Garamond', serif;
      font-size: clamp(2rem, 5vw, 2.5rem);
      line-height: 1.1;
      margin-bottom: .5rem;
   }

   .auth-title em {
      color: var(--gold2);
      font-style: italic;
   }

   .auth-subtitle {
      color: rgba(255, 255, 255, .68);
      font-size: .92rem;
   }

   .auth-field {
      margin-bottom: 1.05rem;
   }

   .auth-label {
      display: block;
      margin-bottom: .45rem;
      font-size: .62rem;
      letter-spacing: 2.5px;
      text-transform: uppercase;
      color: rgba(255, 255, 255, .62);
   }

   .auth-input {
      width: 100%;
      border: 1px solid rgba(255, 255, 255, .14);
      background: rgba(255, 255, 255, .06);
      border-radius: 12px;
      padding: .84rem 1rem;
      color: #fff;
      outline: none;
      transition: border-color .25s, box-shadow .25s, background .25s;
   }

   .auth-input:focus {
      border-color: rgba(232, 204, 122, .95);
      box-shadow: 0 0 0 3px rgba(200, 168, 75, .16);
      background: rgba(255, 255, 255, .08);
   }

   .auth-input::placeholder {
      color: rgba(255, 255, 255, .38);
   }

   .auth-submit {
      margin-top: .55rem;
      width: 100%;
      border: none;
      cursor: pointer;
      justify-content: center;
   }

   .auth-foot {
      text-align: center;
      margin-top: 1.25rem;
      color: rgba(255, 255, 255, .7);
      font-size: .87rem;
   }

   .auth-foot a {
      color: var(--gold2);
      text-decoration: none;
      font-weight: 600;
   }

   .auth-foot a:hover {
      text-decoration: underline;
      text-underline-offset: 3px;
   }

   .btn-gold {
      display: inline-flex;
      align-items: center;
      gap: .5rem;
      background: linear-gradient(135deg, var(--gold), var(--gold2));
      color: var(--forest);
      padding: .9rem 2.4rem;
      border-radius: 40px;
      font-weight: 600;
      font-size: .85rem;
      letter-spacing: 1.5px;
      text-transform: uppercase;
      text-decoration: none;
      box-shadow: 0 8px 32px rgba(200, 168, 75, .4);
      transition: transform .25s, box-shadow .25s;
   }

   .btn-gold:hover {
      transform: translateY(-3px);
      box-shadow: 0 14px 40px rgba(200, 168, 75, .55);
   }

   @media (max-width: 520px) {
      #auth-page {
         padding-top: 105px;
      }

      .auth-card {
         border-radius: 20px;
         padding: 1.7rem 1.2rem;
      }
   }

   
   .mb-3 {
      margin-bottom: 2rem !important;
   }

   .text-center {
      text-align: center;
   }

   .justify-center {
      display: flex;
      justify-content: center;
   }
</style>

<section id="auth-page">
    <div class="auth-wrap r">
         <div class="justify-center mb-3">
         <a href="{{ url('') }}" class="nav-logo text-center">
            <img src="{{ url('images/logo-white.png') }}" alt="Logo Ngrembel Asri" width="350px">
         </a>
      </div>
        <div class="auth-card">
            <div class="auth-head">
                <h2 class="auth-title">Daftar <em>Member</em></h2>
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
