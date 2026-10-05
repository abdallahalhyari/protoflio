import 'package:flutter/material.dart';
import 'package:profile/core/theme/surface_tone.dart';
import 'package:profile/l10n/app_localizations.dart';

import 'package:profile/core/services/sound_service.dart';
import 'package:profile/core/theme/tokens.dart';

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

  static const _gold = AppColors.goldSoft;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isMobile = size.width < 640;
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final accent = scheme.primary;

    Widget block(String label, String value,
        {Color? valueColor, VoidCallback? onTap, String? tooltip}) {
      final child = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    label,
                    style: TextStyle(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.72)
                          : AppColors.ink500,
                      fontSize: AppTypography.label,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
              if (onTap != null) ...[
                const SizedBox(width: 4),
                Icon(Icons.arrow_outward_rounded,
                    size: 9,
                    color: valueColor ??
                        (isDark ? Colors.white70 : AppColors.ink500)),
              ],
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: valueColor ?? (context.onSurface),
              fontSize: AppTypography.label,
              fontWeight: FontWeight.w700,
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
          color:
              isDark ? Colors.white.withValues(alpha: 0.2) : AppColors.ink300,
        );

    final blocks = [
      block(
        l10n.introBasedIn,
        l10n.introLocation,
        valueColor: isDark ? _gold : AppColors.goldDeep,
      ),
      block(
        l10n.introStatus,
        l10n.introOpenForRoles,
        valueColor: isDark ? accent : AppColors.toAccessibleLightText(accent),
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
        Container(
          height: 1,
          margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          color: context.glassBorderStrong,
        ),
        const SizedBox(height: AppSpacing.md),
        // Mobile: one spec sheet with hairline rows. Three separately
        // centred chips of different widths stacked into a ragged pyramid.
        if (isMobile)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            decoration: BoxDecoration(
              color:
                  isDark ? Colors.white.withValues(alpha: 0.04) : Colors.white,
              borderRadius: BorderRadius.circular(AppRadius.sm),
              border: Border.all(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.1)
                    : AppColors.ink200,
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (var i = 0; i < blocks.length; i++) ...[
                  if (i > 0)
                    Container(
                      height: 1,
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.08)
                          : AppColors.ink200,
                    ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.smd, vertical: 10),
                    child: Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: blocks[i],
                    ),
                  ),
                ],
              ],
            ),
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
