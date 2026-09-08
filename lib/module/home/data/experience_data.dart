import '../model/experience.dart';

const List<Experience> kExperience = [
  Experience(
    role: 'Senior Mobile Engineer',
    company: 'NatHealth',
    period: '10/2024 – Present',
    highlights: [
      'Led NFC integration for secure smart-card authentication; designed the NFCCardReader interface supporting multiple card technologies.',
      'Built token-lifecycle security framework: two-step JWT issuance, secure storage, GUID-based device binding.',
      'Established client-side error-handling protocols with exponential-backoff retries and standardized failure guidelines.',
      'Implemented offline-first submission policy via WorkManager for background sync, status polling, and token refresh.',
      'Integrated RabbitMQ-based async messaging across the mobile stack for event-driven flows.',
      'Applied AI/LLM tooling to accelerate delivery and support compliance workflows.',
    ],
  ),
  Experience(
    role: 'Mobile Developer',
    company: 'ESKADENIA Software',
    period: '11/2022 – 10/2024',
    highlights: [
      'Rebuilt and restructured Flutter apps for performance and maintainability; introduced modular architecture.',
      'Applied profiling and optimization; led thorough testing before release.',
      'Collaborated with stakeholders, delivered features on schedule.',
    ],
  ),
  Experience(
    role: 'Flutter Developer',
    company: 'Solutions Now IT',
    period: '11/2021 – 11/2022',
    highlights: [
      'Established reusable Flutter design principles and template libraries.',
      'Documented design patterns for reuse across iterations.',
      'Integrated RESTful web services; designed data structures for dynamic datasets.',
    ],
  ),
  Experience(
    role: 'Mobile Developer (Flutter & Android)',
    company: 'Future Advanced Internet Solutions',
    period: '07/2021 – 12/2021',
    highlights: [
      'Coordinated backend–frontend integration for an M-Commerce app and a fitness & media-streaming app.',
      'Diagnosed and resolved issues through data analysis.',
    ],
  ),
];

const List<Education> kEducation = [
  Education(
    degree: 'M.Sc. in Open Informatics',
    institution: 'Mendel University in Brno',
    period: 'From 2027',
    note: 'Faculty of Business and Economics — Brno, Czech Republic',
  ),
  Education(
    degree: 'B.Sc. in Software Engineering',
    institution: 'Al-Hussein Bin Talal University',
    period: '2018 – 2021',
    note: 'Jordan',
  ),
];

const List<String> kCertifications = [
  'Flutter Development — Udemy',
  'Android App Development — Udemy',
  'Concurrent Programming with Android: Threads, Workers & Kotlin Coroutines — LinkedIn Learning',
  'Android App Development — One Million Arab Coders',
  'Multinational Communication in the Workplace — LinkedIn Learning',
];
