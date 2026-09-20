import 'package:flutter/material.dart';
import 'package:profile/l10n/app_localizations.dart';

import 'package:profile/service/sound_service.dart';
import 'package:profile/theme/tokens.dart';

class IntroFooterStrip extends StatelessWidget {
  final bool isDark;
  final VoidCallback? onContactMe;
  final VoidCallback? onViewWork;

  const IntroFooterStrip({
    super.key,
    required this.isDark,
    this.onContactMe,
    this.onViewWork,
  });

  static const _gold = AppColors.accentAmberSoft;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isMobile = size.width < 640;
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final accent = scheme.primary;
    final accentSoft = accent.withValues(alpha: 0.35);

    Widget block(String label, String value,
        {Color? valueColor, VoidCallback? onTap, String? tooltip}) {
      final child = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.72)
                      : AppColors.slate500,
                  fontSize: AppTypography.editorialSm,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2.5,
                ),
              ),
              if (onTap != null) ...[
                const SizedBox(width: 4),
                Icon(Icons.arrow_outward,
                    size: 9,
                    color: valueColor ??
                        (isDark ? Colors.white70 : AppColors.slate500)),
              ],
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: valueColor ??
                  (isDark ? Colors.white : AppColors.slate900),
              fontSize: AppTypography.captionSm,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.4,
            ),
          ),
        ],
      );

      if (onTap == null) return child;

      return Tooltip(
        message: tooltip ?? '',
        child: InkWell(
          onTap: () {
            SoundService.instance.playClick();
            onTap();
          },
          borderRadius: BorderRadius.circular(AppRadius.sm),
          child: child,
        ),
      );
    }

    Widget divider() => Container(
          width: 1,
          height: 32,
          margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          color: isDark
              ? Colors.white.withValues(alpha: 0.2)
              : AppColors.slate300,
        );

    final blocks = [
      block(
        l10n.introBasedIn,
        l10n.introLocation.toUpperCase(),
        valueColor: isDark ? _gold : AppColors.accentAmberDeep,
      ),
      block(
        l10n.introStatus,
        l10n.introOpenForRoles,
        valueColor: isDark ? accentSoft : accent,
        onTap: onContactMe,
        tooltip: 'Jump to Contact',
      ),
      block(
        l10n.introDiscipline,
        l10n.introMobileArch,
        onTap: onViewWork,
        tooltip: 'Jump to Work',
      ),
    ];

    return Column(
      children: [
        Row(children: [
          Expanded(
              child: Container(
                  height: 1,
                  color: isDark ? Colors.white24 : AppColors.slate300)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              l10n.introMasthead,
              style: TextStyle(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.7)
                    : AppColors.slate500,
                fontSize: AppTypography.micro,
                fontWeight: FontWeight.w900,
                letterSpacing: 3,
              ),
            ),
          ),
          Expanded(
              child: Container(
                  height: 1,
                  color: isDark ? Colors.white24 : AppColors.slate300)),
        ]),
        const SizedBox(height: AppSpacing.md),
        if (isMobile)
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 10,
            runSpacing: 8,
            children: [
              for (final b in blocks)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.04)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                    border: Border.all(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.1)
                          : AppColors.slate200,
                    ),
                    boxShadow: isDark
                        ? null
                        : [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 4,
                              offset: const Offset(0, 1),
                            ),
                          ],
                  ),
                  child: b,
                ),
            ],
          )
        else
          Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              blocks[0],
              divider(),
              blocks[1],
              divider(),
              blocks[2],
            ],
          ),
      ],
    );
  }
}
