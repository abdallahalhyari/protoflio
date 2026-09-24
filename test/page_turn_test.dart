import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:profile/core/bloc/locale/locale_bloc.dart';
import 'package:profile/core/bloc/theme/theme_bloc.dart';
import 'package:profile/features/hats/page/hats_grid_page.dart';
import 'package:profile/features/projects/page/projects_page.dart';
import 'package:profile/features/shell/home_controller.dart';
import 'package:profile/features/shell/home_screen.dart';
import 'package:profile/features/shell/widget/folio_bar.dart';
import 'package:profile/features/shell/widget/magazine_page_transformer.dart';
import 'package:profile/l10n/app_localizations.dart';

Widget _wrapHome() {
  return MultiBlocProvider(
    providers: [
      BlocProvider<ThemeBloc>(create: (_) => ThemeBloc()),
      BlocProvider<LocaleBloc>(create: (_) => LocaleBloc()),
    ],
    child: const MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: HomeScreen(),
    ),
  );
}

int? _folioIndex(WidgetTester tester) {
  for (final w in tester.widgetList<Text>(find.byType(Text))) {
    final m = RegExp(r'^FOLIO (\d+) / \d+$').firstMatch(w.data ?? '');
    if (m != null) return int.parse(m.group(1)!);
  }
  return null;
}

Future<void> _pumpDesktopHome(WidgetTester tester) async {
  tester.view.devicePixelRatio = 1.0;
  tester.view.physicalSize = const Size(1400, 900);
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.view.resetPhysicalSize);
  await tester.pumpWidget(_wrapHome());
  for (int i = 0; i < 6; i++) {
    await tester.pump(const Duration(milliseconds: 200));
  }
}

class _MountCounter extends StatefulWidget {
  const _MountCounter({required this.onMount});

  final VoidCallback onMount;

  @override
  State<_MountCounter> createState() => _MountCounterState();
}

class _MountCounterState extends State<_MountCounter> {
  @override
  void initState() {
    super.initState();
    widget.onMount();
  }

  @override
  Widget build(BuildContext context) => const Text('Page 0');
}

void main() {
  testWidgets('MagazinePageTransformer keeps page state through a turn',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(1200, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final controller = PageController();
    addTearDown(controller.dispose);
    var mounts = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: PageView.builder(
          controller: controller,
          allowImplicitScrolling: true,
          scrollDirection: Axis.vertical,
          itemCount: 3,
          itemBuilder: (context, index) => MagazinePageTransformer(
            controller: controller,
            index: index,
            child: index == 0
                ? _MountCounter(onMount: () => mounts++)
                : Text('Page $index'),
          ),
        ),
      ),
    );
    expect(mounts, 1);

    controller.animateToPage(1,
        duration: const Duration(milliseconds: 300), curve: Curves.linear);
    await tester.pumpAndSettle();
    controller.animateToPage(0,
        duration: const Duration(milliseconds: 300), curve: Curves.linear);
    await tester.pumpAndSettle();

    // Switching rest ↔ turning ↔ offstage phases must not remount the page.
    expect(mounts, 1);
  });

  testWidgets('multi-page jump never highlights intermediate sections',
      (tester) async {
    await _pumpDesktopHome(tester);
    expect(_folioIndex(tester), 1);

    final pageIndex =
        HomeController.of(tester.element(find.byType(FolioBar))).pageIndex;
    final published = <int>[];
    void record() => published.add(pageIndex.value);
    pageIndex.addListener(record);
    addTearDown(() => pageIndex.removeListener(record));

    await tester.sendKeyEvent(LogicalKeyboardKey.digit5);
    for (int i = 0; i < 40; i++) {
      await tester.pump(const Duration(milliseconds: 16));
    }
    // Zero-based index 4 == Skills; nothing in between may be published.
    expect(published, [4]);
  });

  testWidgets('rapid arrow presses each advance one section', (tester) async {
    await _pumpDesktopHome(tester);

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.pump(const Duration(milliseconds: 60));
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    for (int i = 0; i < 8; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    expect(_folioIndex(tester), 3);
  });

  testWidgets('keyboard focus follows the visible page, not pre-built ones',
      (tester) async {
    await _pumpDesktopHome(tester);

    bool focusInside<T extends Widget>() {
      final ctx = FocusManager.instance.primaryFocus?.context;
      return ctx != null &&
          (ctx.widget is T || ctx.findAncestorWidgetOfExactType<T>() != null);
    }

    Future<void> goTo(LogicalKeyboardKey key) async {
      await tester.sendKeyEvent(key);
      for (int i = 0; i < 8; i++) {
        await tester.pump(const Duration(milliseconds: 200));
      }
    }

    // Experience — Projects is pre-built next door but must not own focus.
    await goTo(LogicalKeyboardKey.digit2);
    expect(focusInside<ProjectsPage>(), isFalse);

    await goTo(LogicalKeyboardKey.digit3);
    expect(focusInside<ProjectsPage>(), isTrue);

    // Engineering — the hat deck is pre-built next door.
    await goTo(LogicalKeyboardKey.digit5);
    expect(focusInside<ProjectsPage>(), isFalse);
    expect(focusInside<HatsGridPage>(), isFalse);

    await goTo(LogicalKeyboardKey.digit6);
    expect(focusInside<HatsGridPage>(), isTrue);

    // Leaving the page must hand arrows back to section navigation.
    await goTo(LogicalKeyboardKey.arrowDown);
    expect(_folioIndex(tester), 7);
  });
}
