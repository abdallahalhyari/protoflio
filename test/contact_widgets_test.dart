import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:profile/l10n/app_localizations.dart';
import 'package:profile/features/contact/widget/contact_channels_grid.dart';
import 'package:profile/features/contact/widget/contact_header.dart';
import 'package:profile/features/contact/widget/contact_masthead_footer.dart';
import 'package:profile/features/contact/widget/cv_dossier_card.dart';
import 'package:profile/features/contact/widget/engagement_matrix_section.dart';
import 'package:profile/features/contact/widget/express_presets_bar.dart';
import 'package:profile/features/contact/widget/hero_email_card.dart';
import 'package:profile/features/contact/widget/inquiry_composer_dialog.dart';
import 'package:profile/shared/util/career_facts.dart';
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
    testWidgets('ContactHeader renders feature strip, headline, and lede',
        (tester) async {
      await tester.pumpWidget(_wrap(const ContactHeader()));
      await tester.pumpAndSettle();

      expect(find.text('FEATURE 07 · DIRECT LINE & REACH OUT'), findsOneWidget);
      expect(find.text("LET'S BUILD SOMETHING EXTRAORDINARY"), findsOneWidget);
      expect(
          find.textContaining(
              'Senior Mobile Engineer with ${CareerFacts.yearsOfExperience()}+ years'),
          findsOneWidget);
    });

    testWidgets('HeroEmailCard renders email and triggers action callbacks',
        (tester) async {
      bool sent = false;
      bool copied = false;
      await tester.pumpWidget(_wrap(
        HeroEmailCard(
          email: 'alhyariabdallh@gmail.com',
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

    testWidgets('ExpressPresetsBar renders chips and triggers preset',
        (tester) async {
      String? selectedSubject;
      await tester.pumpWidget(_wrap(
        ExpressPresetsBar(
          onSelectPreset: (subj, body) => selectedSubject = subj,
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text('ONE-TAP EXPRESS REACH-OUT PRESETS'), findsOneWidget);
      expect(find.text('Senior Role'), findsOneWidget);

      await tester.tap(find.text('Senior Role'));
      await tester.pumpAndSettle();

      expect(selectedSubject, contains('Senior Mobile Architect'));
    });

    testWidgets('CvDossierCard renders ATS badge and CV download triggers',
        (tester) async {
      await tester.pumpWidget(_wrap(const CvDossierCard()));
      await tester.pumpAndSettle();

      expect(find.text('ATS-VERIFIED · 2026 EDITION'), findsOneWidget);
      expect(find.text('Executive Curriculum Vitae & Portfolio Dossier'),
          findsOneWidget);
      expect(find.text('DOWNLOAD CV · PDF'), findsOneWidget);
      expect(find.text('PREVIEW'), findsOneWidget);
    });

    testWidgets('ContactChannelsGrid renders all 4 direct channels',
        (tester) async {
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

    testWidgets('EngagementMatrixSection renders tracks and invokes inquiry',
        (tester) async {
      String? inquiredSubject;
      await tester.pumpWidget(_wrap(
        EngagementMatrixSection(
          isDesktop: true,
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

    testWidgets('ContactMastheadFooter renders brand and handle links',
        (tester) async {
      bool linkedInOpened = false;
      bool githubOpened = false;
      await tester.pumpWidget(_wrap(
        ContactMastheadFooter(
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

    testWidgets(
        'HeroEmailCard renders compose button and triggers onComposeInquiry',
        (tester) async {
      bool composed = false;
      await tester.pumpWidget(_wrap(
        HeroEmailCard(
          email: 'alhyariabdallh@gmail.com',
          isDesktop: true,
          onSendEmail: () {},
          onCopyEmail: () {},
          onComposeInquiry: () => composed = true,
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text('COMPOSE INQUIRY'), findsOneWidget);
      await tester.tap(find.text('COMPOSE INQUIRY'));
      await tester.pumpAndSettle();
      expect(composed, isTrue);
    });

    testWidgets(
        'InquiryComposerDialog renders header, tracks, and switches templates',
        (tester) async {
      await tester
          .pumpWidget(_wrap(const InquiryComposerDialog(initialTrackIndex: 0)));
      await tester.pumpAndSettle();

      expect(find.text('DIRECT INQUIRY COMPOSER'), findsOneWidget);
      expect(find.text('Reach Abdallah Alhyari'), findsOneWidget);
      expect(find.textContaining('AMMAN (UTC+3)'), findsOneWidget);
      expect(find.text('Role Opportunity'), findsOneWidget);
      expect(find.text('Architecture Audit'), findsOneWidget);
      expect(find.text('Production App'), findsOneWidget);
      expect(find.text('Tech Advisory'), findsOneWidget);
      expect(find.text('COPY DRAFT'), findsOneWidget);
      expect(find.text('OPEN IN EMAIL CLIENT'), findsOneWidget);

      // Verify initial body contains Role Opportunity template
      expect(
          find.textContaining('Senior Mobile Architect / Flutter Engineering'),
          findsOneWidget);

      // Tap Architecture Audit track
      await tester.tap(find.text('Architecture Audit'));
      await tester.pumpAndSettle();

      expect(find.textContaining('expert architectural audit'), findsOneWidget);
    });

    testWidgets(
        'InquiryComposerDialog accepts name and company inputs and copies draft',
        (tester) async {
      tester.view.physicalSize = const Size(1200, 1000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      String? copiedMessage;
      await tester.pumpWidget(_wrap(
        InquiryComposerDialog(
          initialTrackIndex: 2,
          onCopy: (msg) => copiedMessage = msg,
        ),
      ));
      await tester.pumpAndSettle();

      // Enter name and company
      await tester.enterText(
          find.widgetWithText(TextField, 'Your Name (Optional)'),
          'Sarah Connor');
      await tester.enterText(
          find.widgetWithText(TextField, 'Company / Org (Optional)'),
          'Cyberdyne');
      await tester.pumpAndSettle();

      // Tap COPY DRAFT
      await tester.ensureVisible(find.text('COPY DRAFT'));
      await tester.tap(find.text('COPY DRAFT'));
      await tester.pumpAndSettle();

      expect(copiedMessage, isNotNull);
      expect(copiedMessage, contains('FROM: Sarah Connor (Cyberdyne)'));
      expect(copiedMessage, contains('high-performance cross-platform system'));
    });

    testWidgets('InquiryComposerDialog triggers onSend with subject and body',
        (tester) async {
      tester.view.physicalSize = const Size(1200, 1000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      String? sentSubject;
      String? sentBody;
      await tester.pumpWidget(_wrap(
        InquiryComposerDialog(
          initialTrackIndex: 1,
          onSend: (subj, body) {
            sentSubject = subj;
            sentBody = body;
          },
        ),
      ));
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.text('OPEN IN EMAIL CLIENT'));
      await tester.tap(find.text('OPEN IN EMAIL CLIENT'));
      await tester.pumpAndSettle();

      expect(sentSubject, contains('Architecture Review'));
      expect(sentBody, contains('expert architectural audit'));
    });

    testWidgets(
        'showInquiryComposerDialog opens modal and closes on close button',
        (tester) async {
      await tester.pumpWidget(_wrap(
        Builder(
          builder: (context) => ElevatedButton(
            onPressed: () =>
                showInquiryComposerDialog(context, initialTrackIndex: 1),
            child: const Text('OPEN COMPOSER'),
          ),
        ),
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.text('OPEN COMPOSER'));
      await tester.pumpAndSettle();

      expect(find.text('DIRECT INQUIRY COMPOSER'), findsOneWidget);
      expect(find.byTooltip('Close'), findsOneWidget);

      await tester.tap(find.byTooltip('Close'));
      await tester.pumpAndSettle();

      expect(find.text('DIRECT INQUIRY COMPOSER'), findsNothing);
    });
  });
}
