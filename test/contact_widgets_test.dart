import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:profile/l10n/app_localizations.dart';
import 'package:profile/features/contact/presentation/widgets/contact_header.dart';
import 'package:profile/features/about/presentation/pages/about_contact_page.dart';
import 'package:profile/core/theme/app_theme.dart';

Widget _wrap(Widget child, [Size size = const Size(1200, 900)]) {
  return MaterialApp(
    theme: AppTheme.dark(),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: MediaQuery(
      data: MediaQueryData(size: size),
      child: Scaffold(body: SingleChildScrollView(child: child)),
    ),
  );
}

void main() {
  group('Contact Widgets Test Suite', () {
    testWidgets('ContactHeader renders feature strip, headline, and lede',
        (tester) async {
      await tester.pumpWidget(_wrap(const ContactHeader()));
      await tester.pumpAndSettle();

      expect(find.text('Contact'), findsOneWidget);
      expect(find.text("Have a difficult mobile problem?"), findsOneWidget);
      expect(
        find.textContaining('I am looking for a senior mobile role'),
        findsOneWidget,
      );
    });

    testWidgets('AboutContactPage renders direct contact details and channels',
        (tester) async {
      await tester.pumpWidget(_wrap(const AboutContactPage()));
      await tester.pumpAndSettle();

      expect(find.text('alhyariabdallh@gmail.com'), findsWidgets);
      expect(find.text('+962-787032264'), findsWidgets);
      expect(find.text('WhatsApp'), findsWidgets);
      expect(find.text('LinkedIn'), findsWidgets);
      expect(find.text('GitHub'), findsWidgets);
    });
  });
}
