// Executive Portfolio PWA Service Worker (Cache-First + Stale-While-Revalidate)
const CACHE_NAME = 'alhyari-portfolio-v1';

const STATIC_ASSETS = [
  './',
  './index.html',
  './manifest.json',
  './favicon.png',
  './icons/apple-touch-icon.png',
  './icons/Icon-192.png',
  './icons/Icon-512.png',
  './assets/fonts/Tenada.ttf',
  './assets/fonts/ReadexPro.ttf',
  './assets/fonts/ShareTechMono-Regular.ttf',
  './assets/fonts/MaterialIcons-Regular.otf',
  './assets/assets/my_image.webp',
  './assets/assets/hat.webp',
  './assets/assets/data/projects.json',
  './assets/assets/data/skills.json',
  './assets/assets/data/experience.json',
  './assets/assets/data/hats.json',
  './assets/assets/data/education.json',
  './assets/assets/data/certifications.json',
];

self.addEventListener('install', (event) => {
  event.waitUntil(
    caches.open(CACHE_NAME).then((cache) => {
      return cache.addAll(STATIC_ASSETS);
    }).then(() => self.skipWaiting())
  );
});

self.addEventListener('activate', (event) => {
  event.waitUntil(
    caches.keys().then((keys) => {
      return Promise.all(
        keys.map((key) => {
          if (key !== CACHE_NAME) {
            return caches.delete(key);
          }
        })
      );
    }).then(() => self.clients.claim())
  );
});

self.addEventListener('fetch', (event) => {
  // Ignore non-GET requests or browser extension requests
  if (event.request.method !== 'GET' || !event.request.url.startsWith('http')) {
    return;
  }

  const url = new URL(event.request.url);

  // Cache-First strategy for WASM modules, CanvasKit binaries, TTF fonts, and WebP images
  if (
    url.pathname.endsWith('.wasm') ||
    url.pathname.endsWith('.ttf') ||
    url.pathname.endsWith('.woff2') ||
    url.pathname.endsWith('.webp') ||
    url.pathname.includes('/canvaskit/')
  ) {
    event.respondWith(
      caches.match(event.request).then((cachedResponse) => {
        if (cachedResponse) {
          return cachedResponse;
        }
        return fetch(event.request).then((networkResponse) => {
          if (networkResponse && networkResponse.status === 200) {
            const responseToCache = networkResponse.clone();
            caches.open(CACHE_NAME).then((cache) => {
              cache.put(event.request, responseToCache);
            });
          }
          return networkResponse;
        });
      })
    );
    return;
  }

  // Stale-While-Revalidate for HTML, JSON data, and JavaScript chunks
  event.respondWith(
    caches.match(event.request).then((cachedResponse) => {
      const fetchPromise = fetch(event.request).then((networkResponse) => {
        if (networkResponse && networkResponse.status === 200) {
          const responseToCache = networkResponse.clone();
          caches.open(CACHE_NAME).then((cache) => {
            cache.put(event.request, responseToCache);
          });
        }
        return networkResponse;
      }).catch(() => cachedResponse);

      return cachedResponse || fetchPromise;
    })
  );
});
