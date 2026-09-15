import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:profile/l10n/app_localizations.dart';
import 'package:profile/module/home/widget/contact/contact_channels_grid.dart';
import 'package:profile/module/home/widget/contact/contact_header.dart';
import 'package:profile/module/home/widget/contact/contact_masthead_footer.dart';
import 'package:profile/module/home/widget/contact/cv_dossier_card.dart';
import 'package:profile/module/home/widget/contact/engagement_matrix_section.dart';
import 'package:profile/module/home/widget/contact/express_presets_bar.dart';
import 'package:profile/module/home/widget/contact/hero_email_card.dart';
import 'package:profile/theme/app_theme.dart';

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
    testWidgets('ContactHeader renders feature strip, headline, and lede', (tester) async {
      await tester.pumpWidget(_wrap(const ContactHeader(isDark: true)));
      await tester.pumpAndSettle();

      expect(find.text('FEATURE 07 · DIRECT LINE & REACH OUT'), findsOneWidget);
      expect(find.text("LET'S BUILD SOMETHING EXTRAORDINARY"), findsOneWidget);
      expect(find.textContaining('Principal & Senior Mobile Software Architect'), findsOneWidget);
    });

    testWidgets('HeroEmailCard renders email and triggers action callbacks', (tester) async {
      bool sent = false;
      bool copied = false;
      await tester.pumpWidget(_wrap(
        HeroEmailCard(
          email: 'alhyariabdallh@gmail.com',
          isDark: true,
          isDesktop: true,
          onSendEmail: () => sent = true,
          onCopyEmail: () => copied = true,
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text('alhyariabdallh@gmail.com'), findsOneWidget);
      expect(find.text('SEND EMAIL'), findsOneWidget);
      expect(find.text('COPY ADDRESS'), findsOneWidget);

      await tester.tap(find.text('SEND EMAIL'));
      await tester.pumpAndSettle();
      expect(sent, isTrue);

      await tester.tap(find.text('COPY ADDRESS'));
      await tester.pumpAndSettle();
      expect(copied, isTrue);
    });

    testWidgets('ExpressPresetsBar renders chips and triggers preset', (tester) async {
      String? selectedSubject;
      await tester.pumpWidget(_wrap(
        ExpressPresetsBar(
          isDark: true,
          onSelectPreset: (subj, body) => selectedSubject = subj,
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text('ONE-TAP EXPRESS REACH-OUT PRESETS'), findsOneWidget);
      expect(find.text('💼 Senior Role'), findsOneWidget);

      await tester.tap(find.text('💼 Senior Role'));
      await tester.pumpAndSettle();

      expect(selectedSubject, contains('Senior Mobile Architect'));
    });

    testWidgets('CvDossierCard renders ATS badge and CV download triggers', (tester) async {
      await tester.pumpWidget(_wrap(const CvDossierCard(isDark: true)));
      await tester.pumpAndSettle();

      expect(find.text('ATS-VERIFIED · 2026 EDITION'), findsOneWidget);
      expect(find.text('Executive Curriculum Vitae & Portfolio Dossier'), findsOneWidget);
      expect(find.text('DOWNLOAD CV · PDF'), findsOneWidget);
      expect(find.text('PREVIEW'), findsOneWidget);
    });

    testWidgets('ContactChannelsGrid renders all 4 direct channels', (tester) async {
      await tester.pumpWidget(_wrap(
        ContactChannelsGrid(
          phone: '+962-787032264',
          phoneRaw: '+962787032264',
          whatsAppUrl: 'https://wa.me/962787032264',
          linkedInHandle: 'abdallah-alhyari',
          linkedInUrl: 'https://linkedin.com/in/abdallah-alhyari',
          githubHandle: 'abdallahalhyari',
          githubUrl: 'https://github.com/abdallahalhyari',
          isDesktop: true,
          isDark: true,
          onOpenUrl: (_) {},
          onCopy: (_) {},
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text('// DIRECT COMMUNICATION CHANNELS'), findsOneWidget);
      expect(find.text('+962-787032264'), findsOneWidget);
      expect(find.text('wa.me/962787032264'), findsOneWidget);
      expect(find.text('in/abdallah-alhyari'), findsOneWidget);
      expect(find.text('@abdallahalhyari'), findsOneWidget);
    });

    testWidgets('EngagementMatrixSection renders tracks and invokes inquiry', (tester) async {
      String? inquiredSubject;
      await tester.pumpWidget(_wrap(
        EngagementMatrixSection(
          isDesktop: true,
          isDark: true,
          onInquire: (subj, body) => inquiredSubject = subj,
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Architecture & Resilience Audit'), findsOneWidget);
      expect(find.text('Full-Lifecycle App Engineering'), findsOneWidget);
      expect(find.text('Fractional Lead & Mentorship'), findsOneWidget);

      await tester.tap(find.text('INQUIRE TRACK').first);
      await tester.pumpAndSettle();

      expect(inquiredSubject, contains('Mobile System Audit'));
    });

    testWidgets('ContactMastheadFooter renders brand and handle links', (tester) async {
      bool linkedInOpened = false;
      bool githubOpened = false;
      await tester.pumpWidget(_wrap(
        ContactMastheadFooter(
          isDark: true,
          linkedInHandle: 'abdallah-alhyari',
          githubHandle: 'abdallahalhyari',
          onOpenLinkedIn: () => linkedInOpened = true,
          onOpenGithub: () => githubOpened = true,
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text('LINKEDIN · abdallah-alhyari'), findsOneWidget);
      expect(find.text('GITHUB · abdallahalhyari'), findsOneWidget);
      expect(find.text('// COLOPHON & DISPATCH'), findsOneWidget);
      expect(find.text('PRIMARY LOCATION'), findsOneWidget);

      await tester.tap(find.text('LINKEDIN · abdallah-alhyari'));
      await tester.pumpAndSettle();
      expect(linkedInOpened, isTrue);

      await tester.tap(find.text('GITHUB · abdallahalhyari'));
      await tester.pumpAndSettle();
      expect(githubOpened, isTrue);
    });
  });
}
