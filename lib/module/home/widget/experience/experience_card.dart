import 'package:flutter/material.dart';

import '../../../../service/sound_service.dart';
import '../../../../theme/tokens.dart';
import '../../model/experience.dart';

const _kNowAccent = Color(0xFF10B981); // Emerald green for "Present"
const _kGlassBorder = Color(0x33FFFFFF);

class ExperienceCard extends StatefulWidget {
  final Experience exp;
  final ColorScheme scheme;
  final bool isDesktop;

  const ExperienceCard({
    super.key,
    required this.exp,
    required this.scheme,
    required this.isDesktop,
  });

  @override
  State<ExperienceCard> createState() => _ExperienceCardState();
}

class _ExperienceCardState extends State<ExperienceCard> {
  bool _hover = false;

  bool get _isCurrent => widget.exp.period.toLowerCase().contains('present');

  // Extract a single large year to act as a watermark (e.g. "2024" or "PRESENT")
  String get _watermark {
    if (_isCurrent) return 'NOW';
    final parts = widget.exp.period.split(' ');
    if (parts.isNotEmpty) {
      final last = parts.last;
      if (last.length == 4) return last; // likely a year
    }
    return widget.exp.company.isNotEmpty ? widget.exp.company.substring(0, 1).toUpperCase() : '';
  }

  @override
  Widget build(BuildContext context) {
    final scheme = widget.scheme;
    final isDark = scheme.brightness == Brightness.dark;
    final reduce = MediaQuery.disableAnimationsOf(context);
    final hovered = _hover && !reduce;

    return GestureDetector(
      onTap: () {
        SoundService.instance.playClick();
        setState(() => _hover = !_hover);
      },
      child: MouseRegion(
        onEnter: (_) => setState(() => _hover = true),
        onExit: (_) => setState(() => _hover = false),
        child: AnimatedScale(
          scale: hovered ? 1.02 : 1.0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(
              color: hovered
                  ? scheme.primary.withValues(alpha: isDark ? 0.6 : 0.8)
                  : (isDark ? _kGlassBorder : AppColors.slate200),
              width: hovered ? 1.5 : 1.0,
            ),
            boxShadow: hovered
                ? [
                    BoxShadow(color: scheme.primary.withValues(alpha: isDark ? 0.15 : 0.12), blurRadius: 20, spreadRadius: 2),
                    BoxShadow(color: isDark ? Colors.black.withValues(alpha: 0.4) : AppColors.slate900.withValues(alpha: 0.08), blurRadius: 10, offset: const Offset(0, 8)),
                  ]
                : [
                    BoxShadow(color: isDark ? Colors.black.withValues(alpha: 0.2) : AppColors.slate900.withValues(alpha: 0.04), blurRadius: 10, offset: const Offset(0, 4)),
                  ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            child: Stack(
                children: [
                  // Glass background fill
                  Positioned.fill(
                    child: RepaintBoundary(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        color: isDark
                            ? (hovered ? scheme.surface.withValues(alpha: 0.35) : scheme.surface.withValues(alpha: 0.2))
                            : (hovered ? Colors.white.withValues(alpha: 0.95) : Colors.white.withValues(alpha: 0.88)),
                      ),
                    ),
                  ),

                  // Watermark
                  Positioned(
                    right: -10,
                    bottom: -20,
                    child: Text(
                      _watermark,
                      style: TextStyle(
                        fontFamily: AppTypography.displayFont,
                        fontSize: widget.isDesktop ? 160 : 90,
                        color: scheme.onSurface.withValues(alpha: 0.04),
                        height: 1.0,
                      ),
                    ),
                  ),

                  // Content
                  Builder(
                    builder: (context) {
                      final content = Padding(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Top row: Period and Latest Dispatch
                            Wrap(
                              spacing: 8,
                              runSpacing: 6,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: scheme.primary.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(AppRadius.xs),
                                  ),
                                  child: Text(
                                    widget.exp.period.toUpperCase(),
                                    style: TextStyle(color: scheme.primary, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1),
                                  ),
                                ),
                                if (_isCurrent) ...[
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: _kNowAccent.withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(AppRadius.xs),
                                      border: Border.all(color: _kNowAccent.withValues(alpha: 0.5)),
                                    ),
                                    child: const Text(
                                      'LATEST DISPATCH',
                                      style: TextStyle(color: _kNowAccent, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1),
                                    ),
                                  ),
                                ]
                              ],
                            ),
                            const SizedBox(height: 14),

                            // Role & Company
                            Text(
                              widget.exp.company,
                              style: TextStyle(
                                fontFamily: AppTypography.displayFont,
                                color: scheme.onSurface,
                                fontSize: widget.isDesktop ? 28 : 22,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 2,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.exp.role.toUpperCase(),
                              style: TextStyle(
                                color: scheme.primary,
                                fontSize: widget.isDesktop ? 14 : 12.5,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.5,
                              ),
                            ),

                            const SizedBox(height: 16),

                            // Highlights
                            ...widget.exp.highlights.map((h) => _buildHighlight(h, scheme)),
                          ],
                        ),
                      );

                      return widget.isDesktop
                          ? SingleChildScrollView(primary: false, child: content)
                          : content;
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHighlight(String highlight, ColorScheme scheme) {
    final isDark = scheme.brightness == Brightness.dark;
    final int colonIndex = highlight.indexOf(':');
    final bool hasColon = colonIndex != -1;
    final String prefix = hasColon ? highlight.substring(0, colonIndex + 1) : '';
    final String rest = hasColon ? highlight.substring(colonIndex + 1) : highlight;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: scheme.primary,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: hasColon
                ? Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: prefix,
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            color: isDark ? scheme.onSurface : AppColors.slate900,
                            fontSize: 13.5,
                            height: 1.5,
                          ),
                        ),
                        TextSpan(
                          text: rest,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: isDark ? scheme.onSurface.withValues(alpha: 0.85) : AppColors.slate700,
                            fontSize: 13.5,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  )
                : Text(
                    highlight,
                    style: TextStyle(
                      color: isDark ? scheme.onSurface.withValues(alpha: 0.85) : AppColors.slate700,
                      fontSize: 13.5,
                      height: 1.5,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
