# PrimaryButton

Hero CTA: gradient fill, hover parallax, press haptics, optional loading spinner.

## Import

```dart
import 'package:profile/module/home/widget/primary_button.dart';
```

## Variants

| Variant | Use When |
|---|---|
| `PrimaryButtonVariant.primary` | Main call to action — "View my work", "Download resume" |
| `PrimaryButtonVariant.destructive` | Irreversible actions — uses `ColorScheme.error` |

## Sizes

| Size | fontSize | Horizontal padding | Vertical padding | Icon size |
|---|---|---|---|---|
| `sm` | 13 | 18 | 6 | 14 |
| `md` (default) | 16 | 28 | 8 | 16 |
| `lg` | 18 | 36 | 12 | 20 |

## Props

| Property | Type | Default | Description |
|---|---|---|---|
| `label` | `String` | — | Button text (required) |
| `onPressed` | `VoidCallback?` | — | `null` disables the button |
| `size` | `PrimaryButtonSize` | `md` | Preset spacing scale |
| `variant` | `PrimaryButtonVariant` | `primary` | Semantic intent |
| `loading` | `bool` | `false` | Renders spinner, blocks input |
| `icon` | `IconData?` | `null` | Leading icon |

## States

| State | Visual | Behavior |
|---|---|---|
| Default | Solid gradient (accent → shaded accent), soft glow shadow | — |
| Hover | Lighter gradient, brighter border, +5% scale, parallax on pointer, +18px shadow blur | Micro-scale animates over `AppMotion.xs` (150ms) |
| Pressed | Haptic light-impact fires | Tap forwards `onPressed` |
| Disabled | 35% base + 25% base gradient, cursor `forbidden` | Ignores hover/tap |
| Loading | Inline `CircularProgressIndicator`, `_enabled=false` | Ignores hover/tap |

## Tokens Used

- **Motion**: `AppMotion.xs` (hover scale)
- **Radius**: `AppRadius.sm`
- **Colors**: `Theme.of(context).colorScheme.{primary,error}` (via `_baseColor`)

## Accessibility

- Role: `button` (via `Semantics(button: true)`)
- Announces `label`
- `enabled` flag flips SR read
- Keyboard: standard tab focus + Enter/Space (inherited from `GestureDetector` — consider migrating to `TextButton` internally for full keyboard parity if this becomes a friction point)

## Do's and Don'ts

| ✅ Do | ❌ Don't |
|---|---|
| Pair `loading` with disabled `onPressed` when async | Use for secondary or ghost actions — pick `TextButton`/`OutlinedButton` |
| Set `size: lg` for hero CTAs | Chain 3+ primaries in a row — only one primary per region |
| Pass an icon for context ("Download resume" + `Icons.download_rounded`) | Nest inside a `RawGestureDetector` — will double-fire haptics |

## Example

```dart
PrimaryButton(
  label: 'View My Work',
  size: PrimaryButtonSize.lg,
  icon: Icons.arrow_forward_rounded,
  onPressed: () => controller.goTo(2),
)
```
