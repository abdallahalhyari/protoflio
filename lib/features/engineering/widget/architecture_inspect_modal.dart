import 'package:flutter/material.dart';
import 'package:profile/theme/surface_tone.dart';

import 'package:profile/service/sound_service.dart';
import 'package:profile/theme/tokens.dart';
import 'package:profile/features/engineering/model/architecture_topic.dart';
import 'diagram_list.dart';

Future<void> showArchitectureInspectModal(
  BuildContext context, {
  required ArchitectureTopic topic,
  required int currentStep,
  required ValueChanged<int> onStepChanged,
}) {
  return showDialog(
    context: context,
    barrierDismissible: true,
    builder: (ctx) => _ArchitectureInspectDialog(
      topic: topic,
      initialStep: currentStep,
      onStepChanged: onStepChanged,
    ),
  );
}

class _ArchitectureInspectDialog extends StatefulWidget {
  final ArchitectureTopic topic;
  final int initialStep;
  final ValueChanged<int> onStepChanged;

  const _ArchitectureInspectDialog({
    required this.topic,
    required this.initialStep,
    required this.onStepChanged,
  });

  @override
  State<_ArchitectureInspectDialog> createState() =>
      _ArchitectureInspectDialogState();
}

class _ArchitectureInspectDialogState
    extends State<_ArchitectureInspectDialog> {
  late int _step;
  final TransformationController _transformController =
      TransformationController();

  @override
  void initState() {
    super.initState();
    _step = widget.initialStep.clamp(0, widget.topic.diagramSteps.length - 1);
  }

  @override
  void dispose() {
    _transformController.dispose();
    super.dispose();
  }

  void _updateStep(int newStep) {
    final clamped = newStep.clamp(0, widget.topic.diagramSteps.length - 1);
    setState(() => _step = clamped);
    widget.onStepChanged(clamped);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final size = MediaQuery.sizeOf(context);

    return Dialog(
      backgroundColor: context.modalSurface,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        side: BorderSide(
          color: scheme.primary.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 900,
          maxHeight: size.height * 0.9,
        ),
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: scheme.primary.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.zoom_in_rounded,
                        color: scheme.primary, size: 20),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'INSPECT BLUEPRINT // ZOOM & SIMULATE',
                          style: TextStyle(
                            fontFamily: AppTypography.monoFont,
                            color: scheme.primary,
                            fontSize: AppTypography.micro,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.2,
                          ),
                        ),
                        Text(
                          widget.topic.title,
                          style: TextStyle(
                            fontFamily: AppTypography.displayFont,
                            color: context.onSurface,
                            fontSize: AppTypography.titleSm,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: 'Reset Zoom',
                    onPressed: () {
                      SoundService.instance.playClick();
                      _transformController.value = Matrix4.identity();
                    },
                    icon: const Icon(Icons.center_focus_strong_rounded),
                  ),
                  IconButton(
                    tooltip: 'Close',
                    onPressed: () {
                      SoundService.instance.playClick();
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            // Pan & Zoom Diagram Body
            Expanded(
              child: InteractiveViewer(
                transformationController: _transformController,
                boundaryMargin: const EdgeInsets.all(40),
                minScale: 0.8,
                maxScale: 3.0,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 600),
                      child: DiagramList(
                        topic: widget.topic,
                        scheme: scheme,
                        isDesktop: true,
                        activeStepIndex: _step,
                        onSelectStep: _updateStep,
                        shrinkWrap: true,
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
