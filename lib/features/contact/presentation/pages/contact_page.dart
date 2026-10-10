import 'package:flutter/material.dart';
import 'package:profile/features/about/presentation/about_navigation.dart';
import 'package:profile/features/about/presentation/pages/about_contact_page.dart';

/// Contact Page wrapper pointing to [AboutContactPage].
class ContactPage extends StatelessWidget {
  const ContactPage({
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
      initialTab: initialTab ?? AboutTabs.contact,
    );
  }
}
