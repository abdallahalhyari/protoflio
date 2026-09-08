import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:profile/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../theme/tokens.dart';
import '../widget/page_background.dart';
import '../widget/primary_button.dart';

class ContactPage extends StatefulWidget {
  final PageController controller;
  final int pageIndex;
  
  const ContactPage({super.key, 
    required this.controller,
    required this.pageIndex,
  });

  @override
  State<ContactPage> createState() => ContactPageState();
}

class ContactPageState extends State<ContactPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _msgCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _msgCtrl.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final name = _nameCtrl.text;
      final email = _emailCtrl.text;
      final msg = _msgCtrl.text;
      
      final subject = Uri.encodeComponent('Portfolio Contact from $name');
      final body = Uri.encodeComponent('Name: $name\nEmail: $email\n\n$msg');
      final url = 'mailto:alhyariabdallh@gmail.com?subject=$subject&body=$body';
      
      final uri = Uri.parse(url);
      final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!ok && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open email client')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final headingSize =
        (size.width * 0.055).clamp(AppTypography.heading, AppTypography.hero);
    final isMobile = size.width < 800;

    return PageBackground(
      asset: 'assets/hats_background.webp',
      overlay: AppColors.scrimHeavy,
      controller: widget.controller,
      pageIndex: widget.pageIndex,
      child: Center(
        child: Container(
          constraints: BoxConstraints(
            maxWidth: size.width / (isMobile ? 1.05 : 1.3),
            maxHeight: size.height * 0.9,
          ),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.black26, Colors.black38, Colors.black54],
            ),
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: Colors.white24),
          ),
          padding: EdgeInsets.all(isMobile ? AppSpacing.md : AppSpacing.xl),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  AppLocalizations.of(context)!.contactTitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: headingSize,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  AppLocalizations.of(context)!.contactSubtitle,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: AppTypography.titleSm,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _nameCtrl,
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                        style: const TextStyle(color: Colors.white),
                        decoration: _inputDeco(AppLocalizations.of(context)!.contactNameLabel),
                        validator: (v) => v!.isEmpty ? '*' : null,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      TextFormField(
                        controller: _emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        style: const TextStyle(color: Colors.white),
                        decoration: _inputDeco(AppLocalizations.of(context)!.contactEmailLabel),
                        validator: (v) => (v!.isEmpty || !v.contains('@')) ? '*' : null,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      TextFormField(
                        controller: _msgCtrl,
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.newline,
                        maxLines: 5,
                        style: const TextStyle(color: Colors.white),
                        decoration: _inputDeco(AppLocalizations.of(context)!.contactMessageLabel),
                        validator: (v) => v!.isEmpty ? '*' : null,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      SizedBox(
                        width: double.infinity,
                        child: PrimaryButton(
                          label: AppLocalizations.of(context)!.contactSendBtn,
                          onPressed: _submitForm,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SocialBtn(icon: Icons.email, url: 'mailto:alhyariabdallh@gmail.com'),
                    const SizedBox(width: AppSpacing.md),
                    SocialBtn(icon: Icons.phone, url: 'tel:+962787032264'),
                    const SizedBox(width: AppSpacing.md),
                    SocialBtn(icon: Icons.work, url: 'https://www.linkedin.com/in/abdallah-alhyari-95b915201/'),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                Semantics(
                  button: true,
                  child: TextButton.icon(
                    onPressed: () async => await launchUrl(Uri.parse('cv.pdf')),
                    icon: const Icon(Icons.download, color: Colors.white),
                    label: Text(AppLocalizations.of(context)!.contactDownloadCvBtn, style: const TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDeco(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.white24),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.white),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.redAccent),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.redAccent),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      filled: true,
      fillColor: Colors.black45,
    );
  }
}

class SocialBtn extends StatefulWidget {
  final IconData icon;
  final String url;
  const SocialBtn({super.key, required this.icon, required this.url});

  @override
  State<SocialBtn> createState() => SocialBtnState();
}

class SocialBtnState extends State<SocialBtn> {
  bool _hover = false;
  
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();
          launchUrl(Uri.parse(widget.url), mode: LaunchMode.externalApplication);
        },
        child: AnimatedContainer(
          duration: AppMotion.sm,
          padding: const EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _hover ? Theme.of(context).colorScheme.primary : Colors.white12,
          ),
          child: Icon(widget.icon, color: Colors.white, size: 24),
        ),
      ),
    );
  }
}

