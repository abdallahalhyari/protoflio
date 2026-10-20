import 'package:flutter/material.dart';

import 'package:profile/core/services/sound_service.dart';
import 'package:profile/core/theme/surface_tone.dart';
import 'package:profile/core/theme/tokens.dart';
import 'package:profile/features/experience/domain/entities/experience.dart';

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
          child: AnimatedContainer(
            duration: AppMotion.cardHover,
            curve: AppMotion.emphasized,
            width: double.infinity,
            decoration: BoxDecoration(
              color: active ? context.cardGlassHover : context.cardGlass,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(
                color: active
                    ? scheme.primary
                        .withValues(alpha: widget.isSelected ? 0.75 : 0.45)
                    : (isDark ? context.glassBorderStrong : AppColors.ink200),
                width: widget.isSelected ? 1.5 : 1.0,
              ),
              boxShadow: [
                if (active)
                  BoxShadow(
                    color: scheme.primary.withValues(
                      alpha: widget.isSelected
                          ? (isDark ? 0.28 : 0.18)
                          : (isDark ? 0.12 : 0.06),
                    ),
                    blurRadius: widget.isSelected ? 20 : 12,
                    spreadRadius: widget.isSelected ? 1.5 : 0,
                    offset: const Offset(0, 3),
                  ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.md),
              child: Row(
                children: [
                  AnimatedContainer(
                    duration: AppMotion.cardHover,
                    width: 3,
                    color: _isCurrent
                        ? AppColors.teal
                        : scheme.primary.withValues(alpha: active ? 0.65 : 0.3),
                  ),
                  Expanded(
                    child: Builder(
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
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
