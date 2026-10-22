import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:profile/core/theme/app_theme.dart';
import 'package:profile/features/intro/presentation/widgets/intro_cta_row.dart';
import 'package:profile/l10n/app_localizations.dart';

void main() {
  testWidgets('the cover offers three actions and nothing else',
      (tester) async {
    var work = 0, cv = 0;
    await tester.pumpWidget(MaterialApp(
      theme: AppTheme.dark(),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: Center(
          child: IntroCtaRow(
            isDark: true,
            onViewWork: () => work++,
            onDownloadResume: () => cv++,
          ),
        ),
      ),
    ));
    final l10n = lookupAppLocalizations(const Locale('en'));

    expect(find.text(l10n.viewMyWork), findsOneWidget);
    expect(find.text(l10n.introEmailMe), findsOneWidget);
    expect(find.text(l10n.introDownloadResume), findsOneWidget);
    for (final gone in [
      l10n.quickProfileTitle,
      l10n.quickProfileVcard,
      'Copy email',
      'LinkedIn',
      'GitHub',
    ]) {
      expect(find.text(gone), findsNothing, reason: gone);
    }
    // No arrow appended to the primary action.
    expect(find.byIcon(Icons.arrow_forward_rounded), findsNothing);

    await tester.tap(find.text(l10n.viewMyWork));
    await tester.tap(find.text(l10n.introDownloadResume));
    expect(work, 1);
    expect(cv, 1);
  });
}
