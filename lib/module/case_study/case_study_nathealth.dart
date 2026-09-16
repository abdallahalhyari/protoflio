import 'package:flutter/material.dart';

import '../../service/analytics_service.dart';
import '../../theme/surface_tone.dart';
import '../../theme/tokens.dart';
import '../home/widget/editorial_chip.dart';
import '../home/widget/page_background.dart';
import '../home/widget/primary_button.dart';
import '../home/widget/projects/nfc_architecture_diagram.dart';
import '../home/widget/pulsing_dot.dart';

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
    final scheme = Theme.of(context).colorScheme;
    final isDark = context.isDarkMode;
    final isDesktop = MediaQuery.sizeOf(context).width >= AppBreakpoints.tablet;
    final hPad = isDesktop ? 96.0 : AppSpacing.lg;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: PageBackground(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              backgroundColor:
                  isDark ? AppColors.darkSurface.withValues(alpha: 0.94) : Colors.white.withValues(alpha: 0.94),
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_rounded),
                tooltip: 'Back to portfolio',
                onPressed: () {
                  Analytics.event('case_study_back',
                      params: {'study': 'nathealth'});
                  Navigator.of(context).maybePop();
                },
              ),
              title: Text(
                'NATHEALTH · CASE STUDY',
                style: TextStyle(
                  fontSize: AppTypography.overline,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 2.4,
                  color: scheme.onSurface.withValues(alpha: 0.8),
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.symmetric(
                horizontal: hPad,
                vertical: AppSpacing.xl,
              ),
              sliver: SliverList.list(children: [
                _Masthead(isDesktop: isDesktop),
                const SizedBox(height: AppSpacing.xxl),
                const _SectionKicker(number: '01', label: 'THE PROBLEM'),
                const SizedBox(height: AppSpacing.md),
                _Prose(
                  'Jordan\'s largest health-insurance TPA processes millions of '
                  'claims across hospitals, clinics, and pharmacies. Paper '
                  'submissions were the bottleneck: fraud exposure, days-long '
                  'reimbursement lag, and clinics operating in areas with '
                  'intermittent cellular connectivity had to fall back to '
                  'phone-in verification.',
                ),
                const SizedBox(height: AppSpacing.md),
                _Prose(
                  'The mobile suite needed to (a) verify a member\'s smart-card '
                  'contactlessly in under a second, (b) survive the network '
                  'dropping mid-transaction without ever losing a claim, and '
                  '(c) resist credential extraction on rooted or compromised '
                  'Android handsets — all while meeting national health-data '
                  'regulatory audit requirements.',
                ),
                const SizedBox(height: AppSpacing.xxl),
                const _SectionKicker(number: '02', label: 'MY ROLE'),
                const SizedBox(height: AppSpacing.md),
                _BulletList(items: const [
                  'Senior Mobile Engineer leading mobile architecture across three shipped clients (Ring App, E-Health Gate, Compliance System).',
                  'Owned native Kotlin bridging to Android NFC / IsoDep transceive buffers.',
                  'Designed the two-tier JWT + hardware-GUID token protocol implemented across the suite.',
                  'Owned the offline-first WorkManager sync pipeline and its retry semantics.',
                ]),
                const SizedBox(height: AppSpacing.xxl),
                const _SectionKicker(
                    number: '03', label: 'SYSTEM ARCHITECTURE'),
                const SizedBox(height: AppSpacing.md),
                NfcArchitectureDiagram(isDesktop: isDesktop, isDark: isDark),
                const SizedBox(height: AppSpacing.md),
                _Prose(
                  'Clean Architecture with strict boundary isolation. '
                  'Presentation widgets never touch NFC or JWT primitives; '
                  'they consume a Repository interface backed by a Data layer '
                  'that fans out to the native Kotlin channel, SQLite cache, '
                  'and REST endpoints. The Domain tier is pure Dart — no '
                  'Flutter, no platform channels — so the business rules run '
                  'under `dart test` without a Flutter harness.',
                ),
                const SizedBox(height: AppSpacing.xxl),
                _TechnicalChapter(
                  number: '04',
                  title: 'ISO-7816 APDU PIPELINE',
                  steps: const [
                    _TechStep(
                      layer: 'DISCOVERY',
                      title: 'NFC adapter + tag dispatch',
                      body:
                          'Foreground dispatch filter latches onto IsoDep-compatible smart-cards within ~30ms of tap. Non-matching tags are ignored so misfires don\'t interrupt the user.',
                    ),
                    _TechStep(
                      layer: 'BRIDGE',
                      title: 'Kotlin MethodChannel',
                      body:
                          'A binary transceive channel bridges Flutter to the Android IsoDep buffer. Payloads move as raw `ByteBuffer` to avoid JSON encode/decode round-trips inside the APDU timeout envelope.',
                    ),
                    _TechStep(
                      layer: 'COMMAND CHAIN',
                      title: 'AID select → auth → binary read',
                      body:
                          'Application selection (AID), mutual authentication with the card\'s embedded certificate, then encrypted binary block reads. Each command has a strict per-step timeout; a defensive state machine unwinds cleanly if the card is displaced mid-chain.',
                    ),
                    _TechStep(
                      layer: 'VERIFY',
                      title: 'Cryptographic validation',
                      body:
                          'Card payload is parsed and validated against digital certificates from the TPA\'s CA chain. Cards that fail integrity checks are rejected before reaching the domain tier.',
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xxl),
                _TechnicalChapter(
                  number: '05',
                  title: 'HARDWARE-BOUND TOKEN LIFECYCLE',
                  steps: const [
                    _TechStep(
                      layer: 'AUTHENTICATION',
                      title: 'Biometric + hardware challenge',
                      body:
                          'BiometricPrompt gated by Android Keystore StrongBox / TEE where available; falls back to the standard TEE elsewhere. The keystore challenge is bound to a hardware GUID so cloned APKs on a different device fail immediately.',
                    ),
                    _TechStep(
                      layer: 'STORAGE',
                      title: 'AES-256 GCM in Keystore',
                      body:
                          'Refresh token encrypted with a hardware-backed key that never leaves the secure enclave. Even a fully rooted phone can\'t exfiltrate the key material — only the plaintext token after biometric approval.',
                    ),
                    _TechStep(
                      layer: 'EXCHANGE',
                      title: 'Two-tier JWT rotation',
                      body:
                          'A short-lived access token (15 min) is exchanged for API calls. Refresh happens via a hardware-GUID-bound refresh token; the server rejects any refresh whose device GUID doesn\'t match the one recorded at enrollment.',
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xxl),
                _TechnicalChapter(
                  number: '06',
                  title: 'OFFLINE-FIRST SYNC PIPELINE',
                  steps: const [
                    _TechStep(
                      layer: 'DISPATCH',
                      title: 'Optimistic UI + local ACID commit',
                      body:
                          'Every submission writes to SQLite inside a transaction, marked `PENDING_SYNC`, before the UI acknowledges. Nothing lives only in RAM.',
                    ),
                    _TechStep(
                      layer: 'SCHEDULE',
                      title: 'Android WorkManager',
                      body:
                          'A NETWORK_CONNECTED-constrained worker takes over — survives process death, doze mode, and app force-quit. Retries use exponential backoff with jitter to protect the backend during recovery storms.',
                    ),
                    _TechStep(
                      layer: 'RECONCILE',
                      title: 'Idempotent server ACK',
                      body:
                          'Each pending item carries a client-generated idempotency key so retries never double-submit. Server timestamp response flips the row to `SYNCED`; conflicts resolve via last-write-wins keyed to server clock.',
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xxl),
                const _SectionKicker(number: '07', label: 'OUTCOMES'),
                const SizedBox(height: AppSpacing.md),
                _OutcomeGrid(isDesktop: isDesktop),
                const SizedBox(height: AppSpacing.xxl),
                const _SectionKicker(number: '08', label: 'LESSONS'),
                const SizedBox(height: AppSpacing.md),
                _Prose(
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
              ]),
            ),
          ],
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
            fontSize: isDesktop ? 60 : 40,
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
      ],
    );
  }
}

class _SectionKicker extends StatelessWidget {
  const _SectionKicker({required this.number, required this.label});

  final String number;
  final String label;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(children: [
      Text(
        number,
        style: TextStyle(
          fontFamily: AppTypography.displayFont,
          fontSize: 28,
          fontWeight: FontWeight.w900,
          color: scheme.primary,
        ),
      ),
      const SizedBox(width: AppSpacing.md),
      Expanded(
        child: Text(
          label,
          style: TextStyle(
            fontSize: AppTypography.overline,
            letterSpacing: 3,
            fontWeight: FontWeight.w800,
            color: scheme.onSurface.withValues(alpha: 0.9),
          ),
        ),
      ),
      Container(
        height: 1,
        width: 80,
        color: scheme.onSurface.withValues(alpha: 0.15),
      ),
    ]);
  }
}

class _Prose extends StatelessWidget {
  const _Prose(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Text(
      text,
      style: TextStyle(
        fontSize: AppTypography.body + 1,
        height: 1.65,
        color: scheme.onSurface.withValues(alpha: 0.85),
      ),
    );
  }
}

class _BulletList extends StatelessWidget {
  const _BulletList({required this.items});

  final List<String> items;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items
          .map((t) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.smd),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: scheme.primary,
                          borderRadius: BorderRadius.circular(AppRadius.xxs),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.smd),
                    Expanded(
                      child: Text(
                        t,
                        style: TextStyle(
                          fontSize: AppTypography.body,
                          height: 1.55,
                          color: scheme.onSurface.withValues(alpha: 0.82),
                        ),
                      ),
                    ),
                  ],
                ),
              ))
          .toList(),
    );
  }
}

