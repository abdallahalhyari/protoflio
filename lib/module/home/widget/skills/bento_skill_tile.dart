import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../service/sound_service.dart';
import '../../../../theme/surface_tone.dart';
import '../../../../theme/tokens.dart';
import '../../model/skill.dart';
import '../holographic_physics.dart';

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

class _BentoSkillTileState extends State<BentoSkillTile> with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: AppMotion.cardFlip,
  );
  late final Animation<double> _flipAnim = CurvedAnimation(parent: _c, curve: Curves.easeOutBack);

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

  String _masteryLabel(double level) {
    if (level >= 0.9) return 'LEAD';
    if (level >= 0.75) return 'CORE';
    if (level >= 0.55) return 'SOLID';
    return 'GROWING';
  }

  @override
  Widget build(BuildContext context) {
    final Widget frontCard = _buildFront();
    final Widget backCard = Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()..rotateY(math.pi),
      child: _buildBack(),
    );

    return HolographicCardPhysics(
      borderRadius: 14,
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

            return Transform(
              alignment: Alignment.center,
              transform: transform,
              child: isBack ? backCard : frontCard,
            );
          },
        ),
        ),
      ),
    );
  }

  Widget _buildFront() {
    final isDark = context.isDarkMode;
    final accentText = context.adaptiveAccentText(widget.categoryColor);
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceElevated : Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(
          color: widget.categoryColor.withValues(alpha: isDark ? 0.3 : 0.4),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? widget.categoryColor.withValues(alpha: 0.1)
                : AppColors.slate900.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 4,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: widget.categoryGradient),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(widget.isDesktop ? 16.0 : 12.0),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.center,
                  child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        padding: EdgeInsets.all(widget.isDesktop ? 12 : 6),
                        decoration: BoxDecoration(
                          color: widget.categoryColor.withValues(alpha: isDark ? 0.15 : 0.10),
                          shape: BoxShape.circle,
                          border: Border.all(color: widget.categoryColor.withValues(alpha: isDark ? 0.3 : 0.4)),
                        ),
                        child: Icon(widget.skill.icon, color: accentText, size: widget.isDesktop ? 36 : 20),
                      ),
                      SizedBox(height: widget.isDesktop ? 16 : 8),
                      Text(
                        widget.skill.name.toUpperCase(),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: AppTypography.displayFont,
                          color: isDark ? Colors.white : AppColors.slate900,
                          fontSize: widget.isDesktop ? 22 : 14,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.2,
                        ),
                      ),
                      SizedBox(height: widget.isDesktop ? 8 : 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: widget.categoryColor.withValues(alpha: isDark ? 0.2 : 0.12),
                          borderRadius: BorderRadius.circular(AppRadius.xs),
                        ),
                        child: Text(
                          _masteryLabel(widget.skill.level),
                          style: TextStyle(
                            fontFamily: AppTypography.monoFont,
                            color: accentText,
                            fontSize: widget.isDesktop ? 11 : 9,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                      SizedBox(height: widget.isDesktop ? 10 : 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.05)
                              : Colors.black.withValues(alpha: 0.04),
                          borderRadius: BorderRadius.circular(AppRadius.pill),
                          border: Border.all(
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.12)
                                : AppColors.slate300,
                            width: 0.8,
                          ),
                        ),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.touch_app_outlined,
                                size: 11,
                                color: isDark
                                    ? Colors.white.withValues(alpha: 0.6)
                                    : AppColors.slate500,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'TAP TO FLIP ↺',
                                style: TextStyle(
                                  fontFamily: AppTypography.monoFont,
                                  color: isDark
                                      ? Colors.white.withValues(alpha: 0.6)
                                      : AppColors.slate500,
                                  fontSize: widget.isDesktop ? 9.5 : 10,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.8,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBack() {
    final isDark = context.isDarkMode;
    final accentText = context.adaptiveAccentText(widget.categoryColor);
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: widget.categoryColor, width: 2),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? widget.categoryColor.withValues(alpha: 0.3)
                : AppColors.slate900.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 4,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: widget.categoryGradient),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(widget.isDesktop ? 16.0 : 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(widget.skill.icon, color: accentText, size: widget.isDesktop ? 20 : 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            widget.skill.name.toUpperCase(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: AppTypography.displayFont,
                              color: isDark ? Colors.white : AppColors.slate900,
                              fontSize: widget.isDesktop ? 16 : 13,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                          decoration: BoxDecoration(
                            color: widget.categoryColor.withValues(alpha: isDark ? 0.12 : 0.10),
                            borderRadius: BorderRadius.circular(AppRadius.xs),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.flip_to_front_rounded, size: 10, color: accentText),
                              const SizedBox(width: 3),
                              Text(
                                'FLIP',
                                style: TextStyle(
                                  fontFamily: AppTypography.monoFont,
                                  color: accentText,
                                  fontSize: AppTypography.micro,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: widget.isDesktop ? 12 : 8),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Text(
                          widget.skill.description,
                          style: TextStyle(
                            color: isDark ? Colors.white.withValues(alpha: 0.85) : AppColors.slate700,
                            fontSize: widget.isDesktop ? 12 : 10.5,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ),
                    if (widget.skill.tags.isNotEmpty) ...[
                      SizedBox(height: widget.isDesktop ? 12 : 8),
                      Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        children: [
                          for (final tag in widget.skill.tags)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2.5),
                              decoration: BoxDecoration(
                                color: isDark ? Colors.white.withValues(alpha: 0.08) : AppColors.slate100,
                                borderRadius: BorderRadius.circular(AppRadius.xs),
                                border: Border.all(color: isDark ? Colors.white24 : AppColors.slate200),
                              ),
                              child: Text(
                                tag,
                                style: TextStyle(
                                  fontFamily: AppTypography.monoFont,
                                  color: isDark ? widget.categoryColor.withValues(alpha: 0.9) : context.adaptiveAccentText(widget.categoryColor),
                                  fontSize: widget.isDesktop ? 9.5 : 8.0,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
