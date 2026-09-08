import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../theme/tokens.dart';
import '../model/hat_info.dart';
import 'app_card.dart';
import 'details_widget.dart';
import 'network_hat_image.dart';
import 'primary_button.dart';

/// Category tile for a single "hat" (role/interest). Lifts + shadows on
/// desktop hover to match ProjectCard's hover language; skipped when
/// `MediaQueryData.disableAnimations` is on.
class HatCard extends StatefulWidget {
  final HatInfo hat;

  const HatCard({super.key, required this.hat});

  @override
  State<HatCard> createState() => _HatCardState();
}

class _HatCardState extends State<HatCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final hat = widget.hat;
    final reduce = MediaQuery.of(context).disableAnimations;
    final hovered = _hover && !reduce;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: AppMotion.sm,
        curve: Curves.easeOut,
        transform: Matrix4.translationValues(0, hovered ? -4 : 0, 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.md),
          boxShadow: hovered
              ? [
                  BoxShadow(
                    color: hat.color.withValues(alpha: 0.35),
                    blurRadius: 22,
                    offset: const Offset(0, 10),
                  ),
                ]
              : const [],
        ),
        child: AppCard.filled(
          color: hat.color,
          padding: const EdgeInsets.all(AppSpacing.smd),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final imageHeight =
                  (constraints.maxHeight * 0.45).clamp(80.0, 200.0);
              final titleSize = (constraints.maxWidth * 0.11)
                  .clamp(AppTypography.titleSm, AppTypography.display - 2);
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    '${hat.title} ${'hat_card.suffix'.tr()}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: titleSize,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Hero(
                    tag: hat.heroTag,
                    createRectTween: (b, e) =>
                        MaterialRectArcTween(begin: b, end: e),
                    child: HatImage(
                      path: hat.image,
                      height: imageHeight,
                      semanticLabel: 'hat_card.image_alt'
                          .tr(namedArgs: {'title': hat.title}),
                    ),
                  ),
                  PrimaryButton(
                    label: 'hat_card.expand'.tr(),
                    horizontalPadding: 16,
                    fontSize: AppTypography.body,
                    onPressed: () {
                      Navigator.of(context).push(DetailsWidget.route(hat));
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
