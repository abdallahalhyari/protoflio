import 'package:flutter/material.dart';

import 'package:profile/shared/widget/retrying_asset_image.dart';

class HatImage extends StatefulWidget {
  final String path;
  final double height;
  final String? semanticLabel;

  const HatImage({
    super.key,
    required this.path,
    required this.height,
    this.semanticLabel,
  });

  @override
  State<HatImage> createState() => _HatImageState();
}

class _HatImageState extends State<HatImage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(seconds: 3));
    _anim = Tween<double>(begin: -0.02, end: 0.02)
        .animate(CurvedAnimation(parent: _c, curve: Curves.easeInOutSine));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final shouldAnimate = !MediaQuery.disableAnimationsOf(context);
    if (shouldAnimate && !_c.isAnimating) {
      _c.forward();
    } else if (!shouldAnimate && _c.isAnimating) {
      _c.stop();
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  // All hats ship as bundled assets now — they used to be hotlinked from a
  // third-party Webflow CDN that could disappear at any time.
  Widget _buildImage() {
    return SizedBox(
      height: widget.height,
      child: RetryingAssetImage(
        widget.path,
        fit: BoxFit.contain,
        semanticLabel: widget.semanticLabel,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _anim.value * widget.height),
          child: child,
        );
      },
      child: _buildImage(),
    );
  }
}
