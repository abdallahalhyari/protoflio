import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../../../theme/tokens.dart';
import '../model/experience.dart';

class ExperienceTile extends StatefulWidget {
  final Experience exp;
  final bool isFirst;
  final bool isLast;
  final int index;
  final bool isVisible;

  const ExperienceTile({
    super.key,
    required this.exp,
    this.isFirst = false,
    this.isLast = false,
    this.index = 0,
    this.isVisible = true,
  });

  @override
  State<ExperienceTile> createState() => _ExperienceTileState();
}

class _ExperienceTileState extends State<ExperienceTile> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    
    return FadeInUp(
      animate: widget.isVisible,
      delay: Duration(milliseconds: 100 * widget.index),
      duration: const Duration(milliseconds: 600),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _Timeline(
              color: scheme.primary,
              isFirst: widget.isFirst,
              isLast: widget.isLast,
              isHovered: _isHovered,
            ),
            const SizedBox(width: AppSpacing.md - 2),
            Expanded(
              child: MouseRegion(
                onEnter: (_) => setState(() => _isHovered = true),
                onExit: (_) => setState(() => _isHovered = false),
                child: AnimatedScale(
                  scale: _isHovered ? 1.02 : 1.0,
                  duration: AppMotion.sm,
                  curve: Curves.easeOut,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: AppSpacing.lg - 4),
                    child: RepaintBoundary(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: AnimatedContainer(
                          duration: AppMotion.sm,
                          padding: const EdgeInsets.all(AppSpacing.md),
                          decoration: BoxDecoration(
                            color: _isHovered 
                                ? scheme.onSurface.withValues(alpha: 0.1) 
                                : (Theme.of(context).brightness == Brightness.dark 
                                    ? Colors.black.withValues(alpha: 0.25)
                                    : Colors.white.withValues(alpha: 0.5)),
                            borderRadius: BorderRadius.circular(AppRadius.md),
                            border: Border.all(
                              color: _isHovered 
                                  ? scheme.primary.withValues(alpha: 0.5) 
                                  : (Theme.of(context).brightness == Brightness.dark ? Colors.white24 : Colors.black12),
                              width: 1,
                            ),
                            boxShadow: [
                              if (_isHovered)
                                BoxShadow(
                                  color: scheme.primary.withValues(alpha: 0.15),
                                  blurRadius: 15,
                                  spreadRadius: 2,
                                )
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      widget.exp.role,
                                      style: TextStyle(
                                        fontSize: AppTypography.titleSm,
                                        fontWeight: FontWeight.w800,
                                        color: scheme.onSurface,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    widget.exp.period,
                                    style: TextStyle(
                                      fontSize: AppTypography.caption,
                                      color: scheme.onSurface.withValues(alpha: 0.6),
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppSpacing.xs / 2),
                              Text(
                                widget.exp.company,
                                style: TextStyle(
                                  fontSize: AppTypography.body,
                                  fontWeight: FontWeight.w600,
                                  color: scheme.primary,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.sm),
                              ...widget.exp.highlights.map(
                                (h) => Padding(
                                  padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(top: AppSpacing.sm - 2),
                                        child: Icon(
                                          Icons.circle,
                                          size: 5,
                                          color: scheme.onSurface.withValues(alpha: 0.5),
                                        ),
                                      ),
                                      const SizedBox(width: AppSpacing.sm),
                                      Expanded(
                                        child: Text(
                                          h,
                                          style: TextStyle(
                                            fontSize: AppTypography.small,
                                            height: 1.4,
                                            color: scheme.onSurface.withValues(alpha: 0.85),
                                          ),
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
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Timeline extends StatelessWidget {
  final Color color;
  final bool isFirst;
  final bool isLast;
  final bool isHovered;

  const _Timeline({
    required this.color,
    required this.isFirst,
    required this.isLast,
    this.isHovered = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 14,
      child: Column(
        children: [
          Expanded(
            flex: 0,
            child: SizedBox(
              height: 14,
              child: isFirst
                  ? const SizedBox.shrink()
                  : Container(width: 2, color: color.withValues(alpha: 0.35)),
            ),
          ),
          AnimatedContainer(
            duration: AppMotion.sm,
            width: isHovered ? 14 : 12,
            height: isHovered ? 14 : 12,
            decoration: BoxDecoration(
              color: color, 
              shape: BoxShape.circle,
              boxShadow: [
                if (isHovered)
                  BoxShadow(
                    color: color, // Full glow
                    blurRadius: 12,
                    spreadRadius: 4,
                  )
                else
                  BoxShadow(
                    color: color.withValues(alpha: 0.4),
                    blurRadius: 4,
                    spreadRadius: 1,
                  )
              ]
            ),
          ),
          Expanded(
            child: isLast
                ? const SizedBox.shrink()
                : Container(width: 2, color: color.withValues(alpha: 0.35)),
          ),
        ],
      ),
    );
  }
}
