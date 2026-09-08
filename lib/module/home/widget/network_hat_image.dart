import 'package:flutter/material.dart';

class HatImage extends StatelessWidget {
  final String path;
  final double height;
  final String? semanticLabel;

  const HatImage({
    super.key,
    required this.path,
    required this.height,
    this.semanticLabel,
  });

  bool get _isNetwork => path.startsWith('http');

  @override
  Widget build(BuildContext context) {
    if (!_isNetwork) {
      return Image.asset(
        path,
        height: height,
        fit: BoxFit.contain,
        semanticLabel: semanticLabel,
      );
    }
    return Image.network(
      path,
      height: height,
      fit: BoxFit.contain,
      semanticLabel: semanticLabel,
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return SizedBox(
          height: height,
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
        height: height,
        child: const Center(
          child: Icon(Icons.broken_image_outlined,
              color: Colors.white70, size: 40),
        ),
      ),
    );
  }
}
