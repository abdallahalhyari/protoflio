import 'package:flutter/material.dart';

import 'package:profile/theme/tokens.dart';
import 'package:profile/features/hats/data/hats_data.dart';
import 'package:profile/features/hats/widget/hat_playing_card.dart';
import 'hat_bio_strip.dart';
import 'hat_pagination_row.dart';
import 'hat_role_pills.dart';

/// Single-column mobile view for continuous-scroll mobile mode, with gesture-based
/// swipe between cards and flip-card preview.
class ContinuousMobileHatColumn extends StatelessWidget {
  final int selectedHatIndex;
  final ValueChanged<int> onSelectRole;
  final VoidCallback onNextRole;
  final VoidCallback onPrevRole;
  final VoidCallback onCardTap;

  const ContinuousMobileHatColumn({
    super.key,
    required this.selectedHatIndex,
    required this.onSelectRole,
    required this.onNextRole,
    required this.onPrevRole,
    required this.onCardTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 2,
            color: theme.colorScheme.primary.withValues(alpha: 0.9),
          ),
          const SizedBox(height: 6),
          Text(
            'FEATURE 06 · 6 ROLES',
            style: TextStyle(
              color: theme.colorScheme.primary.withValues(alpha: 0.35),
              fontSize: AppTypography.editorial,
              fontWeight: FontWeight.w900,
              letterSpacing: 3,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'ARCHITECTURAL PERSPECTIVES',
            style: TextStyle(
              fontFamily: AppTypography.displayFont,
              color: isDark ? Colors.white : AppColors.slate900,
              fontSize: AppTypography.titleMid,
              fontWeight: FontWeight.w900,
              letterSpacing: 3,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          HatRolePills(
            selectedIndex: selectedHatIndex,
            isDesktop: false,
            onSelectRole: onSelectRole,
          ),
          const SizedBox(height: AppSpacing.md),
          const HatBioStrip(isMobile: true),
          const SizedBox(height: AppSpacing.md),
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onHorizontalDragEnd: (details) {
              if (details.primaryVelocity != null) {
                if (details.primaryVelocity! < -200) {
                  onNextRole();
                } else if (details.primaryVelocity! > 200) {
                  onPrevRole();
                }
              }
            },
            child: SizedBox(
              height: 380,
              child: Center(
                child: AnimatedSwitcher(
                  duration: AppMotion.switcher,
                  transitionBuilder: (child, animation) => FadeTransition(
                    opacity: animation,
                    child: ScaleTransition(
                      scale: Tween<double>(begin: 0.96, end: 1.0)
                          .animate(animation),
                      child: child,
                    ),
                  ),
                  child: HatPlayingCard(
                    key: ValueKey('mobile_hat_card_$selectedHatIndex'),
                    hat: kHats[selectedHatIndex],
                    index: selectedHatIndex,
                    position: Offset.zero,
                    isStandalone: true,
                    onCardTap: onCardTap,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          HatPaginationRow(
            selectedIndex: selectedHatIndex,
            totalCount: kHats.length,
            onPrev: onPrevRole,
            onNext: onNextRole,
          ),
          const SizedBox(height: 6),
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.04)
                    : Colors.white.withValues(alpha: 0.85),
                borderRadius: BorderRadius.circular(AppRadius.chip),
                border: Border.all(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.08)
                        : AppColors.slate200),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.touch_app_outlined,
                      size: 12, color: theme.colorScheme.primary),
                  const SizedBox(width: 5),
                  Flexible(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        'TAP CARD TO FLIP · SWIPE TO CHANGE ROLE',
                        style: TextStyle(
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.72)
                              : AppColors.slate500,
                          fontSize: AppTypography.editorialSm,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
