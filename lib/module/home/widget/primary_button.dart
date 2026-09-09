import 'package:flutter/material.dart';
import '../../../theme/tokens.dart';

/// Portfolio primary CTA. Black surface, white text; focus ring, hover /
/// press overlay, and — when `onPressed` is null — a visibly dimmed
/// disabled state so tap-dead buttons never look tappable.
///
/// Set `pulse: true` on hero CTAs (Download CV, etc.) for an ambient
/// scale-breathing loop that draws the eye. Skipped when
/// `MediaQueryData.disableAnimations` is on.
class PrimaryButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final double fontSize;
  final double horizontalPadding;
  final bool pulse;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.fontSize = AppTypography.bodyLg + 2,
    this.horizontalPadding = 28,
    this.pulse = false,
  });

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1800),
  );
  late final Animation<double> _t = CurvedAnimation(
    parent: _c,
    curve: Curves.easeInOut,
  );
  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final want = widget.pulse && !MediaQuery.of(context).disableAnimations;
    if (want && !_started) {
      _started = true;
      _c.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final button = ElevatedButton(
      onPressed: widget.onPressed,
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
          horizontal: widget.horizontalPadding,
          vertical: AppSpacing.sm,
        ),
        child: Text(widget.label, style: TextStyle(fontSize: widget.fontSize)),
      ),
    );

    if (!_started) return button;
    return AnimatedBuilder(
      animation: _t,
      builder: (_, child) {
        // Ambient breathing loop: 1.0 -> 1.04 -> 1.0, with a matching
        // subtle white halo shadow.
        final scale = 1 + 0.04 * _t.value;
        return Transform.scale(
          scale: scale,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.sm),
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withValues(alpha: 0.15 * _t.value),
                  blurRadius: 24,
                  spreadRadius: 2 * _t.value,
                ),
              ],
            ),
            child: child,
          ),
        );
      },
      child: button,
    );
  }
}
