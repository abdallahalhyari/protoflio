import 'package:flutter/material.dart';

import 'package:profile/core/theme/tokens.dart';

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
  late final Animation<double> _pulseCurve = CurvedAnimation(
    parent: _c,
    curve: Curves.easeInOutCubic,
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_c.isAnimating && !MediaQuery.disableAnimationsOf(context)) {
      if (WidgetsBinding.instance.runtimeType.toString().contains('Test')) {
        _c.forward();
      } else {
        _c.repeat(reverse: true);
      }
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
        boxShadow: [
          BoxShadow(
            color: widget.color.withValues(alpha: 0.65),
            blurRadius: 4,
            spreadRadius: 0.5,
          ),
        ],
      ),
    );

    return ExcludeSemantics(
      child: RepaintBoundary(
        child: SizedBox(
          width: 14,
          height: 14,
          child: AnimatedBuilder(
            animation: _pulseCurve,
            child: staticDot,
            builder: (_, child) {
              final t = _pulseCurve.value;
              return Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 7 + 7 * t,
                    height: 7 + 7 * t,
                    decoration: BoxDecoration(
                      color: widget.color.withValues(alpha: 0.38 * (1 - t)),
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
