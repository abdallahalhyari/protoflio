# PulsingDot

14×14 badge — solid inner dot with expanding-then-fading halo. Used as "online / active / live" status pip.

## Import

```dart
import 'package:profile/module/home/widget/pulsing_dot.dart';
```

## Props

| Property | Type | Default | Description |
|---|---|---|---|
| `color` | `Color` | — | Dot + halo tint (required) |

Everything else fixed. Widget is intentionally opinionated to keep pips visually consistent across the app.

## Animation

Runs on an `AnimationController` cycling `AppMotion.pulse` (1500 ms) via `repeat(reverse: true)` — a slow breath, not a strobe.

Per-frame layer (only the halo repaints; static dot is cached via `AnimatedBuilder.child`):
- Halo diameter: `8 + 6·t` px
- Halo alpha: `0.35 · (1 - t)`
- Inner dot: solid 6×6 circle

`AnimationController.repeat` is gated on `MediaQuery.disableAnimationsOf(context)` — reduced-motion users see a static ring.

## States

| State | Behavior |
|---|---|
| Default | Breathing halo, static center |
| `disableAnimations` | Static frozen halo |
| Off-screen | Continues ticking — pip is cheap (2 `Container`s in a `Stack`). Wrap parent in `TickerMode(enabled: false)` if you need to pause. |

## Tokens Used

- **Motion**: `AppMotion.pulse`

## Performance

- `RepaintBoundary` isolates repaints from ancestor scroll
- `ExcludeSemantics` — SR does not announce decoration
- `AnimatedBuilder.child` caches the static inner dot; only the halo rebuilds

## Accessibility

- Announced as decorative — wrap it (or its parent) with `Semantics(label: 'status: online')` at the caller if the state matters to SR users
- Reduced-motion respected

## Do's and Don'ts

| ✅ Do | ❌ Don't |
|---|---|
| Pair with a sibling `Text('ONLINE')` when meaning matters | Rely on it alone for status — SR-only users won't hear it |
| Size fixed at 14 — do not stretch | Wrap in a `SizedBox` smaller than 14 — halo will clip |
| Reuse the same color across a page for consistency | Use as a loading indicator — pick `CircularProgressIndicator` |

## Example

```dart
Row(children: [
  PulsingDot(color: AppColors.accentGreen),
  const SizedBox(width: 6),
  Text('AVAILABLE', style: TextStyle(fontSize: AppTypography.editorial, letterSpacing: 1.2)),
])
```
