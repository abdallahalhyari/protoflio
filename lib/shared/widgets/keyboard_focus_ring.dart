import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// Draws one clear outline around whatever currently holds keyboard focus.
///
/// Flutter's default focus feedback is a faint overlay tint that most of
/// this site's custom controls (nav links, pills, cards, chips) either
/// don't show or show at near-invisible strength, so tabbing through the
/// page gave no visible position (WCAG 2.4.7). Rather than patching every
/// widget, this sits above the whole app and follows the primary focus.
///
/// It only draws while the focus highlight mode is traditional (the user
/// is on a keyboard), never for mouse or touch focus, and skips page-level
/// focus scopes whose bounds cover most of the screen.
class KeyboardFocusRing extends StatefulWidget {
  const KeyboardFocusRing({super.key, required this.child});

  final Widget child;

  @override
  State<KeyboardFocusRing> createState() => _KeyboardFocusRingState();
}

class _KeyboardFocusRingState extends State<KeyboardFocusRing>
    with SingleTickerProviderStateMixin {
  final GlobalKey _hostKey = GlobalKey();
  final ValueNotifier<Rect?> _rect = ValueNotifier<Rect?>(null);
  late final Ticker _ticker = createTicker((_) => _measure());

  @override
  void initState() {
    super.initState();
    FocusManager.instance.addListener(_sync);
    FocusManager.instance.addHighlightModeListener(_onModeChanged);
  }

  @override
  void dispose() {
    FocusManager.instance.removeListener(_sync);
    FocusManager.instance.removeHighlightModeListener(_onModeChanged);
    _ticker.dispose();
    _rect.dispose();
    super.dispose();
  }

  void _onModeChanged(FocusHighlightMode _) => _sync();

  bool get _keyboardMode =>
      FocusManager.instance.highlightMode == FocusHighlightMode.traditional;

  /// Follow the focused control every frame while the ring is showing, so
  /// it tracks page turns, scrolling and hover lifts; idle otherwise.
  void _sync() {
    final active =
        _keyboardMode && FocusManager.instance.primaryFocus?.context != null;
    if (active && !_ticker.isActive) {
      _ticker.start();
    } else if (!active && _ticker.isActive) {
      _ticker.stop();
    }
    if (!active) _rect.value = null;
    _measure();
  }

  void _measure() {
    if (!mounted) return;
    final host = _hostKey.currentContext?.findRenderObject();
    final focused =
        FocusManager.instance.primaryFocus?.context?.findRenderObject();
    Rect? next;
    if (_keyboardMode &&
        host is RenderBox &&
        host.hasSize &&
        focused is RenderBox &&
        focused.attached &&
        focused.hasSize) {
      final topLeft = focused.localToGlobal(Offset.zero, ancestor: host);
      final r = topLeft & focused.size;
      final screen = Offset.zero & host.size;
      // Page-level focus scopes (keyboard navigation, the Hats deck)
      // cover most of the viewport; outlining them just frames the page.
      final coversPage =
          r.width * r.height > screen.width * screen.height * 0.5;
      if (!coversPage && r.overlaps(screen) && !r.isEmpty) next = r;
    }
    if (next != _rect.value) _rect.value = next;
  }

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).colorScheme.primary;
    return Stack(
      key: _hostKey,
      textDirection: TextDirection.ltr,
      children: [
        widget.child,
        Positioned.fill(
          child: IgnorePointer(
            child: ValueListenableBuilder<Rect?>(
              valueListenable: _rect,
              builder: (context, rect, _) => RepaintBoundary(
                child: CustomPaint(
                  painter: FocusRingPainter(rect: rect, color: accent),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Paints the ring: a dark halo under a bright accent stroke, so it reads
/// on both the dark canvas and light cards.
class FocusRingPainter extends CustomPainter {
  const FocusRingPainter({required this.rect, required this.color});

  final Rect? rect;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final r = rect;
    if (r == null) return;
    final ring =
        RRect.fromRectAndRadius(r.inflate(4), const Radius.circular(10));
    canvas.drawRRect(
      ring,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5
        ..color = Colors.black.withValues(alpha: 0.55),
    );
    canvas.drawRRect(
      ring,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..color = Color.lerp(color, Colors.white, 0.35)!,
    );
  }

  @override
  bool shouldRepaint(FocusRingPainter old) =>
      old.rect != rect || old.color != color;
}
