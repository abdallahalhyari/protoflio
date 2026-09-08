import 'package:flutter/material.dart';
import '../../../theme/tokens.dart';
import '../data/hats_data.dart';
import '../widget/hat_card.dart';

class HatsGridPage extends StatelessWidget {
  const HatsGridPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      padding: const EdgeInsets.all(AppSpacing.sm),
      child: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final crossAxisCount = constraints.maxWidth >= 900
                ? 3
                : constraints.maxWidth >= 600
                    ? 2
                    : 1;
            return GridView.builder(
              itemCount: kHats.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 1.05,
              ),
              itemBuilder: (context, i) => HatCard(hat: kHats[i]),
            );
          },
        ),
      ),
    );
  }
}

