import 'package:flutter/material.dart';
import 'package:profile/theme/surface_tone.dart';
import 'package:profile/theme/tokens.dart';
import 'package:profile/service/sound_service.dart';
import 'package:profile/l10n/app_localizations.dart';

class InquiryDialogHeader extends StatelessWidget {
  final ColorScheme scheme;
  final bool isDesktop;

  const InquiryDialogHeader(
      {super.key, required this.scheme, required this.isDesktop});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: scheme.primary.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.send_rounded, color: scheme.primary, size: 20),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.uiComposerTitle,
                style: TextStyle(
                  fontFamily: AppTypography.monoFont,
                  color: scheme.primary,
                  fontSize: AppTypography.micro,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.4,
                ),
              ),
              Text(
                'Reach Abdallah Alhyari',
                style: TextStyle(
                  fontFamily: AppTypography.displayFont,
                  color: context.onSurface,
                  fontSize: isDesktop ? 20 : 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          tooltip: 'Close',
          onPressed: () {
            SoundService.instance.playClick();
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.close_rounded),
        ),
      ],
    );
  }
}
