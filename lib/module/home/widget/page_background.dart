import 'package:flutter/material.dart';

class PageBackground extends StatelessWidget {
  final String asset;
  final Widget child;
  final Color? overlay;

  const PageBackground({
    super.key,
    required this.asset,
    required this.child,
    this.overlay,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(asset, fit: BoxFit.cover),
        ),
        if (overlay != null) Positioned.fill(child: ColoredBox(color: overlay!)),
        Positioned.fill(child: child),
      ],
    );
  }
}
