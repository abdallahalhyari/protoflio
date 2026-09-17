# Handoff: HTML Boot Loader / Early LCP Skeleton

Purpose: paint a real portfolio hero in raw HTML on the first frame so Lighthouse LCP fires against text visible ~800 ms in — not against the Flutter canvas at 3-5 s after wasm parse.

## Overview

`web/index.html` renders a full-viewport `<div id="boot-loader">` that stays visible until Flutter dispatches `flutter-first-frame`. The loader shows the "Abdallah Alhyari" wordmark, role subtitle, and a pulsing red bar. Once Flutter takes over, the loader fades and Flutter's canvas paints the real intro page over the same coordinates — perceptually the swap is invisible.

## Layout

Fixed, `inset: 0`, `z-index: 9999`. Column flex, centered content:
- `<h1 class="boot-hero">` — 2 lines: "Abdallah" / "Alhyari" (accent color on last name)
- `<p class="boot-role">` — "Senior Flutter & Android Engineer"
- `<div class="boot-indicator">` — 48×2 red bar, pulsing scale animation

Background: `radial-gradient(ellipse at 30% 25%, #14192a → #0B101D → #080C14)` — visually matches Flutter's dark obsidian bg.

## Typography

| Element | Font | Size | Weight | Notes |
|---|---|---|---|---|
| `.boot-hero` | `Tenada, -apple-system, ...` | `clamp(2.5rem, 9vw, 7.5rem)` | 900 | Fluid; caps at 120 px |
| `.boot-role` | `-apple-system, ...` | `clamp(0.75rem, 1.2vw, 0.95rem)` | 600 | Uppercase, 0.32 em tracking |

Tenada preloads via `<link rel="preload" as="font" ... crossorigin>`. If it fails to load the system stack takes over — no layout shift because both fonts are letter-similar.

## Design Tokens Used

Boot loader is HTML/CSS pre-Flutter; it cannot import Dart tokens. Values are hand-mirrored:

| Value | HTML | Dart equivalent |
|---|---|---|
| Accent red | `#E11D48` | `AppColors.accentRose` |
| Off-white text | `#F8FAFC` | `AppColors.slate50` |
| Muted subtitle | `#94A3B8` | `AppColors.slate400` |
| BG stops | `#14192a` / `#0B101D` / `#080C14` | `darkCanvasElevated` / `darkNight` / `slate950` |

**Warning**: these values are hard-coded. If Dart tokens change, this file must be updated by hand.

## Interactions

| Event | Behavior |
|---|---|
| DOMContentLoaded | Loader visible immediately (server ships it in the HTML) |
| `flutter-first-frame` event | JS handler adds `.hidden` class → 350 ms opacity fade |
| Safety timeout (8 s) | If `flutter-first-frame` never fires, loader dismisses anyway so a broken build doesn't leave a permanent overlay |

## States

| State | Visual |
|---|---|
| Booting | Full-viewport gradient bg, wordmark centered, pulsing red bar |
| Fading | `.hidden` class applied — `opacity: 0`, `pointer-events: none`, 350 ms transition |
| Dismissed | Element `.remove()`d 150 ms after fade starts |

## Related preloads (`<head>`)

Order matters — these hit the network in parallel with HTML parse:

```html
<link rel="preload" href="assets/fonts/Tenada.ttf" as="font" crossorigin>
<link rel="preload" href="main.dart.wasm" as="fetch" fetchpriority="high" crossorigin>
<link rel="modulepreload" href="main.dart.mjs" crossorigin>
<link rel="preload" href="assets/assets/my_image.webp" as="image" fetchpriority="high">
```

Plus per-build `.part.js` prefetches injected by `patch_flutter_js.js`.

## Perf

Baseline Lighthouse LCP was 1.0 s against a red bar. Adding this hero moved LCP to ~1.1 s against the actual name — larger element, same "good" bucket (< 2.5 s). Trade-off worth it because LCP now measures the thing users actually care about.

TBT dropped 37% independently (see perf PR #32).

## Accessibility

- `<h1>` renders the person's name — SEO + screen-reader win.
- Below the loader, a `<main class="sr-only" id="main-content">` holds the full semantic DOM (about / work / experience / contact). Screen readers walk that immediately without waiting on Flutter.
- Skip-to-content link (`.skip-link`) jumps keyboard users past the loader straight to the sr-only main.
- Print stylesheet hides the loader entirely and reveals the sr-only main styled for print.

## When to change this

- Hero copy update → both `<h1 class="boot-hero">` and `<main class="sr-only"> <h1>` must match.
- Brand color update → update the four hex values noted in the tokens table above.
- Font change → replace `Tenada` reference + preload URL; verify system font fallback still visually close.

## Do's and Don'ts

| ✅ Do | ❌ Don't |
|---|---|
| Keep loader dimensions roughly matching where Flutter's canvas will paint | Delay loader dismiss past `flutter-first-frame` — it looks like a bug |
| Use raw CSS animations only (no JS) so it works while Dart still boots | Import any Dart-side or theme dependency here — this ships before Dart runs |
| Reload after every hero-copy change and sanity-check on mobile Lighthouse | Increase the 8 s safety timeout without discussing — long stuck loader = broken build masked |
