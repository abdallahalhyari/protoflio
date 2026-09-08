import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../theme/tokens.dart';
import '../model/skill.dart';
import 'app_card.dart';

class SkillTile extends StatefulWidget {
  final Skill skill;
  final Duration delay;

  const SkillTile({
    super.key,
    required this.skill,
    this.delay = Duration.zero,
  });

  @override
  State<SkillTile> createState() => _SkillTileState();
}

class _SkillTileState extends State<SkillTile>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: AppMotion.xxl,
  );
  late final Animation<double> _a =
      CurvedAnimation(parent: _c, curve: Curves.easeOutCubic);

  @override
  void initState() {
    super.initState();
    Future.delayed(widget.delay, () {
      if (mounted) _c.forward();
    });
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final onSurface = scheme.onSurface;
    final isTop = widget.skill.level >= 0.9;
    final card = AppCard.outlined(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md, vertical: AppSpacing.smd),
      child: Row(
        children: [
          Icon(widget.skill.icon, color: onSurface, size: 28),
          const SizedBox(width: AppSpacing.md - 2),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.skill.name,
                      style: TextStyle(
                        color: onSurface,
                        fontSize: AppTypography.bodyLg,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    AnimatedBuilder(
                      animation: _a,
                      builder: (_, __) => Text(
                        '${(widget.skill.level * _a.value * 100).round()}%',
                        style: TextStyle(
                          color: onSurface.withValues(alpha: 0.7),
                          fontSize: AppTypography.small,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Semantics(
                  label: 'skills.proficiency'
                      .tr(namedArgs: {'name': widget.skill.name}),
                  value: 'skills.percent'.tr(namedArgs: {
                    'n': '${(widget.skill.level * 100).round()}'
                  }),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadius.xs),
                    child: AnimatedBuilder(
                      animation: _a,
                      builder: (_, __) => LinearProgressIndicator(
                        value: widget.skill.level * _a.value,
                        minHeight: 6,
                        backgroundColor: onSurface.withValues(alpha: 0.12),
                        valueColor: AlwaysStoppedAnimation(scheme.primary),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    if (!isTop) return card;
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.md),
        boxShadow: [
          BoxShadow(
            color: scheme.primary.withValues(alpha: 0.35),
            blurRadius: 12,
            spreadRadius: -2,
          ),
        ],
        border: Border.all(
            color: scheme.primary.withValues(alpha: 0.55), width: 1.5),
      ),
      child: card,
    );
  }
}
