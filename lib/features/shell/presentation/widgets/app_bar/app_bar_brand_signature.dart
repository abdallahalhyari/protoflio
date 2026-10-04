import 'package:flutter/material.dart';
import 'package:profile/core/theme/surface_tone.dart';
import 'package:profile/core/theme/tokens.dart';
import 'package:profile/core/services/sound_service.dart';
import 'package:profile/features/shell/presentation/controllers/home_controller.dart';
import 'package:profile/features/shell/presentation/widgets/portfolio_nav.dart';

class AppBarBrandSignature extends StatelessWidget {
  final bool tight;
  final bool isDark;
  final VoidCallback? onLogoPressed;

  const AppBarBrandSignature({
    super.key,
    required this.tight,
    required this.isDark,
    this.onLogoPressed,
  });

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final secondary = Theme.of(context).colorScheme.secondary;

    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: AlignmentDirectional.centerStart,
      child: Semantics(
        button: true,
        label: 'Abdallah Alhyari — return to top',
        child: InkWell(
          onTap: () {
            SoundService.instance.playClick();
            onLogoPressed?.call();
          },
          borderRadius: BorderRadius.circular(AppRadius.sm),
          child: ExcludeSemantics(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                      gradient: LinearGradient(
                        colors: [primary, secondary],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: primary.withValues(alpha: AppAlpha.border),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        'A',
                        style: TextStyle(
                          fontFamily: AppTypography.displayFont,
                          color: Colors.white,
                          fontSize: AppTypography.subtitle,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ABDALLAH',
                        style: TextStyle(
                          fontFamily: AppTypography.displayFont,
                          color: context.onSurface,
                          fontSize: AppTypography.small,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.4,
                          height: 1.1,
                        ),
                      ),
                      if (!tight) _buildSubBadge(context, isDark),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSubBadge(BuildContext context, bool isDark) {
    final controller = HomeController.maybeOf(context);
    if (controller == null) return _availableBadge(isDark);

    return ValueListenableBuilder<int>(
      valueListenable: controller.pageIndex,
      builder: (context, page, _) {
        final pageCount = controller.pageCount;
        if (page < 0) return _availableBadge(isDark);
        final labels = TopNav.getLabels(context);
        if (page >= labels.length) return _availableBadge(isDark);

        final ordinal = (page + 1).toString().padLeft(2, '0');
        final denom = ' / ${pageCount.toString().padLeft(2, '0')}';
        final label = labels[page].toUpperCase();

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$ordinal$denom',
              style: const TextStyle(
                fontFamily: AppTypography.monoFont,
                color: AppColors.accentIndigo,
                fontSize: AppTypography.editorialSm,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(width: 6),
            Container(
              width: 1,
              height: 8,
              color: context.glassBorderStrong,
            ),
            const SizedBox(width: 6),
            Flexible(
              child: AnimatedSwitcher(
                duration: AppMotion.chipHover,
                child: Text(
                  label,
                  key: ValueKey(label),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.8)
                        : AppColors.slate600,
                    fontSize: AppTypography.micro,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.4,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _availableBadge(bool isDark) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: AppColors.accentGreen,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            'AVAILABLE',
            style: TextStyle(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.7)
                  : AppColors.slate600,
              fontSize: AppTypography.micro,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.0,
            ),
          ),
        ],
      );
}
