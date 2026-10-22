import 'package:flutter/material.dart';
import 'package:profile/core/theme/surface_tone.dart';
import 'package:profile/core/theme/tokens.dart';

/// Quiet container: card stock, one hairline. Nothing here is tappable, so
/// nothing is gold.
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
