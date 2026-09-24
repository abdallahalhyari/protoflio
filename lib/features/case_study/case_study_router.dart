import 'package:flutter/material.dart';

import 'package:profile/service/analytics_service.dart';
import 'package:profile/service/url_sync_service.dart';
import 'package:profile/theme/tokens.dart';
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

  static String? _openSlug;
  static Route<void>? _openRoute;

  /// True while any case study is on screen.
  static bool get hasOpen => _openSlug != null;

  /// True while the case study for [slug] is on screen.
  static bool isOpen(String slug) => _openSlug == slug;

  /// Push the case-study page for [slug] onto the root navigator.
  ///
  /// Gets its own browser-history entry (`#work/<slug>`), so Back closes it.
  /// Pass [fromUrl] when the browser already moved to that hash (link click,
  /// URL edit, Forward) — the entry exists and must not be pushed again.
  static Future<void> push(
    BuildContext context,
    String slug, {
    bool fromUrl = false,
  }) async {
    final builder = _pages[slug];
    // One case study at a time — a repeated hash event or double tap must
    // not stack a second copy of the same page.
    if (builder == null || _openSlug != null) return;
    if (!fromUrl) UrlSyncService.instance.pushHash('work/$slug');
    await _present(Navigator.of(context, rootNavigator: true), slug, builder);
  }

  /// Swap the open case study for [slug] (related-study links) in place,
  /// reusing the current history entry instead of popping and pushing —
  /// history.back() is async and would race a following pushState.
  static Future<void> replace(BuildContext context, String slug) async {
    final builder = _pages[slug];
    final current = _openRoute;
    if (builder == null || current == null || !current.isCurrent) return;
    UrlSyncService.instance.updateHash('work/$slug');
    await _present(Navigator.of(context, rootNavigator: true), slug, builder,
        replacing: current);
  }

  /// Close the open case study because the URL left `#work/<slug>`
  /// (browser Back, or the user navigated to another hash).
  static void closeFromUrl() {
    final route = _openRoute;
    if (route == null || !route.isActive) return;
    _openSlug = null;
    final navigator = route.navigator!;
    if (route.isCurrent) {
      navigator.pop();
    } else {
      navigator.removeRoute(route);
    }
  }

  static Future<void> _present(
    NavigatorState navigator,
    String slug,
    WidgetBuilder builder, {
    Route<void>? replacing,
  }) async {
    _openSlug = slug;
    Analytics.event('case_study_open', params: {'study': slug});
    final route = PageRouteBuilder<void>(
      transitionDuration: AppMotion.md,
      reverseTransitionDuration: AppMotion.sm,
      pageBuilder: (ctx, __, ___) => builder(ctx),
      transitionsBuilder: (_, animation, __, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: AppMotion.emphasizedDecel,
          )),
          child: child,
        );
      },
    );
    _openRoute = route;
    await (replacing == null
        ? navigator.push(route)
        : navigator.pushReplacement(route));

    // Replaced by a related study — the new route owns the state now.
    if (_openRoute != route) return;
    _openRoute = null;
    _openSlug = null;
    // Closed from the UI (back arrow, Esc): drop the `#work/<slug>` entry
    // this page pushed. Closed by the URL: the browser already moved.
    if (UrlSyncService.instance.getInitialHash() == 'work/$slug') {
      UrlSyncService.instance.back();
    }
  }
}
