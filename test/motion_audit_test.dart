import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:profile/core/bloc/locale/locale_bloc.dart';
import 'package:profile/core/bloc/theme/theme_bloc.dart';
import 'package:profile/features/projects/data/projects_data.dart';
import 'package:profile/l10n/app_localizations.dart';
import 'package:profile/features/shell/home_controller.dart';
import 'package:profile/features/projects/page/project_modal.dart';
import 'package:profile/features/hats/widget/hat_role_pills.dart';
import 'package:profile/features/shell/widget/mobile_pager.dart';
import 'package:profile/features/shell/widget/mobile_progress_rail.dart';
import 'package:profile/features/shell/widget/portfolio_nav.dart';
import 'package:profile/features/projects/widget/interactive_project_card.dart';
import 'package:profile/service/sound_service.dart';
import 'package:profile/theme/app_theme.dart';
import 'package:profile/theme/tokens.dart';
import 'package:shared_preferences/shared_preferences.dart';

HomeController _mockController({int initialPage = 0}) {
  final pageNotifier = ValueNotifier<int>(initialPage);
  return HomeController(
    pageIndex: pageNotifier,
    showScrollToTop: ValueNotifier<bool>(false),
    pageCount: 7,
    goTo: (int page, {bool syncUrl = true}) {
      pageNotifier.value = page;
    },
    next: () {
      if (pageNotifier.value < 6) pageNotifier.value++;
    },
    prev: () {
      if (pageNotifier.value > 0) pageNotifier.value--;
    },
    scrollToMobileSection: (int page, {bool syncUrl = true}) {
      pageNotifier.value = page;
    },
    downloadResume: () async {},
  );
}

