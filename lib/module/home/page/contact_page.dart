import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../theme/tokens.dart';
import '../../../service/sound_service.dart';
import '../widget/page_background.dart';

class ContactPage extends StatefulWidget {
  final PageController controller;
  final int pageIndex;

  const ContactPage({
    super.key,
    required this.controller,
    required this.pageIndex,
  });

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _msgCtrl = TextEditingController();
  final _cliCmdCtrl = TextEditingController();
  final List<String> _terminalLog = [];
  
  late AnimationController _cursorBlinkController;
  String _consoleStatus = '[STATUS] Direct transmission channel idle. Ready for input.';

  @override
  void initState() {
    super.initState();
    _cursorBlinkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _cursorBlinkController.dispose();
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _msgCtrl.dispose();
    _cliCmdCtrl.dispose();
    super.dispose();
  }

  void _executeCommand(String rawInput) {
    final input = rawInput.trim();
    if (input.isEmpty) return;
    _onKeyPress();
    final cmd = input.toLowerCase();

    setState(() {
      _terminalLog.add('guest@terminal:~\$ $input');
      
      if (cmd == 'help') {
        _terminalLog.add(
          'AVAILABLE COMMANDS:\n'
          '  skills         - Inspect core architectural competencies & mastery\n'
          '  projects       - List high-impact production enterprise mobile releases\n'
          '  cv / resume    - Download Abdallah\'s official Curriculum Vitae (PDF)\n'
          '  sudo hire      - Unlock executive hiring contract & auto-populate transmission\n'
          '  clear          - Flush console log buffer',
        );
        _consoleStatus = '[STATUS] Help manual printed to terminal stdout.';
      } else if (cmd == 'skills') {
        _terminalLog.add(
          '[ARCHITECTURAL MATRIX]\n'
          '• FLUTTER / DART      : 96% (Enterprise MVVM, Custom RenderObjects, 60fps)\n'
          '• ANDROID / KOTLIN    : 92% (Coroutines, Flow, WorkManager, NDK Channels)\n'
          '• NFC / SMART-CARDS   : 95% (APDU ISO-7816, Contactless Readers, Security)\n'
          '• JWT / SECURE AUTH   : 94% (Hardware GUID binding, Biometrics, Keychain)\n'
          '• OFFLINE-FIRST SYNC  : 93% (Background pipelines, SQLite, Conflict resolution)',
        );
        _consoleStatus = '[STATUS] Core competencies loaded to stdout.';
      } else if (cmd == 'projects') {
        _terminalLog.add(
          '[ENTERPRISE RELEASES]\n'
          '1. NATHEALTH          — Smart insurance card, ISO APDU NFC, biometric auth\n'
          '2. ESKADENIA HEALTH   — Offline-first medical records, JWT auth, enterprise sync\n'
          '3. ESKADENIA CARE     — Patient health portal & claims management\n'
          '4. ESKADENIA BROKER   — Multi-tier policy administration & telemetry',
        );
        _consoleStatus = '[STATUS] Enterprise projects catalog printed.';
      } else if (cmd == 'cv' || cmd == 'resume') {
        _terminalLog.add('[SYSTEM] Initiating transmission of cv.pdf...');
        _downloadCv();
      } else if (cmd.contains('hire') || cmd.contains('sudo')) {
        _terminalLog.add(
          '[ROOT PRIVILEGES GRANTED]\n'
          '===========================================================\n'
          '  ★ MATCH DETECTED: SENIOR MOBILE ARCHITECT / LEAD ★\n'
          '  READY FOR MISSION-CRITICAL SYSTEMS & ENTERPRISE PRODUCTS\n'
          '===========================================================\n'
          '[ACTION] Populating transmission buffer with priority greeting...',
        );
        _msgCtrl.text = 'Hello Abdallah, I reviewed your architectural portfolio and would love to discuss a senior engineering role / leadership opportunity with you.';
        _consoleStatus = '[STATUS] Priority hiring template prepared. Enter name & email to transmit!';
      } else if (cmd == 'clear') {
        _terminalLog.clear();
        _consoleStatus = '[STATUS] Terminal screen buffer cleared.';
      } else {
        _terminalLog.add('[ERROR] Command not recognized: "$input". Type "help" for available commands.');
        _consoleStatus = '[STATUS] Command execution error.';
      }
      _cliCmdCtrl.clear();
    });
  }

  int _lastAudioClickMs = 0;

  void _onKeyPress() {
    final now = DateTime.now().millisecondsSinceEpoch;
    if (now - _lastAudioClickMs > 35) {
      _lastAudioClickMs = now;
      SoundService.instance.playClick();
    }
  }

