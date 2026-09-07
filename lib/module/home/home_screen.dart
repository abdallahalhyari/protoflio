import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../theme/tokens.dart';
import '../../theme_controller.dart';
import 'data/experience_data.dart';
import 'data/hats_data.dart';
import 'data/projects_data.dart';
import 'data/skills_data.dart';
import 'widget/experience_tile.dart';
import 'widget/hat_card.dart';
import 'widget/page_background.dart';
import 'widget/primary_button.dart';
import 'widget/project_card.dart';
import 'widget/skill_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const int _pageCount = 7;
  final PageController _controller = PageController();
  final FocusNode _focusNode = FocusNode();
  int _pageIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onScroll);
  }

  void _onScroll() {
    final page = _controller.page?.round() ?? 0;
    if (page != _pageIndex) setState(() => _pageIndex = page);
  }

  @override
  void dispose() {
    _controller.removeListener(_onScroll);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _goTo(int page) {
    _controller.animateToPage(
      page.clamp(0, _pageCount - 1),
      duration: AppMotion.lg,
      curve: Curves.easeInOut,
    );
  }

  void _next() => _goTo(_pageIndex + 1);
  void _prev() => _goTo(_pageIndex - 1);

  KeyEventResult _handleKey(FocusNode _, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    final k = event.logicalKey;
    if (k == LogicalKeyboardKey.arrowDown ||
        k == LogicalKeyboardKey.pageDown ||
        k == LogicalKeyboardKey.space) {
      _next();
      return KeyEventResult.handled;
    }
    if (k == LogicalKeyboardKey.arrowUp || k == LogicalKeyboardKey.pageUp) {
      _prev();
      return KeyEventResult.handled;
    }
    if (k == LogicalKeyboardKey.home) {
      _goTo(0);
      return KeyEventResult.handled;
    }
    if (k == LogicalKeyboardKey.end) {
      _goTo(_pageCount - 1);
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Focus(
        focusNode: _focusNode,
        autofocus: true,
        onKeyEvent: _handleKey,
        child: Stack(
          children: [
            PageView(
              controller: _controller,
              scrollDirection: Axis.vertical,
              children: [
                _IntroPage(onScrollDown: _next),
                _HatsIntroPage(onExplain: _next),
                const _HatsGridPage(),
                const _SkillsPage(),
                const _ProjectsPage(),
                const _ExperiencePage(),
                const _ContactPage(),
              ],
            ),
            Positioned(
              right: 12,
              top: 0,
              bottom: 0,
              child: Center(
                child: _PageIndicator(
                  count: _pageCount,
                  current: _pageIndex,
                  onTap: _goTo,
                ),
              ),
            ),
            Positioned(
              top: 12,
              right: 12,
              child: SafeArea(
                child: ValueListenableBuilder<ThemeMode>(
                  valueListenable: ThemeController.mode,
                  builder: (_, mode, __) {
                    final dark = mode == ThemeMode.dark;
                    return Semantics(
                      toggled: dark,
                      label: 'Dark mode',
                      child: Material(
                        color: Colors.black45,
                        shape: const CircleBorder(),
                        child: IconButton(
                          tooltip: dark ? 'Switch to light' : 'Switch to dark',
                          icon: Icon(
                            dark ? Icons.light_mode : Icons.dark_mode,
                            color: Colors.white,
                          ),
                          onPressed: ThemeController.toggle,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PageIndicator extends StatelessWidget {
  final int count;
  final int current;
  final ValueChanged<int> onTap;

  const _PageIndicator({
    required this.count,
    required this.current,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(count, (i) {
        final active = i == current;
        return Semantics(
          button: true,
          selected: active,
          label: 'Go to page ${i + 1} of $count',
          child: SizedBox(
            width: 44,
            height: 44,
            child: InkResponse(
              onTap: () => onTap(i),
              radius: 22,
              child: Center(
                child: AnimatedContainer(
                  duration: AppMotion.sm,
                  width: active ? 12 : 8,
                  height: active ? 12 : 8,
                  decoration: BoxDecoration(
                    color: active ? Colors.white : Colors.white70,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black45, width: 1),
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _IntroPage extends StatelessWidget {
  final VoidCallback onScrollDown;
  const _IntroPage({required this.onScrollDown});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isWide = size.width >= 800;
    final avatarRadius = (size.shortestSide * 0.22).clamp(80.0, 180.0);
    final titleSize =
        (size.width * 0.06).clamp(AppTypography.heading, AppTypography.heroLg);
    final subtitleSize =
        (size.width * 0.035).clamp(AppTypography.title, AppTypography.display);

    return PageBackground(
      asset: 'assets/background.webp',
      overlay: AppColors.scrimMedium,
      child: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: size.height),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: isWide ? AppSpacing.xxl - 8 : AppSpacing.lg),
                Semantics(
                  header: true,
                  child: Text(
                    'HELLO THERE!\nI\'M ABDALLAH',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: titleSize,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      height: 1.1,
                      shadows: const [
                        Shadow(color: Colors.black87, blurRadius: 12),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Semantics(
                  label: 'Portrait of Abdallah Alhyari',
                  image: true,
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    padding: const EdgeInsets.all(AppSpacing.xs - 1),
                    child: CircleAvatar(
                      radius: avatarRadius,
                      backgroundColor: Colors.brown.shade300,
                      backgroundImage: const AssetImage('assets/my_image.png'),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  'Why Should You Hire Me?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: subtitleSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: const [
                      Shadow(color: Colors.black87, blurRadius: 10),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                PrimaryButton(label: 'Scroll Down', onPressed: onScrollDown),
                const SizedBox(height: AppSpacing.md),
                ExcludeSemantics(
                    child: Lottie.asset('assets/arrow_white.json', height: 80)),
                const SizedBox(height: AppSpacing.md),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HatsIntroPage extends StatelessWidget {
  final VoidCallback onExplain;
  const _HatsIntroPage({required this.onExplain});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final headingSize =
        (size.width * 0.055).clamp(AppTypography.heading + 2, AppTypography.hero);
    final overlineSize = (size.width * 0.028)
        .clamp(AppTypography.titleSm, AppTypography.heading + 2);

    return PageBackground(
      asset: 'assets/hats_background.webp',
      overlay: AppColors.scrimLight,
      child: Center(
        child: Container(
          constraints: BoxConstraints(
            maxWidth: size.width / 1.3,
            maxHeight: size.height * 0.85,
          ),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.black54, Colors.black38, Colors.black26],
            ),
          ),
          padding: const EdgeInsets.all(AppSpacing.md + 2),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'BECAUSE...',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: overlineSize,
                    fontWeight: FontWeight.w100,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs + 1),
                Text(
                  'I WEAR MANY HATS',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: headingSize,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                PrimaryButton(
                    label: 'Allow Me to Explain', onPressed: onExplain),
                const SizedBox(height: AppSpacing.md),
                ExcludeSemantics(
                    child: Lottie.asset('assets/arrow.json', height: 140)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HatsGridPage extends StatelessWidget {
  const _HatsGridPage();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      padding: const EdgeInsets.all(AppSpacing.sm),
      child: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final crossAxisCount = constraints.maxWidth >= 900
                ? 3
                : constraints.maxWidth >= 600
                    ? 2
                    : 1;
            return GridView.builder(
              itemCount: kHats.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 1.05,
              ),
              itemBuilder: (context, i) => HatCard(hat: kHats[i]),
            );
          },
        ),
      ),
    );
  }
}

class _SkillsPage extends StatelessWidget {
  const _SkillsPage();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final headingSize =
        (size.width * 0.055).clamp(AppTypography.heading, AppTypography.displayLg);
    final cross = size.width >= 900 ? 3 : size.width >= 600 ? 2 : 1;

    final theme = Theme.of(context);
    final textColor = theme.colorScheme.onSurface;
    return Container(
      color: theme.scaffoldBackgroundColor,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg, vertical: AppSpacing.xl),
          child: Column(
            children: [
              Text(
                'SKILLS',
                style: TextStyle(
                  color: textColor,
                  fontSize: headingSize,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Expanded(
                child: GridView.builder(
                  itemCount: kSkills.length,
                  gridDelegate:
                      SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: cross,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    mainAxisExtent: 84,
                  ),
                  itemBuilder: (_, i) => SkillTile(
                    skill: kSkills[i],
                    delay: Duration(milliseconds: 80 * i), // staggered — keep raw
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProjectsPage extends StatelessWidget {
  const _ProjectsPage();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final size = MediaQuery.sizeOf(context);
    final headingSize =
        (size.width * 0.055).clamp(AppTypography.heading, AppTypography.displayLg);
    final cross = size.width >= 1100 ? 2 : 1;

    return Container(
      color: theme.scaffoldBackgroundColor,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg, AppSpacing.lg + 4, AppSpacing.lg, AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'PROJECTS',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: scheme.onSurface,
                  fontSize: headingSize,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Expanded(
                child: cross == 1
                    ? ListView.separated(
                        itemCount: kProjects.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: AppSpacing.smd),
                        itemBuilder: (_, i) => ProjectCard(project: kProjects[i]),
                      )
                    : GridView.builder(
                        itemCount: kProjects.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: AppSpacing.smd,
                          crossAxisSpacing: AppSpacing.smd,
                          mainAxisExtent: 380,
                        ),
                        itemBuilder: (_, i) =>
                            ProjectCard(project: kProjects[i]),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ExperiencePage extends StatelessWidget {
  const _ExperiencePage();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final size = MediaQuery.sizeOf(context);
    final headingSize =
        (size.width * 0.055).clamp(AppTypography.heading, AppTypography.displayLg);
    final isWide = size.width >= 900;

    final expList = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < kExperience.length; i++)
          ExperienceTile(
            exp: kExperience[i],
            isFirst: i == 0,
            isLast: i == kExperience.length - 1,
          ),
      ],
    );

    final eduSection = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'EDUCATION',
          style: TextStyle(
            color: scheme.onSurface,
            fontSize: AppTypography.title,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: AppSpacing.smd),
        ...kEducation.map(
          (e) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md - 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  e.degree,
                  style: TextStyle(
                    fontSize: AppTypography.bodyMd,
                    fontWeight: FontWeight.w700,
                    color: scheme.onSurface,
                  ),
                ),
                Text(
                  '${e.institution} · ${e.period}',
                  style: TextStyle(
                    fontSize: AppTypography.small,
                    color: scheme.primary,
                  ),
                ),
                if (e.note != null)
                  Text(
                    e.note!,
                    style: TextStyle(
                      fontSize: AppTypography.caption,
                      color: scheme.onSurface.withValues(alpha: 0.7),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg - 4),
        Text(
          'CERTIFICATIONS',
          style: TextStyle(
            color: scheme.onSurface,
            fontSize: AppTypography.title,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: AppSpacing.sm + 2),
        ...kCertifications.map(
          (c) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm - 2),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.sm - 2),
                  child: Icon(Icons.verified,
                      size: 14, color: scheme.primary),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    c,
                    style: TextStyle(
                      fontSize: AppTypography.small,
                      color: scheme.onSurface.withValues(alpha: 0.85),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );

    return Container(
      color: theme.scaffoldBackgroundColor,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg, AppSpacing.lg + 4, AppSpacing.lg, AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'EXPERIENCE',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: scheme.onSurface,
                  fontSize: headingSize,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: AppSpacing.lg - 4),
              Expanded(
                child: SingleChildScrollView(
                  child: isWide
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(flex: 3, child: expList),
                            const SizedBox(width: AppSpacing.xl + 8),
                            Expanded(flex: 2, child: eduSection),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            expList,
                            const SizedBox(height: AppSpacing.lg - 4),
                            eduSection,
                          ],
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ContactPage extends StatelessWidget {
  const _ContactPage();

  Future<void> _open(BuildContext context, String url) async {
    final uri = Uri.parse(url);
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not open $url')),
      );
    }
  }

  Future<void> _copy(BuildContext context, String value) async {
    await Clipboard.setData(ClipboardData(text: value));
    if (!context.mounted) return;
    final msg = 'Copied: $value';
    // ignore: deprecated_member_use
    SemanticsService.announce(msg, TextDirection.ltr);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), duration: const Duration(seconds: 2)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final headingSize =
        (size.width * 0.055).clamp(AppTypography.heading, AppTypography.hero);
    final rowSize =
        (size.width * 0.035).clamp(AppTypography.bodyLg, AppTypography.head + 6);

    return PageBackground(
      asset: 'assets/hats_background.webp',
      overlay: AppColors.scrimHeavy,
      child: Center(
        child: Container(
          constraints: BoxConstraints(
            maxWidth: size.width / 1.15,
            maxHeight: size.height * 0.9,
          ),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.black26, Colors.black38, Colors.black54],
            ),
          ),
          padding: const EdgeInsets.all(AppSpacing.md + 2),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'CONTACT INFORMATION',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: headingSize,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Tap to open · long-press to copy',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize:
                        (rowSize * 0.55).clamp(AppTypography.micro, AppTypography.bodyLg),
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                _ContactRow(
                  label: 'EMAIL',
                  value: 'alhyariabdallh@gmail.com',
                  onTap: () =>
                      _open(context, 'mailto:alhyariabdallh@gmail.com'),
                  onLongPress: () =>
                      _copy(context, 'alhyariabdallh@gmail.com'),
                  fontSize: rowSize,
                ),
                const SizedBox(height: AppSpacing.md),
                _ContactRow(
                  label: 'PHONE',
                  value: '+962-787032264',
                  onTap: () => _open(context, 'tel:+962787032264'),
                  onLongPress: () => _copy(context, '+962787032264'),
                  fontSize: rowSize,
                ),
                const SizedBox(height: AppSpacing.md),
                _ContactRow(
                  label: 'LINKEDIN',
                  value: 'abdallah-alhyari',
                  onTap: () => _open(context,
                      'https://www.linkedin.com/in/abdallah-alhyari-95b915201/'),
                  onLongPress: () => _copy(
                      context,
                      'https://www.linkedin.com/in/abdallah-alhyari-95b915201/'),
                  fontSize: rowSize,
                  linkStyle: true,
                ),
                const SizedBox(height: AppSpacing.xl),
                Semantics(
                  label: 'Download CV, PDF, 54 kilobytes, opens in new tab',
                  button: true,
                  child: PrimaryButton(
                    label: 'Download CV (PDF)',
                    onPressed: () => _open(context, 'cv.pdf'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ContactRow extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final double fontSize;
  final bool linkStyle;

  const _ContactRow({
    required this.label,
    required this.value,
    required this.onTap,
    required this.fontSize,
    this.onLongPress,
    this.linkStyle = false,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '$label $value',
      button: true,
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(
            '$label : ',
            style: TextStyle(
              color: Colors.white,
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
          InkWell(
            onTap: onTap,
            onLongPress: onLongPress,
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 44),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm - 2, vertical: AppSpacing.sm + 2),
                child: Text(
                  value,
                  style: TextStyle(
                    color: linkStyle ? Colors.lightBlueAccent : Colors.white,
                    decoration: linkStyle
                        ? TextDecoration.underline
                        : TextDecoration.none,
                    decorationColor: Colors.white,
                    fontSize: fontSize,
                    fontWeight: FontWeight.bold,
                    shadows: const [
                      Shadow(color: Colors.black87, blurRadius: 6),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
