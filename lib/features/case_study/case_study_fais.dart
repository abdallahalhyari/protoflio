import 'package:flutter/material.dart';

import 'package:profile/service/analytics_service.dart';
import 'package:profile/theme/tokens.dart';
import 'package:profile/features/projects/data/projects_data.dart';
import 'package:profile/shared/widget/editorial_chip.dart';
import 'package:profile/shared/widget/primary_button.dart';
import 'package:profile/features/projects/widget/pipeline_topology_diagram.dart';
import 'package:profile/shared/widget/pulsing_dot.dart';
import 'case_study_widgets.dart';
import 'related_case_studies.dart';

/// Deep-dive case study on FAIS's M-Commerce & Media-Streaming Clients.
/// Full-screen scrollable narrative matching the NatHealth case-study pattern.
class FaisCaseStudy extends StatelessWidget {
  const FaisCaseStudy({super.key});

  static const String routePath = '/work/fais';

  @override
  Widget build(BuildContext context) {
    return CaseStudyScaffold(
      slug: 'fais',
      appBarTitle: 'FAIS · CASE STUDY',
      shareTitle: 'M-Commerce & Media-Streaming Clients',
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
                    'At Future Advanced Internet Solutions (FAIS), our engineering '
                    'squads built high-concurrency commercial m-commerce platforms and '
                    'on-demand media-streaming fitness applications for regional clients. '
                    'The primary vulnerability in the m-commerce platform was payment-funnel '
                    'fragility: users on volatile cellular connections frequently experienced '
                    'drops during checkout handshakes, leading to duplicate transaction attempts, '
                    'unconfirmed authorizations, and elevated cart abandonment.',
                  ),
                  const SizedBox(height: AppSpacing.md),
                  const Prose(
                    'Simultaneously, the media-streaming client required continuous audio playback '
                    'and video workout streaming that resisted background termination by aggressive '
                    'Android OEM battery savers, while dynamically adapting buffer sizes to '
                    'prevent playback stutter across erratic cellular networks.',
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  KeyedSubtree(
                    key: keys.roleKey,
                    child: const SectionKicker(number: '02', label: 'MY ROLE'),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  const BulletList(items: [
                    'Mobile Developer across Flutter and native Android (Kotlin/Java), coordinating end-to-end frontend-to-backend API integrations and checkout reliability.',
                    'Engineered transactional checkout flows with client-side idempotency keys and state reconciliation to eliminate duplicate customer billing.',
                    'Architected the media streaming buffer manager and native Android foreground service lifecycle for uninterrupted playback.',
                    'Analyzed production telemetry, error crash logs, and network latency metrics to diagnose and resolve critical live runtime bottlenecks.',
                  ]),
                  const SizedBox(height: AppSpacing.xxl),
                  KeyedSubtree(
                    key: keys.archKey,
                    child: const SectionKicker(
                        number: '03', label: 'SYSTEM ARCHITECTURE'),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  PipelineTopologyDiagram(
                    project: kProjects[3],
                    isDesktop: isDesktop,
                    isDark: isDark,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  const Prose(
                    'Service-oriented client architecture prioritizing transactional '
                    'atomicity and defensive I/O. The checkout engine operates as an explicit '
                    'finite state machine with local SQL persistence, guaranteeing that '
                    'in-flight cart operations can resume safely after unexpected terminations. '
                    'The streaming subsystem interfaces with native Android audio/video framework '
                    'APIs via platform channels, wrapped in adaptive buffer controllers that '
                    'respond to network throughput shifts.',
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  const TechnicalChapter(
                    number: '04',
                    title: 'TRANSACTIONAL CHECKOUT FUNNEL & IDEMPOTENCY',
                    steps: [
                      TechStep(
                        layer: 'INTEGRITY',
                        title: 'Client-Generated Idempotency Keys',
                        body:
                            'Assigned unique cryptographically secure UUID transaction tokens to every payment submission. Retried requests following network timeouts carried identical tokens, allowing backend gateways to recognize replays and prevent double-charging.',
                      ),
                      TechStep(
                        layer: 'STATE MACHINE',
                        title: 'Deterministic Funnel Navigation',
                        body:
                            'Structured checkout steps (Cart → Delivery → Payment Gateway → Order Confirmation) as a strict finite state machine. Impossible state transitions and accidental back-navigation during payment processing were blocked defensively.',
                      ),
                      TechStep(
                        layer: 'PERSISTENCE',
                        title: 'Atomic Local Order Staging',
                        body:
                            'Staged cart and order payloads in local SQLite storage before initiating network requests. If the app process was interrupted mid-funnel, the checkout session recovered seamlessly without data loss.',
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  const TechnicalChapter(
                    number: '05',
                    title: 'UNINTERRUPTED MEDIA STREAMING PIPELINE',
                    steps: [
                      TechStep(
                        layer: 'LIFECYCLE',
                        title: 'Foreground Service & Audio Focus',
                        body:
                            'Implemented native Android foreground services with persistent playback notifications and system audio-focus listeners. Media streaming continued uninterrupted when users locked their screens or switched apps.',
                      ),
                      TechStep(
                        layer: 'BUFFERING',
                        title: 'Adaptive Buffer Management',
                        body:
                            'Constructed a predictive buffer controller that adjusted audio and video cache horizons dynamically based on moving-average network throughput, eliminating stutter on intermittent connections.',
                      ),
                      TechStep(
                        layer: 'TELEMETRY',
                        title: 'Quality of Service (QoS) Telemetry',
                        body:
                            'Monitored buffer underrun occurrences, playback start latencies, and stream bitrates to identify ISP peering bottlenecks and optimize CDN distribution rules.',
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  const TechnicalChapter(
                    number: '06',
                    title: 'DATA-DRIVEN TRIAGE & RESOLUTION',
                    steps: [
                      TechStep(
                        layer: 'MONITORING',
                        title: 'Automated Network Interception',
                        body:
                            'Wired network interceptors logging response latencies, payload sizes, and HTTP status codes, flagging degrading endpoints before user reports arrived.',
                      ),
                      TechStep(
                        layer: 'TRIAGE',
                        title: 'Rapid Root-Cause Diagnosis',
                        body:
                            'Correlated client crash reports with server access logs to pinpoint edge-case serialization anomalies in legacy backend microservices.',
                      ),
                      TechStep(
                        layer: 'EFFICIENCY',
                        title: 'Optimized JSON Serialization',
                        body:
                            'Refactored catalog models to use lazy JSON decoding and selective deserialization, slashing memory footprint during large search result page loads.',
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  KeyedSubtree(
                    key: keys.outcomesKey,
                    child: const SectionKicker(number: '07', label: 'OUTCOMES'),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  OutcomeGrid(
                    isDesktop: isDesktop,
                    items: const [
                      (
                        '99.8%',
                        'successful checkout transaction completion rate with zero duplicate charges'
                      ),
                      (
                        '-45%',
                        'reduction in customer support escalation tickets for failed checkout orders'
                      ),
                      (
                        '< 200ms',
                        'instantaneous cart calculation and state reconciliation latency'
                      ),
                      (
                        '10k+',
                        'daily active sessions supported across commercial commerce funnels'
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  KeyedSubtree(
                    key: keys.lessonsKey,
                    child: const SectionKicker(number: '08', label: 'LESSONS'),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  const Prose(
                    'In mobile commerce and streaming platforms, network unreliability is the '
                    'rule rather than the exception. Building resilient systems demands that '
                    'engineers treat the network interface as inherently untrusted and prone to '
                    'interruption. Implementing client-side idempotency, explicit state machine '
                    'transitions, and persistent local staging transforms flaky user experiences '
                    'into robust, trustworthy products.',
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  RelatedCaseStudies(
                    currentSlug: 'fais',
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
                                params: {'study': 'fais', 'cta': 'back'});
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
          const PulsingDot(color: AppColors.accentCyan),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              'MOBILE DEVELOPER (FLUTTER & ANDROID) · 2020 — 2021',
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
          'M-Commerce & Media-Streaming Clients',
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
          'High-throughput commercial m-commerce checkout funnels and continuous media-streaming fitness applications. Engineered with atomic checkout transactions, defensive network interceptors, and resilient audio/video streaming.',
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
            EditorialChip(label: 'Android (Kotlin/Java)', tone: ChipTone.amber),
            EditorialChip(label: 'REST APIs', tone: ChipTone.neutral),
            EditorialChip(label: 'SQL Database', tone: ChipTone.sky),
            EditorialChip(label: 'Media Streaming', tone: ChipTone.primary),
            EditorialChip(label: 'Payment Gateways', tone: ChipTone.green),
            EditorialChip(label: 'Idempotency', tone: ChipTone.indigo),
          ],
        ),
        const CaseStudyCorporateHeader(
          company: 'Future Advanced Internet Solutions',
          websiteUrl: 'http://www.fuais.com/',
          linkedinUrl: 'https://www.linkedin.com/company/futureadvnced',
          slug: 'fais',
          title: 'M-Commerce & Media-Streaming Clients',
        ),
      ],
    );
  }
}
