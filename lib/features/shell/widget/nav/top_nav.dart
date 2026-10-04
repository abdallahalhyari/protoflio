import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:profile/l10n/app_localizations.dart';
import 'package:profile/theme/surface_tone.dart';
import 'package:profile/theme/tokens.dart';
import 'package:profile/service/cv_service.dart';
import 'package:profile/shared/widget/conditional_blur.dart';
import 'package:profile/features/shell/home_controller.dart';
import 'package:profile/shared/widget/edge_fade_scroller.dart';

import 'package:profile/features/shell/widget/nav/nav_item.dart';

const double kDenseNavBelow = 1200;

class TopNav extends StatelessWidget {
  static List<String> getLabels(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return [
      l.navHome,
      l.navExperience,
      l.navWork,
      l.navStack,
      l.navEngineering,
      l.navAbout,
      l.navContact,
    ];
  }

  const TopNav({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: HomeController.of(context).pageIndex,
      builder: (context, current, _) => _build(context, current),
    );
  }

  Widget _build(BuildContext context, int current) {
    final accent = Theme.of(context).colorScheme.primary;

    final width = MediaQuery.sizeOf(context).width;
    final isDesktop = AppBreakpoints.isDesktop(context);
    final horizontalReserve =
        isDesktop ? 320.0 : AppSpacing.xl;
    final offsetForToolbar =
        isDesktop && width < AppBreakpoints.desktop;

    final compactResume = width < AppBreakpoints.desktop;
    final denseLinks = width < kDenseNavBelow;
    final resumeLabel = AppLocalizations.of(context)!.navResume.toUpperCase();
    void onResume() {
      HapticFeedback.lightImpact();
      CvService.open(context);
    }

    final resumeStyle = OutlinedButton.styleFrom(
      foregroundColor: context.resumeAccent,
      side: BorderSide(color: context.resumeBorder, width: 1.2),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
    );

    return Semantics(
      container: true,
      explicitChildNodes: true,
      label: 'Section navigation',
      child: Padding(
        padding: offsetForToolbar
            ? const EdgeInsets.only(left: AppSpacing.md, right: 170)
            : EdgeInsets.zero,
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: offsetForToolbar
                  ? double.infinity
                  : math.max(0.0, width - horizontalReserve),
            ),
            child: RepaintBoundary(
              child: ConditionalBlur(
                borderRadius: BorderRadius.circular(AppRadius.pill),
                child: Container(
                  margin: const EdgeInsets.only(top: AppSpacing.smd),
                  padding: EdgeInsets.symmetric(
                      horizontal: denseLinks ? AppSpacing.sm : AppSpacing.md,
                      vertical: AppSpacing.xs),
                  decoration: BoxDecoration(
                    color: context.glassSurface,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                    border: Border.all(
                      color: context.navSurfaceBorder(accent),
                    ),
                    boxShadow: context.ambientGlow(accent),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: EdgeFadeScroller(
                          child: Builder(
                            builder: (context) {
                              final labels = getLabels(context);
                              return Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  for (var i = 0; i < labels.length; i++)
                                    NavItem(
                                      label: labels[i],
                                      active: current == i,
                                      dense: denseLinks,
                                      onTap: () {
                                        if (i == current) return;
                                        HapticFeedback.selectionClick();
                                        HomeController.of(context).goTo(i);
                                      },
                                    ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Container(
                        width: 1,
                        height: 18,
                        color: context.navDivider,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      MergeSemantics(
                        child: Semantics(
                          button: true,
                          label: 'Download Resume PDF',
                          child: compactResume
                              ? Tooltip(
                                  message: resumeLabel,
                                  excludeFromSemantics: true,
                                  child: OutlinedButton(
                                    onPressed: onResume,
                                    style: resumeStyle.copyWith(
                                      padding: const WidgetStatePropertyAll(
                                          EdgeInsets.all(6)),
                                      minimumSize: const WidgetStatePropertyAll(
                                          Size(32, 32)),
                                    ),
                                    child: const Icon(Icons.download_rounded,
                                        size: 16),
                                  ),
                                )
                              : OutlinedButton.icon(
                                  onPressed: onResume,
                                  icon: const Icon(Icons.download_rounded,
                                      size: 14),
                                  label: Text(
                                    resumeLabel,
                                    semanticsLabel: '',
                                    style: const TextStyle(
                                      fontSize: AppTypography.caption,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 1.0,
                                    ),
                                  ),
                                  style: resumeStyle,
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
    );
  }
}
