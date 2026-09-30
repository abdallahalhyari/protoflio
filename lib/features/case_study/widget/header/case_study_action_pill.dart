import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:profile/service/analytics_service.dart';
import 'package:profile/service/sound_service.dart';
import 'package:profile/shared/util/bidi.dart';
import 'package:profile/theme/surface_tone.dart';
import 'package:profile/theme/tokens.dart';

class CaseStudyActionPill extends StatefulWidget {
  final String label;
  final String tooltip;
  final IconData? icon;
  final bool isLinkedIn;
  final String url;
  final String company;
  final String type;
  final ColorScheme scheme;
  final bool isDark;

  const CaseStudyActionPill({
    super.key,
    required this.label,
    required this.tooltip,
    this.icon,
    this.isLinkedIn = false,
    required this.url,
    required this.company,
    required this.type,
    required this.scheme,
    required this.isDark,
  });

  @override
  State<CaseStudyActionPill> createState() => _CaseStudyActionPillState();
}

class _CaseStudyActionPillState extends State<CaseStudyActionPill> {
  bool _hovered = false;

  Future<void> _handleTap() async {
    SoundService.instance.playClick();
    Analytics.event('case_study_company_link', params: {
      'company': widget.company,
      'type': widget.type,
      'url': widget.url,
    });
    final uri = Uri.parse(widget.url);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    final primary =
        widget.isLinkedIn ? AppColors.linkedIn : widget.scheme.primary;

    return Semantics(
      link: true,
      linkUrl: Uri.tryParse(widget.url),
      label: widget.tooltip,
      child: Tooltip(
        message: widget.tooltip,
        excludeFromSemantics: true,
        waitDuration: AppMotion.tooltipWait,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => setState(() => _hovered = true),
          onExit: (_) => setState(() => _hovered = false),
          child: Material(
              type: MaterialType.transparency,
              child: InkWell(
                onTap: _handleTap,
                borderRadius: BorderRadius.circular(AppRadius.pill),
                onFocusChange: (focused) => setState(() => _hovered = focused),
                child: ExcludeSemantics(
                    child: AnimatedScale(
                  scale: _hovered ? 1.05 : 1.0,
                  duration: AppMotion.snap,
                  child: AnimatedContainer(
                    duration: AppMotion.snap,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: _hovered
                          ? (isDark
                              ? primary.withValues(alpha: 0.22)
                              : primary.withValues(alpha: AppAlpha.hover))
                          : (isDark
                              ? Colors.white.withValues(alpha: AppAlpha.whisper)
                              : AppColors.slate100),
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                      border: Border.all(
                        color: _hovered
                            ? primary.withValues(alpha: isDark ? 0.9 : 0.8)
                            : (isDark
                                ? Colors.white.withValues(alpha: 0.2)
                                : AppColors.slate300),
                        width: _hovered ? 1.4 : 1.0,
                      ),
                      boxShadow: _hovered
                          ? [
                              BoxShadow(
                                color: primary.withValues(
                                    alpha: isDark ? 0.35 : 0.22),
                                blurRadius: 10,
                                spreadRadius: 0.5,
                              ),
                            ]
                          : null,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.isLinkedIn) ...[
                          Container(
                            width: 13,
                            height: 13,
                            decoration: BoxDecoration(
                              color: AppColors.linkedIn,
                              borderRadius:
                                  BorderRadius.circular(AppRadius.hairline),
                            ),
                            alignment: Alignment.center,
                            child: const Text(
                              'in',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: AppTypography.nano,
                                fontWeight: FontWeight.w900,
                                fontFamily: 'sans-serif',
                                height: 1.0,
                              ),
                            ),
                          ),
                        ] else if (widget.icon != null) ...[
                          Icon(
                            widget.icon,
                            size: 13,
                            color: _hovered
                                ? (isDark ? Colors.white : primary)
                                : (context.mutedText),
                          ),
                        ],
                        const SizedBox(width: 5),
                        Flexible(
                          child: Text(
                            widget.label,
                            maxLines: 1,
                            softWrap: false,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: AppTypography.monoFont,
                              fontSize: AppTypography.micro,
                              fontWeight: FontWeight.w900,
                              letterSpacing: latinTracking(context, 1.2),
                              color: _hovered
                                  ? (isDark ? Colors.white : primary)
                                  : (isDark
                                      ? Colors.white.withValues(alpha: 0.88)
                                      : AppColors.slate800),
                            ),
                          ),
                        ),
                        const SizedBox(width: 3),
                        Icon(
                          Icons.arrow_outward_rounded,
                          size: 10,
                          color: _hovered
                              ? primary
                              : (isDark ? Colors.white54 : AppColors.slate500),
                        ),
                      ],
                    ),
                  ),
                )),
              )),
        ),
      ),
    );
  }
}
