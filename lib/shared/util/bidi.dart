import 'package:flutter/widgets.dart';

/// Unicode LEFT-TO-RIGHT ISOLATE / POP DIRECTIONAL ISOLATE.
const String kLri = '\u2066';
const String kPdi = '\u2069';

final RegExp _firstStrongIsLatin =
    RegExp(r'^[^\p{L}]*[A-Za-z\u00C0-\u024F]', unicode: true);

/// True when [text] is Latin-script content shown inside an RTL (Arabic)
/// layout. Portfolio content is English-only, so under `ar` the paragraph
/// direction is RTL and trailing punctuation jumps to the wrong end
/// (".introduced modular architecture"). Isolating the run as LTR keeps the
/// sentence intact while the block keeps its RTL alignment.
bool needsLtrIsolate(BuildContext context, String text) =>
    Directionality.of(context) == TextDirection.rtl &&
    _firstStrongIsLatin.hasMatch(text);

/// [text] wrapped in an LTR isolate when [needsLtrIsolate]; otherwise as-is.
String ltrContent(BuildContext context, String text) =>
    needsLtrIsolate(context, text) ? '$kLri$text$kPdi' : text;
