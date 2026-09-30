import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:profile/l10n/app_localizations.dart';
import 'package:profile/service/analytics_service.dart';
import 'package:profile/service/sound_service.dart';
import 'package:profile/shared/widget/app_toast.dart';

Future<void> shareCaseStudy(
  BuildContext context, {
  required String slug,
  required String title,
}) async {
  SoundService.instance.playClick();
  Analytics.event('case_study_share', params: {'study': slug, 'title': title});
  final url = 'https://alhyari.web.app/work/$slug/';
  await Clipboard.setData(ClipboardData(text: url));

  if (!context.mounted) return;
  AppToast.showGlass(
    context,
    message: AppLocalizations.of(context)!.studyLinkCopied(url),
  );
}

class CaseStudyToolbarShareButton extends StatelessWidget {
  final String slug;
  final String title;

  const CaseStudyToolbarShareButton({
    super.key,
    required this.slug,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.share_rounded, size: 20),
      tooltip: AppLocalizations.of(context)!.studyShareButton,
      onPressed: () => shareCaseStudy(context, slug: slug, title: title),
    );
  }
}
