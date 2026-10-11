import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:profile/l10n/app_localizations.dart';
import 'package:profile/core/theme/app_theme.dart';
import 'package:profile/features/about/presentation/pages/about_contact_page.dart';
import 'package:profile/features/about/presentation/pages/about_page.dart';

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
  group('About & Executive Contact Page Test Suite', () {
    testWidgets(
        'AboutContactPage renders executive hero, impact stats, and credentials',
        (tester) async {
      await tester.pumpWidget(_wrap(const AboutContactPage()));
      await tester.pumpAndSettle();

      expect(find.text('Abdallah Alhyari'), findsOneWidget);
      expect(find.text('STAFF / LEAD'), findsOneWidget);
      expect(
          find.text(
              'Senior Mobile Systems Engineer · Mobile Solutions Architect'),
          findsOneWidget);
      expect(find.text('Years Experience'), findsOneWidget);
      expect(find.text('Production Apps'), findsOneWidget);
      expect(find.text('Active Users'), findsOneWidget);
      expect(find.text('Offline SLA'), findsOneWidget);
      expect(find.text('alhyariabdallh@gmail.com'), findsWidgets);
    });

    testWidgets('AboutPage wrapper renders executive details and email',
        (tester) async {
      await tester.pumpWidget(_wrap(const AboutPage()));
      await tester.pumpAndSettle();

      expect(find.text('Abdallah Alhyari'), findsOneWidget);
      expect(find.text('alhyariabdallh@gmail.com'), findsWidgets);
    });
  });
}
