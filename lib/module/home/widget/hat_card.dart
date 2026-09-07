import 'package:flutter/material.dart';
import '../../../theme/tokens.dart';
import '../model/hat_info.dart';
import 'details_widget.dart';
import 'network_hat_image.dart';
import 'primary_button.dart';

class HatCard extends StatelessWidget {
  final HatInfo hat;

  const HatCard({super.key, required this.hat});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: hat.color,
      padding: const EdgeInsets.all(AppSpacing.smd),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final imageHeight = (constraints.maxHeight * 0.45).clamp(80.0, 200.0);
          final titleSize = (constraints.maxWidth * 0.11)
              .clamp(AppTypography.titleSm, AppTypography.display - 2);
          final hatSize = (constraints.maxWidth * 0.08)
              .clamp(AppTypography.body, AppTypography.heading);
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                hat.title,
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
                  semanticLabel: '${hat.title} hat illustration',
                ),
              ),
              Text(
                'Hat',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: hatSize,
                  fontWeight: FontWeight.w900,
                ),
              ),
              PrimaryButton(
                label: 'Expand',
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
    );
  }
}
