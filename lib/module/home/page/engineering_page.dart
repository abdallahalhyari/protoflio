import 'package:flutter/material.dart';
import '../../../theme/tokens.dart';
import '../../../service/sound_service.dart';

import '../widget/engineering/diagram_list.dart';
import '../widget/screen_shell.dart';
import '../widget/swipe_affordance.dart';

class ArchitectureTopic {
  final String id;
  final String title;
  final String category;
  final String summary;
  final String whyChosen;
  final List<DiagramStep> diagramSteps;
  final List<String> technicalHighlights;

  const ArchitectureTopic({
    required this.id,
    required this.title,
    required this.category,
    required this.summary,
    required this.whyChosen,
    required this.diagramSteps,
    required this.technicalHighlights,
  });
}

class DiagramStep {
  final String layer;
  final String title;
  final String details;
  final IconData icon;
  final Color color;

  const DiagramStep({
    required this.layer,
    required this.title,
    required this.details,
    required this.icon,
    required this.color,
  });
}

final List<ArchitectureTopic> kArchitectureTopics = [
  ArchitectureTopic(
    id: 'clean_arch',
    title: 'Clean Mobile Architecture',
    category: 'SYSTEM DESIGN',
    summary:
        'Strict 3-tier boundary separation decoupling presentation widgets from business use-cases and hardware data sources.',
    whyChosen:
        'Prevents UI framework lock-in, enables independent automated unit testing of core business rules without Flutter mocks, and isolates platform-specific native plugins (like NFC and Keystore).',
    diagramSteps: [
      DiagramStep(
        layer: 'PRESENTATION LAYER',
        title: 'Flutter UI & State Controllers',
        details: 'Declarative widgets, BLoC / ValueNotifiers, input validation & 60fps view rendering.',
        icon: Icons.layers_outlined,
        color: Color(0xFF38BDF8),
      ),
      DiagramStep(
        layer: 'DOMAIN LAYER (CORE)',
        title: 'Use Cases & Business Entities',
        details: 'Pure Dart entities, business rules, repository contracts. Zero external framework dependencies.',
        icon: Icons.account_tree_outlined,
        color: const Color(0xFF38BDF8),
      ),
      DiagramStep(
        layer: 'DATA LAYER',
        title: 'Repository Implementations & DTOs',
        details: 'Coordination between local cache and remote sources, serialization, and error translation.',
        icon: Icons.storage_outlined,
        color: Color(0xFF34D399),
      ),
      DiagramStep(
        layer: 'DATA SOURCES / HARDWARE',
        title: 'SQLite Cache & REST / NFC APIs',
        details: 'Native Android NFC Adapter, SQLite persistent storage, and secure HTTPS REST endpoints.',
        icon: Icons.settings_ethernet_outlined,
        color: Color(0xFFFBBF24),
      ),
    ],
    technicalHighlights: [
      'Repository Pattern decouples native NFC hardware channels from presentation views.',
      'Pure Domain entities ensure 100% test coverage without UI harness dependencies.',
      'Immutable Data Transfer Objects (DTOs) with defensive parsing prevent runtime crashes from unexpected null payloads.',
    ],
  ),
  ArchitectureTopic(
    id: 'offline_first',
    title: 'Offline-First Synchronization',
    category: 'DATA PERSISTENCE',
    summary:
        'Guaranteed data delivery through persistent local queueing, atomic SQLite mutations, and Android WorkManager background sync.',
    whyChosen:
        'Healthcare practitioners and clinic staff operate in areas with fluctuating cellular connectivity. Claims and patient validations must never be lost or blocked by network drops.',
    diagramSteps: [
      DiagramStep(
        layer: 'STEP 1: USER ACTION',
        title: 'Optimistic UI Dispatch',
        details: 'Immediate user feedback with transactional state marked as PENDING_SYNC.',
        icon: Icons.touch_app_outlined,
        color: Color(0xFF38BDF8),
      ),
      DiagramStep(
        layer: 'STEP 2: LOCAL ATOMIC COMMIT',
        title: 'SQLite / Encrypted Database',
        details: 'Record stored locally within an ACID database transaction. Never held in volatile memory.',
        icon: Icons.save_outlined,
        color: Color(0xFF10B981),
      ),
      DiagramStep(
        layer: 'STEP 3: JOB SCHEDULER',
        title: 'Android WorkManager Pipeline',
        details: 'OS-managed background worker triggered with NETWORK_CONNECTED constraints & exponential backoff.',
        icon: Icons.schedule_outlined,
        color: Color(0xFFF59E0B),
      ),
      DiagramStep(
        layer: 'STEP 4: REMOTE RECONCILIATION',
        title: 'Server ACK & Conflict Resolution',
        details: 'Idempotency keys prevent duplicate transactions; server timestamp updates local state to SYNCED.',
        icon: Icons.cloud_done_outlined,
        color: Color(0xFFA78BFA),
      ),
    ],
    technicalHighlights: [
      'Idempotent dispatch tokens prevent duplicate claims on flaky network reconnects.',
      'Survives complete app process termination via Android WorkManager native OS execution.',
      'Client-side error protocols implement exponential backoff with jitter to protect backend infrastructure.',
    ],
  ),
  ArchitectureTopic(
    id: 'nfc_apdu',
    title: 'ISO-7816 Smart-Card & NFC Pipeline',
    category: 'HARDWARE INTEGRATION',
    summary:
        'Direct low-level contactless smart-card interaction via ISO/IEC 7816-4 APDU command chains over Android NFC.',
    whyChosen:
        'Enables paperless, high-security smart-card verification for national health insurance schemes with millisecond validation speed and zero physical contact.',
    diagramSteps: [
      DiagramStep(
        layer: 'DISCOVERY',
        title: 'NFC Adapter & Tag Dispatch',
        details: 'Foreground dispatch filter captures IsoDep / Mifare smart-cards within milliseconds.',
        icon: Icons.nfc_outlined,
        color: Color(0xFF38BDF8),
      ),
      DiagramStep(
        layer: 'NATIVE CHANNEL',
        title: 'Kotlin MethodChannel Bridge',
        details: 'High-speed binary transport bridging Flutter runtime to native Android IsoDep transceive buffer.',
        icon: Icons.cable_outlined,
        color: const Color(0xFF38BDF8),
      ),
      DiagramStep(
        layer: 'COMMAND CHAIN',
        title: 'ISO-7816 APDU Handshake',
        details: 'Select Application (AID), Mutual Authentication, and encrypted binary block read.',
        icon: Icons.security_outlined,
        color: Color(0xFFFBBF24),
      ),
      DiagramStep(
        layer: 'VERIFICATION',
        title: 'Cryptographic Claim Verification',
        details: 'Card payload parsed and cryptographically validated against digital certificate authorities.',
        icon: Icons.verified_user_outlined,
        color: Color(0xFF10B981),
      ),
    ],
    technicalHighlights: [
      'Abstract NFCCardReader interface allows swapping physical card vendors without modifying app logic.',
      'Defensive state machine handles card displacement before APDU command sequence completion.',
      'Optimized transceive buffers achieve complete contactless card verification in under 750ms.',
    ],
  ),
  ArchitectureTopic(
    id: 'security_jwt',
    title: 'Hardware-Backed Keystore & JWT Lifecycle',
    category: 'APPLICATION SECURITY',
    summary:
        'Defense-in-depth security framework combining hardware-bound cryptographic keys, biometric auth, and dual-token JWT rotation.',
    whyChosen:
        'Enterprise healthcare and financial data requires zero-trust security. Protecting credentials against extraction on compromised or rooted devices is mandatory.',
    diagramSteps: [
      DiagramStep(
        layer: 'AUTHENTICATION',
        title: 'Biometric + Hardware Challenge',
        details: 'Fingerprint / Face Unlock verified via Android BiometricPrompt with StrongBox / TEE backing.',
        icon: Icons.fingerprint_outlined,
        color: Color(0xFF38BDF8),
      ),
      DiagramStep(
        layer: 'STORAGE',
        title: 'Android Keystore / iOS Keychain',
        details: 'Hardware-backed AES-256 GCM key encryption. Private keys never leave secure hardware enclave.',
        icon: Icons.lock_outlined,
        color: Color(0xFFF59E0B),
      ),
      DiagramStep(
        layer: 'EXCHANGE',
        title: 'Two-Tier JWT Token Protocol',
        details: 'Short-lived access token (15 min) + hardware GUID-bound refresh token stored securely.',
        icon: Icons.vpn_key_outlined,
        color: const Color(0xFF38BDF8),
      ),
      DiagramStep(
        layer: 'ROTATION',
        title: 'Atomic Silent Refresh & Revocation',
        details: 'Automatic token refresh on HTTP 401 with immediate local cache purge upon revocation.',
        icon: Icons.sync_lock_outlined,
        color: Color(0xFF10B981),
      ),
    ],
    technicalHighlights: [
      'Hardware GUID binding prevents token replay even if refresh token is intercepted on untrusted devices.',
      'Strict in-memory cleanup: sensitive credentials explicitly zeroed out after cryptographic operations.',
      'Proactive SSL Pinning protects network transport against rogue proxy or man-in-the-middle attacks.',
    ],
  ),
  ArchitectureTopic(
    id: 'state_management_bloc',
    title: 'Reactive State Management (BLoC)',
    category: 'STATE ARCHITECTURE',
    summary:
        'Predictable, highly-testable reactive state container using the BLoC pattern with unidirectional data flow and strict event-to-state mapping.',
    whyChosen:
        'Isolates UI from complex business logic. Enables time-travel debugging, flawless dependency injection, and guarantees that the presentation layer strictly reflects the current state without side effects.',
    diagramSteps: [
      DiagramStep(
        layer: 'UI / PRESENTATION',
        title: 'BlocBuilder & BlocListener',
        details: 'Widget tree reacts instantly to state emissions while handling side-effects (navigation, dialogs) through listeners.',
        icon: Icons.view_quilt_outlined,
        color: Color(0xFF38BDF8),
      ),
      DiagramStep(
        layer: 'EVENT DISPATCH',
        title: 'Unidirectional Data Flow',
        details: 'User actions are transformed into strictly typed Events pushed into the BLoC sink.',
        icon: Icons.alt_route_outlined,
        color: Color(0xFFF59E0B),
      ),
      DiagramStep(
        layer: 'BUSINESS LOGIC COMPONENT',
        title: 'Event-to-State Mapping',
        details: 'Asynchronous generators process events, interact with Domain use-cases, and yield immutable State objects.',
        icon: Icons.memory_outlined,
        color: const Color(0xFF38BDF8),
      ),
      DiagramStep(
        layer: 'STATE / EMISSION',
        title: 'Immutable State Classes',
        details: 'Data classes with strictly defined properties and value equality (Equatable) preventing unnecessary widget rebuilds.',
        icon: Icons.stream_outlined,
        color: Color(0xFF10B981),
      ),
    ],
    technicalHighlights: [
      'Extensive use of Freezed and Equatable to guarantee memory-efficient value equality and copyWith mutations.',
      'Complex asynchronous race conditions solved via restartable, sequential, and droppable event transformers (RxDart).',
      'Flawless automated unit testing achieved using bloc_test to verify precise event-state trajectories.',
    ],
  ),
];

