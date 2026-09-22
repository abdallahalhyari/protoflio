import 'package:flutter/material.dart';
import 'package:profile/shared/widget/app_toast.dart';
import 'package:profile/theme/surface_tone.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:profile/service/analytics_service.dart';
import 'package:profile/service/sound_service.dart';
import 'package:profile/theme/tokens.dart';
import 'package:profile/features/contact/bloc/contact_inquiry_bloc.dart';
import 'package:profile/features/contact/bloc/contact_inquiry_event.dart';
import 'package:profile/features/contact/bloc/contact_inquiry_state.dart';

Future<void> showInquiryComposerDialog(
  BuildContext context, {
  int initialTrackIndex = 0,
  void Function(String message)? onCopy,
  void Function(String subject, String body)? onSend,
}) {
  return showDialog(
    context: context,
    barrierDismissible: true,
    builder: (ctx) => InquiryComposerDialog(
      initialTrackIndex: initialTrackIndex,
      onCopy: onCopy,
      onSend: onSend,
    ),
  );
}

class InquiryComposerDialog extends StatelessWidget {
  final int initialTrackIndex;
  final void Function(String message)? onCopy;
  final void Function(String subject, String body)? onSend;

  const InquiryComposerDialog({
    super.key,
    this.initialTrackIndex = 0,
    this.onCopy,
    this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    ContactInquiryBloc? bloc;
    try {
      bloc = context.read<ContactInquiryBloc>();
    } catch (_) {
      bloc = null;
    }

    if (bloc != null) {
      return _InquiryComposerDialogView(
        initialTrackIndex: initialTrackIndex,
        onCopy: onCopy,
        onSend: onSend,
      );
    }

    return BlocProvider<ContactInquiryBloc>(
      create: (_) => ContactInquiryBloc(initialTrackIndex: initialTrackIndex),
      child: _InquiryComposerDialogView(
        initialTrackIndex: initialTrackIndex,
        onCopy: onCopy,
        onSend: onSend,
      ),
    );
  }
}

class _InquiryComposerDialogView extends StatefulWidget {
  final int initialTrackIndex;
  final void Function(String message)? onCopy;
  final void Function(String subject, String body)? onSend;

  const _InquiryComposerDialogView({
    required this.initialTrackIndex,
    this.onCopy,
    this.onSend,
  });

