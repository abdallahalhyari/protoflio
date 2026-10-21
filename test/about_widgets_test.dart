import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:profile/core/config/profile_links.dart';
import 'package:profile/core/theme/app_theme.dart';
import 'package:profile/features/about/presentation/about_navigation.dart';
import 'package:profile/features/about/presentation/pages/about_contact_page.dart';
import 'package:profile/features/about/presentation/pages/about_page.dart';
import 'package:profile/features/about/presentation/widgets/credential_sheet.dart';
import 'package:profile/l10n/app_localizations.dart';

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
  group('About & contact credential sheet', () {
    testWidgets('desktop shows reach and holder halves on one sheet',
        (tester) async {
      await tester.pumpWidget(_wrap(const AboutContactPage()));
      await tester.pumpAndSettle();

      // Reach.
      expect(find.text('Have a difficult mobile problem?'), findsOneWidget);
      expect(find.textContaining(ProfileLinks.email), findsWidgets);
      expect(find.text('Send email'), findsOneWidget);
      expect(find.text('Replies within 24 hours, in English or Arabic'),
          findsOneWidget);

      // Holder, as credential fields.
      expect(find.text('Surname'), findsOneWidget);
      expect(find.text('Alhyari'), findsOneWidget);
      expect(find.text('Given name'), findsOneWidget);
      expect(find.text('Abdallah'), findsOneWidget);
      // The real work-permit fact, with its condition.
      expect(find.text('Not needed in Czechia while studying full-time'),
          findsOneWidget);
    });

    testWidgets('drops the old executive chrome and invented stats',
        (tester) async {
      await tester.pumpWidget(_wrap(const AboutContactPage()));
      await tester.pumpAndSettle();

      for (final gone in [
        'STAFF / LEAD',
        'DIRECT EXECUTIVE EMAIL',
        'Offline SLA',
        'Active Users',
        'Production Apps',
      ]) {
        expect(find.text(gone), findsNothing, reason: gone);
      }
    });

    testWidgets('the machine-readable zone is real TD1 and silent',
        (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(_wrap(const AboutContactPage()));
      await tester.pumpAndSettle();

      final mrz = find.textContaining('I<JORMOBILEENG');
      expect(mrz, findsOneWidget);
      final lines = (tester.widget<Text>(mrz).data!).split('\n');
      expect(lines, hasLength(3));
      for (final line in lines) {
        expect(line.length, 30);
      }
      // Pure texture: the facts it encodes are stated in words above.
      expect(find.bySemanticsLabel(RegExp('MOBILEENG')), findsNothing);
      handle.dispose();
    });

    testWidgets('AboutPage wrapper renders the holder and the email',
        (tester) async {
      await tester.pumpWidget(_wrap(const AboutPage()));
      await tester.pumpAndSettle();

      expect(find.text('Alhyari'), findsOneWidget);
      expect(find.textContaining(ProfileLinks.email), findsWidgets);
    });

    testWidgets('phone sections each get their own half, not the sheet twice',
        (tester) async {
      await tester.pumpWidget(_wrap(
        const AboutContactPage(
          isContinuousMobile: true,
          initialTab: AboutTabs.profile,
        ),
        const Size(390, 844),
      ));
      await tester.pumpAndSettle();
      expect(find.text('Alhyari'), findsOneWidget);
      expect(find.text('Have a difficult mobile problem?'), findsNothing);
      expect(
        tester.widget<CredentialSheet>(find.byType(CredentialSheet)).part,
        CredentialSheetPart.holder,
      );

      await tester.pumpWidget(_wrap(
        const AboutContactPage(
          isContinuousMobile: true,
          initialTab: AboutTabs.contact,
        ),
        const Size(390, 844),
      ));
      await tester.pumpAndSettle();
      expect(find.text('Have a difficult mobile problem?'), findsOneWidget);
      expect(find.text('Alhyari'), findsNothing);
    });
  });
}
