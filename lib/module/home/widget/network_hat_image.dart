import 'package:flutter/material.dart';

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

class _HatImageState extends State<HatImage> with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(seconds: 3))..repeat(reverse: true);
    _anim = Tween<double>(begin: -0.02, end: 0.02).animate(CurvedAnimation(parent: _c, curve: Curves.easeInOutSine));
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  bool get _isNetwork => widget.path.startsWith('http');

  Widget _buildImage() {
    if (!_isNetwork) {
      return Image.asset(
        widget.path,
        height: widget.height,
        fit: BoxFit.contain,
        semanticLabel: widget.semanticLabel,
      );
    }
    return Image.network(
      widget.path,
      height: widget.height,
      fit: BoxFit.contain,
      semanticLabel: widget.semanticLabel,
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return SizedBox(
          height: widget.height,
          child: const Center(
            child: SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white70,
              ),
            ),
          ),
        );
      },
      errorBuilder: (context, error, stack) => SizedBox(
        height: widget.height,
        child: const Center(
          child: Icon(Icons.broken_image_outlined, color: Colors.white70, size: 40),
        ),
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
