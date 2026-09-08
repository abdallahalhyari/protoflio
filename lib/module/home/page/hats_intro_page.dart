import 'package:flutter/material.dart';
import 'package:profile/l10n/app_localizations.dart';
import 'package:lottie/lottie.dart';
import '../../../theme/tokens.dart';
import '../widget/page_background.dart';
import '../widget/primary_button.dart';

class HatsIntroPage extends StatelessWidget {
  final VoidCallback onExplain;
  final PageController controller;
  final int pageIndex;

  const HatsIntroPage({super.key, 
    required this.onExplain,
    required this.controller,
    required this.pageIndex,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final loc = AppLocalizations.of(context)!;
    final headingSize =
        (size.width * 0.055).clamp(AppTypography.heading + 2, AppTypography.hero);
    final overlineSize = (size.width * 0.028)
        .clamp(AppTypography.titleSm, AppTypography.heading + 2);

    return PageBackground(
      asset: 'assets/hats_background.webp',
      overlay: AppColors.scrimLight,
      controller: controller,
      pageIndex: pageIndex,
      child: Center(
        child: Container(
          constraints: BoxConstraints(
            maxWidth: size.width / 1.3,
            maxHeight: size.height * 0.85,
          ),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.black54, Colors.black38, Colors.black26],
            ),
          ),
          padding: const EdgeInsets.all(AppSpacing.md + 2),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  loc.hatsIntroSubtitle,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: overlineSize,
                    fontWeight: FontWeight.w100,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs + 1),
                Text(
                  loc.hatsIntroTitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: headingSize,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                PrimaryButton(
                    label: loc.hatsIntroBtn, onPressed: onExplain),
                const SizedBox(height: AppSpacing.md),
                ExcludeSemantics(
                    child: Lottie.asset('assets/arrow.json', height: 140)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

