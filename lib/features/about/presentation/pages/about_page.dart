import 'package:flutter/material.dart';
import 'package:profile/features/about/presentation/about_navigation.dart';
import 'package:profile/features/contact/presentation/pages/contact_page.dart';

/// About & Contact Page wrapper for backward compatibility across route references.
class AboutPage extends StatelessWidget {
  const AboutPage({super.key, this.isContinuousMobile = false});

  final bool isContinuousMobile;

  @override
  Widget build(BuildContext context) {
    return ContactPage(
      isContinuousMobile: isContinuousMobile,
      initialTab: AboutTabs.profile,
    );
  }
}
