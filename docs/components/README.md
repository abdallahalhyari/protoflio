# Component library

Living documentation for high-frequency portfolio widgets. Each file follows the same shape: purpose → variants → props → states → tokens → a11y → do/don't → example.

## Documented components

| Component | File | Kind |
|---|---|---|
| [PrimaryButton](primary_button.md) | Hero CTA with gradient + parallax + haptics | Action |
| [EditorialChip](editorial_chip.md) | Pill-shaped meta / status label | Data |
| [HolographicCardPhysics](holographic_physics.md) | 3D tilt wrapper for cards | Effect |
| [PageBackground](page_background.md) | Ambient stage — orbs + grid + vignette | Layout |
| [PulsingDot](pulsing_dot.md) | 14×14 status pip | Feedback |

## Tokens

See `lib/theme/tokens.dart` for:

- `AppSpacing` — 4pt scale (`xs`-`xxl`)
- `AppRadius` — tier + intent radius scale
- `AppMotion` — durations + M3 easing
- `AppColors` — brand seed, accents, slates, glows, hats, shadows
- `AppTypography` — Tenada display + 6 size steps + editorial micro-sizes

Prefer intent-named tokens (`AppMotion.cardHover`, `AppRadius.chip`) over numeric tiers when one fits — they encode design decisions and are easier to migrate.

## When to add a new component doc

1. Widget is used 3+ places
2. Widget has variants or states (not a leaf visual)
3. Consumers reach for `Container + BoxDecoration` clones — replace with a documented primitive

Adding one is cheap. Skipping the doc is why 40+ chip clones existed before `EditorialChip` landed.
