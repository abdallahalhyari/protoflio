# Handoff: Atomic Components — `PrimaryButton`, `EditorialChip`, `PulsingDot`

Full engineering handoff for the three most-reused leaf components. Complements the shorter user-facing docs in `docs/components/` — this file specifies edge cases, motion parameters, accessibility semantics, and a11y expectations that consumers should not have to rediscover.

---

## `PrimaryButton`

Hero CTA — gradient fill, hover parallax, press haptics, optional inline spinner.

### Layout

| Size | fontSize | Horizontal padding | Vertical padding | Icon size |
|---|---|---|---|---|
| `sm` | `AppTypography.small` (13) | 18 | `xs+2` (6) | 14 |
| `md` (default) | `AppTypography.subtitle` (16) | 28 | `AppSpacing.sm` (8) | `AppSpacing.md` (16) |
| `lg` | `AppTypography.subtitle+2` (18) | 36 | `AppSpacing.smd` (12) | 20 |

Corner radius: `AppRadius.sm` (8). Icon gap: `AppSpacing.sm` (8).

### Props

| Property | Type | Default | Notes |
|---|---|---|---|
| `label` | String | required | |
| `onPressed` | `VoidCallback?` | required | `null` disables |
| `size` | `PrimaryButtonSize` | `md` | `sm`/`md`/`lg` |
| `variant` | `PrimaryButtonVariant` | `primary` | `primary`/`destructive` |
| `loading` | bool | false | Renders spinner, blocks tap |
| `icon` | `IconData?` | null | Leading |

### States

| State | Visual | Motion |
|---|---|---|
| Default | Solid gradient (accent → shaded accent), soft glow shadow | — |
| Hover (enabled only) | Lighter gradient, brighter 1.5 px border, +5% scale, cursor parallax up to `(delta.dx × 0.15, delta.dy × 0.25)` | `AppMotion.xs` (150 ms) `easeOut` for scale; parallax updates as pointer moves |
| Pressed | Fires `HapticFeedback.lightImpact()` synchronously with `onPressed` | — |
| Disabled | Base color at 35% / 25% alpha stops, cursor `forbidden`, all hover skipped | — |
| Loading | 2 px `CircularProgressIndicator` (white) prepended, `_enabled=false` guard | — |

### Edge cases

- Sub-pixel parallax jitter gated at `distanceSquared < 2` — high-poll mice don't churn setState.
- `_key` `GlobalKey` used to measure box for parallax; skipped if `null` before first frame.
- Reduced motion suppresses parallax entirely (`disableAnimationsOf`).

### Accessibility

- `Semantics(button: true, enabled: _enabled, label: label)` wraps the whole thing — SR reads "button, [label]"; disabled state announced.
- Focus: implicit via `GestureDetector` — not full Focus support. Follow-up: swap for `InkWell` inside `Material` if keyboard-first users report friction.
- Haptic on tap fires only on real platforms; web fallback is silent (Flutter engine).

---

## `EditorialChip`

Pill-shaped meta / status / tag label. Consolidated ~40 hand-rolled `Container(padding, decoration, Row)` clones.

### Layout

| dense | Horizontal padding | Vertical padding | fontSize |
|---|---|---|---|
| `false` (default) | 10 | 5 | `AppTypography.editorial` (10.5) |
| `true` | 8 | 3 | `AppTypography.editorialSm` (9.5) |

Corner radius: `AppRadius.pill` (999 → capsule). Border: 1 px. Icon gap: 6 px. Trailing gap: 6 px.

### Tones

Auto-adapts light/dark:

| Tone | Dark | Light |
|---|---|---|
| `primary` | `scheme.primary` | `scheme.primary` |
| `amber` | `accentAmber` | `accentAmberDeep` |
| `green` | `accentGreen` | `accentGreenDeep` |
| `sky` | `accentSky` | `accentSkyDeep` |
| `indigo` | `accentIndigo` | `accentIndigoDeepText` |
| `neutral` | `onSurface × 0.7` | `slate700` |

