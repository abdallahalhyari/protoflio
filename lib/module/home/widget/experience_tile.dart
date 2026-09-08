import 'package:flutter/material.dart';
import '../../../theme/tokens.dart';
import '../model/experience.dart';

class ExperienceTile extends StatelessWidget {
  final Experience exp;
  final bool isFirst;
  final bool isLast;

  const ExperienceTile({
    super.key,
    required this.exp,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _Timeline(
            color: scheme.primary,
            isFirst: isFirst,
            isLast: isLast,
          ),
          const SizedBox(width: AppSpacing.md - 2),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.lg - 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          exp.role,
                          style: TextStyle(
                            fontSize: AppTypography.titleSm,
                            fontWeight: FontWeight.w800,
                            color: scheme.onSurface,
                          ),
                        ),
                      ),
                      Text(
                        exp.period,
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
                    exp.company,
                    style: TextStyle(
                      fontSize: AppTypography.body,
                      fontWeight: FontWeight.w600,
                      color: scheme.primary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  ...exp.highlights.map(
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
                                color:
                                    scheme.onSurface.withValues(alpha: 0.85),
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
        ],
      ),
    );
  }
}

class _Timeline extends StatelessWidget {
  final Color color;
  final bool isFirst;
  final bool isLast;

  const _Timeline({
    required this.color,
    required this.isFirst,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 14,
      child: Column(
        children: [
          SizedBox(
            height: 6,
            child: isFirst
                ? const SizedBox.shrink()
                : Container(width: 2, color: color.withValues(alpha: 0.35)),
          ),
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
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
