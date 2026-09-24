import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:profile/features/contact/widget/contact_header.dart';
import 'package:profile/features/experience/widget/experience_header.dart';
import 'package:profile/features/shell/home_controller.dart';
import 'package:profile/features/shell/widget/mobile_pager.dart';
import 'package:profile/features/skills/widget/skills_header.dart';
import 'package:profile/main.dart';

void main() {
  // Menu / hash jumps on phones used to do nothing: ListView builds lazily
  // and the section keys lived inside DeferredMount, so any section more
  // than a screen away had no position and the jump silently bailed.
  testWidgets('mobile menu jumps land each section under the app bar',
      (tester) async {
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(390, 844);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    await tester.pumpWidget(const PortfolioApp());
    for (int i = 0; i < 6; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    final controller =
        HomeController.of(tester.element(find.byType(MobilePager)));

    final cases = <int, Type>{
      3: SkillsHeader,
      6: ContactHeader,
      1: ExperienceHeader,
    };
    for (final entry in cases.entries) {
      controller.scrollToMobileSection(entry.key);
      for (int i = 0; i < 25; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }
      final top = tester.getTopLeft(find.byType(entry.value).first).dy;
      expect(top, inInclusiveRange(40.0, 260.0),
          reason: 'section ${entry.key} header should sit under the bar');
      expect(controller.pageIndex.value, entry.key);
    }
  });
}
