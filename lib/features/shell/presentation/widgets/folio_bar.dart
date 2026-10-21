import 'package:flutter/material.dart';
import 'package:profile/l10n/app_localizations.dart';

import 'package:profile/features/shell/presentation/controllers/home_controller.dart';
import 'package:profile/core/theme/surface_tone.dart';
import 'package:profile/core/theme/tokens.dart';
import 'package:profile/shared/widgets/directional_icon.dart';
import 'package:profile/features/shell/presentation/widgets/portfolio_nav.dart'
    show TopNav;

/// Desktop bottom-left "Next: Skills" control: the journey's next step,
/// one click away. The top nav already says where you are, so this only
/// says where you go next; on the last section it offers the way back.
class FolioBar extends StatelessWidget {
  const FolioBar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = HomeController.of(context);
    final labels = TopNav.getLabels(context);

    return ValueListenableBuilder<int>(
      valueListenable: controller.pageIndex,
      // Its own semantics node: without the boundary the "Next" button
      // absorbed the page beneath it into one control.
      builder: (context, page, _) => Semantics(
        container: true,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: context.glassSurface,
            borderRadius: BorderRadius.circular(AppRadius.xs),
            border: Border.all(color: context.glassBorder),
          ),
          child: _NextStep(
            page: page,
            pageCount: controller.pageCount,
            labels: labels,
            onGoTo: controller.goTo,
          ),
        ),
      ),
    );
  }
}

/// The next section's name and a directional arrow icon, so the reader
/// never has to guess what follows or discover the wheel and arrow keys.
class _NextStep extends StatefulWidget {
  const _NextStep({
    required this.page,
    required this.pageCount,
    required this.labels,
    required this.onGoTo,
  });

  final int page;
  final int pageCount;
  final List<String> labels;
  final void Function(int index, {bool syncUrl}) onGoTo;

  @override
  State<_NextStep> createState() => _NextStepState();
}

class _NextStepState extends State<_NextStep> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isLast = widget.page >= widget.pageCount - 1;
    final target = isLast ? 0 : widget.page + 1;
    final label = isLast
        ? l10n.folioBackToStart
        : '${l10n.folioNext}: ${widget.labels[target]}';
    final accent =
        context.adaptiveAccentText(Theme.of(context).colorScheme.primary);
    final reduce = MediaQuery.disableAnimationsOf(context);

    return Semantics(
      button: true,
      label: isLast
          ? l10n.folioBackToStart
          : '${l10n.folioNext}: ${widget.labels[target]}',
      excludeSemantics: true,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: AnimatedContainer(
          duration: AppMotion.xs,
          decoration: BoxDecoration(
            color: _hovered
                ? Theme.of(context)
                    .colorScheme
                    .primary
                    .withValues(alpha: context.isDarkMode ? 0.15 : 0.08)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(AppRadius.xs),
          ),
          child: InkWell(
            onTap: () => widget.onGoTo(target),
            borderRadius: BorderRadius.circular(AppRadius.xs),
            child: Padding(
              // 28px tall hit area around the micro label.
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedSwitcher(
                    duration: AppMotion.switcher,
                    child: Text(
                      label,
                      key: ValueKey<String>(label),
                      style: TextStyle(
                        color: _hovered ? accent : context.mutedText,
                        fontSize: AppTypography.label,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  AnimatedSlide(
                    offset: _hovered && !reduce
                        ? Offset(isLast ? 0 : 0.25, isLast ? -0.25 : 0)
                        : Offset.zero,
                    duration: AppMotion.chipHover,
                    curve: AppMotion.emphasized,
                    child: isLast
                        ? Icon(Icons.arrow_upward_rounded,
                            size: 12, color: accent)
                        : DirIcon(Icons.arrow_forward_rounded,
                            size: 12, color: accent),
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