  @override
  State<_InquiryComposerDialogView> createState() =>
      _InquiryComposerDialogViewState();
}

class _InquiryComposerDialogViewState
    extends State<_InquiryComposerDialogView> {
  static const String _recipientEmail = 'alhyariabdallh@gmail.com';

  late final TextEditingController _nameController;
  late final TextEditingController _companyController;
  late final TextEditingController _bodyController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _companyController = TextEditingController();
    _bodyController = TextEditingController();

    final bloc = context.read<ContactInquiryBloc>();
    _bodyController.text = bloc.state.body;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _companyController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  void _onTrackChanged(int index, ContactInquiryState state) {
    SoundService.instance.playSelection();
    context.read<ContactInquiryBloc>().add(InquiryTrackChanged(index));
    final newDefaultBody =
        state.tracks[index.clamp(0, state.tracks.length - 1)].defaultBody;
    _bodyController.text = newDefaultBody;
  }

  Future<void> _launchEmailClient(ContactInquiryState state) async {
    SoundService.instance.playClick();
    Analytics.ctaEmail();
    final subject = state.activeSubject;
    final body = state.formattedMessage;

    if (widget.onSend != null) {
      widget.onSend!(subject, body);
      return;
    }

    final Uri mailUri = Uri(
      scheme: 'mailto',
      path: _recipientEmail,
      queryParameters: {
        'subject': subject,
        'body': body,
      },
    );
    await launchUrl(mailUri, mode: LaunchMode.externalApplication);
  }

  Future<void> _copyDraft(ContactInquiryState state) async {
    SoundService.instance.playClick();
    context.read<ContactInquiryBloc>().add(const InquiryCopiedEvent());
    final body = state.formattedMessage;

    if (widget.onCopy != null) {
      widget.onCopy!(body);
      return;
    }

    await Clipboard.setData(ClipboardData(text: body));

    if (!mounted) return;
    AppToast.show(
      context,
      message: 'Inquiry draft copied to clipboard!',
      status: ToastStatus.ok,
      duration: const Duration(seconds: 2),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final size = MediaQuery.sizeOf(context);
    final isDesktop = size.width >= AppBreakpoints.tablet;

    // Timezone computation
    final nowUtc = DateTime.now().toUtc();
    final ammanTime = nowUtc.add(const Duration(hours: 3));
    final localTime = DateTime.now();
    final ammanHour = ammanTime.hour;
    final isAmmanActive = ammanHour >= 9 && ammanHour < 19;

    final ammanFormatted =
        '${ammanTime.hour.toString().padLeft(2, '0')}:${ammanTime.minute.toString().padLeft(2, '0')}';
    final localFormatted =
        '${localTime.hour.toString().padLeft(2, '0')}:${localTime.minute.toString().padLeft(2, '0')}';

    return BlocBuilder<ContactInquiryBloc, ContactInquiryState>(
      builder: (context, state) {
        final tracks = state.tracks;
        final selectedTrack = state.selectedTrackIndex;

        return Dialog(
          backgroundColor: context.modalSurface,
          insetPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            side: BorderSide(
              color: scheme.primary.withValues(alpha: AppAlpha.border),
              width: 1.5,
            ),
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 680,
              maxHeight: size.height * 0.88,
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: scheme.primary.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.send_rounded,
                            color: scheme.primary, size: 20),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'DIRECT INQUIRY COMPOSER',
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
                  ),
                  const SizedBox(height: AppSpacing.md),
                  // Timezone Overlap Banner
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.black.withValues(alpha: 0.3)
                          : AppColors.slate50,
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      border: Border.all(
                        color: (isAmmanActive
                                ? AppColors.accentGreen
                                : AppColors.accentAmber)
                            .withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: isAmmanActive
                                ? AppColors.accentGreen
                                : AppColors.accentAmber,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'AMMAN (UTC+3): $ammanFormatted · YOUR TIME: $localFormatted — ${isAmmanActive ? "ACTIVE RESPONSE WINDOW" : "ASYNC INQUIRY (REPLY WITHIN 24H)"}',
                            style: TextStyle(
                              fontFamily: AppTypography.monoFont,
                              color:
                                  isDark ? Colors.white70 : AppColors.slate700,
                              fontSize: AppTypography.micro,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  // Track Selector Chips
                  Text(
                    'SELECT ENGAGEMENT TRACK',
                    style: TextStyle(
                      fontFamily: AppTypography.monoFont,
                      color: scheme.primary,
                      fontSize: AppTypography.micro,
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
                          label: Text(tracks[i].title),
                          selected: selectedTrack == i,
                          onSelected: (_) => _onTrackChanged(i, state),
                          selectedColor: scheme.primary.withValues(alpha: 0.2),
                          side: BorderSide(
                            color: selectedTrack == i
                                ? scheme.primary
                                : (context.divider),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  // Contact details inputs
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _nameController,
                          onChanged: (val) {
                            context
                                .read<ContactInquiryBloc>()
                                .add(InquiryNameChanged(val));
                          },
                          decoration: const InputDecoration(
                            labelText: 'Your Name (Optional)',
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: TextField(
                          controller: _companyController,
                          onChanged: (val) {
                            context
                                .read<ContactInquiryBloc>()
                                .add(InquiryCompanyChanged(val));
                          },
                          decoration: const InputDecoration(
                            labelText: 'Company / Org (Optional)',
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  // Message Body
                  TextField(
                    controller: _bodyController,
                    onChanged: (val) {
                      context
                          .read<ContactInquiryBloc>()
                          .add(InquiryBodyChanged(val));
                    },
                    maxLines: 5,
                    decoration: const InputDecoration(
                      labelText: 'Message Body',
                      border: OutlineInputBorder(),
                      alignLabelWithHint: true,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  // Actions
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton.icon(
                        onPressed: () => _copyDraft(state),
                        icon: const Icon(Icons.copy_rounded, size: 16),
                        label: const Text('COPY DRAFT'),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      FilledButton.icon(
                        onPressed: () => _launchEmailClient(state),
                        icon: const Icon(Icons.mail_outline_rounded, size: 16),
                        label: const Text('OPEN IN EMAIL CLIENT'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
