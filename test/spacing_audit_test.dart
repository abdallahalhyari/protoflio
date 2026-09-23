import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:profile/core/bloc/locale/locale_bloc.dart';
import 'package:profile/core/bloc/theme/theme_bloc.dart';
import 'package:profile/l10n/app_localizations.dart';
import 'package:profile/features/case_study/case_study_widgets.dart';
import 'package:profile/features/shell/home_controller.dart';
import 'package:profile/features/experience/page/experience_page.dart';
import 'package:profile/features/experience/widget/experience_header.dart';
import 'package:profile/features/shell/widget/mobile_home_layout.dart';
import 'package:profile/features/shell/widget/portfolio_nav.dart';
import 'package:profile/shared/widget/screen_shell.dart';
import 'package:profile/theme/app_theme.dart';
import 'package:profile/theme/tokens.dart';

HomeController _mockController() {
  return HomeController(
    pageIndex: ValueNotifier<int>(0),
    showScrollToTop: ValueNotifier<bool>(false),
    pageCount: 7,
    goTo: (int _, {bool syncUrl = true}) {},
    next: () {},
    prev: () {},
    scrollToMobileSection: (int _, {bool syncUrl = true}) {},
    downloadResume: () async {},
  );
}

Widget _wrap(Widget child, {Size? size, EdgeInsets? padding}) {
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
        controller: _mockController(),
        child: MediaQuery(
          data: MediaQueryData(
            size: size ?? const Size(1200, 900),
            padding: padding ?? EdgeInsets.zero,
          ),
          child: Scaffold(body: child),
        ),
      ),
    ),
  );
}

void main() {
  group('Page Padding & Spacing Audit Regression Tests', () {
    testWidgets(
        'ExperiencePage does not double-pad horizontally inside AppScreenShell',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(1200, 900));
      await tester
          .pumpWidget(_wrap(const ExperiencePage(isContinuousMobile: false)));
      await tester.pumpAndSettle();

      final shellFinder = find.byType(AppScreenShell);
      expect(shellFinder, findsOneWidget);

      // Verify ExperienceHeader has no redundant inner horizontal padding
      final headerFinder = find.byType(ExperienceHeader);
      expect(headerFinder, findsOneWidget);

      // Header is a direct child of Column inside AppScreenShell without an extra Padding wrapper.
      final directParent = tester.widget<Column>(find
          .ancestor(
            of: headerFinder,
            matching: find.byType(Column),
          )
          .first);
      expect(directParent.children.any((w) => w is ExperienceHeader), isTrue);

      await tester.binding.setSurfaceSize(null);
    });

    testWidgets(
        'TopNav reserves clearance for DesktopToolbar on desktop viewports',
        (tester) async {
      // 960px desktop viewport
      await tester.binding.setSurfaceSize(const Size(960, 800));
      await tester
          .pumpWidget(_wrap(const TopNav(), size: const Size(960, 800)));
      await tester.pumpAndSettle();

      final constrainedBox = tester.widget<ConstrainedBox>(
        find
            .descendant(
                of: find.byType(TopNav), matching: find.byType(ConstrainedBox))
            .first,
      );

      // Width 960 - 320 reserve = 640 max width
      expect(constrainedBox.constraints.maxWidth, 640.0);

      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('TopNav on mobile viewports uses AppSpacing.xl reserve',
        (tester) async {
      // 400px mobile viewport
      await tester.binding.setSurfaceSize(const Size(400, 800));
      await tester
          .pumpWidget(_wrap(const TopNav(), size: const Size(400, 800)));
      await tester.pumpAndSettle();

      final constrainedBox = tester.widget<ConstrainedBox>(
        find
            .descendant(
                of: find.byType(TopNav), matching: find.byType(ConstrainedBox))
            .first,
      );

      // Width 400 - AppSpacing.xl (32) = 368 max width
      expect(constrainedBox.constraints.maxWidth, 368.0);

      await tester.binding.setSurfaceSize(null);
    });

    testWidgets(
        'MobileHomeLayout SingleChildScrollView clears floating MobilePager and safe area',
        (tester) async {
      final keys = List.generate(7, (_) => GlobalKey());
      final scrollController = ScrollController();
      addTearDown(scrollController.dispose);

      const bottomSafeArea = 34.0;
      await tester.pumpWidget(_wrap(
        MobileHomeLayout(
          scrollController: scrollController,
          sectionKeys: keys,
        ),
        size: const Size(390, 844),
        padding: const EdgeInsets.only(bottom: bottomSafeArea),
      ));
      await tester.pump(const Duration(milliseconds: 300));

      final scrollView = tester.widget<ListView>(
        find.byKey(const PageStorageKey<String>('mobile_scrollview')),
      );

      final padding = scrollView.padding as EdgeInsets;
      // Expect bottom padding to be 80 + bottomSafeArea (114)
      expect(padding.bottom, 80.0 + bottomSafeArea);
    });

    testWidgets('CaseStudyLayout caps reading width to 960px on wide monitors',
        (tester) async {
      // 1920px wide monitor
      await tester.pumpWidget(_wrap(
        Builder(builder: (context) {
          final hPad = CaseStudyLayout.horizontalPadding(context);
          return Text('pad: $hPad');
        }),
        size: const Size(1920, 1080),
      ));
      await tester.pump();

      // (1920 - 960) / 2 = 480
      expect(find.text('pad: 480.0'), findsOneWidget);

      // 4K monitor (3840px)
      await tester.pumpWidget(_wrap(
        Builder(builder: (context) {
          final hPad = CaseStudyLayout.horizontalPadding(context);
          return Text('pad: $hPad');
        }),
        size: const Size(3840, 2160),
      ));
      await tester.pump();

      // (3840 - 960) / 2 = 1440
      expect(find.text('pad: 1440.0'), findsOneWidget);

      // Mobile phone (390px)
      await tester.pumpWidget(_wrap(
        Builder(builder: (context) {
          final hPad = CaseStudyLayout.horizontalPadding(context);
          return Text('pad: $hPad');
        }),
        size: const Size(390, 844),
      ));
      await tester.pump();

      // AppSpacing.lg = 24.0
      expect(find.text('pad: ${AppSpacing.lg}'), findsOneWidget);
    });
  });
}
