import 'dart:math' as math;
import 'package:flutter/material.dart';

import 'package:profile/l10n/app_localizations.dart';
import 'package:profile/core/services/sound_service.dart';
import 'package:profile/core/theme/tokens.dart';
import 'package:profile/features/skills/domain/entities/skill.dart';
import 'package:profile/shared/widgets/holographic_physics.dart';

import 'package:profile/features/skills/presentation/widgets/tile/bento_skill_tile_shared.dart';
import 'package:profile/features/skills/presentation/widgets/tile/bento_skill_tile_front.dart';
import 'package:profile/features/skills/presentation/widgets/tile/bento_skill_tile_back.dart';

class BentoSkillTile extends StatefulWidget {
  final Skill skill;
  final Color categoryColor;
  final List<Color> categoryGradient;
  final bool isDesktop;

  const BentoSkillTile({
    super.key,
    required this.skill,
    required this.categoryColor,
    required this.categoryGradient,
    required this.isDesktop,
  });

  @override
  State<BentoSkillTile> createState() => _BentoSkillTileState();
}

class _BentoSkillTileState extends State<BentoSkillTile>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  bool _showFocus = false;
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: AppMotion.cardFlip,
  );
  late final Animation<double> _flipAnim =
      CurvedAnimation(parent: _c, curve: Curves.easeOutBack);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  void _onHover(bool isHovered) {
    if (isHovered == _isHovered) return;
    setState(() => _isHovered = isHovered);
    if (isHovered) {
      _c.forward();
    } else {
      _c.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final Widget frontCard = TileFrontFace(
      skill: widget.skill,
      categoryColor: widget.categoryColor,
      categoryGradient: widget.categoryGradient,
      isDesktop: widget.isDesktop,
      isHovered: _isHovered,
      showFocus: _showFocus,
    );
    final Widget backCard = Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()..rotateY(math.pi),
      child: TileBackFace(
        skill: widget.skill,
        categoryColor: widget.categoryColor,
        categoryGradient: widget.categoryGradient,
        isDesktop: widget.isDesktop,
      ),
    );

    return Semantics(
      button: true,
      label: loc.skillCardSemantics(
        widget.skill.name,
        masteryLabel(widget.skill.level, loc),
      ),
      child: HolographicCardPhysics(
        borderRadius: AppRadius.tile,
        child: FocusableActionDetector(
          actions: <Type, Action<Intent>>{
            ActivateIntent: CallbackAction<ActivateIntent>(
              onInvoke: (_) {
                SoundService.instance.playClick();
                _onHover(!_isHovered);
                return null;
              },
            ),
          },
          onShowFocusHighlight: (show) {
            if (show != _showFocus) setState(() => _showFocus = show);
          },
          onFocusChange: (focused) {
            if (!focused) _onHover(false);
          },
          child: MouseRegion(
            onEnter: (_) => _onHover(true),
            onExit: (_) => _onHover(false),
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {
                SoundService.instance.playClick();
                _onHover(!_isHovered);
              },
              child: AnimatedBuilder(
                animation: _flipAnim,
                builder: (context, child) {
                  final isBack = _flipAnim.value >= 0.5;
                  final angle = _flipAnim.value * math.pi;

                  final transform = Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..rotateY(angle);

                  return ExcludeSemantics(
                    excluding: !isBack,
                    child: Transform(
                      alignment: Alignment.center,
                      transform: transform,
                      child: isBack ? backCard : frontCard,
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
