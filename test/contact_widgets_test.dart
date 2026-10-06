import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:profile/l10n/app_localizations.dart';
import 'package:profile/features/contact/presentation/widgets/contact_channels_grid.dart';
import 'package:profile/features/contact/presentation/widgets/contact_header.dart';
import 'package:profile/features/contact/presentation/widgets/contact_masthead_footer.dart';
import 'package:profile/features/contact/presentation/widgets/cv_dossier_card.dart';
import 'package:profile/features/contact/presentation/widgets/engagement_matrix_section.dart';
import 'package:profile/features/contact/presentation/widgets/express_presets_bar.dart';
import 'package:profile/features/contact/presentation/widgets/hero_email_card.dart';
import 'package:profile/features/contact/presentation/widgets/inquiry_composer_dialog.dart';
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
      expect(find.text("Tell me what you're building."), findsOneWidget);
      expect(
        find.textContaining("I'm looking for a senior mobile role"),
        findsOneWidget,
      );
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
      expect(find.text('Send email'), findsOneWidget);
      expect(find.text('Copy address'), findsOneWidget);

      await tester.tap(find.text('Send email'));
      await tester.pumpAndSettle();
      expect(sent, isTrue);

      await tester.tap(find.text('Copy address'));
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

      expect(find.text('Start from a template'), findsOneWidget);
      expect(find.text('Senior Role'), findsOneWidget);

      await tester.tap(find.text('Senior Role'));
      await tester.pumpAndSettle();

      expect(selectedSubject, contains('Senior Mobile Engineer'));
    });

    testWidgets('CvDossierCard renders ATS badge and CV download triggers',
        (tester) async {
      await tester.pumpWidget(_wrap(const CvDossierCard()));
      await tester.pumpAndSettle();

      expect(find.text('ATS-friendly, 2026 edition'), findsOneWidget);
      expect(find.text('Executive Curriculum Vitae & Portfolio Dossier'),
          findsOneWidget);
      expect(find.text('Download CV (PDF)'), findsOneWidget);
      expect(find.text('Preview'), findsOneWidget);
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

      expect(find.text('Direct communication channels'), findsOneWidget);
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

      await tester.tap(find.text('Ask about this').first);
      await tester.pumpAndSettle();

      expect(inquiredSubject, contains('Mobile System Audit'));
    });

    testWidgets('ContactMastheadFooter renders the colophon only',
        (tester) async {
      await tester.pumpWidget(_wrap(const ContactMastheadFooter()));
      await tester.pumpAndSettle();

      expect(find.text('Colophon & dispatch'), findsOneWidget);
      expect(find.text('Primary location'), findsOneWidget);
      // Profile links live on the channel cards, not repeated here.
      expect(find.textContaining('LINKEDIN ·'), findsNothing);
      expect(find.textContaining('GITHUB ·'), findsNothing);
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

      expect(find.text('Write a message'), findsOneWidget);
      await tester.tap(find.text('Write a message'));
      await tester.pumpAndSettle();
      expect(composed, isTrue);
    });

    testWidgets(
        'InquiryComposerDialog renders header, tracks, and switches templates',
        (tester) async {
      await tester.pumpWidget(_wrap(const InquiryComposerDialog()));
      await tester.pumpAndSettle();

      expect(find.text('Write a message'), findsOneWidget);
      expect(find.text('Reach Abdallah Alhyari'), findsOneWidget);
      expect(find.textContaining('AMMAN (UTC+3)'), findsOneWidget);
      expect(find.text('Role Opportunity'), findsOneWidget);
      expect(find.text('Architecture Audit'), findsOneWidget);
      expect(find.text('Production App'), findsOneWidget);
      expect(find.text('Tech Advisory'), findsOneWidget);
      expect(find.text('Copy draft'), findsOneWidget);
      expect(find.text('Open in email app'), findsOneWidget);

      // Verify initial body contains Role Opportunity template
      expect(find.textContaining('Senior Mobile Engineer (Flutter)'),
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
      await tester.ensureVisible(find.text('Copy draft'));
      await tester.tap(find.text('Copy draft'));
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

      await tester.ensureVisible(find.text('Open in email app'));
      await tester.tap(find.text('Open in email app'));
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

      expect(find.text('Write a message'), findsOneWidget);
      expect(find.byTooltip('Close'), findsOneWidget);

      await tester.tap(find.byTooltip('Close'));
      await tester.pumpAndSettle();

      expect(find.text('Write a message'), findsNothing);
    });
  });

  testWidgets(
      'InquiryComposerDialog disables sending until the message has text',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(1200, 1000));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(_wrap(const InquiryComposerDialog()));
    await tester.pumpAndSettle();

    FilledButton sendButton() => tester.widget<FilledButton>(find.ancestor(
        of: find.text('Open in email app'),
        matching: find.byWidgetPredicate((w) => w is FilledButton)));

    // The template pre-fills the body, so sending starts enabled.
    expect(sendButton().onPressed, isNotNull);

    await tester.enterText(
        find.widgetWithText(TextField, 'Message Body'), '   ');
    await tester.pump();
    expect(sendButton().onPressed, isNull);
    expect(find.text('Write a message to enable sending'), findsOneWidget);
  });
}
