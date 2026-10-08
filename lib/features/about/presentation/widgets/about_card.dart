import 'package:flutter/material.dart';
import 'package:profile/core/theme/surface_tone.dart';
import 'package:profile/core/theme/tokens.dart';

/// Quiet container shared by the About tabs: card stock, one hairline.
class AboutCard extends StatelessWidget {
  const AboutCard({super.key, required this.child, this.padding});

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final primary = Theme.of(context).colorScheme.primary;

    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: context.cardGlass,
        borderRadius: BorderRadius.circular(AppRadius.card),
        gradient: isDark
            ? RadialGradient(
                center: Alignment.topLeft,
                radius: 1.5,
                colors: [
                  primary.withValues(alpha: 0.1),
                  context.cardGlass,
                ],
              )
            : null,
        border: Border.all(
          color: isDark
              ? primary.withValues(alpha: 0.2)
              : context.glassBorderStrong,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black26 : AppColors.shadowSoft,
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
          if (isDark)
            BoxShadow(
              color: primary.withValues(alpha: 0.05),
              blurRadius: 32,
              spreadRadius: 1,
            )
        ],
      ),
      child: child,
    );
  }
}

/// Technical tag: tool names set in the mono face.
class MonoTag extends StatelessWidget {
  const MonoTag(this.label, {super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.chip),
        border: Border.all(color: context.glassBorderStrong),
      ),
      child: Text(
        label,
        textDirection: TextDirection.ltr,
        style: TextStyle(
          fontFamily: AppTypography.monoFont,
          fontSize: AppTypography.label,
          color: context.onSurface,
        ),
      ),
    );
  }
}
