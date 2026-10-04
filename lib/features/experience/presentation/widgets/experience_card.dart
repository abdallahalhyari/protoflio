import 'package:flutter/material.dart';

import 'package:profile/core/services/sound_service.dart';
import 'package:profile/core/theme/surface_tone.dart';
import 'package:profile/core/theme/tokens.dart';
import 'package:profile/features/experience/domain/entities/experience.dart';
import 'package:profile/shared/widgets/holographic_physics.dart';

import 'package:profile/features/experience/presentation/widgets/card/experience_card_content.dart';

class ExperienceCard extends StatefulWidget {
  final Experience exp;
  final ColorScheme scheme;
  final bool isDesktop;
  final bool isSelected;
  final VoidCallback? onSelect;

  const ExperienceCard({
    super.key,
    required this.exp,
    required this.scheme,
    required this.isDesktop,
    this.isSelected = false,
    this.onSelect,
  });

  @override
  State<ExperienceCard> createState() => _ExperienceCardState();
}

class _ExperienceCardState extends State<ExperienceCard> {
  bool _hover = false;

  bool get _isCurrent => widget.exp.period.toLowerCase().contains('present');

  String get _watermark {
    if (_isCurrent) return 'NOW';
    final parts = widget.exp.period.split(' ');
    if (parts.isNotEmpty) {
      final last = parts.last;
      if (last.length == 4) return last;
    }
    return widget.exp.company.isNotEmpty
        ? widget.exp.company.substring(0, 1).toUpperCase()
        : '';
  }

  @override
  Widget build(BuildContext context) {
    final scheme = widget.scheme;
    final isDark = context.isDarkMode;
    final reduce = MediaQuery.disableAnimationsOf(context);
    final active = (widget.isSelected || _hover) && !reduce;

    return Semantics(
      container: true,
      label:
          '${widget.exp.role} at ${widget.exp.company}, ${widget.exp.period}',
      explicitChildNodes: true,
      child: GestureDetector(
        excludeFromSemantics: true,
        onTap: () {
          SoundService.instance.playClick();
          widget.onSelect?.call();
          if (!widget.isDesktop) {
            setState(() => _hover = !_hover);
          }
        },
        child: MouseRegion(
          onEnter: (_) => setState(() => _hover = true),
          onExit: (_) => setState(() => _hover = false),
          child: AnimatedScale(
            scale: active ? 1.02 : 1.0,
            duration: AppMotion.cardHover,
            curve: AppMotion.emphasized,
            child: HolographicCardPhysics(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  border: Border.all(
                    color: active
                        ? scheme.primary.withValues(
                            alpha: isDark
                                ? (widget.isSelected ? 0.9 : 0.6)
                                : (widget.isSelected ? 1.0 : 0.8))
                        : (isDark
                            ? context.glassBorderStrong
                            : AppColors.slate200),
                    width: active ? (widget.isSelected ? 2.0 : 1.5) : 1.0,
                  ),
                  boxShadow: active
                      ? [
                          BoxShadow(
                            color: scheme.primary.withValues(
                                alpha: isDark
                                    ? (widget.isSelected ? 0.35 : 0.22)
                                    : (widget.isSelected ? 0.25 : 0.16)),
                            blurRadius: widget.isSelected ? 32 : 24,
                            spreadRadius: widget.isSelected ? 3 : 2,
                          ),
                          BoxShadow(
                            color: isDark
                                ? AppColors.shadowMedium
                                : AppColors.shadowSoft,
                            blurRadius: 12,
                            offset: const Offset(0, 10),
                          ),
                        ]
                      : [
                          BoxShadow(
                              color: isDark
                                  ? AppColors.shadowSoft
                                  : AppColors.slate900.withValues(alpha: 0.04),
                              blurRadius: 10,
                              offset: const Offset(0, 4)),
                        ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: RepaintBoundary(
                          child: AnimatedContainer(
                            duration: AppMotion.cardHover,
                            curve: AppMotion.emphasized,
                            color: active
                                ? context.cardGlassHover
                                : context.cardGlass,
                          ),
                        ),
                      ),
                      Positioned(
                        right: -10,
                        bottom: -20,
                        child: Text(
                          _watermark,
                          style: TextStyle(
                            fontFamily: AppTypography.displayFont,
                            fontSize: widget.isDesktop ? 160 : 90,
                            color: scheme.onSurface
                                .withValues(alpha: isDark ? 0.04 : 0.02),
                            height: 1.0,
                          ),
                        ),
                      ),
                      Builder(
                        builder: (context) {
                          final content = CardContent(
                            exp: widget.exp,
                            scheme: scheme,
                            isDesktop: widget.isDesktop,
                            isCurrent: _isCurrent,
                            isDark: isDark,
                          );

                          return widget.isDesktop
                              ? SingleChildScrollView(
                                  primary: false, child: content)
                              : content;
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
