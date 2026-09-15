import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../theme/tokens.dart';

/// Compact size preset for `PrimaryButton`.
enum PrimaryButtonSize { sm, md, lg }

/// Semantic color intent.
enum PrimaryButtonVariant { primary, destructive }

/// Portfolio hero CTA — gradient fill, hover parallax, and press haptics.
/// Supports size / variant tokens, a `loading` spinner, and a disabled
/// state (pass `onPressed: null`).
class PrimaryButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final PrimaryButtonSize size;
  final PrimaryButtonVariant variant;
  final bool loading;
  final IconData? icon;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.size = PrimaryButtonSize.md,
    this.variant = PrimaryButtonVariant.primary,
    this.loading = false,
    this.icon,
  });

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  bool _isHovered = false;
  Offset _mousePos = Offset.zero;
  final GlobalKey _key = GlobalKey();

  bool get _enabled => widget.onPressed != null && !widget.loading;

  ({double fontSize, double hPad, double vPad, double iconSize}) get _dims {
    switch (widget.size) {
      case PrimaryButtonSize.sm:
        return (fontSize: 13, hPad: 18, vPad: 6, iconSize: 14);
      case PrimaryButtonSize.md:
        return (fontSize: 16, hPad: 28, vPad: 8, iconSize: 16);
      case PrimaryButtonSize.lg:
        return (fontSize: 18, hPad: 36, vPad: 12, iconSize: 20);
    }
  }

  Color _baseColor(ColorScheme scheme) {
    switch (widget.variant) {
      case PrimaryButtonVariant.primary:
        return scheme.primary;
      case PrimaryButtonVariant.destructive:
        return scheme.error;
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final base = _baseColor(scheme);
    final dims = _dims;
    final hover = _isHovered && _enabled;

    Widget content = Text(
      widget.label,
      style: TextStyle(
        fontSize: dims.fontSize,
        color: _enabled ? Colors.white : Colors.white70,
        fontWeight: FontWeight.bold,
      ),
    );

    if (widget.icon != null) {
      content = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(widget.icon,
              size: dims.iconSize,
              color: _enabled ? Colors.white : Colors.white70),
          const SizedBox(width: 8),
          content,
        ],
      );
    }

    if (widget.loading) {
      content = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: dims.iconSize,
            height: dims.iconSize,
            child: const CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          const SizedBox(width: 10),
          content,
        ],
      );
    }

    return Semantics(
      button: true,
      enabled: _enabled,
      label: widget.label,
      child: MouseRegion(
        onEnter: (_) {
          if (!_enabled) return;
          setState(() => _isHovered = true);
        },
        onExit: (_) => setState(() {
          _isHovered = false;
          _mousePos = Offset.zero;
        }),
        onHover: (event) {
          if (!_enabled || _key.currentContext == null) return;
          final RenderBox box =
              _key.currentContext!.findRenderObject() as RenderBox;
          final center = Offset(box.size.width / 2, box.size.height / 2);
          final delta = event.localPosition - center;
          final next = Offset(delta.dx * 0.15, delta.dy * 0.25);
          if ((next - _mousePos).distanceSquared < 4) return;
          setState(() => _mousePos = next);
        },
        cursor: _enabled
            ? SystemMouseCursors.click
            : SystemMouseCursors.forbidden,
        child: GestureDetector(
          onTap: _enabled
              ? () {
                  HapticFeedback.lightImpact();
                  widget.onPressed!();
                }
              : null,
          child: AnimatedContainer(
            key: _key,
            duration: AppMotion.xs,
            curve: Curves.easeOut,
            transform: Matrix4.identity()
              ..translateByDouble(_mousePos.dx, _mousePos.dy, 0.0, 1.0)
              ..scaleByDouble(
                hover ? 1.05 : 1.0,
                hover ? 1.05 : 1.0,
                1.0,
                1.0,
              ),
            transformAlignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.sm),
              boxShadow: [
                BoxShadow(
                  color: base.withValues(alpha: hover ? 0.55 : 0.28),
                  blurRadius: hover ? 18 : 10,
                  spreadRadius: hover ? 2 : 0,
                  offset: const Offset(0, 4),
                ),
              ],
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: !_enabled
                    ? [
                        base.withValues(alpha: 0.35),
                        base.withValues(alpha: 0.25),
                      ]
                    : hover
                        ? [
                            Color.lerp(base, Colors.white, 0.15)!,
                            base,
                          ]
                        : [
                            Color.lerp(base, Colors.white, 0.08)!,
                            Color.lerp(base, Colors.black, 0.12)!,
                          ],
              ),
              border: Border.all(
                color: hover
                    ? Color.lerp(base, Colors.white, 0.40)!
                    : Colors.white.withValues(alpha: 0.22),
                width: hover ? 1.5 : 1,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: dims.hPad,
                vertical: dims.vPad,
              ),
              child: content,
            ),
          ),
        ),
      ),
    );
  }
}
