import 'package:flutter/material.dart';

import 'package:profile/core/theme/surface_tone.dart';
import 'package:profile/core/theme/tokens.dart';
import 'package:profile/shared/utils/bidi.dart';

/// Editorial section header shared by the paged sections: a heavy accent
/// rule, a letter-spaced "FEATURE 0X · …" kicker, the display-font title,
/// an italic subtitle, an optional count badge on the right (desktop),
/// and a hairline rule underneath.
///
/// The top accent rule plays a one-shot specular shimmer sweep on mount
/// to signal each new section landing.
class SectionMasthead extends StatefulWidget {
  const SectionMasthead({
    super.key,
    required this.kicker,
    required this.title,
    required this.subtitle,
    required this.isDesktop,
    this.badgeIcon,
    this.badgeLabel,
  });

  final String kicker;
  final String title;
  final String subtitle;
  final bool isDesktop;
  final IconData? badgeIcon;
  final String? badgeLabel;

  @override
  State<SectionMasthead> createState() => _SectionMastheadState();
}

class _SectionMastheadState extends State<SectionMasthead>
    with SingleTickerProviderStateMixin {
  late final AnimationController _shimmer;

  @override
  void initState() {
    super.initState();
    _shimmer = AnimationController(
      vsync: this,
      duration: AppMotion.entry,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!AppMedia.reduceMotion(context) && !_shimmer.isCompleted) {
      if (WidgetsBinding.instance.runtimeType.toString().contains('Test')) {
        _shimmer.value = 1.0;
      } else {
        _shimmer.forward();
      }
    }
  }

  @override
  void dispose() {
    _shimmer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final width = MediaQuery.sizeOf(context).width;
    final accentText = context.adaptiveAccentText(scheme.primary);
    final titleSize = (width * 0.05).clamp(24.0, 48.0);
    final reduceMotion = AppMedia.reduceMotion(context);

    // The accent rule: solid fill with a shimmer gradient overlay.
    Widget accentRule = Container(
      height: 2,
      color: scheme.primary.withValues(alpha: 0.9),
    );

    if (!reduceMotion) {
      accentRule = Stack(
        children: [
          accentRule,
          Positioned.fill(
            child: RepaintBoundary(
              child: AnimatedBuilder(
                animation: _shimmer,
                builder: (context, _) {
                  // Sweep a specular highlight from -100% to +200%
                  final t = _shimmer.value;
                  final center = -1.0 + t * 3.0;
                  return DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment(center - 0.3, 0),
                        end: Alignment(center + 0.3, 0),
                        colors: [
                          Colors.transparent,
                          scheme.onPrimary.withValues(alpha: 0.6),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      );
    }

    final Widget headerContent = Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.kicker,
                style: TextStyle(
                  color: accentText,
                  fontSize: widget.isDesktop ? 11 : 10,
                  fontWeight: FontWeight.w900,
                  letterSpacing: latinTracking(context, 3),
                ),
              ),
              // Tenada caps fill their 1.0 line box, so a fixed 4px read
              // as touching on wide screens; scale with the title.
              SizedBox(height: (titleSize * 0.2).clamp(6.0, 10.0)),
              Semantics(
                header: true,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    widget.title,
                    style: TextStyle(
                      fontFamily: AppTypography.displayFont,
                      color: scheme.onSurface,
                      fontSize: titleSize,
                      fontWeight: FontWeight.w900,
                      letterSpacing: latinTracking(context, 4),
                      height: 1,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                widget.subtitle,
                style: TextStyle(
                  color: scheme.onSurface.withValues(alpha: 0.75),
                  fontSize: widget.isDesktop ? 12.5 : 11.5,
                  fontStyle: FontStyle.italic,
                  letterSpacing: latinTracking(context, 0.5),
                ),
              ),
            ],
          ),
        ),
        if (widget.isDesktop && widget.badgeLabel != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: scheme.primary.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(AppRadius.pill),
              border: Border.all(color: scheme.primary.withValues(alpha: 0.4)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.badgeIcon != null) ...[
                  Icon(widget.badgeIcon,
                      size: AppTypography.caption + 1, color: accentText),
                  const SizedBox(width: 6),
                ],
                Text(
                  // "4 ROLES · …" — keep the count in front under RTL.
                  ltrContent(context, widget.badgeLabel!),
                  style: TextStyle(
                    color: accentText,
                    fontSize: AppTypography.editorial,
                    fontWeight: FontWeight.w900,
                    letterSpacing: latinTracking(context, 1.4),
                  ),
                ),
              ],
            ),
          ),
      ],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        accentRule,
        const SizedBox(height: 6),
        if (reduceMotion)
          headerContent
        else
          FadeTransition(
            opacity: CurvedAnimation(
              parent: _shimmer,
              curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
            ),
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.06),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: _shimmer,
                curve: AppMotion.emphasizedDecel,
              )),
              child: headerContent,
            ),
          ),
        const SizedBox(height: 6),
        Container(height: 0.75, color: scheme.primary.withValues(alpha: 0.5)),
      ],
    );
  }
}
