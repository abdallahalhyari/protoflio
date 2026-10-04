import 'package:flutter/material.dart';
import 'package:profile/shared/widgets/app_toast.dart';
import 'package:profile/core/theme/surface_tone.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:profile/core/services/analytics_service.dart';
import 'package:profile/core/services/sound_service.dart';
import 'package:profile/core/theme/tokens.dart';
import 'package:profile/features/contact/presentation/bloc/contact_inquiry_bloc.dart';
import 'package:profile/features/contact/presentation/bloc/contact_inquiry_event.dart';
import 'package:profile/features/contact/presentation/bloc/contact_inquiry_state.dart';
import 'package:profile/core/services/email_service.dart';
import 'package:profile/shared/utils/mailto.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:profile/features/contact/presentation/widgets/inquiry/inquiry_dialog_header.dart';
import 'package:profile/features/contact/presentation/widgets/inquiry/inquiry_timezone_banner.dart';
import 'package:profile/features/contact/presentation/widgets/inquiry/inquiry_track_selector.dart';
import 'package:profile/features/contact/presentation/widgets/inquiry/inquiry_dialog_actions.dart';

Future<void> showInquiryComposerDialog(
  BuildContext context, {
  int initialTrackIndex = 0,
  void Function(String message)? onCopy,
  void Function(String subject, String body)? onSend,
}) {
  return showDialog(
    context: context,
    builder: (ctx) => InquiryComposerDialog(
      initialTrackIndex: initialTrackIndex,
      onCopy: onCopy,
      onSend: onSend,
    ),
  );
}

const String _kInquiryEmail = 'alhyariabdallh@gmail.com';

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
  late final TextEditingController _nameController;
  late final TextEditingController _companyController;
  late final TextEditingController _bodyController;
  bool _isSending = false;

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

  Future<void> _sendEmail(ContactInquiryState state) async {
    SoundService.instance.playClick();
    Analytics.ctaEmail();
    final subject = state.activeSubject;
    final body = state.formattedMessage;

    if (widget.onSend != null) {
      widget.onSend!(subject, body);
      return;
    }

    if (!EmailService.instance.isConfigured) {
      await _openInEmailClient(subject, body);
      return;
    }

    setState(() => _isSending = true);

    final success = await EmailService.instance.sendEmail(
      subject: subject,
      body: body,
      name: _nameController.text,
      company: _companyController.text,
    );

    if (!mounted) return;
    setState(() => _isSending = false);

    if (success) {
      AppToast.show(
        context,
        message: 'Message sent successfully!',
        status: ToastStatus.ok,
        duration: const Duration(seconds: 3),
      );
      Navigator.of(context).pop();
    } else {
      // Don't strand the visitor with a failed send: hand the same draft to
      // their email app.
      await _openInEmailClient(subject, body);
    }
  }

  Future<void> _openInEmailClient(String subject, String body) async {
    final opened = await launchUrl(
      mailtoUri(_kInquiryEmail, subject: subject, body: body),
      mode: LaunchMode.externalApplication,
    );
    if (!opened && mounted) {
      AppToast.show(
        context,
        message: 'Could not open an email app. Copy the draft instead.',
        status: ToastStatus.critical,
        duration: const Duration(seconds: 4),
      );
    }
  }

  Future<void> _copyDraft(ContactInquiryState state) async {
    SoundService.instance.playClick();
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
    final isDesktop = AppBreakpoints.isDesktop(context);

    return BlocBuilder<ContactInquiryBloc, ContactInquiryState>(
      builder: (context, state) {
        final canSend = state.body.trim().isNotEmpty;
        final nameField = _InquiryNameField(controller: _nameController);
        final companyField =
            _InquiryCompanyField(controller: _companyController);

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
                  InquiryDialogHeader(scheme: scheme, isDesktop: isDesktop),
                  const SizedBox(height: AppSpacing.md),
                  InquiryTimezoneBanner(isDark: isDark),
                  const SizedBox(height: AppSpacing.md),
                  InquiryTrackSelector(
                    state: state,
                    scheme: scheme,
                    onTrackChanged: (idx) => _onTrackChanged(idx, state),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  // Contact details inputs — side by side on desktop,
                  // stacked on phones where each was only ~150px wide.
                  if (isDesktop)
                    Row(
                      children: [
                        Expanded(child: nameField),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(child: companyField),
                      ],
                    )
                  else ...[
                    nameField,
                    const SizedBox(height: AppSpacing.md),
                    companyField,
                  ],
                  const SizedBox(height: AppSpacing.md),
                  // Message Body
                  _InquiryBodyField(controller: _bodyController, state: state),
                  const SizedBox(height: AppSpacing.lg),
                  InquiryDialogActions(
                    canSend: canSend,
                    isSending: _isSending,
                    sendsDirectly: EmailService.instance.isConfigured,
                    onCopy: () => _copyDraft(state),
                    onSend: () => _sendEmail(state),
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

class _InquiryNameField extends StatelessWidget {
  final TextEditingController controller;

  const _InquiryNameField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      autofillHints: const [AutofillHints.name],
      textInputAction: TextInputAction.next,
      textCapitalization: TextCapitalization.words,
      onChanged: (val) {
        context.read<ContactInquiryBloc>().add(InquiryNameChanged(val));
      },
      decoration: const InputDecoration(
        labelText: 'Your Name (Optional)',
        border: OutlineInputBorder(),
        isDense: true,
      ),
    );
  }
}

class _InquiryCompanyField extends StatelessWidget {
  final TextEditingController controller;

  const _InquiryCompanyField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      autofillHints: const [AutofillHints.organizationName],
      textInputAction: TextInputAction.next,
      textCapitalization: TextCapitalization.words,
      onChanged: (val) {
        context.read<ContactInquiryBloc>().add(InquiryCompanyChanged(val));
      },
      decoration: const InputDecoration(
        labelText: 'Company / Org (Optional)',
        border: OutlineInputBorder(),
        isDense: true,
      ),
    );
  }
}

class _InquiryBodyField extends StatelessWidget {
  final TextEditingController controller;
  final ContactInquiryState state;

  const _InquiryBodyField({required this.controller, required this.state});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: (val) {
        context.read<ContactInquiryBloc>().add(InquiryBodyChanged(val));
      },
      maxLines: 5,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'Message Body',
        border: const OutlineInputBorder(),
        alignLabelWithHint: true,
        helperText: state.body.trim().isEmpty
            ? 'Write a message to enable sending'
            : null,
      ),
    );
  }
}
