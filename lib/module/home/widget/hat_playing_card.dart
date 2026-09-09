import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../service/sound_service.dart';
import '../model/hat_info.dart';
import 'network_hat_image.dart';

class HatPlayingCard extends StatefulWidget {
  final HatInfo hat;
  final int index;
  final Offset position;
  final double rotation;
  final ValueChanged<Offset>? onDragEnd;
  final VoidCallback? onDragStart;
  final VoidCallback? onCardTap;

  final bool isStandalone;

  const HatPlayingCard({
    super.key,
    required this.hat,
    required this.index,
    required this.position,
    this.rotation = 0.0,
    this.onDragEnd,
    this.onDragStart,
    this.onCardTap,
    this.isStandalone = false,
  });

  @override
  State<HatPlayingCard> createState() => _HatPlayingCardState();
}

class _HatPlayingCardState extends State<HatPlayingCard> with SingleTickerProviderStateMixin {
  late AnimationController _flipController;
  late Animation<double> _flipAnimation;
  bool _isFlipped = false;
  bool _isHovered = false;
  Offset _tiltOffset = Offset.zero;
  late Offset _currentOffset;

  @override
  void initState() {
    super.initState();
    _currentOffset = widget.position;
    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _flipAnimation = Tween<double>(begin: 0.0, end: math.pi).animate(
      CurvedAnimation(parent: _flipController, curve: Curves.easeInOutBack),
    );
  }

