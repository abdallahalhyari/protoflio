# Handoff: Case-Study Page Pattern

Full-screen scrollable deep-dive on a single portfolio project. First shipped for NatHealth (`#35`); reused for ESKADENIA, Solutions Now, FAIS.

## Overview

Each case-study reads like an engineering blog post: problem → role → architecture → 1-3 numbered technical chapters → outcomes → lessons → CTA. Replaces the modal for projects that deserve depth; unwired projects still fall through to the modal.

## Layout

| Breakpoint | Horizontal padding | Notes |
|---|---|---|
| Desktop (`≥ AppBreakpoints.tablet`) | 96 px | Two-column masthead if hero image is set |
| Mobile | `AppSpacing.lg` (24 px) | Single column, outcome grid drops to 2 columns |

Root is `Scaffold(body: PageBackground(child: CustomScrollView))`. Sticky `SliverAppBar` with back arrow + kicker.

## Design Tokens Used

| Token | Where |
|---|---|
| `AppTypography.displayFont` (Tenada) | Section numbers, headline, outcome metric |
| `AppTypography.subtitle` | Body-of-chapter titles, hero subtitle |
| `AppTypography.body`, `body + 1` | Prose |
| `AppTypography.overline`, `editorial` | Kickers, layer labels |
| `AppSpacing.md`, `lg`, `xl`, `xxl` | Vertical rhythm |
| `AppRadius.card`, `sm`, `xxs` | Step cards, chip radii, bullet dots |
| `AppMotion.emphasizedDecel` | Page-push transition |
| `AppMotion.md`, `sm` | Transition durations |
| `scheme.primary` | Accent — auto-lerps via `_AccentTheme` when user navigates back |

## Components

| Component | Variant | Notes |
|---|---|---|
| `SectionKicker` | numeric + label | Fixed height, right-side hairline rule |
| `Prose` | one variant | `body + 1`, `height: 1.65` |
| `BulletList` | primary-dotted | 6×6 rounded square marker, `AppSpacing.smd` gutter |
| `TechnicalChapter` | ordered step group | Wraps `TechStepCard`s under a `SectionKicker` |
| `TechStepCard` | 1 variant | 36×36 primary-tinted number tile, layer label + title + body |
| `OutcomeGrid` | 2/4 cols | Auto-cols on breakpoint, `childAspectRatio 1.3 / 1.15` |
| `OutcomeCard` | headline + body | Display-font metric, small-body caption |
| `EditorialChip` | tone-varied | Stack of 5-7 in masthead |
| `PulsingDot` | color-passed | Adjacent to masthead role kicker |
| `NfcArchitectureDiagram` (NatHealth only) | — | Reused from projects page |

## States and Interactions

| Element | State | Behavior |
|---|---|---|
| Back button | idle → hover | Standard `IconButton` inkwell |
| Back button | tap | `Navigator.maybePop()` + `Analytics.event('case_study_back')` |
| CTA button | idle → hover | `PrimaryButton` gradient lightens, +5% scale, parallax on cursor |
| CTA button | tap | Pop route + `Analytics.event('case_study_cta')` |
| Page | enter | Fade transition, `AppMotion.md` (350 ms), curve `emphasizedDecel` |
| Page | exit | Fade, `AppMotion.sm` (250 ms) |
| Accent color | on back-to-home | Section accent lerps back to home's indigo via `_AccentTheme` |

## Responsive Behavior

| Breakpoint | Changes |
|---|---|
| Desktop | 96 px side gutters; outcome grid 4-across; masthead headline 60 pt display |
| Mobile | 24 px gutters; outcome grid 2-across; masthead headline 40 pt display |

Prose lines wrap freely — no explicit max-character; body font stays constant across breakpoints so line-length varies with viewport.

## Edge Cases

- **Long project name in masthead**: Flutter Text wraps automatically; no truncation. Verified on the FAIS 5-word title.
- **Missing hero image**: masthead has no image slot in current pattern; if added, fall back to `PageBackground` orbs.
- **Deep-linking**: not implemented — `#work/nathealth` hash is not deep-linked yet. Back button relies on `Navigator.maybePop`. Follow-up.
- **Reload while on case study**: currently returns user to `/#work` (Projects section). Fix pending URL routing.
- **Reduced motion**: page-push fade still fires (chose visual continuity over pure snap); step-card animations don't exist. Verified with `MediaQuery.disableAnimationsOf`.

## Animation / Motion

| Element | Trigger | Animation | Duration | Easing |
|---|---|---|---|---|
| Page route | push | Fade in | 350 ms | `emphasizedDecel` |
| Page route | pop | Fade out | 250 ms | linear default |
| Accent recovery | route pop | Theme.primary lerp back to base seed | 260 ms | `AppMotion.standard` |

## Accessibility

- **Focus order**: back button → masthead → each section in DOM order → CTA.
- **Semantics**: `IconButton(tooltip: 'Back to portfolio')`; `EditorialChip` inherits label semantics from `Text`.
- **Keyboard**: standard route pop via Esc handled by Flutter's `Navigator` default.
- **Screen reader**: reads the semantic DOM top-down. `SectionKicker` reads as "01 THE PROBLEM" — clear enough. No live-region announcements needed (static content).
- **Text scaling**: all `fontSize:` values are unclamped; large-font accessibility settings scale automatically.

## Adding a new case study

1. Create `lib/module/case_study/case_study_<name>.dart` — mirror `case_study_solutions.dart` (simplest of the four).
2. Import shared widgets from `case_study/case_study_widgets.dart`.
3. Build sections: masthead → `SectionKicker`s → `TechnicalChapter`s → `OutcomeGrid` → CTA.
4. Wire in `lib/module/home/page/project_modal.dart` `showProjectCaseStudy`:
   ```dart
   if (project.company == 'YourCompany') {
     await Navigator.of(context, rootNavigator: true).push(
       PageRouteBuilder(
         transitionDuration: AppMotion.md,
         pageBuilder: (_, __, ___) => const YourCaseStudy(),
         transitionsBuilder: (_, a, __, c) => FadeTransition(
           opacity: CurvedAnimation(parent: a, curve: AppMotion.emphasizedDecel),
           child: c,
         ),
       ),
     );
     return;
   }
   ```
5. Fire `Analytics.event('case_study_back')` / `case_study_cta` in matching handlers.
