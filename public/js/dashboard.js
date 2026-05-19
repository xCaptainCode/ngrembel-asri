/* ─ CURSOR ─ */
const cur = document.getElementById('cursor');
const ring = document.getElementById('cursor-ring');
let mx = 0, my = 0, rx = 0, ry = 0;
if (cur && ring) {
   document.addEventListener('mousemove', e => {
      mx = e.clientX; my = e.clientY;
      cur.style.left = mx + 'px';
      cur.style.top = my + 'px';
   });
   (function animRing() {
      rx += (mx - rx) * .12;
      ry += (my - ry) * .12;
      ring.style.left = rx + 'px';
      ring.style.top = ry + 'px';
      requestAnimationFrame(animRing);
   })();
}

/* ─ NAVBAR SCROLL ─ */
const nav = document.getElementById('nav');
window.addEventListener('scroll', () => {
   if (nav) nav.classList.toggle('scrolled', window.scrollY > 60);
});

/* ─ PROFILE DROPDOWN ─ */
const profileButton = document.getElementById('profileButton');
const profileMenu   = document.getElementById('profileMenu');

if (profileButton && profileMenu) {
   profileButton.addEventListener('click', (e) => {
      e.preventDefault();
      e.stopPropagation();
      profileMenu.classList.toggle('show');
   });

   // Tutup jika klik di luar
   document.addEventListener('click', (e) => {
      if (!profileMenu.contains(e.target) && !profileButton.contains(e.target)) {
         profileMenu.classList.remove('show');
      }
   });

   // Tutup setelah pilih menu
   profileMenu.querySelectorAll('.profile-item').forEach(link => {
      link.addEventListener('click', () => profileMenu.classList.remove('show'));
   });
}

/* ─ MOBILE BURGER NAV ─ */
const navToggleMobile = document.getElementById('navToggleMobile');
const navMenu = document.getElementById('navMenu');
const navLinks = document.querySelectorAll('.nav-menu a:not(.profile-btn):not(.nav-link-main):not(.nav-sub-toggle)');
const navSubToggles = document.querySelectorAll('.nav-sub-toggle');
const navDropdownMainLinks = document.querySelectorAll('.nav-item-dropdown > .nav-link-main:not(.nav-sub-toggle)');
const mobileQuery = window.matchMedia('(max-width: 900px)');

function isMobileMenuMode() {
   return mobileQuery.matches || (navMenu && navMenu.classList.contains('active'));
}

navSubToggles.forEach(toggle => {
   toggle.addEventListener('click', (e) => {
      if (isMobileMenuMode()) {
         e.preventDefault();
         e.stopPropagation();
         e.stopImmediatePropagation();
         const wrap = toggle.closest('.nav-item-dropdown');
         if (!wrap) return;

         // Toggle current dropdown
         wrap.classList.toggle('open');
         const expanded = wrap.classList.contains('open');
         toggle.setAttribute('aria-expanded', expanded ? 'true' : 'false');

         // Close other dropdowns
         document.querySelectorAll('.nav-item-dropdown.open').forEach(item => {
            if (item !== wrap) {
               item.classList.remove('open');
               const itemToggle = item.querySelector('.nav-sub-toggle');
               if (itemToggle) itemToggle.setAttribute('aria-expanded', 'false');
            }
         });
      }
   });
});

navDropdownMainLinks.forEach(link => {
   link.addEventListener('click', (e) => {
      if (isMobileMenuMode()) {
         e.preventDefault();
         e.stopPropagation();
         e.stopImmediatePropagation();
         const wrap = link.closest('.nav-item-dropdown');
         if (!wrap) return;

         // Toggle current dropdown
         wrap.classList.toggle('open');
         const expanded = wrap.classList.contains('open');
         const toggle = wrap.querySelector('.nav-sub-toggle');
         if (toggle) toggle.setAttribute('aria-expanded', expanded ? 'true' : 'false');

         // Close other dropdowns
         document.querySelectorAll('.nav-item-dropdown.open').forEach(item => {
            if (item !== wrap) {
               item.classList.remove('open');
               const itemToggle = item.querySelector('.nav-sub-toggle');
               if (itemToggle) itemToggle.setAttribute('aria-expanded', 'false');
            }
         });
      }
   });
});

