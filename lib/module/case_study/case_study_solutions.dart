import 'package:flutter/material.dart';

import '../../service/analytics_service.dart';
import '../../theme/surface_tone.dart';
import '../../theme/tokens.dart';
import '../../theme_controller.dart';
import '../home/data/projects_data.dart';
import '../home/widget/editorial_chip.dart';
import '../home/widget/page_background.dart';
import '../home/widget/primary_button.dart';
import '../home/widget/projects/pipeline_topology_diagram.dart';
import '../home/widget/pulsing_dot.dart';
import 'case_study_widgets.dart';
import 'related_case_studies.dart';

/// Deep-dive case study on Solutions Now IT's Loyalty Rewards & Ephemeral
/// Social Media Apps.
/// Full-screen scrollable narrative matching the NatHealth case-study pattern.
class SolutionsCaseStudy extends StatefulWidget {
  const SolutionsCaseStudy({super.key});

  static const String routePath = '/work/solutions';

  @override
  State<SolutionsCaseStudy> createState() => _SolutionsCaseStudyState();
}

class _SolutionsCaseStudyState extends State<SolutionsCaseStudy> {
  late final ScrollController _scrollController;
  final GlobalKey _problemKey = GlobalKey();
  final GlobalKey _roleKey = GlobalKey();
  final GlobalKey _archKey = GlobalKey();
  final GlobalKey _outcomesKey = GlobalKey();
  final GlobalKey _lessonsKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    ThemeController.updateSeedFromHash('work/solutions');
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = context.isDarkMode;
    final isDesktop = MediaQuery.sizeOf(context).width >= AppBreakpoints.tablet;
    final hPad = isDesktop ? 96.0 : AppSpacing.lg;