class EngineeringPage extends StatefulWidget {
  final bool isContinuousMobile;

  const EngineeringPage({
    super.key,
    this.isContinuousMobile = false,
  });

  @override
  State<EngineeringPage> createState() => _EngineeringPageState();
}

class _EngineeringPageState extends State<EngineeringPage>
    with AutomaticKeepAliveClientMixin {
  int _selectedTopicIndex = 0;

  @override
  bool get wantKeepAlive => true;

  void _selectTopic(int index) {
    if (_selectedTopicIndex == index) return;
    SoundService.instance.playClick();
    setState(() => _selectedTopicIndex = index);
  }

  void _nextTopic() {
    SoundService.instance.playClick();
    setState(() => _selectedTopicIndex = (_selectedTopicIndex + 1) % kArchitectureTopics.length);
  }

  void _prevTopic() {
    SoundService.instance.playClick();
    setState(() => _selectedTopicIndex = (_selectedTopicIndex - 1 + kArchitectureTopics.length) % kArchitectureTopics.length);
  }

  Widget _buildSwipeAffordance(ColorScheme scheme) {
    return SwipeAffordance(
      margin: const EdgeInsets.only(top: 6),
      label:
          'SWIPE OR TAP TO SWITCH ARCHITECTURAL BLUEPRINTS (${_selectedTopicIndex + 1}/${kArchitectureTopics.length})',
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // AutomaticKeepAliveClientMixin requirement
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final size = MediaQuery.sizeOf(context);
    final isDesktop = size.width >= AppBreakpoints.tablet;
    final activeTopic = kArchitectureTopics[_selectedTopicIndex];

    return AppScreenShell(
      maxWidth: 1280,
      verticalPadding: widget.isContinuousMobile ? AppSpacing.md : AppSpacing.md,
      reserveBottomNav: !widget.isContinuousMobile,
      reserveMobileTop: !widget.isContinuousMobile,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(scheme, isDesktop),
            const SizedBox(height: AppSpacing.sm),
            _buildTopicTabs(scheme, isDesktop),
            if (!isDesktop) _buildSwipeAffordance(scheme),
            const SizedBox(height: AppSpacing.md),
            if (widget.isContinuousMobile)
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onHorizontalDragEnd: (details) {
                  if (details.primaryVelocity != null) {
                    if (details.primaryVelocity! < -200) {
                      _nextTopic();
                    } else if (details.primaryVelocity! > 200) {
                      _prevTopic();
                    }
                  }
                },
                child: AnimatedSwitcher(
                  duration: AppMotion.switcher,
                  switchInCurve: Curves.easeOutCubic,
                  switchOutCurve: Curves.easeInCubic,
                  transitionBuilder: (child, animation) => FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0.04, 0),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                  ),
                  child: KeyedSubtree(
                    key: ValueKey('arch_topic_${activeTopic.id}'),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildDiagramView(activeTopic, scheme, isDesktop),
                        const SizedBox(height: AppSpacing.md),
                        _buildDetailsView(activeTopic, scheme, isDesktop),
                      ],
                    ),
                  ),
                ),
              )
            else
              Expanded(
                child: isDesktop
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            flex: 6,
                            child: _buildDiagramView(activeTopic, scheme, isDesktop),
                          ),
                          const SizedBox(width: AppSpacing.lg),
                          Expanded(
                            flex: 5,
                            child: _buildDetailsView(activeTopic, scheme, isDesktop),
                          ),
                        ],
                      )
                    : ListView(
                        primary: false,
                        padding: EdgeInsets.zero,
                        physics: const ClampingScrollPhysics(),
                        children: [
                          _buildDiagramView(activeTopic, scheme, isDesktop),
                          const SizedBox(height: AppSpacing.md),
                          _buildDetailsView(activeTopic, scheme, isDesktop),
                          const SizedBox(height: AppSpacing.lg),
                        ],
                      ),
              ),
          ],
      ),
    );
  }

  Widget _buildHeader(ColorScheme scheme, bool isDesktop) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                  height: 2, color: scheme.primary.withValues(alpha: 0.9)),
              const SizedBox(height: 6),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'FEATURE 03 · SYSTEMS ARCHITECTURE',
                          style: TextStyle(
                            color: scheme.primary,
                            fontSize: isDesktop ? 11 : 10,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 3,
                          ),
                        ),
                        const SizedBox(height: 4),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'ENGINEERING EXPERTISE',
                            style: TextStyle(
                              fontFamily: AppTypography.displayFont,
                              color: scheme.onSurface,
                              fontSize: isDesktop ? 42 : 26,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 4,
                              height: 1,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Production-tested architectures behind the mobile suites',
                          style: TextStyle(
                            color: scheme.onSurface.withValues(alpha: 0.75),
                            fontSize: isDesktop ? 12.5 : 11.5,
                            fontStyle: FontStyle.italic,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isDesktop)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: scheme.primary.withValues(alpha: 0.10),
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                        border: Border.all(
                            color:
                                scheme.primary.withValues(alpha: 0.4)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.hub_outlined,
                              color: scheme.primary, size: 13),
                          const SizedBox(width: 6),
                          Text(
                            '4 ARCHITECTURES',
                            style: TextStyle(
                              color: scheme.primary,
                              fontSize: 10.5,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 6),
              Container(
                  height: 0.75,
                  color: scheme.primary.withValues(alpha: 0.5)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTopicTabs(ColorScheme scheme, bool isDesktop) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (int i = 0; i < kArchitectureTopics.length; i++) ...[
            _buildTabItem(
              topic: kArchitectureTopics[i],
              isSelected: _selectedTopicIndex == i,
              onTap: () => _selectTopic(i),
              scheme: scheme,
            ),
            if (i < kArchitectureTopics.length - 1) const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }

  Widget _buildTabItem({
    required ArchitectureTopic topic,
    required bool isSelected,
    required VoidCallback onTap,
    required ColorScheme scheme,
  }) {
    final isDark = scheme.brightness == Brightness.dark;
    return Semantics(
      button: true,
      selected: isSelected,
      label: 'Select ${topic.title}',
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        child: AnimatedContainer(
          duration: AppMotion.sm,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? scheme.primary.withValues(alpha: isDark ? 0.18 : 0.12)
                : (isDark ? scheme.surface.withValues(alpha: 0.4) : Colors.white.withValues(alpha: 0.85)),
            borderRadius: BorderRadius.circular(AppRadius.sm),
            border: Border.all(
              color: isSelected
                  ? scheme.primary
                  : (isDark ? scheme.onSurface.withValues(alpha: 0.15) : AppColors.slate300),
              width: isSelected ? 1.5 : 1.0,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: scheme.primary.withValues(alpha: isDark ? 0.25 : 0.15),
                      blurRadius: 16,
                    ),
                  ]
                : (isDark
                    ? []
                    : [
                        BoxShadow(
                          color: AppColors.slate900.withValues(alpha: 0.04),
                          blurRadius: 6,
                          offset: const Offset(0, 1),
                        ),
                      ]),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? scheme.primary : (isDark ? Colors.white38 : AppColors.slate400),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                topic.title.toUpperCase(),
                style: TextStyle(
                  color: isSelected ? (isDark ? Colors.white : scheme.primary) : (isDark ? Colors.white70 : AppColors.slate600),
                  fontSize: 11.5,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDiagramView(ArchitectureTopic topic, ColorScheme scheme, bool isDesktop) {
    final isDark = scheme.brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? scheme.surface.withValues(alpha: 0.5) : Colors.white.withValues(alpha: 0.90),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: isDark ? Colors.white12 : AppColors.slate200),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: AppColors.slate900.withValues(alpha: 0.05),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'ARCHITECTURE FLOWCHART',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Courier',
                    color: scheme.primary,
                    fontSize: isDesktop ? 11 : 9.5,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isDark ? Colors.white.withValues(alpha: 0.08) : AppColors.slate100,
                  borderRadius: BorderRadius.circular(AppRadius.xs),
                  border: Border.all(color: isDark ? Colors.transparent : AppColors.slate200),
                ),
                child: Text(
                  '${topic.diagramSteps.length} TIERS',
                  style: TextStyle(
                    fontFamily: 'Courier',
                    color: isDark ? Colors.white70 : AppColors.slate600,
                    fontSize: 9.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          DiagramList(topic: topic, scheme: scheme, isDesktop: isDesktop),
        ],
      ),
    );
  }

  Widget _buildDetailsView(ArchitectureTopic topic, ColorScheme scheme, bool isDesktop) {
    final isDark = scheme.brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? scheme.surface.withValues(alpha: 0.5) : Colors.white.withValues(alpha: 0.90),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: isDark ? Colors.white12 : AppColors.slate200),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: AppColors.slate900.withValues(alpha: 0.05),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: ListView(
        primary: false,
        padding: EdgeInsets.zero,
        shrinkWrap: !isDesktop,
        physics: isDesktop
            ? const ClampingScrollPhysics()
            : const NeverScrollableScrollPhysics(),
        children: [
          // Section Title
          Text(
            topic.title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: isDark ? Colors.white : AppColors.slate900,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            topic.summary,
            style: TextStyle(
              fontSize: 13,
              color: isDark ? Colors.white.withValues(alpha: 0.85) : AppColors.slate700,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 16),

          // Architectural Rationale Container
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withValues(alpha: isDark ? 0.12 : 0.08),
              borderRadius: BorderRadius.circular(AppRadius.sm),
              border: Border.all(color: Theme.of(context).colorScheme.primary.withValues(alpha: isDark ? 0.35 : 0.5)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.psychology_outlined, color: Theme.of(context).colorScheme.primary, size: 16),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'ARCHITECTURAL RATIONALE (WHY THIS CHOICE)',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  topic.whyChosen,
                  style: TextStyle(
                    color: isDark ? Colors.white : AppColors.slate800,
                    fontSize: 12,
                    height: 1.45,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Technical Highlights
          Text(
            'KEY IMPLEMENTATION SAFEGUARDS',
            style: TextStyle(
              fontFamily: 'Courier',
              color: scheme.primary,
              fontSize: 10.5,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          for (final item in topic.technicalHighlights) ...[
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '❖ ',
                    style: TextStyle(color: scheme.primary, fontSize: 11),
                  ),
                  Expanded(
                    child: Text(
                      item,
                      style: TextStyle(
                        color: isDark ? Colors.white.withValues(alpha: 0.8) : AppColors.slate700,
                        fontSize: 11.5,
                        height: 1.35,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
