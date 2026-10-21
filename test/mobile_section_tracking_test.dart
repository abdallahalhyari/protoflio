import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:profile/core/bloc/locale/locale_bloc.dart';
import 'package:profile/core/bloc/theme/theme_bloc.dart';
import 'package:profile/core/services/url_sync_service.dart';
import 'package:profile/features/about/presentation/about_navigation.dart';
import 'package:profile/features/experience/domain/repositories/experience_repository.dart';
import 'package:profile/features/projects/domain/repositories/project_repository.dart';
import 'package:profile/features/shell/presentation/controllers/home_controller.dart';
import 'package:profile/features/shell/presentation/pages/home_screen.dart';
import 'package:profile/features/shell/presentation/widgets/folio_bar.dart';
import 'package:profile/features/shell/presentation/widgets/mobile_home_layout.dart';
import 'package:profile/features/shell/presentation/widgets/mobile_section_divider.dart';
import 'package:profile/features/skills/domain/repositories/skill_repository.dart';
import 'package:profile/l10n/app_localizations.dart';
import 'helpers/test_data.dart';

Widget _wrapHome() {
  return MultiRepositoryProvider(
    providers: [
      RepositoryProvider<ProjectRepository>(
          create: (_) => TestProjectRepository()),
      RepositoryProvider<ExperienceRepository>(
          create: (_) => TestExperienceRepository()),
      RepositoryProvider<SkillRepository>(create: (_) => TestSkillRepository()),
    ],
    child: MultiBlocProvider(
      providers: [
        BlocProvider<ThemeBloc>(create: (_) => ThemeBloc()),
        BlocProvider<LocaleBloc>(create: (_) => LocaleBloc()),
      ],
      child: const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: HomeScreen(),
      ),
    ),
  );
}

Future<void> _settle(WidgetTester tester, [int frames = 10]) async {
  for (int i = 0; i < frames; i++) {
    await tester.pump(const Duration(milliseconds: 200));
  }
}

void _setSize(WidgetTester tester, Size size) {
  tester.view.devicePixelRatio = 1.0;
  tester.view.physicalSize = size;
}

/// Page titles the app publishes (the stub URL service turns every hash it
/// writes into a title on this channel), newest last.
List<String> _recordTitles(WidgetTester tester) {
  final titles = <String>[];
  tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
    SystemChannels.platform,
    (call) async {
      if (call.method == 'SystemChrome.setApplicationSwitcherDescription') {
        titles.add((call.arguments as Map)['label'] as String);
      }
      return null;
    },
  );
  addTearDown(() => tester.binding.defaultBinaryMessenger
      .setMockMethodCallHandler(SystemChannels.platform, null));
  return titles;
}

void main() {
  tearDown(() => aboutTabRequest.value = null);

  testWidgets(
      'one large scroll jump lands on the section now under the focal line',
      (tester) async {
    _setSize(tester, const Size(390, 844));
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(_wrapHome());
    await _settle(tester);

    final pageIndex =
        HomeController.of(tester.element(find.byType(MobileHomeLayout)))
            .pageIndex;
    final position =
        tester.state<ScrollableState>(find.byType(Scrollable).first).position;
    // Built (the list caches every section) but below the fold.
    final divider = find.byWidgetPredicate(
      (w) => w is MobileSectionDivider && w.number == '03',
      skipOffstage: false,
    );
    final dividerBottom = tester.getBottomLeft(divider).dy;

    // One jump (a wheel notch or fling end): Experience's top lands at
    // y=100, so the tracker's focal line (y=180) sits inside Experience.
    position.jumpTo(position.pixels + dividerBottom - 100);
    await _settle(tester, 3);

    expect(pageIndex.value, 2,
        reason: 'the tracker must read where sections are now, '
            'not where they were before the scroll');
  });

  testWidgets('switching desktop to mobile publishes the section mobile shows',
      (tester) async {
    final titles = _recordTitles(tester);
    _setSize(tester, const Size(1400, 900));
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(_wrapHome());
    await _settle(tester, 6);

    // A visit to #about earlier left a profile request behind; the user then
    // browsed to the combined About & Contact page, so the URL says contact.
    aboutTabRequest.value = AboutTabs.profile;
    HomeController.of(tester.element(find.byType(FolioBar))).goTo(5);
    await _settle(tester);
    expect(titles.last, UrlSyncService.instance.titleForHash('contact'));

    _setSize(tester, const Size(390, 844));
    await _settle(tester);

    final shown =
        HomeController.of(tester.element(find.byType(MobileHomeLayout)))
            .pageIndex
            .value;
    expect(
      titles.last,
      UrlSyncService.instance
          .titleForHash(UrlSyncService.instance.indexToHash(shown)),
      reason: 'the URL must name the section on screen after the switch',
    );
  });
}
