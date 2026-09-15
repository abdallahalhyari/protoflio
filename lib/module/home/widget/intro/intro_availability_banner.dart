import 'package:flutter/material.dart';
import 'package:profile/l10n/app_localizations.dart';

import '../../../../theme/tokens.dart';
import '../breathing_pulse.dart';

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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: isDark
                ? accent.withValues(alpha: 0.1)
                : accent.withValues(alpha: 0.05),
            border: Border.all(color: accent.withValues(alpha: 0.3)),
            borderRadius: BorderRadius.circular(AppRadius.pill),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.flight_takeoff_outlined, color: accent, size: 18),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  loc.introEuEligibility,
                  style: TextStyle(
                    color: isDark ? Colors.white : AppColors.slate900,
                    fontSize: isWide ? 13 : 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
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
