import 'package:flutter/material.dart';
import 'package:profile/core/services/analytics_service.dart';
import 'package:profile/core/theme/tokens.dart';
import 'package:profile/features/case_study/presentation/pages/related_case_studies.dart';
import 'package:profile/features/case_study/presentation/widgets/case_study_widgets.dart';
import 'package:profile/features/projects/presentation/widgets/nfc_architecture_diagram.dart';
import 'package:profile/l10n/app_localizations.dart';
import 'package:profile/shared/widgets/editorial_chip.dart';
import 'package:profile/shared/widgets/primary_button.dart';
import 'package:profile/shared/widgets/pulsing_dot.dart';
import 'package:profile/shared/widgets/retrying_asset_image.dart';

/// Deep-dive case study on the NatHealth TPA ecosystem — ISO-7816 smart-card
/// claims, background sync, and offline-first security.
/// Full-screen scrollable narrative with sticky reading progress, jump dock,
/// and responsive margins.
class NatHealthCaseStudy extends StatelessWidget {
  const NatHealthCaseStudy({super.key});

  static const String routePath = '/work/nathealth';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return CaseStudyScaffold(
      slug: 'nathealth',
      appBarTitle: 'NATHEALTH · ${l10n.studyCaseStudy}',
      shareTitle: 'NatHealth Mobile Suite',
      sliversBuilder: (context, keys, isDesktop) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return [
          _Masthead(isDesktop: isDesktop),
          const SizedBox(height: AppSpacing.xl),
          CaseStudyAtAGlance(
            slug: 'nathealth',
            challenge: l10n.studyNatChallenge,
            built: l10n.studyNatBuilt,
            result: l10n.studyNatResult,
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
            'NatHealth processes medical claims for over two million beneficiaries '
            'across thousands of clinics, pharmacies, and hospitals. Before the mobile '
            'suite, claim verification relied on manual paperwork, physical vouchers, '
            'or desktop portals with intermittent internet connectivity in remote '
            'care centers. Verification delays stalled patient check-in, invited fraud, '
            'and forced providers to store sensitive data in insecure local files.',
          ),
          const SizedBox(height: AppSpacing.md),
          const Prose(
            'The core engineering challenge was twofold: communicate reliably with '
            'legacy ISO-7816 NFC health smart cards on a wide spectrum of Android and iOS '
            'smartphones, and build a zero-trust offline engine that encrypts claim '
            'transactions on-device until network connectivity resumes.',
          ),
          const SizedBox(height: AppSpacing.xxl),
          KeyedSubtree(
            key: keys.roleKey,
            child: SectionKicker(number: '02', label: l10n.studyRole),
          ),
          const SizedBox(height: AppSpacing.md),
          const BulletList(items: [
            'Lead Mobile Architect for NatHealth\'s cross-platform ecosystem.',
            'Wrote native Kotlin / Swift platform channels for ISO-7816 APDU command sequences.',
            'Designed local encrypted SQLite caching and WorkManager background upload queues.',
            'Partnered with clinical security officers to satisfy HIPAA-grade data-at-rest requirements.',
          ]),
          const SizedBox(height: AppSpacing.xxl),
          KeyedSubtree(
            key: keys.archKey,
            child: SectionKicker(number: '03', label: l10n.studyArchitecture),
          ),
          const SizedBox(height: AppSpacing.md),
          EnglishContent(
            child: NfcArchitectureDiagram(
              isDesktop: isDesktop,
              isDark: isDark,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          const Prose(
            'Decoupled Clean Architecture with explicit directional dependencies. '
            'The Presentation layer is built with Flutter and BLoC. When a provider scans a card, '
            'a native Android (Kotlin) / iOS (Swift) platform channel handles raw APDU streams, '
            'parses binary payloads into domain models, and signs the claim hash with '
            'hardware-backed Keystore / Keychain keys. Claims queue in SQLite and sync via WorkManager.',
          ),
          const SizedBox(height: AppSpacing.xxl),
          const TechnicalChapter(
            number: '04',
            title: 'ISO-7816 APDU protocol engineering',
            steps: [
              TechStep(
                layer: 'Hardware',
                title: 'Low-Level Transceive Pipeline',
                body:
                    'Built thread-safe platform channels to execute raw ISO-7816 APDU command chains (SELECT AID, READ BINARY, VERIFY PIN) across 40+ smartphone NFC controller variants.',
              ),
              TechStep(
                layer: 'Security',
                title: 'Hardware-Backed Session Signing',
                body:
                    'Stored private keys inside Android Keystore / iOS Secure Enclave. Every card read generates a cryptographically signed JWT payload, preventing replay attacks.',
              ),
              TechStep(
                layer: 'Resilience',
                title: 'Automated Recovery for Card Swipes',
                body:
                    'Engineered automatic retry envelopes and state reconciliation for premature card removals during 3-step APDU handshakes.',
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xxl),
          const TechnicalChapter(
            number: '05',
            title: 'Offline-first queue & background sync',
            steps: [
              TechStep(
                layer: 'Storage',
                title: 'Encrypted SQLite Cache',
                body:
                    'Designed an offline-first repository using SQLCipher. Clinical claims store locally when offline, encrypted with AES-256 keys derived from session tokens.',
              ),
              TechStep(
                layer: 'Sync',
                title: 'WorkManager / BGTaskScheduler',
                body:
                    'Wired system WorkManager tasks with exponential backoff and battery-aware constraints, flushing queued claims automatically upon network reconnection.',
              ),
              TechStep(
                layer: 'Conflicts',
                title: 'Deterministic Conflict Resolution',
                body:
                    'Implemented server-side vector clocks and client-side transaction idempotency keys, eliminating duplicate claim filings during flaky connectivity.',
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xxl),
          const TechnicalChapter(
            number: '06',
            title: 'UI performance & governance',
            steps: [
              TechStep(
                layer: 'Raster',
                title: '120 FPS Claims Feed Rendering',
                body:
                    'Isolated complex claim cards with RepaintBoundary, memoized expensive text painters, and eliminated unnecessary rebuilds across long scroll lists.',
              ),
              TechStep(
                layer: 'Testing',
                title: 'End-to-End APDU Mock Harness',
                body:
                    'Constructed a mock NFC channel provider for Flutter widget tests, allowing 100% automated test coverage of card verification flows without physical hardware.',
              ),
              TechStep(
                layer: 'Deps',
                title: 'Modular Multi-Package Decoupling',
                body:
                    'Extracted core security, network, and design system components into isolated internal packages with strict dependency isolation.',
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
              ('2M+', l10n.studyNatOutcome1),
              ('100%', l10n.studyNatOutcome2),
              ('< 1.2s', l10n.studyNatOutcome3),
              ('0', l10n.studyNatOutcome4),
            ],
          ),
          const SizedBox(height: AppSpacing.xxl),
          KeyedSubtree(
            key: keys.lessonsKey,
            child: SectionKicker(number: '08', label: l10n.studyLessons),
          ),
          const SizedBox(height: AppSpacing.md),
          const Prose(
            'Building mission-critical healthcare software requires designing for the '
            'worst-case physical environment. Internet access will drop, users will swipe '
            'NFC cards too quickly, and low-end devices will constrain memory. By treating '
            'offline storage as the primary source of truth and isolating hardware IO '
            'behind strict platform channels, we delivered a bulletproof application '
            'that doctors and patients rely on daily.',
          ),
          const SizedBox(height: AppSpacing.xxl),
          RelatedCaseStudies(
            currentSlug: 'nathealth',
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
                        params: {'study': 'nathealth', 'cta': 'back'});
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
          const PulsingDot(color: AppColors.teal),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              '${l10n.introSeniorEngineer} · 2024 — ${l10n.studyPresent}',
              // Two lines on phones rather than clipping the end date
              // ("2024 — PRES…").
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: AppTypography.label,
                fontWeight: FontWeight.w800,
                color: scheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ),
        ]),
        const SizedBox(height: AppSpacing.md),
        Text(
          'NatHealth Mobile Suite',
          style: TextStyle(
            fontFamily: AppTypography.displayFont,
            fontSize: isDesktop ? AppTypography.hero : AppTypography.display,
            fontWeight: FontWeight.w900,
            height: 1.0,
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
              tag: 'project_hero_nathealth',
              child: RetryingAssetImage(
                'assets/images/projects/nathealth.webp',
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          l10n.studyNatIntro,
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
            EditorialChip(label: 'Kotlin', tone: ChipTone.amber),
            EditorialChip(label: 'ISO-7816 APDU NFC'),
            EditorialChip(label: 'WorkManager', tone: ChipTone.green),
            EditorialChip(label: 'JWT + Keystore', tone: ChipTone.sky),
            EditorialChip(label: 'Clean Architecture', tone: ChipTone.neutral),
            EditorialChip(label: 'SQLite', tone: ChipTone.neutral),
          ],
        ),
        const CaseStudyCorporateHeader(
          company: 'NatHealth',
          websiteUrl: 'https://www.nathealth.net',
          linkedinUrl: 'https://www.linkedin.com/company/nathealth',
          slug: 'nathealth',
          title: 'NatHealth Mobile Suite',
        ),
      ],
    );
  }
}
