import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../service/analytics_service.dart';
import '../../../../service/sound_service.dart';
import '../../../../theme/tokens.dart';

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

class InquiryComposerDialog extends StatefulWidget {
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
  State<InquiryComposerDialog> createState() => _InquiryComposerDialogState();
}

class _InquiryComposerDialogState extends State<InquiryComposerDialog> {
  static const String _recipientEmail = 'alhyariabdallh@gmail.com';

  static const List<(String, String, String)> _tracks = [
    (
      '💼 Role Opportunity',
      '[Role Opportunity] Senior Mobile Architect - Abdallah Alhyari',
      'Hi Abdallah,\n\nI reviewed your portfolio and would like to discuss a Senior Mobile Architect / Flutter Engineering position at our company.\n\nLooking forward to scheduling an introductory conversation.',
    ),
    (
      '📐 Architecture Audit',
      '[Architecture Review] Mobile Codebase Audit - Abdallah Alhyari',
      'Hi Abdallah,\n\nWe are looking for an expert architectural audit and performance profiling for our enterprise mobile codebase.\n\nPlease let us know your availability for a technical discovery call.',
    ),
    (
      '⚡ Production App',
      '[Project Inquiry] Enterprise Mobile System - Abdallah Alhyari',
      'Hi Abdallah,\n\nWe are planning to build a high-performance cross-platform system requiring offline-first synchronization and robust security.\n\nWe would love to explore an engagement scope.',
    ),
    (
      '☕ Tech Advisory',
      '[Connect] Tech Advisory & Coffee - Abdallah Alhyari',
      'Hi Abdallah,\n\nI’d love to connect for a 20-minute chat regarding mobile engineering, smart-card integrations, and architecture.',
    ),
  ];

  late int _selectedTrack;
  late final TextEditingController _nameController;
  late final TextEditingController _companyController;
  late final TextEditingController _bodyController;

  @override
  void initState() {
    super.initState();
    _selectedTrack = widget.initialTrackIndex.clamp(0, _tracks.length - 1);
    _nameController = TextEditingController();
    _companyController = TextEditingController();
    _bodyController = TextEditingController(text: _tracks[_selectedTrack].$3);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _companyController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  void _onTrackChanged(int index) {
    SoundService.instance.playSelection();
    setState(() {
      _selectedTrack = index;
      _bodyController.text = _tracks[index].$3;
    });
  }

  String _buildFormattedMessage() {
    final name = _nameController.text.trim();
    final company = _companyController.text.trim();
    final customBody = _bodyController.text.trim();

    final buffer = StringBuffer();
    if (name.isNotEmpty || company.isNotEmpty) {
      buffer.writeln('FROM: ${name.isNotEmpty ? name : 'Visitor'}${company.isNotEmpty ? ' ($company)' : ''}');
      buffer.writeln('---');
    }
    buffer.writeln(customBody);
    return buffer.toString();
  }

  Future<void> _launchEmailClient() async {
    SoundService.instance.playClick();
    Analytics.ctaEmail();
    final subject = _tracks[_selectedTrack].$2;
    final body = _buildFormattedMessage();

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

  Future<void> _copyDraft() async {
    SoundService.instance.playClick();
    final body = _buildFormattedMessage();

    if (widget.onCopy != null) {
      widget.onCopy!(body);
      return;
    }

    await Clipboard.setData(ClipboardData(text: body));

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Inquiry draft copied to clipboard!'),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
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

    return Dialog(
      backgroundColor: isDark ? const Color(0xFF0F1422) : Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        side: BorderSide(
          color: scheme.primary.withValues(alpha: 0.35),
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
                    child: Icon(Icons.send_rounded, color: scheme.primary, size: 20),
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
                            color: isDark ? Colors.white : AppColors.slate900,
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
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isDark ? Colors.black.withValues(alpha: 0.3) : AppColors.slate50,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  border: Border.all(
                    color: (isAmmanActive ? AppColors.accentGreen : AppColors.accentAmber)
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
                        color: isAmmanActive ? AppColors.accentGreen : AppColors.accentAmber,
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
                  for (int i = 0; i < _tracks.length; i++)
                    ChoiceChip(
                      label: Text(_tracks[i].$1),
                      selected: _selectedTrack == i,
                      onSelected: (_) => _onTrackChanged(i),
                      selectedColor: scheme.primary.withValues(alpha: 0.2),
                      side: BorderSide(
                        color: _selectedTrack == i
                            ? scheme.primary
                            : (isDark ? Colors.white12 : AppColors.slate200),
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
                    onPressed: _copyDraft,
                    icon: const Icon(Icons.copy_rounded, size: 16),
                    label: const Text('COPY DRAFT'),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  FilledButton.icon(
                    onPressed: _launchEmailClient,
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
  }
}