  @override
  void didUpdateWidget(HatPlayingCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.position != widget.position) {
      _currentOffset = widget.position;
    }
  }

  @override
  void dispose() {
    _flipController.dispose();
    super.dispose();
  }

  void _toggleFlip() {
    widget.onCardTap?.call();
    SoundService.instance.playClick();
    if (_isFlipped) {
      _flipController.reverse();
    } else {
      _flipController.forward();
    }
    setState(() => _isFlipped = !_isFlipped);
  }

  Widget _buildSpecularGleam() {
    if (!_isHovered) return const SizedBox.shrink();
    return Positioned.fill(
      child: IgnorePointer(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: RadialGradient(
              center: Alignment(_tiltOffset.dx, _tiltOffset.dy),
              radius: 0.9,
              colors: [
                const Color(0xFFFBBF24).withValues(alpha: 0.2),
                Colors.white.withValues(alpha: 0.06),
                Colors.transparent,
              ],
              stops: const [0.0, 0.45, 1.0],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cardContent = GestureDetector(
      onPanStart: widget.isStandalone ? null : (_) => widget.onDragStart?.call(),
      onPanUpdate: widget.isStandalone ? null : (details) {
        setState(() {
          _currentOffset += details.delta;
        });
      },
      onPanEnd: widget.isStandalone ? null : (_) => widget.onDragEnd?.call(_currentOffset),
      child: MouseRegion(
        cursor: SystemMouseCursors.grab,
        onEnter: (_) => setState(() => _isHovered = true),
        onHover: (event) {
          final RenderBox? box = context.findRenderObject() as RenderBox?;
          if (box != null) {
            final local = box.globalToLocal(event.position);
            final nx = ((local.dx / 255.0) * 2 - 1).clamp(-1.0, 1.0);
            final ny = ((local.dy / 370.0) * 2 - 1).clamp(-1.0, 1.0);
            setState(() {
              _tiltOffset = Offset(nx, ny);
            });
          }
        },
        onExit: (_) => setState(() {
          _isHovered = false;
          _tiltOffset = Offset.zero;
        }),
        child: AnimatedBuilder(
          animation: _flipAnimation,
          builder: (context, child) {
            final angle = _flipAnimation.value;
            final isUnder = angle > math.pi / 2;
            final double hoverLift = _isHovered ? -10.0 : 0.0;
            final double tiltX = _isHovered ? -_tiltOffset.dy * 0.16 : 0.0;
            final double tiltY = _isHovered ? _tiltOffset.dx * 0.20 : 0.0;

            return Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..translateByDouble(0.0, hoverLift, 0.0, 1.0)
                ..rotateZ(widget.isStandalone ? 0.0 : widget.rotation)
                ..setEntry(3, 2, 0.0015)
                ..rotateX(tiltX)
                ..rotateY(angle + tiltY),
              child: isUnder
                  // Card Back (Description side)
                  ? Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()..rotateY(math.pi),
                      child: _buildCardBack(context),
                    )
                  // Card Front (Hat Illustration side)
                  : _buildCardFront(context),
            );
          },
        ),
      ),
    );

    if (widget.isStandalone) {
      return SizedBox(
        width: 255,
        height: 370,
        child: cardContent,
      );
    }

    return Positioned(
      left: _currentOffset.dx,
      top: _currentOffset.dy,
      child: cardContent,
    );
  }

  Widget _buildCardFront(BuildContext context) {
    return GestureDetector(
      onTap: _toggleFlip,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 255,
            height: 370,
            decoration: BoxDecoration(
          color: const Color(0xFF1B2028),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _isHovered ? const Color(0xFFFBBF24) : const Color(0xFFC8A951),
            width: _isHovered ? 2.5 : 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: _isHovered ? 0.65 : 0.45),
              blurRadius: _isHovered ? 26 : 14,
              offset: Offset(0, _isHovered ? 12 : 6),
            ),
            if (_isHovered)
              BoxShadow(
                color: const Color(0xFFFBBF24).withValues(alpha: 0.3),
                blurRadius: 18,
              ),
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFC8A951).withValues(alpha: 0.35), width: 1),
            gradient: RadialGradient(
              center: Alignment.center,
              radius: 0.9,
              colors: [
                widget.hat.color.withValues(alpha: 0.4),
                const Color(0xFF0F141A),
              ],
            ),
          ),
          padding: const EdgeInsets.all(14),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Top Index row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'NO. 0${widget.index + 1}',
                    style: const TextStyle(
                      color: Color(0xFFFDE68A),
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const Text('✦', style: TextStyle(color: Color(0xFFFBBF24), fontSize: 13)),
                ],
              ),

              // Hat Illustration
              Expanded(
                child: Center(
                  child: Hero(
                    tag: 'hat_card_${widget.hat.heroTag}',
                    child: HatImage(
                      path: widget.hat.image,
                      height: 125,
                      semanticLabel: widget.hat.title,
                    ),
                  ),
                ),
              ),

              // Title and Call to action
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.hat.title.toUpperCase(),
                    style: const TextStyle(
                      fontFamily: 'Tenada',
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(height: 1.5, width: 48, color: const Color(0xFFC8A951)),
                  const SizedBox(height: 8),
                  Text(
                    'CLICK TO FLIP ↺',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.85),
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),

              // Bottom Index row (inverted)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('✦', style: TextStyle(color: Color(0xFFFBBF24), fontSize: 13)),
                  Text(
                    'CARD 0${widget.index + 1}',
                    style: const TextStyle(
                      color: Color(0xFFFDE68A),
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      _buildSpecularGleam(),
    ],
  ),
);
  }

  Widget _buildCardBack(BuildContext context) {
    return GestureDetector(
      onTap: _toggleFlip,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 255,
            height: 370,
            decoration: BoxDecoration(
          color: const Color(0xFF141922),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFFBBF24), width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.65),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFC8A951).withValues(alpha: 0.4), width: 1),
            color: const Color(0xFF0C1017),
          ),
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.hat.title.toUpperCase(),
                    style: const TextStyle(
                      color: Color(0xFFFBBF24),
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                    ),
                  ),
                  const Icon(Icons.refresh, size: 16, color: Color(0xFFFDE68A)),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                widget.hat.titleDesc,
                style: const TextStyle(
                  color: Color(0xFFFDE68A),
                  fontSize: 12.5,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 10),
              Container(height: 1, color: Colors.white24),
              const SizedBox(height: 10),
              // Body - High contrast and comfortable reading size (fits without nested scroll)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    widget.hat.desc,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13.5,
                      height: 1.5,
                      letterSpacing: 0.15,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  'TAP TO FLIP BACK ↺',
                  style: TextStyle(
                    color: const Color(0xFFFBBF24).withValues(alpha: 0.95),
                    fontSize: 10.5,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      _buildSpecularGleam(),
    ],
  ),
);
  }
}
