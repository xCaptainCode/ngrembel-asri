<!DOCTYPE html>
<html lang="id">
<head>
   <meta charset="UTF-8">
   <meta name="viewport" content="width=device-width, initial-scale=1.0">
   <title>Masuk - Ngrembel Asri</title>
   
   <!-- Meta SEO -->
   <meta name="description" content="Silakan masuk untuk melanjutkan ke dashboard member Ngrembel Asri.">
   <meta name="robots" content="noindex, nofollow">
   
   <!-- Google Fonts -->
   <link rel="preconnect" href="https://fonts.googleapis.com">
   <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
   <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,300;0,400;0,600;0,700;1,300;1,400;1,600&family=Jost:wght@200;300;400;500;600&display=swap" rel="stylesheet">

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
         color-scheme: dark;
      }

      *,
      *::before,
      *::after {
         box-sizing: border-box;
         margin: 0;
         padding: 0;
      }

      html {
         scroll-behavior: smooth;
         font-size: 16px;
      }

      body {
         font-family: 'Jost', sans-serif;
         background: var(--forest);
         color: var(--cream);
         overflow-x: hidden;
         cursor: default;
         min-height: 100vh;
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
         -webkit-backdrop-filter: blur(12px);
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

      .auth-password-wrap {
         position: relative;
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
         font-family: 'Jost', sans-serif;
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

      .auth-password-toggle {
         position: absolute;
         top: 50%;
         right: 12px;
         transform: translateY(-50%);
         width: 34px;
         height: 34px;
         display: inline-flex;
         align-items: center;
         justify-content: center;
         border: none;
         border-radius: 10px;
         background: rgba(255, 255, 255, .08);
         color: rgba(255, 255, 255, .85);
         cursor: pointer;
         transition: background .2s ease;
      }

      .auth-password-toggle:hover {
         background: rgba(255, 255, 255, .14);
      }

      .auth-password-toggle svg {
         width: 18px;
         height: 18px;
         stroke: currentColor;
         fill: none;
         stroke-width: 2;
         stroke-linecap: round;
         stroke-linejoin: round;
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

      .auth-wrap .nav-logo img {
         width: min(350px, 78vw);
         height: auto;
      }

      @media (max-width: 991px) {
         #auth-page {
            padding: 105px 24px 40px;
         }

         .auth-wrap {
            max-width: 520px;
         }

         .auth-card {
            padding: 2rem 1.6rem;
         }
      }

      @media (max-width: 767px) {
         #auth-page {
            align-items: flex-start;
            padding: 96px 16px 24px;
            width: 100%;
         }

         .auth-title {
            font-size: 2.2rem;
         }

         .auth-label {
            font-size: .78rem;
            letter-spacing: 2px;
         }

         .auth-subtitle {
            font-size: 1rem;
         }

         .auth-input {
            font-size: 1rem;
            padding: 1rem 1rem;
         }

         .btn-gold {
            width: 100%;
            padding: 1rem 1rem;
            font-size: .92rem;
         }
      }

      @media (max-width: 576px) {
         .auth-card {
            width: 100%;
            border-radius: 20px;
            padding: 2rem 1.3rem;
         }

         .auth-foot {
            font-size: .95rem;
         }
      }
   </style>
</head>
<body>

   <section id="auth-page">
      <div class="auth-wrap">
         <div class="justify-center mb-3">
            <a href="{{ url('') }}" class="nav-logo text-center">
               <img src="{{ url('images/logo-white.png') }}" alt="Logo Ngrembel Asri" width="350px">
            </a>
         </div>
         <div class="auth-card">
            <div class="auth-head">
               <h1 class="auth-title">Selamat <em>Datang</em></h1>
               <p class="auth-subtitle">Silakan masuk untuk melanjutkan</p>
            </div>

            <form action="{{ url('login/proses') }}" method="POST">
               <div class="auth-field">
                  <label class="auth-label" for="txtemail">Email</label>
                  <input class="auth-input" id="txtemail" type="email" name="txtemail" required
                     placeholder="Masukkan email">
               </div>

               <div class="auth-field">
                  <label class="auth-label" for="txtpassword">Password</label>
                  <div class="auth-password-wrap">
                     <input class="auth-input" id="txtpassword" type="password" name="txtpassword" required
                        placeholder="Masukkan password">
                     <button type="button" class="auth-password-toggle" id="togglePassword" aria-label="Tampilkan password">
                        <svg id="eyeOpen" viewBox="0 0 24 24" aria-hidden="true">
                           <path d="M1 12s4-7 11-7 11 7 11 7-4 7-11 7S1 12 1 12z"></path>
                           <circle cx="12" cy="12" r="3"></circle>
                        </svg>
                        <svg id="eyeClosed" viewBox="0 0 24 24" aria-hidden="true" style="display:none;">
                           <path d="M17.94 17.94A10.94 10.94 0 0 1 12 19c-7 0-11-7-11-7a21.77 21.77 0 0 1 5.06-5.94"></path>
                           <path d="M9.9 4.24A10.94 10.94 0 0 1 12 5c7 0 11 7 11 7a21.8 21.8 0 0 1-3.22 4.22"></path>
                           <path d="M1 1l22 22"></path>
                        </svg>
                     </button>
                  </div>
               </div>

               <button type="submit" class="btn-gold auth-submit">Masuk Sekarang</button>
            </form>

            <div class="auth-foot">
               Belum punya akun? <a href="{{ url('registrasi') }}">Daftar</a><br><br>
               Lupa password? <a href="{{ url('lupa-password') }}">Reset</a>
            </div>
         </div>
      </div>
   </section>

   <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
   <script>
      (function () {
         const passwordInput = document.getElementById('txtpassword');
         const toggleButton = document.getElementById('togglePassword');
         const eyeOpen = document.getElementById('eyeOpen');
         const eyeClosed = document.getElementById('eyeClosed');

         if (!passwordInput || !toggleButton) return;

         toggleButton.addEventListener('click', function () {
            const isPassword = passwordInput.getAttribute('type') === 'password';
            passwordInput.setAttribute('type', isPassword ? 'text' : 'password');
            eyeOpen.style.display = isPassword ? 'none' : 'block';
            eyeClosed.style.display = isPassword ? 'block' : 'none';
            toggleButton.setAttribute('aria-label', isPassword ? 'Sembunyikan password' : 'Tampilkan password');
         });
      })();
   </script>
   {% if session.has('login_error') %}
   <script>
      Swal.fire({
         icon: 'error',
         title: 'Login Gagal',
         text: '{{ session.get("login_error") }}',
         confirmButtonColor: '#c8a84b'
      });
   </script>
   {% do session.remove('login_error') %}
   {% endif %}

   {% if session.has('registrasi_success') %}
   <script>
      Swal.fire({
         icon: 'success',
         title: 'Pendaftaran Sukses',
         text: '{{ session.get("registrasi_success") }}',
         confirmButtonColor: '#c8a84b'
      });
   </script>
   {% do session.remove('registrasi_success') %}
   {% endif %}

   {% if session.has('reset_success') %}
   <script>
      Swal.fire({
         icon: 'success',
         title: 'Reset Password Sukses',
         text: '{{ session.get("reset_success") }}',
         confirmButtonColor: '#c8a84b'
      });
   </script>
   {% do session.remove('reset_success') %}
   {% endif %}

</body>
</html>
