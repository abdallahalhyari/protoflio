import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../theme/tokens.dart';

/// Desktop-web cursor overlay: a hollow ring trails the pointer and a small
/// primary dot sits at the pointer tip. On mobile / non-web the widget is a
/// plain passthrough.
///
/// The system cursor stays visible underneath so that hit-testing feedback
/// (`SystemMouseCursors.click`, `.text`, etc.) still communicates
/// interactivity in the usual way.
class SiteCursor extends StatefulWidget {
  final Widget child;
  const SiteCursor({super.key, required this.child});

  @override
  State<SiteCursor> createState() => _SiteCursorState();
}

class _SiteCursorState extends State<SiteCursor> {
  Offset _pos = Offset.zero;
  bool _inside = false;

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb || MediaQuery.sizeOf(context).width < 700) {
      return widget.child;
    }
    final scheme = Theme.of(context).colorScheme;
    return MouseRegion(
      opaque: false,
      onEnter: (_) => setState(() => _inside = true),
      onExit: (_) => setState(() => _inside = false),
      onHover: (e) {
        if (e.kind != PointerDeviceKind.mouse) return;
        setState(() => _pos = e.position);
      },
      child: Stack(
        children: [
          widget.child,
          if (_inside)
            IgnorePointer(
              child: Stack(
                children: [
                  AnimatedPositioned(
                    duration: AppMotion.xs,
                    curve: Curves.easeOut,
                    left: _pos.dx - 14,
                    top: _pos.dy - 14,
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: scheme.onSurface.withValues(alpha: 0.45),
                          width: 1.4,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: _pos.dx - 2,
                    top: _pos.dy - 2,
                    child: Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: scheme.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
