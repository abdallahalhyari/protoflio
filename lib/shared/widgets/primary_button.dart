import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:profile/core/theme/tokens.dart';
import 'package:profile/shared/utils/hover_reset_offset_controller.dart';

import 'package:profile/shared/widgets/primary_button_parallax_layer.dart';
import 'package:profile/shared/widgets/primary_button_gradient_shell.dart';

enum PrimaryButtonSize { sm, md, lg }

enum PrimaryButtonVariant { primary, destructive }

class PrimaryButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final PrimaryButtonSize size;
  final PrimaryButtonVariant variant;
  final bool loading;
  final IconData? icon;
  final IconData? trailingIcon;
  final bool isPill;
  final double? letterSpacing;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.size = PrimaryButtonSize.md,
    this.variant = PrimaryButtonVariant.primary,
    this.loading = false,
    this.icon,
    this.trailingIcon,
    this.isPill = false,
    this.letterSpacing,
  });

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  bool _isFocused = false;
  bool _isPressed = false;
  late final _hover = HoverResetOffsetController(
    vsync: this,
    duration: AppMotion.xs,
    curve: Curves.easeOutCubic,
  );
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
    _hover.dispose();
    super.dispose();
  }

  bool get _enabled => widget.onPressed != null && !widget.loading;

  ({double fontSize, double hPad, double vPad, double iconSize}) get _dims {
    switch (widget.size) {
      case PrimaryButtonSize.sm:
        return (
          fontSize: AppTypography.body,
          hPad: 18,
          vPad: AppSpacing.xs + 2,
          iconSize: 14,
        );
      case PrimaryButtonSize.md:
        return (
          fontSize: AppTypography.lead,
          hPad: 28,
          vPad: AppSpacing.sm,
          iconSize: AppSpacing.md,
        );
      case PrimaryButtonSize.lg:
        return (
          fontSize: AppTypography.lead + 2,
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

    Widget content = ExcludeSemantics(
      child: Text(
        widget.label,
        style: TextStyle(
          fontSize: dims.fontSize,
          color: _enabled
              ? scheme.onPrimary
              : scheme.onPrimary.withValues(alpha: 0.7),
          fontWeight: FontWeight.bold,
          letterSpacing: widget.letterSpacing,
        ),
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
          Flexible(child: content),
        ],
      );
    } else if (widget.trailingIcon != null) {
      content = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(child: content),
          const SizedBox(width: AppSpacing.sm),
          Icon(widget.trailingIcon,
              size: dims.iconSize,
              color: _enabled
                  ? scheme.onPrimary
                  : scheme.onPrimary.withValues(alpha: 0.7)),
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
            _hover.animateToZero();
            if (_isHovered) {
              setState(() => _isHovered = false);
            }
          },
          cursor: _enabled
              ? SystemMouseCursors.click
              : SystemMouseCursors.forbidden,
          child: GestureDetector(
            onTapDown:
                _enabled ? (_) => setState(() => _isPressed = true) : null,
            onTapUp:
                _enabled ? (_) => setState(() => _isPressed = false) : null,
            onTapCancel:
                _enabled ? () => setState(() => _isPressed = false) : null,
            onTap: _enabled
                ? () {
                    HapticFeedback.lightImpact();
                    widget.onPressed!();
                  }
                : null,
            child: AnimatedScale(
              scale: _isPressed ? 0.95 : 1.0,
              duration: AppMotion.micro,
              curve: Curves.easeOutCubic,
              child: PrimaryButtonParallaxLayer(
                parallaxOffset: _hover.offset,
                child: PrimaryButtonGradientShell(
                  containerKey: _key,
                  base: base,
                  scheme: scheme,
                  hover: hover,
                  enabled: _enabled,
                  isFocused: _isFocused,
                  isPill: widget.isPill,
                  reduceMotion: reduceMotion,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: dims.hPad,
                      vertical: dims.vPad,
                    ),
                    child: content,
                  ),
                ),
              ), // PrimaryButtonParallaxLayer
            ), // AnimatedScale
          ), // GestureDetector
        ), // MouseRegion
      ), // FocusableActionDetector
    ); // Semantics
  }
}
