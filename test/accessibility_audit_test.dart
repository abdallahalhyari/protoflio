import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'helpers/test_data.dart';
import 'package:profile/core/bloc/locale/locale_bloc.dart';
import 'package:profile/core/bloc/theme/theme_bloc.dart';
import 'package:profile/l10n/app_localizations.dart';
import 'package:profile/features/case_study/presentation/widgets/case_study_widgets.dart';
import 'package:profile/features/engineering/data/datasources/architecture_data.dart';

import 'package:profile/features/shell/presentation/controllers/home_controller.dart';
import 'package:profile/features/projects/presentation/pages/projects_page.dart';
import 'package:profile/features/contact/presentation/widgets/contact_header.dart';
import 'package:profile/features/shell/presentation/widgets/desktop_toolbar.dart';
import 'package:profile/features/engineering/presentation/widgets/architecture_diagram_card.dart';
import 'package:profile/features/engineering/presentation/widgets/engineering_header.dart';
import 'package:profile/features/experience/presentation/widgets/experience_card.dart';
import 'package:profile/features/experience/presentation/widgets/experience_header.dart';
import 'package:profile/features/shell/presentation/widgets/folio_bar.dart';
import 'package:profile/features/intro/presentation/widgets/intro_cta_row.dart';
import 'package:profile/features/shell/presentation/widgets/keyboard_hint_chip.dart';
import 'package:profile/features/shell/presentation/widgets/mobile_app_bar.dart';
import 'package:profile/features/projects/presentation/widgets/pipeline_topology_diagram.dart';
import 'package:profile/shared/widgets/screen_shell.dart';
import 'package:profile/features/skills/presentation/widgets/skills_header.dart';
import 'package:profile/core/theme/app_theme.dart';

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
  final ctrl = controller ?? _mockController();
  return MultiBlocProvider(
    providers: [
      BlocProvider<ThemeBloc>(create: (_) => ThemeBloc()),
      BlocProvider<LocaleBloc>(create: (_) => LocaleBloc()),
    ],
    child: MaterialApp(
      theme: AppTheme.dark(),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: HomeControllerScope(
        controller: ctrl,
        child: MediaQuery(
          data: MediaQueryData(size: size),
          child: Scaffold(body: child),
        ),
      ),
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Accessibility & Screen Reader Audit — Interactive Controls', () {
    testWidgets('DesktopToolbar buttons declare button and toggled semantics',
        (tester) async {
      await tester.pumpWidget(_wrapWithHarness(child: const DesktopToolbar()));
      await tester.pumpAndSettle();

      // Language picker puck
      final langSemantics = find.byWidgetPredicate(
        (w) =>
            w is Semantics &&
            w.properties.button == true &&
            (w.properties.label?.contains('Change language') ?? false),
      );
      expect(langSemantics, findsOneWidget);

      // Theme toggle puck
      final themeSemantics = find.byWidgetPredicate(
        (w) =>
            w is Semantics &&
            w.properties.button == true &&
            w.properties.toggled != null &&
            (w.properties.label?.contains('mode') ?? false),
      );
      expect(themeSemantics, findsOneWidget);

      // Audio toggle puck
      final audioSemantics = find.byWidgetPredicate(
        (w) =>
            w is Semantics &&
            w.properties.button == true &&
            w.properties.toggled != null &&
            (w.properties.label?.contains('sound effects') ?? false),
      );
      expect(audioSemantics, findsOneWidget);
    });

    testWidgets('MobileAppBar declares semantics for quick controls and menu',
        (tester) async {
      await tester.pumpWidget(_wrapWithHarness(
        size: const Size(500, 800),
        child: MobileAppBar(onMenuPressed: () {}),
      ));
      await tester.pumpAndSettle();

      // Brand logo
      expect(
        find.byWidgetPredicate((w) =>
            w is Semantics &&
            w.properties.button == true &&
            (w.properties.label?.contains('Abdallah') ?? false)),
        findsOneWidget,
      );

      // Language quick control
      expect(
        find.byWidgetPredicate((w) =>
            w is Semantics &&
            w.properties.button == true &&
            (w.properties.label?.contains('Change language') ?? false)),
        findsOneWidget,
      );

      // Theme quick control
      expect(
        find.byWidgetPredicate((w) =>
            w is Semantics &&
            w.properties.button == true &&
            w.properties.toggled != null &&
            (w.properties.label?.contains('mode') ?? false)),
        findsOneWidget,
      );

      // Audio quick control
      expect(
        find.byWidgetPredicate((w) =>
            w is Semantics &&
            w.properties.button == true &&
            (w.properties.label?.contains('sound effects') ?? false)),
        findsOneWidget,
      );

      // Menu button
      expect(
        find.byWidgetPredicate((w) =>
            w is Semantics &&
            w.properties.button == true &&
            (w.properties.label?.contains('navigation menu') ?? false)),
        findsOneWidget,
      );
    });

    testWidgets(
        'ExperienceCard declares container semantics and action buttons',
        (tester) async {
      final exp = testExperience.first;
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
        (w) =>
            w is Semantics &&
            w.container &&
            (w.properties.label?.contains(exp.company) ?? false),
      );
      expect(cardSemantics, findsOneWidget);

      // Company pills (Website / LinkedIn) are links, named once.
      if (exp.websiteUrl != null || exp.linkedinUrl != null) {
        final actionPillSemantics = find.byWidgetPredicate(
          (w) =>
              w is Semantics &&
              w.properties.link == true &&
              w.properties.linkUrl != null &&
              (w.properties.label?.contains(exp.company) ?? false),
        );
        expect(actionPillSemantics, findsWidgets);
      }
    });

    testWidgets('KeyboardHintChip declares button semantics', (tester) async {
      await tester.pumpWidget(_wrapWithHarness(
        child: KeyboardHintChip(onShowHelp: () {}),
      ));
      await tester.pumpAndSettle();

      final chipSemantics = find.byWidgetPredicate(
        (w) =>
            w is Semantics &&
            w.properties.button == true &&
            (w.properties.label?.toLowerCase().contains('keyboard shortcuts') ??
                false),
      );
      expect(chipSemantics, findsOneWidget);
    });

    testWidgets('IntroCtaRow ghost buttons declare button semantics',
        (tester) async {
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
        find.byWidgetPredicate((w) =>
            w is Semantics &&
            w.properties.button == true &&
            (w.properties.label?.contains('Download CV') ?? false)),
        findsOneWidget,
      );
      expect(
        find.byWidgetPredicate((w) =>
            w is Semantics &&
            w.properties.button == true &&
            (w.properties.label?.contains('Let\'s talk') ?? false)),
        findsOneWidget,
      );
      expect(
        find.byWidgetPredicate((w) =>
            w is Semantics &&
            w.properties.button == true &&
            (w.properties.label?.contains('Copy email') ?? false)),
        findsOneWidget,
      );
    });
  });

  group(
      'Accessibility & Screen Reader Audit — Heading Landmarks (header: true)',
      () {
    testWidgets('ProjectsPage declares header landmark on section title',
        (tester) async {
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

  group(
      'Accessibility & Screen Reader Audit — Diagrams, Metric Cards, Folio & Shell',
      () {
    testWidgets(
        'ArchitectureDiagramCard declares container semantics with tier count',
        (tester) async {
      final topic = kArchitectureTopics.first;
      await tester.pumpWidget(_wrapWithHarness(
        child: ArchitectureDiagramCard(topic: topic, isDesktop: true),
      ));
      await tester.pumpAndSettle();

      final diagramFinder = find.byWidgetPredicate(
        (w) =>
            w is Semantics &&
            w.container &&
            (w.properties.label?.contains('Architecture flowchart diagram') ??
                false),
      );
      expect(diagramFinder, findsOneWidget);
    });

    testWidgets(
        'PipelineTopologyDiagram declares container semantics with stage flow',
        (tester) async {
      final project = testProjects.first;
      await tester.pumpWidget(_wrapWithHarness(
        child: PipelineTopologyDiagram(
          project: project,
          isDesktop: true,
          isDark: true,
        ),
      ));
      await tester.pumpAndSettle();

      final pipelineFinder = find.byWidgetPredicate(
        (w) =>
            w is Semantics &&
            w.container &&
            (w.properties.label?.contains('Pipeline architecture') ?? false),
      );
      expect(pipelineFinder, findsOneWidget);
    });

    testWidgets(
        'OutcomeCard declares container semantics describing key metrics',
        (tester) async {
      await tester.pumpWidget(_wrapWithHarness(
        child: const SizedBox(
          width: 250,
          height: 180,
          child: OutcomeCard(
              headline: '99.98%', body: 'Production uptime across cluster'),
        ),
      ));
      await tester.pumpAndSettle();

      final outcomeFinder = find.byWidgetPredicate(
        (w) =>
            w is Semantics &&
            w.container &&
            (w.properties.label?.contains('Key outcome metric: 99.98%') ??
                false),
      );
      expect(outcomeFinder, findsOneWidget);
    });

    testWidgets(
        'FolioBar declares container semantics with current section and page position',
        (tester) async {
      final controller = _mockController(initialPage: 2);
      await tester.pumpWidget(_wrapWithHarness(
        controller: controller,
        child: const FolioBar(),
      ));
      await tester.pumpAndSettle();

      final folioFinder = find.byWidgetPredicate(
        (w) =>
            w is Semantics &&
            w.container &&
            (w.properties.label?.contains('Current section:') ?? false) &&
            (w.properties.label?.contains('page 3 of 7') ?? false),
      );
      expect(folioFinder, findsOneWidget);
    });

    testWidgets('AppScreenShell wraps page content in Semantics container',
        (tester) async {
      await tester.pumpWidget(_wrapWithHarness(
        child: const AppScreenShell(
          child: Text('Screen Shell Content'),
        ),
      ));
      await tester.pumpAndSettle();

      final shellFinder = find.byWidgetPredicate(
        (w) => w is Semantics && w.container,
      );
      expect(shellFinder, findsWidgets);
    });
  });
}
