import 'package:flutter/material.dart';

/// Mirrors a directional icon (e.g. `arrow_forward_rounded`,
/// `chevron_right_rounded`) horizontally when the ambient text direction
/// is RTL. Use for **navigational** arrows — prev/next chevrons, "go to"
/// carets, page-turn glyphs. **Don't** wrap semantic arrows like the
/// "open external link" out-arrow, which should point in a fixed
/// direction regardless of locale.
class DirIcon extends StatelessWidget {
  const DirIcon(this.icon, {super.key, this.size, this.color});

  final IconData icon;
  final double? size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final rtl = Directionality.of(context) == TextDirection.rtl;
    final ic = Icon(icon, size: size, color: color);
    if (!rtl) return ic;
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()..scaleByDouble(-1.0, 1.0, 1.0, 1.0),
      child: ic,
    );
  }
}
