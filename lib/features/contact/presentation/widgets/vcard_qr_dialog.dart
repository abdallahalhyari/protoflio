import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:profile/core/theme/surface_tone.dart';
import 'package:profile/core/theme/tokens.dart';
import 'package:profile/shared/widgets/app_toast.dart';

/// Interactive Recruiter vCard Modal. Renders an ultra-clean, high-precision
/// scannable vCard QR code with sleek cards, clear metadata, and one-tap copy.
class VCardQrDialog extends StatelessWidget {
  const VCardQrDialog({super.key});

  static const String vCardData = '''BEGIN:VCARD
VERSION:3.0
N:Alhyari;Abdallah;;;
FN:Abdallah Alhyari
TITLE:Senior Mobile Engineer (Flutter & Android)
ORG:NatHealth
EMAIL;TYPE=INTERNET,PREF:alhyariabdallh@gmail.com
TEL;TYPE=CELL:+962787032264
URL:https://alhyari.web.app/
URL;TYPE=LinkedIn:https://www.linkedin.com/in/abdallah-alhyari-0294791a0/
END:VCARD''';

  static Future<void> show(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (_) => const VCardQrDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final theme = Theme.of(context);
    final accent = theme.colorScheme.primary;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Container(
        width: 380,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurfaceElevated : Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: context.glassBorder),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? accent.withValues(alpha: 0.15)
                  : Colors.black.withValues(alpha: 0.12),
              blurRadius: 28,
              spreadRadius: 2,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header Bar
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(AppRadius.xs),
                  ),
                  child: Icon(Icons.qr_code_scanner_rounded,
                      color: accent, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Recruiter vCard',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: context.onSurface,
                        ),
                      ),
                      Text(
                        'Scan with phone camera',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: context.onSurface.withValues(alpha: 0.65),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close_rounded, size: 20),
                  tooltip: 'Close',
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Crisp White QR Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppRadius.sm),
                border: Border.all(color: AppColors.ink200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: QrImageView(
                data: vCardData,
                size: 200,
                padding: const EdgeInsets.all(4),
                eyeStyle: const QrEyeStyle(
                  eyeShape: QrEyeShape.square,
                  color: AppColors.ink950,
                ),
                dataModuleStyle: const QrDataModuleStyle(
                  dataModuleShape: QrDataModuleShape.square,
                  color: AppColors.ink950,
                ),
                errorCorrectionLevel: QrErrorCorrectLevel.M,
              ),
            ),
            const SizedBox(height: 18),

            // Profile Summary Pill
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.04)
                    : AppColors.ink50,
                borderRadius: BorderRadius.circular(AppRadius.xs),
                border: Border.all(color: context.glassBorder),
              ),
              child: Column(
                children: [
                  Text(
                    'Abdallah Alhyari',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: context.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Senior Flutter & Android Engineer',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: accent,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'alhyariabdallh@gmail.com · +962-78-703-2264',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: context.onSurface.withValues(alpha: 0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      Clipboard.setData(const ClipboardData(text: vCardData));
                      AppToast.show(context,
                          message: 'vCard copied to clipboard');
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    icon: const Icon(Icons.copy_rounded, size: 16),
                    label: const Text('Copy Text'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      Navigator.of(context).pop();
                    },
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    icon: const Icon(Icons.check_rounded, size: 16),
                    label: const Text('Done'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
