<style>
   :root {
      --forest: #0d2416;
      --deep: #152e1e;
      --gold: #c8a84b;
      --gold2: #e8cc7a;
      --cream: #f5efe4;
      --white: #ffffff;
   }

   * {
      box-sizing: border-box;
   }

   body {
      margin: 0;
      min-height: 100vh;
      font-family: 'Jost', sans-serif;
      color: var(--cream);
      background:
         radial-gradient(circle at 15% 15%, rgba(200, 168, 75, .16), transparent 42%),
         radial-gradient(circle at 85% 85%, rgba(94, 183, 120, .12), transparent 44%),
         linear-gradient(165deg, var(--deep) 0%, var(--forest) 70%);
   }

   .forgot-wrap {
      min-height: 100vh;
      display: flex;
      align-items: center;
      justify-content: center;
      padding: 24px;
   }

   .forgot-card {
      width: 100%;
      max-width: 520px;
      text-align: center;
      background: rgba(255, 255, 255, .06);
      border: 1px solid rgba(200, 168, 75, .28);
      border-radius: 24px;
      padding: 34px 28px;
      box-shadow: 0 24px 60px rgba(0, 0, 0, .32);
      backdrop-filter: blur(10px);
   }

   .forgot-title {
      font-size: 2rem;
      font-weight: 700;
      margin: 0 0 10px;
      color: var(--white);
   }

   .forgot-subtitle {
      margin: 0 0 18px;
      color: rgba(255, 255, 255, .82);
      line-height: 1.6;
   }

   .forgot-help {
      margin: 0 0 24px;
      color: rgba(255, 255, 255, .7);
      font-size: .95rem;
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
      transition: transform .2s ease, box-shadow .2s ease;
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

   @media (max-width: 991px) {
      .forgot-wrap {
         align-items: flex-start;
         padding-top: 80px;
      }

      .forgot-card {
         max-width: 620px;
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
         font-size: 1rem;
      }
   }
</style>

<section class="forgot-wrap">
   <div class="forgot-card">
      <h1 class="forgot-title">Lupa Password?</h1>
      <p class="forgot-subtitle">
         Fitur reset password sedang dalam pengembangan.
      </p>
      <p class="forgot-help">
         Silakan hubungi admin untuk bantuan reset akun Anda sementara waktu.
      </p>

      <div class="forgot-actions">
         <a class="btn-forgot primary" href="{{ url('login') }}">Kembali ke Login</a>
         <a class="btn-forgot secondary" href="{{ url('') }}"><span class="ti-home"></span> Home</a>
      </div>
   </div>
</section>