class _TechStep {
  const _TechStep(
      {required this.layer, required this.title, required this.body});
  final String layer;
  final String title;
  final String body;
}

class _TechnicalChapter extends StatelessWidget {
  const _TechnicalChapter({
    required this.number,
    required this.title,
    required this.steps,
  });

  final String number;
  final String title;
  final List<_TechStep> steps;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionKicker(number: number, label: title),
        const SizedBox(height: AppSpacing.md),
        ...List.generate(steps.length, (i) {
          final s = steps[i];
          return Padding(
            padding: EdgeInsets.only(
                bottom: i == steps.length - 1 ? 0 : AppSpacing.md),
            child: _TechStepCard(index: i + 1, step: s),
          );
        }),
      ],
    );
  }
}

class _TechStepCard extends StatelessWidget {
  const _TechStepCard({required this.index, required this.step});

  final int index;
  final _TechStep step;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = context.isDarkMode;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.03)
            : Colors.white.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(
          color: scheme.primary.withValues(alpha: isDark ? 0.15 : 0.18),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: scheme.primary.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Text(
              index.toString().padLeft(2, '0'),
              style: TextStyle(
                fontFamily: AppTypography.displayFont,
                fontSize: AppTypography.subtitle,
                fontWeight: FontWeight.w900,
                color: scheme.primary,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step.layer,
                  style: TextStyle(
                    fontSize: AppTypography.editorial,
                    letterSpacing: 2.4,
                    fontWeight: FontWeight.w800,
                    color: scheme.primary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  step.title,
                  style: TextStyle(
                    fontSize: AppTypography.subtitle,
                    fontWeight: FontWeight.w800,
                    color: scheme.onSurface,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  step.body,
                  style: TextStyle(
                    fontSize: AppTypography.body,
                    height: 1.55,
                    color: scheme.onSurface.withValues(alpha: 0.82),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OutcomeGrid extends StatelessWidget {
  const _OutcomeGrid({required this.isDesktop});
  final bool isDesktop;

  static const List<(String, String)> _cards = [
    ('< 1s', 'contactless card verification, flagship → budget handsets'),
    ('100%', 'reliable offline batch sync during connectivity drops'),
    ('0', 'security breaches under hardware-bound token lifecycle'),
    ('3', 'coordinated clients shipped on the shared architecture'),
  ];

  @override
  Widget build(BuildContext context) {
    final cols = isDesktop ? 4 : 2;
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: cols,
      childAspectRatio: isDesktop ? 1.3 : 1.15,
      mainAxisSpacing: AppSpacing.md,
      crossAxisSpacing: AppSpacing.md,
      children: _cards.map((c) => _OutcomeCard(headline: c.$1, body: c.$2)).toList(),
    );
  }
}

class _OutcomeCard extends StatelessWidget {
  const _OutcomeCard({required this.headline, required this.body});

  final String headline;
  final String body;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = context.isDarkMode;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.04)
            : Colors.white.withValues(alpha: 0.75),
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(
          color: scheme.primary.withValues(alpha: isDark ? 0.18 : 0.22),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            headline,
            style: TextStyle(
              fontFamily: AppTypography.displayFont,
              fontSize: 44,
              fontWeight: FontWeight.w900,
              color: scheme.primary,
              height: 1.0,
            ),
          ),
          Text(
            body,
            style: TextStyle(
              fontSize: AppTypography.small,
              height: 1.4,
              color: scheme.onSurface.withValues(alpha: 0.75),
            ),
          ),
        ],
      ),
    );
  }
}
