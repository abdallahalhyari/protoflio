import 'package:flutter/material.dart';

import 'package:profile/core/theme/tokens.dart';

/// One beat of the cover's entrance, played from a shared [animation].
///
/// The cover runs a single scripted sequence: each element takes a slice
/// ([begin]..[end], 0–1) of one controller. With [mask] the child rises
/// out of its own box (a line of type surfacing); otherwise it fades up.
class HeroStep extends StatelessWidget {
  final Animation<double> animation;
  final double begin;
  final double end;
  final bool mask;
  final double rise;
  final Widget child;

  const HeroStep({
    super.key,
    required this.animation,
    required this.begin,
    required this.end,
    required this.child,
    this.mask = false,
    this.rise = 0.25,
  });

  @override
  Widget build(BuildContext context) {
    if (AppMedia.reduceMotion(context)) return child;
    final t = CurvedAnimation(
      parent: animation,
      curve: Interval(begin, end, curve: AppMotion.emphasizedDecel),
    );
    final moving = AnimatedBuilder(
      animation: t,
      child: child,
      builder: (context, child) {
        final v = t.value;
        final lifted = FractionalTranslation(
          translation: Offset(0, mask ? 1 - v : (1 - v) * rise),
          child: child,
        );
        return mask ? lifted : Opacity(opacity: v, child: lifted);
      },
    );
    return mask ? ClipRect(child: moving) : moving;
  }
}
