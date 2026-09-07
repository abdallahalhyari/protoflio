import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../theme/tokens.dart';
import '../model/hat_info.dart';
import 'network_hat_image.dart';

class DetailsWidget extends StatefulWidget {
  final HatInfo hat;

  const DetailsWidget({super.key, required this.hat});

  @override
  State<DetailsWidget> createState() => _DetailsWidgetState();

  static Route<void> route(HatInfo hat) {
    return PageRouteBuilder<void>(
      transitionDuration: AppMotion.md,
      reverseTransitionDuration: AppMotion.md,
      pageBuilder: (_, __, ___) => DetailsWidget(hat: hat),
      transitionsBuilder: (_, animation, __, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        );
        return FadeTransition(
          opacity: curved,
          child: child,
        );
      },
    );
  }
}

class _DetailsWidgetState extends State<DetailsWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _entryController;
  late final Animation<double> _textFade;
  late final Animation<Offset> _textSlide;

  @override
  void initState() {
    super.initState();
    _entryController = AnimationController(
      vsync: this,
      duration: AppMotion.xl,
    );
    _textFade = CurvedAnimation(
      parent: _entryController,
      curve: const Interval(0.35, 1.0, curve: Curves.easeOut),
    );
    _textSlide = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.35, 1.0, curve: Curves.easeOutCubic),
      ),
    );
    _entryController.forward();
  }

  @override
  void dispose() {
    _entryController.dispose();
    super.dispose();
  }

  RectTween _arcTween(Rect? begin, Rect? end) =>
      MaterialRectArcTween(begin: begin, end: end);

  @override
  Widget build(BuildContext context) {
    final hat = widget.hat;
    final size = MediaQuery.sizeOf(context);
    final isWide = size.width >= 800;

    final image = Opacity(
      opacity: .55,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Hero(
            tag: hat.heroTag,
            createRectTween: _arcTween,
            flightShuttleBuilder: (_, animation, __, ___, toHero) {
              return ScaleTransition(
                scale: Tween<double>(begin: 0.9, end: 1.0).animate(
                  CurvedAnimation(
                      parent: animation, curve: Curves.easeOutBack),
                ),
                child: toHero.widget,
              );
            },
            child: HatImage(
              path: hat.image,
              height: isWide ? 300 : 180,
              semanticLabel: 'hat_card.image_alt'
                  .tr(namedArgs: {'title': hat.title}),
            ),
          ),
          Text(
            hat.title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: isWide ? AppTypography.display : AppTypography.head,
              fontWeight: FontWeight.w600,
              shadows: const [
                Shadow(color: Colors.black87, blurRadius: 10),
              ],
            ),
          ),
        ],
      ),
    );

    final text = SlideTransition(
      position: _textSlide,
      child: FadeTransition(
        opacity: _textFade,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: isWide ? 600 : size.width - 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment:
                isWide ? CrossAxisAlignment.start : CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                hat.titleDesc,
                textAlign: isWide ? TextAlign.start : TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isWide ? AppTypography.display : AppTypography.subhead,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                hat.desc,
                textAlign: isWide ? TextAlign.start : TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isWide ? AppTypography.title : AppTypography.bodyMd,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.escape): () {
          Navigator.of(context).maybePop();
        },
      },
      child: Focus(
        autofocus: true,
        child: Scaffold(
          backgroundColor: hat.color,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.white),
            actions: [
              IconButton(
                tooltip: 'details.close_tooltip'.tr(),
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.of(context).maybePop(),
              ),
            ],
          ),
          extendBodyBehindAppBar: true,
          body: SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md, vertical: AppSpacing.lg),
              child: Center(
                child: SingleChildScrollView(
                  child: isWide
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            image,
                            const SizedBox(width: AppSpacing.huge),
                            text,
                          ],
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            image,
                            const SizedBox(height: AppSpacing.lg),
                            text,
                          ],
                        ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
