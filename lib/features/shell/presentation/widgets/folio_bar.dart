import 'package:flutter/material.dart';
import 'package:profile/l10n/app_localizations.dart';

import 'package:profile/features/shell/presentation/controllers/home_controller.dart';
import 'package:profile/core/theme/surface_tone.dart';
import 'package:profile/core/theme/tokens.dart';
import 'package:profile/shared/widgets/directional_icon.dart';
import 'package:profile/shared/widgets/pulsing_dot.dart';
import 'package:profile/shared/utils/bidi.dart';
import 'package:profile/features/shell/presentation/widgets/portfolio_nav.dart'
    show TopNav;

/// Desktop bottom-left "05 / 07 · SKILLS" folio bar. Reads pageIndex from
/// [HomeController]; pageCount is constant for the app's lifetime.
class FolioBar extends StatelessWidget {
  const FolioBar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = HomeController.of(context);
    final pageCount = controller.pageCount;
    final labels = TopNav.getLabels(context);

    return ValueListenableBuilder<int>(
      valueListenable: controller.pageIndex,
      builder: (context, page, _) {
        final currentLabel =
            (page >= 0 && page < labels.length) ? labels[page] : '';
        return Semantics(
          container: true,
          label:
              'Current section: $currentLabel, page ${page + 1} of $pageCount',
          child: Container(
            padding: const EdgeInsets.fromLTRB(10, 0, 2, 0),
            decoration: BoxDecoration(
              color: context.glassSurface,
              borderRadius: BorderRadius.circular(AppRadius.xs),
              border: Border.all(color: context.glassBorder),
              boxShadow: [
                BoxShadow(
                  color: context.isDarkMode
                      ? Theme.of(context)
                          .colorScheme
                          .primary
                          .withValues(alpha: 0.08)
                      : AppColors.shadowSoft,
                  blurRadius: 12,
                  spreadRadius: 1,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ExcludeSemantics(
                    child: AnimatedSwitcher(
                  duration: AppMotion.switcher,
                  transitionBuilder: (child, animation) => FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0.0, 0.2),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                  ),
                  child: Text(
                    // "01 / 07" wrapped in one LTR isolate: under RTL the
                    // run otherwise renders reversed ("07 / 01").
                    AppLocalizations.of(context)!.folioIndicator(
                      '${_rtl(context) ? kLri : ''}'
                          '${(page + 1).toString().padLeft(2, '0')}',
                      '${pageCount.toString().padLeft(2, '0')}'
                          '${_rtl(context) ? kPdi : ''}',
                    ),
                    key: ValueKey<int>(page),
                    style: TextStyle(
                      color: context.subtleText,
                      fontSize: AppTypography.label,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                )),
                const SizedBox(width: 8),
                Container(
                  width: 1,
                  height: 10,
                  color: context.glassBorderStrong,
                ),
                const SizedBox(width: 8),
                PulsingDot(color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 6),
                ExcludeSemantics(
                    child: AnimatedSwitcher(
                  duration: AppMotion.switcher,
                  transitionBuilder: (child, animation) => FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0.0, -0.2),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                  ),
                  child: Text(
                    currentLabel,
                    key: ValueKey<String>(currentLabel),
                    style: TextStyle(
                      color: context.onSurface,
                      fontSize: AppTypography.label,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                )),
                const SizedBox(width: 8),
                Container(
                  width: 1,
                  height: 10,
                  color: context.glassBorderStrong,
                ),
                const SizedBox(width: 2),
                _NextStep(
                  page: page,
                  pageCount: pageCount,
                  labels: labels,
                  onGoTo: controller.goTo,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// "NEXT · SKILLS & STACK →" — the journey's next step, one click away,
/// so the reader never has to guess what follows or discover the wheel /
/// arrow keys. On the last section it offers the way back to the start.
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
        : '${l10n.folioNext} · ${widget.labels[target]}';
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

bool _rtl(BuildContext context) =>
    Directionality.of(context) == TextDirection.rtl;
