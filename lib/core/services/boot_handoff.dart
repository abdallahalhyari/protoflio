import 'package:profile/core/services/boot_handoff_stub.dart'
    if (dart.library.js_interop) 'boot_handoff_web.dart';

/// Tells `web/index.html` the app has painted real content, so its boot
/// screen can dissolve straight into it.
///
/// The boot screen used to leave on Flutter's first frame, which is the
/// bootstrapper's own loading screen: visitors saw the boot screen fade to
/// a near-black frame, then the page. No-op off the web.
void signalAppReady() => announceAppReady();

/// Whether the HTML boot screen is still up, showing its still of the
/// cover (name, sentence, availability, actions). A cover built under it
/// keeps those still instead of playing their entrance: they're already
/// on screen, and replaying them would make the name vanish and slide back
/// in as the boot screen fades. Always false off the web.
bool bootScreenShowsCover() => isBootScreenUp();
