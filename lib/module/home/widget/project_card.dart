import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../../theme/tokens.dart';
import '../../../util/open_url.dart';
import '../model/project.dart';
import 'site_cursor.dart';

/// A single project rendered as a numbered "dossier" entry: a ghosted
/// index numeral filed behind the content, a colored accent spine down
/// the left edge, a kicker company label above the name, arrow-marked
/// highlights, and bracketed tech tags.
///
/// Each card draws a per-index accent from [_accents] so the Projects
/// grid reads as a set of distinct filed entries rather than five
/// identical blue cards. Hover keeps the pointer-tracked 3D tilt + lift
/// from the previous design, now tinted by the card's own accent, and
/// widens the spine. All motion is `MediaQueryData.disableAnimations`
/// aware.
class ProjectCard extends StatefulWidget {
  final Project project;
  final int index;

  const ProjectCard({super.key, required this.project, required this.index});

  // Editorial accent palette — one solid color per card slot.
  static const List<Color> _accents = [
    Color(0xFF4F9DFF), // azure
    Color(0xFFE0725C), // terracotta
    Color(0xFF56C596), // jade
    Color(0xFFB388FF), // violet
    Color(0xFFF2B84B), // amber
  ];

  Color get accent => _accents[index % _accents.length];

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  bool _hover = false;
  Offset _tilt = Offset.zero; // -1..1 on each axis

  Future<void> _open(BuildContext context) async {
    final url = widget.project.url;
    if (url == null) return;
    await openUrl(context, url);
  }

  void _updateTilt(PointerHoverEvent e) {
    if (MediaQuery.of(context).disableAnimations) return;
    final box = context.findRenderObject() as RenderBox?;
    if (box == null) return;
    final local = box.globalToLocal(e.position);
    final rel = Offset(
      (local.dx / box.size.width) * 2 - 1,
      (local.dy / box.size.height) * 2 - 1,
    );
    setState(() => _tilt = rel);
  }

  @override
  void dispose() {
    if (_hover && widget.project.url != null) SiteCursor.hot.value--;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final project = widget.project;
    final scheme = Theme.of(context).colorScheme;
    final onSurface = scheme.onSurface;
    final accent = widget.accent;
    final canOpen = project.url != null;
    final reduce = MediaQuery.of(context).disableAnimations;
    final hovered = _hover && !reduce;
    final ordinal = (widget.index + 1).toString().padLeft(2, '0');

    const maxTiltDeg = 6.0;
    final tiltMatrix = Matrix4.identity()
      ..setEntry(3, 2, 0.001)
      ..translateByDouble(0, hovered ? -6 : 0, 0, 1)
      ..rotateX(hovered ? -_tilt.dy * maxTiltDeg * 3.14159 / 180 : 0)
      ..rotateY(hovered ? _tilt.dx * maxTiltDeg * 3.14159 / 180 : 0);

    return MouseRegion(
      cursor: canOpen ? SystemMouseCursors.click : MouseCursor.defer,
      onEnter: (_) {
        setState(() => _hover = true);
        if (canOpen) SiteCursor.hot.value++;
      },
      onHover: _updateTilt,
      onExit: (_) {
        setState(() {
          _hover = false;
          _tilt = Offset.zero;
        });
        if (canOpen) SiteCursor.hot.value--;
      },
      child: AnimatedContainer(
        duration: AppMotion.xs,
        curve: Curves.easeOut,
        transformAlignment: Alignment.center,
        transform: tiltMatrix,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.md),
          color: scheme.onSurface.withValues(alpha: 0.04),
          border: Border.all(
            color: hovered
                ? accent.withValues(alpha: 0.6)
                : scheme.onSurface.withValues(alpha: 0.14),
          ),
          boxShadow: hovered
              ? [
                  BoxShadow(
                    color: accent.withValues(alpha: 0.28),
                    blurRadius: 30,
                    offset: const Offset(0, 14),
                  ),
                ]
              : const [],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.md),
          child: Stack(
            children: [
              // Ghosted index numeral filed in the top-right corner.
              Positioned(
                top: -AppSpacing.lg,
                right: -AppSpacing.xs,
                child: IgnorePointer(
                  child: Text(
                    ordinal,
                    style: TextStyle(
                      fontFamily: 'Tenada',
                      fontSize: 120,
                      height: 1,
                      fontWeight: FontWeight.w900,
                      color: accent.withValues(alpha: hovered ? 0.16 : 0.09),
                    ),
                  ),
                ),
              ),
              // Left accent spine.
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                child: AnimatedContainer(
                  duration: AppMotion.sm,
                  curve: Curves.easeOut,
                  width: hovered ? 6 : 4,
                  color: accent,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.md + AppSpacing.sm,
                  AppSpacing.md,
                  AppSpacing.md,
                  AppSpacing.md,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Kicker: company, uppercase + letter-spaced.
                    Text(
                      project.company.toUpperCase(),
                      style: TextStyle(
                        color: accent,
                        fontSize: AppTypography.micro,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    // Title + open-link affordance.
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            project.name,
                            style: TextStyle(
                              color: onSurface,
                              fontSize: AppTypography.title,
                              fontWeight: FontWeight.w900,
                              height: 1.1,
                            ),
                          ),
                        ),
                        if (canOpen)
                          IconButton(
                            tooltip: 'projects.open_link'.tr(),
                            visualDensity: VisualDensity.compact,
                            icon: Icon(Icons.arrow_outward,
                                size: 18, color: accent),
                            onPressed: () => _open(context),
                          ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      project.tagline,
                      style: TextStyle(
                        color: onSurface.withValues(alpha: 0.8),
                        fontSize: AppTypography.body,
                        height: 1.4,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.smd),
                    ...project.highlights.map(
                      (h) => Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: AppSpacing.xs / 2),
                              child: Text(
                                '›',
                                style: TextStyle(
                                  color: accent,
                                  fontSize: AppTypography.bodyMd,
                                  fontWeight: FontWeight.w900,
                                  height: 1.2,
                                ),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Expanded(
                              child: Text(
                                h,
                                style: TextStyle(
                                  color: onSurface.withValues(alpha: 0.82),
                                  fontSize: AppTypography.small,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.smd),
                    Wrap(
                      spacing: AppSpacing.smx,
                      runSpacing: AppSpacing.smx,
                      children: project.stack
                          .map((t) => _StackTag(label: t, accent: accent))
                          .toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Bracketed tech tag: `[ Flutter ]` in the card's accent color.
class _StackTag extends StatelessWidget {
  final String label;
  final Color accent;

  const _StackTag({required this.label, required this.accent});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '[',
          style: TextStyle(
            color: accent.withValues(alpha: 0.6),
            fontSize: AppTypography.small,
            fontWeight: FontWeight.w900,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3),
          child: Text(
            label,
            style: TextStyle(
              color: accent,
              fontSize: AppTypography.micro + 1,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ),
        Text(
          ']',
          style: TextStyle(
            color: accent.withValues(alpha: 0.6),
            fontSize: AppTypography.small,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}
