import 'package:flutter/material.dart';

import '../../service/analytics_service.dart';
import '../../theme/surface_tone.dart';
import '../../theme/tokens.dart';
import '../home/data/projects_data.dart';
import '../home/widget/editorial_chip.dart';
import '../home/widget/page_background.dart';
import '../home/widget/primary_button.dart';
import '../home/widget/projects/pipeline_topology_diagram.dart';
import '../home/widget/pulsing_dot.dart';
import 'case_study_widgets.dart';
import 'related_case_studies.dart';

/// Deep-dive case study on ESKADENIA Software's E-Learning & Healthcare
/// Enterprise Suite.
/// Full-screen scrollable narrative matching the NatHealth case-study pattern.
class EskadeniaCaseStudy extends StatefulWidget {
  const EskadeniaCaseStudy({super.key});

  static const String routePath = '/work/eskadenia';

  @override
  State<EskadeniaCaseStudy> createState() => _EskadeniaCaseStudyState();
}

class _EskadeniaCaseStudyState extends State<EskadeniaCaseStudy> {
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
    final hPad = CaseStudyLayout.horizontalPadding(context);

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
                        params: {'study': 'eskadenia'});
                    Navigator.of(context).maybePop();
                  },
                ),
                title: Text(
                  'ESKADENIA · CASE STUDY',
                  style: TextStyle(
                    fontSize: AppTypography.overline,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 2.4,
                    color: scheme.onSurface.withValues(alpha: 0.8),
                  ),
                ),
                actions: const [
                  CaseStudyToolbarShareButton(
                    slug: 'eskadenia',
                    title: 'E-Learning & Healthcare Enterprise Suite',
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
                    child:
                        const SectionKicker(number: '01', label: 'THE PROBLEM'),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  const Prose(
                    'ESKADENIA Software\'s enterprise mobile applications serve '
                    'high-concurrency operational environments across hospitals, '
                    'specialized medical clinics, universities, and training institutes '
                    'throughout the MENA region. Over successive releases, legacy codebases '
                    'had accumulated monolithic coupling: UI widgets were directly bound '
                    'to complex SQL query models, business validation rules lived inside '
                    'stateful widget trees, and network responses lacked strict schema contracts.',
                  ),
                  const SizedBox(height: AppSpacing.md),
                  const Prose(
                    'This architectural debt manifested as critical operational bottlenecks: '
                    'severe frame drops (jank) when scrolling dense medical records or university '
                    'rosters, memory bloat during multi-hour clinical shifts that led to '
                    'out-of-memory crashes on low-spec ward tablets, and high regression risk '
                    'whenever a feature team modified shared business logic.',
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  KeyedSubtree(
                    key: _roleKey,
                    child: const SectionKicker(number: '02', label: 'MY ROLE'),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  const BulletList(items: [
                    'Mobile Developer heading architectural refactoring, modular package extraction, and performance profiling across the Healthcare and Education software divisions.',
                    'Profiled memory allocations, widget rebuild trees, and GPU raster bottlenecks using Flutter DevTools and Android Profiler.',
                    'Rebuilt monolithic state into decoupled MVVM presentation pipelines backed by cached repositories and typed data contracts.',
                    'Engineered an incremental refactoring strategy allowing continuous production updates to hospital and campus systems with zero operational downtime.',
                  ]),
                  const SizedBox(height: AppSpacing.xxl),
                  KeyedSubtree(
                    key: _archKey,
                    child: const SectionKicker(
                        number: '03', label: 'SYSTEM ARCHITECTURE'),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  PipelineTopologyDiagram(
                    project: kProjects[1],
                    isDesktop: isDesktop,
                    isDark: isDark,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  const Prose(
                    'Decoupled Clean MVVM architecture enforcing strict directional '
                    'dependencies. The Presentation layer (View) communicates exclusively '
                    'with ViewModels through reactive ValueNotifiers and streams, entirely '
                    'unaware of backend transport details. ViewModels consume domain '
                    'Repositories backed by local SQLite/SQL Server cache layers and typed '
                    'REST services, wired through lightweight service locators for seamless '
                    'mocking and 100% test isolation.',
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  const TechnicalChapter(
                    number: '04',
                    title: 'MODULAR PACKAGE EXTRACTION',
                    steps: [
                      TechStep(
                        layer: 'AUDIT',
                        title: 'Dependency Graph Analysis',
                        body:
                            'Profiled the legacy monolithic codebase to map circular dependencies, shared static singletons, and leaky UI state. Identified core domain boundaries between clinical operations (HIS, Pharmacy, Radiology) and administrative flows.',
                      ),
                      TechStep(
                        layer: 'DECOUPLING',
                        title: 'Feature Package Partitioning',
                        body:
                            'Extracted monolithic modules into standalone Dart/Flutter packages with explicitly defined public API boundaries. Common logic (networking, auth, theme tokens, storage) was abstracted into a shared enterprise foundation package.',
                      ),
                      TechStep(
                        layer: 'INJECTION',
                        title: 'Service Locator & Repository Pattern',
                        body:
                            'Implemented lightweight dependency injection isolating concrete REST consumers from business logic. Feature squads could develop, mock, and unit-test modules independently without running full application builds.',
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  const TechnicalChapter(
                    number: '05',
                    title: 'HIGH-DENSITY RENDERING OPTIMIZATION',
                    steps: [
                      TechStep(
                        layer: 'VIEWPORT',
                        title: 'Custom Slivers & Lazy Loading',
                        body:
                            'Replaced naive nested list builders with customized CustomScrollView and SliverList implementations. Roster items, laboratory test cards, and course catalogs allocate only visible elements, maintaining a fixed memory envelope regardless of roster size.',
                      ),
                      TechStep(
                        layer: 'CACHE',
                        title: 'Two-Tier Caching & Query Deduplication',
                        body:
                            'Engineered an in-memory LRU cache backed by indexed local SQLite storage. Repeated lookups for doctor rosters, medication formularies, and student grades resolve instantaneously without redundant network roundtrips.',
                      ),
                      TechStep(
                        layer: 'RASTER',
                        title: 'GPU Paint & Clip Optimization',
                        body:
                            'Eliminated expensive saveLayer triggers caused by unnecessary Opacity and ClipRRect wrappers on data tables. Cached static table headers with RepaintBoundary, locking continuous 60 FPS scrolling on data-dense hospital screens.',
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  const TechnicalChapter(
                    number: '06',
                    title: 'ENTERPRISE RESILIENCE & ERROR HANDLING',
                    steps: [
                      TechStep(
                        layer: 'NETWORK',
                        title: 'Defensive Network Interceptors',
                        body:
                            'Standardized HTTP client pipelines with automated token refresh, transparent timeout envelopes, and exponential backoff retry policies for intermittent hospital Wi-Fi zones.',
                      ),
                      TechStep(
                        layer: 'VALIDATION',
                        title: 'Strict Schema Contracts & Type Safety',
                        body:
                            'Eliminated dynamic type casting by generating immutable Dart models with runtime validation. Invalid API responses fail fast at the network boundary rather than causing unhandled null pointer exceptions in UI trees.',
                      ),
                      TechStep(
                        layer: 'DIAGNOSTICS',
                        title: 'Proactive Crash Telemetry & Logging',
                        body:
                            'Integrated structured error reporting with breadcrumb logging across clinical shifts, enabling the engineering squad to diagnose and resolve production anomalies before users encounter disruptions.',
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
                      (
                        '60 FPS',
                        'sustained frame rate on dense hospital data tables and medical charts'
                      ),
                      (
                        '-35%',
                        'reduction in client-side crash rate across multi-hour clinical shifts'
                      ),
                      (
                        '1,000+',
                        'patient and student records rendered with zero viewport latency'
                      ),
                      (
                        '4',
                        'enterprise platforms deployed (HIS, Clinic, University, School)'
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  KeyedSubtree(
                    key: _lessonsKey,
                    child: const SectionKicker(number: '08', label: 'LESSONS'),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  const Prose(
                    'Enterprise software running in active hospital wards and university '
                    'registrar offices operates under zero-tolerance conditions for disruption. '
                    '\'Big-bang\' architecture rewrites frequently introduce more bugs than they solve. '
                    'The decisive factor in ESKADENIA\'s architectural transformation was incremental '
                    'module extraction: decoupling one subsystem at a time under strict regression '
                    'safety nets and continuous performance profiling.',
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  RelatedCaseStudies(
                    currentSlug: 'eskadenia',
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
                                params: {'study': 'eskadenia', 'cta': 'back'});
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
          const PulsingDot(color: AppColors.accentViolet),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              'MOBILE DEVELOPER · 2022 — 2024',
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
          'E-Learning & Healthcare Enterprise Suite',
          style: TextStyle(
            fontFamily: AppTypography.displayFont,
            fontSize: isDesktop
                ? AppTypography.displayLg
                : AppTypography.displaySm,
            fontWeight: FontWeight.w900,
            height: 1.05,
            color: scheme.onSurface,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          'High-performance enterprise mobile architecture powering Hospital Information Systems (HIS) and Education platforms across the MENA region. Rebuilt legacy monolithic codebases into decoupled, testable feature packages with zero operational downtime.',
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
            EditorialChip(label: 'Dart', tone: ChipTone.sky),
            EditorialChip(label: 'MVVM Architecture', tone: ChipTone.primary),
            EditorialChip(label: 'REST APIs', tone: ChipTone.neutral),
            EditorialChip(label: 'SQL Server', tone: ChipTone.amber),
            EditorialChip(label: 'DevTools Profiling', tone: ChipTone.green),
            EditorialChip(label: 'Modular Packages', tone: ChipTone.indigo),
            EditorialChip(label: 'Clean Repository', tone: ChipTone.neutral),
          ],
        ),
        const CaseStudyCorporateHeader(
          company: 'ESKADENIA Software',
          websiteUrl: 'https://www.eskadenia.com',
          linkedinUrl: 'https://www.linkedin.com/company/eskadenia-software',
          slug: 'eskadenia',
          title: 'E-Learning & Healthcare Enterprise Suite',
        ),
      ],
    );
  }
}
