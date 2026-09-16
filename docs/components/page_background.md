# PageBackground

Ambient stage for all portfolio pages. Renders base gradient + 3 parallax orb glows + optional decorative micro-dot grid + vignette. Automatically light/dark aware.

## Import

```dart
import 'package:profile/module/home/widget/page_background.dart';
```

## Props

| Property | Type | Default | Description |
|---|---|---|---|
| `child` | `Widget` | — | Foreground page content (required) |
| `overlay` | `Color?` | `null` | Optional scrim applied at composition time (unused by base; kept for consumer overlay) |

## Variants (auto)

| Variant | Trigger | Base | Orbs | Grid | Vignette |
|---|---|---|---|---|---|
| Dark | `context.isDarkMode == true` | Deep obsidian LinearGradient (`0xFF080C14`→`0xFF0B101D`) | Indigo/cyan/violet radials | Micro-dot painter (desktop only) | Radial vignette (desktop only) |
| Light | `context.isDarkMode == false` | Slate LinearGradient (`0xFFFAFBFC`→`slate200`) | Indigo/sky/amber radials | Micro-dot painter (desktop only) | none |

## Interactivity

`MouseRegion.onHover` reads cursor position, computes offset relative to viewport center, and drives parallax on the orb layer only:

- Offset skipped when `disableAnimationsOf(context)` is true
- Sub-motion gate: `distanceSquared < 36` rejects micro-jitter
- Orb layer wrapped in a single `Transform.translate` so only the composite transform layer updates, not the paint tree

## States

| State | Behavior |
|---|---|
| Idle | Base + 3 orbs at rest |
| Hovering | Orbs translate up to ±24 (dark) / ±20 (light) px based on cursor offset |
| Mouse exit | Snap back to `Offset.zero` (no animation — subtle) |
| Reduced motion | Parallax offset locked at `Offset.zero` |
| Mobile (`< AppBreakpoints.tablet`) | Micro-dot painter + vignette skipped to save fill-rate |

## Tokens Used

- **Colors**: `AppColors.accentIndigoDeep`, `slate100/200`, hardcoded gradient hexes (dark obsidian palette)
- **Breakpoints**: `AppBreakpoints.tablet`

## Accessibility

- Purely decorative — wrapped in `IgnorePointer` where necessary
- Foreground `child` receives all pointer + keyboard events
- No SR announcements

## Do's and Don'ts

| ✅ Do | ❌ Don't |
|---|---|
| Use once per Scaffold body | Nest — two `PageBackground`s composite orb glow on top of each other |
| Pair with `RepaintBoundary` around `child` | Set `overlay` for interactive scrim — apply overlay in the child instead |
| Rely on it as the sole backdrop | Add a solid-color `Container` behind it — gradient will be occluded |

## Example

```dart
PageBackground(
  overlay: AppColors.scrimMedium,
  child: HomeContent(),
)
```
