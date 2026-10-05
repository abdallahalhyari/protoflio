import 'package:flutter/material.dart';
import 'package:profile/core/theme/tokens.dart';
import 'package:profile/features/contact/presentation/bloc/contact_inquiry_state.dart';
import 'package:profile/l10n/app_localizations.dart';

class InquiryTrackSelector extends StatelessWidget {
  final ContactInquiryState state;
  final ColorScheme scheme;
  final ValueChanged<int> onTrackChanged;

  const InquiryTrackSelector({
    super.key,
    required this.state,
    required this.scheme,
    required this.onTrackChanged,
  });

  @override
  Widget build(BuildContext context) {
    final tracks = state.tracks;
    final selectedTrack = state.selectedTrackIndex;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          AppLocalizations.of(context)!.uiSelectTrack,
          style: TextStyle(
            color: scheme.primary,
            fontSize: AppTypography.label,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (int i = 0; i < tracks.length; i++)
              ChoiceChip(
                avatar: Icon(tracks[i].icon, size: 16),
                label: Text(tracks[i].title),
                selected: selectedTrack == i,
                onSelected: (_) => onTrackChanged(i),
                selectedColor: scheme.primary.withValues(alpha: 0.2),
                side: BorderSide(
                  color: selectedTrack == i
                      ? scheme.primary
                      : Theme.of(context).dividerColor,
                ),
              ),
          ],
        ),
      ],
    );
  }
}
