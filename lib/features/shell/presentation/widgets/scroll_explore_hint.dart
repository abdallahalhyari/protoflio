import 'package:flutter/material.dart';
import 'package:profile/core/theme/surface_tone.dart';

import 'package:profile/core/theme/tokens.dart';
import 'package:profile/l10n/app_localizations.dart';

/// Bouncing chevron + "SCROLL TO EXPLORE" label. Auto-loops when motion is
/// allowed; renders static when the user prefers reduced motion.
class ScrollExploreHint extends StatefulWidget {
  const ScrollExploreHint({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  State<ScrollExploreHint> createState() => _ScrollExploreHintState();
}

class _ScrollExploreHintState extends State<ScrollExploreHint>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: AppMotion.ambient,
  );
  late final Animation<double> _anim = CurvedAnimation(
    parent: _ctrl,
    curve: Curves.easeInOut,
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final reduce = MediaQuery.disableAnimationsOf(context);
    if (!reduce && !_ctrl.isAnimating) {
      _ctrl.repeat(reverse: true);
    } else if (reduce && _ctrl.isAnimating) {
      _ctrl.stop();
      _ctrl.value = 0;
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tint = context.mutedText;
    return MergeSemantics(
      child: Semantics(
        button: true,
        label: 'Scroll to explore the portfolio',
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(AppRadius.sm),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ExcludeSemantics(
                    child: Text(
                      AppLocalizations.of(context)!.uiScrollToExplore,
                      style: TextStyle(
                        color: tint,
                        fontSize: AppTypography.label,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  RepaintBoundary(
                    child: AnimatedBuilder(
                      animation: _anim,
                      builder: (_, child) {
                        return Transform.translate(
                          offset: Offset(0, _anim.value * 6),
                          child: child,
                        );
                      },
                      child: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 24,
                        color: tint,
                      ),
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
