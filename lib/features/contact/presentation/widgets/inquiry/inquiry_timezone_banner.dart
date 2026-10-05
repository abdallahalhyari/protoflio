import 'package:flutter/material.dart';
import 'package:profile/core/theme/tokens.dart';

class InquiryTimezoneBanner extends StatelessWidget {
  final bool isDark;

  const InquiryTimezoneBanner({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final nowUtc = DateTime.now().toUtc();
    final ammanTime = nowUtc.add(const Duration(hours: 3));
    final localTime = DateTime.now();
    final ammanHour = ammanTime.hour;
    final isAmmanActive = ammanHour >= 9 && ammanHour < 19;

    final ammanFormatted =
        '${ammanTime.hour.toString().padLeft(2, '0')}:${ammanTime.minute.toString().padLeft(2, '0')}';
    final localFormatted =
        '${localTime.hour.toString().padLeft(2, '0')}:${localTime.minute.toString().padLeft(2, '0')}';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? Colors.black.withValues(alpha: 0.3) : AppColors.slate50,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: (isAmmanActive ? AppColors.accentGreen : AppColors.accentAmber)
              .withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color:
                  isAmmanActive ? AppColors.accentGreen : AppColors.accentAmber,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'AMMAN (UTC+3): $ammanFormatted · YOUR TIME: $localFormatted — ${isAmmanActive ? "ACTIVE RESPONSE WINDOW" : "ASYNC INQUIRY (REPLY WITHIN 24H)"}',
              style: TextStyle(
                fontFamily: AppTypography.monoFont,
                color: isDark ? Colors.white70 : AppColors.slate700,
                fontSize: AppTypography.micro,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
