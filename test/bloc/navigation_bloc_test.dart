import 'package:flutter_test/flutter_test.dart';
import 'package:profile/core/bloc/navigation/navigation_bloc.dart';
import 'package:profile/core/bloc/navigation/navigation_event.dart';
import 'package:profile/core/bloc/navigation/navigation_state.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('NavigationBloc Test Suite', () {
    test('initial state defaults to page 0 with 7 pages and top button hidden', () async {
      final bloc = NavigationBloc();
      expect(bloc.state.pageIndex, equals(0));
      expect(bloc.state.pageCount, equals(7));
      expect(bloc.state.showScrollToTop, isFalse);
      expect(bloc.state.canGoBack, isFalse);
      expect(bloc.state.canGoForward, isTrue);
      await bloc.close();
    });

    test('NavigationPageSelected navigates to target clamped within bounds', () async {
      final bloc = NavigationBloc();

      bloc.add(const NavigationPageSelected(2));
      await expectLater(
        bloc.stream,
        emits(const NavigationState(pageIndex: 2, pageCount: 7, showScrollToTop: false)),
      );

      // Clamping upper bound
      bloc.add(const NavigationPageSelected(99));
      await expectLater(
        bloc.stream,
        emits(const NavigationState(pageIndex: 6, pageCount: 7, showScrollToTop: false)),
      );

      // Clamping lower bound
      bloc.add(const NavigationPageSelected(-5));
      await expectLater(
        bloc.stream,
        emits(const NavigationState(pageIndex: 0, pageCount: 7, showScrollToTop: false)),
      );

      await bloc.close();
    });

    test('NavigationNextPageRequested and NavigationPrevPageRequested step sequentially', () async {
      final bloc = NavigationBloc();

      bloc.add(const NavigationNextPageRequested());
      await expectLater(
        bloc.stream,
        emits(const NavigationState(pageIndex: 1, pageCount: 7)),
      );

      bloc.add(const NavigationNextPageRequested());
      await expectLater(
        bloc.stream,
        emits(const NavigationState(pageIndex: 2, pageCount: 7)),
      );

      bloc.add(const NavigationPrevPageRequested());
      await expectLater(
        bloc.stream,
        emits(const NavigationState(pageIndex: 1, pageCount: 7)),
      );

      await bloc.close();
    });

    test('NavigationUrlHashReceived correctly navigates to matched section index', () async {
      final bloc = NavigationBloc();

      // '#work/eskadenia' -> work is index 2
      bloc.add(const NavigationUrlHashReceived('#work/eskadenia'));
      await expectLater(
        bloc.stream,
        emits(const NavigationState(pageIndex: 2, pageCount: 7)),
      );

      // 'engineering' -> index 4
      bloc.add(const NavigationUrlHashReceived('engineering'));
      await expectLater(
        bloc.stream,
        emits(const NavigationState(pageIndex: 4, pageCount: 7)),
      );

      await bloc.close();
    });

    test('NavigationScrollToTopToggled updates showScrollToTop flag', () async {
      final bloc = NavigationBloc();

      bloc.add(const NavigationScrollToTopToggled(true));
      await expectLater(
        bloc.stream,
        emits(const NavigationState(pageIndex: 0, showScrollToTop: true, pageCount: 7)),
      );

      bloc.add(const NavigationScrollToTopToggled(false));
      await expectLater(
        bloc.stream,
        emits(const NavigationState(pageIndex: 0, showScrollToTop: false, pageCount: 7)),
      );

      await bloc.close();
    });
  });
}
