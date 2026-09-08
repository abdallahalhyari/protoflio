import 'package:flutter/material.dart';
import '../../../theme/tokens.dart';

/// Portfolio primary CTA. Black surface, white text; focus ring, hover /
/// press overlay, and — when `onPressed` is null — a visibly dimmed
/// disabled state so tap-dead buttons never look tappable.
class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final double fontSize;
  final double horizontalPadding;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.fontSize = AppTypography.bodyLg + 2,
    this.horizontalPadding = 28,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return Colors.black.withValues(alpha: 0.35);
          }
          return Colors.black;
        }),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return Colors.white.withValues(alpha: 0.45);
          }
          return Colors.white;
        }),
        elevation: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) return 0;
          return 3;
        }),
        overlayColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) return null;
          if (states.contains(WidgetState.focused) ||
              states.contains(WidgetState.hovered)) {
            return Colors.white.withValues(alpha: 0.18);
          }
          if (states.contains(WidgetState.pressed)) {
            return Colors.white.withValues(alpha: 0.28);
          }
          return null;
        }),
        side: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.focused)) {
            return const BorderSide(color: Colors.white, width: 2);
          }
          return BorderSide.none;
        }),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.sm)),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: AppSpacing.sm,
        ),
        child: Text(label, style: TextStyle(fontSize: fontSize)),
      ),
    );
  }
}
