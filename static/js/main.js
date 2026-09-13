// Spacious Africa — main.js

// navbar scroll (IntersectionObserver on a top sentinel, no scroll-listener jank)
const navbar = document.getElementById('navbar');
const navSentinel = document.getElementById('navSentinel');
if (navbar && navSentinel) {
  new IntersectionObserver(([entry]) => {
    navbar.classList.toggle('bg-zinc-950/95', !entry.isIntersecting);
  }).observe(navSentinel);
}

// scroll-reveal
if (window.matchMedia('(prefers-reduced-motion: no-preference)').matches) {
  const revealObserver = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        entry.target.classList.add('is-visible');
        revealObserver.unobserve(entry.target);
      }
    });
  }, { threshold: 0.15, rootMargin: '0px 0px -60px 0px' });
  document.querySelectorAll('.reveal').forEach(el => revealObserver.observe(el));
} else {
  document.querySelectorAll('.reveal').forEach(el => el.classList.add('is-visible'));
}

// mobile drawer
const burgerBtn   = document.getElementById('burgerBtn');
const drawer      = document.getElementById('drawer');
const drawerPanel = document.getElementById('drawerPanel');
const drawerOvl   = document.getElementById('drawerOverlay');
const b1 = document.getElementById('b1');
const b2 = document.getElementById('b2');
const b3 = document.getElementById('b3');

function openDrawer() {
  drawer.classList.remove('hidden');
  requestAnimationFrame(() => {
    drawerOvl.classList.add('opacity-100');
    drawerPanel.classList.remove('translate-x-full');
  });
  document.body.style.overflow = 'hidden';
  b1.style.transform = 'translateY(7px) rotate(45deg)';
  b2.style.opacity   = '0';
  b3.style.transform = 'translateY(-7px) rotate(-45deg)';
}
function closeDrawer() {
  drawerOvl.classList.remove('opacity-100');
  drawerPanel.classList.add('translate-x-full');
  document.body.style.overflow = '';
  b1.style.transform = '';
  b2.style.opacity   = '';
  b3.style.transform = '';
  setTimeout(() => drawer.classList.add('hidden'), 320);
}

if (burgerBtn) burgerBtn.addEventListener('click', () =>
  drawer.classList.contains('hidden') ? openDrawer() : closeDrawer()
);
if (drawerOvl) drawerOvl.addEventListener('click', closeDrawer);
document.querySelectorAll('.drawer-link').forEach(a => a.addEventListener('click', closeDrawer));

// explore dropdown
const exploreBtn  = document.getElementById('exploreBtn');
const exploreMenu = document.getElementById('exploreMenu');
const exploreCaret = document.getElementById('exploreCaret');

if (exploreBtn && exploreMenu) {
  exploreBtn.addEventListener('click', e => {
    e.stopPropagation();
    const open = exploreMenu.classList.toggle('hidden');
    exploreCaret.style.transform = open ? '' : 'rotate(180deg)';
  });
  document.addEventListener('click', () => {
    exploreMenu.classList.add('hidden');
    exploreCaret.style.transform = '';
  });
  exploreMenu.addEventListener('click', e => e.stopPropagation());
}

// active link highlight
const p = window.location.pathname;
document.querySelectorAll('.nav-link').forEach(a => {
  const h = a.getAttribute('href');
  if (h && (p === h || (h !== '/' && p.startsWith(h))))
    a.classList.replace('text-zinc-400', 'text-white');
});

// auto dismiss messages
document.querySelectorAll('.msg').forEach(el => {
  setTimeout(() => { el.style.opacity='0'; el.style.transition='opacity .4s'; setTimeout(()=>el.remove(),400); }, 5000);
});
document.querySelectorAll('.msg-close').forEach(btn => {
  btn.addEventListener('click', () => { const m=btn.closest('.msg'); m.style.transition='opacity .3s'; m.style.opacity='0'; setTimeout(()=>m.remove(),300); });
});
