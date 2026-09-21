import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:profile/service/analytics_service.dart';
import 'package:profile/service/sound_service.dart';
import 'package:profile/theme/surface_tone.dart';
import 'package:profile/theme/tokens.dart';
import 'package:profile/features/experience/model/experience.dart';

const _kNowAccent = AppColors.accentGreen; // Emerald green for "Present"

class ExperienceCard extends StatefulWidget {
  final Experience exp;
  final ColorScheme scheme;
  final bool isDesktop;
  final bool isSelected;
  final VoidCallback? onSelect;

  const ExperienceCard({
    super.key,
    required this.exp,
    required this.scheme,
    required this.isDesktop,
    this.isSelected = false,
    this.onSelect,
  });

  @override
  State<ExperienceCard> createState() => _ExperienceCardState();
}

class _ExperienceCardState extends State<ExperienceCard> {
  bool _hover = false;

  bool get _isCurrent => widget.exp.period.toLowerCase().contains('present');

  // Extract a single large year to act as a watermark (e.g. "2024" or "PRESENT")
  String get _watermark {
    if (_isCurrent) return 'NOW';
    final parts = widget.exp.period.split(' ');
    if (parts.isNotEmpty) {
      final last = parts.last;
      if (last.length == 4) return last; // likely a year
    }
    return widget.exp.company.isNotEmpty
        ? widget.exp.company.substring(0, 1).toUpperCase()
        : '';
  }

  @override
  Widget build(BuildContext context) {
    final scheme = widget.scheme;
    final isDark = context.isDarkMode;
    final reduce = MediaQuery.disableAnimationsOf(context);
    final active = (widget.isSelected || _hover) && !reduce;

    return Semantics(
      container: true,
      label:
          '${widget.exp.role} at ${widget.exp.company}, ${widget.exp.period}',
      child: GestureDetector(
        onTap: () {
          SoundService.instance.playClick();
          widget.onSelect?.call();
          if (!widget.isDesktop) {
            setState(() => _hover = !_hover);
          }
        },
        child: MouseRegion(
          onEnter: (_) => setState(() => _hover = true),
          onExit: (_) => setState(() => _hover = false),
          child: AnimatedScale(
            scale: active ? 1.02 : 1.0,
            duration: AppMotion.cardHover,
            curve: AppMotion.emphasized,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadius.lg),
                border: Border.all(
                  color: active
                      ? scheme.primary.withValues(
                          alpha: isDark
                              ? (widget.isSelected ? 0.9 : 0.6)
                              : (widget.isSelected ? 1.0 : 0.8))
                      : (isDark
                          ? context.glassBorderStrong
                          : AppColors.slate200),
                  width: active ? (widget.isSelected ? 2.0 : 1.5) : 1.0,
                ),
                boxShadow: active
                    ? [
                        BoxShadow(
                          color: scheme.primary.withValues(
                              alpha: isDark
                                  ? (widget.isSelected ? 0.35 : 0.22)
                                  : (widget.isSelected ? 0.25 : 0.16)),
                          blurRadius: widget.isSelected ? 32 : 24,
                          spreadRadius: widget.isSelected ? 3 : 2,
                        ),
                        BoxShadow(
                          color: isDark
                              ? AppColors.shadowMedium
                              : AppColors.shadowSoft,
                          blurRadius: 12,
                          offset: const Offset(0, 10),
                        ),
                      ]
                    : [
                        BoxShadow(
                            color: isDark
                                ? AppColors.shadowSoft
                                : AppColors.slate900.withValues(alpha: 0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 4)),
                      ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.lg),
                child: Stack(
                  children: [
                    // Glass background fill
                    Positioned.fill(
                      child: RepaintBoundary(
                        child: AnimatedContainer(
                          duration: AppMotion.cardHover,
                          curve: AppMotion.emphasized,
                          color: active
                              ? context.cardGlassHover
                              : context.cardGlass,
                        ),
                      ),
                    ),

                    // Watermark
                    Positioned(
                      right: -10,
                      bottom: -20,
                      child: Text(
                        _watermark,
                        style: TextStyle(
                          fontFamily: AppTypography.displayFont,
                          fontSize: widget.isDesktop ? 160 : 90,
                          color: scheme.onSurface.withValues(alpha: 0.04),
                          height: 1.0,
                        ),
                      ),
                    ),

                    // Content
                    Builder(
                      builder: (context) {
                        final content = Padding(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Top row: Period and Latest Dispatch
                              Wrap(
                                spacing: 8,
                                runSpacing: 6,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: scheme.primary
                                          .withValues(alpha: 0.15),
                                      borderRadius:
                                          BorderRadius.circular(AppRadius.xs),
                                    ),
                                    child: Text(
                                      widget.exp.period.toUpperCase(),
                                      style: TextStyle(
                                          color: context.adaptiveAccentText(scheme.primary),
                                          fontSize: AppTypography.micro,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: 1),
                                    ),
                                  ),
                                  if (_isCurrent) ...[
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: isDark
                                            ? _kNowAccent.withValues(
                                                alpha: 0.15)
                                            : AppColors.accentGreenDeep
                                                .withValues(alpha: 0.10),
                                        borderRadius:
                                            BorderRadius.circular(AppRadius.xs),
                                        border: Border.all(
                                          color: isDark
                                              ? _kNowAccent.withValues(
                                                  alpha: 0.5)
                                              : AppColors.accentGreenDeep
                                                  .withValues(alpha: 0.45),
                                        ),
                                      ),
                                      child: Text(
                                        'LATEST DISPATCH',
                                        style: TextStyle(
                                          color: isDark
                                              ? _kNowAccent
                                              : AppColors.accentGreenDeep,
                                          fontSize: AppTypography.micro,
                                          fontWeight: FontWeight.w900,
                                          letterSpacing: 1,
                                        ),
                                      ),
                                    ),
                                  ]
                                ],
                              ),
                              const SizedBox(height: 14),

                              // Role & Company
                              Text(
                                widget.exp.company,
                                style: TextStyle(
                                  fontFamily: AppTypography.displayFont,
                                  color: scheme.onSurface,
                                  fontSize: widget.isDesktop ? 28 : 22,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 2,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                widget.exp.role.toUpperCase(),
                                style: TextStyle(
                                  color: context.adaptiveAccentText(scheme.primary),
                                  fontSize: widget.isDesktop ? 14 : 12.5,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1.5,
                                ),
                              ),

                              if (widget.exp.websiteUrl != null ||
                                  widget.exp.linkedinUrl != null) ...[
                                const SizedBox(height: 12),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 6,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    if (widget.exp.websiteUrl != null)
                                      _CompanyActionPill(
                                        label: 'WEBSITE',
                                        tooltip:
                                            'Visit ${widget.exp.company} official website',
                                        icon: Icons.language_rounded,
                                        url: widget.exp.websiteUrl!,
                                        company: widget.exp.company,
                                        type: 'website',
                                        scheme: scheme,
                                        isDark: isDark,
                                      ),
                                    if (widget.exp.linkedinUrl != null)
                                      _CompanyActionPill(
                                        label: 'LINKEDIN',
                                        tooltip:
                                            'View ${widget.exp.company} on LinkedIn',
                                        isLinkedIn: true,
                                        url: widget.exp.linkedinUrl!,
                                        company: widget.exp.company,
                                        type: 'linkedin',
                                        scheme: scheme,
                                        isDark: isDark,
                                      ),
                                  ],
                                ),
                              ],

                              const SizedBox(height: 16),

                              // Highlights
                              ...widget.exp.highlights
                                  .map((h) => _buildHighlight(h, scheme)),
                            ],
                          ),
                        );

