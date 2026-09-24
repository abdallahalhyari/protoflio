/// Builds a `mailto:` URI whose query is percent-encoded per RFC 6068.
///
/// `Uri(queryParameters: ...)` form-encodes spaces as `+`, which mail
/// clients (Gmail, Apple Mail, Outlook) show literally — "Senior+Role".
Uri mailtoUri(String address, {String? subject, String? body}) {
  final params = <String, String>{
    if (subject != null && subject.isNotEmpty) 'subject': subject,
    if (body != null && body.isNotEmpty) 'body': body,
  };
  return Uri(
    scheme: 'mailto',
    path: address,
    query: params.isEmpty
        ? null
        : params.entries
            .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
            .join('&'),
  );
}
