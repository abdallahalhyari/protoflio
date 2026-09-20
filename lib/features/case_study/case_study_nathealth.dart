import 'package:flutter/material.dart';

import 'package:profile/service/analytics_service.dart';
import 'package:profile/theme/tokens.dart';
import 'package:profile/shared/widget/editorial_chip.dart';
import 'package:profile/shared/widget/primary_button.dart';
import 'package:profile/features/projects/widget/nfc_architecture_diagram.dart';
import 'package:profile/shared/widget/pulsing_dot.dart';
import 'case_study_widgets.dart';
import 'related_case_studies.dart';

/// Deep-dive case study on the NatHealth NFC platform. Full-screen
/// scrollable narrative: problem → role → architecture → three
/// technical chapters → outcomes → lessons → CTA back to portfolio.
///
/// Routed at hash `#work/nathealth` by the URL sync service (see
/// `HomeScreen`).
class NatHealthCaseStudy extends StatelessWidget {
  const NatHealthCaseStudy({super.key});

  static const String routePath = '/work/nathealth';

  @override
  Widget build(BuildContext context) {
    return CaseStudyScaffold(
      slug: 'nathealth',
      appBarTitle: 'NATHEALTH · CASE STUDY',
      shareTitle: 'NatHealth Mobile Suite',
      sliversBuilder: (context, keys, isDesktop) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return [
          _Masthead(isDesktop: isDesktop),
          const SizedBox(height: AppSpacing.xxl),
          KeyedSubtree(
            key: keys.problemKey,
            child: const SectionKicker(number: '01', label: 'THE PROBLEM'),
          ),
          const SizedBox(height: AppSpacing.md),
          const Prose(
            'Jordan\'s largest health-insurance TPA processes millions of '
            'claims across hospitals, clinics, and pharmacies. Paper '
            'submissions were the bottleneck: fraud exposure, days-long '
            'reimbursement lag, and clinics operating in areas with '
            'intermittent cellular connectivity had to fall back to '
            'phone-in verification.',
          ),
          const SizedBox(height: AppSpacing.md),
          const Prose(
            'The mobile suite needed to (a) verify a member\'s smart-card '
            'contactlessly in under a second, (b) survive the network '
            'dropping mid-transaction without ever losing a claim, and '
            '(c) resist credential extraction on rooted or compromised '
            'Android handsets — all while meeting national health-data '
            'regulatory audit requirements.',
          ),
          const SizedBox(height: AppSpacing.xxl),
          KeyedSubtree(
            key: keys.roleKey,
            child: const SectionKicker(number: '02', label: 'MY ROLE'),
          ),
          const SizedBox(height: AppSpacing.md),
          const BulletList(items: [
            'Senior Mobile Engineer leading mobile architecture across three shipped clients (Ring App, E-Health Gate, Compliance System).',
            'Owned native Kotlin bridging to Android NFC / IsoDep transceive buffers.',
            'Designed the two-tier JWT + hardware-GUID token protocol implemented across the suite.',
            'Owned the offline-first WorkManager sync pipeline and its retry semantics.',
          ]),
          const SizedBox(height: AppSpacing.xxl),
          KeyedSubtree(
            key: keys.archKey,
            child:
                const SectionKicker(number: '03', label: 'SYSTEM ARCHITECTURE'),
          ),
          const SizedBox(height: AppSpacing.md),
          NfcArchitectureDiagram(isDesktop: isDesktop, isDark: isDark),
          const SizedBox(height: AppSpacing.md),
          const Prose(
            'Clean Architecture with strict boundary isolation. '
            'Presentation widgets never touch NFC or JWT primitives; '
            'they consume a Repository interface backed by a Data layer '
            'that fans out to the native Kotlin channel, SQLite cache, '
            'and REST endpoints. The Domain tier is pure Dart — no '
            'Flutter, no platform channels — so the business rules run '
            'under `dart test` without a Flutter harness.',
          ),
          const SizedBox(height: AppSpacing.xxl),
          const TechnicalChapter(
            number: '04',
            title: 'ISO-7816 APDU PIPELINE',
            steps: [
              TechStep(
                layer: 'DISCOVERY',
                title: 'NFC adapter + tag dispatch',
                body:
                    'Foreground dispatch filter latches onto IsoDep-compatible smart-cards within ~30ms of tap. Non-matching tags are ignored so misfires don\'t interrupt the user.',
              ),
              TechStep(
                layer: 'BRIDGE',
                title: 'Kotlin MethodChannel',
                body:
                    'A binary transceive channel bridges Flutter to the Android IsoDep buffer. Payloads move as raw `ByteBuffer` to avoid JSON encode/decode round-trips inside the APDU timeout envelope.',
              ),
              TechStep(
                layer: 'COMMAND CHAIN',
                title: 'AID select → auth → binary read',
                body:
                    'Application selection (AID), mutual authentication with the card\'s embedded certificate, then encrypted binary block reads. Each command has a strict per-step timeout; a defensive state machine unwinds cleanly if the card is displaced mid-chain.',
              ),
              TechStep(
                layer: 'VERIFY',
                title: 'Cryptographic validation',
                body:
                    'Card payload is parsed and validated against digital certificates from the TPA\'s CA chain. Cards that fail integrity checks are rejected before reaching the domain tier.',
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xxl),
          const TechnicalChapter(
            number: '05',
            title: 'HARDWARE-BOUND TOKEN LIFECYCLE',
            steps: [
              TechStep(
                layer: 'AUTHENTICATION',
                title: 'Biometric + hardware challenge',
                body:
                    'BiometricPrompt gated by Android Keystore StrongBox / TEE where available; falls back to the standard TEE elsewhere. The keystore challenge is bound to a hardware GUID so cloned APKs on a different device fail immediately.',
              ),
              TechStep(
                layer: 'STORAGE',
                title: 'AES-256 GCM in Keystore',
                body:
                    'Refresh token encrypted with a hardware-backed key that never leaves the secure enclave. Even a fully rooted phone can\'t exfiltrate the key material — only the plaintext token after biometric approval.',
              ),
              TechStep(
                layer: 'EXCHANGE',
                title: 'Two-tier JWT rotation',
                body:
                    'A short-lived access token (15 min) is exchanged for API calls. Refresh happens via a hardware-GUID-bound refresh token; the server rejects any refresh whose device GUID doesn\'t match the one recorded at enrollment.',
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xxl),
          const TechnicalChapter(
            number: '06',
            title: 'OFFLINE-FIRST SYNC PIPELINE',
            steps: [
              TechStep(
                layer: 'DISPATCH',
                title: 'Optimistic UI + local ACID commit',
                body:
                    'Every submission writes to SQLite inside a transaction, marked `PENDING_SYNC`, before the UI acknowledges. Nothing lives only in RAM.',
              ),
              TechStep(
                layer: 'SCHEDULE',
                title: 'Android WorkManager',
                body:
                    'A NETWORK_CONNECTED-constrained worker takes over — survives process death, doze mode, and app force-quit. Retries use exponential backoff with jitter to protect the backend during recovery storms.',
              ),
              TechStep(
                layer: 'RECONCILE',
                title: 'Idempotent server ACK',
                body:
                    'Each pending item carries a client-generated idempotency key so retries never double-submit. Server timestamp response flips the row to `SYNCED`; conflicts resolve via last-write-wins keyed to server clock.',
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xxl),
          KeyedSubtree(
            key: keys.outcomesKey,
            child: const SectionKicker(number: '07', label: 'OUTCOMES'),
          ),
          OutcomeGrid(
            isDesktop: isDesktop,
            items: const [
              (
                '< 1s',
                'contactless card verification, flagship → budget handsets'
              ),
              ('100%', 'reliable offline batch sync during connectivity drops'),
              ('0', 'security breaches under hardware-bound token lifecycle'),
              ('3', 'coordinated clients shipped on the shared architecture'),
            ],
          ),
          const SizedBox(height: AppSpacing.xxl),
          KeyedSubtree(
            key: keys.lessonsKey,
            child: const SectionKicker(number: '08', label: 'LESSONS'),
          ),
          const SizedBox(height: AppSpacing.md),
          const Prose(
            'NFC APDU timing envelopes are unforgiving and vary by handset. '
            'Different antenna coil geometries across OEMs meant our '
            'end-to-end read budget had to account for a ~2× variance in '
            'transceive latency between flagship and budget devices. '
            'The fix wasn\'t tighter code — it was a defensive state '
            'machine that treated every command as potentially '
            'interruptable, plus per-step timeouts that could fail '
            'gracefully and prompt the user to re-tap without losing '
            'the outer transaction state.',
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
                  label: 'Back to portfolio',
                  icon: Icons.arrow_back_rounded,
                  size: PrimaryButtonSize.md,
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
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          const PulsingDot(color: AppColors.accentGreen),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              'SENIOR MOBILE ENGINEER · 2024 — PRESENT',
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
          'NatHealth Mobile Suite',
          style: TextStyle(
            fontFamily: AppTypography.displayFont,
            fontSize: isDesktop ? AppTypography.heroSm : AppTypography.display,
            fontWeight: FontWeight.w900,
            height: 1.0,
            color: scheme.onSurface,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          'Mission-critical NFC smart-card healthcare platform serving Jordan\'s largest health-insurance TPA. Ring App, E-Health Gate, and Compliance System — shipped as three coordinated clients on a shared architecture.',
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
            EditorialChip(label: 'Kotlin', tone: ChipTone.amber),
            EditorialChip(label: 'ISO-7816 APDU NFC', tone: ChipTone.primary),
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
