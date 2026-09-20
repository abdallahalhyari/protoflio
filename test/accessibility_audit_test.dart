import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:profile/l10n/app_localizations.dart';
import 'package:profile/features/case_study/case_study_widgets.dart';
import 'package:profile/features/engineering/data/architecture_data.dart';
import 'package:profile/features/experience/data/experience_data.dart';
import 'package:profile/features/projects/data/projects_data.dart';
import 'package:profile/features/skills/data/skills_data.dart';
import 'package:profile/features/shell/home_controller.dart';
import 'package:profile/features/projects/page/projects_page.dart';
import 'package:profile/features/contact/widget/channel_tile.dart';
import 'package:profile/features/contact/widget/consulting_track.dart';
import 'package:profile/features/contact/widget/contact_header.dart';
import 'package:profile/features/shell/widget/desktop_toolbar.dart';
import 'package:profile/features/engineering/widget/architecture_diagram_card.dart';
import 'package:profile/features/engineering/widget/engineering_header.dart';
import 'package:profile/features/experience/widget/experience_card.dart';
import 'package:profile/features/experience/widget/experience_header.dart';
import 'package:profile/features/shell/widget/folio_bar.dart';
import 'package:profile/features/hats/widget/hat_role_pills.dart';
import 'package:profile/features/intro/widget/intro_cta_row.dart';
import 'package:profile/features/shell/widget/keyboard_hint_chip.dart';
import 'package:profile/features/shell/widget/mobile_app_bar.dart';
import 'package:profile/features/projects/widget/pipeline_topology_diagram.dart';
import 'package:profile/shared/widget/screen_shell.dart';
import 'package:profile/features/skills/widget/bento_skill_tile.dart';
import 'package:profile/features/skills/widget/skills_header.dart';
import 'package:profile/theme/app_theme.dart';

HomeController _mockController({int initialPage = 0}) {
  final pageNotifier = ValueNotifier<int>(initialPage);
  return HomeController(
    pageIndex: pageNotifier,
    showScrollToTop: ValueNotifier<bool>(false),
    pageCount: 7,
    goTo: (int page, {bool syncUrl = true}) {
      pageNotifier.value = page;
    },
    next: () {},
    prev: () {},
    scrollToMobileSection: (int page, {bool syncUrl = true}) {},
    downloadResume: () async {},
  );
}

