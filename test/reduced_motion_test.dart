import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:profile/main.dart';
import 'helpers/test_data.dart';

PageController _desktopPages(WidgetTester tester) => tester
    .widget<Scrollable>(
        find.byKey(const PageStorageKey<String>('desktop_pageview')))
    .controller! as PageController;

void main() {
  // The page-turn transformer drops its effects under reduced motion, but
  // the page itself used to slide a full screen height on every turn.
  testWidgets('desktop page turns cut instead of sliding with reduced motion',
      (tester) async {
    tester.view.physicalSize = const Size(1440, 900);
    tester.view.devicePixelRatio = 1.0;
    tester.platformDispatcher.accessibilityFeaturesTestValue =
        const FakeAccessibilityFeatures(disableAnimations: true);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);

    await tester.pumpWidget(PortfolioApp(
      projectRepo: TestProjectRepository(),
      experienceRepo: TestExperienceRepository(),
      hatRepo: TestHatRepository(),
      skillRepo: TestSkillRepository(),
    ));
    for (var i = 0; i < 6; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }

    await tester.sendKeyEvent(LogicalKeyboardKey.digit3);
    await tester.pump(); // one frame, no animation time
    expect(_desktopPages(tester).page, 2.0);

    await tester.sendKeyEvent(LogicalKeyboardKey.digit6);
    await tester.pump();
    expect(_desktopPages(tester).page, 5.0);
    for (var i = 0; i < 6; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
  });
}
