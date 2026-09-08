import 'package:flutter/material.dart';
import 'package:profile/l10n/app_localizations.dart';
import 'package:lottie/lottie.dart';
import '../../../theme/tokens.dart';
import '../widget/page_background.dart';
import '../widget/primary_button.dart';

class IntroPage extends StatelessWidget {
  final VoidCallback onScrollDown;
  final PageController controller;
  final int pageIndex;
  
  const IntroPage({super.key, 
    required this.onScrollDown,
    required this.controller,
    required this.pageIndex,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isWide = size.width >= 800;
    final avatarRadius = (size.shortestSide * 0.22).clamp(80.0, 180.0);
    final l10n = AppLocalizations.of(context)!;

    return PageBackground(
      asset: 'assets/background.webp',
      overlay: AppColors.scrimMedium,
      controller: controller,
      pageIndex: pageIndex,
      child: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: size.height),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: isWide ? AppSpacing.xxl - 8 : AppSpacing.lg),
                Semantics(
                  header: true,
                  child: ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [Color(0xFF818CF8), Color(0xFFC084FC)], // Indigo to Purple
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ).createShader(bounds),
                    child: Text(
                      l10n.introHiName,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: (size.width * 0.06).clamp(AppTypography.heading, AppTypography.heroLg),
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        height: 1.1,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Semantics(
                  label: 'Portrait of Abdallah Alhyari',
                  image: true,
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    padding: const EdgeInsets.all(AppSpacing.xs - 1),
                    child: CircleAvatar(
                      radius: avatarRadius,
                      backgroundColor: Colors.brown.shade300,
                      backgroundImage: const AssetImage('assets/my_image.png'),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  l10n.introRole,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: (size.width * 0.035).clamp(AppTypography.title, AppTypography.display),
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: AppColors.textScrim,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  l10n.introLocation,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: (size.width * 0.02).clamp(AppTypography.body, AppTypography.title),
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withValues(alpha: 0.85),
                    letterSpacing: 0.5,
                    shadows: AppColors.textScrim,
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                PrimaryButton(label: 'Scroll Down', onPressed: onScrollDown),
                const SizedBox(height: AppSpacing.md),
                ExcludeSemantics(
                    child: Lottie.asset('assets/arrow_white.json', height: 80)),
                const SizedBox(height: AppSpacing.md),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

