import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:profile/features/contact/presentation/widgets/vcard_qr_dialog.dart';
import 'package:profile/features/intro/presentation/widgets/quick_profile_sheet.dart';
import 'package:profile/l10n/app_localizations.dart';
import 'package:profile/shared/utils/career_facts.dart';
import 'package:profile/core/theme/app_theme.dart';

/// Opens the hiring summary and the vCard dialog directly: the cover no
/// longer carries buttons for them, but both still exist.
Widget _hero(Locale locale, {VoidCallback? onCv}) => MaterialApp(
      theme: AppTheme.dark(),
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Builder(
        builder: (context) {
          final l10n = AppLocalizations.of(context)!;
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton(
                    onPressed: () => showQuickProfile(context,
                        onDownloadResume: onCv ?? () {}),
                    child: Text(l10n.quickProfile),
                  ),
                  TextButton(
                    onPressed: () => VCardQrDialog.show(context),
                    child: Text(l10n.quickProfileVcard),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );

void _size(WidgetTester tester, Size size, [double textScale = 1]) {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  tester.platformDispatcher.textScaleFactorTestValue = textScale;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
}

void main() {
  testWidgets('hiring summary shows the hiring facts', (tester) async {
    _size(tester, const Size(1440, 900));
    var cvOpened = false;
    await tester.pumpWidget(_hero(const Locale('en'), onCv: () {
      cvOpened = true;
    }));
    await tester.tap(
        find.text(lookupAppLocalizations(const Locale('en')).quickProfile));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('quick_profile')), findsOneWidget);
    expect(find.byType(Dialog), findsOneWidget, reason: 'dialog on desktop');
    expect(find.text('Senior Flutter & Android engineer'), findsWidgets);
    expect(
        find.text(
            '${CareerFacts.yearsOfExperience()}+ years in mobile engineering'),
        findsOneWidget);
    expect(find.textContaining('NatHealth', findRichText: true), findsWidgets);

    await tester.tap(find.byKey(const Key('quick_profile_cv')));
    expect(cvOpened, isTrue);
  });

  testWidgets('vCard dialog opens with its scan hint', (tester) async {
    _size(tester, const Size(1440, 900));
    await tester.pumpWidget(_hero(const Locale('en')));
    await tester.tap(find
        .text(lookupAppLocalizations(const Locale('en')).quickProfileVcard));
    await tester.pumpAndSettle();

    final l10n = lookupAppLocalizations(const Locale('en'));
    expect(find.text(l10n.vcardDialogTitle), findsOneWidget);
    expect(find.text(l10n.vcardScanHint), findsOneWidget);
  });

  for (final locale in const [Locale('ar'), Locale('cs')]) {
    testWidgets('vCard dialog is localized in ${locale.languageCode}',
        (tester) async {
      _size(tester, const Size(390, 844));
      final l10n = lookupAppLocalizations(locale);
      await tester.pumpWidget(_hero(locale));
      await tester.tap(find.text(l10n.quickProfileVcard));
      await tester.pumpAndSettle();

      expect(find.text(l10n.vcardDialogTitle), findsOneWidget);
      expect(find.text(l10n.vcardScanHint), findsOneWidget);
      expect(find.text(l10n.vcardCopyText), findsOneWidget);
      expect(find.text(l10n.done), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('bottom sheet on phones', (tester) async {
    _size(tester, const Size(390, 844));
    await tester.pumpWidget(_hero(const Locale('en')));
    await tester.tap(
        find.text(lookupAppLocalizations(const Locale('en')).quickProfile));
    await tester.pumpAndSettle();
    expect(find.byType(BottomSheet), findsOneWidget);
    expect(find.byKey(const Key('quick_profile')), findsOneWidget);
  });

  testWidgets('copy summary puts a plain-text profile on the clipboard',
      (tester) async {
    _size(tester, const Size(1440, 900));
    String? copied;
    tester.binding.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, (call) async {
      if (call.method == 'Clipboard.setData') {
        copied = (call.arguments as Map)['text'] as String;
      }
      return null;
    });
    addTearDown(() => tester.binding.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, null));

    await tester.pumpWidget(_hero(const Locale('en')));
    await tester.tap(
        find.text(lookupAppLocalizations(const Locale('en')).quickProfile));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('quick_profile_copy')));
    await tester.pumpAndSettle();

    expect(copied, isNotNull);
    expect(copied, startsWith('Abdallah Alhyari\n'));
    expect(copied, contains('${CareerFacts.yearsOfExperience()}+ years'));
    expect(copied, contains('Senior mobile engineer, NatHealth'));
    expect(copied, contains('alhyariabdallh@gmail.com'));
    expect(copied,
        contains('https://www.linkedin.com/in/abdallah-alhyari-0294791a0/'));
    expect(copied, isNot(contains('*')), reason: 'plain text, no markup');
  });

  for (final locale in const [Locale('cs'), Locale('ar')]) {
    testWidgets('lays out cleanly: ${locale.languageCode}, 320px, 2x text',
        (tester) async {
      _size(tester, const Size(320, 640), 2.0);
      final errors = <String>[];
      final previous = FlutterError.onError;
      FlutterError.onError = (d) => errors.add(d.exceptionAsString());
      addTearDown(() => FlutterError.onError = previous);

      await tester.pumpWidget(MaterialApp(
        theme: AppTheme.dark(),
        locale: locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: TextButton(
                onPressed: () =>
                    showQuickProfile(context, onDownloadResume: () {}),
                child: const Text('open'),
              ),
            ),
          ),
        ),
      ));
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      FlutterError.onError = previous;
      expect(find.byKey(const Key('quick_profile')), findsOneWidget);
      expect(errors, isEmpty);
    });
  }
}
