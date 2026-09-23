# Abdallah Alhyari — Portfolio

Editorial magazine-style portfolio built in Flutter. Runs on web, iOS, and Android from a single codebase. Highlights senior mobile engineering experience: offline-first architecture, NFC / ISO-7816 APDU, JWT security, and multi-year enterprise Flutter delivery.

Live: [alhyari.web.app](https://alhyari.web.app)

---

## Sections

| # | Section | Content |
|---|---------|---------|
| 01 | Intro | Wordmark cover, role kicker, CTAs |
| 02 | Selected Work | 4 enterprise case studies with architectural dossiers |
| 03 | Engineering | 4 production architecture flowcharts (Clean, Offline-First, NFC APDU, JWT/Keystore) |
| 04 | Experience | Career timeline + academic annex + certifications |
| 05 | Skills & Stack | 13 disciplines with mastery levels + flip-card details |
| 06 | Roles & Advisory | Six-hat perspective deck (draggable poker fan on desktop) |
| 07 | Contact | Live-ticking Amman clock, engagement matrix, one-tap presets, verified channels |

## Tech Stack

- **Flutter 3.6+ / Dart 3** — single codebase for web, iOS, Android, desktop (macOS runner included for local dev/testing).
- **flutter_bloc + equatable** — BLoC state management (`lib/core/bloc/{navigation,theme,locale}`, plus per-feature blocs under `lib/features/*/bloc/`).
- **Material 3** theming — `AppTheme` derived from a seed color with per-brightness `ColorScheme`.
- **Design tokens** (`lib/theme/tokens.dart`) — `AppSpacing`, `AppRadius`, `AppMotion`, `AppTypography`, `AppColors` (slate scale + editorial accents).
- **Firebase Hosting** — deploy target only; the Flutter app itself has no `firebase_core`/Firebase SDK dependency. Analytics ships via `web/index.html`'s `gtag` snippet, called from Dart through `dart:js_interop` (`lib/service/analytics_service_web.dart`) — no Dart-side Firebase init needed.
- **url_launcher** — email / phone / social channel deep links.
- **shared_preferences** — persisted theme mode + locale.
- **Custom `Tenada` display font** (`fonts/Tenada.ttf`, subsetted, <32 KB) + system font stack for body text — no `google_fonts` dependency.
- **flutter_localizations + intl** — `en`, `ar`, `cs` locales (see `lib/l10n/`).

## Architecture

Feature-first: each top-level section owns its `page/`, `widget/`, `bloc/`, `model/`, and `data/` — cross-cutting app shell and state live in `core/` and `features/shell/`.

```
lib/
├── main.dart                       # MaterialApp bootstrap + global scroll behavior
├── core/
│   └── bloc/
│       ├── navigation/              # NavigationBloc — section index, scroll-to-top visibility
│       ├── theme/                   # ThemeBloc — light/dark mode, live section-accent seed color
│       └── locale/                  # LocaleBloc — en / ar / cs
├── service/
│   ├── analytics_service*.dart      # gtag-backed screen/CTA telemetry (web/stub split)
│   ├── cv_service.dart              # CV download & preview handler
│   ├── sound_service*.dart          # Ambient audio + tactile click feedback (web/io split)
│   └── url_sync_service*.dart       # Hash-based deep linking (#work, #work/<slug>, …)
├── theme/                           # Design tokens + ThemeData (AppTheme, AppColors, AppSpacing, AppMotion...)
├── shared/widget/                   # Cross-feature components (PrimaryButton, HolographicCardPhysics, AppToast...)
├── l10n/                            # ARB files + generated AppLocalizations (en, ar, cs)
└── features/
    ├── shell/                       # HomeScreen: desktop PageView + mobile continuous scroll,
    │                                 #   HomeController (real nav state), keyboard nav, scroll interceptor
    ├── intro/                       # Hero section (page/ + widget/)
    ├── projects/                    # Selected Work grid, domain filters, case-study modal (page/widget/bloc/model/data)
    ├── case_study/                  # Dedicated full-page case studies (routed via CaseStudyRouter, not the modal)
    ├── engineering/                 # Architecture flowcharts + simulator (page/widget/bloc/data)
    ├── experience/                  # Career timeline (page/widget/bloc/model/data)
    ├── skills/                      # Skill tiles + category filters (page/widget/bloc/data)
    ├── hats/                        # Perspective card deck (page/widget/bloc/model)
    └── contact/                     # Contact channels + inquiry composer (page/widget/bloc)
```

Notable architectural detail: `NavigationBloc` mirrors the current section index for UI highlighting (nav pills, dots, folio bar), but the *actual* page position is owned by `HomeController`/`_HomeScreenState` (the real `PageController` / mobile `ScrollController`). Always drive navigation through `HomeController.of(context).goTo(...)` / `.scrollToMobileSection(...)` — dispatching `NavigationPageSelected` straight to the bloc only updates the highlight, not the visible page.

## Running

Prereqs: Flutter 3.6+, Dart 3, Xcode + CocoaPods (iOS/macOS), Android Studio (Android).

```bash
flutter pub get
flutter run -d chrome              # web
flutter run -d ios                 # simulator
flutter run -d android             # device / emulator
flutter run -d macos               # desktop
```

Or via the `Makefile` / npm scripts (both wrap the same commands):

```bash
make format         # dart format lib/ test/
make analyze         # flutter analyze
make test            # flutter test
make build            # flutter build web --wasm --release ...
make deploy           # format-check + analyze + test + build + firebase deploy
make deploy-fast      # build + firebase deploy (skips verification, for quick iteration)
```

## Testing & Quality Assurance

```bash
flutter analyze     # 0 static analysis issues
flutter test        # ~280 passing tests across 44 files in test/
```

Test suites cover, per feature: widget rendering across light/dark theme (`theme_audit_test.dart`), responsive breakpoints (`responsive_audit_test.dart`), RTL layout (`rtl_smoke_test.dart`), keyboard navigation (`home_screen_keyboard_test.dart`), motion/reduced-motion behavior (`motion_audit_test.dart`), accessibility semantics (`accessibility_audit_test.dart`), scroll/repaint performance (`scroll_performance_test.dart`, `performance_audit_test.dart`), each BLoC (`test/bloc/*_test.dart`), and per-feature widget suites (`*_widgets_test.dart`). See `test/` for the full list.

## Deploying

Web (Firebase Hosting), via `make deploy` or manually:

```bash
flutter build web --wasm --release --tree-shake-icons --no-source-maps
node patch_flutter_js.js
firebase deploy --only hosting
```

Build-flag notes:
- `--wasm` compiles Dart to WebAssembly instead of JavaScript, delivering near-native performance and faster initial load times.
- `--tree-shake-icons` drops unused MaterialIcons glyphs from the icon font (usually cuts ~80–90% of the icon-font bytes).
- `--no-source-maps` keeps the release payload lean; drop it if you need to debug production stack traces.
- `patch_flutter_js.js` patches the generated bundle for Lighthouse best-practices compliance (disables the SW, uses local CanvasKit, injects `.part.js` prefetch tags).
- iOS release build should ship Impeller (default on stable). No extra flag needed.

Configuration lives in `firebase.json` (single hosting target: `alhyari`) and `.firebaserc` (default project `testfirestore-9b0b0` — the project's default Hosting site of the same name exists but is unused/undeletable; deploys don't target it).

CI/CD: `.github/workflows/firebase-hosting-merge.yml` runs format-check + analyze + test + build and deploys to Firebase Hosting on every push to `main`. Requires a `FIREBASE_SERVICE_ACCOUNT` secret configured in the repo settings.

## Contact

- Email: alhyariabdallh@gmail.com
- LinkedIn: [in/abdallah-alhyari](https://www.linkedin.com/in/abdallah-alhyari-0294791a0/)
- GitHub: [@abdallahalhyari](https://github.com/abdallahalhyari)