Widget _wrapWithHarness({
  required Widget child,
  Size size = const Size(1200, 900),
  HomeController? controller,
}) {
  return MaterialApp(
    theme: AppTheme.dark(),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: HomeControllerScope(
      controller: controller ?? _mockController(),
      child: MediaQuery(
        data: MediaQueryData(size: size),
        child: Scaffold(body: child),
      ),
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Accessibility & Screen Reader Audit — Interactive Controls', () {
    testWidgets('DesktopToolbar buttons declare button and toggled semantics', (tester) async {
      await tester.pumpWidget(_wrapWithHarness(child: const DesktopToolbar()));
      await tester.pumpAndSettle();

      // Language picker puck
      final langSemantics = find.byWidgetPredicate(
        (w) => w is Semantics && w.properties.button == true && (w.properties.label?.contains('Change language') ?? false),
      );
      expect(langSemantics, findsOneWidget);

      // Theme toggle puck
      final themeSemantics = find.byWidgetPredicate(
        (w) => w is Semantics && w.properties.button == true && w.properties.toggled != null && (w.properties.label?.contains('mode') ?? false),
      );
      expect(themeSemantics, findsOneWidget);

      // Audio toggle puck
      final audioSemantics = find.byWidgetPredicate(
        (w) => w is Semantics && w.properties.button == true && w.properties.toggled != null && (w.properties.label?.contains('sound effects') ?? false),
      );
      expect(audioSemantics, findsOneWidget);
    });

    testWidgets('MobileAppBar declares semantics for quick controls and menu', (tester) async {
      await tester.pumpWidget(_wrapWithHarness(
        size: const Size(500, 800),
        child: MobileAppBar(onMenuPressed: () {}),
      ));
      await tester.pumpAndSettle();

      // Brand logo
      expect(
        find.byWidgetPredicate((w) => w is Semantics && w.properties.button == true && (w.properties.label?.contains('Abdallah') ?? false)),
        findsOneWidget,
      );

      // Language quick control
      expect(
        find.byWidgetPredicate((w) => w is Semantics && w.properties.button == true && (w.properties.label?.contains('Change language') ?? false)),
        findsOneWidget,
      );

      // Theme quick control
      expect(
        find.byWidgetPredicate((w) => w is Semantics && w.properties.button == true && w.properties.toggled != null && (w.properties.label?.contains('mode') ?? false)),
        findsOneWidget,
      );

      // Audio quick control
      expect(
        find.byWidgetPredicate((w) => w is Semantics && w.properties.button == true && (w.properties.label?.contains('ambient audio') ?? false)),
        findsOneWidget,
      );

      // Menu button
      expect(
        find.byWidgetPredicate((w) => w is Semantics && w.properties.button == true && (w.properties.label?.contains('navigation menu') ?? false)),
        findsOneWidget,
      );
    });

    testWidgets('HatRolePills announces role position and selected state', (tester) async {
      await tester.pumpWidget(_wrapWithHarness(
        child: HatRolePills(
          selectedIndex: 1,
          isDesktop: true,
          onSelectRole: (_) {},
        ),
      ));
      await tester.pumpAndSettle();

      // Active pill (index 1)
      final selectedPill = find.byWidgetPredicate(
        (w) => w is Semantics && w.properties.button == true && w.properties.selected == true && (w.properties.label?.contains('Role 2 of') ?? false),
      );
      expect(selectedPill, findsOneWidget);

      // Unselected pill (index 0)
      final unselectedPill = find.byWidgetPredicate(
        (w) => w is Semantics && w.properties.button == true && w.properties.selected == false && (w.properties.label?.contains('Role 1 of') ?? false),
      );
      expect(unselectedPill, findsOneWidget);
    });

    testWidgets('BentoSkillTile announces skill name, mastery level, and flip hint', (tester) async {
      final skill = kSkills.first;
      await tester.pumpWidget(_wrapWithHarness(
        child: BentoSkillTile(
          skill: skill,
          categoryColor: Colors.blue,
          categoryGradient: const [Colors.blue, Colors.cyan],
          isDesktop: true,
        ),
      ));
      await tester.pumpAndSettle();

      final skillSemantics = find.byWidgetPredicate(
        (w) => w is Semantics && w.properties.button == true && (w.properties.label?.contains(skill.name) ?? false) && (w.properties.label?.contains('flip') ?? false),
      );
      expect(skillSemantics, findsOneWidget);
    });

    testWidgets('ExperienceCard declares container semantics and action buttons', (tester) async {
      final exp = kExperience.first;
      await tester.pumpWidget(_wrapWithHarness(
        child: ExperienceCard(
          exp: exp,
          scheme: AppTheme.dark().colorScheme,
          isDesktop: true,
        ),
      ));
      await tester.pumpAndSettle();

      // Card container semantics
      final cardSemantics = find.byWidgetPredicate(
        (w) => w is Semantics && w.container == true && (w.properties.label?.contains(exp.company) ?? false),
      );
      expect(cardSemantics, findsOneWidget);

      // Company action pills (e.g. Website or LinkedIn)
      if (exp.websiteUrl != null || exp.linkedinUrl != null) {
        final actionPillSemantics = find.byWidgetPredicate(
          (w) => w is Semantics && w.properties.button == true && (w.properties.label?.contains(exp.company) ?? false),
        );
        expect(actionPillSemantics, findsWidgets);
      }
    });

    testWidgets('BentoTrackCard declares button semantics on inquire action', (tester) async {
      final track = ConsultingTrack(
        tag: 'ARCHITECTURE',
        title: 'Full Engine Audit',
        description: 'Comprehensive evaluation of code quality and scale.',
        icon: Icons.architecture,
        accent: Colors.amber,
        inquirySubject: 'Engine Audit',
        onInquire: (_) {},
      );

      await tester.pumpWidget(_wrapWithHarness(child: BentoTrackCard(track: track)));
      await tester.pumpAndSettle();

      final inquireSemantics = find.byWidgetPredicate(
        (w) => w is Semantics && w.properties.button == true && (w.properties.label?.contains('Inquire about Full Engine Audit') ?? false),
      );
      expect(inquireSemantics, findsOneWidget);
    });

    testWidgets('ChannelTile declares button semantics for primary and secondary actions', (tester) async {
      final data = ChannelData(
        badge: 'PRIMARY',
        badgeColor: Colors.blue,
        label: 'TELEGRAM',
        value: '@alhyari',
        icon: Icons.send,
        primaryLabel: 'Message',
        primaryAction: () {},
        secondaryLabel: 'Copy',
        secondaryAction: () {},
        accent: Colors.blue,
      );

      await tester.pumpWidget(_wrapWithHarness(child: ChannelTile(data: data)));
      await tester.pumpAndSettle();

      final primaryBtn = find.byWidgetPredicate(
        (w) => w is Semantics && w.properties.button == true && (w.properties.label?.contains('TELEGRAM: Message') ?? false),
      );
      expect(primaryBtn, findsOneWidget);

      final secondaryBtn = find.byWidgetPredicate(
        (w) => w is Semantics && w.properties.button == true && (w.properties.label?.contains('TELEGRAM: Copy') ?? false),
      );
      expect(secondaryBtn, findsOneWidget);
    });

    testWidgets('KeyboardHintChip declares button semantics', (tester) async {
      await tester.pumpWidget(_wrapWithHarness(
        child: KeyboardHintChip(onShowHelp: () {}),
      ));
      await tester.pumpAndSettle();

      final chipSemantics = find.byWidgetPredicate(
        (w) => w is Semantics && w.properties.button == true && (w.properties.label?.contains('keyboard shortcuts') ?? false),
      );
      expect(chipSemantics, findsOneWidget);
    });

    testWidgets('IntroCtaRow ghost buttons declare button semantics', (tester) async {
      await tester.pumpWidget(_wrapWithHarness(
        child: IntroCtaRow(
          isDark: true,
          onViewWork: () {},
          onDownloadResume: () {},
          onContactMe: () {},
        ),
      ));
      await tester.pumpAndSettle();

      expect(
        find.byWidgetPredicate((w) => w is Semantics && w.properties.button == true && (w.properties.label?.contains('DOWNLOAD RESUME') ?? false)),
        findsOneWidget,
      );
      expect(
        find.byWidgetPredicate((w) => w is Semantics && w.properties.button == true && (w.properties.label?.contains('CONTACT ME') ?? false)),
        findsOneWidget,
      );
      expect(
        find.byWidgetPredicate((w) => w is Semantics && w.properties.button == true && (w.properties.label?.contains('COPY EMAIL') ?? false)),
        findsOneWidget,
      );
    });
  });

  group('Accessibility & Screen Reader Audit — Heading Landmarks (header: true)', () {
    testWidgets('ProjectsPage declares header landmark on section title', (tester) async {
      await tester.pumpWidget(_wrapWithHarness(child: const ProjectsPage()));
      await tester.pumpAndSettle();

      final headerFinder = find.byWidgetPredicate(
        (w) => w is Semantics && w.properties.header == true,
      );
      expect(headerFinder, findsWidgets);
    });

    testWidgets('EngineeringHeader declares header landmark', (tester) async {
      await tester.pumpWidget(_wrapWithHarness(
        child: const EngineeringHeader(isDesktop: true),
      ));
      await tester.pumpAndSettle();

      final headerFinder = find.byWidgetPredicate(
        (w) => w is Semantics && w.properties.header == true,
      );
      expect(headerFinder, findsOneWidget);
    });

    testWidgets('ExperienceHeader declares header landmark', (tester) async {
      await tester.pumpWidget(_wrapWithHarness(
        child: const ExperienceHeader(isDesktop: true),
      ));
      await tester.pumpAndSettle();

      final headerFinder = find.byWidgetPredicate(
        (w) => w is Semantics && w.properties.header == true,
      );
      expect(headerFinder, findsOneWidget);
    });

    testWidgets('SkillsHeader declares header landmark', (tester) async {
      await tester.pumpWidget(_wrapWithHarness(
        child: const SkillsHeader(isDesktop: true),
      ));
      await tester.pumpAndSettle();

      final headerFinder = find.byWidgetPredicate(
        (w) => w is Semantics && w.properties.header == true,
      );
      expect(headerFinder, findsOneWidget);
    });

    testWidgets('ContactHeader declares header landmark', (tester) async {
      await tester.pumpWidget(_wrapWithHarness(
        child: const ContactHeader(),
      ));
      await tester.pumpAndSettle();

      final headerFinder = find.byWidgetPredicate(
        (w) => w is Semantics && w.properties.header == true,
      );
      expect(headerFinder, findsOneWidget);
    });
  });

  group('Accessibility & Screen Reader Audit — Diagrams, Metric Cards, Folio & Shell', () {
    testWidgets('ArchitectureDiagramCard declares container semantics with tier count', (tester) async {
      final topic = kArchitectureTopics.first;
      await tester.pumpWidget(_wrapWithHarness(
        child: ArchitectureDiagramCard(topic: topic, isDesktop: true),
      ));
      await tester.pumpAndSettle();

      final diagramFinder = find.byWidgetPredicate(
        (w) => w is Semantics && w.container == true && (w.properties.label?.contains('Architecture flowchart diagram') ?? false),
      );
      expect(diagramFinder, findsOneWidget);
    });

    testWidgets('PipelineTopologyDiagram declares container semantics with stage flow', (tester) async {
      final project = kProjects.first;
      await tester.pumpWidget(_wrapWithHarness(
        child: PipelineTopologyDiagram(
          project: project,
          isDesktop: true,
          isDark: true,
        ),
      ));
      await tester.pumpAndSettle();

      final pipelineFinder = find.byWidgetPredicate(
        (w) => w is Semantics && w.container == true && (w.properties.label?.contains('Pipeline architecture') ?? false),
      );
      expect(pipelineFinder, findsOneWidget);
    });

    testWidgets('OutcomeCard declares container semantics describing key metrics', (tester) async {
      await tester.pumpWidget(_wrapWithHarness(
        child: const SizedBox(
          width: 250,
          height: 180,
          child: OutcomeCard(headline: '99.98%', body: 'Production uptime across cluster'),
        ),
      ));
      await tester.pumpAndSettle();

      final outcomeFinder = find.byWidgetPredicate(
        (w) => w is Semantics && w.container == true && (w.properties.label?.contains('Key outcome metric: 99.98%') ?? false),
      );
      expect(outcomeFinder, findsOneWidget);
    });

    testWidgets('FolioBar declares container semantics with current section and page position', (tester) async {
      final controller = _mockController(initialPage: 2);
      await tester.pumpWidget(_wrapWithHarness(
        controller: controller,
        child: const FolioBar(),
      ));
      await tester.pumpAndSettle();

      final folioFinder = find.byWidgetPredicate(
        (w) => w is Semantics && w.container == true && (w.properties.label?.contains('Current section:') ?? false) && (w.properties.label?.contains('page 3 of 7') ?? false),
      );
      expect(folioFinder, findsOneWidget);
    });

    testWidgets('AppScreenShell wraps page content in Semantics container', (tester) async {
      await tester.pumpWidget(_wrapWithHarness(
        child: const AppScreenShell(
          child: Text('Screen Shell Content'),
        ),
      ));
      await tester.pumpAndSettle();

      final shellFinder = find.byWidgetPredicate(
        (w) => w is Semantics && w.container == true,
      );
      expect(shellFinder, findsWidgets);
    });
  });
}
