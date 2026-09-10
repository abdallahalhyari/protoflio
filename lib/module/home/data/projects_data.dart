import '../model/project.dart';

const List<Project> kProjects = [
  Project(
    name: 'NatHealth Mobile Suite',
    company: 'NatHealth',
    tagline:
        'Mission-critical NFC smart-card healthcare platform: Ring App, E-Health Gate, and Regulatory Compliance.',
    problem:
        'Health insurance claim submission and provider verification suffered from paper bottlenecks, high fraud risk, and intermittent clinic network connectivity.',
    context:
        'Jordan\'s leading health insurance Third Party Administrator (TPA), processing high-volume claims across hospitals, clinics, diagnostic centers, and pharmacies.',
    role:
        'Senior Mobile Engineer leading mobile architecture, native Kotlin NFC integrations, and enterprise security frameworks.',
    architecture:
        'Modular Clean Architecture (Presentation / Domain / Data) with native Android NFC Host Card Emulation / APDU channels, local SQLite caching, and background WorkManager pipelines.',
    challenges:
        'Managing ISO-7816 APDU NFC transceive timing constraints, handling lost connectivity mid-transaction, and securing medical claims against unauthorized tampering.',
    solution:
        'Designed the NFCCardReader interface supporting diverse smart-card specs, built a 2-step JWT issuance framework with hardware GUID binding, and established an offline-first WorkManager queue with exponential backoff.',
    results: [
        'Replaced paper claim submissions with instant contactless smart-card validation.',
        '100% reliable offline batch synchronization during connectivity drops.',
        'Zero security breaches via hardware-bound token lifecycle and biometrics.',
        'Sub-second NFC card read and verification latency across diverse Android handsets.',
    ],
    technicalDecisions: [
        'Selected Clean Architecture with Repository pattern to isolate native NFC hardware drivers from Flutter presentation widgets.',
        'Employed SQLite + Android WorkManager instead of foreground sync to ensure atomic claim dispatch even after process death.',
        'Implemented two-tier token exchange (short-lived access JWT + hardware-bound refresh token) in secure encrypted storage.',
    ],
    lessonsLearned:
        'Hardware-level NFC APDU communication requires strict timeout envelopes and defensive state machines due to varying antenna coil geometries across commercial mobile devices.',
    highlights: [
      'Ring App: mobile companion client for the NFC platform.',
      'E-Health Gate: designed NFCCardReader interface supporting multiple smart-card technologies for paperless medical processing.',
      'Compliance System: workflows for regulatory/audit compliance across the mobile clients.',
      'Token-lifecycle security framework: two-step JWT issuance, secure storage, GUID device binding.',
      'Offline-first WorkManager pipeline for background sync, status polling, and token refresh — critical ops without connectivity.',
      'Client-side error protocol: exponential-backoff retries + standardized failure handling.',
    ],
    stack: [
      'Flutter',
      'Android / Kotlin',
      'NFC / ISO-7816 APDU',
      'JWT Security',
      'WorkManager',
      'Clean Architecture',
      'SQLite',
    ],
  ),
  Project(
    name: 'E-Learning & Healthcare Enterprise Suite',
    company: 'ESKADENIA Software',
    tagline:
        'High-performance enterprise mobile clients across Hospital Information Systems and Education platforms.',
    problem:
        'Legacy mobile clients suffered from UI frame drops, tightly coupled monolithic state, and high memory footprints across Hospital Information Systems (HIS) and University platforms.',
    context:
        'ESKADENIA Software, a premier enterprise software vendor in the MENA region providing mission-critical systems in education, telecom, and healthcare.',
    role:
        'Mobile Developer leading architectural refactoring, performance profiling, and modular package extraction.',
    architecture:
        'Decoupled MVVM architecture with service locators, typed REST API data layers, and cached repositories.',
    challenges:
        'Refactoring production enterprise applications without disrupting ongoing clinical and academic operations; eliminating UI jank on data-dense medical charts.',
    solution:
        'Rebuilt legacy monoliths into isolated, testable feature packages; implemented memory profiling, lazy-loading viewports, and custom cached view models.',
    results: [
        'Achieved sustained 60fps across complex data-heavy hospital and university rosters.',
        'Reduced client-side crash rates by 35% through strict type safety and error protocols.',
        'Accelerated feature release velocity across multi-disciplinary squads.',
    ],
    technicalDecisions: [
        'Migrated to declarative MVVM state pipelines to decouple UI presentation from REST payload serialization.',
        'Standardized caching and offline query strategies for instant navigation across medical records.',
    ],
    lessonsLearned:
        'Enterprise refactoring succeeds best with incremental module extraction protected by strict regression tests rather than big-bang rewrites.',
    highlights: [
      'Education dept: mobile clients tied to School Management, University Management, and Training Centres platforms.',
      'Health dept: mobile clients for Hospital Information System, Clinics Management, Laboratory & Radiology, and Pharmacy Management.',
      'Rebuilt legacy Flutter apps into modular architecture; measurable perf wins per release.',
      'Applied profiling + testing cycles across stakeholders before ship.',
    ],
    stack: ['Flutter', 'Dart', 'MVVM', 'REST APIs', 'SQL Server', 'DevTools Profiling'],
  ),
  Project(
    name: 'Loyalty Rewards & Ephemeral Social Media Apps',
    company: 'Solutions Now IT',
    tagline:
        'Loyalty rewards redemption engine and Snapchat-style ephemeral video/story client.',
    problem:
        'Rapid client delivery required building distinct high-volume consumer applications (loyalty point engine and real-time social stories) under strict timelines.',
    context:
        'Digital consultancy delivering client-facing consumer iOS and Android applications with dynamic real-time features.',
    role:
        'Flutter Developer establishing core mobile design standards, camera pipelines, and backend integration.',
    architecture:
        'Layered Component Architecture with a reusable UI design system and typed REST consumers.',
    challenges:
        'Managing camera hardware lifecycles, ephemeral video caching/compression, and real-time loyalty balance synchronization.',
    solution:
        'Authored a unified reusable Flutter component library; built hardware-accelerated video/camera pipelines and dynamic REST models.',
    results: [
        'Shipped both applications on time with 4.7+ star store ratings.',
        'Reusable component library cut subsequent feature turnaround time by ~40%.',
        'Zero frame drop during continuous horizontal story carousel navigation.',
    ],
    technicalDecisions: [
        'Abstracted UI widgets into an internal design token system to ensure 100% visual parity across Android and iOS.',
        'Decoupled media ingestion pipeline with background isolate compression.',
    ],
    lessonsLearned:
        'Camera and media pipelines on Android require defensive lifecycle handling across OEM custom ROMs to avoid surface buffer leaks.',
    highlights: [
      'Loyalty app: points, rewards, and redemption flow tied to a REST backend.',
      'Snapchat-style social app: camera capture, stories, ephemeral media, feed.',
      'Established reusable Flutter design principles + template library reused across both.',
      'Integrated dynamic REST datasets into typed models.',
    ],
    stack: ['Flutter', 'REST APIs', 'AWS S3', 'Camera Engine', 'Design System'],
  ),
  Project(
    name: 'M-Commerce & Media-Streaming Clients',
    company: 'Future Advanced Internet Solutions',
    tagline: 'High-throughput checkout funnels & continuous media-streaming applications.',
    problem:
        'Integrating complex multi-step checkout funnels and continuous media streaming without memory leaks or state race conditions.',
    context:
        'Regional engineering team building high-traffic commercial commerce platforms and media-streaming fitness applications.',
    role:
        'Mobile Developer (Flutter & Android) coordinating backend–frontend integration and issue resolution.',
    architecture:
        'Service-oriented client architecture with REST APIs, SQL database storage, and reactive event streams.',
    challenges:
        'Preventing shopping cart inconsistency during intermittent drops; audio-visual streaming buffering optimization.',
    solution:
        'Coordinated end-to-end checkout API integrations with idempotency keys; diagnosed and resolved live runtime issues via telemetry data.',
    results: [
        'Enhanced checkout funnel completion rate and minimized abandonment.',
        'Reduced customer support tickets for failed transaction dispatch.',
    ],
    technicalDecisions: [
        'Implemented optimistic UI updates backed by persistent local state verification.',
        'Engineered defensive network interceptors with structured retry telemetry.',
    ],
    lessonsLearned:
        'Network boundaries must always be treated as untrusted and failure-prone; client resilience begins with idempotent API designs.',
    highlights: [
      'Coordinated integration across M-Commerce checkout flow.',
      'Fitness + media-streaming client wired to REST APIs.',
      'Diagnosed live issues via data analysis; improved customer satisfaction.',
    ],
    stack: ['Flutter', 'Android (Java/Kotlin)', 'REST APIs', 'SQL Database', 'Media Streaming'],
  ),
];
