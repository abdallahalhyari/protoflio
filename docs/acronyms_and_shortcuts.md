# Portfolio Acronyms, Abbreviations & Shortcuts Glossary

This reference document compiles all the abbreviations, acronyms, technical initialisms, and keyboard shortcuts used across the **Abdallah Alhyari** portfolio website, along with what each stands for and where it is used.

---

## 1. Professional & Industry Qualifications

| Abbreviation | Stands For | Context & Description |
|---|---|---|
| **CV** | **Curriculum Vitae** | Latin for *"course of life"*. The complete professional portfolio dossier and career track record available for download (`DOWNLOAD CV · PDF`). |
| **ATS** | **Applicant Tracking System** | Automated software used by recruiters and hiring managers to parse resumes. The CV is marked `ATS-VERIFIED` to ensure 100% readability. |
| **PDF** | **Portable Document Format** | The standard document format for the downloadable executive resume dossier. |
| **B.Sc.** | **Bachelor of Science** | Undergraduate degree in Software Engineering from Al-Hussein Bin Talal University (2018–2021). |
| **M.Sc.** | **Master of Science** | Graduate master's degree in Open Informatics at Mendel University in Brno, Czech Republic (from 2027). |
| **CTA** | **Call To Action** | Interactive buttons or prompts encouraging user engagement (e.g., `VIEW MY WORK`, `DOWNLOAD RESUME`, `CONTACT ME`). |
| **TPA** | **Third Party Administrator** | An organization that processes insurance claims and provider networks (referenced in NatHealth's enterprise healthcare role). |
| **SLA** | **Service Level Agreement** | Contractual performance or availability guarantee (referenced as `100% Offline SLA` in the NatHealth Mobile Suite). |
| **HIPAA** | **Health Insurance Portability and Accountability Act** | United States national standard for safeguarding sensitive patient medical data and records. |
| **MENA** | **Middle East & North Africa** | Geographic business region where enterprise solutions for ESKADENIA and FAIS were deployed. |
| **CZ** | **Czech Republic** | Country code; referenced in work eligibility and academic transition (`CZ WORK ELIGIBLE · STUDENT`). |
| **UTC** | **Coordinated Universal Time** | Primary world time standard; used in the live Amman timezone clock telemetry (`UTC+3`). |
| **AM / PM** | **Ante Meridiem / Post Meridiem** | Latin for *before midday* and *after midday*, displayed on the real-time contact telemetry bar. |
| **MMXXVI** | **Roman Numerals for 2026** | Featured on the magazine cover issue strip (`ISSUE 01 · PORTFOLIO EDITION · MMXXVI`). |

---

## 2. Mobile Systems, Hardware & Embedded Protocols

| Abbreviation | Stands For | Context & Description |
|---|---|---|
| **NFC** | **Near Field Communication** | High-frequency short-range wireless communication standard used in the NatHealth smart medical card verification platform. |
| **APDU** | **Application Protocol Data Unit** | The fundamental communication unit between an NFC card reader and smart chip defined under ISO/IEC 7816-4. |
| **ISO / IEC** | **International Organization for Standardization / International Electrotechnical Commission** | International standard bodies responsible for smart-card specifications (e.g., `ISO-7816 APDU`). |
| **IsoDep** | **ISO-DEP (ISO 14443-4 Proximity Protocol)** | Android NFC protocol layer providing high-speed binary transceive buffers for ISO-7816 smart cards. |
| **AID** | **Application Identifier** | A unique address defined under ISO-7816 used during NFC APDU handshakes to select a specific card applet. |
| **HCE** | **Host Card Emulation** | Android technology allowing software to emulate physical smart cards over NFC channels. |
| **NDK** | **Native Development Kit** | Android toolset allowing Kotlin/Java apps to execute native C/C++ code and low-level hardware channel drivers. |
| **APK** | **Android Package Kit** | The package file format used by the Android OS for application distribution and installation. |
| **SDK** | **Software Development Kit** | Reusable collection of software libraries, APIs, and tools for building platform-specific features. |
| **OS** | **Operating System** | System software managing computer hardware and software resources (Android, iOS, macOS, Linux, Windows). |
| **iOS** | **iPhone Operating System** | Apple's mobile operating system; referenced across cross-platform Flutter native channels and Keychain integrations. |
| **ROM** | **Read-Only Memory** | Device firmware; referenced regarding Android OEM custom skins (Samsung OneUI, Xiaomi MIUI) in media pipeline handling. |
| **OEM** | **Original Equipment Manufacturer** | Hardware device makers (Samsung, Google, Xiaomi, Apple). |
| **FPS** | **Frames Per Second** | Measure of UI animation smoothness. The portfolio and enterprise clients are tuned for `60 FPS` / `120 FPS` frame budgets. |
| **GPU** | **Graphics Processing Unit** | Hardware dedicated to accelerated 2D/3D graphics and shader calculations (Skia/Impeller rasterization). |
| **CPU** | **Central Processing Unit** | Main processor executing Dart/Kotlin logic, concurrency pipelines, and data serialization. |
| **OOM** | **Out Of Memory** | Critical OS exception thrown when an application exceeds available memory heaps. |
| **QR** | **Quick Response** | Two-dimensional matrix barcode used for instant device pairing, ticketing, and identity verification. |
| **1D / 2D** | **One-Dimensional / Two-Dimensional** | Linear barcode vs. matrix code data representations handled in camera scanning pipelines. |
| **ML Kit** | **Machine Learning Kit** | Google's on-device SDK for high-speed offline barcode, QR, and text detection. |

---

## 3. Architecture, State & Software Engineering

| Abbreviation | Stands For | Context & Description |
|---|---|---|
| **BLoC** | **Business Logic Component** | Flutter architectural design pattern separating presentation widgets from reactive business logic using streams and event-to-state mapping. |
| **MVVM** | **Model-View-ViewModel** | Architectural pattern that decouples user interface logic from backend data schemas via observable view models. |
| **UDF** | **Unidirectional Data Flow** | Architectural principle where data flows down through states and events flow up through controllers, preventing race conditions. |
| **DTO / DTOs** | **Data Transfer Object(s)** | Immutable serializable classes designed strictly to transport data between network APIs and internal domain layers. |
| **ACID** | **Atomicity, Consistency, Isolation, Durability** | Set of standard database properties that guarantee transactions are processed reliably in local SQLite stores. |
| **SQL** | **Structured Query Language** | Standard domain-specific language for managing relational database schemas and records. |
| **MySQL** | **My Structured Query Language** | Open-source relational database management system referenced under technical backend competencies. |
| **SQLite** | **Structured Query Language Lite** | Embedded, serverless local database engine used for atomic offline data persistence and claims queues. |
| **DS** | **Data Structures** | Methods of organizing and storing data in memory (Trees, Graphs, Queues, Hash Tables). |
| **LRU** | **Least Recently Used** | Cache eviction policy that discards the least recently accessed items first to preserve memory constraints. |
| **CI / CD** | **Continuous Integration / Continuous Deployment** | Automated engineering pipeline for code linting, automated testing, artifact bundling, and release delivery. |
| **DEV** | **Development** | Short for software development or developer environment. |
| **RxDart** | **Reactive Extensions for Dart** | Reactive functional programming library adding debounce, throttle, and switchMap transformers to Dart streams. |
| **ERP** | **Enterprise Resource Planning** | Comprehensive business process management software coordinating inventory, finance, and human resources. |
| **HIS** | **Hospital Information System** | Enterprise medical software managing patient records, laboratory results, pharmacy orders, and doctor rosters. |
| **LMS** | **Learning Management System** | Educational platform for managing university course curriculums, student grading, and scheduling. |
| **IT** | **Information Technology** | Application of computers to store, retrieve, transmit, and manipulate data. |
| **M-Commerce** | **Mobile Commerce** | Commercial transactions, shopping checkouts, and payments conducted wirelessly on mobile devices. |
| **E-Health** | **Electronic Health** | Digital healthcare technology and smart-card patient identity systems. |
| **PWA** | **Progressive Web App** | Web application designed to provide native-app-like offline caching, installability, and responsiveness. |

---

## 4. Security, Cryptography & Networking Protocols

| Abbreviation | Stands For | Context & Description |
|---|---|---|
| **JWT** | **JSON Web Token** | Open standard (RFC 7519) for securely transmitting compact, digitally signed JSON claims between client and server. |
| **GUID / UUID** | **Globally Unique Identifier / Universally Unique Identifier** | 128-bit hardware/device identifier used to bind refresh tokens to specific physical handsets to prevent token replay. |
| **AES** | **Advanced Encryption Standard** | Symmetric block cipher used to encrypt sensitive offline databases and refresh tokens. |
| **GCM** | **Galois/Counter Mode** | Authenticated encryption mode for AES (AES-256-GCM) that provides both data confidentiality and cryptographic authenticity. |
| **TEE** | **Trusted Execution Environment** | Secure, tamper-resistant area of the main mobile processor (ARM TrustZone) where cryptographic keys are generated and stored. |
| **StrongBox** | **Android StrongBox Keymaster** | Hardware Security Module (HSM) with dedicated CPU, secure memory, and true random number generation on Android hardware. |
| **CA** | **Certificate Authority** | Trusted cryptographic entity that issues digital certificates verifying identity in PKI systems. |
| **SSL** | **Secure Sockets Layer** | Cryptographic protocol for establishing authenticated and encrypted network links (enforced via SSL Certificate Pinning). |
| **HTTP / HTTPS** | **Hypertext Transfer Protocol / Hypertext Transfer Protocol Secure** | Foundation protocol for data communication over the web and secure mobile REST endpoints. |
| **REST** | **Representational State Transfer** | Stateless architectural style for networked web API services utilizing standard HTTP verbs (GET, POST, PUT, DELETE). |
| **API / APIs** | **Application Programming Interface(s)** | Defined set of rules and specifications allowing the mobile client to communicate with backend services. |
| **SSE** | **Server-Sent Events** | Unidirectional server-push technology where clients receive real-time automated updates over a persistent HTTP connection. |
| **ACK** | **Acknowledgment** | Protocol signal confirming that a data packet or batch claim was received and committed by the server. |
| **URL / URLs** | **Uniform Resource Locator(s)** | Web address referencing specific internet resources or deep links. |
| **AWS** | **Amazon Web Services** | Cloud computing platform providing S3 cloud storage, CloudFront CDN, and compute infrastructure. |
| **S3** | **Simple Storage Service** | Scalable object storage service provided by AWS for hosting application media, avatars, and assets. |
| **CDN** | **Content Delivery Network** | Globally distributed network of proxy edge servers delivering assets with minimal regional latency. |

---

## 5. Web, UX, Formatting & Accessibility

| Abbreviation | Stands For | Context & Description |
|---|---|---|
| **UI / UX** | **User Interface / User Experience** | The visual elements (buttons, typography, spacing) and holistic user interaction flow of the application. |
| **WCAG** | **Web Content Accessibility Guidelines** | International accessibility guidelines (WCAG 2.1 / 2.2 AA standard) ensuring high color contrast (≥ 4.5:1) and screen-reader support. |
| **RTL / LTR** | **Right-To-Left / Left-To-Right** | Directional text rendering layout. Arabic renders RTL; English and Czech render LTR. |
| **WASM** | **WebAssembly** | Binary code format executed by modern web browsers enabling near-native Flutter performance (`main.dart.wasm`). |
| **HTML** | **Hypertext Markup Language** | Standard markup language for web browser document structure. |
| **CSS** | **Cascading Style Sheets** | Style sheet language used for visual presentation and layout formatting. |
| **JSON** | **JavaScript Object Notation** | Lightweight human-readable data interchange format used for network payloads and local asset data. |
| **JSON-LD** | **JavaScript Object Notation for Linked Data** | Structured data format embedded in `web/index.html` for search engines (SEO) and schema graph discovery. |
| **OG** | **Open Graph** | Protocol used by social platforms (LinkedIn, Slack, WhatsApp) to generate rich social media preview cards. |
| **KB / MB** | **Kilobyte / Megabyte** | Units of digital data storage (e.g., `PDF · 22 KB`, `Tenada.ttf < 32 KB`). |

---

## 6. Website Keyboard Shortcuts (Interactive Hotkeys)

In addition to linguistic acronyms, the website features a complete suite of global keyboard shortcuts accessible on desktop viewports:

| Shortcut Key | Action | Context / Scope |
|---|---|---|
| **`1`** | Jump to **Home / Cover** (`01 / Intro`) | Global Navigation |
| **`2`** | Jump to **Experience** (`02 / Experience`) | Global Navigation |
| **`3`** | Jump to **Selected Work** (`03 / Selected Work`) | Global Navigation |
| **`4`** | Jump to **Skills & Stack** (`04 / Skills`) | Global Navigation |
| **`5`** | Jump to **Engineering** (`05 / Engineering`) | Global Navigation |
| **`6`** | Jump to **Perspectives (Hats)** (`06 / Hats`) | Global Navigation |
| **`7`** | Jump to **Contact** (`07 / Contact`) | Global Navigation |
| **`W`** | Jump to **Selected Work** (`03 / Selected Work`) | Mnemonic Section Hotkey |
| **`E`** | Jump to **Engineering** (`05 / Engineering`) | Mnemonic Section Hotkey |
| **`X`** | Jump to **Experience** (`02 / Experience`) | Mnemonic Section Hotkey |
| **`S`** | Jump to **Skills & Stack** (`04 / Skills`) *(when not typing in search)* | Mnemonic Section Hotkey |
| **`H`** | Jump to **Perspectives (Hats)** (`06 / Hats`) | Mnemonic Section Hotkey |
| **`C`** | Jump to **Contact** (`07 / Contact`) | Mnemonic Section Hotkey |
| **`T`** | **Toggle Theme** (Light / Dark mode) | Global System Command |
| **`M`** | **Mute / Unmute** Audio sound effects | Global System Command |
| **`?`** | Open **Keyboard Shortcuts Modal** | Global Help |
| **`↓` / `PageDown` / `Space`** | Advance to Next Section | Sequential Scroll Navigation |
| **`↑` / `PageUp`** | Return to Previous Section | Sequential Scroll Navigation |
| **`Home`** | Jump to First Page (`01 / Intro`) | Quick Navigation |
| **`End`** | Jump to Last Page (`07 / Contact`) | Quick Navigation |
| **`S`** | **Spread / Shuffle** hat cards | Perspectives Deck Console |
| **`R`** | **Reset / Align** hat cards | Perspectives Deck Console |
| **`←` / `A`** | Previous Perspective Card | Perspectives Deck Console |
| **`→` / `D`** | Next Perspective Card | Perspectives Deck Console |
| **`Tab` + `Enter`** | **Flip Card** (Front / Back mastery) | Bento Skill Tiles & Hat Deck |
| **`Esc`** | Close Open Modal / Dialog | Case Study & Inquiry Composer Modals |
