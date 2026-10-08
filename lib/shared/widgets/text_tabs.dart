import 'package:flutter/material.dart';
import 'package:profile/core/services/sound_service.dart';
import 'package:profile/core/theme/surface_tone.dart';
import 'package:profile/core/theme/tokens.dart';

/// Text tabs with a gold rule under the current one. Plain words rather
/// than chips: the three views are places, not filters.
class TextTabs extends StatelessWidget {
  const TextTabs({
    super.key,
    required this.labels,
    required this.selected,
    required this.accent,
    required this.onSelect,
  });

  final List<String> labels;
  final int selected;
  final Color accent;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (var i = 0; i < labels.length; i++)
            Padding(
              padding: const EdgeInsetsDirectional.only(end: 28),
              child: Semantics(
                button: true,
                selected: i == selected,
                child: InkWell(
                  borderRadius: BorderRadius.circular(AppRadius.xs),
                  onTap: () {
                    SoundService.instance.playSelection();
                    onSelect(i);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: IntrinsicWidth(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          AnimatedDefaultTextStyle(
                            duration: AppMotion.snap,
                            style: TextStyle(
                              fontFamily: AppTypography.bodyFont,
                              fontSize: AppTypography.lead,
                              fontWeight: i == selected
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              color: i == selected
                                  ? context.onSurface
                                  : context.mutedText,
                            ),
                            child: Text(labels[i]),
                          ),
                          const SizedBox(height: 6),
                          AnimatedContainer(
                            duration: AppMotion.snap,
                            height: 2,
                            decoration: BoxDecoration(
                              color: i == selected
                                  ? accent
                                  : accent.withValues(alpha: 0),
                              borderRadius: BorderRadius.circular(1),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
