import 'package:flutter/material.dart';

import 'package:profile/features/intro/presentation/widgets/credential/cover_stage.dart';

/// The cover: a full-bleed card reader. Reading the credential unlocks
/// the site and opens onto the work; the two plain actions under the
/// reader do the same without the ceremony.
class IntroPage extends StatefulWidget {
  final VoidCallback onScrollDown;
  final VoidCallback? onViewWork;
  final VoidCallback? onDownloadResume;
  final VoidCallback? onContactMe;
  final bool isContinuousMobile;

  const IntroPage({
    super.key,
    required this.onScrollDown,
    this.onViewWork,
    this.onDownloadResume,
    this.onContactMe,
    this.isContinuousMobile = false,
  });

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final viewWork = widget.onViewWork ?? widget.onScrollDown;
    return CoverStage(
      isContinuousMobile: widget.isContinuousMobile,
      onUnlocked: viewWork,
      onViewWork: viewWork,
      onDownloadResume: widget.onDownloadResume ?? widget.onScrollDown,
    );
  }
}
