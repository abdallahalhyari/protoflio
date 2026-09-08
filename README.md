# Abdallah Alhyari — Portfolio

A Flutter web portfolio for a senior mobile engineer. Ships as a single-page
PageView with seven vertical sections (About · Why · Hats · Skills · Projects
· Roles · Contact), fully bilingual (English / Arabic), persistent light/dark
theme, and full keyboard + wheel + touch navigation. Deployed to Firebase
Hosting.

Live: <https://testfirestore-9b0b0.web.app>

## Features

- **Vertical section PageView** with wheel snap, digit-key jumps (`1`–`7`),
  arrow-key nav, and a scroll-tracking side indicator that glides between
  sections rather than snapping.
- **Bilingual** — English and Arabic via `easy_localization`; the whole
  subtree rebuilds on locale change so no strings go stale.
- **Persistent theming** — light / dark preference stored via
  `shared_preferences`.
- **Editorial polish** — rotating sweep-gradient halo behind the portrait,
  film-grain overlay across the canvas, chapter-numbered section headings,
  and per-project hover-lift.
- **Desktop cursor overlay** — hollow ring + primary dot trail the pointer
  on web ≥ 700 px; system cursor stays visible for link/text affordances.
- **A11y**: honors `prefers-reduced-motion`, Semantics labels on every
  interactive control, focus-ring styling on the nav, screen-reader
  announcements on copy actions.
- **Responsive** — 1-, 2-, 3-, 4-column grids tuned per breakpoint;
  short-landscape phones (< 560 px tall) drop the decorative Lottie arrows
  and shrink the portrait; hero cards cap width on ultra-wide viewports.
- **SEO / PWA** — real meta tags, JSON-LD `Person` schema, manifest,
  1200×630 branded OG card, robots + sitemap, boot loader.

## Stack

- Flutter 3 (SDK ≥ 3.6.1) targeting web + iOS + Android.
- `easy_localization`, `lottie`, `url_launcher`, `shared_preferences`,
  `cupertino_icons`.
- CI / CD: GitHub Actions (`.github/workflows/flutter-ci.yml`) — analyze +
  test on every PR, build + deploy to Firebase Hosting on push to `main`
  when repo variable `DEPLOY_ENABLED=true`.

## Layout

```
lib/
├── main.dart                  MaterialApp + easy_localization boot
├── theme_controller.dart      persisted ThemeMode (ValueListenable)
├── theme/                     tokens + AppTheme
└── module/home/
    ├── home_screen.dart       PageView + nav + toggles
    ├── data/                  content sources (projects, skills, hats, experience)
    ├── model/                 typed content classes
    └── widget/                cards, tiles, cursor, grain, chapter heading
assets/
├── translations/{en,ar}.json  copy
├── background.webp, hats_background.webp
├── my_image.png, hat.png
└── arrow*.json                Lottie CTAs
web/
├── index.html                 meta + JSON-LD + boot loader
├── cv.pdf                     linked from Contact
├── manifest.json, robots.txt, sitemap.xml
└── og-image.png               1200×630
```

## Local development

```bash
flutter pub get
flutter run -d chrome           # web
flutter run -d <device-id>      # mobile
```

## Build

```bash
flutter build web --no-tree-shake-icons
```

Output goes to `build/web`; Firebase Hosting is configured in `firebase.json`
to serve that directory with SPA rewrites.

## Deploy

- **Preferred**: merge a PR to `main` — CI handles build + deploy.
- **Manual** (requires Firebase CLI auth on the target project):

```bash
firebase deploy --only hosting
```

## Keyboard shortcuts

| Key                          | Action                        |
| ---------------------------- | ----------------------------- |
| ↑ / PageUp                   | Previous section              |
| ↓ / PageDown / Space         | Next section                  |
| Home / End                   | Jump to first / last section  |
| `1`–`7` / Numpad `1`–`7`     | Jump directly to section N    |

## License

Personal portfolio — content and assets © Abdallah Alhyari. Code available
for reference.
