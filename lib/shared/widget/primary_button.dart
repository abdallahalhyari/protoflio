import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:profile/theme/tokens.dart';

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
  final bool isPill;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.size = PrimaryButtonSize.md,
    this.variant = PrimaryButtonVariant.primary,
    this.loading = false,
    this.icon,
    this.isPill = false,
  });

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  bool _isHovered = false;
  bool _isFocused = false;
  final ValueNotifier<Offset> _parallaxOffset =
      ValueNotifier<Offset>(Offset.zero);
  final GlobalKey _key = GlobalKey();
  late final FocusNode _focusNode = FocusNode()..addListener(_onFocus);

  void _onFocus() {
    if (!mounted) return;
    setState(() => _isFocused = _focusNode.hasFocus);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocus);
    _focusNode.dispose();
    _parallaxOffset.dispose();
    super.dispose();
  }

  bool get _enabled => widget.onPressed != null && !widget.loading;

  ({double fontSize, double hPad, double vPad, double iconSize}) get _dims {
    switch (widget.size) {
      case PrimaryButtonSize.sm:
        return (
          fontSize: AppTypography.small,
          hPad: 18,
          vPad: AppSpacing.xs + 2,
          iconSize: 14,
        );
      case PrimaryButtonSize.md:
        return (
          fontSize: AppTypography.subtitle,
          hPad: 28,
          vPad: AppSpacing.sm,
          iconSize: AppSpacing.md,
        );
      case PrimaryButtonSize.lg:
        return (
          fontSize: AppTypography.subtitle + 2,
          hPad: 36,
          vPad: AppSpacing.smd,
          iconSize: 20,
        );
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
    final reduceMotion = MediaQuery.disableAnimationsOf(context);

    Widget content = Text(
      widget.label,
      style: TextStyle(
        fontSize: dims.fontSize,
        color: _enabled
            ? scheme.onPrimary
            : scheme.onPrimary.withValues(alpha: 0.7),
        fontWeight: FontWeight.bold,
      ),
    );

    if (widget.icon != null) {
      content = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(widget.icon,
              size: dims.iconSize,
              color: _enabled
                  ? scheme.onPrimary
                  : scheme.onPrimary.withValues(alpha: 0.7)),
          const SizedBox(width: AppSpacing.sm),
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
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(scheme.onPrimary),
            ),
          ),
          const SizedBox(width: AppSpacing.sm + 2),
          content,
        ],
      );
    }

    return Semantics(
      button: true,
      enabled: _enabled,
      label: widget.label,
      child: FocusableActionDetector(
        focusNode: _focusNode,
        enabled: _enabled,
        actions: <Type, Action<Intent>>{
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (_) {
              if (!_enabled) return null;
              HapticFeedback.lightImpact();
              widget.onPressed!();
              return null;
            },
          ),
        },
        child: MouseRegion(
          onEnter: (_) {
            if (!_enabled) return;
            setState(() => _isHovered = true);
          },
          onExit: (_) {
            _parallaxOffset.value = Offset.zero;
            if (_isHovered) {
              setState(() => _isHovered = false);
            }
          },
          onHover: (event) {
            if (!_enabled || _key.currentContext == null || reduceMotion) {
              return;
            }
            final RenderBox box =
                _key.currentContext!.findRenderObject() as RenderBox;
            final center = Offset(box.size.width / 2, box.size.height / 2);
            final delta = event.localPosition - center;
            final next = Offset(delta.dx * 0.15, delta.dy * 0.25);
            if ((next - _parallaxOffset.value).distanceSquared < 2) return;
            _parallaxOffset.value = next;
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
            child: ValueListenableBuilder<Offset>(
              valueListenable: _parallaxOffset,
              builder: (context, parallax, staticChild) {
                return Transform.translate(
                  offset: parallax,
                  child: staticChild,
                );
              },
              child: AnimatedContainer(
                key: _key,
                duration: AppMotion.xs,
                curve: Curves.easeOut,
                transform: Matrix4.identity()
                  ..scaleByDouble(
                    hover && !reduceMotion ? 1.05 : 1.0,
                    hover && !reduceMotion ? 1.05 : 1.0,
                    1.0,
                    1.0,
                  ),
                transformAlignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                      widget.isPill ? AppRadius.pill : AppRadius.sm),
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
                            base.withValues(alpha: AppAlpha.border),
                            base.withValues(alpha: AppAlpha.fill),
                          ]
                        : hover
                            ? [
                                Color.lerp(base, scheme.onPrimary, 0.15)!,
                                base,
                              ]
                            : [
                                Color.lerp(base, scheme.onPrimary, 0.08)!,
                                Color.lerp(base, scheme.shadow, 0.12)!,
                              ],
                  ),
                  border: Border.all(
                    color: _isFocused
                        ? scheme.onPrimary
                        : hover
                            ? Color.lerp(base, scheme.onPrimary, 0.40)!
                            : scheme.onPrimary.withValues(alpha: 0.22),
                    width: _isFocused ? 2 : (hover ? 1.5 : 1),
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
        ),
      ),
    );
  }
}
