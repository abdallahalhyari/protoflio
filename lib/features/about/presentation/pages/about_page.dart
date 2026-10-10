import 'package:flutter/material.dart';
import 'package:profile/features/about/presentation/about_navigation.dart';
import 'package:profile/features/about/presentation/pages/about_contact_page.dart';

/// About Page wrapper pointing to [AboutContactPage].
class AboutPage extends StatelessWidget {
  const AboutPage({
    super.key,
    this.isContinuousMobile = false,
    this.initialTab,
  });

  final bool isContinuousMobile;
  final int? initialTab;

  @override
  Widget build(BuildContext context) {
    return AboutContactPage(
      isContinuousMobile: isContinuousMobile,
      initialTab: initialTab ?? AboutTabs.profile,
    );
  }
}
