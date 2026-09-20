import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:profile/service/url_sync_service.dart';

void main() {
  group('SEO & URL Title Sync Audit Tests', () {
    test('UrlSyncService maps section hashes to descriptive page titles', () {
      final service = UrlSyncService.instance;

      expect(
        service.titleForHash('home'),
        UrlSyncService.baseTitle,
      );
      expect(
        service.titleForHash('#home'),
        UrlSyncService.baseTitle,
      );
      expect(
        service.titleForHash('work'),
        'Selected Work & Case Studies · Abdallah Alhyari',
      );
      expect(
        service.titleForHash('#work'),
        'Selected Work & Case Studies · Abdallah Alhyari',
      );
      expect(
        service.titleForHash('engineering'),
        'Systems Architecture & Engineering · Abdallah Alhyari',
      );
      expect(
        service.titleForHash('experience'),
        'Career Trajectory & Roles · Abdallah Alhyari',
      );
      expect(
        service.titleForHash('stack'),
        'Architectural Mastery & Skills · Abdallah Alhyari',
      );
      expect(
        service.titleForHash('about'),
        'Perspectives & Roles · Abdallah Alhyari',
      );
      expect(
        service.titleForHash('contact'),
        'Contact & Recruiter Inquiries · Abdallah Alhyari',
      );
    });

    test('UrlSyncService maps case study deep links to specific titles', () {
      final service = UrlSyncService.instance;

      expect(
        service.titleForHash('work/nathealth'),
        'NatHealth Smart-Card Case Study · Abdallah Alhyari',
      );
      expect(
        service.titleForHash('#work/nathealth'),
        'NatHealth Smart-Card Case Study · Abdallah Alhyari',
      );
      expect(
        service.titleForHash('work/eskadenia'),
        'ESKADENIA Healthcare Case Study · Abdallah Alhyari',
      );
      expect(
        service.titleForHash('work/solutions'),
        'Solutions Now Loyalty Case Study · Abdallah Alhyari',
      );
      expect(
        service.titleForHash('work/fais'),
        'FAIS M-Commerce & Streaming Case Study · Abdallah Alhyari',
      );
    });
  });

  group('web/index.html Meta & Open Graph Audit Tests', () {
    late String indexHtml;

    setUpAll(() {
      final file = File('web/index.html');
      expect(file.existsSync(), isTrue, reason: 'web/index.html must exist');
      indexHtml = file.readAsStringSync();
    });

    test('Contains standard crawler directives and canonical link', () {
      expect(indexHtml.contains('<meta name="robots" content="index, follow'),
          isTrue);
      expect(
          indexHtml.contains('<meta name="googlebot" content="index, follow">'),
          isTrue);
      expect(
          indexHtml.contains(
              '<meta name="referrer" content="strict-origin-when-cross-origin">'),
          isTrue);
      expect(
          indexHtml.contains(
              '<link rel="canonical" href="https://alhyari.web.app/">'),
          isTrue);
      expect(indexHtml.contains('<link rel="alternate" hreflang="en"'), isTrue);
    });

    test('Contains rich Open Graph protocol tags for social previews', () {
      expect(indexHtml.contains('<meta property="og:type" content="website">'),
          isTrue);
      expect(indexHtml.contains('<meta property="og:site_name"'), isTrue);
      expect(indexHtml.contains('<meta property="og:title"'), isTrue);
      expect(indexHtml.contains('<meta property="og:description"'), isTrue);
      expect(
          indexHtml.contains(
              '<meta property="og:image" content="https://alhyari.web.app/og-image.png">'),
          isTrue);
      expect(
          indexHtml.contains('<meta property="og:image:secure_url"'), isTrue);
      expect(
          indexHtml
              .contains('<meta property="og:image:type" content="image/png">'),
          isTrue);
      expect(
          indexHtml.contains('<meta property="og:image:width" content="1200">'),
          isTrue);
      expect(
          indexHtml.contains('<meta property="og:image:height" content="630">'),
          isTrue);
      expect(indexHtml.contains('<meta property="og:image:alt"'), isTrue);
      expect(
          indexHtml.contains(
              '<meta property="og:url" content="https://alhyari.web.app/">'),
          isTrue);
    });

    test(
        'Strictly contains zero Twitter/X tags or handles per user requirement',
        () {
      // The user explicitly stated: "i dont have Twitter" and "remove Twitter"
      final lower = indexHtml.toLowerCase();
      expect(lower.contains('name="twitter:'), isFalse,
          reason: 'No twitter:* name meta tags should exist in index.html');
      expect(lower.contains('property="twitter:'), isFalse,
          reason: 'No twitter:* property meta tags should exist in index.html');
      expect(lower.contains('twitter.com'), isFalse,
          reason: 'No twitter.com links should exist in index.html');
    });

    test('Contains valid JSON-LD structured data graph', () {
      final jsonLdMatch =
          RegExp(r'<script type="application/ld\+json">([\s\S]*?)</script>')
              .firstMatch(indexHtml);
      expect(jsonLdMatch, isNotNull, reason: 'Must contain JSON-LD script tag');

      final rawJson = jsonLdMatch!.group(1)!.trim();
      final Map<String, dynamic> schema =
          jsonDecode(rawJson) as Map<String, dynamic>;

      expect(schema['@context'], 'https://schema.org');
      final graph = schema['@graph'] as List<dynamic>;
      expect(graph, isNotEmpty);

      // Verify ProfilePage
      final profilePage = graph.firstWhere(
        (node) => node['@type'] == 'ProfilePage',
        orElse: () => null,
      );
      expect(profilePage, isNotNull);
      expect(profilePage['url'], 'https://alhyari.web.app/');

      // Verify WebSite
      final webSite = graph.firstWhere(
        (node) => node['@type'] == 'WebSite',
        orElse: () => null,
      );
      expect(webSite, isNotNull);

      // Verify Person
      final person = graph.firstWhere(
        (node) => node['@type'] == 'Person',
        orElse: () => null,
      );
      expect(person, isNotNull);
      expect(person['name'], 'Abdallah Alhyari');
      expect(person['jobTitle'], contains('Flutter'));
      expect(person['email'], 'mailto:alhyariabdallh@gmail.com');
      expect(person['worksFor']?['name'], 'NatHealth');
      expect(person['hasOccupation']?['occupationalCategory'], '15-1252.00');

      // Verify SoftwareApplications
      final softwareApps = graph
          .where((node) => node['@type'] == 'SoftwareApplication')
          .toList();
      expect(softwareApps.length, 4,
          reason: 'Must document all 4 featured production apps');
      final appNames =
          softwareApps.map((app) => app['name'].toString()).toList();
      expect(appNames.any((n) => n.contains('NatHealth')), isTrue);
      expect(appNames.any((n) => n.contains('ESKADENIA')), isTrue);
      expect(appNames.any((n) => n.contains('Solutions Now')), isTrue);
      expect(appNames.any((n) => n.contains('FAIS')), isTrue);
    });

    test(
        'Semantic skip target and crawler main does not block accessibility tree',
        () {
      // Must not have aria-hidden="true" so screen readers and search bots can traverse it
      expect(
          indexHtml.contains('id="main-content" aria-hidden="true"'), isFalse);
      expect(
          indexHtml.contains('aria-hidden="true" id="main-content"'), isFalse);
      expect(indexHtml.contains('<main class="sr-only" id="main-content">'),
          isTrue);
    });
  });

  group('web/manifest.json PWA Shortcuts Audit Tests', () {
    late Map<String, dynamic> manifest;

    setUpAll(() {
      final file = File('web/manifest.json');
      expect(file.existsSync(), isTrue, reason: 'web/manifest.json must exist');
      manifest = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
    });

    test('Manifest has standard PWA properties', () {
      expect(manifest['name'], contains('Abdallah Alhyari'));
      expect(manifest['short_name'], 'Alhyari');
      expect(manifest['display'], 'standalone');
      expect(manifest['theme_color'], '#0E0E10');
      expect(manifest['background_color'], '#0E0E10');
    });

    test('Manifest contains app shortcuts for quick deep-linking', () {
      final shortcuts = manifest['shortcuts'] as List<dynamic>?;
      expect(shortcuts, isNotNull);
      expect(shortcuts!.length, greaterThanOrEqualTo(4));

      final urls = shortcuts.map((s) => s['url'].toString()).toList();
      expect(urls, contains('./#work'));
      expect(urls, contains('./#engineering'));
      expect(urls, contains('./#contact'));
      expect(urls, contains('./cv.pdf'));
    });
  });
}
