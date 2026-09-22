import 'package:flutter/material.dart';
import 'package:profile/theme/surface_tone.dart';
import 'package:profile/theme/tokens.dart';

/// Semantic role for an [AppToast]. `neutral` keeps the theme's inverse
/// surface look (no accent bar); the rest paint a 4px status-color rail
/// down the leading edge.
enum ToastStatus { ok, critical, warn, info, neutral }

/// Themed snack-bar wrapper. Wraps `ScaffoldMessenger.showSnackBar` with a
/// status accent bar + default icon + semantic prefix so 20+ callsites
/// stop hand-rolling `SnackBar(content: Text(...))`.
///
/// Non-neutral variants prepend the status role to the semantic label
/// (`"Error: send failed"`) so screen readers hear the severity.
class AppToast {
  AppToast._();

  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> show(
    BuildContext context, {
    required String message,
    ToastStatus status = ToastStatus.neutral,
    IconData? icon,
    Duration duration = AppMotion.toast,
    SnackBarAction? action,
  }) {
    final effectiveIcon = icon ?? _defaultIcon(status);
    final accent = _accent(status);
    final theme = Theme.of(context);
    final onInverse = theme.colorScheme.onInverseSurface;

    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    return messenger.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        duration: duration,
        backgroundColor: theme.colorScheme.inverseSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        padding: EdgeInsets.zero,
        content: _ToastContent(
          message: message,
          semanticsLabel: _semanticsLabel(status, message),
          icon: effectiveIcon,
          accent: accent,
          onInverse: onInverse,
        ),
        action: action,
      ),
    );
  }

  /// Floating pill toast — transparent snack chrome + glass container
  /// with a status-tinted border and icon. Signature visual used by
  /// email-copy / share-link flows across contact / intro / nav / case
  /// study. Matches the hand-rolled design that lived in ~4 places.
  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showGlass(
    BuildContext context, {
    required String message,
    ToastStatus status = ToastStatus.ok,
    IconData? icon,
    Duration duration = AppMotion.toast,
  }) {
    final effectiveIcon = icon ?? _defaultIcon(status);
    final accent = _accent(status) ?? Theme.of(context).colorScheme.primary;

    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    return messenger.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
        duration: duration,
        margin: const EdgeInsets.only(
          bottom: AppSpacing.lg,
          left: AppSpacing.md,
          right: AppSpacing.md,
        ),
        content: _GlassToastContent(
          message: message,
          semanticsLabel: _semanticsLabel(status, message),
          icon: effectiveIcon,
          accent: accent,
        ),
      ),
    );
  }

  static IconData? _defaultIcon(ToastStatus status) => switch (status) {
        ToastStatus.ok => Icons.check_circle_rounded,
        ToastStatus.critical => Icons.error_rounded,
        ToastStatus.warn => Icons.warning_rounded,
        ToastStatus.info => Icons.info_rounded,
        ToastStatus.neutral => null,
      };

  static Color? _accent(ToastStatus status) => switch (status) {
        ToastStatus.ok => AppColors.statusOk,
        ToastStatus.critical => AppColors.statusCritical,
        ToastStatus.warn => AppColors.statusWarn,
        ToastStatus.info => AppColors.statusInfo,
        ToastStatus.neutral => null,
      };

  static String _semanticsLabel(ToastStatus status, String message) {
    final prefix = switch (status) {
      ToastStatus.ok => 'Success',
      ToastStatus.critical => 'Error',
      ToastStatus.warn => 'Warning',
      ToastStatus.info => 'Info',
      ToastStatus.neutral => null,
    };
    return prefix == null ? message : '$prefix: $message';
  }
}

class _GlassToastContent extends StatelessWidget {
  const _GlassToastContent({
    required this.message,
    required this.semanticsLabel,
    required this.icon,
    required this.accent,
  });

  final String message;
  final String semanticsLabel;
  final IconData? icon;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    return Semantics(
      label: semanticsLabel,
      liveRegion: true,
      child: ExcludeSemantics(
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.smd,
            ),
            decoration: BoxDecoration(
              color: isDark ? AppColors.slate900 : Colors.white,
              borderRadius: BorderRadius.circular(AppRadius.pill),
              border: Border.all(
                color: accent.withValues(alpha: 0.65),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.45 : 0.12),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(icon, color: accent, size: AppTypography.subtitle),
                  const SizedBox(width: AppSpacing.smd),
                ],
                Flexible(
                  child: Text(
                    message,
                    style: TextStyle(
                      color: context.onSurface,
                      fontSize: AppTypography.body,
                      fontWeight: FontWeight.w600,
                    ),
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

class _ToastContent extends StatelessWidget {
  const _ToastContent({
    required this.message,
    required this.semanticsLabel,
    required this.icon,
    required this.accent,
    required this.onInverse,
  });

  final String message;
  final String semanticsLabel;
  final IconData? icon;
  final Color? accent;
  final Color onInverse;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticsLabel,
      liveRegion: true,
      child: ExcludeSemantics(
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (accent != null) Container(width: 4, color: accent),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.smd,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (icon != null) ...[
                      Icon(icon,
                          size: AppTypography.subtitle,
                          color: accent ?? onInverse),
                      const SizedBox(width: AppSpacing.sm),
                    ],
                    Flexible(
                      child: Text(
                        message,
                        style: TextStyle(
                          color: onInverse,
                          fontSize: AppTypography.body,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
