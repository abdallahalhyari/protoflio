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
├── theme/                       # Design tokens + ThemeData (AppTheme, AppColors, AppSpacing...)
├── locale_controller.dart       # Multi-locale state controller (en, ar, cs)
├── theme_controller.dart        # Light/Dark mode state notifier
├── service/
│   ├── analytics_service.dart   # Screen tracking & CTA telemetry
│   ├── cv_service.dart          # ATS-verified CV download & preview handler
│   ├── sound_service.dart       # Ambient audio + tactile click feedback
│   └── url_sync_service.dart    # Hash-based deep linking (#work, #contact, …)
└── module/home/
    ├── home_screen.dart         # Desktop PageView + mobile continuous scroll shell
    ├── page/                    # Modularized section views (-56% total page footprint)
    │   ├── intro_page.dart
    │   ├── projects_page.dart
    │   ├── engineering_page.dart
    │   ├── experience_page.dart
    │   ├── skills_page.dart
    │   ├── hats_grid_page.dart
    │   ├── contact_page.dart
    │   └── project_modal.dart
    ├── widget/                  # Domain-isolated component subpackages
    │   ├── intro/               # IntroCtaRow, IntroFooterStrip, IntroAvailabilityBanner
    │   ├── projects/            # PipelineTopologyDiagram, NfcArchitectureDiagram, ProjectDossierCard
    │   ├── engineering/         # EngineeringHeader, ArchitectureTopicTabs, ArchitectureDiagramCard...
    │   ├── experience/          # ExperienceHeader, CredentialsBentoCard, AnimatedExperienceNode...
    │   ├── skills/              # SkillsHeader, SkillCategoryFilters, SkillsEmptyState...
    │   ├── hats/                # HatDeckHeader, ContinuousMobileHatColumn, HatBioStrip, HatRolePills...
    │   └── contact/             # ContactHeader, HeroEmailCard, ExpressPresetsBar, CvDossierCard...
    ├── model/                   # Skill / Project / Experience / Hat / Topic data models
    └── data/                    # Pure domain data sources (projects, skills, experience, hats)
```

## Running

Prereqs: Flutter 3.6+, Dart 3, Xcode + CocoaPods (iOS), Android Studio (Android).

```bash
flutter pub get
flutter run -d chrome              # web
flutter run -d ios                 # simulator
flutter run -d android             # device / emulator
```

## Testing & Quality Assurance

Comprehensive verification across 112 automated tests:

```bash
flutter analyze                    # 0 static analysis issues
flutter test                       # 112/112 passing tests
```

Test suites:
- `test/widget_test.dart` — Core app bootstrap, desktop keyboard navigation & section transitions.
- `test/theme_audit_test.dart` — Comprehensive light and dark mode audits across all 7 sections.
- `test/responsive_audit_test.dart` — Breakpoint layout assertions across desktop, tablet, and mobile.
- `test/rtl_smoke_test.dart` — Right-to-left bidirectional layout assertions (Arabic locale).
- `test/contact_widgets_test.dart` — Contact header, encrypted email cards, express presets, CV dossier & channels.
- `test/hats_widgets_test.dart` — Architectural perspectives deck, continuous mobile scroll, role pills & steppers.
- `test/engineering_widgets_test.dart` — Architecture header, topic tabs, flowchart diagrams & technical safeguards.
- `test/experience_widgets_test.dart` — Career trajectory header, academic annex, certification bento & timeline nodes.
- `test/skills_widgets_test.dart` — Skills header, category filters, and empty-state fallback.
- `test/projects_widgets_test.dart` — CI/CD pipeline topology, ISO-7816 NFC APDU architecture & dossier cards.
- `test/editorial_chip_test.dart` & `test/primary_button_test.dart` — Design system atomic token components.

## Deploying

Web (Firebase Hosting):

```bash
flutter build web --wasm --release --tree-shake-icons --no-source-maps
firebase deploy --only hosting
```

Build-flag notes:
- `--wasm` compiles Dart to WebAssembly instead of JavaScript, delivering near-native performance and faster initial load times.
- `--tree-shake-icons` drops unused MaterialIcons glyphs from the icon font (usually cuts ~80–90% of the icon-font bytes).
- `--no-source-maps` keeps the release payload lean; drop it if you need to debug production stack traces.
- iOS release build should ship Impeller (default on stable). No extra flag needed.

Configuration lives in `firebase.json`. Analytics + hosting cache rules are already wired.

## Contact

- Email: alhyariabdallh@gmail.com
- LinkedIn: [in/abdallah-alhyari](https://www.linkedin.com/in/abdallah-alhyari-0294791a0/)
- GitHub: [@abdallahalhyari](https://github.com/abdallahalhyari)
