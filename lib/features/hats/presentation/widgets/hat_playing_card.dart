import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:profile/l10n/app_localizations.dart';
import 'package:profile/core/services/sound_service.dart';
import 'package:profile/core/theme/tokens.dart';
import 'package:profile/shared/widgets/holographic_physics.dart';

import 'package:profile/features/hats/domain/entities/hat_info.dart';
import 'package:profile/features/hats/presentation/utils/hat_labels.dart';

import 'package:profile/features/hats/presentation/widgets/card/hat_card_front_face.dart';
import 'package:profile/features/hats/presentation/widgets/card/hat_card_back_face.dart';

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

class _HatPlayingCardState extends State<HatPlayingCard>
    with TickerProviderStateMixin {
  late AnimationController _flipController;
  late Animation<double> _flipAnimation;
  late AnimationController _entranceController;
  late Animation<double> _entranceAnimation;
  bool _isFlipped = false;
  bool _isHovered = false;
  final ValueNotifier<Offset> _tiltOffset = ValueNotifier(Offset.zero);
  late Offset _currentOffset;
  final ValueNotifier<double> _rotationDelta = ValueNotifier(0.0);

  Timer? _delayTimer;

  @override
  void initState() {
    super.initState();
    _currentOffset = widget.position;
    _flipController = AnimationController(
      vsync: this,
      duration: AppMotion.cardFlip,
    );
    _flipAnimation = Tween<double>(begin: 0.0, end: math.pi).animate(
      CurvedAnimation(parent: _flipController, curve: Curves.easeInOutBack),
    );
    _entranceController = AnimationController(
      vsync: this,
      duration: AppMotion.cardFlip,
    );
    _entranceAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
          parent: _entranceController, curve: AppMotion.emphasizedDecel),
    );

    // Stagger the entrance based on the card index
    final int delay = widget.index * 80;
    _delayTimer = Timer(Duration(milliseconds: delay), () {
      if (mounted) _entranceController.forward();
    });
  }

  @override
  void didUpdateWidget(HatPlayingCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.position != widget.position) {
      _currentOffset = widget.position;
    }
    if (oldWidget.rotation != widget.rotation) {
      _rotationDelta.value = 0.0;
    }
  }

  @override
  void dispose() {
    _delayTimer?.cancel();
    _flipController.dispose();
    _entranceController.dispose();
    _tiltOffset.dispose();
    _rotationDelta.dispose();
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

  @override
  Widget build(BuildContext context) => MediaQuery.withClampedTextScaling(
        maxScaleFactor: 1.35,
        child: Builder(builder: _buildCard),
      );

  Widget _buildCard(BuildContext context) {
    final reduce = MediaQuery.disableAnimationsOf(context);
    final cardContent = GestureDetector(
      onPanStart:
          widget.isStandalone ? null : (_) => widget.onDragStart?.call(),
      onPanUpdate: widget.isStandalone
          ? null
          : (details) {
              _rotationDelta.value += details.delta.dx * 0.006;
            },
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
            final next = Offset(nx, ny);
            if ((next - _tiltOffset.value).distanceSquared < 0.005) return;
            _tiltOffset.value = next;
          }
        },
        onExit: (_) {
          setState(() => _isHovered = false);
          if (_tiltOffset.value != Offset.zero) {
            _tiltOffset.value = Offset.zero;
          }
        },
        child: HolographicCardPhysics(
          maxTiltAngle: 0.25,
          enableGlare: false,
          child: Builder(
            builder: (context) {
              final Widget frontCard = CardFrontFace(
                hat: widget.hat,
                index: widget.index,
                isHovered: _isHovered,
                isStandalone: widget.isStandalone,
                tiltOffset: _tiltOffset,
                onTap: _toggleFlip,
              );
              final Widget backCard = Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()..rotateY(math.pi),
                child: CardBackFace(
                  hat: widget.hat,
                  isHovered: _isHovered,
                  tiltOffset: _tiltOffset,
                  onTap: _toggleFlip,
                ),
              );

              return AnimatedBuilder(
                animation: Listenable.merge(
                    [_flipAnimation, _rotationDelta, _entranceAnimation]),
                builder: (context, _) {
                  final angle = _flipAnimation.value;
                  final entranceAngle =
                      reduce ? 0.0 : _entranceAnimation.value * math.pi;
                  final isUnder = angle > math.pi / 2;
                  return AnimatedSlide(
                    offset: Offset(0, (_isHovered && !reduce) ? -0.03 : 0.0),
                    duration: AppMotion.cardHover,
                    curve: AppMotion.emphasizedDecel,
                    child: ExcludeSemantics(
                      excluding: !isUnder,
                      child: Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()
                          ..rotateZ(widget.isStandalone
                              ? 0.0
                              : widget.rotation + _rotationDelta.value)
                          ..setEntry(3, 2, 0.0015)
                          ..rotateY(angle + entranceAngle),
                        child: RepaintBoundary(
                          child: isUnder ? backCard : frontCard,
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );

    final semantics = Semantics(
      button: true,
      label:
          '${hatTitleLabel(AppLocalizations.of(context)!, widget.hat.title)} role card. Tap to flip; drag to rotate.',
      child: cardContent,
    );

    if (widget.isStandalone) {
      return FittedBox(
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
}
