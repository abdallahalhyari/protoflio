# Engineering handoff specs

Deep engineering handoffs — deeper than the user-facing `docs/components/` docs, tighter than the codebase itself. Written so a new hire (or future-you) can reproduce, extend, or safely delete these patterns.

## Index

| Spec | Covers |
|---|---|
| [case_study_pattern.md](case_study_pattern.md) | Full-screen case-study page pattern (NatHealth + 3 siblings) |
| [accent_theme.md](accent_theme.md) | `_AccentTheme` — how per-section color changes without full app rebuild |
| [boot_loader.md](boot_loader.md) | HTML hero skeleton + early LCP strategy |
| [atomic_components.md](atomic_components.md) | `PrimaryButton` + `EditorialChip` + `PulsingDot` edge cases |

## When to add one

A new spec pays for itself when:
- The pattern is non-obvious enough that reading the code lies to you (e.g. `_AccentTheme` looks simple, but the reason it exists is subtle)
- The pattern is reused 3+ places
- Getting it wrong ships a visible regression (LCP, rebuild storms, semantic drift)

Skip specs for one-off widgets or thin wrappers — the code is the doc there.