    final chapters = [
      CaseStudyChapter(
        id: 'problem',
        label: '01 PROBLEM',
        shortLabel: 'PROB',
        key: _problemKey,
      ),
      CaseStudyChapter(
        id: 'role',
        label: '02 ROLE',
        shortLabel: 'ROLE',
        key: _roleKey,
      ),
      CaseStudyChapter(
        id: 'architecture',
        label: '03 ARCH',
        shortLabel: 'ARCH',
        key: _archKey,
      ),
      CaseStudyChapter(
        id: 'outcomes',
        label: '07 OUTCOMES',
        shortLabel: 'RESULTS',
        key: _outcomesKey,
      ),
      CaseStudyChapter(
        id: 'lessons',
        label: '08 LESSONS',
        shortLabel: 'LESSONS',
        key: _lessonsKey,
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: PageBackground(
        child: CaseStudyReadingCompanion(
          scrollController: _scrollController,
          chapters: chapters,
          primaryAccent: AppColors.caseStudySolutionsPrimary,
          secondaryAccent: AppColors.caseStudySolutionsSecondary,
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
            SliverAppBar(
              pinned: true,
              backgroundColor: isDark
                  ? AppColors.darkSurface.withValues(alpha: 0.94)
                  : Colors.white.withValues(alpha: 0.94),
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_rounded),
                tooltip: 'Back to portfolio',
                onPressed: () {
                  Analytics.event('case_study_back',
                      params: {'study': 'solutions'});
                  ThemeController.updateSeedFromHash('work');
                  Navigator.of(context).maybePop();
                },
              ),
              title: Text(
                'SOLUTIONS NOW · CASE STUDY',
                style: TextStyle(
                  fontSize: AppTypography.overline,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 2.4,
                  color: scheme.onSurface.withValues(alpha: 0.8),
                ),
              ),
              actions: const [
                CaseStudyToolbarShareButton(
                  slug: 'solutions',
                  title: 'Loyalty Rewards & Ephemeral Social Media Apps',
                ),
                SizedBox(width: AppSpacing.sm),
              ],
            ),
            SliverPadding(
              padding: EdgeInsets.symmetric(
                horizontal: hPad,
                vertical: AppSpacing.xl,
              ),
              sliver: SliverList.list(children: [
                _Masthead(isDesktop: isDesktop),
                const SizedBox(height: AppSpacing.xxl),
                KeyedSubtree(
                  key: _problemKey,
                  child: const SectionKicker(number: '01', label: 'THE PROBLEM'),
                ),
                const SizedBox(height: AppSpacing.md),
                const Prose(
                  'As a fast-paced technology consultancy, Solutions Now IT needed to '
                  'engineer and deliver two distinct, high-volume consumer mobile applications '
                  'under compressed commercial deadlines. The first was an enterprise loyalty '
                  'rewards platform with real-time balance tracking, QR-code redemptions, '
                  'and tier progressions; the second was an ephemeral social story app featuring '
                  'instant camera capture, high-definition video recording, and fluid horizontal feed navigation.',
                ),
                const SizedBox(height: AppSpacing.md),
                const Prose(
                  'The technical hurdles were formidable: media pipelines on Android '
                  'frequently suffered from aspect-ratio distortion and native camera surface '
                  'buffer leaks across heterogeneous OEM devices. Furthermore, building two full '
                  'applications from scratch simultaneously risked code duplication, inconsistent '
                  'UX behaviors, and doubled testing overhead.',
                ),
                const SizedBox(height: AppSpacing.xxl),
                KeyedSubtree(
                  key: _roleKey,
                  child: const SectionKicker(number: '02', label: 'MY ROLE'),
                ),
                const SizedBox(height: AppSpacing.md),
                const BulletList(items: [
                  'Core Flutter Developer architecting cross-platform mobile standards and engineering core media and transaction pipelines.',
                  'Engineered the native camera capture and video recording engine with hardware codec acceleration.',
                  'Built background Dart isolates for image and video compression prior to AWS S3 multi-part uploads, preserving UI responsiveness.',
                  'Designed and implemented an internal atomic design token library shared between both consumer client applications.',
                ]),
                const SizedBox(height: AppSpacing.xxl),
                KeyedSubtree(
                  key: _archKey,
                  child: const SectionKicker(number: '03', label: 'SYSTEM ARCHITECTURE'),
                ),
                const SizedBox(height: AppSpacing.md),
                PipelineTopologyDiagram(
                  project: kProjects[2],
                  isDesktop: isDesktop,
                  isDark: isDark,
                ),
                const SizedBox(height: AppSpacing.md),
                const Prose(
                  'Layered Component Architecture prioritizing reusability, hardware '
                  'isolation, and asynchronous processing. High-frequency camera preview frames '
                  'feed directly into hardware texture buffers, decoupled from the Flutter '
                  'widget tree. Media encoding and compression execute off the main thread in '
                  'dedicated background isolates, streaming progress to the UI via broadcast '
                  'ports without dropping presentation frames.',
                ),
                const SizedBox(height: AppSpacing.xxl),
                const TechnicalChapter(
                  number: '04',
                  title: 'CAMERA PIPELINE & ISOLATE COMPRESSION',
                  steps: [
                    TechStep(
                      layer: 'HARDWARE',
                      title: 'Native Camera Controller Lifecycle',
                      body:
                          'Engineered robust lifecycle management for camera preview textures, managing focus modes, exposure locks, and orientation transforms across diverse Android device configurations and iOS devices.',
                    ),
                    TechStep(
                      layer: 'CONCURRENCY',
                      title: 'Background Dart Isolate Compression',
                      body:
                          'Offloaded video bitrate transcoding and thumbnail image generation to background Dart isolates. By isolating CPU-intensive byte compression from the UI isolate, the application maintains a stutter-free 60 FPS recording viewfinder.',
                    ),
                    TechStep(
                      layer: 'STORAGE',
                      title: 'Resumable Multi-Part AWS S3 Uploads',
                      body:
                          'Designed chunked background uploads utilizing presigned AWS S3 URLs with automatic resume upon transient network disconnects, ensuring user media was never lost.',
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xxl),
                const TechnicalChapter(
                  number: '05',
                  title: 'EPHEMERAL STORY CAROUSEL ENGINE',
                  steps: [
                    TechStep(
                      layer: 'GESTURE',
                      title: 'Interactive Playback State Machine',
                      body:
                          'Engineered a fluid gesture recognizer supporting press-and-hold pause, left/right edge taps for story progression, and vertical swipes for dismissal, perfectly synchronized with segment progress bars.',
                    ),
                    TechStep(
                      layer: 'MEMORY',
                      title: 'Anticipatory Video Buffering & Eviction',
                      body:
                          'Implemented a sliding-window media cache: pre-buffering the upcoming two video segments while aggressively releasing watched segments to prevent memory leaks during long browsing sessions.',
                    ),
                    TechStep(
                      layer: 'TRANSITION',
                      title: 'Seamless Horizontal Page Transformation',
                      body:
                          'Crafted custom cube and depth page transitions using 3D Matrix4 transformations that smoothly lerp based on scroll position without clipping or texture flickering.',
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xxl),
                const TechnicalChapter(
                  number: '06',
                  title: 'UNIFIED ATOMIC DESIGN SYSTEM',
                  steps: [
                    TechStep(
                      layer: 'TOKENS',
                      title: 'Design Token Foundation',
                      body:
                          'Standardized typography, spacing, radius, and color semantics into an extensible token layer, ensuring consistent brand expression across dark and light presentation modes.',
                    ),
                    TechStep(
                      layer: 'COMPONENTS',
                      title: 'Reusable Component Catalog',
                      body:
                          'Built a comprehensive suite of accessible buttons, modal sheets, badges, and input controls used across both the loyalty and social apps, cutting subsequent feature turnaround time by 40%.',
                    ),
                    TechStep(
                      layer: 'PARITY',
                      title: 'Cross-Platform Visual Parity',
                      body:
                          'Ensured haptic feedback, spring physics, and bounce curves mirrored native platform expectations seamlessly across both Apple iOS and Google Android handsets.',
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xxl),
                KeyedSubtree(
                  key: _outcomesKey,
                  child: const SectionKicker(number: '07', label: 'OUTCOMES'),
                ),
                const SizedBox(height: AppSpacing.md),
                OutcomeGrid(
                  isDesktop: isDesktop,
                  items: const [
                    ('4.7+', 'average star rating across iOS App Store and Google Play'),
                    ('40%', 'reduction in subsequent feature turnaround time via shared component library'),
                    ('0', 'dropped frames during horizontal story carousel gesture navigation'),
                    ('2', 'production consumer applications launched simultaneously on schedule'),
                  ],
                ),
                const SizedBox(height: AppSpacing.xxl),
                KeyedSubtree(
                  key: _lessonsKey,
                  child: const SectionKicker(number: '08', label: 'LESSONS'),
                ),
                const SizedBox(height: AppSpacing.md),
                const Prose(
                  'Mobile media applications live or die by memory hygiene and hardware '
                  'lifecycle management. Android OEM variations in camera sensor orientation, '
                  'buffer allocation, and codec support mean that defensive abstraction layers '
                  'and background thread isolation are mandatory from day one. Investing early '
                  'in a unified design system proved to be the single highest-ROI architectural '
                  'decision for the consultancy\'s velocity.',
                ),
                const SizedBox(height: AppSpacing.xxl),
                RelatedCaseStudies(
                  currentSlug: 'solutions',
                  isDesktop: isDesktop,
                ),
                const SizedBox(height: AppSpacing.xxl),
                Center(
                  child: Wrap(
                    spacing: AppSpacing.md,
                    runSpacing: AppSpacing.md,
                    alignment: WrapAlignment.center,
                    children: [
                      PrimaryButton(
                        label: 'Back to portfolio',
                        icon: Icons.arrow_back_rounded,
                        size: PrimaryButtonSize.md,
                        onPressed: () {
                          Analytics.event('case_study_cta',
                              params: {'study': 'solutions', 'cta': 'back'});
                          ThemeController.updateSeedFromHash('work');
                          Navigator.of(context).maybePop();
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
              ]),
            ),
          ],
        ),
      ),
    ),
  );
}
}

class _Masthead extends StatelessWidget {
  const _Masthead({required this.isDesktop});

  final bool isDesktop;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          const PulsingDot(color: AppColors.accentAmber),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              'FLUTTER DEVELOPER · 2021 — 2022',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: AppTypography.editorial,
                letterSpacing: 3,
                fontWeight: FontWeight.w800,
                color: scheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ),
        ]),
        const SizedBox(height: AppSpacing.md),
        Text(
          'Loyalty Rewards & Ephemeral Social Media Apps',
          style: TextStyle(
            fontFamily: AppTypography.displayFont,
            fontSize: isDesktop ? 54 : 36,
            fontWeight: FontWeight.w900,
            height: 1.05,
            color: scheme.onSurface,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          'High-throughput consumer iOS and Android applications: a real-time loyalty redemption engine and a Snapchat-style ephemeral video/story camera platform. Built with hardware-accelerated video pipelines and an internal reusable design system.',
          style: TextStyle(
            fontSize: AppTypography.subtitle,
            height: 1.55,
            color: scheme.onSurface.withValues(alpha: 0.85),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: const [
            EditorialChip(label: 'Flutter', tone: ChipTone.indigo),
            EditorialChip(label: 'Camera Engine', tone: ChipTone.amber),
            EditorialChip(label: 'AWS S3', tone: ChipTone.sky),
            EditorialChip(label: 'REST APIs', tone: ChipTone.neutral),
            EditorialChip(label: 'Design System', tone: ChipTone.primary),
            EditorialChip(label: 'Isolate Compression', tone: ChipTone.green),
            EditorialChip(label: 'Real-Time Feeds', tone: ChipTone.indigo),
          ],
        ),
        const CaseStudyCorporateHeader(
          company: 'Solutions Now IT',
          websiteUrl: 'https://itsolutions-now.com',
          linkedinUrl: 'https://www.linkedin.com/company/solutionsnowit',
          slug: 'solutions',
          title: 'Loyalty Rewards & Ephemeral Social Media Apps',
        ),
      ],
    );
  }
}
