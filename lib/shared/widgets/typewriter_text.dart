import 'package:flutter/material.dart';
import 'package:profile/core/theme/tokens.dart';

/// Reveals text character-by-character with a blinking cursor, starting when
/// [trigger] crosses [triggerAt]. Layout size is reserved up-front via an
/// invisible full-text layer so the surrounding Column never jumps.
///
/// Fully respects [AppMedia.reduceMotion]: shows the finished text instantly.
class TypewriterText extends StatefulWidget {
  /// The full text to type out.
  final String text;

  /// Text style applied to both the invisible spacer and the visible text.
  final TextStyle? style;

  /// Optional text alignment.
  final TextAlign? textAlign;

  /// The parent entrance animation (typically the cover's reveal controller).
  final Animation<double> trigger;

  /// Value of [trigger] at which typing begins (0–1). Defaults to 0.5.
  final double triggerAt;

  /// Time per character. Total duration = charInterval × text.length,
  /// clamped to [300ms, 4500ms].
  final Duration charInterval;

  /// Accent colour for the blinking cursor. Falls back to [style]'s colour,
  /// then the theme primary.
  final Color? cursorColor;

  const TypewriterText({
    super.key,
    required this.text,
    this.style,
    this.textAlign,
    required this.trigger,
    this.triggerAt = 0.5,
    this.charInterval = AppMotion.typewriterChar,
    this.cursorColor,
  });

  @override
  State<TypewriterText> createState() => _TypewriterTextState();
}

class _TypewriterTextState extends State<TypewriterText>
    with TickerProviderStateMixin {
  late AnimationController _typing;
  late AnimationController _cursor;
  bool _started = false;
  bool _done = false;

  @override
  void initState() {
    super.initState();
    _initTyping();
    _cursor = AnimationController(
      vsync: this,
      duration: AppMotion.typewriterBlink,
    );
    widget.trigger.addListener(_checkTrigger);
    _checkTrigger(); // in case the animation already passed the threshold
  }

  void _initTyping() {
    final ms = widget.charInterval.inMilliseconds * widget.text.length;
    _typing = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: ms.clamp(300, 4500)),
    );
    _typing.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        // Let the cursor blink a couple more times, then fade it out.
        Future.delayed(AppMotion.typewriterCursorHold, () {
          if (mounted) {
            _cursor.stop();
            setState(() => _done = true);
          }
        });
      }
    });
  }

  void _checkTrigger() {
    if (_started) return;
    if (widget.trigger.value >= widget.triggerAt) {
      _started = true;
      widget.trigger.removeListener(_checkTrigger);
      _cursor.repeat(reverse: true);
      _typing.forward();
    }
  }

  @override
  void didUpdateWidget(TypewriterText old) {
    super.didUpdateWidget(old);
    if (old.text != widget.text) {
      _typing.dispose();
      _initTyping();
      if (_started && !_done) _typing.forward();
    }
  }

  @override
  void dispose() {
    widget.trigger.removeListener(_checkTrigger);
    _typing.dispose();
    _cursor.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Accessibility: no motion → show the finished text.
    if (AppMedia.reduceMotion(context) || _done) {
      return Text(
        widget.text,
        style: widget.style,
        textAlign: widget.textAlign,
      );
    }

    return AnimatedBuilder(
      animation: Listenable.merge([_typing, _cursor]),
      builder: (context, _) {
        final length = widget.text.length;
        final chars = (_typing.value * length).round().clamp(0, length);
        final visible = widget.text.substring(0, chars);
        final showCursor = _started;
        final cursorAlpha = showCursor ? _cursor.value : 0.0;
        final accent = widget.cursorColor ??
            widget.style?.color ??
            Theme.of(context).colorScheme.primary;

        // Stack: invisible full text reserves space; visible typed text
        // overlays it so the layout never jumps as lines wrap.
        return Stack(
          children: [
            Visibility(
              visible: false,
              maintainSize: true,
              maintainAnimation: true,
              maintainState: true,
              child: Text(
                widget.text,
                style: widget.style,
                textAlign: widget.textAlign,
              ),
            ),
            Text.rich(
              TextSpan(
                text: visible,
                children: [
                  if (showCursor)
                    TextSpan(
                      text: '▎',
                      style: TextStyle(
                        color: accent.withValues(alpha: cursorAlpha * 0.85),
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                ],
              ),
              style: widget.style,
              textAlign: widget.textAlign,
            ),
          ],
        );
      },
    );
  }
}
