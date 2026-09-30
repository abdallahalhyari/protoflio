import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:profile/l10n/app_localizations.dart';
import 'package:profile/theme/app_theme.dart';
import 'package:profile/features/intro/widget/quick_profile_actions.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
    theme: AppTheme.dark(),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(
      body: child,
    ),
  );
}

void main() {
  group('QuickProfileActions Test Suite', () {
    testWidgets('Renders all action buttons', (tester) async {
      await tester.pumpWidget(_wrap(
        QuickProfileActions(
          onDownloadResume: () {},
          onCopySummary: () {},
          email: 'test@example.com',
          linkedIn: 'https://linkedin.com',
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('quick_profile_cv')), findsOneWidget);
      expect(find.text('DOWNLOAD RESUME'), findsOneWidget);

      expect(find.text('Email'), findsOneWidget);
      expect(find.text('LinkedIn'), findsOneWidget);
      
      expect(find.byKey(const Key('quick_profile_copy')), findsOneWidget);
      expect(find.text('Copy summary'), findsOneWidget);
    });

    testWidgets('Triggers callbacks on tap', (tester) async {
      bool resumeDownloaded = false;
      bool summaryCopied = false;

      await tester.pumpWidget(_wrap(
        QuickProfileActions(
          onDownloadResume: () => resumeDownloaded = true,
          onCopySummary: () => summaryCopied = true,
          email: 'test@example.com',
          linkedIn: 'https://linkedin.com',
        ),
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('quick_profile_cv')));
      await tester.pumpAndSettle();
      expect(resumeDownloaded, isTrue);

      await tester.tap(find.byKey(const Key('quick_profile_copy')));
      await tester.pumpAndSettle();
      expect(summaryCopied, isTrue);
    });
  });
}
