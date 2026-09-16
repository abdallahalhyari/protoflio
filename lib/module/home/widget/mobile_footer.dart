import 'package:flutter/material.dart';
import 'package:profile/l10n/app_localizations.dart';

import '../../../theme/surface_tone.dart';
import '../../../theme/tokens.dart';

/// Bottom-of-scroll wordmark + rights strip shown on the mobile
/// continuous scroll layout. Pure presentation — no controller or
/// state coupling.
class MobileFooter extends StatelessWidget {
  const MobileFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: context.divider)),
        color: context.isDarkMode
            ? AppColors.darkSurface.withValues(alpha: 0.6)
            : Colors.white.withValues(alpha: 0.7),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF38BDF8), AppColors.accentIndigo],
                  ),
                  borderRadius: BorderRadius.circular(AppRadius.chip),
                ),
                alignment: Alignment.center,
                child: const Text(
                  'A',
                  style: TextStyle(
                    fontFamily: AppTypography.displayFont,
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 15,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'ABDALLAH AL-HYARI',
                style: TextStyle(
                  color: context.onSurface,
                  fontWeight: FontWeight.w900,
                  fontSize: 12,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'SENIOR MOBILE ENGINEER · SYSTEM ARCHITECT',
            style: TextStyle(
              color: context.mutedText,
              fontSize: 9.5,
              fontWeight: FontWeight.w700,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            AppLocalizations.of(context)!.footerRightsReserved,
            style: TextStyle(
              color: context.subtleText,
              fontSize: 9,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
