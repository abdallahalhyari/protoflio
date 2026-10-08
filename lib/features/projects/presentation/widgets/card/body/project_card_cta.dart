import 'package:flutter/material.dart';
import 'package:profile/core/theme/tokens.dart';
import 'package:profile/l10n/app_localizations.dart';

class ReadCaseStudyCta extends StatefulWidget {
  const ReadCaseStudyCta({
    super.key,
    required this.projectName,
    required this.scheme,
    required this.isHovered,
    required this.isDesktop,
    required this.isDark,
    required this.onTap,
    required this.onFocusChange,
  });

  final String projectName;
  final ColorScheme scheme;
  final bool isHovered;
  final bool isDesktop;
  final bool isDark;
  final VoidCallback onTap;
  final ValueChanged<bool> onFocusChange;

  @override
  State<ReadCaseStudyCta> createState() => _ReadCaseStudyCtaState();
}

class _ReadCaseStudyCtaState extends State<ReadCaseStudyCta> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final ctaColor = widget.isDark ? widget.scheme.primary : AppColors.tealDeep;
    final reduceMotion = MediaQuery.disableAnimationsOf(context);

    return Semantics(
      button: true,
      label: AppLocalizations.of(context)!.readCaseStudyFor(widget.projectName),
      child: InkWell(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: widget.onTap,
        onFocusChange: widget.onFocusChange,
        borderRadius: BorderRadius.circular(AppRadius.xs),
        child: ExcludeSemantics(
          child: AnimatedScale(
            scale: _isPressed ? 0.96 : 1.0,
            duration: reduceMotion ? Duration.zero : AppMotion.micro,
            curve: Curves.easeOutCubic,
            child: AnimatedSlide(
              offset: widget.isHovered && widget.isDesktop
                  ? const Offset(0.05, 0)
                  : Offset.zero,
              duration: reduceMotion ? Duration.zero : AppMotion.cardHover,
              curve: AppMotion.emphasized,
              child: Row(
                children: [
                  Flexible(
                    child: Text(
                      AppLocalizations.of(context)!.uiReadCaseStudy,
                      style: TextStyle(
                        color: ctaColor,
                        fontSize: AppTypography.label,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Icon(Icons.arrow_forward_rounded, size: 14, color: ctaColor),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
