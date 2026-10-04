import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:profile/features/shell/presentation/widgets/desktop_keyboard_nav.dart';

/// The section shortcuts (1–7, Space, arrows, Home / End, "/") listen on
/// the whole page. Typing "5" in the skills search used to jump to a
/// section and Space paged down mid-word.
void main() {
  late List<String> calls;

  Widget app({required FocusNode pageFocus}) => MaterialApp(
        home: Scaffold(
          body: DesktopKeyboardNav(
            focusNode: pageFocus,
            pageCount: 7,
            onNext: () => calls.add('next'),
            onPrev: () => calls.add('prev'),
            onGoTo: (i) => calls.add('goTo $i'),
            onShowHelp: () => calls.add('help'),
            child:
                const Center(child: SizedBox(width: 300, child: TextField())),
          ),
        ),
      );

  setUp(() => calls = []);

  testWidgets('shortcuts work when no field has focus', (tester) async {
    final focus = FocusNode();
    addTearDown(focus.dispose);
    await tester.pumpWidget(app(pageFocus: focus));
    focus.requestFocus();
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.digit5);
    await tester.sendKeyEvent(LogicalKeyboardKey.space);
    expect(calls, ['goTo 4', 'next']);
  });

  testWidgets('typing in a text field does not trigger them', (tester) async {
    final focus = FocusNode();
    addTearDown(focus.dispose);
    await tester.pumpWidget(app(pageFocus: focus));
    await tester.tap(find.byType(TextField));
    await tester.pump();
    for (final key in [
      LogicalKeyboardKey.digit5,
      LogicalKeyboardKey.space,
      LogicalKeyboardKey.slash,
      LogicalKeyboardKey.home,
      LogicalKeyboardKey.end,
    ]) {
      await tester.sendKeyEvent(key);
    }
    await tester.enterText(find.byType(TextField), '5G 2');
    expect(calls, isEmpty);
  });

  testWidgets('modified keys stay with the browser', (tester) async {
    final focus = FocusNode();
    addTearDown(focus.dispose);
    await tester.pumpWidget(app(pageFocus: focus));
    focus.requestFocus();
    await tester.pump();
    await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
    await tester.sendKeyEvent(LogicalKeyboardKey.digit1);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
    expect(calls, isEmpty);
  });
}
