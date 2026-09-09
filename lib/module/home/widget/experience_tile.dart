import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../theme/tokens.dart';
import '../model/experience.dart';
import 'site_cursor.dart';

class ExperienceTile extends StatefulWidget {
  final Experience exp;
  final bool isFirst;
  final bool isLast;

  const ExperienceTile({
    super.key,
    required this.exp,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  State<ExperienceTile> createState() => _ExperienceTileState();
}

class _ExperienceTileState extends State<ExperienceTile>
    with SingleTickerProviderStateMixin {
  bool _hover = false;
  late final AnimationController _pulse;
  late final bool _isCurrent;

  @override
  void initState() {
    super.initState();
    _isCurrent = widget.exp.period.toLowerCase().contains('present');
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isCurrent &&
        !_pulse.isAnimating &&
        !MediaQuery.of(context).disableAnimations) {
      _pulse.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    if (_hover) SiteCursor.hot.value--;
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final reduce = MediaQuery.of(context).disableAnimations;
    final hovered = _hover && !reduce;

    return MouseRegion(
      onEnter: (_) {
        setState(() => _hover = true);
        SiteCursor.hot.value++;
      },
      onExit: (_) {
        setState(() => _hover = false);
        SiteCursor.hot.value--;
      },
      child: AnimatedContainer(
        duration: AppMotion.sm,
        curve: Curves.easeOut,
        padding: EdgeInsets.only(
          left: hovered ? AppSpacing.xs : 0,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          color: hovered
              ? scheme.primary.withValues(alpha: 0.05)
              : Colors.transparent,
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ExcludeSemantics(
                child: _Timeline(
                  color: scheme.primary,
                  isFirst: widget.isFirst,
                  isLast: widget.isLast,
                  hover: hovered,
                  pulse: _isCurrent ? _pulse : null,
                ),
              ),
              const SizedBox(width: AppSpacing.mdx),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.lgx),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              widget.exp.role,
                              style: TextStyle(
                                fontSize: AppTypography.titleSm,
                                fontWeight: FontWeight.w800,
                                color: scheme.onSurface,
                              ),
                            ),
                          ),
                          if (_isCurrent) ...[
                            _NowChip(),
                            const SizedBox(width: AppSpacing.sm),
                          ],
                          Text(
                            widget.exp.period,
                            style: TextStyle(
                              fontSize: AppTypography.caption,
                              color: scheme.onSurface.withValues(alpha: 0.6),
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xs / 2),
                      Text(
                        widget.exp.company,
                        style: TextStyle(
                          fontSize: AppTypography.body,
                          fontWeight: FontWeight.w600,
                          color: scheme.primary,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      ...widget.exp.highlights.map(
                        (h) => Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: AppSpacing.smx),
                                child: Icon(
                                  Icons.circle,
                                  size: 5,
                                  color:
                                      scheme.onSurface.withValues(alpha: 0.5),
                                ),
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              Expanded(
                                child: Text(
                                  h,
                                  style: TextStyle(
                                    fontSize: AppTypography.small,
                                    height: 1.4,
                                    color: scheme.onSurface
                                        .withValues(alpha: 0.85),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NowChip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const green = Color(0xFF22C55E);
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 2),
      decoration: BoxDecoration(
        color: green.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(color: green.withValues(alpha: 0.6), width: 1),
      ),
      child: Text(
        'experience.now_chip'.tr(),
        style: const TextStyle(
          color: green,
          fontSize: AppTypography.micro - 1,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _Timeline extends StatelessWidget {
  final Color color;
  final bool isFirst;
  final bool isLast;
  final bool hover;
  final Animation<double>? pulse;

  const _Timeline({
    required this.color,
    required this.isFirst,
    required this.isLast,
    required this.hover,
    this.pulse,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 14,
      child: Column(
        children: [
          SizedBox(
            height: 6,
            child: isFirst
                ? const SizedBox.shrink()
                : Container(
                    width: 2,
                    color: color.withValues(alpha: hover ? 0.7 : 0.35),
                  ),
          ),
          _TimelineNode(color: color, hover: hover, pulse: pulse),
          Expanded(
            child: isLast
                ? const SizedBox.shrink()
                : Container(
                    width: 2,
                    color: color.withValues(alpha: hover ? 0.7 : 0.35),
                  ),
          ),
        ],
      ),
    );
  }
}

class _TimelineNode extends StatelessWidget {
  final Color color;
  final bool hover;
  final Animation<double>? pulse;

  const _TimelineNode({
    required this.color,
    required this.hover,
    this.pulse,
  });

  @override
  Widget build(BuildContext context) {
    final size = hover ? 18.0 : 14.0;
    final dot = AnimatedContainer(
      duration: AppMotion.sm,
      curve: Curves.easeOut,
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: hover ? 0.75 : 0.55),
            blurRadius: hover ? 14 : 8,
          ),
        ],
      ),
    );
    if (pulse == null) return dot;
    // Halo behind the node, for current-role items only.
    return SizedBox(
      width: size + 20,
      height: size + 20,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: pulse!,
            builder: (_, __) {
              final t = pulse!.value; // 0..1..0
              return Container(
                width: size + 6 + 12 * t,
                height: size + 6 + 12 * t,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.35 * (1 - t)),
                  shape: BoxShape.circle,
                ),
              );
            },
          ),
          dot,
        ],
      ),
    );
  }
}
