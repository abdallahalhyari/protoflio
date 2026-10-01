import 'package:flutter/material.dart';
import 'package:profile/service/sound_service.dart';
import 'package:profile/theme/surface_tone.dart';
import 'package:profile/theme/tokens.dart';
import 'package:profile/l10n/app_localizations.dart';

class SheetHeader extends StatelessWidget {
  const SheetHeader({super.key, required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '// DIRECTORY',
                style: TextStyle(
                  color: AppColors.accentIndigo,
                  fontSize: AppTypography.caption,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2.0,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                AppLocalizations.of(context)!.uiPortfolioSections,
                style: TextStyle(
                  fontFamily: AppTypography.displayFont,
                  color: context.onSurface,
                  fontSize: AppTypography.subtitle,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
          InkWell(
            onTap: () {
              SoundService.instance.playClick();
              Navigator.of(context).pop();
            },
            borderRadius: BorderRadius.circular(AppRadius.sm),
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.08)
                    : AppColors.slate100,
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: Icon(
                Icons.close_rounded,
                size: 18,
                color: isDark ? Colors.white70 : AppColors.slate900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
