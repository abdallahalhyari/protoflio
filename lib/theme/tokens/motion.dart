import 'package:flutter/material.dart';

/// Motion scale — named durations + easing. Mixes numeric tiers
/// (`micro`, `xs`, `sm`, ...) with intent-named durations (`cardHover`,
/// `heroEntry`, ...). **Prefer intent tokens** — they express *why*, not
/// *how long*, and let global timing tune without hunting call sites.
class AppMotion {
  AppMotion._();

  // Numeric scale — Material-style tiers.
  static const Duration micro = Duration(milliseconds: 100);
  static const Duration xs = Duration(milliseconds: 150);
  static const Duration sm = Duration(milliseconds: 250);
  static const Duration md = Duration(milliseconds: 350);
  static const Duration lg = Duration(milliseconds: 500);
  static const Duration xl = Duration(milliseconds: 700);

  // Intent-named durations — use these where the numeric scale doesn't
  // fit an established interaction beat. Values chosen from the ad-hoc
  // Duration literals that used to live across pages.
  static const Duration chipHover =
      Duration(milliseconds: 180); // filter / tab hover
  static const Duration snap =
      Duration(milliseconds: 200); // page pill / snap-to
  static const Duration cardHover =
      Duration(milliseconds: 300); // card lift / border pulse
  static const Duration switcher =
      Duration(milliseconds: 280); // AnimatedSwitcher content
  static const Duration heroEntry =
      Duration(milliseconds: 260); // intro wordmark
  static const Duration pageTurn =
      Duration(milliseconds: 380); // desktop wheel page jump
  static const Duration cardFlip =
      Duration(milliseconds: 400); // skill / hat card flip
  static const Duration sectionScroll =
      Duration(milliseconds: 600); // mobile section jump
  static const Duration entry =
      Duration(milliseconds: 800); // page-entry stagger
  static const Duration ambient =
      Duration(milliseconds: 1400); // long-loop hint bounces
  static const Duration pulse =
      Duration(milliseconds: 1500); // presence dot breath
  static const Duration wheelResetGap =
      Duration(milliseconds: 220); // wheel accumulator reset
  static const Duration toast =
      Duration(milliseconds: 2600); // floating snack lifetime
  static const Duration tooltipWait =
      Duration(milliseconds: 300); // standard tooltip delay

  // Material 3 emphasized easing — snappier at the top, decelerates
  // gently. Use for state changes the user drove (tap, hover), so the
  // motion feels responsive without whip-crack.
  static const Cubic emphasized = Cubic(0.2, 0.0, 0.0, 1.0);
  static const Cubic emphasizedAccel = Cubic(0.3, 0.0, 0.8, 0.15);
  static const Cubic emphasizedDecel = Cubic(0.05, 0.7, 0.1, 1.0);
  // Standard Material curve — for continuous transitions where the user
  // isn't the trigger (auto-advance, section snap).
  static const Cubic standard = Cubic(0.2, 0.0, 0.0, 1.0);
  // Overshoot spring — for pill-drop / card-catch beats that want a
  // gentle bounce past the target.
  static const Cubic spring = Cubic(0.34, 1.56, 0.64, 1.0);

  // Standard and specialized easing curves.
  static const Curve easeOut = Curves.easeOut;
  static const Curve easeOutCubic = Curves.easeOutCubic;
  static const Curve easeInOutCubic = Curves.easeInOutCubic;
  static const Curve easeOutBack = Curves.easeOutBack;
  static const Curve easeInOutBack = Curves.easeInOutBack;
  static const Curve easeInOutSine = Curves.easeInOutSine;
}