                        return widget.isDesktop
                            ? SingleChildScrollView(
                                primary: false, child: content)
                            : content;
                      },
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

  Widget _buildHighlight(String highlight, ColorScheme scheme) {
    final isDark = context.isDarkMode;
    final int colonIndex = highlight.indexOf(':');
    final bool hasColon = colonIndex != -1;
    final String prefix =
        hasColon ? highlight.substring(0, colonIndex + 1) : '';
    final String rest =
        hasColon ? highlight.substring(colonIndex + 1) : highlight;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: context.adaptiveAccentText(scheme.primary),
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: hasColon
                ? Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: prefix,
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            color:
                                isDark ? scheme.onSurface : AppColors.slate900,
                            fontSize: AppTypography.smallLoose,
                            height: 1.5,
                          ),
                        ),
                        TextSpan(
                          text: rest,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: isDark
                                ? scheme.onSurface.withValues(alpha: 0.85)
                                : AppColors.slate700,
                            fontSize: AppTypography.smallLoose,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  )
                : Text(
                    highlight,
                    style: TextStyle(
                      color: isDark
                          ? scheme.onSurface.withValues(alpha: 0.85)
                          : AppColors.slate700,
                      fontSize: AppTypography.smallLoose,
                      height: 1.5,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _CompanyActionPill extends StatefulWidget {
  final String label;
  final String tooltip;
  final IconData? icon;
  final bool isLinkedIn;
  final String url;
  final String company;
  final String type;
  final ColorScheme scheme;
  final bool isDark;

  const _CompanyActionPill({
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
  State<_CompanyActionPill> createState() => _CompanyActionPillState();
}

class _CompanyActionPillState extends State<_CompanyActionPill> {
  bool _hovered = false;

  Future<void> _handleTap() async {
    SoundService.instance.playClick();
    Analytics.event('company_link_click', params: {
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
    final scheme = widget.scheme;
    final primary = widget.isLinkedIn ? AppColors.linkedIn : scheme.primary;

    return Semantics(
      button: true,
      label: '${widget.company} ${widget.label}: ${widget.tooltip}',
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                          ? (isDark ? primary : primary)
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
