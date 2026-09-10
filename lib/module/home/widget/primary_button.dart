import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../theme/tokens.dart';

class PrimaryButton extends StatefulWidget {
  final String label;
  final VoidCallback onPressed;
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
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  bool _isHovered = false;
  Offset _mousePos = Offset.zero;
  final GlobalKey _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() {
        _isHovered = false;
        _mousePos = Offset.zero;
      }),
      onHover: (event) {
        if (_key.currentContext == null) return;
        final RenderBox box =
            _key.currentContext!.findRenderObject() as RenderBox;
        final center = Offset(box.size.width / 2, box.size.height / 2);
        final delta = event.localPosition - center;
        final next = Offset(delta.dx * 0.15, delta.dy * 0.25);
        // Skip micro-jitter rebuilds — anything under ~2px shift is
        // imperceptible visually but still triggers a full paint.
        if ((next - _mousePos).distanceSquared < 4) return;
        setState(() => _mousePos = next);
      },
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();
          widget.onPressed();
        },
        child: AnimatedContainer(
          key: _key,
          duration: AppMotion.xs,
          curve: Curves.easeOut,
          transform: Matrix4.identity()
            ..translateByDouble(_mousePos.dx, _mousePos.dy, 0.0, 1.0)
            ..scaleByDouble(
              _isHovered ? 1.05 : 1.0, 
              _isHovered ? 1.05 : 1.0, 
              1.0,
              1.0,
            ),
          transformAlignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.sm),
            boxShadow: [
              if (_isHovered)
                BoxShadow(
                  color: scheme.primary.withValues(alpha: 0.5),
                  blurRadius: 12,
                  spreadRadius: 2,
                  offset: const Offset(0, 4),
                ),
            ],
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: _isHovered
                  ? [
                      scheme.primary,
                      scheme.primary.withValues(alpha: 0.7),
                    ]
                  : [
                      scheme.primary.withValues(alpha: 0.85),
                      scheme.primary,
                    ],
            ),
            border: Border.all(
              color: _isHovered ? scheme.primary : Colors.white24,
              width: _isHovered ? 2 : 1,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: widget.horizontalPadding,
              vertical: AppSpacing.sm,
            ),
            child: Text(
              widget.label,
              style: TextStyle(
                fontSize: widget.fontSize,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