  Future<void> _submitTransmission() async {
    SoundService.instance.playClick();
    if (_formKey.currentState!.validate()) {
      final name = _nameCtrl.text;
      final email = _emailCtrl.text;
      final msg = _msgCtrl.text;

      setState(() {
        _consoleStatus = '[DISPATCH] Encrypting packet and launching mail client...';
      });

      final subject = Uri.encodeComponent('Portfolio Transmission from $name');
      final body = Uri.encodeComponent('Sender: $name <$email>\n\nMessage:\n$msg');
      final url = 'mailto:alhyariabdallh@gmail.com?subject=$subject&body=$body';

      final ok = await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
      if (mounted) {
        setState(() {
          _consoleStatus = ok
              ? '[DISPATCH_SUCCESS] Mail client invoked successfully. [OK]'
              : '[DISPATCH_ERROR] Could not open system mail client. Please copy email directly.';
        });
      }
    }
  }

  Future<void> _copyEmail() async {
    SoundService.instance.playClick();
    await Clipboard.setData(const ClipboardData(text: 'alhyariabdallh@gmail.com'));
    setState(() {
      _consoleStatus = '[CLIPBOARD] "alhyariabdallh@gmail.com" copied to clipboard! [OK]';
    });
  }

  Future<void> _downloadCv() async {
    SoundService.instance.playClick();
    setState(() {
      _consoleStatus = '[DOWNLOAD] Fetching curriculum vitae (cv.pdf)... [OK]';
    });
    await launchUrl(Uri.parse('assets/cv.pdf'), mode: LaunchMode.externalApplication);
  }

