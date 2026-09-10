import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../../theme/tokens.dart';
import '../../../service/sound_service.dart';

import '../widget/primary_button.dart';
import '../widget/screen_shell.dart';

class HatsIntroPage extends StatelessWidget {
  final VoidCallback onExplain;
  final PageController controller;
  final int pageIndex;

  const HatsIntroPage({
    super.key,
    required this.onExplain,
    required this.controller,
    required this.pageIndex,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isDesktop = size.width >= AppBreakpoints.tablet;

      // AppScreenShell centers content, caps maxWidth, and auto-reserves
      // top space for the desktop TopNav so this page follows the same
      // shell contract as every other page.
      return AppScreenShell(
        maxWidth: 960,
        hPad: isDesktop ? AppSpacing.xxl : AppSpacing.md,
        verticalPadding: AppSpacing.lg,
        child: SingleChildScrollView(
          primary: false,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.82),
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(color: Colors.white.withValues(alpha: 0.2), width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.6),
                  blurRadius: 36,
                  spreadRadius: 6,
                ),
              ],
            ),
            padding: EdgeInsets.all(isDesktop ? AppSpacing.xxl : AppSpacing.lg),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Letter-sized giant quote marks in background
                Positioned(
                  top: -40,
                  left: -10,
                  child: IgnorePointer(
                    child: Text(
                      '“',
                      style: TextStyle(
                        fontFamily: 'Tenada',
                        fontSize: (size.width * 0.22).clamp(100.0, 220.0),
                        color: Colors.white.withValues(alpha: 0.12),
                        height: 0.8,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -60,
                  right: -10,
                  child: IgnorePointer(
                    child: Text(
                      '”',
                      style: TextStyle(
                        fontFamily: 'Tenada',
                        fontSize: (size.width * 0.22).clamp(100.0, 220.0),
                        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.15),
                        height: 0.8,
                      ),
                    ),
                  ),
                ),

                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Editorial header: rule + kicker + rule (matches the
                    // masthead treatment used on the intro cover).
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            width: 32,
                            height: 1,
                            color: const Color(0xFF818CF8)),
                        const SizedBox(width: 10),
                        const Flexible(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              'ESSAY 01 · OPERATING PHILOSOPHY',
                              style: TextStyle(
                                color: Color(0xFFB6C9FF),
                                fontSize: 11,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 4,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                            width: 32,
                            height: 1,
                            color: const Color(0xFF818CF8)),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xl),

                    // Typographic manifesto lockup — no more boxed pills.
                    // "BECAUSE" as a display-weight kicker; "I WEAR"
                    // subline; "MANY HATS" as the gradient hero.
                    Text(
                      'BECAUSE',
                      style: TextStyle(
                        fontFamily: 'Tenada',
                        fontSize: (size.width * 0.032).clamp(22.0, 40.0),
                        fontWeight: FontWeight.w900,
                        letterSpacing: 8,
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                    const SizedBox(height: 4),

                    Text(
                      'I WEAR',
                      style: TextStyle(
                        fontSize: (size.width * 0.028).clamp(18.0, 36.0),
                        fontWeight: FontWeight.w600,
                        letterSpacing: 12,
                        color: Colors.white.withValues(alpha: 0.75),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),

                    // Giant Tenada "MANY HATS"
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [Color(0xFFFFFFFF), Color(0xFFFDE68A), Color(0xFFF59E0B)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ).createShader(bounds),
                        child: Text(
                          'MANY HATS',
                          style: TextStyle(
                            fontFamily: 'Tenada',
                            fontSize: (size.width * 0.085).clamp(42.0, 92.0),
                            fontWeight: FontWeight.w900,
                            letterSpacing: 8,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: AppSpacing.md),
                    Container(
                      height: 1.5,
                      width: 140,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.transparent, Color(0xFF818CF8), Colors.transparent],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // Editorial Manifesto Body Text - High Contrast & Crisp Readability
                    Container(
                      constraints: const BoxConstraints(maxWidth: 680),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.45),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.white12),
                      ),
                      child: Text(
                        'True technical excellence does not live in an isolated silo. '
                        'From architecting robust offline synchronization and cryptographic security, '
                        'to product empathy, cross-functional leadership, and relentless debugging—'
                        'every challenge demands its own dedicated mindset.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: (size.width * 0.018).clamp(15.0, 18.0),
                          fontWeight: FontWeight.w500,
                          height: 1.75,
                          color: Colors.white,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),

                    const SizedBox(height: AppSpacing.xl),

                    // Primary button with sound
                    PrimaryButton(
                      label: 'DEAL THE HATS TABLE',
                      onPressed: () {
                        SoundService.instance.playClick();
                        onExplain();
                      },
                    ),

                    const SizedBox(height: AppSpacing.sm),
                    ExcludeSemantics(
                      child: Opacity(
                        opacity: 0.6,
                        child: Lottie.asset('assets/arrow.json', height: 48),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
  }
}
