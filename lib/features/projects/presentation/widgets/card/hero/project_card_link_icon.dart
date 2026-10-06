import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:profile/core/services/analytics_service.dart';
import 'package:profile/core/services/sound_service.dart';
import 'package:profile/core/theme/tokens.dart';

class ProjectCardLinkIcon extends StatefulWidget {
  final String tooltip;
  final String? url;
  final VoidCallback? onTap;
  final IconData? icon;
  final bool isLinkedIn;
  final String company;
  final String type;
  final ColorScheme scheme;

  const ProjectCardLinkIcon({
    super.key,
    required this.tooltip,
    this.url,
    this.onTap,
    this.icon,
    this.isLinkedIn = false,
    required this.company,
    required this.type,
    required this.scheme,
  });

  @override
  State<ProjectCardLinkIcon> createState() => _ProjectCardLinkIconState();
}

class _ProjectCardLinkIconState extends State<ProjectCardLinkIcon> {
  bool _hovered = false;

  Future<void> _handleTap() async {
    if (widget.onTap != null) {
      widget.onTap!();
      return;
    }
    SoundService.instance.playClick();
    Analytics.event('project_company_link_click', params: {
      'company': widget.company,
      'type': widget.type,
      'url': widget.url ?? '',
    });
    if (widget.url != null) {
      final uri = Uri.parse(widget.url!);
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final activeColor =
        widget.isLinkedIn ? AppColors.linkedIn : widget.scheme.primary;

    return Semantics(
      link: widget.url != null,
      button: widget.url == null,
      linkUrl: widget.url == null ? null : Uri.tryParse(widget.url!),
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
              borderRadius: BorderRadius.circular(AppRadius.xs),
              onFocusChange: (focused) => setState(() => _hovered = focused),
              child: ExcludeSemantics(
                  child: AnimatedScale(
                scale: _hovered ? 1.1 : 1.0,
                duration: AppMotion.snap,
                child: AnimatedContainer(
                  duration: AppMotion.snap,
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: _hovered
                        ? activeColor.withValues(alpha: 0.85)
                        : Colors.black.withValues(alpha: 0.55),
                    borderRadius: BorderRadius.circular(AppRadius.xs),
                    border: Border.all(
                      color: _hovered
                          ? Colors.white
                          : Colors.white.withValues(alpha: AppAlpha.fill),
                    ),
                    boxShadow: _hovered
                        ? [
                            BoxShadow(
                              color: activeColor.withValues(alpha: 0.45),
                              blurRadius: 8,
                              spreadRadius: 1,
                            ),
                          ]
                        : null,
                  ),
                  alignment: Alignment.center,
                  child: widget.isLinkedIn
                      ? Container(
                          width: 15,
                          height: 15,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: _hovered ? Colors.white : AppColors.linkedIn,
                            borderRadius:
                                BorderRadius.circular(AppRadius.hairline),
                          ),
                          child: Text(
                            'in',
                            style: TextStyle(
                              color:
                                  _hovered ? AppColors.linkedIn : Colors.white,
                              fontSize: AppTypography.label,
                              fontWeight: FontWeight.w900,
                              fontFamily: 'sans-serif',
                              height: 1.0,
                            ),
                          ),
                        )
                      : Icon(
                          widget.icon ?? Icons.language_rounded,
                          size: 14,
                          color: Colors.white,
                        ),
                ),
              )),
            ),
          ),
        ),
      ),
    );
  }
}
