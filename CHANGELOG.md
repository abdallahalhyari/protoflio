# Changelog

All notable changes to this project. Generated from git history, grouped by
theme rather than release, since there are no versioned releases yet.

## Unreleased

### Editorial polish

- Film-grain overlay (~1500 seeded dots, α 0.045, `RepaintBoundary`) above
  content but `IgnorePointer` — tactile depth without banding.
- Chapter-numbered section headings on Skills / Projects / Experience — big
  outlined numeral behind the title, `NN / 07` label above.
- Rotating sweep-gradient halo behind the intro portrait (primary +
  tertiary) with slow 18 s cycle; mouse-parallax translates the portrait a
  few px toward the pointer on desktop.
- Project cards lift on hover with a primary-tinted shadow.
- Desktop-web cursor overlay (`SiteCursor`) — hollow ring + primary dot
  trail the pointer on ≥ 700 px viewports.
- Contact rows flash a primary tint on tap and show a brief `COPIED` chip
  beside the label on long-press.
- Vertical page indicator: soft primary halo glides continuously between
  dot slots as the PageView scrolls.

### Responsive / layout

- Projects breakpoint 1100 → 900: tablet portrait and iPad landscape now
  render the 2×2 grid instead of the narrow horizontal-swipe fallback.
- Skills 4-column layout at ≥ 1400 px.
- Intro hero fits short-landscape (< 560 tall) — avatar radius clamped to
  48–88 px, decorative Lottie arrow hidden.
- Hats-intro Lottie arrow follows the same short-viewport rule.
- Hero card `maxWidth` capped (hats 900, contact 720) so ultra-wide
  viewports don't stretch content across the full canvas.
- Hats grid fits viewport (`NeverScrollable`) so no inner Scrollable
  competes with the outer PageView for wheel + touch.
- Projects fits viewport at both breakpoints for the same reason.
- Top nav horizontal scroll + tighter labels fix 4.7 px overflow at 1200.

### Navigation / input

- Mouse wheel snaps whole PageView sections on desktop web (450 ms cooldown,
  4 px deadzone).
- Digit keys `1`–`7` and numpad `1`–`7` jump directly to a section.

### Accessibility

- `MediaQueryData.disableAnimations` honored for the intro halo rotation,
  portrait parallax, and project hover-lift.
- Nav focus ring, contact-icon `ExcludeSemantics`, theme/language toggle
  focus colors.
- Semantics labels + screen-reader announcements on copy actions.

### Internationalization

- Arabic + English via `easy_localization`; language toggle in the top-right
  cluster.
- Home subtree keyed on locale so `.tr()` strings always rebuild on switch.

### Theming

- Design-token migration: widgets consume `AppSpacing`, `AppRadius`,
  `AppMotion`, `AppTypography`, `AppColors`.
- Persisted `ThemeMode` via `shared_preferences`.

### iOS

- Custom `AA` monogram launcher icon on dark surface (#0E0E10) with a
  primary blue accent corner — replaces the stock Flutter logo across all
  15 AppIcon slots.

### SEO / PWA

- Meta tags, JSON-LD `Person` schema, 1200×630 branded OG image,
  `manifest.json`, `robots.txt`, `sitemap.xml`, boot loader in
  `web/index.html`.
- Translation JSON no longer cached forever (`firebase.json`).

### Infrastructure

- GitHub Actions: analyze + test on PR; build + deploy on push to `main`
  when `DEPLOY_ENABLED=true`.
- Deploy-preview job gets `pull-requests: write` permission.
- Firebase SPA rewrite fix.

### Content

- Projects: NatHealth Mobile Suite (E-Health Gate + Ring), Solutions Now
  (loyalty + Snapchat-style), ESKADENIA product domains.
- Skills: AI / LLM, RabbitMQ, iOS across skills / OG / roles / project
  stacks.
