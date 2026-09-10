import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../service/sound_service.dart';
import '../../../theme/tokens.dart';
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
  // Additive rotation applied on top of `widget.rotation` when the user
  // drags the card. Drag now rotates in place instead of translating,
  // so `_currentOffset` never changes during a pan.
  double _rotationDelta = 0.0;

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
    // External rotation change (parent shuffle / reset) — clear the
    // local drag delta so the card lands exactly where the parent asked.
    if (oldWidget.rotation != widget.rotation) {
      _rotationDelta = 0.0;
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
    final reduce = MediaQuery.of(context).disableAnimations;
    final cardContent = GestureDetector(
      onPanStart: widget.isStandalone ? null : (_) => widget.onDragStart?.call(),
      onPanUpdate: widget.isStandalone
          ? null
          : (details) {
              // Rotate in place: horizontal drag = spin around the card
              // center. Position (`_currentOffset`) is intentionally left
              // untouched so the card doesn't slide across the felt.
              setState(() {
                _rotationDelta += details.delta.dx * 0.006;
              });
            },
      // Position never changes during drag, so we still report the
      // original offset to the parent — it just persists whatever
      // position the card had at deal time.
      onPanEnd: widget.isStandalone
          ? null
          : (_) => widget.onDragEnd?.call(_currentOffset),
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
            // reduce-motion strips the hover lift + parallax tilt so the
            // card sits flat when the user requests less motion.
            final double hoverLift = (_isHovered && !reduce) ? -10.0 : 0.0;
            final double tiltX =
                (_isHovered && !reduce) ? -_tiltOffset.dy * 0.16 : 0.0;
            final double tiltY =
                (_isHovered && !reduce) ? _tiltOffset.dx * 0.20 : 0.0;

            return Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..translateByDouble(0.0, hoverLift, 0.0, 1.0)
                ..rotateZ(widget.isStandalone
                    ? 0.0
                    : widget.rotation + _rotationDelta)
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

    // Screen readers announce the card as a button + its role title so
    // gesture-only drag isn't the only affordance.
    final semantics = Semantics(
      button: true,
      label: '${widget.hat.title} role card. Tap to flip; drag to rotate.',
      child: cardContent,
    );

    if (widget.isStandalone) {
      // Standalone mode is used by the mobile Hats page (single card
      // showcase). Wrap the fixed-size card in a FittedBox so it
      // scales down when the viewport is narrower than 255px or the
      // available height is under 370px, instead of overflowing.
      return FittedBox(
        fit: BoxFit.contain,
        child: SizedBox(
          width: 255,
          height: 370,
          child: semantics,
        ),
      );
    }

    return Positioned(
      left: _currentOffset.dx,
      top: _currentOffset.dy,
      child: semantics,
    );
  }

  Widget _buildCardFront(BuildContext context) {
    final accent = widget.hat.color;
    final ordinal = (widget.index + 1).toString().padLeft(2, '0');
    return GestureDetector(
      onTap: _toggleFlip,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 255,
            height: 370,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: _isHovered
                    ? accent.withValues(alpha: 1)
                    : accent.withValues(alpha: 0.55),
                width: _isHovered ? 2.2 : 1.4,
              ),
              // Single-layer gradient reads cleaner than the old
              // nested containers/gradients.
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF141B2A),
                  const Color(0xFF0A0F1A),
                  accent.withValues(alpha: 0.22),
                ],
                stops: const [0.0, 0.55, 1.0],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black
                      .withValues(alpha: _isHovered ? 0.72 : 0.55),
                  blurRadius: _isHovered ? 30 : 18,
                  offset: Offset(0, _isHovered ? 14 : 8),
                ),
                BoxShadow(
                  color: accent.withValues(alpha: _isHovered ? 0.45 : 0.28),
                  blurRadius: _isHovered ? 24 : 16,
                  spreadRadius: 1,
                ),
              ],
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Header: ordinal (left) + accent dot (right). Kills the
                // old duplicate "NO. 0X" + "CARD 0X" pair.
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ordinal,
                          style: const TextStyle(
                            fontFamily: 'Tenada',
                            color: AppColors.accentAmberSoft,
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            height: 1,
                            letterSpacing: 1,
                          ),
                        ),
                        Text(
                          'ROLE',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.6),
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 3,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: accent,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: accent.withValues(alpha: 0.65),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Hat image — larger, no nested wrapper, subtle
                // top-to-bottom vignette straight on the card gradient.
                Expanded(
                  child: Center(
                    child: Hero(
                      tag: 'hat_card_${widget.hat.heroTag}',
                      child: HatImage(
                        path: widget.hat.image,
                        height: 148,
                        semanticLabel: widget.hat.title,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.hat.title.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Tenada',
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2.2,
                  ),
                ),
                const SizedBox(height: 6),
                // Accent under-rule — width scales with the title font.
                Container(
                  height: 1.5,
                  width: 64,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        accent.withValues(alpha: 0),
                        accent,
                        accent.withValues(alpha: 0),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // Single meta row — was two rows previously.
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.touch_app_outlined,
                        size: 12, color: Colors.white.withValues(alpha: 0.60)),
                    Text(
                      'TAP TO FLIP',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.82),
                        fontSize: 10.5,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.8,
                      ),
                    ),
                    Icon(Icons.autorenew,
                        size: 12, color: Colors.white.withValues(alpha: 0.60)),
                  ],
                ),
              ],
            ),
          ),
          _buildSpecularGleam(),
        ],
      ),
    );
  }

  Widget _buildCardBack(BuildContext context) {
    final accent = widget.hat.color;
    return GestureDetector(
      onTap: _toggleFlip,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 255,
            height: 370,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              // Border now uses the hat's own accent instead of the
              // universal yellow — makes the back read as the "same
              // card" flipped rather than a different card entirely.
              border: Border.all(color: accent.withValues(alpha: 0.65), width: 1.4),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF0A0F1A),
                  accent.withValues(alpha: 0.14),
                  const Color(0xFF141B2A),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.65),
                  blurRadius: 22,
                  offset: const Offset(0, 10),
                ),
                BoxShadow(
                  color: accent.withValues(alpha: 0.28),
                  blurRadius: 18,
                  spreadRadius: 1,
                ),
              ],
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header: kicker `REVERSE · <title>` + flip icon.
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text.rich(
                        TextSpan(children: [
                          TextSpan(
                            text: 'REVERSE · ',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.5),
                              fontSize: 11,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 2,
                            ),
                          ),
                          TextSpan(
                            text: widget.hat.title.toUpperCase(),
                            style: TextStyle(
                              color: accent,
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.8,
                            ),
                          ),
                        ]),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Icon(Icons.autorenew,
                        size: 14,
                        color: Colors.white.withValues(alpha: 0.6)),
                  ],
                ),
                const SizedBox(height: 10),
                // Under-rule tinted with the accent.
                Container(
                  height: 1,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        accent.withValues(alpha: 0.7),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Tagline block — subtle left-border accent, no amber
                // battle with the body text below.
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.04),
                    borderRadius: BorderRadius.circular(6),
                    border: Border(
                      left: BorderSide(color: accent, width: 2.5),
                    ),
                  ),
                  child: Text(
                    widget.hat.titleDesc,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      height: 1.4,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Body description.
                Expanded(
                  child: Text(
                    widget.hat.desc,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.92),
                      fontSize: 12.5,
                      height: 1.55,
                      letterSpacing: 0.15,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // Single meta row mirrors the front's affordance.
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.autorenew,
                        size: 12,
                        color: Colors.white.withValues(alpha: 0.55)),
                    Text(
                      'TAP TO RETURN',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.82),
                        fontSize: 10.5,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.8,
                      ),
                    ),
                    Icon(Icons.touch_app_outlined,
                        size: 12,
                        color: Colors.white.withValues(alpha: 0.55)),
                  ],
                ),
              ],
            ),
          ),
          _buildSpecularGleam(),
        ],
      ),
    );
  }
}
