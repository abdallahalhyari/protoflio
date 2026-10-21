import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:profile/core/config/profile_links.dart';
import 'package:profile/core/theme/app_theme.dart';
import 'package:profile/features/about/presentation/pages/about_contact_page.dart';
import 'package:profile/features/about/presentation/widgets/credential_sheet.dart';
import 'package:profile/l10n/app_localizations.dart';

Widget _wrap(
  Widget child, [
  Size size = const Size(1200, 900),
  Locale? locale,
]) {
  return MaterialApp(
    theme: AppTheme.dark(),
    locale: locale,
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
    testWidgets('AboutContactPage lists every way to reach the holder',
        (tester) async {
      await tester.pumpWidget(_wrap(const AboutContactPage()));
      await tester.pumpAndSettle();

      expect(find.textContaining(ProfileLinks.email), findsWidgets);
      expect(find.textContaining(ProfileLinks.phoneDisplay), findsWidgets);
      expect(find.text('LinkedIn'), findsOneWidget);
      expect(find.text('WhatsApp'), findsOneWidget);
      expect(find.text('Phone'), findsOneWidget);
      expect(find.text('CV'), findsOneWidget);
      expect(find.text('Call'), findsOneWidget);
      expect(find.text('Download'), findsOneWidget);
      // Re-added on request after an earlier removal (3c00809), along with
      // the hiring summary and contact card that left the cover.
      expect(find.text('GitHub'), findsOneWidget);
      expect(find.text('Hiring summary'), findsOneWidget);
      expect(find.text('Contact card'), findsOneWidget);
    });

    testWidgets('channel rows open their links; the phone row has two',
        (tester) async {
      final opened = <String>[];
      var cv = 0;
      await tester.pumpWidget(_wrap(
        CredentialSheet(
          part: CredentialSheetPart.reach,
          isDesktop: true,
          onSendEmail: () {},
          onCopyEmail: () {},
          onOpenUrl: opened.add,
          onOpenCv: () => cv++,
        ),
      ));
      await tester.pumpAndSettle();

      // Single-action rows: tapping the label, not the action word, still
      // fires the row. The phone row's two words are separate buttons.
      for (final text in ['LinkedIn', 'WhatsApp', 'Call', 'CV']) {
        await tester.ensureVisible(find.text(text));
        await tester.tap(find.text(text));
        await tester.pump();
      }

      expect(opened, [
        ProfileLinks.linkedIn,
        ProfileLinks.whatsApp,
        'tel:${ProfileLinks.phoneRaw}',
      ]);
      expect(cv, 1);
    });

    testWidgets('GitHub, hiring summary and contact card rows work',
        (tester) async {
      final opened = <String>[];
      await tester.pumpWidget(_wrap(
        CredentialSheet(
          part: CredentialSheetPart.reach,
          isDesktop: true,
          onSendEmail: () {},
          onCopyEmail: () {},
          onOpenUrl: opened.add,
          onOpenCv: () {},
        ),
      ));
      await tester.pumpAndSettle();
      final l10n = lookupAppLocalizations(const Locale('en'));

      await tester.ensureVisible(find.text('GitHub'));
      await tester.tap(find.text('GitHub'));
      expect(opened, [ProfileLinks.github]);

      await tester.ensureVisible(find.text(l10n.quickProfileTitle));
      await tester.tap(find.text(l10n.quickProfileTitle));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('quick_profile')), findsOneWidget);
      Navigator.of(tester.element(find.byKey(const Key('quick_profile'))))
          .pop();
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.text(l10n.contactVcard));
      await tester.tap(find.text(l10n.contactVcard));
      await tester.pumpAndSettle();
      expect(find.text(l10n.vcardDialogTitle), findsOneWidget);
    });

    testWidgets('AboutContactPage stays readable on compact Arabic RTL',
        (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AboutContactPage(),
          const Size(390, 844),
          const Locale('ar'),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        Directionality.of(tester.element(find.byType(AboutContactPage))),
        TextDirection.rtl,
      );
      expect(find.textContaining(ProfileLinks.email), findsWidgets);
      // Labels are localized; the holder's name comes from the Arabic ARB.
      expect(find.text('واتساب'), findsOneWidget);
      expect(find.text('الحياري'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
