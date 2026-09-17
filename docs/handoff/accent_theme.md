# Handoff: `_AccentTheme` Section Accent System

Portfolio has a per-section accent color that shifts smoothly as the user navigates between sections. This spec captures the non-obvious perf pattern behind it so future changes don't reintroduce the "whole app refreshes" bug.

## Overview

Six of the seven portfolio sections have a designated accent color (Experience → green, Work → violet, Stack → amber, …). When the user navigates, the color of every widget reading `Theme.of(context).colorScheme.primary` shifts to match — but the swap does **not** re-run `MaterialApp.build`, does **not** reallocate `ThemeData`, and does **not** trigger a full inherited-widget invalidation cascade.

## Why not put the seed inside `MaterialApp.theme`

Because it does re-run `MaterialApp.build` on every seed change, which cascades into every widget reading `Theme.of(context)`. Empirically the user perceived this as a full-screen refresh flash on section navigation.

## The pattern (`lib/main.dart:_AccentTheme`)

```
MaterialApp                             ← rebuilds ONLY on locale/mode change
  theme: AppTheme.light()               ← static base
  darkTheme: AppTheme.dark()
  home: const _AccentTheme(             ← rebuilds ONLY on seed change
    child: HomeScreen(),                    (scoped to this subtree)
  )
```

`_AccentTheme` is a `ValueListenableBuilder<Color>` wrapping an `AnimatedTheme`. On seed change:

1. Builder rebuilds — cheap, wraps a single subtree.
2. Derives a new `ColorScheme` from the base, overriding `primary`, `onPrimary`, `secondary` (+24° hue shift), `tertiary` (−24° hue shift), and `surfaceTint`.
3. `AnimatedTheme` lerps the whole scheme over `AppMotion.heroEntry` (260 ms) with `AppMotion.standard` curve.
4. Descendants reading `Theme.of(context).colorScheme.primary` (etc.) receive interpolated values frame-by-frame.

## Design Tokens Used

| Token | Where |
|---|---|
| `AppMotion.heroEntry` (260 ms) | Cross-section lerp duration |
| `AppMotion.standard` | Cross-section lerp curve |
| `Duration.zero` | Substituted for `heroEntry` under reduced motion |
| `ThemeController.seedColor` | The single source of truth — `ValueNotifier<Color>` |
| `AppColors.seed` | Fallback / home-section accent |

## Related scheme slots

The seed override propagates to more than `primary`:

| Slot | How |
|---|---|
| `primary` | direct seed |
| `onPrimary` | white on dark, base scheme on light |
| `secondary` | `seed` shifted +24° HSL hue |
| `tertiary` | `seed` shifted −24° HSL hue |
| `onSecondary` / `onTertiary` | same as `onPrimary` |
| `surfaceTint` | `seed` (drives M3 tonal elevation tints) |

## States

| State | Behavior |
|---|---|
| Normal | Lerps `primary` + siblings smoothly over 260 ms |
| Reduced motion | `Duration.zero` — snaps instantly |
| Repeat set of same value | `ValueNotifier` dedupes; no rebuild |
| Route push (case study) | Same accent inherits; on pop, accent lerps back if the outer section changed while pushed |

## Trigger points

`ThemeController.seedColor.value` is written from:
- `HomeScreen._scheduleSettle` — 250 ms after a page turn settles (URL hash sync)
- `ThemeController.updateSeedFromHash` — on initial load if URL has a hash, and via the URL sync listener when the user hits Back
- Manual test toggles via `?theme=` query param

## Do's and Don'ts

| ✅ Do | ❌ Don't |
|---|---|
| Read `Theme.of(context).colorScheme.primary` at leaves — it stays live | Read `AppColors.seed` for section-accent — that's static |
| Trust `AnimatedTheme` to lerp; don't manually animate primary | Wrap MaterialApp's `theme` prop in a `ValueListenableBuilder` — that's the exact bug we fixed |
| Add new sections by extending `updateSeedFromHash` | Fire `seedColor.value = X` from a scroll listener — throttle at the settle boundary instead |

## Perf notes

- Rebuild scope: `_AccentTheme.build` runs, its `ValueListenableBuilder` closure allocates one `ColorScheme` + one `ThemeData` per seed change. Under `AnimatedTheme`, this is amortized across 16-17 frames of the 260 ms lerp.
- `HSLColor.fromColor(c)` + `.toColor()` are called twice per rebuild — cheap, ~µs.
- If profiling shows churn, cache the derived scheme in a `Map<Color, ColorScheme>` keyed by seed. Only worth doing if section-switch becomes a jank source.

## Accessibility

- Reduced-motion path fully bypasses the tween — verified in `flutter analyze` and by unit test coverage in `test/theme_audit_test.dart`.
- Focus rings inherit the live `scheme.primary`, so they always match the current section — no separate focus-ring color to maintain.
