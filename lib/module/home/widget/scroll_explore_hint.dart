import 'package:flutter/material.dart';

import '../../../theme/tokens.dart';

/// Bouncing chevron + "SCROLL TO EXPLORE" label. Auto-loops when motion is
/// allowed; renders static when the user prefers reduced motion.
class ScrollExploreHint extends StatefulWidget {
  const ScrollExploreHint({super.key, required this.isDark, required this.onTap});

  final bool isDark;
  final VoidCallback onTap;

  @override
  State<ScrollExploreHint> createState() => _ScrollExploreHintState();
}

class _ScrollExploreHintState extends State<ScrollExploreHint>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final reduce = MediaQuery.of(context).disableAnimations;
    if (!reduce && !_ctrl.isAnimating) {
      _ctrl.repeat(reverse: true);
    } else if (reduce && _ctrl.isAnimating) {
      _ctrl.stop();
      _ctrl.value = 0;
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tint = widget.isDark
        ? Colors.white.withValues(alpha: 0.65)
        : AppColors.slate500;
    return Semantics(
      button: true,
      label: 'Scroll to explore the portfolio',
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: widget.onTap,
          behavior: HitTestBehavior.opaque,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'SCROLL TO EXPLORE',
                  style: TextStyle(
                    color: tint,
                    fontSize: AppTypography.editorial,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 3,
                  ),
                ),
                const SizedBox(height: 6),
                RepaintBoundary(
                  child: AnimatedBuilder(
                    animation: _ctrl,
                    builder: (_, __) {
                      final t = Curves.easeInOut.transform(_ctrl.value);
                      return Transform.translate(
                        offset: Offset(0, t * 6),
                        child: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: 24,
                          color: tint,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