### Variants

| Variant | Fill | Border | Foreground |
|---|---|---|---|
| `filled` (default) | tone × 0.18 (dark) / 0.14 (light) | tone × 0.5 / 0.4 | tone |
| `outline` | transparent | tone × 0.6 / 0.5 | tone |
| `glass` | `Colors.white × 0.05 (dark) / 0.85 (light)` | white × 0.12 / `slate200` | white / `slate900` |

### States

Only `pressed` when `onTap != null` — ripple via `Material + InkWell` with `pill` radius. No hover / disabled variants — chip is decorative unless tappable.

### Edge cases

- `label` overflows via `TextOverflow.ellipsis`; caller must give the chip a bounded width via `Wrap` or fixed parent.
- Icon size derived as `fontSize + 2` — no independent knob.
- `trailing` widget occupies the last slot; layout does not shrink it if crowded — caller controls the width.

### Accessibility

- Non-tappable chip has no `Semantics` wrapper — text alone reaches SR.
- Tappable chip inherits `Material + InkWell` button role.
- `letterSpacing: 1.2` improves readability at 9.5-10.5 pt.

---

## `PulsingDot`

14×14 status pip. Static center dot + animated halo. Used for "online / active / live" pips.

### Layout

Fixed 14×14 outer, 6×6 inner static dot, halo scales `8 + 6·t` (px) where `t ∈ [0, 1]`. Halo alpha `0.35 · (1 - t)`.

### Props

| Property | Type | Notes |
|---|---|---|
| `color` | `Color` | Required; drives both center + halo tint |

### Animation

- Controller duration: `AppMotion.pulse` (1500 ms), `repeat(reverse: true)` — 3-second full cycle (fill/fade).
- Curve: none applied — linear `t` from controller.
- Gated on `MediaQuery.disableAnimationsOf(context)` inside `didChangeDependencies`; static frozen halo if reduce-motion.
- `AnimatedBuilder(child: staticDot)` caches the center — only the halo `Container` rebuilds per frame.
- `RepaintBoundary` isolates from ancestor scroll repaints.
- `ExcludeSemantics` — SR does not announce decoration.

### States

| State | Behavior |
|---|---|
| Default | Loops the breath |
| Reduced motion | Frozen halo at `t = 0` |
| Off-screen (scrolled past) | Continues ticking cheaply; if needed, wrap parent in `TickerMode(enabled: false)` |

### Edge cases

- Widget size fixed at 14 × 14; do NOT wrap in `SizedBox` smaller — halo will clip.
- Only one animation controller per instance — if you have 20+ dots on a page they all tick independently. Cheap in practice (~ 20 μs each per frame), but consider a shared ticker if scaling up.

### Accessibility

- Announced as decorative (via `ExcludeSemantics`). Callers MUST pair the dot with a sibling `Text` label for meaning, or wrap the pair with `Semantics(label: 'status: online')`.
- Reduce-motion respected.

---

## Cross-cutting

### Design Tokens Used

| Component | Tokens |
|---|---|
| `PrimaryButton` | `AppTypography.small/subtitle`, `AppSpacing.xs/sm/smd/md`, `AppRadius.sm`, `AppMotion.xs`, `scheme.primary/error` |
| `EditorialChip` | `AppTypography.editorial/editorialSm`, `AppRadius.pill`, `AppColors.accent*` (via `ChipTone`), `slate*` |
| `PulsingDot` | `AppMotion.pulse` |

### Reduce-motion posture

All three respect `MediaQuery.disableAnimationsOf`:
- Button: parallax suppressed, scale still animates
- Chip: no motion to suppress
- Dot: halo frozen

### Testing

Existing tests: `test/primary_button_test.dart` (loading, size variants, icon rendering, destructive), `test/skills_widgets_test.dart` (chip filter interaction, empty state).

Add tests when you extend variants — Chip's tone × variant matrix is 6 × 3 = 18 combinations. Focus new tests on newly added ones only.