if (navToggleMobile && navMenu) {
   navToggleMobile.addEventListener('click', () => {
      navToggleMobile.classList.toggle('active');
      navMenu.classList.toggle('active');
      document.body.classList.toggle('overflow-hidden');
      if (!navMenu.classList.contains('active')) {
         document.querySelectorAll('.nav-item-dropdown.open').forEach(item => item.classList.remove('open'));
         navSubToggles.forEach(toggle => toggle.setAttribute('aria-expanded', 'false'));
         if (profileMenu) profileMenu.classList.remove('show');
      }
   });

   navLinks.forEach(link => {
      link.addEventListener('click', () => {
         navToggleMobile.classList.remove('active');
         navMenu.classList.remove('active');
         document.body.classList.remove('overflow-hidden');
         document.querySelectorAll('.nav-item-dropdown.open').forEach(item => item.classList.remove('open'));
         navSubToggles.forEach(toggle => toggle.setAttribute('aria-expanded', 'false'));
         if (profileMenu) profileMenu.classList.remove('show');
      });
   });
}

/* ─ HERO SLIDESHOW ─ */
const slides = document.querySelectorAll('.slide');
const dotsWrap = document.getElementById('slideDots');
const slideNumEl = document.getElementById('slideNum');
let cur_slide = 0;

if (dotsWrap && slides.length > 0) {
   slides.forEach((_, i) => {
      const d = document.createElement('button');
      d.className = 'dot' + (i === 0 ? ' active' : '');
      d.onclick = () => goSlide(i);
      dotsWrap.appendChild(d);
   });
}

function goSlide(n) {
   if (slides.length === 0) return;
   slides[cur_slide].classList.remove('active');
   const dots = document.querySelectorAll('.dot');
   if (dots[cur_slide]) dots[cur_slide].classList.remove('active');
   cur_slide = (n + slides.length) % slides.length;
   slides[cur_slide].classList.add('active');
   if (dots[cur_slide]) dots[cur_slide].classList.add('active');
   if (slideNumEl) slideNumEl.textContent = cur_slide + 1;
}
if (slides.length > 0) setInterval(() => goSlide(cur_slide + 1), 5000);

/* ─ PARALLAX ─ */
const pdBg1 = document.getElementById('pdBg1');
const pdBg2 = document.getElementById('pdBg2');
const sejarahBg = document.getElementById('sejarahBg');
window.addEventListener('scroll', () => {
   const sy = window.scrollY;
   if (pdBg1) pdBg1.style.transform = `translateY(${sy * .08}px)`;
   if (pdBg2) pdBg2.style.transform = `translateY(${(sy - pdBg2.parentElement.offsetTop) * .08}px)`;
   if (sejarahBg) sejarahBg.style.transform = `translateY(${(sy - sejarahBg.parentElement.offsetTop) * .05}px)`;
}, { passive: true });

/* ─ SCROLL REVEAL ─ */
const revEls = document.querySelectorAll('.r,.r-left,.r-right,.tl-item');
const revObs = new IntersectionObserver((entries) => {
   entries.forEach(e => {
      if (e.isIntersecting) {
         e.target.classList.add('on');
         if (e.target.classList.contains('tl-item')) revObs.unobserve(e.target);
      }
   });
}, { threshold: 0.1 });
revEls.forEach(el => revObs.observe(el));

/* ─ COUNT UP ─ */
const countEls = document.querySelectorAll('.stat-num[data-count]');
const cntObs = new IntersectionObserver((entries) => {
   entries.forEach(e => {
      if (e.isIntersecting) {
         const target = +e.target.dataset.count;
         let cur = 0; const step = target / 60;
         const t = setInterval(() => {
            cur += step; if (cur >= target) { cur = target; clearInterval(t); }
            e.target.textContent = Math.round(cur) + (target >= 10 ? '+' : '');
         }, 16);
         cntObs.unobserve(e.target);
      }
   });
}, { threshold: .5 });
countEls.forEach(el => cntObs.observe(el));

/* ─ MENU TABS ─ */
function showMenu(id, btn) {
   const panel = document.getElementById('m-' + id);
   if (!panel) return;
   document.querySelectorAll('.mpanel').forEach(p => p.classList.remove('active'));
   document.querySelectorAll('.mtab').forEach(b => b.classList.remove('active'));
   panel.classList.add('active');
   btn.classList.add('active');
   panel.querySelectorAll('.r').forEach(el => {
      el.classList.remove('on');
      setTimeout(() => el.classList.add('on'), 50);
   });
}
