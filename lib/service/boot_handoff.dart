import 'package:profile/service/boot_handoff_stub.dart'
    if (dart.library.js_interop) 'boot_handoff_web.dart';

/// Tells `web/index.html` the app has painted real content, so its boot
/// screen can dissolve straight into it.
///
/// The boot screen used to leave on Flutter's first frame, which is the
/// bootstrapper's own loading screen: visitors saw the boot screen fade to
/// a near-black frame, then the page. No-op off the web.
void signalAppReady() => announceAppReady();
