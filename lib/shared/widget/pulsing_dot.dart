import 'package:flutter/material.dart';

import 'package:profile/theme/tokens.dart';

class PulsingDot extends StatefulWidget {
  final Color color;
  const PulsingDot({super.key, required this.color});
  @override
  State<PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<PulsingDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: AppMotion.pulse,
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_c.isAnimating && !MediaQuery.disableAnimationsOf(context)) {
      _c.forward();
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Static inner dot is cached via the AnimatedBuilder `child:` param so
    // it doesn't re-decorate every frame — only the growing halo does.
    // RepaintBoundary isolates this from ancestor repaints on scroll.
    final staticDot = Container(
      width: 6,
      height: 6,
      decoration: BoxDecoration(
        color: widget.color,
        shape: BoxShape.circle,
      ),
    );

    return ExcludeSemantics(
      child: RepaintBoundary(
        child: SizedBox(
          width: 14,
          height: 14,
          child: AnimatedBuilder(
            animation: _c,
            child: staticDot,
            builder: (_, child) {
              final t = _c.value;
              return Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 8 + 6 * t,
                    height: 8 + 6 * t,
                    decoration: BoxDecoration(
                      color: widget.color.withValues(alpha: 0.35 * (1 - t)),
                      shape: BoxShape.circle,
                    ),
                  ),
                  child!,
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
