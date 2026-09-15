import 'package:flutter/material.dart';

import '../../../theme/tokens.dart';
import '../data/experience_data.dart';
import '../widget/experience/animated_experience_node.dart';
import '../widget/experience/credentials_bento_card.dart';
import '../widget/experience/experience_header.dart';
import '../widget/screen_shell.dart';

class ExperiencePage extends StatefulWidget {
  final PageController? controller;
  final int? pageIndex;
  final bool isContinuousMobile;

  const ExperiencePage({
    super.key,
    this.controller,
    this.pageIndex,
    this.isContinuousMobile = false,
  });

  @override
  State<ExperiencePage> createState() => _ExperiencePageState();
}

class _ExperiencePageState extends State<ExperiencePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  // Stagger animation state
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    if (widget.isContinuousMobile) {
      _isVisible = true;
    } else {
      _checkVisibility();
      widget.controller?.addListener(_checkVisibility);
    }
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_checkVisibility);
    super.dispose();
  }

  void _checkVisibility() {
    if (!mounted) return;
    if (widget.controller == null ||
        !widget.controller!.hasClients ||
        widget.controller!.positions.length != 1) {
      if (!_isVisible) setState(() => _isVisible = true);
      return;
    }

    // Trigger animation when the page comes into view
    final page =
        widget.controller!.page ?? widget.controller!.initialPage.toDouble();
    final isFocused = (page - (widget.pageIndex ?? 0)).abs() < 0.3;

    if (isFocused && !_isVisible) {
      setState(() => _isVisible = true);
    } else if (!isFocused &&
        _isVisible &&
        (page - (widget.pageIndex ?? 0)).abs() > 0.8) {
      // Optional: reset visibility when scrolling far away to replay animation when returning
      setState(() => _isVisible = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // AutomaticKeepAliveClientMixin requirement
    final size = MediaQuery.sizeOf(context);
    final isDesktop = size.width >= AppBreakpoints.tablet;

    return AppScreenShell(
      maxWidth: 1600, // Wider for horizontal scroll
      verticalPadding:
          widget.isContinuousMobile ? AppSpacing.md : AppSpacing.md,
      reserveBottomNav: !widget.isContinuousMobile,
      reserveMobileTop: !widget.isContinuousMobile,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? AppSpacing.xl : AppSpacing.md),
            child: ExperienceHeader(isDesktop: isDesktop),
          ),
          const SizedBox(height: AppSpacing.sm),

          // Timeline Grid
          if (widget.isContinuousMobile)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              child: _buildContinuousMobileList(),
            )
          else
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isDesktop ? AppSpacing.xl : AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                child: isDesktop
                    ? _buildDesktopGrid()
                    : _buildMobileList(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildContinuousMobileList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (int i = 0; i < kExperience.length; i++) ...[
          AnimatedExperienceNode(
            exp: kExperience[i],
            index: i,
            isVisible: _isVisible,
            isDesktop: false,
          ),
          const SizedBox(height: AppSpacing.md),
        ],
        CredentialsBentoCard(
          isVisible: _isVisible,
          isDesktop: false,
        ),
      ],
    );
  }

  Widget _buildDesktopGrid() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Column 1: Experiences 0 and 1
        Expanded(
          flex: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 5,
                child: AnimatedExperienceNode(
                  exp: kExperience[0],
                  index: 0,
                  isVisible: _isVisible,
                  isDesktop: true,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Expanded(
                flex: 4,
                child: AnimatedExperienceNode(
                  exp: kExperience[1],
                  index: 1,
                  isVisible: _isVisible,
                  isDesktop: true,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.lg),

        // Column 2: Experiences 2 and 3
        Expanded(
          flex: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 5,
                child: AnimatedExperienceNode(
                  exp: kExperience[2],
                  index: 2,
                  isVisible: _isVisible,
                  isDesktop: true,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Expanded(
                flex: 4,
                child: AnimatedExperienceNode(
                  exp: kExperience[3],
                  index: 3,
                  isVisible: _isVisible,
                  isDesktop: true,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.lg),

        // Column 3: Credentials Bento
        Expanded(
          flex: 4,
          child: CredentialsBentoCard(
            isVisible: _isVisible,
            isDesktop: true,
          ),
        ),
      ],
    );
  }

  Widget _buildMobileList() {
    return ListView.builder(
      padding: EdgeInsets.zero,
      primary: false,
      physics: const ClampingScrollPhysics(),
      itemCount: kExperience.length + 1,
      itemBuilder: (context, index) {
        if (index == kExperience.length) {
          return CredentialsBentoCard(
            isVisible: _isVisible,
            isDesktop: false,
          );
        }
        return AnimatedExperienceNode(
          exp: kExperience[index],
          index: index,
          isVisible: _isVisible,
          isDesktop: false,
        );
      },
    );
  }
}
