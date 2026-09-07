import '../model/project.dart';

const List<Project> kProjects = [
  Project(
    name: 'NatHealth Mobile Suite',
    company: 'NatHealth',
    tagline:
        'Secure NFC-based health-insurance mobile stack: Ring, E-Health Gate, Compliance and more.',
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
      'Kotlin',
      'NFC',
      'JWT',
      'WorkManager',
      'Clean Arch',
    ],
  ),
  Project(
    name: 'E-Learning & Healthcare Flutter Clients',
    company: 'ESKADENIA Software',
    tagline:
        'Mobile clients for ESKADENIA\'s Education and Health & Wellbeing product lines.',
    highlights: [
      'Education dept: mobile clients tied to School Management, University Management, and Training Centres platforms.',
      'Health dept: mobile clients for Hospital Information System, Clinics Management, Laboratory & Radiology, and Pharmacy Management.',
      'Rebuilt legacy Flutter apps into modular architecture; measurable perf wins per release.',
      'Applied profiling + testing cycles across stakeholders before ship.',
    ],
    stack: ['Flutter', 'Dart', 'MVVM', 'REST', 'SQL Server'],
  ),
  Project(
    name: 'Loyalty + Social Media Apps',
    company: 'Solutions Now IT',
    tagline:
        'Loyalty rewards app and a Snapchat-style social media app for commissioned clients.',
    highlights: [
      'Loyalty app: points, rewards, and redemption flow tied to a REST backend.',
      'Snapchat-style social app: camera capture, stories, ephemeral media, feed.',
      'Established reusable Flutter design principles + template library reused across both.',
      'Integrated dynamic REST datasets into typed models.',
    ],
    stack: ['Flutter', 'REST', 'AWS', 'SQL Server'],
  ),
  Project(
    name: 'M-Commerce + Fitness Apps',
    company: 'Future Advanced Internet Solutions',
    tagline: 'Backend-frontend integration for e-commerce & media-streaming.',
    highlights: [
      'Coordinated integration across M-Commerce checkout flow.',
      'Fitness + media-streaming client wired to REST APIs.',
      'Diagnosed live issues via data analysis; improved customer satisfaction.',
    ],
    stack: ['Flutter', 'Android', 'REST', 'SQL Server'],
  ),
];
