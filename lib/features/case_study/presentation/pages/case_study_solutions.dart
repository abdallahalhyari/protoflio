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

/// Deep-dive case study on Solutions Now IT's Loyalty Rewards & Ephemeral Social
/// Media Client Apps.
/// Full-screen scrollable narrative matching the NatHealth case-study pattern.
class SolutionsCaseStudy extends StatelessWidget {
  const SolutionsCaseStudy({super.key});

  static const String routePath = '/work/solutions';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return CaseStudyScaffold(
      slug: 'solutions',
      appBarTitle: 'SOLUTIONS NOW · ${l10n.studyCaseStudy}',
      shareTitle: 'Loyalty Rewards & Ephemeral Social Media Apps',
      sliversBuilder: (context, keys, isDesktop) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return [
          _Masthead(isDesktop: isDesktop),
          const SizedBox(height: AppSpacing.xl),
          CaseStudyAtAGlance(
            slug: 'solutions',
            challenge: l10n.studySolChallenge,
            built: l10n.studySolBuilt,
            result: l10n.studySolResult,
            outcomesKey: keys.outcomesKey,
            isDesktop: isDesktop,
          ),
          CaseStudyLanguageNote(l10n.studyEnglishNote),
          const SizedBox(height: AppSpacing.xxl),
          KeyedSubtree(
            key: keys.problemKey,
            child: SectionKicker(number: '01', label: l10n.studyProblem),
          ),
          const SizedBox(height: AppSpacing.md),
          const Prose(
            'At Solutions Now IT, our engineering team delivered consumer-facing '
            'commercial mobile applications across two distinct domains: a high-engagement '
            'ephemeral social media sharing client and a multi-merchant loyalty rewards '
            'platform. The primary engineering bottleneck in the social media app was camera '
            'pipeline memory overhead: capturing high-resolution photos and video stories '
            'on mid-range devices caused severe main-thread UI jank, elevated memory pressure, '
            'and out-of-memory crashes during multi-image uploads.',
          ),
          const SizedBox(height: AppSpacing.md),
          const Prose(
            'Simultaneously, the loyalty rewards platform required real-time barcode '
            'scanning, secure coupon validation, and multi-tenant UI theme switching that '
            'needed to operate smoothly across fragmented merchant tablet and phone hardware.',
          ),
          const SizedBox(height: AppSpacing.xxl),
          KeyedSubtree(
            key: keys.roleKey,
            child: SectionKicker(number: '02', label: l10n.studyRole),
          ),
          const SizedBox(height: AppSpacing.md),
          const BulletList(items: [
            'Flutter Developer responsible for client app engineering, camera pipeline optimization, and multi-tenant UI design system implementation.',
            'Offloaded high-resolution image compression and EXIF metadata stripping to background Dart Isolates, restoring fluid 60 FPS UI responsiveness.',
            'Architected a modular multi-merchant design system with dynamic brand tokens, dark/light theme switching, and reusable widget libraries.',
            'Engineered camera capture workflows with hardware-accelerated preview controllers, flash toggles, and direct S3 multipart upload pipelines.',
          ]),
          const SizedBox(height: AppSpacing.xxl),
          KeyedSubtree(
            key: keys.archKey,
            child: SectionKicker(number: '03', label: l10n.studyArchitecture),
          ),
          const SizedBox(height: AppSpacing.md),
          EnglishContent(
            child: PipelineTopologyDiagram(
              project: context.read<ProjectRepository>().getProjectByIndex(2)!,
              isDesktop: isDesktop,
              isDark: isDark,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          const Prose(
            'Layered Clean Architecture enforcing clear boundary separation. '
            'The Camera Subsystem communicates with native device camera hardware '
            'via platform channels, passing raw byte buffers to dedicated background '
            'Dart Isolates for non-blocking JPEG encoding, resizing, and watermark '
            'compositing. The Loyalty Engine utilizes a token-driven Design System '
            'backed by reactive state managers, enabling instantaneous tenant theme '
            'swaps without rebuilding root widget trees.',
          ),
          const SizedBox(height: AppSpacing.xxl),
          const TechnicalChapter(
            number: '04',
            title: 'Background isolate compression & camera pipeline',
            steps: [
              TechStep(
                layer: 'Camera',
                title: 'Hardware-Accelerated Camera Controller',
                body:
                    'Wired low-level camera preview controllers with custom exposure locks, tap-to-focus indicators, and flash triggers optimized for low-light social story captures.',
              ),
              TechStep(
                layer: 'Isolates',
                title: 'Background Dart Isolate Encoding',
                body:
                    'Offloaded heavy JPEG byte manipulation, image downsampling, and EXIF orientation normalization to isolated worker threads, keeping the main UI thread completely jank-free.',
              ),
              TechStep(
                layer: 'Upload',
                title: 'Direct S3 Multipart Uploads',
                body:
                    'Engineered chunked background file uploads directly to AWS S3 buckets using presigned URLs, featuring automatic upload resumption on network drops.',
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xxl),
          const TechnicalChapter(
            number: '05',
            title: 'Multi-tenant design system & loyalty engine',
            steps: [
              TechStep(
                layer: 'Tokens',
                title: 'Dynamic Theme Token Engine',
                body:
                    'Constructed a flexible design system with runtime brand token injection (primary accents, typography scales, card radii), allowing merchant brands to skin the white-label app instantly.',
              ),
              TechStep(
                layer: 'Barcode',
                title: 'High-Speed Barcode & QR Scanner',
                body:
                    'Integrated real-time optical camera scanning with client-side checksum validation, enabling merchant cashiers to scan and redeem loyalty vouchers in under 300 milliseconds.',
              ),
              TechStep(
                layer: 'Cache',
                title: 'Offline Coupon Storage',
                body:
                    'Cached earned loyalty rewards and barcode tokens in encrypted local storage, permitting offline redemptions when store cellular coverage was degraded.',
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xxl),
          const TechnicalChapter(
            number: '06',
            title: 'Performance profiling & UI polish',
            steps: [
              TechStep(
                layer: 'Raster',
                title: '60 FPS Social Feed Virtualization',
                body:
                    'Implemented custom sliver list views with image memory caching horizons, preventing high-resolution story feeds from exceeding device RAM thresholds.',
              ),
              TechStep(
                layer: 'Animation',
                title: 'Micro-Interactions & Gesture Feedback',
                body:
                    'Designed subtle spring animations and haptic feedback triggers for voucher redemptions, story likes, and reward card flips.',
              ),
              TechStep(
                layer: 'Governance',
                title: 'Modular Component Library',
                body:
                    'Package-ified core UI components (buttons, input fields, modal sheets, toast alerts), accelerating feature delivery across both project teams.',
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xxl),
          KeyedSubtree(
            key: keys.outcomesKey,
            child: SectionKicker(number: '07', label: l10n.studyOutcomes),
          ),
          const SizedBox(height: AppSpacing.md),
          OutcomeGrid(
            isDesktop: isDesktop,
            items: [
              ('60 FPS', l10n.studySolOutcome1),
              ('-60%', l10n.studySolOutcome2),
              ('< 300ms', l10n.studySolOutcome3),
              ('50k+', l10n.studySolOutcome4),
            ],
          ),
          const SizedBox(height: AppSpacing.xxl),
          KeyedSubtree(
            key: keys.lessonsKey,
            child: SectionKicker(number: '08', label: l10n.studyLessons),
          ),
          const SizedBox(height: AppSpacing.md),
          const Prose(
            'Media-intensive mobile apps live or die by their UI responsiveness. '
            'Executing computationally expensive operations—such as image re-encoding, '
            'filtering, or serialization—on Flutter\'s main UI thread inevitably leads '
            'to dropped frames and user frustration. Leveraging background Dart Isolates '
            'and modular token-driven design systems ensures that performance and '
            'visual elegance go hand in hand.',
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
                  label: l10n.studyBackToPortfolio,
                  icon: Icons.arrow_back_rounded,
                  onPressed: () {
                    Analytics.event('case_study_cta',
                        params: {'study': 'solutions', 'cta': 'back'});
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
              '${l10n.studyRoleFlutterDev}, 2021–2022',
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
          'Loyalty Rewards & Ephemeral Social Media Apps',
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
              tag: 'project_hero_solutions',
              child: RetryingAssetImage(
                'assets/images/projects/solutions.webp',
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          l10n.studySolIntro,
          style: TextStyle(
            fontSize: AppTypography.lead,
            height: 1.55,
            color: scheme.onSurface.withValues(alpha: 0.85),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        const Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            EditorialChip(label: 'Flutter', tone: ChipTone.indigo),
            EditorialChip(label: 'Camera Engine', tone: ChipTone.amber),
            EditorialChip(label: 'AWS s3', tone: ChipTone.sky),
            EditorialChip(label: 'REST APIs', tone: ChipTone.neutral),
            EditorialChip(label: 'Design System'),
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
