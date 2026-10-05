import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:profile/features/intro/presentation/widgets/intro_constellation.dart';
import 'package:profile/features/shell/presentation/controllers/home_controller.dart';

Widget _host(GlobalKey<IntroConstellationState> key,
    {ValueNotifier<int>? pageIndex, bool reduceMotion = false}) {
  Widget child = MediaQuery(
    data: MediaQueryData(
      size: const Size(390, 844),
      disableAnimations: reduceMotion,
    ),
    child: Directionality(
      textDirection: TextDirection.ltr,
      child: IntroConstellation(key: key, isDark: true),
    ),
  );
  if (pageIndex != null) {
    child = HomeControllerScope(
      controller: HomeController(
        pageIndex: pageIndex,
        showScrollToTop: ValueNotifier<bool>(false),
        pageCount: 7,
        goTo: (int _, {bool syncUrl = true}) {},
        next: () {},
        prev: () {},
        scrollToMobileSection: (int _, {bool syncUrl = true}) {},
        downloadResume: () async {},
      ),
      child: child,
    );
  }
  return child;
}

/// Advances [seconds] of animation in frames of [frame] length.
Future<void> _run(WidgetTester tester, double seconds, Duration frame) async {
  final frames = (seconds * 1e6 / frame.inMicroseconds).round();
  for (var i = 0; i < frames; i++) {
    await tester.pump(frame);
  }
}

void main() {
  testWidgets('moves at the same speed at 60 Hz and 120 Hz', (tester) async {
    Future<List<Offset>> after(Duration frame) async {
      final key = GlobalKey<IntroConstellationState>();
      await tester.pumpWidget(_host(key));
      await tester.pump(); // ticker's first tick
      await _run(tester, 1.0, frame);
      final positions = key.currentState!.particlePositions;
      await tester.pumpWidget(const SizedBox());
      return positions;
    }

    final at60 = await after(const Duration(microseconds: 16667));
    final at120 = await after(const Duration(microseconds: 8333));
    expect(at60.length, at120.length);
    for (var i = 0; i < at60.length; i++) {
      expect((at60[i] - at120[i]).distance, lessThan(0.5),
          reason: 'particle $i drifted with the refresh rate');
    }
  });

  testWidgets('pauses once the cover scrolls away, resumes on return',
      (tester) async {
    final key = GlobalKey<IntroConstellationState>();
    final page = ValueNotifier<int>(0);
    await tester.pumpWidget(_host(key, pageIndex: page));
    await tester.pump();
    expect(key.currentState!.isAnimating, isTrue);

    page.value = 2; // reader scrolled on to Selected Work
    await tester.pump();
    expect(key.currentState!.isAnimating, isFalse);
    final frozen = key.currentState!.particlePositions;
    await tester.pump(const Duration(seconds: 1));
    expect(key.currentState!.particlePositions, frozen);
    expect(tester.binding.hasScheduledFrame, isFalse,
        reason: 'no frames rendered for a hidden cover');

    page.value = 0;
    await tester.pump();
    expect(key.currentState!.isAnimating, isTrue);
  });

  testWidgets('keeps its particles when only the height changes',
      (tester) async {
    final key = GlobalKey<IntroConstellationState>();
    await tester.pumpWidget(_host(key));
    await tester.pump(const Duration(milliseconds: 100));
    final before = key.currentState!.particlePositions;

    // Mobile URL bar collapsing: same width, taller viewport.
    await tester.pumpWidget(MediaQuery(
      data: const MediaQueryData(size: Size(390, 900)),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: IntroConstellation(key: key, isDark: true),
      ),
    ));
    final after = key.currentState!.particlePositions;
    expect(after.length, before.length);
    for (var i = 0; i < before.length; i++) {
      expect(after[i].dx, before[i].dx, reason: 'not respawned');
    }
  });

  testWidgets('stays still with reduced motion', (tester) async {
    final key = GlobalKey<IntroConstellationState>();
    await tester.pumpWidget(_host(key, reduceMotion: true));
    await tester.pump();
    expect(key.currentState!.isAnimating, isFalse);
    expect(tester.binding.hasScheduledFrame, isFalse);
  });
}
