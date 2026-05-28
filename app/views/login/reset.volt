<!DOCTYPE html>
<html lang="id">
<head>
   <meta charset="UTF-8">
   <meta name="viewport" content="width=device-width, initial-scale=1.0">
   <title>Reset Password - Ngrembel Asri</title>
   
   <!-- Meta SEO -->
   <meta name="description" content="Halaman untuk merestart password akun member Ngrembel Asri Anda.">
   <meta name="robots" content="noindex, nofollow">
   
   <!-- Google Fonts -->
   <link rel="preconnect" href="https://fonts.googleapis.com">
   <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
   <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,300;0,400;0,600;0,700;1,300;1,400;1,600&family=Jost:wght@200;300;400;500;600&display=swap" rel="stylesheet">

   <style>
      :root {
         --forest: #0d2416;
         --deep: #152e1e;
         --gold: #c8a84b;
         --gold2: #e8cc7a;
         --cream: #f5efe4;
         --white: #ffffff;
         color-scheme: dark;
      }

      * {
         box-sizing: border-box;
         margin: 0;
         padding: 0;
      }

      body {
         font-family: 'Jost', sans-serif;
         color: var(--cream);
         background:
            radial-gradient(circle at 15% 15%, rgba(200, 168, 75, .16), transparent 42%),
            radial-gradient(circle at 85% 85%, rgba(94, 183, 120, .12), transparent 44%),
            linear-gradient(165deg, var(--deep) 0%, var(--forest) 70%);
         min-height: 100vh;
         display: flex;
         align-items: center;
         justify-content: center;
      }

      .reset-wrap {
         width: 100%;
         max-width: 520px;
         padding: 24px;
         z-index: 2;
      }

      .reset-card {
         width: 100%;
         text-align: center;
         background: rgba(255, 255, 255, .06);
         border: 1px solid rgba(200, 168, 75, .28);
         border-radius: 24px;
         padding: 34px 28px;
         box-shadow: 0 24px 60px rgba(0, 0, 0, .32);
         backdrop-filter: blur(10px);
         -webkit-backdrop-filter: blur(10px);
      }

      .reset-title {
         font-family: 'Cormorant Garamond', serif;
         font-size: clamp(2rem, 5vw, 2.5rem);
         font-weight: 700;
         margin-bottom: 10px;
         color: var(--white);
      }

      .reset-subtitle {
         margin-bottom: 24px;
         color: rgba(255, 255, 255, .82);
         line-height: 1.6;
         font-size: 1rem;
      }

      .auth-field {
         margin-bottom: 1.25rem;
         text-align: left;
      }

      .auth-label {
         display: block;
         margin-bottom: .45rem;
         font-size: .62rem;
         letter-spacing: 2.5px;
         text-transform: uppercase;
         color: rgba(255, 255, 255, .62);
      }

      .auth-password-wrap {
         position: relative;
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
         font-size: 1rem;
         padding-right: 50px;
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

      .reset-actions {
         display: flex;
         gap: 12px;
         justify-content: center;
         flex-wrap: wrap;
         margin-top: 1.8rem;
      }

      .btn-reset {
         border: none;
         border-radius: 999px;
         padding: 11px 22px;
         font-weight: 600;
         text-decoration: none;
         font-size: .85rem;
         letter-spacing: 1.5px;
         text-transform: uppercase;
         transition: transform .2s ease, box-shadow .2s ease;
         display: inline-flex;
         align-items: center;
         justify-content: center;
         gap: .5rem;
         cursor: pointer;
      }

      .btn-reset.primary {
         background: linear-gradient(135deg, var(--gold), var(--gold2));
         color: var(--forest);
         box-shadow: 0 8px 24px rgba(200, 168, 75, .38);
      }

      .btn-reset.secondary {
         background: rgba(255, 255, 255, .14);
         color: var(--white);
         border: 1px solid rgba(255, 255, 255, .28);
      }

      .btn-reset:hover {
         transform: translateY(-2px);
      }

      @media (max-width: 991px) {
         .reset-card {
            max-width: 100%;
         }
      }

      @media (max-width: 767px) {
         .reset-wrap {
            padding: 90px 16px 24px;
         }

         .reset-actions {
            flex-direction: column;
         }

         .btn-reset {
            width: 100%;
            padding: 13px 20px;
            font-size: .9rem;
         }
      }
   </style>
</head>
<body>

   <section class="reset-wrap">
      <div class="reset-card">
         <h1 class="reset-title">Reset Password</h1>
         <p class="reset-subtitle">
            Buat password baru yang aman untuk akun Anda.
         </p>

         <form action="{{ url('reset-password') }}" method="POST">
            <input type="hidden" name="token" value="{{ token }}">

            <div class="auth-field">
               <label class="auth-label" for="password">Password Baru</label>
               <div class="auth-password-wrap">
                  <input class="auth-input" id="password" type="password" name="password" required
                     placeholder="Minimal 8 karakter">
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

            <div class="auth-field">
               <label class="auth-label" for="confirm_password">Konfirmasi Password Baru</label>
               <div class="auth-password-wrap">
                  <input class="auth-input" id="confirm_password" type="password" name="confirm_password" required
                     placeholder="Ulangi password baru">
                  <button type="button" class="auth-password-toggle" id="toggleConfirmPassword" aria-label="Tampilkan password">
                     <svg id="eyeOpenConfirm" viewBox="0 0 24 24" aria-hidden="true">
                        <path d="M1 12s4-7 11-7 11 7 11 7-4 7-11 7S1 12 1 12z"></path>
                        <circle cx="12" cy="12" r="3"></circle>
                     </svg>
                     <svg id="eyeClosedConfirm" viewBox="0 0 24 24" aria-hidden="true" style="display:none;">
                        <path d="M17.94 17.94A10.94 10.94 0 0 1 12 19c-7 0-11-7-11-7a21.77 21.77 0 0 1 5.06-5.94"></path>
                        <path d="M9.9 4.24A10.94 10.94 0 0 1 12 5c7 0 11 7 11 7a21.8 21.8 0 0 1-3.22 4.22"></path>
                        <path d="M1 1l22 22"></path>
                     </svg>
                  </button>
               </div>
            </div>

            <div class="reset-actions">
               <button type="submit" class="btn-reset primary">Perbarui Password</button>
               <a class="btn-reset secondary" href="{{ url('login') }}">Batal</a>
            </div>
         </form>
      </div>
   </section>

   <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
   <script>
      (function () {
         function setupToggle(inputEl, toggleBtn, eyeOpen, eyeClosed) {
            if (!inputEl || !toggleBtn) return;
            toggleBtn.addEventListener('click', function () {
               const isPassword = inputEl.getAttribute('type') === 'password';
               inputEl.setAttribute('type', isPassword ? 'text' : 'password');
               eyeOpen.style.display = isPassword ? 'none' : 'block';
               eyeClosed.style.display = isPassword ? 'block' : 'none';
               toggleBtn.setAttribute('aria-label', isPassword ? 'Sembunyikan password' : 'Tampilkan password');
            });
         }

         setupToggle(
            document.getElementById('password'),
            document.getElementById('togglePassword'),
            document.getElementById('eyeOpen'),
            document.getElementById('eyeClosed')
         );

         setupToggle(
            document.getElementById('confirm_password'),
            document.getElementById('toggleConfirmPassword'),
            document.getElementById('eyeOpenConfirm'),
            document.getElementById('eyeClosedConfirm')
         );
      })();
   </script>

   {% if session.has('reset_error') %}
   <script>
      Swal.fire({
         icon: 'error',
         title: 'Gagal',
         text: '{{ session.get("reset_error") }}',
         confirmButtonColor: '#c8a84b'
      });
   </script>
   {% do session.remove('reset_error') %}
   {% endif %}

</body>
</html>
