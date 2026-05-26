<!DOCTYPE html>
<html lang="id">
<head>
   <meta charset="UTF-8">
   <meta name="viewport" content="width=device-width, initial-scale=1.0">
   <title>Lupa Password - Ngrembel Asri</title>
   
   <!-- Meta SEO -->
   <meta name="description" content="Informasi pemulihan password akun member Ngrembel Asri.">
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

      .forgot-wrap {
         width: 100%;
         max-width: 520px;
         padding: 24px;
         z-index: 2;
      }

      .forgot-card {
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

      .forgot-title {
         font-family: 'Cormorant Garamond', serif;
         font-size: clamp(2rem, 5vw, 2.5rem);
         font-weight: 700;
         margin-bottom: 10px;
         color: var(--white);
      }

      .forgot-subtitle {
         margin-bottom: 18px;
         color: rgba(255, 255, 255, .82);
         line-height: 1.6;
         font-size: 1rem;
      }

      .forgot-help {
         margin-bottom: 24px;
         color: rgba(255, 255, 255, .7);
         font-size: .95rem;
         line-height: 1.5;
      }

      .forgot-actions {
         display: flex;
         gap: 12px;
         justify-content: center;
         flex-wrap: wrap;
      }

      .btn-forgot {
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
      }

      .btn-forgot.primary {
         background: linear-gradient(135deg, var(--gold), var(--gold2));
         color: var(--forest);
         box-shadow: 0 8px 24px rgba(200, 168, 75, .38);
      }

      .btn-forgot.secondary {
         background: rgba(255, 255, 255, .14);
         color: var(--white);
         border: 1px solid rgba(255, 255, 255, .28);
      }

      .btn-forgot:hover {
         transform: translateY(-2px);
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
      }

      .auth-input:focus {
         border-color: rgba(232, 204, 122, .95);
         box-shadow: 0 0 0 3px rgba(200, 168, 75, .16);
         background: rgba(255, 255, 255, .08);
      }

      .auth-input::placeholder {
         color: rgba(255, 255, 255, .38);
      }

      @media (max-width: 991px) {
         .forgot-card {
            max-width: 100%;
         }
      }

      @media (max-width: 767px) {
         .forgot-wrap {
            padding: 90px 16px 24px;
         }

         .forgot-actions {
            flex-direction: column;
         }

         .btn-forgot {
            width: 100%;
            padding: 13px 20px;
            font-size: .9rem;
         }
      }
   </style>
</head>
<body>

   <section class="forgot-wrap">
      <div class="forgot-card">
         <h1 class="forgot-title">Lupa Password?</h1>
         <p class="forgot-subtitle" style="margin-bottom: 1.5rem;">
            Masukkan email terdaftar Anda untuk menerima tautan pemulihan password.
         </p>

         <form action="{{ url('lupa-password') }}" method="POST">
            <div class="auth-field">
               <label class="auth-label" for="email">Alamat Email</label>
               <input class="auth-input" id="email" type="email" name="email" required placeholder="Masukkan email Anda">
            </div>

            <div class="forgot-actions" style="margin-top: 1.5rem;">
               <button type="submit" class="btn-forgot primary">Kirim Link Reset</button>
               <a class="btn-forgot secondary" href="{{ url('login') }}">Kembali</a>
            </div>
         </form>
      </div>
   </section>

   <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
   
   {% if session.has('forgot_error') %}
   <script>
      Swal.fire({
         icon: 'error',
         title: 'Gagal',
         text: '{{ session.get("forgot_error") }}',
         confirmButtonColor: '#c8a84b'
      });
   </script>
   {% do session.remove('forgot_error') %}
   {% endif %}

   {% if session.has('forgot_success') %}
   <script>
      Swal.fire({
         icon: 'success',
         title: 'Permintaan Dikirim',
         text: '{{ session.get("forgot_success") }}',
         confirmButtonColor: '#c8a84b'
      });
   </script>
   {% do session.remove('forgot_success') %}
   {% endif %}

</body>
</html>