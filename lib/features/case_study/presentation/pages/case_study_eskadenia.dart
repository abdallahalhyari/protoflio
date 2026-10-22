import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:profile/core/services/analytics_service.dart';
import 'package:profile/core/theme/tokens.dart';
import 'package:profile/features/case_study/presentation/pages/related_case_studies.dart';
import 'package:profile/features/case_study/presentation/widgets/case_study_widgets.dart';
import 'package:profile/features/projects/domain/repositories/project_repository.dart';
import 'package:profile/features/projects/presentation/widgets/pipeline_topology_diagram.dart';
import 'package:profile/l10n/app_localizations.dart';
import 'package:profile/shared/widgets/editorial_chip.dart';
import 'package:profile/shared/widgets/primary_button.dart';
import 'package:profile/core/theme/surface_tone.dart';
import 'package:profile/shared/widgets/retrying_asset_image.dart';

/// Deep-dive case study on ESKADENIA Software's E-Learning & Healthcare
/// Enterprise Suite.
/// Full-screen scrollable narrative matching the NatHealth case-study pattern.
class EskadeniaCaseStudy extends StatelessWidget {
  const EskadeniaCaseStudy({super.key});

  static const String routePath = '/work/eskadenia';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return CaseStudyScaffold(
      slug: 'eskadenia',
      appBarTitle: l10n.studyCaseStudy('ESKADENIA'),
      shareTitle: 'E-Learning & Healthcare Enterprise Suite',
      sliversBuilder: (context, keys, isDesktop) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return [
          _Masthead(isDesktop: isDesktop),
          const SizedBox(height: AppSpacing.xl),
          CaseStudyAtAGlance(
            slug: 'eskadenia',
            challenge: l10n.studyEskChallenge,
            built: l10n.studyEskBuilt,
            result: l10n.studyEskResult,
            outcomesKey: keys.outcomesKey,
            isDesktop: isDesktop,
          ),
          CaseStudyLanguageNote(l10n.studyEnglishNote),
          const SizedBox(height: AppSpacing.xxl),
          KeyedSubtree(
            key: keys.problemKey,
            child: ChapterHeading(l10n.studyProblem),
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
            key: keys.roleKey,
            child: ChapterHeading(l10n.studyRole),
          ),
          const SizedBox(height: AppSpacing.md),
          const BulletList(items: [
            'Flutter developer heading architectural refactoring, modular package extraction, and performance profiling across the Healthcare and Education software divisions.',
            'Profiled memory allocations, widget rebuild trees, and GPU raster bottlenecks using Flutter DevTools and Android Profiler.',
            'Rebuilt monolithic state into decoupled MVVM presentation pipelines backed by cached repositories and typed data contracts.',
            'Planned the refactor in small steps, so hospital and campus systems kept receiving production updates throughout.',
          ]),
          const SizedBox(height: AppSpacing.xxl),
          KeyedSubtree(
            key: keys.archKey,
            child: ChapterHeading(l10n.studyArchitecture),
          ),
          const SizedBox(height: AppSpacing.md),
          EnglishContent(
            child: PipelineTopologyDiagram(
              project: context.read<ProjectRepository>().getProjectByIndex(1)!,
              isDesktop: isDesktop,
              isDark: isDark,
              showTitle: false,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          const Prose(
            'Decoupled Clean MVVM architecture enforcing strict directional '
            'dependencies. The Presentation layer (View) communicates exclusively '
            'with ViewModels through reactive ValueNotifiers and streams, entirely '
            'unaware of backend transport details. ViewModels consume domain '
            'Repositories backed by local SQLite/SQL Server cache layers and typed '
            'REST services, wired through a service locator so each piece can be '
            'replaced with a fake in tests.',
          ),
          const SizedBox(height: AppSpacing.xxl),
          const TechnicalChapter(
            title: 'Modular package extraction',
            steps: [
              TechStep(
                layer: 'Audit',
                title: 'Mapping the dependencies',
                body:
                    'Profiled the legacy monolithic codebase to map circular dependencies, shared static singletons, and leaky UI state. Identified core domain boundaries between clinical operations (HIS, Pharmacy, Radiology) and administrative flows.',
              ),
              TechStep(
                layer: 'Decoupling',
                title: 'One package per feature',
                body:
                    'Extracted monolithic modules into standalone Dart/Flutter packages with explicitly defined public API boundaries. Common logic (networking, auth, theme tokens, storage) was abstracted into a shared enterprise foundation package.',
              ),
              TechStep(
                layer: 'Injection',
                title: 'Service locator & repositories',
                body:
                    'Implemented lightweight dependency injection isolating concrete REST consumers from business logic. Feature squads could develop, mock, and unit-test modules independently without running full application builds.',
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xxl),
          const TechnicalChapter(
            title: 'Rendering dense screens',
            steps: [
              TechStep(
                layer: 'Viewport',
                title: 'Custom slivers & lazy loading',
                body:
                    'Replaced naive nested list builders with customized CustomScrollView and SliverList implementations. Roster items, laboratory test cards, and course catalogs allocate only visible elements, maintaining a fixed memory envelope regardless of roster size.',
              ),
              TechStep(
                layer: 'Cache',
                title: 'Two-level cache & duplicate queries',
                body:
                    'An in-memory LRU cache backed by indexed local SQLite storage. Repeated lookups for doctor rosters, medication formularies, and student grades come from the cache without redundant network roundtrips.',
              ),
              TechStep(
                layer: 'Raster',
                title: 'Cheaper painting & clipping',
                body:
                    'Eliminated expensive saveLayer triggers caused by unnecessary Opacity and ClipRRect wrappers on data tables. Cached static table headers with RepaintBoundary, locking continuous 60 FPS scrolling on data-dense hospital screens.',
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xxl),
          const TechnicalChapter(
            title: 'Error handling',
            steps: [
              TechStep(
                layer: 'Network',
                title: 'Network interceptors',
                body:
                    'Standardized HTTP client pipelines with automated token refresh, transparent timeout envelopes, and exponential backoff retry policies for intermittent hospital Wi-Fi zones.',
              ),
              TechStep(
                layer: 'Validation',
                title: 'Typed API contracts',
                body:
                    'Eliminated dynamic type casting by generating immutable Dart models with runtime validation. Invalid API responses fail fast at the network boundary rather than causing unhandled null pointer exceptions in UI trees.',
              ),
              TechStep(
                layer: 'Diagnostics',
                title: 'Crash reporting & logging',
                body:
                    'Integrated structured error reporting with breadcrumb logging across clinical shifts, enabling the engineering squad to diagnose and resolve production anomalies before users encounter disruptions.',
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xxl),
          KeyedSubtree(
            key: keys.outcomesKey,
            child: ChapterHeading(l10n.studyOutcomes),
          ),
          const SizedBox(height: AppSpacing.md),
          OutcomeGrid(
            isDesktop: isDesktop,
            items: [
              ('60 FPS', l10n.studyEskOutcome1),
              ('-35%', l10n.studyEskOutcome2),
              ('4', l10n.studyEskOutcome4),
            ],
          ),
          const SizedBox(height: AppSpacing.xxl),
          KeyedSubtree(
            key: keys.lessonsKey,
            child: ChapterHeading(l10n.studyLessons),
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
                  label: l10n.studyBackToPortfolio,
                  icon: Icons.arrow_back_rounded,
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
        ];
      },
    );
  }
}

class _Masthead extends StatelessWidget {
  const _Masthead({required this.isDesktop});

  final bool isDesktop;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          Expanded(
            child: Text(
              '${l10n.studyRoleFlutterDev}, 2022–2024',
              // Two lines on phones rather than clipping the end date
              // ("2024 — PRES…").
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: AppTypography.label,
                fontWeight: FontWeight.w800,
                color: context.mutedText,
              ),
            ),
          ),
        ]),
        const SizedBox(height: AppSpacing.md),
        Text(
          'E-Learning & Healthcare Enterprise Suite',
          style: TextStyle(
            fontFamily: AppTypography.displayFont,
            fontSize: isDesktop ? AppTypography.hero : AppTypography.display,
            fontWeight: FontWeight.w900,
            height: 1.05,
            color: scheme.onSurface,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.card),
          child: Container(
            height: isDesktop ? 180 : 130,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.card),
              border: Border.all(
                color: scheme.primary.withValues(alpha: 0.3),
              ),
            ),
            child: Hero(
              tag: 'project_hero_eskadenia',
              child: RetryingAssetImage(
                'assets/images/projects/eskadenia.webp',
                fit: BoxFit.cover,
                excludeFromSemantics: true,
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          l10n.studyEskIntro,
          style: TextStyle(
            fontSize: AppTypography.lead,
            height: 1.55,
            color: scheme.onSurface.withValues(alpha: 0.85),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            for (final tech in const [
              'Flutter',
              'Dart',
              'MVVM Architecture',
              'REST APIs',
              'SQL Server',
              'DevTools Profiling',
              'Modular Packages',
              'Clean Repository',
            ])
              EditorialChip(
                label: tech,
                tone: ChipTone.neutral,
                variant: ChipVariant.outline,
              ),
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
