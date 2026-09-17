import 'package:flutter/material.dart';

import '../../service/analytics_service.dart';
import '../../service/url_sync_service.dart';
import '../../theme/tokens.dart';
import 'case_study_eskadenia.dart';
import 'case_study_fais.dart';
import 'case_study_nathealth.dart';
import 'case_study_solutions.dart';

/// URL slug ↔ case-study page mapping. Slugs live under `#work/<slug>`
/// so recruiters can deep-link to a specific case study, and the
/// browser back button pops the page + restores the hash.
class CaseStudyRouter {
  CaseStudyRouter._();

  static const Map<String, String> slugToCompany = {
    'nathealth': 'NatHealth',
    'eskadenia': 'ESKADENIA Software',
    'solutions': 'Solutions Now IT',
    'fais': 'Future Advanced Internet Solutions',
  };

  static final Map<String, WidgetBuilder> _pages = {
    'nathealth': (_) => const NatHealthCaseStudy(),
    'eskadenia': (_) => const EskadeniaCaseStudy(),
    'solutions': (_) => const SolutionsCaseStudy(),
    'fais': (_) => const FaisCaseStudy(),
  };

  /// Slug for a project. Falls back to null when the company has no
  /// dedicated case study yet — caller keeps its existing modal path.
  static String? slugForCompany(String company) {
    for (final entry in slugToCompany.entries) {
      if (entry.value == company) return entry.key;
    }
    return null;
  }

  /// True when a slug has a dedicated case-study page registered.
  static bool has(String slug) => _pages.containsKey(slug);

  /// Push the case-study page for [slug] onto the root navigator and
  /// rewrite the URL hash to `#work/<slug>`. On pop, the hash is
  /// restored to `#work` so the Projects section stays selected.
  static Future<void> push(BuildContext context, String slug) async {
    final builder = _pages[slug];
    if (builder == null) return;

    final priorHash = UrlSyncService.instance.getInitialHash() ?? 'work';
    UrlSyncService.instance.updateHash('work/$slug');
    Analytics.event('case_study_open', params: {'study': slug});

    await Navigator.of(context, rootNavigator: true).push(
      PageRouteBuilder(
        transitionDuration: AppMotion.md,
        reverseTransitionDuration: AppMotion.sm,
        pageBuilder: (ctx, __, ___) => builder(ctx),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(
            opacity: CurvedAnimation(
                parent: animation, curve: AppMotion.emphasizedDecel),
            child: child,
          );
        },
      ),
    );

    // Restore the hash to the outer section — never back past it, since
    // that would drop the user into whatever they were on when they
    // opened the case study.
    UrlSyncService.instance.updateHash(
      priorHash.startsWith('work/') ? 'work' : priorHash,
    );
  }
}
