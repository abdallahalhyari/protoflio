import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:profile/l10n/app_localizations.dart';

/// "11/2024 – Present" as "Nov 2024 – Present", in the reader's locale.
///
/// The data stores periods as `MM/YYYY – MM/YYYY` or `MM/YYYY – Present`.
/// Numeric month/year pairs are hard to scan down a timeline; a month
/// name is not. Anything that does not parse is returned unchanged.
String formatExperiencePeriod(BuildContext context, String period) {
  final parts = period.split('–').map((p) => p.trim()).toList();
  if (parts.length != 2) return period;

  final locale = Localizations.localeOf(context).toLanguageTag();
  final l10n = AppLocalizations.of(context)!;

  String? month(String s) {
    final m = RegExp(r'^(\d{1,2})/(\d{4})$').firstMatch(s);
    if (m == null) return null;
    final date = DateTime(int.parse(m.group(2)!), int.parse(m.group(1)!));
    // Latin digits in every locale, matching the rest of the Arabic page.
    return (DateFormat.yMMM(locale)..useNativeDigits = false).format(date);
  }

  final start = month(parts[0]);
  final end =
      parts[1].toLowerCase() == 'present' ? l10n.studyPresent : month(parts[1]);
  if (start == null || end == null) return period;
  return '$start – $end';
}

bool isCurrentExperience(String period) =>
    period.toLowerCase().contains('present');
