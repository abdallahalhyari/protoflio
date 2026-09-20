import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:profile/service/analytics_service.dart';
import 'package:profile/service/sound_service.dart';
import 'package:profile/theme/surface_tone.dart';
import 'package:profile/theme/tokens.dart';

/// Share / copy case study link helper with custom haptic toast.
Future<void> shareCaseStudy(
  BuildContext context, {
  required String slug,
  required String title,
}) async {
  SoundService.instance.playClick();
  Analytics.event('case_study_share', params: {'study': slug, 'title': title});
  final url = 'https://alhyari.web.app/#work/$slug';
  await Clipboard.setData(ClipboardData(text: url));

  if (!context.mounted) return;
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      elevation: 0,
      duration: AppMotion.toast,
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      content: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.slate900,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(
              color: AppColors.accentGreen.withValues(alpha: 0.7),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.5),
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
              BoxShadow(
                color: AppColors.accentGreen.withValues(alpha: 0.25),
                blurRadius: 14,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle_rounded,
                  color: AppColors.accentGreen, size: 18),
              const SizedBox(width: 10),
              Flexible(
                child: Text(
                  'Case study link copied: $url',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: AppTypography.small,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

/// A compact icon button for AppBar actions that shares the case study.
class CaseStudyToolbarShareButton extends StatelessWidget {
  final String slug;
  final String title;

  const CaseStudyToolbarShareButton({
    super.key,
    required this.slug,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.share_rounded, size: 20),
      tooltip: 'Share case study link',
      onPressed: () => shareCaseStudy(context, slug: slug, title: title),
    );
  }
}

/// Corporate verification links and direct share actions rendered in the case study masthead.
class CaseStudyCorporateHeader extends StatelessWidget {
  final String company;
  final String websiteUrl;
  final String linkedinUrl;
  final String slug;
  final String title;

  const CaseStudyCorporateHeader({
    super.key,
    required this.company,
    required this.websiteUrl,
    required this.linkedinUrl,
    required this.slug,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = context.isDarkMode;

    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.md),
      child: Wrap(
        spacing: 10,
        runSpacing: 8,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          _CaseStudyActionPill(
            label: 'OFFICIAL WEBSITE',
            tooltip: 'Visit $company official website',
            icon: Icons.language_rounded,
            url: websiteUrl,
            company: company,
            type: 'website',
            scheme: scheme,
            isDark: isDark,
          ),
          _CaseStudyActionPill(
            label: 'COMPANY LINKEDIN',
            tooltip: 'View $company on LinkedIn',
            isLinkedIn: true,
            url: linkedinUrl,
            company: company,
            type: 'linkedin',
            scheme: scheme,
            isDark: isDark,
          ),
          _CaseStudySharePill(
            slug: slug,
            title: title,
            scheme: scheme,
            isDark: isDark,
          ),
        ],
      ),
    );
  }
}

class _CaseStudyActionPill extends StatefulWidget {
  final String label;
  final String tooltip;
  final IconData? icon;
  final bool isLinkedIn;
  final String url;
  final String company;
  final String type;
  final ColorScheme scheme;
  final bool isDark;

  const _CaseStudyActionPill({
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
  State<_CaseStudyActionPill> createState() => _CaseStudyActionPillState();
}

class _CaseStudyActionPillState extends State<_CaseStudyActionPill> {
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
      button: true,
      label: '${widget.label}: ${widget.tooltip}',
      child: Tooltip(
        message: widget.tooltip,
        waitDuration: const Duration(milliseconds: 300),
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => setState(() => _hovered = true),
          onExit: (_) => setState(() => _hovered = false),
          child: GestureDetector(
            onTap: _handleTap,
            behavior: HitTestBehavior.opaque,
            child: AnimatedScale(
              scale: _hovered ? 1.05 : 1.0,
              duration: AppMotion.snap,
              child: AnimatedContainer(
                duration: AppMotion.snap,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: _hovered
                      ? (isDark
                          ? primary.withValues(alpha: 0.22)
                          : primary.withValues(alpha: 0.12))
                      : (isDark
                          ? Colors.white.withValues(alpha: 0.06)
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
                            color:
                                primary.withValues(alpha: isDark ? 0.35 : 0.22),
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
                          borderRadius: BorderRadius.circular(2),
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
                            : (isDark ? Colors.white70 : AppColors.slate600),
                      ),
                    ],
                    const SizedBox(width: 5),
                    Text(
                      widget.label,
                      style: TextStyle(
                        fontFamily: AppTypography.monoFont,
                        fontSize: AppTypography.micro,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.2,
                        color: _hovered
                            ? (isDark ? Colors.white : primary)
                            : (isDark
                                ? Colors.white.withValues(alpha: 0.88)
                                : AppColors.slate800),
                      ),
                    ),
                    const SizedBox(width: 3),
                    Icon(
                      Icons.arrow_outward_rounded,
                      size: 10,
                      color: _hovered
                          ? primary
                          : (isDark ? Colors.white38 : AppColors.slate400),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CaseStudySharePill extends StatefulWidget {
  final String slug;
  final String title;
  final ColorScheme scheme;
  final bool isDark;

  const _CaseStudySharePill({
    required this.slug,
    required this.title,
    required this.scheme,
    required this.isDark,
  });

  @override
  State<_CaseStudySharePill> createState() => _CaseStudySharePillState();
}

class _CaseStudySharePillState extends State<_CaseStudySharePill> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    const accent = AppColors.accentGreen;

    return Semantics(
      button: true,
      label: 'Share direct link to ${widget.title} case study',
      child: Tooltip(
        message: 'Copy direct link to this case study',
        waitDuration: const Duration(milliseconds: 300),
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => setState(() => _hovered = true),
          onExit: (_) => setState(() => _hovered = false),
          child: GestureDetector(
            onTap: () =>
                shareCaseStudy(context, slug: widget.slug, title: widget.title),
            behavior: HitTestBehavior.opaque,
            child: AnimatedScale(
              scale: _hovered ? 1.05 : 1.0,
              duration: AppMotion.snap,
              child: AnimatedContainer(
                duration: AppMotion.snap,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: _hovered
                      ? (isDark
                          ? accent.withValues(alpha: 0.22)
                          : accent.withValues(alpha: 0.12))
                      : (isDark
                          ? Colors.white.withValues(alpha: 0.06)
                          : AppColors.slate100),
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                  border: Border.all(
                    color: _hovered
                        ? accent.withValues(alpha: isDark ? 0.9 : 0.8)
                        : (isDark
                            ? Colors.white.withValues(alpha: 0.2)
                            : AppColors.slate300),
                    width: _hovered ? 1.4 : 1.0,
                  ),
                  boxShadow: _hovered
                      ? [
                          BoxShadow(
                            color: accent.withValues(alpha: isDark ? 0.35 : 0.22),
                            blurRadius: 10,
                            spreadRadius: 0.5,
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.share_rounded,
                      size: 13,
                      color: _hovered
                          ? (isDark ? Colors.white : AppColors.accentGreenDeep)
                          : (isDark ? Colors.white70 : AppColors.slate600),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'SHARE STUDY',
                      style: TextStyle(
                        fontFamily: AppTypography.monoFont,
                        fontSize: AppTypography.micro,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.2,
                        color: _hovered
                            ? (isDark ? Colors.white : AppColors.accentGreenDeep)
                            : (isDark
                                ? Colors.white.withValues(alpha: 0.88)
                                : AppColors.slate800),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
