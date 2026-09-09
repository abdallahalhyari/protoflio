import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:profile/l10n/app_localizations.dart';
import 'package:lottie/lottie.dart';
import '../../../theme/tokens.dart';
import '../../../service/sound_service.dart';
import '../widget/page_background.dart';
import '../widget/primary_button.dart';

class IntroPage extends StatefulWidget {
  final VoidCallback onScrollDown;
  final PageController controller;
  final int pageIndex;

  const IntroPage({
    super.key,
    required this.onScrollDown,
    required this.controller,
    required this.pageIndex,
  });

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  ui.Image? _portraitImage;
  Offset _mouseOffset = Offset.zero;

  @override
  void initState() {
    super.initState();
    _loadPortrait();
    widget.controller.addListener(_onScroll);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    if (mounted) setState(() {});
  }

  void _loadPortrait() {
    const imageProvider = AssetImage('assets/my_image.png');
    final stream = imageProvider.resolve(ImageConfiguration.empty);
    late ImageStreamListener listener;
    listener = ImageStreamListener(
      (ImageInfo info, bool _) {
        if (mounted) {
          setState(() {
            _portraitImage = info.image;
          });
        }
        stream.removeListener(listener);
      },
      onError: (_, __) {},
    );
    stream.addListener(listener);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final l10n = AppLocalizations.of(context)!;
    final isDesktop = size.width >= 900;

    double scrollProgress = 0.0;
    if (widget.controller.hasClients && widget.controller.position.haveDimensions) {
      scrollProgress = (widget.controller.page ?? 0.0).clamp(0.0, 1.0);
    }

    // Scroll-linked portrait morph: desaturate on scroll
    final double sat = (1.0 - scrollProgress * 0.9).clamp(0.1, 1.0);

    return PageBackground(
      asset: 'assets/background.webp',
      overlay: AppColors.scrimMedium,
      controller: widget.controller,
      pageIndex: widget.pageIndex,
      child: SafeArea(
        child: MouseRegion(
          onHover: (e) {
            final center = Offset(size.width / 2, size.height / 2);
            setState(() {
              _mouseOffset = Offset(
                ((e.position.dx - center.dx) / (size.width / 2)).clamp(-1.0, 1.0),
                ((e.position.dy - center.dy) / (size.height / 2)).clamp(-1.0, 1.0),
              );
            });
          },
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isDesktop ? AppSpacing.xxl : AppSpacing.md,
              vertical: AppSpacing.lg,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                    const SizedBox(height: AppSpacing.xl),

                    // Top editorial dateline & dispatch header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(width: 24, height: 1, color: const Color(0xFF818CF8)),
                        const SizedBox(width: AppSpacing.sm),
                        Text(
                          'THE DIGITAL DISPATCH // VOL. 24',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.8),
                            fontSize: (size.width * 0.012).clamp(11.0, 14.0),
                            fontWeight: FontWeight.w700,
                            letterSpacing: 3,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Container(width: 24, height: 1, color: const Color(0xFF818CF8)),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // GIANT TENADA WORDMARK HERO WITH PORTRAIT MASKED INSIDE
                    Semantics(
                      header: true,
                      label: 'Abdallah Alhyari, Mobile Architect',
                      child: Container(
                        constraints: BoxConstraints(
                          maxWidth: (size.width * 0.92).clamp(320.0, 1200.0),
                          maxHeight: (size.height * 0.38).clamp(160.0, 380.0),
                        ),
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Subtle stroke outline behind letterforms for crisp editorial definition
                              Text(
                                'ABDALLAH',
                                style: TextStyle(
                                  fontFamily: 'Tenada',
                                  fontSize: 220,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 10,
                                  height: 0.95,
                                  foreground: Paint()
                                    ..style = PaintingStyle.stroke
                                    ..strokeWidth = 3
                                    ..color = Colors.white.withValues(alpha: 0.25),
                                ),
                              ),

                              // Main masked text with portrait
                              ColorFiltered(
                                colorFilter: ColorFilter.matrix([
                                  0.2126 + 0.7874 * sat, 0.7152 - 0.7152 * sat, 0.0722 - 0.0722 * sat, 0, 0,
                                  0.2126 - 0.2126 * sat, 0.7152 + 0.2848 * sat, 0.0722 - 0.0722 * sat, 0, 0,
                                  0.2126 - 0.2126 * sat, 0.7152 - 0.7152 * sat, 0.0722 + 0.9278 * sat, 0, 0,
                                  0, 0, 0, 1, 0,
                                ]),
                                child: ShaderMask(
                                  blendMode: BlendMode.srcIn,
                                  shaderCallback: (bounds) {
                                    if (_portraitImage == null) {
                                      // Fallback gradient while asset loads
                                      return const LinearGradient(
                                        colors: [Color(0xFF818CF8), Color(0xFFC084FC)],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ).createShader(bounds);
                                    }

                                    final double imgW = _portraitImage!.width.toDouble();
                                    final double imgH = _portraitImage!.height.toDouble();
                                    
                                    // Scale image to cover bounds + scroll zoom + mouse parallax
                                    final double baseScale = math.max(bounds.width / imgW, bounds.height / imgH);
                                    final double scale = baseScale * (1.15 + scrollProgress * 0.25);
                                    
                                    final double tx = (bounds.width - imgW * scale) / 2 + (_mouseOffset.dx * 25);
                                    final double ty = (bounds.height - imgH * scale) / 2 + (_mouseOffset.dy * 25) - (scrollProgress * 40);

                                    final matrix = Float64List.fromList([
                                      scale, 0, 0, 0,
                                      0, scale, 0, 0,
                                      0, 0, 1, 0,
                                      tx, ty, 0, 1,
                                    ]);

                                    return ImageShader(
                                      _portraitImage!,
                                      TileMode.clamp,
                                      TileMode.clamp,
                                      matrix,
                                    );
                                  },
                                  child: const Text(
                                    'ABDALLAH',
                                    style: TextStyle(
                                      fontFamily: 'Tenada',
                                      fontSize: 220,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 10,
                                      height: 0.95,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: AppSpacing.sm),

                    // Surname & Editorial Masthead Line
                    Text(
                      'ALHYARI',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Tenada',
                        fontSize: (size.width * 0.035).clamp(20.0, 38.0),
                        fontWeight: FontWeight.w800,
                        letterSpacing: 12,
                        color: Colors.white,
                        shadows: const [
                          Shadow(
                            color: Colors.black,
                            blurRadius: 12,
                          ),
                          Shadow(
                            color: Colors.black,
                            blurRadius: 24,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: AppSpacing.md),

                    // Editorial Section Rules & Tagline with Frosted Backing for Maximum Readability
                    Container(
                      constraints: const BoxConstraints(maxWidth: 720),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.65),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.2), width: 1.5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.5),
                            blurRadius: 24,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(child: Container(height: 1, color: Colors.white24)),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                child: Text(
                                  '❖',
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.primary,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                              Expanded(child: Container(height: 1, color: Colors.white24)),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            l10n.introRole.toUpperCase(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: (size.width * 0.018).clamp(16.0, 22.0),
                              fontWeight: FontWeight.w800,
                              letterSpacing: 3,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            'FLUTTER · ANDROID (KOTLIN) · SMART CARDS & NFC · ENTERPRISE ARCHITECTURE',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: (size.width * 0.013).clamp(12.5, 14.5),
                              fontWeight: FontWeight.w600,
                              color: Colors.white.withValues(alpha: 0.95),
                              letterSpacing: 1.5,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Row(
                            children: [
                              Expanded(child: Container(height: 1, color: Colors.white24)),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                child: Text(
                                  l10n.introLocation.toUpperCase(),
                                  style: const TextStyle(
                                    color: Color(0xFFFDE68A),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 2,
                                  ),
                                ),
                              ),
                              Expanded(child: Container(height: 1, color: Colors.white24)),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: AppSpacing.xl),

                    // Call to Action with tactile click
                    PrimaryButton(
                      label: 'EXPLORE PUBLICATION',
                      onPressed: () {
                        SoundService.instance.playClick();
                        widget.onScrollDown();
                      },
                    ),

                    const SizedBox(height: AppSpacing.md),
                    ExcludeSemantics(
                      child: Lottie.asset('assets/arrow_white.json', height: 70),
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                  ],
                ),
              ),
        ),
      ),
    );
  }
}
