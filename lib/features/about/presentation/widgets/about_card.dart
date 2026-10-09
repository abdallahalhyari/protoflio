import 'package:flutter/material.dart';
import 'package:profile/core/theme/surface_tone.dart';
import 'package:profile/core/theme/tokens.dart';

/// Quiet container shared by the About tabs: card stock, one hairline.
/// Supports an optional cyber terminal window header with status markers.
class AboutCard extends StatelessWidget {
  const AboutCard({
    super.key,
    required this.child,
    this.padding,
    this.terminalHeader = false,
    this.headerKicker,
    this.headerTitle,
    this.engineStatus,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final bool terminalHeader;
  final String? headerKicker;
  final String? headerTitle;
  final String? engineStatus;

  Widget _trafficDot(Color color) => Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      );

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final primary = Theme.of(context).colorScheme.primary;
    final hasHeader = terminalHeader || headerKicker != null;

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (hasHeader) ...[
          LayoutBuilder(
            builder: (context, constraints) {
              final isCompact = constraints.maxWidth < 420;
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                child: Row(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _trafficDot(AppColors.signalLight),
                        const SizedBox(width: 5),
                        _trafficDot(
                            isDark ? AppColors.goldSoft : AppColors.goldDeep),
                        const SizedBox(width: 5),
                        _trafficDot(
                            isDark ? AppColors.tealLight : AppColors.tealDeep),
                      ],
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        headerKicker ?? headerTitle ?? 'TERMINAL',
                        maxLines: 1,
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: AppTypography.monoFont,
                          fontSize: AppTypography.label - 2,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.8,
                          color: context.adaptiveAccentText(primary),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color:
                            isDark ? AppColors.tealLight : AppColors.tealDeep,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: (isDark
                                    ? AppColors.tealLight
                                    : AppColors.tealDeep)
                                .withValues(alpha: 0.6),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                    if (!isCompact && engineStatus != null) ...[
                      const SizedBox(width: 6),
                      Text(
                        engineStatus!,
                        maxLines: 1,
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: AppTypography.monoFont,
                          fontSize: AppTypography.label - 2,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.8,
                          color:
                              isDark ? AppColors.tealLight : AppColors.tealDeep,
                        ),
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
          Divider(
            height: 1,
            thickness: 0.8,
            color: context.glassBorderStrong.withValues(alpha: 0.5),
          ),
        ],
        Padding(
          padding: padding ?? const EdgeInsets.all(AppSpacing.md),
          child: child,
        ),
      ],
    );

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: context.cardGlass,
        borderRadius: BorderRadius.circular(AppRadius.card),
        gradient: isDark
            ? RadialGradient(
                center: Alignment.topLeft,
                radius: 1.8,
                colors: [
                  primary.withValues(alpha: 0.12),
                  context.cardGlass,
                ],
              )
            : null,
        border: Border.all(
          color: isDark
              ? primary.withValues(alpha: 0.25)
              : context.glassBorderStrong,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black38 : AppColors.shadowSoft,
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
          if (isDark)
            BoxShadow(
              color: primary.withValues(alpha: 0.08),
              blurRadius: 36,
              spreadRadius: 1,
            )
        ],
      ),
      child: content,
    );
  }
}

/// Technical tag: tool names set in the mono face.
class MonoTag extends StatelessWidget {
  const MonoTag(this.label, {super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final primary = Theme.of(context).colorScheme.primary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.03) : AppColors.ink50,
        borderRadius: BorderRadius.circular(AppRadius.chip),
        border: Border.all(
          color: isDark
              ? primary.withValues(alpha: 0.25)
              : context.glassBorderStrong,
          width: 0.8,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '#',
            style: TextStyle(
              fontFamily: AppTypography.monoFont,
              fontSize: AppTypography.label - 1,
              fontWeight: FontWeight.w700,
              color: context.adaptiveAccentText(primary),
            ),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            textDirection: TextDirection.ltr,
            style: TextStyle(
              fontFamily: AppTypography.monoFont,
              fontSize: AppTypography.label,
              fontWeight: FontWeight.w600,
              color: context.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
