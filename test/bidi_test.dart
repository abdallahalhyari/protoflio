import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:profile/shared/utils/bidi.dart';

void main() {
  Future<String> render(
      WidgetTester tester, TextDirection dir, String s) async {
    late String out;
    await tester.pumpWidget(Directionality(
      textDirection: dir,
      child: Builder(builder: (context) {
        out = ltrContent(context, s);
        return const SizedBox();
      }),
    ));
    return out;
  }

  testWidgets('isolates English content only inside RTL layouts',
      (tester) async {
    expect(await render(tester, TextDirection.rtl, 'Built apps.'),
        '${kLri}Built apps.$kPdi');
    expect(await render(tester, TextDirection.rtl, '  "Quoted" text.'),
        '$kLri  "Quoted" text.$kPdi');
    expect(await render(tester, TextDirection.rtl, 'مرحبا'), 'مرحبا');
    expect(
        await render(tester, TextDirection.ltr, 'Built apps.'), 'Built apps.');
  });

  testWidgets('ltrAlways isolates numbers and URLs only under RTL',
      (tester) async {
    late String rtl, ltr;
    await tester.pumpWidget(Directionality(
      textDirection: TextDirection.rtl,
      child: Builder(builder: (context) {
        rtl = ltrAlways(context, '+962-787032264');
        return const SizedBox();
      }),
    ));
    await tester.pumpWidget(Directionality(
      textDirection: TextDirection.ltr,
      child: Builder(builder: (context) {
        ltr = ltrAlways(context, '+962-787032264');
        return const SizedBox();
      }),
    ));
    expect(rtl, '$kLri+962-787032264$kPdi');
    expect(ltr, '+962-787032264');
  });
}
