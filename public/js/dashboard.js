/* ─ CURSOR ─ */
const cur = document.getElementById('cursor');
const ring = document.getElementById('cursor-ring');
let mx = 0, my = 0, rx = 0, ry = 0;
document.addEventListener('mousemove', e => { mx = e.clientX; my = e.clientY; cur.style.left = mx + 'px'; cur.style.top = my + 'px'; });
(function animRing() { rx += (mx - rx) * .12; ry += (my - ry) * .12; ring.style.left = rx + 'px'; ring.style.top = ry + 'px'; requestAnimationFrame(animRing); })();

/* ─ NAVBAR SCROLL ─ */
const nav = document.getElementById('nav');
window.addEventListener('scroll', () => {
   if (nav) nav.classList.toggle('scrolled', window.scrollY > 60);
});

/* ─ MOBILE NAV ─ */
const navToggle = document.getElementById('navToggle');
const navMenu = document.getElementById('navMenu');
const navLinks = document.querySelectorAll('.nav-menu a');

if (navToggle && navMenu) {
   navToggle.addEventListener('click', () => {
      navToggle.classList.toggle('active');
      navMenu.classList.toggle('active');
      document.body.classList.toggle('overflow-hidden');
   });

   navLinks.forEach(link => {
      link.addEventListener('click', () => {
         navToggle.classList.remove('active');
         navMenu.classList.remove('active');
         document.body.classList.remove('overflow-hidden');
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

/* ─ GALLERY SLIDESHOW ─ */
const gslides = document.querySelectorAll('.gslide');
const thumbsWrap = document.getElementById('galThumbsWrap');
let gcur = 0;
const gImgs = [
   'images/wahana/aviary.jpg',
   'images/wahana/ember-tumpah.jpg',
   'images/wahana/kolam-tm.jpg',
   'images/wahana/paintball.jpg',
   'images/wahana/pasar-kembang.jpg',
   'images/wahana/omah-playon.jpg',
];

if (thumbsWrap && gslides.length > 0) {
   gImgs.forEach((src, i) => {
      const t = document.createElement('div');
      t.className = 'gthumb' + (i === 0 ? ' active' : '');
      t.innerHTML = `<img src="${src}" alt="thumb ${i + 1}"/>`;
      t.onclick = () => goGaleri(i);
      thumbsWrap.appendChild(t);
   });
}

function goGaleri(n) {
   if (gslides.length === 0) return;
   gslides[gcur].classList.remove('active');
   const thumbs = document.querySelectorAll('.gthumb');
   if (thumbs[gcur]) thumbs[gcur].classList.remove('active');
   gcur = (n + gslides.length) % gslides.length;
   gslides[gcur].classList.add('active');
   if (thumbs[gcur]) thumbs[gcur].classList.add('active');
}
function moveGaleri(dir) { if (gslides.length > 0) goGaleri(gcur + dir); }
if (gslides.length > 0) setInterval(() => goGaleri(gcur + 1), 4500);