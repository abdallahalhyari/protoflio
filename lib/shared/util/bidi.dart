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

/// [text] always isolated as LTR inside an RTL layout — for phone numbers,
/// URLs and handles, which have no Latin letter for [needsLtrIsolate] to
/// detect ("+962-787…" otherwise renders as "962-787…+").
String ltrAlways(BuildContext context, String text) =>
    Directionality.of(context) == TextDirection.rtl ? '$kLri$text$kPdi' : text;

/// Letter spacing for uppercase label styles. Arabic is a joined script:
/// tracking pulls its letters apart and breaks the joins, so right-to-left
/// text gets none.
double latinTracking(BuildContext context, double spacing) =>
    Directionality.of(context) == TextDirection.rtl ? 0 : spacing;
