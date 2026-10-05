import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:profile/core/services/sound_service.dart';
import 'package:profile/core/theme/surface_tone.dart';
import 'package:profile/core/theme/tokens.dart';
import 'package:profile/l10n/app_localizations.dart';

class BottomActions extends StatelessWidget {
  const BottomActions({super.key, required this.onDownloadResume});

  final VoidCallback onDownloadResume;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                SoundService.instance.playClick();
                Navigator.of(context).pop();
                onDownloadResume();
              },
              icon: const Icon(Icons.download_rounded, size: 18),
              label: Text(
                AppLocalizations.of(context)!.uiDownloadResumePdf,
                style: const TextStyle(
                  fontSize: AppTypography.label,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.4,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.gold,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
                elevation: 4,
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SocialButton(
                label: 'LinkedIn',
                icon: Icons.link_rounded,
                url: 'https://www.linkedin.com/in/abdallah-alhyari-0294791a0/',
              ),
              SizedBox(width: 12),
              SocialButton(
                label: 'GitHub',
                icon: Icons.code_rounded,
                url: 'https://github.com/abdallahalhyari',
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class SocialButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final String url;

  const SocialButton({
    super.key,
    required this.label,
    required this.icon,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;

    return InkWell(
      onTap: () async {
        SoundService.instance.playClick();
        final uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      },
      borderRadius: BorderRadius.circular(AppRadius.chip),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 14,
              color: isDark ? Colors.white60 : AppColors.ink500,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: context.mutedText,
                fontSize: AppTypography.label,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
