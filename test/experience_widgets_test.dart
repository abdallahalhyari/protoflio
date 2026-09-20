import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:profile/l10n/app_localizations.dart';
import 'package:profile/features/experience/data/experience_data.dart';
import 'package:profile/features/experience/widget/animated_experience_node.dart';
import 'package:profile/features/experience/widget/credentials_bento_card.dart';
import 'package:profile/features/experience/widget/experience_header.dart';
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
  group('Experience Widgets Test Suite', () {
    testWidgets('ExperienceHeader renders title and enterprise impact badge',
        (tester) async {
      await tester.pumpWidget(_wrap(const ExperienceHeader(isDesktop: true)));
      await tester.pumpAndSettle();

      expect(find.text('FEATURE 04 · CAREER TRAJECTORY'), findsOneWidget);
      expect(find.text('CAREER TRAJECTORY'), findsOneWidget);
      expect(find.text('4 ROLES · ENTERPRISE IMPACT'), findsOneWidget);
    });

    testWidgets('CredentialsBentoCard renders Academic Annex & Certifications',
        (tester) async {
      await tester.pumpWidget(_wrap(
        const CredentialsBentoCard(
          isVisible: true,
          isDesktop: true,
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text('ACADEMIC ANNEX'), findsOneWidget);
      expect(find.text('CERTIFICATION STAMPS'), findsOneWidget);
      expect(find.textContaining('Al-Hussein Bin Talal University'),
          findsOneWidget);
      expect(find.textContaining('Udemy'), findsWidgets);
    });

    testWidgets('AnimatedExperienceNode renders experience card content',
        (tester) async {
      final exp = kExperience.first;
      await tester.pumpWidget(_wrap(
        AnimatedExperienceNode(
          exp: exp,
          index: 0,
          isVisible: true,
          isDesktop: true,
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text(exp.company), findsOneWidget);
      expect(find.text(exp.role.toUpperCase()), findsOneWidget);
    });

    testWidgets(
        'AnimatedExperienceNode renders company website and linkedin action pills',
        (tester) async {
      final exp = kExperience.first;
      await tester.pumpWidget(_wrap(
        AnimatedExperienceNode(
          exp: exp,
          index: 0,
          isVisible: true,
          isDesktop: true,
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text('WEBSITE'), findsOneWidget);
      expect(find.text('LINKEDIN'), findsOneWidget);
      expect(find.byIcon(Icons.language_rounded), findsOneWidget);
      expect(find.text('in'), findsOneWidget);
    });
  });
}
