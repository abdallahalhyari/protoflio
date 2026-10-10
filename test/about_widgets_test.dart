import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:profile/l10n/app_localizations.dart';
import 'package:profile/core/theme/app_theme.dart';
import 'package:profile/features/about/presentation/pages/about_page.dart';
import 'package:profile/features/about/presentation/widgets/profile_tab.dart';

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
  group('About & ProfileTab Redesign Test Suite', () {
    testWidgets(
        'ProfileTab renders executive hero, impact stats, and credentials',
        (tester) async {
      await tester.pumpWidget(_wrap(const ProfileTab(isDesktop: true)));
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
      expect(find.text('EXECUTIVE CREDENTIAL DOSSIER'), findsOneWidget);
      expect(find.text('ENGINEERING PHILOSOPHY & ETHOS'), findsOneWidget);
    });

    testWidgets(
        'ProfileTab renders under-the-hood capabilities with company provenance',
        (tester) async {
      await tester.pumpWidget(_wrap(const ProfileTab(isDesktop: true)));
      await tester.pumpAndSettle();

      expect(find.text('UNDER THE HOOD CAPABILITIES'), findsOneWidget);
      expect(find.text('NFC'), findsOneWidget);
      expect(find.text('Cryptography'), findsOneWidget);
      expect(find.text('Offline-first'), findsOneWidget);
      expect(find.text('Native integration'), findsOneWidget);
      expect(find.text('NatHealth'), findsWidgets);
      expect(find.text('ESKADENIA Software'), findsWidgets);
    });

    testWidgets(
        'ProfileTab renders technical arsenal matrix and playground banner',
        (tester) async {
      await tester.pumpWidget(_wrap(const ProfileTab(isDesktop: true)));
      await tester.pumpAndSettle();

      expect(find.text('TECHNICAL ARSENAL & TOOLCHAIN MATRIX'), findsOneWidget);
      expect(find.text('MOBILE & PLATFORMS'), findsOneWidget);
      expect(find.text('ARCHITECTURE & STATE'), findsOneWidget);
      expect(find.text('HARDWARE & SECURITY'), findsOneWidget);
      expect(find.text('LIVE ENGINEERING PLAYGROUND'), findsOneWidget);
      expect(find.text('Open Playground'), findsOneWidget);
    });

    testWidgets('AboutPage renders executive profile details and direct email',
        (tester) async {
      await tester.pumpWidget(_wrap(const AboutPage()));
      await tester.pumpAndSettle();

      expect(find.text('About'), findsOneWidget);
      expect(find.text('Abdallah Alhyari'), findsOneWidget);
      expect(find.text('alhyariabdallh@gmail.com'), findsOneWidget);
    });
  });
}
