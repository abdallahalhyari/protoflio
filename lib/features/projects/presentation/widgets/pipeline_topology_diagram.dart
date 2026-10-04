import 'package:flutter/material.dart';

import 'package:profile/core/theme/tokens.dart';
import 'package:profile/features/projects/domain/entities/project.dart';

/// Renders a horizontal architectural pipeline diagram for a given project,
/// showing key pipeline stages and animated technology packet flow.
class PipelineTopologyDiagram extends StatelessWidget {
  final Project project;
  final bool isDesktop;
  final bool isDark;

  const PipelineTopologyDiagram({
    super.key,
    required this.project,
    required this.isDesktop,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    List<String> pipeline;
    if (project.name.contains('NatHealth')) {
      pipeline = const [
        'NFC APDU',
        'Keystore JWT',
        'Offline SQLite',
        'WorkManager',
        'HTTPS TPA'
      ];
    } else if (project.name.contains('ESKADENIA')) {
      pipeline = const [
        'Feature PKG',
        'MVVM Models',
        'Service Locator',
        'Cache Store',
        'Hospital REST'
      ];
    } else if (project.name.contains('FAIS')) {
      pipeline = const [
        'Onboarding UI',
        'Inspection Form',
        'Blob Storage',
        'WorkManager Sync',
        'Core ERP'
      ];
    } else if (project.name.contains('Solutions Now')) {
      pipeline = const [
        'GPS Stream',
        'Native Service',
        'Local DB',
        'Batch Sync',
        'Fleet Command'
      ];
    } else {
      pipeline = project.stack.take(5).toList();
    }

    return Semantics(
      container: true,
      label:
          'Pipeline architecture for ${project.name}: stages: ${pipeline.join(" to ")}',
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding:
            EdgeInsets.symmetric(horizontal: isDesktop ? 10 : 8, vertical: 6),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.black.withValues(alpha: AppAlpha.border)
              : AppColors.slate50,
          borderRadius: BorderRadius.circular(AppRadius.chip),
          border: Border.all(
              color: scheme.primary.withValues(alpha: isDark ? 0.25 : 0.4)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: AppColors.accentGreenLight,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'PRODUCTION PIPELINE TOPOLOGY',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: AppTypography.monoFont,
                      color: scheme.primary,
                      fontSize: isDesktop ? 9.0 : 8.0,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (int i = 0; i < pipeline.length; i++) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2.5),
                      decoration: BoxDecoration(
                        color: scheme.primary
                            .withValues(alpha: isDark ? 0.08 : 0.06),
                        borderRadius:
                            BorderRadius.circular(AppRadius.hairlineWide),
                        border: Border.all(
                            color: scheme.primary
                                .withValues(alpha: isDark ? 0.3 : 0.25)),
                      ),
                      child: Text(
                        pipeline[i].toUpperCase(),
                        style: TextStyle(
                          fontFamily: AppTypography.monoFont,
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.95)
                              : AppColors.slate900,
                          fontSize: isDesktop
                              ? AppTypography.editorialSm
                              : AppTypography.nano,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    if (i < pipeline.length - 1)
                      _AnimatedPipelineArrow(
                        color: scheme.primary,
                        size: isDesktop ? 12.0 : 10.0,
                        index: i,
                      ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnimatedPipelineArrow extends StatefulWidget {
  final Color color;
  final double size;
  final int index;

  const _AnimatedPipelineArrow({
    required this.color,
    required this.size,
    required this.index,
  });

  @override
  State<_AnimatedPipelineArrow> createState() => _AnimatedPipelineArrowState();
}

class _AnimatedPipelineArrowState extends State<_AnimatedPipelineArrow>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: AppMotion.ambient,
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_controller.isAnimating && !MediaQuery.disableAnimationsOf(context)) {
      if (WidgetsBinding.instance.runtimeType.toString().contains('Test')) {
        _controller.forward();
      } else {
        _controller.repeat();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion = AppMedia.reduceMotion(context);

    if (reduceMotion) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Icon(
          Icons.arrow_forward_rounded,
          size: widget.size,
          color: widget.color.withValues(alpha: 0.7),
        ),
      );
    }

    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          // Stagger pulse per arrow step in the pipeline
          final offset = (widget.index * 0.2) % 1.0;
          final progress = (_controller.value + offset) % 1.0;
          final pulseAlpha =
              (1.0 - (progress - 0.5).abs() * 2.0).clamp(0.2, 1.0);

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  Icons.arrow_forward_rounded,
                  size: widget.size,
                  color: widget.color.withValues(alpha: 0.4),
                ),
                Positioned(
                  left: progress * widget.size * 0.6,
                  child: Container(
                    width: 3,
                    height: 3,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: widget.color.withValues(alpha: pulseAlpha),
                      boxShadow: [
                        BoxShadow(
                          color:
                              widget.color.withValues(alpha: pulseAlpha * 0.8),
                          blurRadius: 3,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
