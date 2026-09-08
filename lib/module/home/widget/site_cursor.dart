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
///
/// ### Hot state
///
/// The ring can grow + tint primary when the pointer sits over a widget
/// that has opted in. Any hover-aware widget (project card, hat card,
/// nav item, etc.) just calls `SiteCursor.hot.value++` on enter and
/// `--` on exit — the reference count lets nested/overlapping regions
/// stack cleanly. On mobile / non-web the notifier still exists but
/// isn't read.
class SiteCursor extends StatefulWidget {
  final Widget child;
  const SiteCursor({super.key, required this.child});

  /// Reference-counted hot flag. `> 0` means the pointer is over at
  /// least one interactive widget; the ring grows and takes on the
  /// primary color while non-zero.
  static final ValueNotifier<int> hot = ValueNotifier<int>(0);

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
              child: ValueListenableBuilder<int>(
                valueListenable: SiteCursor.hot,
                builder: (context, hotCount, _) {
                  final hot = hotCount > 0;
                  final ringSize = hot ? 44.0 : 28.0;
                  return Stack(
                    children: [
                      AnimatedPositioned(
                        duration: AppMotion.sm,
                        curve: Curves.easeOutCubic,
                        left: _pos.dx - ringSize / 2,
                        top: _pos.dy - ringSize / 2,
                        child: AnimatedContainer(
                          duration: AppMotion.sm,
                          curve: Curves.easeOutCubic,
                          width: ringSize,
                          height: ringSize,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: hot
                                ? scheme.primary.withValues(alpha: 0.12)
                                : Colors.transparent,
                            border: Border.all(
                              color: hot
                                  ? scheme.primary
                                  : scheme.onSurface
                                      .withValues(alpha: 0.45),
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
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
