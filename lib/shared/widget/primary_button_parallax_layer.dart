import 'package:flutter/material.dart';

class PrimaryButtonParallaxLayer extends StatelessWidget {
  const PrimaryButtonParallaxLayer({
    super.key,
    required this.parallaxOffset,
    required this.child,
  });

  final ValueNotifier<Offset> parallaxOffset;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Offset>(
      valueListenable: parallaxOffset,
      builder: (context, parallax, staticChild) {
        return RepaintBoundary(
          child: Transform.translate(
            offset: parallax,
            child: staticChild,
          ),
        );
      },
      child: child,
    );
  }
}
