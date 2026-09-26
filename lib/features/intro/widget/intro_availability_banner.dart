import 'package:flutter/material.dart';
import 'package:profile/theme/surface_tone.dart';
import 'package:profile/l10n/app_localizations.dart';

import 'package:profile/theme/tokens.dart';
import 'package:profile/shared/widget/breathing_pulse.dart';

class IntroAvailabilityBanner extends StatelessWidget {
  final bool isDark;
  final bool isWide;

  const IntroAvailabilityBanner({
    super.key,
    required this.isDark,
    required this.isWide,
  });

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).colorScheme.primary;
    final loc = AppLocalizations.of(context)!;

    return Center(
      child: BreathingPulse(
        child: Container(
          // A status tag, not an action: compact and borderless so it no
          // longer reads as a fifth button next to the CTAs.
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isDark
                ? accent.withValues(alpha: 0.12)
                : accent.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.flight_takeoff_outlined, color: accent, size: 14),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  loc.introEuEligibility,
                  style: TextStyle(
                    color: context.onSurface,
                    fontSize: isWide ? 11 : 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
