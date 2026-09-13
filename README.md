# Abdallah Alhyari — Portfolio

Editorial magazine-style portfolio built in Flutter. Runs on web, iOS, and Android from a single codebase. Highlights senior mobile engineering experience: offline-first architecture, NFC / ISO-7816 APDU, JWT security, and multi-year enterprise Flutter delivery.

Live: _(add production URL when domain is live)_

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

- **Flutter 3.6+ / Dart 3** — single codebase for web, iOS, Android, desktop.
- **Material 3** theming — `AppTheme` derived from a seed color with per-brightness `ColorScheme`.
- **Design tokens** (`lib/theme/tokens.dart`) — `AppSpacing`, `AppRadius`, `AppMotion`, `AppTypography`, `AppColors` (slate scale + editorial accents).
- **firebase_core + analytics** — screen-view logging.
- **url_launcher** — email / phone / social channel deep links.
- **google_fonts** — Inter body + custom `Tenada` display font (see `fonts/`).
- **lottie + animate_do** — subtle intro / entry animations.
- **flutter_localizations + intl** — `en`, `ar`, `cs` locales (see `lib/l10n/`).

## Architecture

```
lib/
├── main.dart                    # MaterialApp + global scroll behavior
├── theme/                       # Design tokens + ThemeData
├── locale_controller.dart       # Locale state
├── theme_controller.dart        # Light/Dark toggle
├── service/
│   ├── sound_service.dart       # Ambient audio + click effects
│   └── url_sync_service.dart    # Hash-based deep linking (#work, #contact, …)
└── module/home/
    ├── home_screen.dart         # Desktop PageView + mobile continuous scroll shell
    ├── page/                    # 7 section pages
    ├── widget/                  # Shared widgets (nav, cards, chips, backgrounds)
    ├── model/                   # Skill / Project / Experience / Hat data models
    └── data/                    # Content data (skills, projects, experience, hats)
```

## Running

Prereqs: Flutter 3.6+, Dart 3, Xcode + CocoaPods (iOS), Android Studio (Android).

```bash
flutter pub get
flutter run -d chrome              # web
flutter run -d ios                 # simulator
flutter run -d android             # device / emulator
```

## Testing

```bash
flutter analyze
flutter test                       # widget + theme + responsive smoke suite
```

Test suites: `test/widget_test.dart`, `test/theme_audit_test.dart`, `test/responsive_audit_test.dart`, `test/editorial_chip_test.dart`, `test/primary_button_test.dart`.

## Deploying

Web (Firebase Hosting):

```bash
flutter build web --release --tree-shake-icons --no-source-maps
firebase deploy --only hosting
```

Build-flag notes:
- `--tree-shake-icons` drops unused MaterialIcons glyphs from the icon font (usually cuts ~80–90% of the icon-font bytes).
- `--no-source-maps` keeps the release payload lean; drop it if you need to debug production stack traces.
- iOS release build should ship Impeller (default on stable). No extra flag needed.

Configuration lives in `firebase.json`. Analytics + hosting cache rules are already wired.

## Contact

- Email: alhyariabdallh@gmail.com
- LinkedIn: [in/abdallah-alhyari](https://www.linkedin.com/in/abdallah-alhyari-0294791a0/)
- GitHub: [@abdallahalhyari](https://github.com/abdallahalhyari)