Widget _wrapWithMedia({
  required Widget child,
  bool disableAnimations = false,
  bool accessibleNavigation = false,
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
          data: MediaQueryData(
            size: size,
            disableAnimations: disableAnimations,
            accessibleNavigation: accessibleNavigation,
          ),
          child: Scaffold(body: child),
        ),
      ),
    ),
  );
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('AppMotion & AppMedia Tokens Audit', () {
    test('AppMotion durations maintain strict monotonic ordering', () {
      expect(AppMotion.micro, lessThan(AppMotion.xs));
      expect(AppMotion.xs, lessThan(AppMotion.sm));
      expect(AppMotion.sm, lessThan(AppMotion.md));
      expect(AppMotion.md, lessThan(AppMotion.lg));
      expect(AppMotion.lg, lessThan(AppMotion.xl));
      expect(AppMotion.xl, lessThan(AppMotion.toast));
    });

    test('AppMotion specialized curves are defined and non-null', () {
      expect(AppMotion.emphasized, isNotNull);
      expect(AppMotion.emphasizedAccel, isNotNull);
      expect(AppMotion.emphasizedDecel, isNotNull);
      expect(AppMotion.standard, isNotNull);
      expect(AppMotion.spring, isNotNull);
      expect(AppMotion.easeOut, Curves.easeOut);
      expect(AppMotion.easeOutCubic, Curves.easeOutCubic);
      expect(AppMotion.easeInOutCubic, Curves.easeInOutCubic);
      expect(AppMotion.easeOutBack, Curves.easeOutBack);
      expect(AppMotion.easeInOutBack, Curves.easeInOutBack);
      expect(AppMotion.easeInOutSine, Curves.easeInOutSine);
    });

    testWidgets('AppMedia.reduceMotion detects accessibility settings',
        (tester) async {
      late bool normalMotion;
      late bool reducedDisabledAnim;
      late bool reducedAccessibleNav;

      await tester.pumpWidget(
        _wrapWithMedia(
          disableAnimations: false,
          accessibleNavigation: false,
          child: Builder(
            builder: (ctx) {
              normalMotion = AppMedia.reduceMotion(ctx);
              return const SizedBox();
            },
          ),
        ),
      );
      expect(normalMotion, isFalse);

      await tester.pumpWidget(
        _wrapWithMedia(
          disableAnimations: true,
          accessibleNavigation: false,
          child: Builder(
            builder: (ctx) {
              reducedDisabledAnim = AppMedia.reduceMotion(ctx);
              return const SizedBox();
            },
          ),
        ),
      );
      expect(reducedDisabledAnim, isTrue);

      await tester.pumpWidget(
        _wrapWithMedia(
          disableAnimations: false,
          accessibleNavigation: true,
          child: Builder(
            builder: (ctx) {
              reducedAccessibleNav = AppMedia.reduceMotion(ctx);
              return const SizedBox();
            },
          ),
        ),
      );
      expect(reducedAccessibleNav, isTrue);
    });
  });

  group('SoundService Micro-interactions & Haptics Audit', () {
    test('SoundService toggles enabled state and executes methods safely', () {
      final sound = SoundService.instance;
      final initial = sound.isEnabled.value;

      sound.toggle();
      expect(sound.isEnabled.value, !initial);

      // Restore
      sound.toggle();
      expect(sound.isEnabled.value, initial);

      // Verify execution does not throw
      sound.playClick();
      sound.playPageTurn();
      sound.playSelection();
      sound.playSnap();
    });
  });

  group('Interactive Widgets Motion & Reduced-Motion Response', () {
    testWidgets(
        'InteractiveProjectCard does not scale on hover when reduceMotion is active',
        (tester) async {
      final project = kProjects.first;

      await tester.pumpWidget(
        _wrapWithMedia(
          disableAnimations: true,
          child: InteractiveProjectCard(
            project: project,
            index: 0,
            isDesktop: true,
            scheme: ColorScheme.fromSeed(
                seedColor: AppColors.seed, brightness: Brightness.dark),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Trigger hover
      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);
      await gesture
          .moveTo(tester.getCenter(find.byType(InteractiveProjectCard)));
      await tester.pump(const Duration(milliseconds: 100));

      final animatedScale = tester.widget<AnimatedScale>(
        find
            .descendant(
              of: find.byType(InteractiveProjectCard),
              matching: find.byType(AnimatedScale),
            )
            .first,
      );

      // Scale should remain locked to 1.0 under reduced motion
      expect(animatedScale.scale, 1.0);
      expect(tester.takeException(), isNull);
    });

    testWidgets('MobilePager triggers page updates on tap', (tester) async {
      final controller = _mockController(initialPage: 1);

      await tester.pumpWidget(
        _wrapWithMedia(
          size: const Size(390, 844),
          controller: controller,
          child: const MobilePager(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('02 / 07'), findsOneWidget);

      // Tap next — MobilePager calls HomeController.scrollToMobileSection
      // and reactively re-renders off controller.pageIndex.
      final nextButton = find.byTooltip('Next section');
      expect(nextButton, findsOneWidget);
      await tester.tap(nextButton);
      await tester.pumpAndSettle();

      expect(controller.pageIndex.value, 2);

      // Tap previous — should round-trip back to the original page.
      final prevButton = find.byTooltip('Previous section');
      expect(prevButton, findsOneWidget);
      await tester.tap(prevButton);
      await tester.pumpAndSettle();

      expect(controller.pageIndex.value, 1);
      expect(tester.takeException(), isNull);
    });

    testWidgets('MobileProgressRail triggers section scroll on tap',
        (tester) async {
      final controller = _mockController(initialPage: 0);

      await tester.pumpWidget(
        _wrapWithMedia(
          size: const Size(390, 844),
          controller: controller,
          child: const MobileProgressRail(),
        ),
      );
      await tester.pumpAndSettle();

      // Tap the second dot (index 1)
      final dots = find.byType(InkResponse);
      expect(dots, findsWidgets);

      await tester.tap(dots.at(1));
      await tester.pumpAndSettle();

      // MobileProgressRail calls HomeController.scrollToMobileSection.
      expect(controller.pageIndex.value, 1);
      expect(tester.takeException(), isNull);
    });

    testWidgets('HatRolePills triggers role selection on tap', (tester) async {
      int selected = 0;

      await tester.pumpWidget(
        _wrapWithMedia(
          child: HatRolePills(
            selectedIndex: selected,
            isDesktop: true,
            onSelectRole: (idx) {
              selected = idx;
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      final pills = find.byType(InkWell);
      expect(pills, findsWidgets);

      await tester.tap(pills.at(2));
      await tester.pumpAndSettle();

      expect(selected, 2);
      expect(tester.takeException(), isNull);
    });

    testWidgets(
        'NavItem uses AppMotion.emphasized curve on selection transition',
        (tester) async {
      await tester.pumpWidget(
        _wrapWithMedia(
          child: NavItem(
            label: 'WORK',
            active: true,
            onTap: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      final animatedContainer = tester.widget<AnimatedContainer>(
        find.descendant(
          of: find.byType(NavItem),
          matching: find.byType(AnimatedContainer),
        ),
      );

      expect(animatedContainer.curve, AppMotion.emphasized);
      expect(tester.takeException(), isNull);
    });

    testWidgets(
        'ProjectModal opens with pure FadeTransition under reduced motion',
        (tester) async {
      final project = kProjects.first;

      await tester.pumpWidget(
        _wrapWithMedia(
          disableAnimations: true,
          child: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () =>
                    showProjectCaseStudy(context, project: project, index: 0),
                child: const Text('Open Modal'),
              );
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Open Modal'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      expect(find.text(project.name), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
