# EditorialChip

Pill-shaped meta chip. Status pills, kicker badges, tag chips, meta labels.

Consolidates ~40 hand-rolled `Container(padding, decoration, Row(icon, text))` clones.

## Import

```dart
import 'package:profile/module/home/widget/editorial_chip.dart';
```

## Tones (semantic color slots)

| Tone | Dark mode | Light mode |
|---|---|---|
| `primary` | `scheme.primary` | `scheme.primary` |
| `amber` | `accentAmber` | `accentAmberDeep` |
| `green` | `accentGreen` | `accentGreenDeep` |
| `sky` | `accentSky` | `accentSkyDeep` |
| `indigo` | `accentIndigo` | `accentIndigoDeepText` |
| `neutral` | `onSurface × 0.7` | `slate700` |

## Variants

| Variant | Fill | Border | Foreground |
|---|---|---|---|
| `filled` (default) | tint × 0.18/0.14 | tint × 0.5/0.4 | tint |
| `outline` | transparent | tint × 0.6/0.5 | tint |
| `glass` | white × 0.05/0.85 | white × 0.12 / slate200 | white / slate900 |

## Props

| Property | Type | Default | Description |
|---|---|---|---|
| `label` | `String` | — | Chip text (required) |
| `icon` | `IconData?` | `null` | Leading icon |
| `trailing` | `Widget?` | `null` | Trailing slot (e.g. count badge) |
| `tone` | `ChipTone` | `primary` | Semantic color |
| `variant` | `ChipVariant` | `filled` | Fill treatment |
| `dense` | `bool` | `false` | Tighter padding + editorialSm font |
| `onTap` | `VoidCallback?` | `null` | Makes chip tappable via `InkWell` |

## States

| State | Visual | Behavior |
|---|---|---|
| Default | Fill + border per tone/variant | — |
| Pressed | Ripple (only when `onTap != null`) | Forwards `onTap` |

No hover/disabled states — chip is decorative unless `onTap` is set.

## Tokens Used

- **Typography**: `AppTypography.editorial` / `editorialSm`
- **Radius**: `AppRadius.pill`
- **Colors**: theme scheme + `AppColors.accent*` + `AppColors.slate*`

## Accessibility

- Text uses `overflow: TextOverflow.ellipsis` — safe when label exceeds parent width
- Tappable variant surfaced through `Material + InkWell` — inherits SR button role and focus ring
- Non-tappable chip = decorative; consumers should not rely on it for interactive semantics

## Do's and Don'ts

| ✅ Do | ❌ Don't |
|---|---|
| Use for < 3 words of status metadata | Wrap multi-line text — will still fit, but chip pill breaks the eye |
| Match `tone` to page accent — reads as "editorial callout" | Nest another `EditorialChip` inside `trailing` |
| Use `dense: true` in meta rows | Set `onTap` for navigation — prefer `PrimaryButton` |

## Example

```dart
EditorialChip(
  label: 'ONLINE',
  icon: Icons.circle_rounded,
  tone: ChipTone.green,
  variant: ChipVariant.glass,
  dense: true,
)
```