  Future<void> _openExternal(String url, String label) async {
    SoundService.instance.playClick();
    setState(() {
      _consoleStatus = '[NAVIGATE] Opening external gateway to $label... [OK]';
    });
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isDesktop = size.width >= 900;

    return PageBackground(
      asset: 'assets/hats_background.webp',
      overlay: AppColors.scrimHeavy,
      controller: widget.controller,
      pageIndex: widget.pageIndex,
      child: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: isDesktop ? AppSpacing.xxl : AppSpacing.md,
            vertical: AppSpacing.lg,
          ),
          child: Container(
            constraints: BoxConstraints(
              maxWidth: (size.width * 0.92).clamp(320.0, 960.0),
            ),
            decoration: BoxDecoration(
              color: const Color(0xFF0C1017), // Deep terminal obsidian
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF38BDF8).withValues(alpha: 0.35), width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.7),
                  blurRadius: 32,
                  spreadRadius: 4,
                ),
                BoxShadow(
                  color: const Color(0xFF38BDF8).withValues(alpha: 0.15),
                  blurRadius: 20,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(11),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // TERMINAL WINDOW HEADER
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: const BoxDecoration(
                      color: Color(0xFF161E2A),
                      border: Border(bottom: BorderSide(color: Color(0xFF243042), width: 1)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // macOS terminal dots
                        Row(
                          children: [
                            Container(width: 12, height: 12, decoration: const BoxDecoration(color: Color(0xFFFF5F56), shape: BoxShape.circle)),
                            const SizedBox(width: 8),
                            Container(width: 12, height: 12, decoration: const BoxDecoration(color: Color(0xFFFFBD2E), shape: BoxShape.circle)),
                            const SizedBox(width: 8),
                            Container(width: 12, height: 12, decoration: const BoxDecoration(color: Color(0xFF27C93F), shape: BoxShape.circle)),
                          ],
                        ),

                        // Terminal title
                        Text(
                          'bash — abdallah@portfolio: ~/direct-dispatch (ssh)',
                          style: TextStyle(
                            fontFamily: 'Courier',
                            color: Colors.white.withValues(alpha: 0.75),
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        // Status dot
                        Row(
                          children: [
                            Container(width: 8, height: 8, decoration: const BoxDecoration(color: Color(0xFF10B981), shape: BoxShape.circle)),
                            const SizedBox(width: 6),
                            const Text('LIVE', style: TextStyle(color: Color(0xFF10B981), fontSize: 10, fontWeight: FontWeight.w800)),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // TERMINAL BODY
                  Padding(
                    padding: EdgeInsets.all(isDesktop ? 24.0 : 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Terminal boot banner
                        const Text(
                          'abdallah@workstation:~\$ ./dispatch.sh --recipient "Abdallah Alhyari"',
                          style: TextStyle(
                            fontFamily: 'Courier',
                            color: Color(0xFF38BDF8),
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '[SYS_INIT] Uplink active · Location: Amman, Jordan · GMT+3\n'
                          '[SYS_INFO] Direct transmission interface initialized.\n'
                          '[SYS_INFO] Enter parameters below to transmit secure communique:',
                          style: TextStyle(
                            fontFamily: 'Courier',
                            color: Colors.white.withValues(alpha: 0.8),
                            fontSize: 12.5,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Container(height: 1, color: Colors.white12),
                        const SizedBox(height: 14),

                        // Interactive CLI Command Shell
                        _buildInteractiveShell(),

                        const SizedBox(height: 8),

                        // Interactive Form Fields with CLI styling
                        Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildCliField(
                                prefix: 'NAME>',
                                hint: 'e.g. John Doe',
                                controller: _nameCtrl,
                                validator: (val) => val == null || val.trim().isEmpty ? 'Identity parameter required' : null,
                              ),
                              const SizedBox(height: 16),
                              _buildCliField(
                                prefix: 'EMAIL>',
                                hint: 'e.g. name@company.com',
                                controller: _emailCtrl,
                                keyboardType: TextInputType.emailAddress,
                                validator: (val) {
                                  if (val == null || val.trim().isEmpty) return 'Return address required';
                                  if (!val.contains('@') || !val.contains('.')) return 'Invalid address format';
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              _buildCliField(
                                prefix: 'PAYLOAD>',
                                hint: 'Type your message or project inquiry here...',
                                controller: _msgCtrl,
                                maxLines: 3,
                                validator: (val) => val == null || val.trim().isEmpty ? 'Payload body required' : null,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 18),

                        // Console Status Bar with Blinking Block Cursor
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: const Color(0xFF06090D),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: Colors.white24),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  _consoleStatus,
                                  style: const TextStyle(
                                    fontFamily: 'Courier',
                                    color: Color(0xFF10B981),
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              AnimatedBuilder(
                                animation: _cursorBlinkController,
                                builder: (context, _) {
                                  return Opacity(
                                    opacity: _cursorBlinkController.value > 0.5 ? 1.0 : 0.0,
                                    child: const Text(
                                      '█',
                                      style: TextStyle(color: Color(0xFF10B981), fontSize: 14),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 18),

                        // QUICK COMMANDS & ACTION BAR
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            ElevatedButton.icon(
                              onPressed: _submitTransmission,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF38BDF8),
                                foregroundColor: Colors.black,
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                              ),
                              icon: const Icon(Icons.send, size: 14),
                              label: const Text(
                                '⏎ TRANSMIT (MAILTO)',
                                style: TextStyle(fontFamily: 'Courier', fontWeight: FontWeight.w900, fontSize: 11.5),
                              ),
                            ),
                            OutlinedButton.icon(
                              onPressed: _copyEmail,
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.white,
                                side: const BorderSide(color: Colors.white24),
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                              ),
                              icon: const Icon(Icons.copy, size: 14, color: Color(0xFFFBBF24)),
                              label: const Text(
                                '> COPY_EMAIL',
                                style: TextStyle(fontFamily: 'Courier', fontSize: 11.5, fontWeight: FontWeight.w700),
                              ),
                            ),
                            OutlinedButton.icon(
                              onPressed: _downloadCv,
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.white,
                                side: const BorderSide(color: Colors.white24),
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                              ),
                              icon: const Icon(Icons.description, size: 14, color: Color(0xFF38BDF8)),
                              label: const Text(
                                '> GET_CV.PDF',
                                style: TextStyle(fontFamily: 'Courier', fontSize: 11.5, fontWeight: FontWeight.w700),
                              ),
                            ),
                            OutlinedButton.icon(
                              onPressed: () => _openExternal('https://www.linkedin.com/in/abdallah-alhyari-0294791a0/', 'LinkedIn'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.white70,
                                side: const BorderSide(color: Colors.white12),
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                              ),
                              icon: const Icon(Icons.link, size: 14),
                              label: const Text(
                                '> LINKEDIN',
                                style: TextStyle(fontFamily: 'Courier', fontSize: 11.5),
                              ),
                            ),
                            OutlinedButton.icon(
                              onPressed: () => _openExternal('https://github.com/abdallahalhyari', 'GitHub'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.white70,
                                side: const BorderSide(color: Colors.white12),
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                              ),
                              icon: const Icon(Icons.code, size: 14),
                              label: const Text(
                                '> GITHUB',
                                style: TextStyle(fontFamily: 'Courier', fontSize: 11.5),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 18),
                        Container(height: 1, color: Colors.white12),
                        const SizedBox(height: 12),

                        // Letterpress Footnote
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'PRINTED AT CENTRAL DESPATCH · AMMAN, JORDAN',
                              style: TextStyle(
                                fontFamily: 'Courier',
                                color: Colors.white.withValues(alpha: 0.4),
                                fontSize: 9.5,
                                letterSpacing: 1.5,
                              ),
                            ),
                            Text(
                              'ALL RIGHTS RESERVED © 2026',
                              style: TextStyle(
                                fontFamily: 'Courier',
                                color: Colors.white.withValues(alpha: 0.4),
                                fontSize: 9.5,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCliField({
    required String prefix,
    required String hint,
    required TextEditingController controller,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 12, right: 12),
          child: Text(
            prefix,
            style: const TextStyle(
              fontFamily: 'Courier',
              color: Color(0xFFFBBF24),
              fontSize: 14.0,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        Expanded(
          child: TextFormField(
            controller: controller,
            maxLines: maxLines,
            keyboardType: keyboardType,
            validator: validator,
            onChanged: (_) => _onKeyPress(),
            style: const TextStyle(
              fontFamily: 'Courier',
              color: Colors.white,
              fontSize: 14.5,
              height: 1.5,
            ),
            cursorColor: const Color(0xFF10B981),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                fontFamily: 'Courier',
                color: Colors.white.withValues(alpha: 0.45),
                fontSize: 13.5,
              ),
              filled: true,
              fillColor: const Color(0xFF111722),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(color: Colors.white24),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(color: Color(0xFF38BDF8), width: 1.5),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(color: Colors.redAccent),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(color: Colors.redAccent),
              ),
              errorStyle: const TextStyle(fontFamily: 'Courier', fontSize: 11, color: Colors.redAccent),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInteractiveShell() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Suggestions row
        Wrap(
          spacing: 6,
          runSpacing: 6,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            const Text(
              'CLI COMMANDS:',
              style: TextStyle(
                fontFamily: 'Courier',
                color: Colors.white54,
                fontSize: 10.5,
                fontWeight: FontWeight.w700,
                letterSpacing: 1,
              ),
            ),
            _buildCmdChip('help'),
            _buildCmdChip('skills'),
            _buildCmdChip('projects'),
            _buildCmdChip('sudo hire'),
            if (_terminalLog.isNotEmpty) _buildCmdChip('clear'),
          ],
        ),
        const SizedBox(height: 10),
        // Command prompt field
        Row(
          children: [
            const Text(
              'CMD> ',
              style: TextStyle(
                fontFamily: 'Courier',
                color: Color(0xFF10B981),
                fontSize: 13.5,
                fontWeight: FontWeight.w900,
              ),
            ),
            Expanded(
              child: TextField(
                controller: _cliCmdCtrl,
                onChanged: (_) => _onKeyPress(),
                onSubmitted: _executeCommand,
                style: const TextStyle(
                  fontFamily: 'Courier',
                  color: Color(0xFF10B981),
                  fontSize: 13.0,
                ),
                decoration: InputDecoration(
                  hintText: 'Type "help", "skills", "sudo hire" and press Enter ⏎',
                  hintStyle: TextStyle(
                    fontFamily: 'Courier',
                    color: Colors.white.withValues(alpha: 0.35),
                    fontSize: 12.0,
                  ),
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  filled: true,
                  fillColor: const Color(0xFF0A0F17),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: const BorderSide(color: Colors.white24),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: const BorderSide(color: Color(0xFF10B981), width: 1.5),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              tooltip: 'Execute command',
              icon: const Icon(Icons.keyboard_return, color: Color(0xFF10B981), size: 18),
              onPressed: () => _executeCommand(_cliCmdCtrl.text),
            ),
          ],
        ),
        if (_terminalLog.isNotEmpty) ...[
          const SizedBox(height: 10),
          Container(
            constraints: const BoxConstraints(maxHeight: 180),
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF080B10),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.4)),
            ),
            child: SingleChildScrollView(
              reverse: true,
              child: Text(
                _terminalLog.join('\n'),
                style: const TextStyle(
                  fontFamily: 'Courier',
                  color: Color(0xFF34D399),
                  fontSize: 11.5,
                  height: 1.45,
                ),
              ),
            ),
          ),
        ],
        const SizedBox(height: 12),
        Container(height: 1, color: Colors.white12),
      ],
    );
  }

  Widget _buildCmdChip(String cmd) {
    return InkWell(
      onTap: () => _executeCommand(cmd),
      borderRadius: BorderRadius.circular(3),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: const Color(0xFF10B981).withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(3),
          border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.4)),
        ),
        child: Text(
          '> $cmd',
          style: const TextStyle(
            fontFamily: 'Courier',
            color: Color(0xFF34D399),
            fontSize: 10.5,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
