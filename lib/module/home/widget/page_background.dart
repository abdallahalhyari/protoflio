import 'package:flutter/material.dart';

class PageBackground extends StatefulWidget {
  final String asset;
  final Widget child;
  final Color? overlay;
  final PageController? controller;
  final int? pageIndex;

  const PageBackground({
    super.key,
    required this.asset,
    required this.child,
    this.overlay,
    this.controller,
    this.pageIndex,
  });

  @override
  State<PageBackground> createState() => _PageBackgroundState();
}

class _PageBackgroundState extends State<PageBackground> {
  Offset _mouseOffset = Offset.zero;

  Widget _buildBackground(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    
    Widget baseImage = Transform.scale(
      scale: 1.35, // extra scale to hide edges during parallax
      child: Image.asset(widget.asset, fit: BoxFit.cover),
    );

    if (widget.controller == null || widget.pageIndex == null) {
      return AnimatedSlide(
        duration: const Duration(milliseconds: 150),
        offset: Offset(_mouseOffset.dx / size.width * 0.05, _mouseOffset.dy / size.height * 0.05),
        child: baseImage,
      );
    }

    return AnimatedBuilder(
      animation: widget.controller!,
      builder: (context, child) {
        double pageOffset = 0.0;
        if (widget.controller!.position.haveDimensions) {
          pageOffset = widget.controller!.page! - widget.pageIndex!;
        }
        
        return AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          transform: Matrix4.identity()
            ..translate(
              _mouseOffset.dx * -0.05, // subtle opposite direction
              (pageOffset * size.height * 0.4) + (_mouseOffset.dy * -0.05),
            ),
          child: baseImage,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (event) {
        final size = MediaQuery.sizeOf(context);
        final center = Offset(size.width / 2, size.height / 2);
        setState(() {
          _mouseOffset = event.localPosition - center;
        });
      },
      onExit: (_) {
        setState(() {
          _mouseOffset = Offset.zero;
        });
      },
      child: Stack(
        children: [
          Positioned.fill(
            child: _buildBackground(context),
          ),
          if (widget.overlay != null) Positioned.fill(child: ColoredBox(color: widget.overlay!)),
          Positioned.fill(child: widget.child),
        ],
      ),
    );
  }
}
