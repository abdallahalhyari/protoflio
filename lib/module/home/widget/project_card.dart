import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:animate_do/animate_do.dart';
import '../../../theme/tokens.dart';
import '../../../service/sound_service.dart';
import '../model/project.dart';

class ProjectCard extends StatefulWidget {
  final Project project;
  final int index; // For staggered animation
  final bool isVisible;
  final VoidCallback? onTap;

  const ProjectCard({
    super.key,
    required this.project,
    this.index = 0,
    this.isVisible = true,
    this.onTap,
  });

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  bool _isHovered = false;

  Future<void> _open(BuildContext context) async {
    final url = widget.project.url;
    if (url == null) return;
    final ok =
        await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not open $url')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final onSurface = scheme.onSurface;

    return FadeInUp(
      animate: widget.isVisible,
      // Cap stagger delay so lower cards don't take forever to appear
      delay: Duration(milliseconds: 100 * (widget.index % 6)),
      duration: const Duration(milliseconds: 600),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTap: () {
            SoundService.instance.playPageTurn();
            widget.onTap?.call();
          },
          child: AnimatedScale(
            scale: _isHovered ? 1.02 : 1.0,
            duration: AppMotion.sm,
            curve: Curves.easeOut,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.lg),
              gradient: _isHovered
                  ? const LinearGradient(
                      colors: [Color(0xFF818CF8), Color(0xFFC084FC)], // Indigo to Purple
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
              color: _isHovered ? null : (Theme.of(context).brightness == Brightness.dark ? Colors.white24 : Colors.black12), // Adaptive border
              boxShadow: [
                if (_isHovered)
                  BoxShadow(
                    color: const Color(0xFF818CF8).withValues(alpha: 0.3),
                    blurRadius: 20,
                    spreadRadius: 2,
                  )
              ],
            ),
            padding: EdgeInsets.all(_isHovered ? 2 : 1), // 2px gradient border on hover, 1px normal
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.lg - 1),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.md + 2),
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark 
                        ? Colors.black.withValues(alpha: 0.3) 
                        : Colors.white.withValues(alpha: 0.5),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              widget.project.name,
                              style: TextStyle(
                                color: onSurface,
                                fontSize: AppTypography.titleSm,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          if (widget.project.url != null)
                            IconButton(
                              tooltip: 'Open project link',
                              visualDensity: VisualDensity.compact,
                              icon: Icon(Icons.open_in_new,
                                  size: 18, color: scheme.primary),
                              onPressed: () => _open(context),
                            ),
                        ],
                      ),
                      Text(
                        widget.project.company,
                        style: TextStyle(
                          color: scheme.primary,
                          fontSize: 12.5,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        widget.project.tagline,
                        style: TextStyle(
                          color: onSurface,
                          fontSize: 14.5,
                          height: 1.5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.smd),
                      ...widget.project.highlights.map(
                        (h) {
                          final int colonIdx = h.indexOf(':');
                          final bool hasColon = colonIdx != -1;
                          final String prefix = hasColon ? h.substring(0, colonIdx + 1) : '';
                          final String rest = hasColon ? h.substring(colonIdx + 1) : h;

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Icon(Icons.check_circle,
                                      size: 13, color: scheme.primary),
                                ),
                                const SizedBox(width: AppSpacing.sm),
                                Expanded(
                                  child: hasColon
                                      ? Text.rich(
                                          TextSpan(
                                            children: [
                                              TextSpan(
                                                text: prefix,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w800,
                                                  color: onSurface,
                                                  fontSize: 13.5,
                                                  height: 1.45,
                                                ),
                                              ),
                                              TextSpan(
                                                text: rest,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  color: onSurface.withValues(alpha: 0.9),
                                                  fontSize: 13.0,
                                                  height: 1.45,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      : Text(
                                          h,
                                          style: TextStyle(
                                            color: onSurface.withValues(alpha: 0.9),
                                            fontSize: 13.0,
                                            height: 1.45,
                                          ),
                                        ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: AppSpacing.smd),
                      Wrap(
                        spacing: AppSpacing.sm - 2,
                        runSpacing: AppSpacing.sm - 2,
                        children: widget.project.stack
                            .map(
                              (t) => Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: AppSpacing.smd - 2,
                                    vertical: AppSpacing.xs),
                                decoration: BoxDecoration(
                                  color: scheme.primary.withValues(alpha: 0.1),
                                  border: Border.all(
                                      color: scheme.primary.withValues(alpha: 0.3)),
                                  borderRadius: BorderRadius.circular(AppRadius.pill),
                                  boxShadow: [
                                    BoxShadow(
                                      color: scheme.primary.withValues(alpha: 0.1),
                                      blurRadius: 4,
                                    )
                                  ]
                                ),
                                child: Text(
                                  t,
                                  style: TextStyle(
                                    color: scheme.primary,
                                    fontSize: AppTypography.micro + 1,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                      const SizedBox(height: AppSpacing.smd),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'READ SPREAD ➔',
                            style: TextStyle(
                              color: scheme.primary,
                              fontSize: 10.5,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.5,
                            ),
                          ),
                          Text(
                            'DOSSIER 0${widget.index + 1}',
                            style: TextStyle(
                              color: onSurface.withValues(alpha: 0.45),
                              fontSize: 9.5,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
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
