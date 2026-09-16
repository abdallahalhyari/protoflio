# HolographicCardPhysics

3D tilt wrapper. Maps cursor position over the child to Y/X rotation + optional specular glare.

Used to wrap `BentoSkillTile`, project cards, and any surface where hover-driven parallax reinforces a "premium" feel.

## Import

```dart
import 'package:profile/module/home/widget/holographic_physics.dart';
```

## Props

| Property | Type | Default | Description |
|---|---|---|---|
| `child` | `Widget` | — | Wrapped subtree (required) |
| `borderRadius` | `double` | `AppRadius.card` | Radius for the glare mask |
| `maxTiltAngle` | `double` | `0.15` (~8.5°) | Max rotation per axis in radians |
| `enableGlare` | `bool` | `true` | Toggle the additive `RadialGradient` glare pass |

## Behavior

Tilt is computed via `MouseRegion.onHover`:
- `nx = 2 * (px / size.w - 0.5)` → pitch (`rotateX = -ny × maxTiltAngle`)
- `ny = 2 * (py / size.h - 0.5)` → yaw (`rotateY = nx × maxTiltAngle`)

Cursor exit animates back to `Offset.zero` over `AppMotion.sm` (250 ms) via `emphasizedDecel` curve.

Glare renders as an additive `RadialGradient` centered on the cursor, fading from `white × 0.15` to transparent.

## States

| State | Visual | Behavior |
|---|---|---|
| Rest | Child at 0° / 0° | Glare hidden |
| Hovering | Live tilt tracks cursor | Glare fades in over `AppMotion.sm` |
| Exit | Reset animation | Glare fades out |
| `disableAnimations` (MediaQuery) | Wrapper is a no-op — returns `widget.child` directly | Zero tilt, zero glare |

## Performance

- `ValueNotifier<Offset>` isolates tilt updates to the transform layer — no full-tree rebuild per pointer move
- `distanceSquared < 0.0004` gate rejects sub-pixel deltas, cutting notifier fires ~5× on high-poll mice
- `RepaintBoundary` wraps the transformed subtree so ancestors aren't repainted on tilt
- Skipped entirely under reduced-motion

## Tokens Used

- **Motion**: `AppMotion.sm`, curve `AppMotion.emphasizedDecel` (implicit via `CurvedAnimation`)
- **Radius**: consumer passes; default `AppRadius.card`
- **Colors**: pure whites for glare — no theme dependency

## Accessibility

- `MediaQuery.disableAnimationsOf(context)` fully disables tilt + glare
- No focus/keyboard interactions — hover-only. Do not use for anything users need to activate via keyboard.
- Screen reader passes through — `HolographicCardPhysics` adds no semantics.

## Do's and Don'ts

| ✅ Do | ❌ Don't |
|---|---|
| Wrap card-sized surfaces (min ~200×120) | Wrap a small `EditorialChip` — tilt gets awkward at low pixel counts |
| Set `enableGlare: false` on dense grids (perf) | Nest inside another `HolographicCardPhysics` — two tilts compose weirdly |
| Combine with `RepaintBoundary` above | Wrap a full page — mouse-move tilt on a big rect drops frames |

## Example

```dart
HolographicCardPhysics(
  borderRadius: AppRadius.card,
  maxTiltAngle: 0.10,
  child: BentoSkillTile(skill: skill, categoryColor: color, ...),
)
```
