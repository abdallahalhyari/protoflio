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
    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: context.cardGlass,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: context.glassBorderStrong),
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
