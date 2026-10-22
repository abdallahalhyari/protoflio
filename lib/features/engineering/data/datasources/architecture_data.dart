import 'package:flutter/material.dart';

import 'package:profile/core/theme/tokens.dart';
import 'package:profile/features/engineering/domain/entities/architecture_topic.dart';

final List<ArchitectureTopic> kArchitectureTopics = [
  const ArchitectureTopic(
    id: 'clean_arch',
    title: 'Clean Mobile Architecture',
    category: 'System design',
    summary:
        'Four layers and one rule: code depends inward only. The screens know the business rules; the business rules know nothing about Flutter, NFC or the network.',
    whyChosen:
        'At NatHealth the card reader, the Keystore and the sync queue are hardware and OS code that a Flutter test cannot run. Behind repository interfaces, the claim rules test in plain Dart and widget tests use a fake card reader.',
    cost: 'More files and mapping code for every feature.',
    usedAt: 'NatHealth',
    diagramSteps: [
      DiagramStep(
        layer: 'Presentation layer',
        title: 'Flutter UI & state controllers',
        details:
            'Widgets and BLoCs: show state, validate input, send user actions. No network or hardware calls here.',
        icon: Icons.layers_rounded,
        color: AppColors.teal,
      ),
      DiagramStep(
        layer: 'Domain layer (core)',
        title: 'Use cases & business entities',
        details:
            'Entities, business rules and the repository interfaces, in plain Dart with no Flutter imports.',
        icon: Icons.account_tree_rounded,
        color: AppColors.teal,
      ),
      DiagramStep(
        layer: 'Data layer',
        title: 'Repository implementations & DTOs',
        details:
            'Repositories choose between the local cache and the server, turn JSON into entities and failures into typed errors.',
        icon: Icons.storage_rounded,
        color: AppColors.tealLight,
      ),
      DiagramStep(
        layer: 'Data sources / hardware',
        title: 'SQLite cache & REST / NFC APIs',
        details:
            "Android's NFC adapter through a Kotlin channel, SQLite on the device and the REST API over HTTPS.",
        icon: Icons.settings_ethernet_rounded,
        color: AppColors.gold,
      ),
    ],
    technicalHighlights: [
      'Screens never talk to the card hardware: the NFC reader sits behind a repository.',
      'Business rules are tested in plain Dart, without a device or a widget harness.',
      'Server responses become immutable objects that reject missing fields when parsed, instead of crashing a screen later.',
    ],
  ),
  const ArchitectureTopic(
    id: 'offline_first',
    title: 'Offline-First Synchronization',
    category: 'Data persistence',
    summary:
        'A claim is saved on the phone first and sent when the network allows. The screen never waits for the server, and nothing is lost if the app is closed.',
    whyChosen:
        'NatHealth clinics include remote care centres with unreliable connections, and a claim cannot be lost or block a patient check-in. Saving locally and syncing in the background made the network optional at the counter.',
    cost: 'Conflicts and duplicates to resolve when the queue syncs.',
    usedAt: 'NatHealth',
    diagramSteps: [
      DiagramStep(
        layer: 'Step 1: user action',
        title: 'Optimistic UI dispatch',
        details:
            'The screen confirms at once and marks the claim as waiting to sync.',
        icon: Icons.touch_app_rounded,
        color: AppColors.teal,
      ),
      DiagramStep(
        layer: 'Step 2: local atomic commit',
        title: 'SQLite / encrypted database',
        details:
            'The claim is written to an encrypted SQLite database (SQLCipher) in one transaction, before anything is sent.',
        icon: Icons.save_rounded,
        color: AppColors.teal,
      ),
      DiagramStep(
        layer: 'Step 3: job scheduler',
        title: 'Android WorkManager pipeline',
        details:
            'A WorkManager job waits for a connection and retries with exponential backoff, even after the app is closed.',
        icon: Icons.schedule_rounded,
        color: AppColors.gold,
      ),
      DiagramStep(
        layer: 'Step 4: remote reconciliation',
        title: 'Server ACK & conflict resolution',
        details:
            "Each claim carries an idempotency key, so a retry can't file it twice. The server's reply marks it synced.",
        icon: Icons.cloud_done_rounded,
        color: AppColors.tealLight,
      ),
    ],
    technicalHighlights: [
      'Retries on a flaky connection never create a duplicate claim.',
      'Queued claims still go out after the app is closed or the phone restarts.',
      'Failures follow one retry policy with exponential backoff, instead of each screen deciding.',
    ],
  ),
  const ArchitectureTopic(
    id: 'nfc_apdu',
    title: 'ISO-7816 Smart-Card & NFC Pipeline',
    category: 'Hardware integration',
    summary:
        'The app reads health smart cards over NFC by sending ISO 7816 APDU commands from native Kotlin, then passes the result to Flutter.',
    whyChosen:
        "NatHealth replaced paper claims with contactless card checks. Flutter can't talk to the card at this level, so the card work runs in Kotlin and Flutter only sees typed results.",
    cost:
        'Phone-by-phone testing: the same commands had to work on many different NFC controllers.',
    usedAt: 'NatHealth',
    diagramSteps: [
      DiagramStep(
        layer: 'Discovery',
        title: 'NFC adapter & tag dispatch',
        details:
            'While the screen is open, the app claims any card that is tapped and opens an IsoDep connection.',
        icon: Icons.nfc_rounded,
        color: AppColors.teal,
      ),
      DiagramStep(
        layer: 'Native channel',
        title: 'Kotlin MethodChannel bridge',
        details:
            'A platform channel carries the request from Flutter to Kotlin and the response back, with typed errors.',
        icon: Icons.cable_rounded,
        color: AppColors.teal,
      ),
      DiagramStep(
        layer: 'Command chain',
        title: 'ISO-7816 APDU handshake',
        details:
            'SELECT the card application, VERIFY the PIN, then READ BINARY to get the data.',
        icon: Icons.security_rounded,
        color: AppColors.gold,
      ),
      DiagramStep(
        layer: 'Verification',
        title: 'Parse and sign the read',
        details:
            'The card data is parsed into a claim, and the read is signed with a hardware-backed key before it is sent.',
        icon: Icons.verified_user_rounded,
        color: AppColors.teal,
      ),
    ],
    technicalHighlights: [
      'An NFCCardReader interface supports several card technologies without changing the app logic.',
      'Pulling the card away mid-read is retried and reconciled instead of failing the claim.',
      'A card check takes under a second, on flagship and budget phones alike.',
    ],
  ),
  const ArchitectureTopic(
    id: 'security_jwt',
    title: 'Hardware-Backed Keystore & JWT Lifecycle',
    category: 'Application security',
    summary:
        'Sign-in tokens are issued in two steps, bound to the device and stored with keys the phone keeps in secure hardware.',
    whyChosen:
        'The apps handle health claims, so a copied token must be useless on another phone. Keeping keys in the Keystore and binding tokens to the device does that.',
    cost: 'A re-login whenever the device binding changes.',
    usedAt: 'NatHealth',
    diagramSteps: [
      DiagramStep(
        layer: 'Authentication',
        title: 'Biometric + hardware challenge',
        details:
            'The user confirms with fingerprint or face before the stored key is used.',
        icon: Icons.fingerprint_rounded,
        color: AppColors.teal,
      ),
      DiagramStep(
        layer: 'Storage',
        title: 'Android Keystore / iOS Keychain',
        details:
            "Keys are created inside the Android Keystore or iOS Keychain and never leave it; the app only asks it to sign.",
        icon: Icons.lock_outline_rounded,
        color: AppColors.gold,
      ),
      DiagramStep(
        layer: 'Exchange',
        title: 'Two-tier JWT token protocol',
        details:
            'A short-lived access token, and a refresh token bound to the device ID, issued in two steps.',
        icon: Icons.vpn_key_rounded,
        color: AppColors.teal,
      ),
      DiagramStep(
        layer: 'Rotation',
        title: 'Atomic silent refresh & revocation',
        details:
            'An expired token is refreshed in the background; a revoked one signs the user out and clears local data.',
        icon: Icons.sync_lock_rounded,
        color: AppColors.teal,
      ),
    ],
    technicalHighlights: [
      'A refresh token copied to another device is rejected: it is bound to the one it was issued to.',
      'Every card read is signed with a hardware-backed key, so a replayed read is detected.',
      'Tokens are kept only in secure storage, never in plain app preferences.',
    ],
  ),
  const ArchitectureTopic(
    id: 'state_management_bloc',
    title: 'Reactive State Management (BLoC)',
    category: 'State architecture',
    summary:
        'Screens send events to a BLoC and redraw from the states it emits. State only changes in one place, in one direction.',
    whyChosen:
        'With NFC reads, offline queues and token refreshes all changing the same screens, state needed one owner. A BLoC per feature makes every change traceable and testable without widgets.',
    cost: 'Boilerplate: events, states and handlers even for small features.',
    usedAt: 'NatHealth',
    diagramSteps: [
      DiagramStep(
        layer: 'UI / presentation',
        title: 'BlocBuilder & BlocListener',
        details:
            'Builders redraw from the current state; listeners handle one-off effects such as navigation and dialogs.',
        icon: Icons.view_quilt_rounded,
        color: AppColors.teal,
      ),
      DiagramStep(
        layer: 'Event dispatch',
        title: 'Unidirectional data flow',
        details: 'Each user action becomes a typed event sent to the BLoC.',
        icon: Icons.alt_route_rounded,
        color: AppColors.gold,
      ),
      DiagramStep(
        layer: 'Business logic component',
        title: 'Event-to-state mapping',
        details:
            'Event handlers call the domain use cases and emit new states.',
        icon: Icons.memory_rounded,
        color: AppColors.teal,
      ),
      DiagramStep(
        layer: 'State / emission',
        title: 'Immutable state classes',
        details:
            'States are immutable with value equality, so an unchanged state does not redraw the screen.',
        icon: Icons.stream_rounded,
        color: AppColors.teal,
      ),
    ],
    technicalHighlights: [
      'States change only through copyWith on immutable objects.',
      'Overlapping requests are handled by choosing per event whether to restart, queue or drop.',
      'BLoCs are unit tested with bloc_test: given these events, expect these states.',
    ],
  ),
];
