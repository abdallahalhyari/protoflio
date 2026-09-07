import '../model/project.dart';

const List<Project> kProjects = [
  Project(
    name: 'NatHealth NFC Auth',
    company: 'NatHealth',
    tagline: 'Secure smart-card authentication for healthcare mobile clients.',
    highlights: [
      'Designed NFCCardReader interface supporting multiple card technologies.',
      'Two-step JWT issuance + secure storage + GUID device binding.',
      'Offline-first WorkManager pipeline for background sync & token refresh.',
      'Exponential-backoff retries + standardized failure protocol.',
    ],
    stack: ['Flutter', 'Kotlin', 'NFC', 'JWT', 'WorkManager', 'Clean Arch'],
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
    name: 'Solutions Now Design Library',
    company: 'Solutions Now IT',
    tagline: 'Reusable Flutter templates + patterns library for commissioned apps.',
    highlights: [
      'Established design principles + reusable widget templates.',
      'Documented patterns for reuse across iterative delivery.',
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
